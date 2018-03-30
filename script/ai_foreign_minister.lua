-- ###############################################
-- ## "Otto" -East vs. West- Lua Foreign Minister File
-- ## Created By: Chromos	Date: 06.06.2013
-- ## Modified By: Chromos	Date: 03.03.2014
-- ###############################################
--[[
]]
--Utils.LUA_DEBUGOUT("Diplo - 1 - " .. tostring(ActTag) .. " CountrySizeChk: " .. tostring(CountrySizeChk) )

require('ai_diplomacy')

-- ##############################
-- Methods Called by the EXE


--Main function
function ForeignMinister_Tick(minister)
	-- run any decisions available
	--calls "ForeignMinister_EvaluateDecision" from within exe..
	minister:ExecuteDiploDecisions()



-- ## Start Data Setup
-- #############################
	local minister = minister
	local ActTag = minister:GetCountryTag()
	local ActTagTbl = tostring(minister:GetCountryTag())
	local ActDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local GetRandom = math.random
	local RandNr = GetRandom(30)
--local ministerCountry = minister:GetCountry()
--Utils.LUA_DEBUGOUT("ministerCountry -: " .. tostring(ActTagTbl) .. " -ministerCountry  : " .. tostring(ministerCountry))
--Utils.LUA_DEBUGOUT("Check before Loop-ActTagTbl -: " .. tostring(ActTagTbl) .. " -ActTag  : " .. tostring(ActTag))
--speed changer for now
--if RandNr > 15 then

-- ## Start Check for Data Tables
-- #############################
	-- Country Data Setup
	local CountryTable = Grand_Country_Table["Country-" .. ActTagTbl]			-- Just a shorter name for the long table name for better readability
	if (CountryTable == nil ) then
		CountrySetup(ActTag)
	elseif (CountryTable.Timestamp) < (AllDays) then
		CountrySetup(ActTag)
	end
	Grand_Country_Table["Country-" .. ActTagTbl].Minister = minister
	local ActAI = minister:GetOwnerAI()
	Grand_Country_Table["Country-" .. ActTagTbl].ActAI = ActAI
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
--Utils.LUA_DEBUGOUT("Check before Loop-ActTagTbl -: " .. tostring(ActTagTbl) .. " -ActCountry  : " .. tostring(ActCountry))
	-- Nation Data Setup
	local NationTable = Grand_Nation_Table["ActNation-" .. ActTagTbl]			-- Just a shorter name for the long table name for better readability
	if (Grand_Nation_Table["ActNation-" .. ActTagTbl] == nil ) then
		NationSetup(ActTagTbl)
	elseif (Grand_Nation_Table["ActNation-" .. ActTagTbl].Timestamp.Day) < (AllDays) then
		NationSetup(ActTagTbl)
	end
	-- Policies Data Setup
	local PoliciesTable = Grand_Policies_Table["ActPolicies-" .. ActTagTbl]		-- Just a shorter name for the long table name for better readability
	if (Grand_Policies_Table["ActPolicies-" .. ActTagTbl] == nil ) then
		PoliciesSetup(ActTagTbl)
	elseif (Grand_Policies_Table["ActPolicies-" .. ActTagTbl].Timestamp.Day) < (AllDays) then
		PoliciesSetup(ActTagTbl)
	end
	-- Units Data Setup
	local UnitsTable = Grand_Units_Table["LandUnits-" .. ActTagTbl]				-- Just a shorter name for the long table name for better readability
	if (UnitsTable == nil ) then
		UnitsSetup(ActTagTbl)
	elseif (UnitsTable.Timestamp.Day + RandNr) < (AllDays) then
		UnitsSetup(ActTagTbl)
	end
	--Diplomacy Data Setup
	local DiploTable = Grand_Diplomacy_Table["RelationTable-" .. ActTagTbl]				-- Just a shorter name for the long table name for better readability
	if (DiploTable == nil ) then
		DiplomacySetup(ActTagTbl)
	elseif (DiploTable.Timestamp.Day + RandNr) < (AllDays) then
		DiplomacySetup(ActTagTbl)
	end

