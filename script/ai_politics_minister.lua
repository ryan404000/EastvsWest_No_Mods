-- ###############################################
-- ## "Niccolo" -East vs. West- Political Lua AI
-- ## Created By: Chromos	Date: 03.02.2013
-- ## Modified By: Chromos	Date: 30.09.2013
-- ###############################################
--[[
]]
-- ###############################################
-- ## Main Method called by the EXE
-- ###############################################
function PoliticsMinister_Tick(minister)

	local minister = minister
	local ActTag = minister:GetCountryTag()
	local ActTagTbl = tostring(minister:GetCountryTag())
	local ActDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local GetRandom = math.random
	local RandNr = GetRandom(30)
	
	-- Don't want to check every day/keep diplo points for other urgent actions.
	-- Need check

-- ## Start Check for Data Tables
-- #############################
	-- Country Data Setup
	local CountryTable = Grand_Country_Table["Country-" .. ActTagTbl]			-- Just a shorter name for the long table name for better readability
	if (Grand_Country_Table["Country-" .. ActTagTbl] == nil ) then
		CountrySetup(ActTag)
	elseif (Grand_Country_Table["Country-" .. ActTagTbl].Timestamp) < (AllDays) then
		CountrySetup(ActTag)
	end
	-- Nation Data Setup
	local NationTable = Grand_Nation_Table["ActNation-" .. ActTagTbl]			-- Just a shorter name for the long table name for better readability
	if (Grand_Nation_Table["ActNation-" .. ActTagTbl] == nil ) then
		NationSetup(ActTagTbl)
	elseif (Grand_Nation_Table["ActNation-" .. ActTagTbl].Timestamp.Day) < (AllDays) then
		NationSetup(ActTagTbl)
	end
	-- Laws Data Setup
	local LawsTable = Grand_Laws_Table["ActLaws-" .. ActTagTbl]					-- Just a shorter name for the long table name for better readability
	if (Grand_Laws_Table["ActLaws-" .. ActTagTbl] == nil ) then
		LawsSetup(ActTagTbl)
	elseif (Grand_Laws_Table["ActLaws-" .. ActTagTbl].Timestamp.Day) < (AllDays) then
		LawsSetup(ActTagTbl)
	end
	-- Policies Data Setup
	local PoliciesTable = Grand_Policies_Table["ActPolicies-" .. ActTagTbl]		-- Just a shorter name for the long table name for better readability
	if (Grand_Policies_Table["ActPolicies-" .. ActTagTbl] == nil ) then
		PoliciesSetup(ActTagTbl)
	elseif (Grand_Policies_Table["ActPolicies-" .. ActTagTbl].Timestamp.Day) < (AllDays) then
		PoliciesSetup(ActTagTbl)
	end
-- #############################
-- ## End Check for Data Tables
	
	Grand_Country_Table["Country-" .. ActTagTbl].Minister = minister
	local ActAI = minister:GetOwnerAI()
	Grand_Country_Table["Country-" .. ActTagTbl].ActAI = ActAI
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActDissent = Grand_Country_Table["Country-" .. ActTagTbl].ActDissent
	local ActNU = Grand_Country_Table["Country-" .. ActTagTbl].ActNU
	local ActGDP = Grand_Country_Table["Country-" .. ActTagTbl].ActGDP
	local GDPSizeChk = Grand_Country_Table["Country-" .. ActTagTbl].GDPSizeChk
