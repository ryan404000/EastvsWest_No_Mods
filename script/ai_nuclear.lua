-----------------------------------------------------------
-- LUA East vs. West Economy AI minister
-- Created By: Biga
-- Modified By: Biga
-- Date Last Modified: 19/09/2012
-----------------------------------------------------------
require('utils')

-- helper methods for nuclear AI

function compare(a,b)
  return a[1] > b[1]
end

-- calling by BuildNuclear or console command for creating silo OOB
function BuildNuclearAgainst(ai, ministerTag, money, enemyTag, numbers)

	--Utils.LUA_DEBUGOUT("Nuclear AI called for: " .. tostring(ministerTag) .. " against " .. tostring(enemyTag))
	
	local Country = ministerTag:GetCountry()
	local enemy = enemyTag:GetCountry()
  
	local ourforces = Country:GetNuclearForces()
	local theirforces = enemy:GetNuclearForces()
	local theircapital = enemy:GetActingCapitalLocation():GetProvinceID()
	
	local startup = false
  
	-- calc numbers if not given: their silos - our silos able to reach them
	if numbers == 0 then
		numbers =  theirforces:GetSilos() - ourforces:GetSilosReach(enemyTag)
	else
		startup = true
	end
  
	if numbers <= 0 then
		return
	end
	
	local loTechStatus = Country:GetTechnologyStatus()
	local icbm = CSubUnitDataBase.GetSubUnit("icbm_complex")
	local silo = CEconomyBuildingDataBase.GetBuilding( "nuclear_silo" )
	
	-- check building and silo is available
	--if loTechStatus:IsBuildingAvailable(silo) == false or
	--	loTechStatus:IsUnitAvailable(icbm) == false
	--then
	--	Utils.LUA_DEBUGOUT("Nuclear AI: silo/icbm not available")
	--	return
	--end
	
	local range = ourforces:GetBestICBMRange():Get()
	local buildtable = { }
	local needed = numbers
	local regiontable = { }
	
	
	--Utils.LUA_DEBUGOUT("Nuclear AI: needed: " .. tostring(numbers) .. " range: " .. tostring(range))
	--Utils.LUA_DEBUGOUT("Nuclear AI: template: " .. tostring(silo:GetName()))
	
	-- creating array for nearest province
	-- we check missile range
	-- try to build to nearest to enemy
	-- exclude islands and prioritize coasts
	-- no more than 2 silos in one region
	-- no more than 6 special buildings in region
	
	for provinceId in Country:GetCoreProvinces() do
		local province = CCurrentGameState.GetProvince(provinceId)
		local region = province:GetRegion()
		local rindex = region:GetID()
		if not province:HasSpecialBuilding() and not province:IsIsland() and region:GetNumOfSpecBuildings( ministerTag ) <= 6 then
			local distance = province:GetDistance(theircapital)
			if distance <= range then
				local weight = 1 / (distance + 1)
				if province:IsCoastal() then
					weight = weight / 1.5
				end
				table.insert( buildtable, { weight, provinceId })
				regiontable[rindex] = region:GetNumOfEcoBuildings( silo:GetIndex(),ministerTag )
			end
		end
	end
	
	if table.getn(buildtable) == 0 then
	  return money
	end
	
	table.sort(buildtable, compare)
	local price = silo:GetInitialMoneyCost():Get()
	
	for i = 1, table.getn(buildtable) do
		if needed <= 0 then
			break
		end
		if money < price and not startup then
			break
		end
        
        local provinceId = buildtable[i][2]
		local province = CCurrentGameState.GetProvince(provinceId)
		local region = province:GetRegion()
		local rindex = region:GetID()
		local weight = buildtable[i][1]
		
		if weight <= 0 then
		  weight = 1
		end
		
		--Utils.LUA_DEBUGOUT("Nuclear AI: silo building to " .. tostring(provinceId) .. " " .. tostring(1/weight))
		if regiontable[rindex] < 3 then
			local constructCommand = CConstructEconomyBuildingCommand(ministerTag, silo, provinceId, 1, true )
			if constructCommand:IsValid() then
				if not startup then
					money = money - price
					ai:Post( constructCommand )
					--Utils.LUA_DEBUGOUT("  built by AI")
				else
					constructCommand:SetFinished()
					Country:SessionPost(constructCommand)
					--Utils.LUA_DEBUGOUT("  silo built for OOB")
				end
			end
			needed = needed - 1
			regiontable[rindex] = regiontable[rindex] + 1
        end
	end
  
	return money
end