-- #############################
-- ## End Check for Data Tables


	local ActDissent = Grand_Country_Table["Country-" .. ActTagTbl].ActDissent
	local ActNU = Grand_Country_Table["Country-" .. ActTagTbl].ActNU
	local ActGDP = Grand_Country_Table["Country-" .. ActTagTbl].ActGDP
	local GDPSizeChk = Grand_Country_Table["Country-" .. ActTagTbl].GDPSizeChk

	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId
	local MobilizingNeededManpower = Grand_Country_Table["Country-" .. ActTagTbl].MobilizingNeededManpower
	local TotalAvailableManpower = Grand_Country_Table["Country-" .. ActTagTbl].TotalAvailableManpower
	local TechStatus = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus
	local SeaAvail = Grand_Country_Table["Country-" .. ActTagTbl].SeaAvail 			-- and money < 100)
	local AirAvail = Grand_Country_Table["Country-" .. ActTagTbl].AirAvail 			-- and money < 100)
	local War = Grand_Country_Table["Country-" .. ActTagTbl].War
	local ActStrategy = Grand_Country_Table["Country-" .. ActTagTbl].ActStrategy
	local Warscore = Grand_Country_Table["Country-" .. ActTagTbl].Warscore
	local OurSurrenderLevel = Grand_Country_Table["Country-" .. ActTagTbl].OurSurrenderLevel
	local OurDesperation = Grand_Country_Table["Country-" .. ActTagTbl].ActDesperation
	local FactionName = Grand_Country_Table["Country-" .. ActTagTbl].FactionName
	local Neutrality = Grand_Country_Table["Country-" .. ActTagTbl].Neutrality
	local EffectiveNeutrality = Grand_Country_Table["Country-" .. ActTagTbl].EffectiveNeutrality
	local HighestThreat = Grand_Country_Table["Country-" .. ActTagTbl].HighestThreat
	local Defcon = Grand_Country_Table["Country-" .. ActTagTbl].Defcon
	local Clock = Grand_Country_Table["Country-" .. ActTagTbl].Clock

	local GetRandom = math.random
	local tabin = table.insert
	local rounddown = math.floor

-- #############################
-- ## End Data Setup

local DiploPoints = Grand_Country_Table["Country-" .. ActTagTbl].DiploPoints


--if k ~= ("Timestamp") then				-- Dont check the values in the Timesptamp section, just countries please..
-- Setup "Diplo Rucksack"
-- Check "diplostatus" ( neighbours / threat / faction / alliance / ..)
-- Check "trade needs" ( technology / licences / ressources

-- 0. min. diplopoints at hand?
-- 1. At war? ->peace?
-- 2. war/more war?
-- 3. influence ctry?
-- 4. trade?

	-- main loop
	--if (DiploPoints > 3) and (War) then																-- 1. peace?
	if (War) then
--Utils.LUA_DEBUGOUT("-if WAR-: " .. tostring(ActTag) .. "-Warcheck-: " .. tostring(War) )
		-- We loose or are desperate that we will loose
		--if (OurSurrenderLevel > 33) or (OurDesperation > 0.2) then
			WarStatus(ActTagTbl)
			ForeignMinister_Peace(ActTagTbl)
		--end
	-- We are not at war anymore, so reset the counters
	else
		local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]
		if WarTable ~= nil then
		--WarTable = nil
			local WarStat = WarTable.OverallWarStat
			PeaceWanted(ActTagTbl)
			WarStat.WarStart = nil
			WarStat.WarEnd = AllDays
			WarStat.WarCounter = 0
			WarStat.PeaceWanted = 0
			WarStat.PeaceWantedTag = nil
			WarStat.WarProgress = 0
			WarStat.OurStrength = 0
			WarStat.AllyStrength = 0
			WarStat.EnemyStrength = 0
			WarStat.SurrenderLevel = nil
			WarStat.PeaceTermTotalValue = nil
			WarStat.Strategy = nil
			WarStat.Desperation = nil
			WarStat.ControlledProvincesOld = 0
			WarStat.Trend = 1
			WarStat.Factor = 0
			WarStat.FactorOld = 0
			WarStat.Winning = nil
			WarStat.Loosing = nil
			WarStat.Static = nil
			WarStat.FullWinning = 0
			WarStat.FullLoosing = 0
			WarStat.FullStatic = 0
			WarStat.StaticWarDays = 0
			WarStat.WinningWarDays = 0
			WarStat.LoosingWarDays = 0
			WarStat.AllWarDays = 0
			WarStat.LowestWarscore = 0
			WarStat.LowestWarscoreTag = 0
			WarStat.MaxWarscore = 0
			WarStat.MaxWarscoreTag = 0
		end
		-- end of: if WarStat ~= nil then
	end
	-- end of: if (War) then

	--if (DiploPoints > 5) and (Defcon > 3) then														-- 2. war or more war?/get allies?
		-- Only if not already preparing a war, we loose or are desperate that we will loose
		--if not(ActStrategy:IsPreparingWar()) and ((OurSurrenderLevel < 30) or (OurDesperation < 0))then
			ForeignMinister_War(ActTagTbl)
		--end
	--end
	
	if (DiploPoints > 3) then																		-- 3. influence countries?
		ForeignMinister_Influence(ActTagTbl)
	end

	if (DiploPoints > 3) then																		-- 4. trade for tech/licence?
		ForeignMinister_Trade(ActTagTbl)
	end
	
	-- main loop end