--Utils.LUA_DEBUGOUT("--1---Political-ActDissent-: " .. tostring(ActTag) .. "-" ..  tostring(ActDissent))
--Utils.LUA_DEBUGOUT("--1---Political-ActNU-: " .. tostring(ActTag) .. "-" ..  tostring(ActNU))
--Utils.LUA_DEBUGOUT("--1---Political--: " .. tostring(ActTag) .. "-" ..  tostring(ActTagTbl))
--Utils.LUA_DEBUGOUT("--2---Politics--: " .. tostring(ActTag) .. "-----------------------" ..  tostring(ActDay))
--Utils.LUA_DEBUGOUT("--2--Politics-RUCKSACK--: " .. tostring(ActTag) .. "-----------------------" ..  tostring(Grand_Country_Table["Country-" .. ActTagTbl].Timestamp))
--Utils.LUA_DEBUGOUT("--2--Politics-RUCKSACK--: " .. tostring(ActTag) .. "-----------------------" ..  tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMonth))
--Utils.LUA_DEBUGOUT("--2--Politics-RUCKSACK--: " .. tostring(ActTag) .. "-----------------------" ..  tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActDay))


	local Faction = ActCountry:GetFaction()
	local Neutrality = ActCountry:GetNeutrality():Get()
	local EffectiveNeutrality = ActCountry:GetEffectiveNeutrality()
	local HighestThreatCtry = Grand_Country_Table["Country-" .. ActTagTbl].HighestThreatCtry
	local HighestThreat = Grand_Country_Table["Country-" .. ActTagTbl].HighestThreat
	local Defcon = ActCountry:GetDefconLevel()
	local War = ActCountry:IsAtWar()
	local Clock = CAI.GetDoomsDayClockMinutes()
	local LastElectionDate = ActCountry:GetLastElectionDate()
	local RatingMajor = ActCountry:GetMajorRating()
	local ActDATE = nil
	local ActMoney = nil 	-- wich to choose balance/actual?..
	local ActMoneyGain = 0	--How much we gain each day..(can be + or -)
	local FactionAlignment = nil
	local Prestige = nil
	--local Alliance = ActCountry:HasAlliance() -- NIL! --Still not
	--local EcoBuildings = ActCountry:GetNumOfEcoBuildings():Get()
	--local EcoBuildingsConstruction = ActCountry:GetNumOfEcoBuildingsUnderConstruction():Get() --int GetNumOfEcoBuildings(CCountry&,int) - no script source to reload
	--local DailyIncome = ActCountry:GetDailyIncome() -
	--local DailyBalance = ActCountry:GetDailyBalance()
	--local RatingEconomy = ActCountry:GetEconomyRatingValue() -- NIL!
	--local TechDoneNumber = ActCountry:GetNumOfTechnologiesDoneByFolder()	
	--local TechDonePercentage = ActCountry:GetPctOfTechnologiesDoneByFolder()

	local AtomicPower = CTechnologyDataBase.GetTechnology("nuclear_nuclear_power")
	local AtomicPowerLevel = ActCountry:GetTechnologyStatus():GetLevel(AtomicPower)
	local AtomicWeapons = CTechnologyDataBase.GetTechnology("nuclear_enrichment_process")
	local AtomicWeaponsLevel = ActCountry:GetTechnologyStatus():GetLevel(AtomicWeapons)

	local HvyIndustryAvail = ActCountry:GetTechnologyStatus():IsBuildingAvailable(CBuildingDataBase.GetBuilding("naval_base"))
	-- new buildings are not working!

