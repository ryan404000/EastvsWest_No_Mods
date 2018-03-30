-----------------------------------------------------------
-- LUA East vs. West Economy AI minister
-- Created By: Biga
-- Modified By: Biga
-- Date Last Modified: 19/09/2012
-----------------------------------------------------------
require('utils')

local INFRA_UPGRADE = 1
local FACTORY_BUILD = 2
local SPECIAL_BUILD = 3

local SLIDER_AUTOMATION_MANUAL = 0
local SLIDER_AUTOMATION_MILITARY_BUILDUP = 1
local SLIDER_AUTOMATION_MILITARY_MAINTAIN = 2
local SLIDER_AUTOMATION_INFRASTRUCTURE = 3
local SLIDER_AUTOMATION_RESEARCH = 4
local SLIDER_AUTOMATION_COUNT = 5

local	DEFCON_5 = 0
local	DEFCON_4 = 1
local	DEFCON_3 = 2
local	DEFCON_2 = 3
local	DEFCON_1 = 4

function EconomyMinister_Monthly(minister, vMoney)
  local mCountry = minister:GetCountry()
 
end  

function GetBestPriority(minister, vMoney)
  local Prio = 0
  
  local mCountry = minister:GetCountry()
  local Defcon = mCountry:GetDefconLevel()
  local War = mCountry:IsAtWar()
  local Clock = CAI.GetDoomsDayClockMinutes()
  local Factory = mCountry:GetFactoryRateInGDP()
 
  if Defcon == 1 or Defcon == 2 then
     Prio = SLIDER_AUTOMATION_MILITARY_BUILDUP
  end
  if War or Defcon > 2 then
    Prio = SLIDER_AUTOMATION_MILITARY_MAINTAIN
  end


--[luainterface.cpp:110]: 
--LUA Error: script\ai_economy_minister.lua:47: attempt to compare userdata with number - no script source to reload 
-- Got above Lua error for this below..
--  if Prio > 0 and Factory < 0.5 then
--    Prio = SLIDER_AUTOMATION_MILITARY_INFRASTRUCTURE
--  end

  return Prio  
   
end