--end
-- end of: if RandNr > 15 then

end

-- War already ongoing, peace?
function ForeignMinister_Peace(ActTagTbl)

	local ActMinister = Grand_Country_Table["Country-" .. ActTagTbl].Minister
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	--local ActTag = ActMinister:GetCountryTag()
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local War = Grand_Country_Table["Country-" .. ActTagTbl].War
	local ActStrategy = Grand_Country_Table["Country-" .. ActTagTbl].ActStrategy
	local Warscore = Grand_Country_Table["Country-" .. ActTagTbl].Warscore
	local OurSurrenderLevel = Grand_Country_Table["Country-" .. ActTagTbl].OurSurrenderLevel
	local ActDesperation = Grand_Country_Table["Country-" .. ActTagTbl].ActDesperation


	local OurStrength = 0
	local AllyStrength = 0
	local EnemyStrength = 0
	local EnemySurrenderLevel = 0
	local AllySurrenderLevel = 0
	local EnemyCounter = 0
	local AllyCounter = 0
	local FactionLeader = nil
	--local PeaceWanted = nil
	local PeaceCountry = nil

	local Warscore = 0
	local ControlledProvincesOld = 0
	local FactorOld = 0
	local StaticWarDaysOld = 0
	local WinningWarDaysOld = 0
	local LoosingWarDaysOld = 0
	local WarDaysOld = 0

	local Peacevalue = nil
	PeaceWanted(ActTagTbl)


	-- Do we want peace?
	local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]
	local WarStat = WarTable.OverallWarStat

	local LowestWarscore = WarStat.LowestWarscore
	local LowestWarscoreTag = WarStat.LowestWarscoreTag
	local Warscore = WarStat.MaxWarscore
	local MaxWarscoreTag = WarStat.MaxWarscoreTag
	local MaxVictoryScore = WarStat.MaxVictoryScore
	local PeaceWantedTag = WarStat.PeaceWantedTag
	local EnemyTag = nil

	local GetRandom = math.random
	local RandNr = GetRandom(30)
	local PeaceWantedNr = WarStat.PeaceWanted
--Utils.LUA_DEBUGOUT("-ForeignMinister_Peace-1: " .. tostring(ActTagTbl) .. " -PeaceWanted: " .. tostring(PeaceWantedNr) .. " -Warscore: " .. tostring(Warscore))

	if PeaceWantedNr > 0 then