-- Lua test output just for some countries
--[[
local USATag = CCountryDataBase.GetTag('USA')
local SOVTag = CCountryDataBase.GetTag('SOV')
local CHCTag = CCountryDataBase.GetTag('CHC')
local CHITag = CCountryDataBase.GetTag('CHI')
local ENGTag = CCountryDataBase.GetTag('ENG')
local FRATag = CCountryDataBase.GetTag('FRA')

if (ActTag == USATag) and (ActTag == SOVTag) and (ActTag == CHCTag) or (ActTag == CHITag) or (ActTag == ENGTag) or (ActTag == FRATag) then
Utils.LUA_DEBUGOUT("------COUNTRY-------" .. " - " ..  tostring(ActTag) .. " - " ..  tostring(ActTag) .. " - "  .. tostring(ActTag) .. " - "  .. "------COUNTRY-------")
Utils.LUA_DEBUGOUT("------Neutrality-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(Neutrality))
Utils.LUA_DEBUGOUT("------EffectiveNeutrality-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(EffectiveNeutrality))
Utils.LUA_DEBUGOUT("------HighestThreatCtry-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(HighestThreatCtry))
Utils.LUA_DEBUGOUT("------HighestThreat-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(HighestThreat))
--Utils.LUA_DEBUGOUT("------ActThreat-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(ActThreat))
Utils.LUA_DEBUGOUT("------Defcon-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(Defcon))
Utils.LUA_DEBUGOUT("------Clock-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(Clock))
Utils.LUA_DEBUGOUT("------RatingMajor-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(RatingMajor))
--Utils.LUA_DEBUGOUT("------LastElectionDate-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(LastElectionDate))
--Utils.LUA_DEBUGOUT("------EcoBuildings-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(EcoBuildings))
--Utils.LUA_DEBUGOUT("------EcoBuildingsConstruction-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(EcoBuildingsConstruction))
--Utils.LUA_DEBUGOUT("------DailyIncome-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(DailyIncome))
--Utils.LUA_DEBUGOUT("------DailyBalance-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(DailyBalance))
--Utils.LUA_DEBUGOUT("------RatingEconomy-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(RatingEconomy))
--Utils.LUA_DEBUGOUT("------TechDoneNumber-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(TechDoneNumber))
--Utils.LUA_DEBUGOUT("------TechDonePercentage-------" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(TechDonePercentage))
end

	--local RatingMilitary = nil
	--local RatingDiplomacy = nil
	--local DiploPoints = nil
	--local ActManpower = ActCountry:GetManpower()
	--local ActAmountNukes = ActCountry:GetNuclearForces()
	--local ActStrategy = ActCountry:GetStrategy()
	--local IsPuppet = ActCountry:IsSubject()
	--local DailyNeed = ActCountry:GetDailyNeed()
	--local DailyExpense = ActCountry:GetDailyExpense()
	--local DailyBalance = ActCountry:GetDailyBalance()
	--local DailyIncome = ActCountry:GetDailyIncome()
	--local ConsumerRateInGDP = ActCountry:GetConsumerRateInGDP()
	--local ServicesRateInGDP = ActCountry:GetServicesRateInGDP()
	--local FactoryRateInGDP = ActCountry:GetFactoryRateInGDP()
]]

	


-- ## Start Politics Score System
-- #############################
--[[
All Score values dummies..
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].ElectionsAndVoting.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].ElectionsAndVoting.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].OrganizedReligionsLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].OrganizedReligionsLaw.Score +1

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].DomesticPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].DomesticPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].IntelligencePolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].IntelligencePolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EconomicPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EconomicPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score +1
	else
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].ElectionsAndVoting.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].ElectionsAndVoting.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].OrganizedReligionsLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].OrganizedReligionsLaw.Score -1

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].DomesticPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].DomesticPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].IntelligencePolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].IntelligencePolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EconomicPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EconomicPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score -1
]]
	-- Check for Government
	if (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (1)) then				-- Totalitarian
		--LawScore = --LawScore - 4
	elseif (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (2)) then			-- Authoritarian
		--LawScore = --LawScore - 3
	elseif (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (3)) then			-- Theocracy
		--LawScore = --LawScore - 2
	elseif (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (4)) then			-- Absolute Monarchy
		--LawScore = --LawScore - 1
	else												-- Democracy..
		--LawScore = --LawScore + 2
	end

	-- Check for Identity
	if (Grand_Nation_Table["ActNation-" .. ActTagTbl].Identity.CurrentCulture < 20) then	-- territorial and cultural bias
		--PolicyScore = --PolicyScore + 1
	else													-- all other
		--PolicyScore = --PolicyScore - 1
	end
	--Check for Attitude
	if (Grand_Nation_Table["ActNation-" .. ActTagTbl].Attitude.CurrentCulture < 28) then 	-- Imperialists to Hegemons..
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -1			-- Get less neutrality
	else													-- all other
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score +1			-- Get more neutrality
	end

	-- Check for War
	if War then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score +1

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score +1
	else
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score -1

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score -1
	end

	-- Check for Dissent
	if (ActDissent < 5) then		-- All before should be taken care of with the Economy Slider settings
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score -1
	elseif (ActDissent < 10) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score -2
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score -2
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -2
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score -2
	elseif (ActDissent < 15) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score -3
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score +3
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -3
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score -3
	elseif (ActDissent < 20) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score -4
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score +4
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -4
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score -4
	else
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score +1
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score +1
	end

	-- Check for National Unity
	if (ActNU < 80) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -1
	elseif (ActNU < 60) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score -2
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -2
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -2
	elseif (ActNU < 40) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score -3
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -3
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -3
	elseif (ActNU < 20) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score -4
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score -4
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -4
	else
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.Score +1
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score +1
	end

	-- Check for Neutrality
	if (Neutrality > 55) then											-- Get around 50 neutrality
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score -1
	else
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.Score +1
	end

	-- Check for Money
	if (ActMoneyGain > 500) then
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score -1
	elseif (ActMoneyGain > 1000) then
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score -2
	elseif (ActMoneyGain > 5000) then
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score -3
	else
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score +1
	end

	-- Check for Highest Threat
	if (HighestThreat > 95) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score +4

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score +4
	elseif (HighestThreat > 75) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score +3

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score +3
	elseif (HighestThreat > 55) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score +2

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score +2
	elseif (HighestThreat > 35) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score +1

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score +1
	elseif (HighestThreat > 15) then
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score -1

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score -1
	else
		Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score = Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.Score -2

		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score -2
	end

	--Buildings Check
	if AtomicPowerLevel > 0 then
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score +1
	else
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score -1
	end
	if AtomicWeaponsLevel > 0 then
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score -1
	else
		Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score +1
	end