-- special buildings construction
function SpecialBuildingConstruct(minister, vMoney)
	local Country = minister:GetCountry()
	local War = Country:IsAtWar()
	local Personality = Country:GetStrategy():GetPersonality()
	local ministerTag = minister:GetCountryTag()
	local money = vMoney:Get()
	local ai = minister:GetOwnerAI()
	
	--Utils.LUA_DEBUGOUT("*AI spec buildings " .. tostring(ministerTag) .. " money: " .. tostring(money))

	
	-- building tag|max buildings per country
	local specials = {
		'military_academy|0',
		'university|0',
		'financial_district|0',
		'strategical_storage|0',
		'intelligence_center|0',
		'spaceport|1',
		'national_monument|1',
		'rocket_test_site|0',
		'industry_research_center|2'
		}
		
	local allowed = { }

	-- create list of allowed buildings
	for i = 1, table.getn(specials) do
	
		local bname =  string.sub(specials[i], 0, string.len(specials[i]) - 2)
		local maxspec = tonumber(string.sub(specials[i], string.len(specials[i])))
					
		local building = CEconomyBuildingDataBase.GetBuilding( bname )
	  
	  	if 	CEconomyBuildingDataBase.CanAfford(building, ministerTag, money) and 
			(Country:GetNumOfEcoBuildings(building:GetIndex()) < maxspec or maxspec == 0) and
			Country:GetNumOfEcoBuildingsUnderConstruction(building:GetIndex()) == 0 
		then
			table.insert( allowed, bname )
			--Utils.LUA_DEBUGOUT("  allowed: " .. bname)
		end
	end
	
	-- nothing can be built atm
	if table.getn(allowed) == 0 then
		return
	end
	
	local goals = false
	local industry_research = false
	local naval_research = false
	
	-- research check for research centers
	-- if goals active, check its folders
	
	--Utils.LUA_DEBUGOUT(" research check: ")
	
	if Country:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_RESEARCH_):GetNeeded():Get() > 0 then
	
		for tech in Country:GetCurrentGoals() do
			local techFolder = tostring(tech:GetFolder():GetKey())
			--Utils.LUA_DEBUGOUT(" goal folder: " .. techFolder)
			if techFolder == 'industrial_tech1_folder' then 
				industry_research = true
			end
			if techFolder == 'naval_tech1_folder' or techFolder == 'naval_tech2_folder' or techFolder == 'naval_tech3_folder' then 
				naval_research = true
			end
			goals = true
		end
		
		-- if no goals, check research ratios
		if goals == false then
			local nIndTechs = 0
			local nNavalTechs = 0
			local nTotalTechs = 0
			for tech in Country:GetCurrentResearch() do
				local techFolder = tostring(tech:GetFolder():GetKey())
				
				--Utils.LUA_DEBUGOUT(" tech folder: " .. techFolder)

				if techFolder == 'industrial_tech1_folder' then
					nIndTechs = nIndTechs + 1
				end
				if techFolder == 'naval_tech1_folder' or techFolder == 'naval_tech2_folder' or techFolder == 'naval_tech3_folder' then
					nNavalTechs = nNavalTechs + 1
				end
				
			end
			
			nTotalTechs = nIndTechs + nNavalTechs
			
			if nTotalTechs > 0 then
				if nIndTechs / nTotalTechs > 0.3 then
					industry_research = true
				end
				if nNavalTechs / nTotalTechs > 0.4 then
					naval_research = true
				end
			end
			
			--Utils.LUA_DEBUGOUT('   ' .. tostring(nIndTechs) .. ' ' .. tostring(nNavalTechs) .. ' ' .. tostring(nTotalTechs))
			--Utils.LUA_DEBUGOUT('   ' .. tostring(industry_research) .. ' ' .. tostring(naval_research) )
			
		end
	end
	
	
	--Utils.LUA_DEBUGOUT(" build phase.")
	
	local built = false
	for i = 1, table.getn(allowed) do
		
		local current = CEconomyBuildingDataBase.GetBuilding( allowed[i] )
		
		--Utils.LUA_DEBUGOUT('  checking ' .. allowed[i])

		-- Build military academy if wartime or military focus and military production running
		if allowed[i] == 'military_academy' and (War or (Personality ~= CAIStrategy._AI_INDUSTRIALIST_ and 
            Country:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_PRODUCTION_):GetNeeded():Get() > 0 ) )
		then
			--Utils.LUA_DEBUGOUT("  build: " .. allowed[i])
			money = BuildSpecial(ai,ministerTag, current, money)	
			built = true
		end
		
		-- Build strategic storage if stores are 80% full and balance is positive
		if allowed[i] == 'strategic_storage' and not War and (
			(Country:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get() > 0 and
			Country:GetMaxStockpile(CGoodsPool._SUPPLIES_) / Country:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get() > 0.8 and
			Country:GetDailyBalance( CGoodsPool._SUPPLIES_ ):Get() > 1.0 ) or
			(Country:GetPool():Get( CGoodsPool._FUEL_ ):Get() > 0 and
			Country:GetMaxStockpile(CGoodsPool._FUEL_) / Country:GetPool():Get( CGoodsPool._FUEL_ ):Get() > 0.8 and
			Country:GetDailyBalance( CGoodsPool._FUEL_ ):Get() > 1.0 ) )
		then
			--Utils.LUA_DEBUGOUT("  build: " .. allowed[i])
			money = BuildSpecial(ai,ministerTag, current, money)	
			built = true
		end
		
		-- Build monument if money is enough (shouldnt in the list if already max number achieved)
		if allowed[i] == 'national_monument' then
			--Utils.LUA_DEBUGOUT("  build: " .. allowed[i])
			money = BuildSpecial(ai,ministerTag, current, money)	
			built = true
		end
		
		-- Build intelligence center if there is high spy priority setting
		if allowed[i] == 'intelligence_center' and Country:IsHighSpyActivity() then
			local score = math.random(100)
			--Utils.LUA_DEBUGOUT("  intel score: " .. tostring(score))
			local build = false
			if War and score < 80 then
				build = true
			elseif score < 90 then
				build = true
			end
			if build then
				--Utils.LUA_DEBUGOUT("  build: " .. allowed[i])
				money = BuildSpecial(ai,ministerTag, current, money)	
				built = true
			end
		end
		
		-- Build if not war and service sector is at least 40%
		if allowed[i] == 'financial_district' and not War and Personality ~= CAIStrategy._AI_MILITARIST_ and
			Country:GetServicesRateInGDP():Get() >= 0.3 
		then
			--Utils.LUA_DEBUGOUT("  build: " .. allowed[i])
			money = BuildSpecial(ai,ministerTag, current, money)	
			built = true
		end
		
		-- Build industry research center if industrial research in progress
		if allowed[i] == 'industry_research_center' and not War and Personality ~= CAIStrategy._AI_MILITARIST_ and industry_research
		then
			--Utils.LUA_DEBUGOUT("  build: " .. allowed[i])
			money = BuildSpecial(ai,ministerTag, current, money)	
			built = true
		end
		
		-- Build naval research center if naval research in progress
		if allowed[i] == 'naval_research_center' and not War and Personality ~= CAIStrategy._AI_MILITARIST_ and naval_research
		then
			--Utils.LUA_DEBUGOUT("  build: " .. allowed[i])
			money = BuildSpecial(ai,ministerTag, current, money)	
			built = true
		end
		
	end
	
	if not built then
		--Utils.LUA_DEBUGOUT('  nothing built for ' .. tostring(ministerTag))
	end
	