--Utils.LUA_DEBUGOUT("-ForeignMinister_Peace-2: " .. tostring(ActTagTbl)  .. " -PeaceWantedNr: " .. tostring(PeaceWantedNr))
		EnemyTag = MaxWarscoreTag
--Utils.LUA_DEBUGOUT("-ForeignMinister_Peace-3: " .. tostring(ActTagTbl)  .. " -EnemyTag: " .. tostring(EnemyTag))
		local Peacevalue = nil
		local MakePeace = false
		local PeaceAction = CPeaceAction( ActTag, EnemyTag )
		if PeaceAction:IsSelectable() then
--Utils.LUA_DEBUGOUT("-ForeignMinister_Peace-4 -IsSelectable: " .. tostring(ActTagTbl)  .. " -EnemyTag: " .. tostring(EnemyTag)  .. " -Our Warscore: " .. tostring(Warscore))
			if Warscore > 0 then
				MakePeace = true
				PeaceAction:SetMode(CPeaceAction._PEACEMODE_DEMAND_)
				
				-- Check first if we want provinces
				local TargetCountryTagTbl = tostring(EnemyTag)
				
				local CoreProvincesCounter = WarTable["EnemyCountry-" .. TargetCountryTagTbl].CoreProvincesCounter
				local TotalProvincesCounter = WarTable["EnemyCountry-" .. TargetCountryTagTbl].TotalProvincesCounter
				local CoreProvincesValue = WarTable["EnemyCountry-" .. TargetCountryTagTbl].CoreProvincesValue
				local ExtraProvincesValue = WarTable["EnemyCountry-" .. TargetCountryTagTbl].ExtraProvincesValue
				local OurCoreProvinces = WarTable["EnemyCountry-" .. TargetCountryTagTbl].OurCoreProvinces
				local ExtraPossibleProvinces = WarTable["EnemyCountry-" .. TargetCountryTagTbl].ExtraPossibleProvinces

				if (OurCoreProvinces ~= nil) and Warscore < 90 then --(CoreProvincesCounter < TotalProvincesCounter) then
--Utils.LUA_DEBUGOUT(" Foreign - Province -PEACE- Core Provinces CHECK " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl))
				for j = 1, #OurCoreProvinces do
					--(ProvinceDistance, ProvinceRegionName, ProvinceValue, OwnedProvinceID)
						local ProvinceID = OurCoreProvinces[j][4]
						local ProvinceValue = OurCoreProvinces[j][3]
						local ProvinceDistance = (OurCoreProvinces[j][1])
						local ProvinceRegionName = (OurCoreProvinces[j][2])
						--	CoreProvincesValue, ExtraProvincesValue
						local WarValue = WarTable["EnemyCountry-" .. TargetCountryTagTbl].AllProvincesValue
						if Warscore > ProvinceValue then
							PeaceAction:AddDemandedProvince(ProvinceID)
							Warscore = (Warscore - ProvinceValue)
--Utils.LUA_DEBUGOUT(" Foreign - Province -PEACE- Core Provinces " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl) .. " Warscore " .. tostring(Warscore) .. " Our core Prov: " .. tostring(ProvinceID) .. " Province Distance from our capital: " .. tostring(ProvinceDistance) .. " In Region of : " .. tostring(ProvinceRegionName) .. " Value : " .. tostring(ProvinceValue) .. " CoreProvincesValue : " .. tostring(CoreProvincesValue) .. " ExtraProvincesValue : " .. tostring(ExtraProvincesValue))
						else
							break
						end
					end
					--end of: for j = 1, #OurCoreProvinces do
				end
				--end of: if OurCoreProvinces ~= nil then

				-- When we are "evil" we ask for some more provinces nearby
				if (ExtraPossibleProvinces ~= nil) and Warscore < 90 then
					if (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (1)) or				-- Totalitarian
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (2)) or			-- Authoritarian
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (3)) or			-- Theocracy
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (4)) then 			-- Absolute Monarchy
						Warscore = Warscore * 0.5
						for j = 1, #ExtraPossibleProvinces do
						--(ProvinceDistance, ProvinceRegionName, ProvinceValue, OwnedProvinceID)
							local ProvinceID = ExtraPossibleProvinces[j][4]
							local ProvinceValue = ExtraPossibleProvinces[j][3]
							local ProvinceDistance = ExtraPossibleProvinces[j][1]
							local ProvinceRegionName = ExtraPossibleProvinces[j][2]
							if Warscore > ProvinceValue then
								PeaceAction:AddDemandedProvince(ProvinceID)
								Warscore = (Warscore - ProvinceValue)