-- #############################
-- ## End Politics Score Section

-- only for testing!
--[[
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].DomesticPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].DomesticPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].IntelligencePolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].IntelligencePolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EconomicPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EconomicPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.Score -1
Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score = Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.Score -1
]]

-- ## Start Politics Change Section
-- #############################
	local LawsChangeable = false 			--for now.. if at war, do we want the ai to be able to change laws in intervals only etc..
	LawsChangeable = true
	-- Change Laws
	if LawsChangeable then
		for k, v in pairs(Grand_Laws_Table["ActLaws-" .. ActTagTbl]) do
			if v.Score ~= 50 then											-- Only go further if really needed
				local NewLawIndex = v.CurrentLaw
				-- Choose Law further down(+1) or up(-1) depending on circumstances(Score)
				if v.Score > 50 then NewLawIndex = NewLawIndex + 1 else NewLawIndex = NewLawIndex - 1 end
					if (NewLawIndex > 0) and (NewLawIndex < (Grand_Laws_Table["ActLaws-" .. ActTagTbl].Timestamp.MaxEndIndex)) then
					local NewLaw = CLawDataBase.GetLaw(NewLawIndex)
					-- Last Check if NewLaw is valid and still in the right group
					if NewLaw:ValidFor(ActTag) and ((NewLawIndex >= v.StartIndex) and (NewLawIndex < v.EndIndex)) then
						-- If change possible, execute
						ActAI:Post(CChangeLawCommand(ActTag, NewLaw, v.LawGroup))
						--NewActLaws = false									-- "Break" clause
-- only for testing!
--[[
Utils.LUA_DEBUGOUT("LAWS LAWS LAWS LAWS LAWS" .. " - " ..  tostring(ActTag) .. " --- "  .. "LAWS LAWS LAWS LAWS LAWS")
Utils.LUA_DEBUGOUT("Laws: Old Law Index" .. " - " ..  tostring(ActTag) .. " --- "  .. tostring(v.CurrentLaw))
local OldLaw = CLawDataBase.GetLaw(v.CurrentLaw)
local OldLawString = OldLaw:GetKey()
local NewLawString = NewLaw:GetKey()
Utils.LUA_DEBUGOUT("LAWS LAWS LAWS LAWS LAWS" .. " - " ..  tostring(ActTag) .. " - "  .. "LAWS LAWS LAWS LAWS LAWS")
Utils.LUA_DEBUGOUT("Laws: OldLaw" .. " - " ..  tostring(ActTag) .. " --- "  .. tostring(OldLawString))
Utils.LUA_DEBUGOUT("Laws: Laws Score" .. " ------ " ..  tostring(ActTag) .. " --- "  .. tostring(v.Score))
Utils.LUA_DEBUGOUT("Laws: New-Law" .. " - " ..  tostring(ActTag) .. " --- "  .. tostring(NewLawString))
Utils.LUA_DEBUGOUT("Laws: New Law Index" .. " - " ..  tostring(ActTag) .. " --- "  .. tostring(NewLawIndex))
]]
					end
				end
			end
			Grand_Laws_Table["ActLaws-" .. ActTagTbl].Timestamp.Day = AllDays								-- We changed some laws..
		end
	end


	local PoliciesChangeable = false 		--for now.. if at war, do we want the ai to be able to change laws in intervals only etc..
	PoliciesChangeable = true
	-- Change Policies
	if PoliciesChangeable then
		for k, v in pairs(Grand_Policies_Table["ActPolicies-" .. ActTagTbl]) do
			if v.Score == 50 then 