end

function BuildSpecial(ai,ministerTag, building, money)
	
	local Country = ministerTag:GetCountry()
	
	if not CEconomyBuildingDataBase.CanAfford(building, ministerTag, money) then
		return money
	end
	
	local towhere = 0
	local maxweight = 0
	local capital = Country:GetActingCapitalLocation():GetProvinceID()

	
	-- where to build, try to near to protected areas (likely near to capital)
	for provinceId in Country:GetCoreProvinces() do
		local province = CCurrentGameState.GetProvince(provinceId)
		local weight = province:GetDistanceWeight(capital):Get() 
		
		if not province:HasSpecialBuilding() then
			-- near to HQs
			if building:GetTag() == 'military_academy' and province:IsHQPresent() then
				weight = weight + 1
			end
			
			-- primarly to capital
			if building:GetTag() == 'national_monument' and provinceId == capital then
				weight = weight + 1
			end
			
			if weight > maxweight then
				maxweight = weight
				towhere = provinceId
			end
		
		end
		
		
	end

   	if towhere > 0 then
        local constructCommand = CConstructEconomyBuildingCommand(ministerTag, building, towhere, 1, true )
	
	    if constructCommand:IsValid() then
		    ai:Post( constructCommand )
		    money = money - building:GetInitialMoneyCost():Get()
	    end
	end
	
	return money
	
end

-- main method calling by exe
function BuildNuclear(ai, ministerTag, money)
	local Country = ministerTag:GetCountry()
	local countrytable = { }
	local silo = CEconomyBuildingDataBase.GetBuilding( "nuclear_silo" )
	
	-- no more than 2 silo build by AI for one time
	if Country:GetNumOfEcoBuildingsUnderConstruction(silo:GetIndex()) > 2 then
		return
	end
	
	for loTargetCountry in CCurrentGameState.GetCountries() do
		local relation = Country:GetRelation(loTargetCountry:GetCountryTag())
		
		if loTargetCountry:GetFaction() ~= Country:GetFaction() and relation:HasAlliance() == false then
			local nuclearforces = loTargetCountry:GetNuclearForces()
			if nuclearforces:GetSilos() > 0 then
				table.insert(countrytable, { nuclearforces:GetSilos(), loTargetCountry:GetCountryTag() } )
			end
		end
	end
	
	table.sort(countrytable, comparedec)
	
	for i = 1, table.getn(countrytable) do
		local countrytag = countrytable[1]
		BuildNuclearAgainst(ai,ministerTag, money, countrytag, 0)
	end
	

end