--Utils.LUA_DEBUGOUT(" Foreign - Province -PEACE- Extra Provinces " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl) .. " Warscore " .. tostring(Warscore) .. " Our extra Prov: " .. tostring(ProvinceID) .. " Province Distance from our capital: " .. tostring(ProvinceDistance) .. " In Region of : " .. tostring(ProvinceRegionName) .. " Value : " .. tostring(ProvinceValue) .. " CoreProvincesValue : " .. tostring(CoreProvincesValue) .. " ExtraProvincesValue : " .. tostring(ExtraProvincesValue))
							else
								break
							end
						end
						--end of: for j = 1, #ExtraPossibleProvinces do
					end
					-- end of: if (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (1)) or				-- Totalitarian
				end
				-- end of: if (ExtraPossibleProvinces ~= nil) and Warscore < 90 then

				-- Decide about the "Wargoal/spoils" for rest of Warscore points
				if (Warscore > 0) and (Warscore < 10) then												-- White Peace / TRUCE??
					Peacevalue = "White Peace"
				elseif (Warscore < 15) then																-- MilAccess?
					Peacevalue = "Mil Access"
					PeaceAction:SetGoal(CPeaceAction._GOAL_ACCESS_,true)
				elseif (Warscore < 30) then																-- Humilate?
					Peacevalue = "Humilate"
					PeaceAction:SetGoal(CPeaceAction._GOAL_HUMILIATE_,true)
				elseif (Warscore < 60) then																-- Disarment
					Peacevalue = "Disarment"
					PeaceAction:SetGoal(CPeaceAction._GOAL_DISARM_,true)
				elseif (Warscore < 80) then																-- to come?
				--	Peacevalue = "to come?"
					Peacevalue = "60-80 Warscore - Temporary Solution Disarment"
					PeaceAction:SetGoal(CPeaceAction._GOAL_DISARM_,true)
				elseif (Warscore > MaxVictoryScore) and (Warscore > 84) and (Warscore < 98) then		-- Puppet
					Peacevalue = "Puppet"
					PeaceAction:SetGoal(CPeaceAction._GOAL_PUPPET_,true)
				elseif (Warscore > MaxVictoryScore) then												-- Annex
					Peacevalue = "Annex"
					PeaceAction:SetGoal(CPeaceAction._GOAL_ANNEX_,true)
				end
	
			elseif Warscore < 0 then
				-- nothing for now, the looser doesn't ask for peace.
			else
				PeaceAction:SetMode(CPeaceAction._PEACEMODE_DEMAND_)
				Peacevalue = "White Peace"
				MakePeace = true
			end
			-- end of: if Warscore > 0 then
		end
		--end of: if PeaceAction:IsSelectable() then
		
		if MakePeace then
			--PeaceAction:SetWarscore(100)
			ActAI:PostAction( PeaceAction )
--Utils.LUA_DEBUGOUT("-<>-ForeignMinister_Peace - !PEACE WANTED!-<>- FROM: " .. tostring(ActTagTbl) ..  " - TO PeaceCountry " .. tostring(EnemyTag) ..  " -  Warscore " .. tostring(Warscore) ..  " -  PeaceSelectable " .. tostring(PeaceAble) ..  " -  PeaceType " .. tostring(Peacevalue))
		end
		--end of: if MakePeace then

	end
	-- end of: if PeaceWanted > 0 then

end