--Utils.LUA_DEBUGOUT("Policies: = 50" .. " - " ..  tostring(ActTag) .. " --- "  .. tostring(k))
			end
			if v.Score ~= 50 then											-- Only go further if really needed
--Utils.LUA_DEBUGOUT("Policies: != 50" .. " ------------ " ..  tostring(ActTag) .. " --- "  .. tostring(k))
				local NewPolicyIndex = v.CurrentPolicy
				-- Choose Policy further down(+1) or up(-1) depending on circumstances(Score)
				if v.Score > 50 then NewPolicyIndex = NewPolicyIndex + 1 else NewPolicyIndex = NewPolicyIndex - 1 end
					if (NewPolicyIndex > 0) and (NewPolicyIndex < (Grand_Policies_Table["ActPolicies-" .. ActTagTbl].Timestamp.MaxEndIndex)) then
						local NewPolicy = CPolicyDataBase.GetPolicy(NewPolicyIndex)
						-- Last Check if NewPolicy is valid and still in the right group
						if NewPolicy:ValidFor(ActTag) and ((NewPolicyIndex >= v.StartIndex) and (NewPolicyIndex < v.EndIndex)) then
							-- If change possible, execute
							ActAI:Post(CChangePolicyCommand(ActTag, NewPolicy, v.PolicyGroup))
							--NewActPolicies = false										-- "Break" clause
		-- only for testing
--[[
Utils.LUA_DEBUGOUT("Policies Policies Policies Policies Policies" .. " - " ..  tostring(ActTag) .. " - "  .. "Policies Policies Policies Policies Policies")
Utils.LUA_DEBUGOUT("Policies: != 50" .. " ---Policies: != 50--- " ..  tostring(ActTag) .. " ---Policies: != 50--- "  .. tostring(k))
local OldPolicy = CPolicyDataBase.GetPolicy(v.CurrentPolicy)
local OldPolicyString = OldPolicy:GetKey()
Utils.LUA_DEBUGOUT("Policies: OldPolicy" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(OldPolicyString))
Utils.LUA_DEBUGOUT("Policies: PolicyScore" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(v.Score))
Utils.LUA_DEBUGOUT("Policies: Old Policy Index" .. " - " ..  tostring(ActTag) .. " --- "  .. tostring(v.CurrentPolicy))
local NewPolicyString = NewPolicy:GetKey()
Utils.LUA_DEBUGOUT("Policies: New-Policy" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(NewPolicyString))
Utils.LUA_DEBUGOUT("Policies: New Policy Index" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(NewPolicyIndex))
]]
					end
				end
			end
			Grand_Policies_Table["ActPolicies-" .. ActTagTbl].Timestamp.Day = AllDays							-- We changed some policies..
		end
	end


-- #############################
-- ## End Politics Change Section


-- When to liberate? Or to puppet?
-- ## Start Liberate Country
-- #############################
    if ActCountry:MayLiberateCountries() then
        for loMember in ActCountry:GetPossibleLiberations() do
            if minister:IsCapitalSafeToLiberate(loMember) then
                ai:Post(CLiberateCountryCommand(loMember, ActTag))
            end
        end
    end	
-- #############################
-- ## End Liberate Country


-- ## Start Puppet Country
-- #############################
	-- Puppets are country specific AI countries will not release them automatically and must be scripted
    if ActCountry:CanCreatePuppet() then
        Utils.CallCountryAI( ActTag, "HandlePuppets", minister )
    end
-- #############################
-- ## End Puppet Country


-- ## Start Politics Decsions
-- #############################
	-- to come, Wich Political decsion to choose	
-- #############################
-- ## End Politics Decsions

end
-- ###############################################
-- ## End of Main Method called by the EXE
-- ###############################################