-- War?
function ForeignMinister_War(ActTagTbl)

	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local GDPSizeChk = Grand_Country_Table["Country-" .. ActTagTbl].GDPSizeChk
	local War = Grand_Country_Table["Country-" .. ActTagTbl].War
	local ActStrategy = Grand_Country_Table["Country-" .. ActTagTbl].ActStrategy
	local Warscore = Grand_Country_Table["Country-" .. ActTagTbl].Warscore
	local OurSurrenderLevel = Grand_Country_Table["Country-" .. ActTagTbl].OurSurrenderLevel
	local ActDesperation = Grand_Country_Table["Country-" .. ActTagTbl].ActDesperation
	local GetRandom = math.random
	local ActFactionName = Grand_Country_Table["Country-" .. ActTagTbl].FactionName
	
	local Score = 0
	local TagList = {}						-- Need reset for each group
	local SortedTagList = {}

	-- Check for possible targets first
	-- Count in strength later..
	-- Defensive War/Full War?
--if (( ActTagTbl == "USA")  or ( ActTagTbl == "SOV")) then
		
	local CheckTable = Grand_Diplomacy_Table["PossibleWarAid-" .. ActTagTbl]

	if CheckTable ~= (nil) then
	-- CheckTable is empty
	--if not(next(CheckTable) == nil) then
		
--Utils.LUA_DEBUGOUT("--1---FOREIGN--TABLE-: " .. tostring(ActTagTbl) ..  "-  PossibleWarAid ~= (nil) -")
		local count = 0
		for k, v in pairs(CheckTable) do

			local RandNr = GetRandom(30)
			local NotAtWar = true
			Score = 0
			Score = Score + RandNr
			count = count + 1
			local ForeignCountryRelation = 0
			local ForeignCountryThreat = 0
--Utils.LUA_DEBUGOUT("-1-WarAid-: " .. tostring(ActTagTbl) .. "--Count-" .. tostring(count) .. "--PossibleWarAid-K-- " .. tostring(k) )

			local ForeignCountryRelation = Grand_Diplomacy_Table["RelationTable-" .. ActTagTbl]["Country-" .. k].ForeignCountryRelation
			local ForeignCountryThreat = Grand_Diplomacy_Table["RelationTable-" .. ActTagTbl]["Country-" .. k].ForeignCountryThreat
			local ForeignEnemyTag = Grand_Country_Table["Country-" .. k].ActTag
			local ForeignEnemyTagTbl = tostring(ForeignEnemyTag)
			local ForeignEnemyCountry =  Grand_Country_Table["Country-" .. k].ActCountry
			local ForeignEnemyFactionName = Grand_Country_Table["Country-" .. k].FactionName
				
			-- Move to initial check..
			if Grand_Country_Table["Country-" .. k].HasFaction and Grand_Country_Table["Country-" .. ActTagTbl].HasFaction then									-- Fighting faction?
				if (ForeignEnemyFactionName ~= ActFactionName) then									-- Another Faction! Fight them off
					Score = Score + 100
				end
			elseif ForeignEnemyCountry:IsEnemy(ActTag) then											-- If we have common enemies
					Score = Score - 25
			elseif ForeignEnemyCountry:IsFriend(ActTag, true) then									-- They are at war with friends!
					Score = Score - 100
			else																					-- Otherwise
				Score = Score + 10
			end
			-- end of: if Grand_Country_Table["Country-" .. k].HasFaction then

			-- Score Relationship: The higher the relationship, the higher the Score
			if ForeignCountryRelation < -125 then													-- value -126 to -200(range 75 = very bad)
				Score = Score + 15
			elseif ForeignCountryRelation < -50 then												-- value -51 to -125(range 75 = bad)
				Score = Score + 5
			elseif ForeignCountryRelation > 50 then													-- value 51 to 125(range 75 = good)
				Score = Score - 5				
			elseif ForeignCountryRelation > 125 then												-- value 126 to 200(range 75 = very good)
				Score = Score - 15
			else																					-- value -49 to 50(range 100 = neutral)
				Score = Score + 0		
			end

			-- Score Threat: The lower the threat, the higher the Score
			if ForeignCountryThreat < 15 then													-- value 0 to 14(range 10 = very low)
				Score = Score + 0
			elseif ForeignCountryThreat < 35 then												-- value 15 to 34(range 20 = low)
				Score = Score + 5
			elseif ForeignCountryThreat < 75 then												-- value 35 to 74(range 40 = middle)
				Score = Score + 10
			elseif ForeignCountryThreat < 125 then												-- value 75 to 124(range 50 = high)
				Score = Score + 15
			else																				-- value 125 to x(range 75 = very high)
				Score = Score + 25
			end
--Utils.LUA_DEBUGOUT("-2-WarAid-: " .. tostring(ActTagTbl) .. "-Score" .. tostring(Score) .. "--PossibleWarAid-K-- " .. tostring(k) )
			-- only add if score is big enough
			if Score > 75 then
--Utils.LUA_DEBUGOUT("-3-WarAid--LIST: " .. tostring(ActTagTbl) .. "-Score" .. tostring(Score) .. "--PossibleWarAid-K-- " .. tostring(k) )

				-- Make sure we did'nt had a war with them in the past last year
				local CheckOurWarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]["EnemyCountry-" .. k]
				if CheckOurWartable ~= (nil) then
					local OurEnemy = CheckOurWartable[Enemy]
					local OurWarStart = CheckOurWartable[WarStart]
					local OurWarEnd = CheckOurWartable[WarEnd]
					if OurWarEnd ~= nil then
						local ActualTime = Grand_Country_Table["Country-" .. ActTagTbl].Timestamp
						if (ActualTime - OurWarEnd) > 365 then
							TagList[Score] = ForeignEnemyTag
							table.insert(SortedTagList , { Score, ForeignEnemyTag })
						end
					end
				else
					TagList[Score] = ForeignEnemyTag
					table.insert(SortedTagList , { Score, ForeignEnemyTag })
				end

			end

		end
		-- end of: for k, v in pairs(CheckTable) do

	end
	-- end of: if CheckTable ~= (nil) then

	
--[[ -- Just for testing
	for l = 1, #SortedTagList do
		local tag= SortedTagList[l][2]
		local ScoreLoop = SortedTagList[l][1]
-- Utils.LUA_DEBUGOUT("--1---FOREIGN---: " .. tostring(ActTagTbl) .. "--SortedTagList-" .. tostring(tag) .. "--Score-" .. tostring(ScoreLoop) )
	end
]]

	-- Sort and declare war..
	if not(next(SortedTagList) == nil) then
			table.sort(SortedTagList,comp)
			local DeclareWarOn = SortedTagList[1][2]

			--if not ActStrategy:IsPreparingWarWith(DeclareWarOn) then
			if not( ActStrategy:IsPreparingWar()) then
	 			ActStrategy:PrepareWar(DeclareWarOn, 100)
				--local WarAction = CDeclareWarAction( ActTag, DeclareWarOn )
				--WarAction:SetLimitedDefensive(true)
				--WarAction:SetValue(true)
				--WarAction:GenerateLimitedDefendedList()
				--ActAI:PostAction( WarAction )
--Utils.LUA_DEBUGOUT("-1-WAR-: " .. tostring(ActTagTbl) .. "--DeclareWarOn-" .. tostring(DeclareWarOn) )
			end
	end
	-- end of: if not(next(SortedTagList) == nil) then
	
--end
-- end of: US only
--[[

##########################################################
	local WarAction = CDeclareWarAction( ActTag, EnemyTag )
	WarAction:SetLimitedDefensive(true)
	WarAction:SetValue(true)
	WarAction:GenerateLimitedDefendedList()
	ActAI:PostAction( WarAction )

CDeclareWarAction( CCountryTag Actor, CCountryTag Recipient, CEU3Date Date, bool bLimitedDefensive);
[21.10.2013 23:56:31] Lennart Berg: pAction->SetValue( false );
[21.10.2013 23:56:58] Lennart Berg: return new CDeclareWarAction( CNullTag(), CNullTag(),CEU3Date() );
[21.10.2013 23:57:04] Lennart Berg:    CDeclareWarAction* pAction = new CDeclareWarAction( CNullTag(), CNullTag(),CEU3Date() );
   pAction->SetValue( false );
[21.10.2013 23:57:10] Lennart Berg:    CDeclareWarAction* pAction = new CDeclareWarAction(CNullTag(), CNullTag(), CEU3Date());
   pAction->SetLimitedDefensive(true);
   pAction->SetValue(true);

#####################################

  CDeclareWarAction* pDecWar =(CDeclareWarAction*)CreateDiplomaticAction(_limited_defensive_war_, Recipient, false);
  pDecWar->SetLimitedDefensive(true);
  pDecWar->SetValue(true);
  pDecWar->GenerateLimitedDefendedList();

 class_< CDeclareWarAction, CDiplomaticAction >("CDeclareWarAction")
   .scope
   [
    def( "Create", &CDeclareWarAction::Create )
   ]
   .def( constructor< CCountryTag, CCountryTag >() )
   .def( "SetLimitedDefensive", &CDeclareWarAction::SetLimitedDefensive )
   .def( "SetValue", &CDeclareWarAction::SetValue )
   .def( "GenerateLimitedDefendedList", &CDeclareWarAction::GenerateLimitedDefendedList ),

 ###############################################################

]]

--[[

		
	-- From the functions(NeigbourCountryCheck(ActTagTbl)/AllCountryCheck(ActTagTbl)) we get a table with possible targets back
	-- Sorting possible targets
	table.sort(SortedTagList,comp) --comp can be found in tech so far, need to be put into utils/rucksack/support..
	-- Only one declaration at a time/tick? or do a for loop for some/all?
	if not ActStrategy:IsPreparingWarWith(SortedTagList[0][0]) then
		ActStrategy:PrepareWar( SortedTagList[0][0], 100 )
	end



	-- Depending on eco, the countries could start wars in neighbourhood, on the same continent or in the whole world
	if GDPSizeChk < 3 then																-- Tiny eco, only ever war with neighbours
		-- Check the Neighbours
		
	elseif GDPSizeChk == 3 then															-- Average eco, only ever war on same continent
		-- from here we need every country queried..
		
	elseif GDPSizeChk == 4 then															-- Big eco, all possibilities
		-- Every country queried..
		
	elseif GDPSizeChk > 4 then															-- Nuke Power, all possibilities
		-- Every country queried..
		
	end
	-- end of:	if GDPSizeChk < 3 then


			-- PossibleTags[Score] = NeighborString
			-- 	Tag = NeighborString
			-- 	Score = Score
			-- 	}

	-- Loop for preparing war
	-- for k, v in pairs(PossibleTags) do
	-- 	if not ActStrategy:IsPreparingWarWith(PossibleTags[k].Tag) then
	-- 		ActStrategy:PrepareWar( PossibleTags[k].Tag, 100 )
	-- 	end
]]

end

-- Influence?
function ForeignMinister_Influence(ActTagTbl)
	-- no entry..




end

-- Trade?
function ForeignMinister_Trade(ActTagTbl)
	-- no entry..
end




function ForeignMinister_EvaluateDecision(agent, decision, scope) 
	-- default we approve any decision we can take, override in country specific ai if wanted
	-- also some random to spread out the decisions
	local score = math.mod( CCurrentGameState.GetAIRand(), 100)

	--score = Utils.CallScoredCountryAI(agent:GetCountryTag(), 'ForeignMinister_EvaluateDecision', score, agent, decision, scope)

	-- All score above 0 counts as decsion taken
	if score < 50 then
		score = 0
	end
	return score
end


-- Not used so far
function ForeignMinister_OnWar( agent, countryTag1, countryTag2, war )
	-- no entry..
end

-- End of Methods Called by the EXE
-- ##############################

