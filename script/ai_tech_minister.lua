-- ###############################################
-- ## "Hypatia" -East vs. West- Research Lua AI
-- ## Created By: Chromos	Date: 26.03.2013
-- ## Modified By: Chromos	Date: 03.03.2013
-- ###############################################
--[[
]]
-- ###############################################
-- ## Main Method called by the EXE
-- ###############################################
function TechMinister_Tick(minister, set_sliders, set_research, fixedmoney, isplayer, nongoaltechs)

	-- preload basic values (Act = Actual..)
	local tostring = tostring
	local minister = minister
	local ActTag = minister:GetCountryTag()
	local ActTagTbl = tostring(minister:GetCountryTag())
	local ActDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local ActYear = CCurrentGameState.GetCurrentDate():GetYear()
	local ActMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	local ActDATE = nil
	local ActMoney = fixedmoney --+ 100000
	local isplayer = isplayer
	local nongoaltechs = nongoaltechs
	local set_research = set_research
	local GetRandom = math.random
	local RandNr = GetRandom(30)

	--local ResearchSlotsAllowed = 10

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
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActDissent = Grand_Country_Table["Country-" .. ActTagTbl].ActDissent
	local ActNU = Grand_Country_Table["Country-" .. ActTagTbl].ActNU
	local ActGDP = Grand_Country_Table["Country-" .. ActTagTbl].ActGDP
	local GDPSizeChk = Grand_Country_Table["Country-" .. ActTagTbl].GDPSizeChk

	local MobilizingNeededManpower = Grand_Country_Table["Country-" .. ActTagTbl].MobilizingNeededManpower
	local TotalAvailableManpower = Grand_Country_Table["Country-" .. ActTagTbl].TotalAvailableManpower
	local TechStatus = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus
	local SeaAvail = Grand_Country_Table["Country-" .. ActTagTbl].SeaAvail 			-- and money < 100)
	local AirAvail = Grand_Country_Table["Country-" .. ActTagTbl].AirAvail 			-- and money < 100)
	local War = Grand_Country_Table["Country-" .. ActTagTbl].War
	local FactionName = Grand_Country_Table["Country-" .. ActTagTbl].FactionName
	local Neutrality = Grand_Country_Table["Country-" .. ActTagTbl].Neutrality
	local EffectiveNeutrality = Grand_Country_Table["Country-" .. ActTagTbl].EffectiveNeutrality
	local HighestThreat = Grand_Country_Table["Country-" .. ActTagTbl].HighestThreat
	local Defcon = Grand_Country_Table["Country-" .. ActTagTbl].Defcon
	local Clock = Grand_Country_Table["Country-" .. ActTagTbl].Clock

	local tabin = table.insert
	local rounddown = math.floor

--[[
	-- set up checks for type of country(big/small, eco, naval, air, major etc..)
	local LightIndustry = nil				-- Do we have Light Industry? Or how much
	local HeavyIndustry = nil				-- Do we have Heavy Industry? Or how much
	local NavalIndustry = nil				-- Do we have Naval Industry? Or how much
	local AirIndustry = nil					-- Do we have Air Industry? Or how much
	local HighTechIndustry = nil			-- Do we have High Tech Industry? Or how much
	local SupplyIndustry = nil				-- Do we have Supply Industry? Or how much
	local SateliteIndustry = nil			-- Do we have Satelite Industry? Or how much
	local CentrifugeIndustry = nil			-- Do we have Centrifuge Industry? Or how much

	-- How to define a big/small country, a wealthy country, an advanced country..
	-- count on provinces, population, money income, techs researched?
	--local DailyIncome = ActCountry:GetDailyIncome()
	--local Population = ActCountry:GetTotalPopulation()
	local ControlledProvincesNumber = ActCountry:GetNumberOfControlledProvinces()
	local OwnedProvincesNumber = ActCountry:GetNumberOfOwnedProvinces()
	local CoreProvincesNumber = ActCountry:GetCoreProvinces()
	--local EcoBuildingsNumber = ActCountry:GetNumOfEcoBuildings()
	--local ResearchDonePercentage = ActCountry:GetPctOfTechnologiesDoneByFolder()
	--local UnitsCount = 

	--Utils.LUA_DEBUGOUT("DailyIncome" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(DailyIncome))
	--Utils.LUA_DEBUGOUT("Population" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(Population))
	--Utils.LUA_DEBUGOUT("ControlledProvincesNumber" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(ControlledProvincesNumber))
	--Utils.LUA_DEBUGOUT("OwnedProvincesNumber" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(OwnedProvincesNumber))
	--Utils.LUA_DEBUGOUT("EcoBuildingsNumber" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(EcoBuildingsNumber))	
	--Utils.LUA_DEBUGOUT("ResearchDonePercentage" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(ResearchDonePercentage))

	-- make table ot of this later..
	local WealthChk = 0
	local EconomyChk = 0
	local ResearchChk = 0
	local UnitsChk = 0					-- Wich type of each branch?
	local PopulationChk = 0
	local NationScore = 0
]]


-- ## Start of Research
-- #############################
	-- Only research if money left
	if (set_research) and (ActMoney > 100) then

	--Average research slot costs $100-$150. So money / 150 = max researchslots..
	local ResearchSlotsAllowed = ((ActMoney / 150) +2)


	-- ## Basic research weight initialisation
	-- #############################
	-- Initial 2 fields make up 100% of the available money
	local ResearchWeightNation = 0.00			-- Basic Nation related research - Will be split up later
	local ResearchWeightMilitary = 0.00 		-- Basic Military related research - Will be split up later

	-- Special, will get % if needed from National/Military
	local ResearchWeightPolitical = 0.00 		-- Special poitical research of doctrines(NATO/WP/Theocracy etc..)
	local ResearchWeightNuclear = 0.00 			-- Nuclear base research
	local ResearchWeightSpace = 0.00 			-- Space Race research

	-- Nation related
	-- made up together 100% of the initial amount from Nation %
	local ResearchWeightScience = 0.00 			-- Basic Science research
	local ResearchWeightIndustry = 0.00 		-- Industry research
	local ResearchWeightEspionage = 0.00 		-- Espionage research

	-- Military related
	-- made up together 100% of the initial amount from Military %
	local ResearchWeightArmy = 0.00 			-- Land units and doctrines research
	local ResearchWeightNavy = 0.00 			-- Naval units and doctrines research
	local ResearchWeightAirforce = 0.00 		-- Air units and doctrines research


	-- Start of Economy Check
	if GDPSizeChk > 1 then									-- Tiny / Infantry Unit advances
		if GDPSizeChk > 2 then								-- Small / Air / Land / Sea
			if GDPSizeChk > 3 then							-- Medium / ALL units
				if GDPSizeChk > 4 then						-- Really Big / Nuclear
					if GDPSizeChk > 5 then					-- Superpower / Space race
						ResearchWeightScience = 0.35
						ResearchWeightIndustry = 0.35
						ResearchWeightEspionage = 0.30
						ResearchWeightNation = 0.50 					-- Basic Nation related research - Will be split up later
						ResearchWeightMilitary = 0.50 					-- Basic Military related research - Will be split up later
					else										-- Really Big / Nuclear
					ResearchWeightScience = 0.40
					ResearchWeightIndustry = 0.35
					ResearchWeightEspionage = 0.25
					ResearchWeightNation = 0.55
					ResearchWeightMilitary = 0.45
					end
				else											-- Medium / ALL units
				ResearchWeightScience = 0.40
				ResearchWeightIndustry = 0.40
				ResearchWeightEspionage = 0.20
				ResearchWeightNation = 0.60 
				ResearchWeightMilitary = 0.40
				end
			else												-- Small / Air / Land / Sea
			ResearchWeightScience = 0.45
			ResearchWeightIndustry = 0.45
			ResearchWeightEspionage = 0.10
			ResearchWeightNation = 0.70
			ResearchWeightMilitary = 0.30
			end
		else													-- Tiny / Infantry Unit advances
		ResearchWeightScience = 0.45
		ResearchWeightIndustry = 0.50
		ResearchWeightEspionage = 0.05
		ResearchWeightNation = 0.80 
		ResearchWeightMilitary = 0.20
		end
	else														-- Below Tiny..
	ResearchWeightScience = 0.40
	ResearchWeightIndustry = 0.60
	ResearchWeightEspionage = 0.00
	ResearchWeightNation = 1.0
	ResearchWeightMilitary = 0.0
	-- End of Economy Check
	end
	-- End of Economy Check
--[[
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightNation: " .. tostring(ResearchWeightNation) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightMilitary: " .. tostring(ResearchWeightMilitary) )
]]
	-- Check for special research fields like Space Race, Nukes or Political research wich will be taken from Nation/Military
	local NuclearChk = nil
	if (GDPSizeChk > 4) then NuclearChk = true end
	if NuclearChk then
		ResearchWeightNation = ResearchWeightNation - 0.08		-- Basic Nation related research - Will be split up later
		ResearchWeightMilitary = ResearchWeightMilitary - 0.07 		-- Basic Military related research - Will be split up later
		ResearchWeightNuclear = ResearchWeightNuclear + 0.15 		-- Nuclear base research
	-- End of NuclearChk Check
	end
	-- End of NuclearChk Check

	-- local SpaceChk = check for space race decision? and if true assume "major enough" country, so delete some % from both general
	-- need additional check military focus, so military gets some more
	local SpaceChk = nil
	if (GDPSizeChk > 5) then SpaceChk = true end
	if SpaceChk then
		ResearchWeightNation = ResearchWeightNation - 0.07		-- Basic Nation related research - Will be split up later
		ResearchWeightMilitary = ResearchWeightMilitary - 0.08 		-- Basic Military related research - Will be split up later
		ResearchWeightSpace = ResearchWeightSpace + 0.15			-- Space Race research
	-- End of SpaceChk Check
	end
	-- End of SpaceChk Check

	-- local PoliticalChk = check for Ideology(facist) or theocracy gov or if in faction NATO/WP
	local PoliticalChk = nil
	if FactionName == ("comintern" or "allies") then
		PoliticalChk = true
	end
	if (GDPSizeChk > 2) then PoliticalChk = true end
	if PoliticalChk then
		ResearchWeightNation = ResearchWeightNation - 0.05		-- Basic Nation related research - Will be split up later
		ResearchWeightMilitary = ResearchWeightMilitary - 0.05 		-- Basic Military related research - Will be split up later
		ResearchWeightPolitical = ResearchWeightPolitical + 0.10 		-- Special poitical research of doctrines(NATO/WP/Theocracy etc..)
	-- End of PoliticalChk Check
	end
	-- End of PoliticalChk Check	


	-- Military research distribution/split up
	if SeaAvail then											-- If ports present
		if AirAvail then										-- Check also for airfields
			if GDPSizeChk > 2 then							-- Then split up between all 3 branches by eco power
				if GDPSizeChk > 3 then
					if GDPSizeChk > 4 then					-- Strongest eco and air/naval present, split up equally
						ResearchWeightArmy = 0.40
						ResearchWeightNavy = 0.30
						ResearchWeightAirforce = 0.30
					else										-- Medium eco and air/naval present, split up in favour of land and land/air equally
					ResearchWeightArmy = 0.50
					ResearchWeightNavy = 0.25
					ResearchWeightAirforce = 0.25
					end
				else											-- Small eco and air/naval present, split up more in favour of land and land/air equally
				ResearchWeightArmy = 0.60
				ResearchWeightNavy = 0.20
				ResearchWeightAirforce = 0.20
				end
			else												-- Below small eco and air/naval present, split up much more in favour of land and land/air equally
			ResearchWeightArmy = 0.80
			ResearchWeightNavy = 0.10
			ResearchWeightAirforce = 0.10
			end
		elseif GDPSizeChk > 2 then							-- So no airfiels at hand, so split up only between land and naval, by eco power
			if GDPSizeChk > 3 then
				if GDPSizeChk > 4 then
					ResearchWeightArmy = 0.60
					ResearchWeightNavy = 0.40
				else
				ResearchWeightArmy = 0.70
				ResearchWeightNavy = 0.30
				end
			else
			ResearchWeightArmy = 0.80
			ResearchWeightNavy = 0.20
			end
		else
		ResearchWeightArmy = 0.90
		ResearchWeightNavy = 0.10
		end
	elseif AirAvail then								-- So no ports at hand, so split up only between land and air, by eco power
		if GDPSizeChk > 2 then
			if GDPSizeChk > 3 then
				if GDPSizeChk > 4 then
					ResearchWeightArmy = 0.60
					ResearchWeightAirforce = 0.40
				else
				ResearchWeightArmy = 0.70
				ResearchWeightAirforce = 0.30
				end
			else
			ResearchWeightArmy = 0.80
			ResearchWeightAirforce = 0.20
			end
		else
		ResearchWeightArmy = 0.90
		ResearchWeightAirforce = 0.10
		end
	else													-- So no airfiels or ports present, so all for land
	ResearchWeightArmy = 1.00

	-- End of Military research distribution
	end
	-- End of Military research distribution



	-- #############################
	-- ## End of Basic research weight initialisation
--[[
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightNation: " .. tostring(ResearchWeightNation) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightMilitary: " .. tostring(ResearchWeightMilitary) )

Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightScience: " .. tostring(ResearchWeightScience) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightIndustry: " .. tostring(ResearchWeightIndustry) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightEspionage: " .. tostring(ResearchWeightEspionage) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightNuclear: " .. tostring(ResearchWeightNuclear) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightSpace: " .. tostring(ResearchWeightSpace) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightPolitical: " .. tostring(ResearchWeightPolitical) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightArmy: " .. tostring(ResearchWeightArmy) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightNavy: " .. tostring(ResearchWeightNavy) )
Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " ResearchWeightAirforce: " .. tostring(ResearchWeightAirforce) )
]]
	-- ## Start of special research weight adjustement
	-- #############################
	-- Other areas(Science/Industry/Espionage) might get also some buffs here depending on decsions etc. - So that could be added here or later in more detailed sub-areas.

	-- Start Armament Policy influence check to weight the research more in favour of the active policy
	-- note: change this to index to safe query -> Ask table!
	local ArmamentPolicy = CPolicyDataBase.GetPolicy(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.CurrentPolicy)
	local ArmamentPolicyName = ArmamentPolicy:GetKey()
	-- Check for Military focus
	-- check for policies land focus or decsions taken
	if (ArmamentPolicyName == "conventional_warfare_focus_pol" or "combined_arms_focus_pol" or "assymetric_warfare_focus_pol") then
		ResearchWeightArmy = (ResearchWeightArmy + 0.10)
		ResearchWeightNavy = (ResearchWeightNavy - 0.05)
		ResearchWeightAirforce = (ResearchWeightAirforce - 0.05)
	-- check for policies naval focus or decsions taken
	elseif (ArmamentPolicyName == "littoral_waters_focus_pol" or "blue_waters_focus_pol" or "submarine_focus_pol") and SeaAvail then
		ResearchWeightArmy = (ResearchWeightArmy - 0.10)
		ResearchWeightNavy = (ResearchWeightNavy + 0.10)
		--ResearchWeightAirforce = (ResearchWeightAirforce - 0.05)
	-- check for policies air focus or decsions taken
	elseif (ArmamentPolicyName == "fighter_focus_pol" or "bomber_focus_pol" or "close_air_support_focus_pol") and AirAvail then
		ResearchWeightArmy = (ResearchWeightArmy - 0.10)
		--ResearchWeightNavy = (ResearchWeightNavy - 0.05)
		ResearchWeightAirforce = (ResearchWeightAirforce + 0.10)
	end
	-- End of AirFocusChk Check	
	-- End of Armament Policy influence check to weight the research more in favour of the active policy

	-- Check for Nation focus
	-- local NationFocusChk = check for policies land focus or decsions taken
	local NationFocusChk = nil
	if NationFocusChk == "Science" then									-- Add later checks maybe for decsions or country flags
		ResearchWeightScience = 0.70
		ResearchWeightIndustry = 0.15
		ResearchWeightEspionage = 0.15
	elseif NationFocusChk == "Industry" then							-- Add later checks maybe for decsions or country flags
		ResearchWeightScience = 0.15
		ResearchWeightIndustry = 0.70
		ResearchWeightEspionage = 0.15
	elseif NationFocusChk == "Espionage" then							-- Add later checks maybe for decsions or country flags
		ResearchWeightScience = 0.35
		ResearchWeightIndustry = 0.35
		ResearchWeightEspionage = 0.30
	else
	--ResearchWeightScience = 0.40
	--ResearchWeightIndustry = 0.40
	--ResearchWeightEspionage = 0.20
	end

	-- #############################
	-- ## End of special research weight adjustement

	-- Nation specific calculated on ResearchWeightNation
	ResearchWeightScience = (ResearchWeightScience * ResearchWeightNation)
	ResearchWeightIndustry = (ResearchWeightIndustry * ResearchWeightNation)
	ResearchWeightEspionage = (ResearchWeightEspionage * ResearchWeightNation)
	-- Military specific calculated on ResearchWeightMilitary
	ResearchWeightArmy = (ResearchWeightArmy * ResearchWeightMilitary)
	ResearchWeightNavy = (ResearchWeightNavy * ResearchWeightMilitary)
	ResearchWeightAirforce = (ResearchWeightAirforce * ResearchWeightMilitary)
--[[
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightScience: " .. tostring(ResearchWeightScience) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightIndustry: " .. tostring(ResearchWeightIndustry) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightEspionage: " .. tostring(ResearchWeightEspionage) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightNuclear: " .. tostring(ResearchWeightNuclear) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightSpace: " .. tostring(ResearchWeightSpace) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightPolitical: " .. tostring(ResearchWeightPolitical) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightArmy: " .. tostring(ResearchWeightArmy) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightNavy: " .. tostring(ResearchWeightNavy) )
Utils.LUA_DEBUGOUT("Research - 2 - " .. tostring(ActTag) .. " ResearchWeightAirforce: " .. tostring(ResearchWeightAirforce) )
]]
	-- ## Start research weight adjustment on current research
	-- #############################
	local FactionBasedCount = 0
	local LandDoctrinesCount = 0
	local NavalDoctrinesCount = 0
	local AirDoctrinesCount = 0
	local ScienceCount = 0
	local IndustrialCount = 0
	local EspionageCount = 0
	local NuclearCount = 0
	local SpaceCount = 0
	local LandBasedCount = 0
	local NavalBasedCount = 0
	local AirBasedCount = 0
	local OtherCount = 0
	local TechFolder

	local DoctrinesTechCount = 0
	local UnitsTechCount = 0
	local CountryTechCount = 0
	local TotalTechCount = 0

	-- Counts of regular research of the AI
	for tech in ActCountry:GetCurrentResearch() do
		TechFolder = tostring(tech:GetFolder():GetKey())

		if TechFolder == "nato_doctrine1_folder" or TechFolder == "warsaw_doctrine1_folder" then
			FactionBasedCount = FactionBasedCount + 1											-- Factions
		elseif TechFolder == "land_doctrine1_folder" or TechFolder == "land_doctrine2_folder"  or TechFolder == "combined_doctrine1_folder" then
			LandDoctrinesCount = LandDoctrinesCount + 1											-- Land Doctrines
		elseif TechFolder == "naval_doctrine1_folder" or TechFolder == "naval_doctrine2_folder" then
			NavalDoctrinesCount = NavalDoctrinesCount + 1										-- Sea Doctrines
		elseif TechFolder == "air_doctrine1_folder" or TechFolder == "air_doctrine2_folder" then
			AirDoctrinesCount = AirDoctrinesCount + 1											-- Air Doctrines
		elseif TechFolder == "general_tech2_folder" then
			ScienceCount = ScienceCount + 1														-- Science
		elseif TechFolder == "industrial_tech1_folder" then
			IndustrialCount = IndustrialCount + 1												-- Industrial
		elseif TechFolder == "general_tech1_folder" then
			EspionageCount = EspionageCount + 1													-- Espionage
		elseif TechFolder == "nuclear_tech1_folder" then
			NuclearCount = NuclearCount + 1														-- Nuclear
		elseif TechFolder == "space_tech1_folder" then
			SpaceCount = SpaceCount + 1															-- Space
		elseif TechFolder == "land_tech1_folder" or TechFolder == "land_tech2_folder" then
			LandBasedCount = LandBasedCount + 1													-- Land Technologies
		elseif TechFolder == "naval_tech1_folder" or TechFolder == "naval_tech2_folder" or TechFolder == "naval_tech3_folder" then
			NavalBasedCount = NavalBasedCount + 1												-- Sea Technologies
		elseif TechFolder == "air_tech1_folder" or TechFolder == "air_tech2_folder" then
			AirBasedCount = AirBasedCount + 1													-- Air Technologies
		else
			OtherCount = OtherCount + 1
		end
	end
	-- Counts of research Goals of the AI
	for tech in ActCountry:GetCurrentGoals() do
		TechFolder = tostring(tech:GetFolder():GetKey())

		if TechFolder == "nato_doctrine1_folder" or TechFolder == "warsaw_doctrine1_folder" then
			FactionBasedCount = FactionBasedCount + 1											-- Factions
		elseif TechFolder == "land_doctrine1_folder" or TechFolder == "land_doctrine2_folder"  or TechFolder == "combined_doctrine1_folder" then
			LandDoctrinesCount = LandDoctrinesCount + 1											-- Land Doctrines
		elseif TechFolder == "naval_doctrine1_folder" or TechFolder == "naval_doctrine2_folder" then
			NavalDoctrinesCount = NavalDoctrinesCount + 1										-- Sea Doctrines
		elseif TechFolder == "air_doctrine1_folder" or TechFolder == "air_doctrine2_folder" then
			AirDoctrinesCount = AirDoctrinesCount + 1											-- Air Doctrines
		elseif TechFolder == "general_tech2_folder" then
			ScienceCount = ScienceCount + 1														-- Science
		elseif TechFolder == "industrial_tech1_folder" then
			IndustrialCount = IndustrialCount + 1												-- Industrial
		elseif TechFolder == "general_tech1_folder" then
			EspionageCount = EspionageCount + 1													-- Espionage
		elseif TechFolder == "nuclear_tech1_folder" then
			NuclearCount = NuclearCount + 1														-- Nuclear
		elseif TechFolder == "space_tech1_folder" then
			SpaceCount = SpaceCount + 1															-- Space
		elseif TechFolder == "land_tech1_folder" or TechFolder == "land_tech2_folder" then
			LandBasedCount = LandBasedCount + 1													-- Land Technologies
		elseif TechFolder == "naval_tech1_folder" or TechFolder == "naval_tech2_folder" or TechFolder == "naval_tech3_folder" then
			NavalBasedCount = NavalBasedCount + 1												-- Sea Technologies
		elseif TechFolder == "air_tech1_folder" or TechFolder == "air_tech2_folder" then
			AirBasedCount = AirBasedCount + 1													-- Air Technologies
		else
			OtherCount = OtherCount + 1
		end
	end

	local DoctrinesTechCount = ((FactionBasedCount + LandDoctrinesCount) + (NavalDoctrinesCount + AirDoctrinesCount))
	local UnitsTechCount = ((LandBasedCount + NavalBasedCount) + (AirBasedCount + OtherCount))
	local CountryTechCount = ((ScienceCount + IndustrialCount) + (EspionageCount + NuclearCount) + SpaceCount)
	TotalTechCount = ((DoctrinesTechCount + UnitsTechCount) + CountryTechCount)
	
	-- Ratio change if research already ongoing
	local ResearchWeightPoliticalChk = ((TotalTechCount / FactionBasedCount) * 0.01)						-- Political
	if ResearchWeightPoliticalChk > ResearchWeightPolitical then
		ResearchWeightPolitical = 0
	elseif ResearchWeightPoliticalChk > 0 then
		ResearchWeightPolitical = ResearchWeightPolitical - ResearchWeightPoliticalChk
	end
	local ResearchWeightEspionageChk = ((TotalTechCount / EspionageCount) * 0.01)							-- Espionage
	if ResearchWeightEspionageChk > ResearchWeightEspionage then
		ResearchWeightEspionage = 0
	elseif ResearchWeightEspionageChk > 0 then
		ResearchWeightEspionage = ResearchWeightEspionage - ResearchWeightEspionageChk
	end
	local ResearchWeightNuclearChk = ((TotalTechCount / NuclearCount) * 0.01)								-- Nuclear
	if ResearchWeightNuclearChk > ResearchWeightNuclear then
		ResearchWeightNuclear = 0
	elseif ResearchWeightNuclearChk > 0 then
		ResearchWeightNuclear = ResearchWeightNuclear - ResearchWeightNuclearChk
	end
	local ResearchWeightSpaceChk = ((TotalTechCount / SpaceCount) * 0.01)									-- Space
	if ResearchWeightSpaceChk > ResearchWeightSpace then
		ResearchWeightSpace = 0
	elseif ResearchWeightSpaceChk > 0 then
		ResearchWeightSpace = ResearchWeightSpace - ResearchWeightSpaceChk
	end
	local ResearchWeightScienceChk = ((TotalTechCount / ScienceCount) * 0.01)								-- Science
	if ResearchWeightScienceChk > ResearchWeightScience then
		ResearchWeightScience = 0
	elseif ResearchWeightScienceChk > 0 then
		ResearchWeightScience = ResearchWeightScience - ResearchWeightScienceChk
	end
	local ResearchWeightIndustryChk = ((TotalTechCount / IndustrialCount) * 0.01)							-- Industry
	if ResearchWeightIndustryChk > ResearchWeightIndustry then
		ResearchWeightIndustry = 0
	elseif ResearchWeightIndustryChk > 0 then
		ResearchWeightIndustry = ResearchWeightIndustry - ResearchWeightIndustryChk
	end
	local ResearchWeightArmyChk = ((TotalTechCount / (LandBasedCount + LandDoctrinesCount)) * 0.01)			-- Army
	if ResearchWeightArmyChk > ResearchWeightArmy then
		ResearchWeightArmy = 0
	elseif ResearchWeightArmyChk > 0 then
		ResearchWeightArmy = ResearchWeightArmy - ResearchWeightArmyChk
	end
	local ResearchWeightNavyChk = ((TotalTechCount / (NavalBasedCount + NavalDoctrinesCount)) * 0.01)		-- Navy
	if ResearchWeightNavyChk > ResearchWeightNavy then
		ResearchWeightNavy = 0
	elseif ResearchWeightNavyChk > 0 then
		ResearchWeightNavy = ResearchWeightNavy - ResearchWeightNavyChk
	end
	local ResearchWeightAirforceChk = ((TotalTechCount / (AirBasedCount + AirDoctrinesCount)) * 0.01)		-- Air Force
	if ResearchWeightAirforceChk > ResearchWeightAirforce then
		ResearchWeightAirforce = 0
	elseif ResearchWeightAirforceChk > 0 then
		ResearchWeightAirforce = ResearchWeightAirforce - ResearchWeightAirforceChk
	end

	-- #############################
	-- ## End research weight adjustment on current research
--[[

Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightScience: " .. tostring(ResearchWeightScience) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightIndustry: " .. tostring(ResearchWeightIndustry) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightEspionage: " .. tostring(ResearchWeightEspionage) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightNuclear: " .. tostring(ResearchWeightNuclear) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightSpace: " .. tostring(ResearchWeightSpace) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightPolitical: " .. tostring(ResearchWeightPolitical) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightArmy: " .. tostring(ResearchWeightArmy) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightNavy: " .. tostring(ResearchWeightNavy) )
Utils.LUA_DEBUGOUT("Research - 3 - " .. tostring(ActTag) .. " ResearchWeightAirforce: " .. tostring(ResearchWeightAirforce) )
]]
	-- ## Start of Money allocation
	-- #############################
	local MoneyScience = 0
	local MoneyIndustry = 0
	local MoneyEspionage = 0
	MoneyScience = rounddown(ResearchWeightScience * ActMoney)										-- MoneyScience
	MoneyIndustry = rounddown(ResearchWeightIndustry * ActMoney)									-- MoneyIndustry
	MoneyEspionage = rounddown(ResearchWeightEspionage * ActMoney)									-- MoneyEspionage
	local MoneyNuclear = 0																			-- MoneyNuclear
	MoneyNuclear = rounddown(ResearchWeightNuclear * ActMoney)
	local MoneySpace = 0																			-- MoneySpace
	MoneySpace = rounddown(ResearchWeightSpace * ActMoney)
	local MoneyPolitical = 0																		-- MoneyPolitical
	MoneyPolitical = rounddown(ResearchWeightPolitical * ActMoney)
	local MoneyArmyDoctrines = 0
	local MoneyNavyDoctrines = 0
	local MoneyAirforceDoctrines = 0
	local DoctrinessModifier = 0.35
	local UnitsModifier = 0.65
	MoneyArmyDoctrines = rounddown((ResearchWeightArmy * ActMoney) * DoctrinessModifier)				-- MoneyArmy
	MoneyNavyDoctrines = rounddown((ResearchWeightNavy * ActMoney) * DoctrinessModifier)				-- MoneyNavy
	MoneyAirforceDoctrines = rounddown((ResearchWeightAirforce * ActMoney) * DoctrinessModifier)		-- MoneyAirforce
	local MoneyArmyUnits = 0
	local MoneyNavyUnits = 0
	local MoneyAirforceUnits = 0
	MoneyArmyUnits = rounddown((ResearchWeightArmy * ActMoney) * UnitsModifier)						-- MoneyArmy
	MoneyNavyUnits = rounddown((ResearchWeightNavy * ActMoney) * UnitsModifier)						-- MoneyNavy
	MoneyAirforceUnits = rounddown((ResearchWeightAirforce * ActMoney) * UnitsModifier)				-- MoneyAirforce
	-- #############################
	-- ## End of Money allocation

--[[
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyScience: " .. tostring(MoneyScience) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyIndustry: " .. tostring(MoneyIndustry) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyEspionage: " .. tostring(MoneyEspionage) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyNuclear: " .. tostring(MoneyNuclear) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneySpace: " .. tostring(MoneySpace) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyPolitical: " .. tostring(MoneyPolitical) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyArmyDoctrines: " .. tostring(MoneyArmyDoctrines) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyNavyDoctrines: " .. tostring(MoneyNavyDoctrines) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyAirforceDoctrines: " .. tostring(MoneyAirforceDoctrines) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyArmyUnits: " .. tostring(MoneyArmyUnits) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyNavyUnits: " .. tostring(MoneyNavyUnits) )
Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " MoneyAirforceUnits: " .. tostring(MoneyAirforceUnits) )
]]

	-- ## Start of tech gathering
	-- #############################
-- All main tech folders below

-- 1 nato_doctrine1_folder 
local NATO = {
	--Mil Doctrine
	"nato_integrated_mil_structure",
	"nato_political_pluralism",
	"nato_joint_nonpoliticalcontrol",
	--Economy
	"nato_rational_choice_theory",
	"nato_efficient_markethypothesis",
	"nato_planned_obsolescence",
	"nato_consumerism",
	"nato_keynesian_economics",
	"nato_greatsociety",
	"nato_supplyside_economics",
	--Politics
	"nato_containment_doctrine",
	"nato_radio_liberty",
	"nato_loyalty_program",
	"nato_peacethroughpartnership",
	"nato_rollback_doctrine",
	--Nuke?
	"nato_duckandcover",
	--Units
	"supercarrier_doctrine",
	"nuclearmissilecruiser_doctrine",
	"naval_combat_system"
}

-- 2 warsaw_doctrine1_folder
local WarsawPact = {
	--Mil Doctr.
	"warsaw_thought_reform",
	"warsaw_young_pioneer",
	"warsaw_political_commissars",
	--Economy
	"warsaw_historical_materialism",
	"warsaw_dialectical_materialism",
	--Political
	"warsaw_marxist-leninist_doctrine",
	"warsaw_permanent_revolution",
	"warsaw_democratic_centralism",
	"warsaw_stalinist_doctrine",
	"warsaw_socialism_in_one_country",
	"warsaw_cult_of_personality",
	"warsaw_maoist_doctrine",
	"warsaw_new_democratic_revolution",
	"warsaw_cultural_revolution",
	--Weapons
	"antishipmissile_shortrange_supersonic",
	"antishipmissile_longrange_supersonic",
	"torpedoes_supercavitating",
	--Units
	"unit_submarine_superlarge",
	"nuclearbattlecruiser_doctrine"
}

-- 3 combined_doctrine1_folder
local CombinedDoctrines = {
	"comb_supreme_leader",
	"comb_theocratic_doctrine",
	"comb_religious_police",
	"comb_holywar",
	"comb_fascist_doctrine",
	"comb_national_identity",
	"comb_thought_reform",
	"comb_youth_movement",
	"comb_informal_control",
	"comb_foreign_legion",
	"comb_colonial_army",
	"comb_paramilitary_recruitment"
}

-- 4 land_doctrine1_folder
local LandDoctrines = {
	--Second Generation Warfare
	"mass_firepower",
	"centralized_command_and_control",
	"military_deception",
	"attrition_warfare",
	"linear_fire_and_movement",
	"indirect_artillery_fire",
	"shock_attacks",
	"infiltration_tactics",
	"specialist_tactics",
	--Third Generation Warfare
	"maneuver_warfare",
	"mechanized_warfare",
	"human_wave_attack",
	"swarming_tactics",
	"hedgehog_defense",
	"elastic_defense",
	"psychological_warfare"
}

-- 5 land_doctrine2_folder
local AsymetricDoctrines = {
	--Fourth Generation Warfare
	"asymmetric_warfare",
	"low_intensity_operations",
	"inkspot_strategy",
	"flypaper_strategy",
	"recondo_school",
	"guerrilla_war_warfare",
	"bait_tactics",
	"propaganda_warfare",
	"two_belt_defense_system",
	"one_slow_four_quick"
}

-- 6 naval_doctrine1_folder
local NavalDoctrines = {
	--Surface vessels
	"battlegroup_strikeoperations",
	"battlegroup_missilebattlegroup",
	"battlegroup_closeescort",
	"battlegroup_systemcoordination",
	"battlegroup_optimalcoveragepositioning",
	"carriergroup_carrierstrikegroup",
	"carriergroup_constantairbornesurveillance",
	"carriergroup_extendedfleetsupply",
	"carriergroup_aircraftpatrolpatterns",
	"carriergroup_scramble_drill",
	"aircommand_simplicityprinciple",
	"escort_submarinehunting",
	"escort_swiftpatrolswarm",
	"missileboatcoastalfleet",
	"escort_responsereadygroup",
	"escort-battlegroup_surfaceengagementpositioning",
	"escort-battlegroup_denyenemyfreedomofaction",
	"escort-battlegroup_acceptablerisk",
	"amphibious_amphibiousoperations"
}

-- 7 naval_doctrine2_folder
local HQandSub = {
	--Joint
	"joint_interserviceoperability",
	"joint_fleetcommandsystem",
	"joint_fleetsupply",
	"joint_selfsustainability",
	"joint_systemcompatibiliity",
	"joint_warliketraining",
	"joint_contingencyplanning",
	"joint_criticalvulnerability",
	--Submarines
	"hksubs_strikeoperations",
	"allsubs_autonomousoperations",
	"hksubs_submarineescorting",
	"hksubs_surfacevesselescorting",
	"hksubs_planning_dynamiccombattempotraining",
	"hksubs-surfacesubs_sensoryandweaponscommand",
	"hksubs-surfacesubs_satellitecommequipment",
	"tacticalstrikesubs-surfacesubs_coordinatedoperations",
	"allsubs_silentoperations",
	"tacticalstrikesubs_firstsecondstrikecapable"
}

-- 8 air_doctrine2_folder
local AirDoctrines = {
	--Joint/Command Principles
	"aircommand_unityofcommandprinciple",
	"aircommand_objectiveprinciple",
	"aircommand_massprinciple",
	"aircommand_securityprinciple",
	"aircommand_surpriseprinciple",
	--Pilot Focus
	"pilotfocus_areabombingtraining",
	"pilotfocus_lowlevelops",
	--Intelligence Operations
	"airintelops_airreconplanningandtraining",
	"airintelops_awacsc2doctrine",
	"airintelops_aswops",
}

-- 9 air_doctrine1_folder
local AirTactics = {
	--Combat Operations
	"aircombatops_offensiveairsuperioritydoctrine",
	"aircombatops_defensiveinterceptiondoctrine",
	"aircombatops_wildweaseloperations",
	"aircombatops_armydirectedbombing",
	--Joint/Command Principles
	"aircommand_offensiveprinciple",
	"aircommand_maneuverprinciple",
	"aircommand_economyofforceprinciple",
	--Pilot Focus
	"pilotfocus_realisticcombatexercises",
	"pilotfocus_precisionbombingtraining",
	"pilotfocus_smartweapondeliverystriketraining",
	--Logistics Operations
	"airlogisticsops_airbridgeplanningandtraining",
	"airlogisticsops_heloresupply",
	"aircommand_searchandrescuemissions",
	"airlogisticsops_mashmedevac",
	--Airborne Operations
	"airborne_warfare",
	"airborneops_airassaultplanning",
	"airborneops_paratroopers",
	"airborneops_aircavalry"
}

-- 10 general_tech2_folder
local BasicSciences = {
	"industry_modern_science",
	"industry_mathematics",
	"industry_physics",
	"industry_electronics",
	"industry_chemistry",
	"industry_biology",
	"industry_medicine",
	"industry_hightech_computers",
	"industry_softwareengineering",
	"industry_sociology",
	"industry_psychology",
	"industry_poliec"
}

-- 11 industrial_tech1_folder
local BasicIndustries = {
	"industry_heavy_mechanical_parts",
	"industry_heavy_mechanical_engineering",
	"industry_heavy_robotics",
	"industry_light_massproduction",
	"industry_light_homeappliance",
	"industry_light_plastics",
	"industry_light_economyofscale",
	"industry_agriculture_mechanized",
	"industry_agriculture_fertilizer",
	"industry_consumer_electronics",
	"industry_hightech_integratedcircuits",
	"industry_mining_mining",
	"industry_mining_oil",
	"industry_refining_refining",
	"industry_electricity",
	"industry_electricity_conversion",
	"industry_recycling",
	"industry_construction_engineering"
}

-- 12 general_tech1_folder
local Espionage = {
	"radar_general",
	"communication_and_intelligence",
	"technology_intel_encryption",
	"technology_intel_decryption",
	"technology_espionage",
	"technology_intelligence_academies",
	"technology_counter_espionage",
	"technology_agent_training",
	"technology_recording_devices",
	"technology_internal_security",
	"technology_double_agents",
	"technology_coups",
	"technology_assassins",
	"technology_hidden_cameras",
	"technology_microtransmitters",
	"technology_shell_company",
	"technology_resident_networks",
	"technology_disinformation",
	"technology_interrogation",
	"space_spysatellites"
}

-- 13 nuclear_tech1_folder
local Nuclear = {
	"nuclear_freefall_bomb",
	"tech_icbm_missile",
	"tech_slbm_missile",
	"abm_site_tech",
	--Nuclear Command
	"nuclearcommand_nuclear_strategy",
	"nuclearcommand_mad",
	"nuclearcommand_secondstrikecapability",
	"nuclearcommand_countervailingstrategy",
	"nuclearcommand_sdi",
	"nuclearcommand_nuclearnonproliferation",
	"nuclear_atomic_theory",
	"nuclear_enrichment_process",
	"nuclear_nuclear_power",
	"nuclear_delivery_systems",
	"nuclear_thermonuclear_design"
}

-- 14 space_tech1_folder
local Space = {
	"space_research_mission",
	"space_ICBM_launch_vehicle",
	"space_requirements_study",
	"space_satellite_development",
	"space_solar_energy",
	"space_orbiting_observatory",
	"space_pressurized_cockpits",
	"space_shirtsleeve_environment",
	"space_missions_manned_planning",
	"space_missions_manned_orbit",
	"space_missions_sustained",
	"space_circumlunar_orbit",
	"space_missions_moon_landing",
	"space_operations",
	"space_missions_research_station",
	"space_missions_permanent_planning",
	"space_living_conditions_requirements",
	"space_modular_design",
	"space_missions_permanent_station"
}

-- 15 land_tech1_folder
local LandVehicle = {
	"amphibious_capability",
	"desert_capability",
	"jungle_capability",
	"mountain_capability",
	"arctic_equipment",
	"night_vision",
	"engineering_equipment",
	"battlefield_medicine",
	"light_engine",
	"medium_engine",
	"heavy_engine",
	"light_armor",
	"medium_armor",
	"heavy_armor",
	"body_armor",
	"battle_tank",
	"comb_technicals",
	"comb_improved_vehic_armor"
}

-- 16 land_tech2_folder
local LandWeapons = {
	"small_arms",
	"explosives",
	"crew_served_weapons",
	"anti_tank",
	"light_artillery",
	"medium_artillery",
	"heavy_artillery",
	"rocket_artillery",
	"generalmissiledesign",
	"light_anti_air",
	"medium_anti_air",
	"heavy_anti_air",
	"aircraftweapons_guns",
	"aircraftweapons_multibarrelguns",
	"aircraftweapons_heavyrotarycannon",
	"aircraftweapons_aamissiles",
	"aircraftweapons_agordinance",
	"aircraftweapons_napalm"
}

-- 17 naval_tech3_folder
local NavalWeapons = {
	--Targeting systems
	"targetingsystems",
	"launcher_submarine_surfacefire",
	"launcher_submarine_submergefire_large",
	--Torpedo Tube Launchers
	"launcher_torpedotubes_533_650",
	"launcher_torpedotubes_external",
	"launcher_torpedotubes_surface",
	"launcher_vls",
	--CIWS and CIWS/SR complex systems
	--1-2 are pure CIWS, above 3 is defense complex
	"closedefense",
	--NAVAL GUNS
	"conventionalnavalgun",
	"torpedoes",
	--MISSILES
	"antishipmissile_shortrange",
	"antishipmissile_longrange",
	"antisub_missile",
	"antisub_torpedorocket",
	"landattackmissile",
	"antiairmissile_shortrange",
	"antiairmissile_mediumrange",
	"antiairmissile_longrange",
	"navalvessel_missilecomplex_trials",
	"radarsystem_airsearch"
}

-- 18 naval_tech1_folder
local NavalVessels = {
	"unit_carrier",
	"unit_supercarrier",
	"unit_helicoptercarrier",
	"unit_cruiser",
	"unit_missilecruiser",
	"unit_nuclearmissilecruiser",
	"unit_nuclearbattlecruiser",
	"unit_destroyer",
	"unit_missilefrigate",
	"unit_missiledestroyer",
	"unit_missileboat",
	"unit_submarine_ww2",
	"unit_submarine_teardrop",
	"unit_submarine_attack",
	"unit_nuclearsubmarine_attack",
	"unit_submarine_missile",
	"unit_nuclearsubmarine_missile",
	"unit_ballistic_missile_submarine"
}

-- 19- naval_tech2_folder
local NavalEquipment = {
	--Propulsions
	"propulsion_steam",
	"propulsion_gas",
	"propulsion_diesel_surface_40s",
	"propulsion_diesel_submarine",
	"propulsion_nuclear",
	"propulsion_nuclear_surface",
	"propulsion_nuclear_submarine",
	"nuclearpropulsion_trials_submarine",
	"nuclearpropulsion_trials_surfacevessel",
	--Air Search Radars
	"radarsystem_3dsearch",
	"radarsystem_surfacesearch",
	--Sonar Systems
	"sonarsystem",
	"towed_sonarsystem",
	"torpedodefensesystem",
	--Helicopters and platforms
	"helicopterplatform"
}

-- 20 air_tech1_folder
local Planes = {
	--# All model-specific techs below generally raise all (relevant) values for that type.
	"aircraft_fighter",
	"aircraft_multirole",
	"aircraft_cas",
	"aircraft_carrier_fighter",
	"aircraft_carrier_multirole",
	"aircraft_carrier_attack",
	"aircraft_carrier_vtol",
	"aircraft_strikebomber",
	"aircraft_strategicbomber",
	"aircraft_maritimebomber",
	"aircraft_antisubbomber",
	"aircraft_transport",
	"aircraft_reconnaissance",
	"aircraft_awacs",
	"helicopter_gunship",
	"helicopter_cas",
	"helicopter_maritime"
	}

-- 21- air_tech2_folder
local AirTechnology = {
	"engine_turbojet_small",
	"engine_turbojet_medium",
	"engine_afterburner",
	"engine_turbojet_large",
	"engine_rocket",
	"airframewing_speed",
	"airframewing_lift",
	"helicopter_body",
	"aerodynamics",
	"aircraftavionics",
	"aircraftcountermeasures"
	--#stealth_basicconcepts
	--#stealth_lowradarvisibility
	--#stealth_silencing
}

local ResearchList = {}
local MoneyTable = {}
local LandListDoctrines = {}
local SeaListDoctrines = {}
local AirListDoctrines = {}
local LandListUnits = {}
local SeaListUnits = {}
local AirListUnits = {}
local OverMoney = 0
local BasicResearchScore = nil
BasicResearchScore = 5
local ResearchListCount = 1


if (GDPSizeChk > 0) then
	-- Science
	ResearchList[ResearchListCount] = BasicSciences
	MoneyTable[ResearchListCount] = MoneyScience
	ResearchListCount = ResearchListCount + 1

	-- Industry
	ResearchList[ResearchListCount] = BasicIndustries
	MoneyTable[ResearchListCount] = MoneyIndustry
	ResearchListCount = ResearchListCount + 1


	if (GDPSizeChk > 1) then

		-- Espionage
		ResearchList[ResearchListCount] = Espionage
		MoneyTable[ResearchListCount] = MoneyEspionage
		ResearchListCount = ResearchListCount + 1

		-- Land
		for _,Tech in pairs(CombinedDoctrines) do
			table.insert(LandListDoctrines, Tech)
		end
		for _,Tech in pairs(LandDoctrines) do
			table.insert(LandListDoctrines, Tech)
		end
		ResearchList[ResearchListCount] = LandListDoctrines
		MoneyTable[ResearchListCount] = MoneyArmyDoctrines
		ResearchListCount = ResearchListCount + 1

		for _,Tech in pairs(LandVehicle) do
			table.insert(LandListUnits, Tech)
		end
		for _,Tech in pairs(LandWeapons) do
			table.insert(LandListUnits, Tech)
		end
		ResearchList[ResearchListCount] = LandListUnits
		MoneyTable[ResearchListCount] = MoneyArmyUnits
		ResearchListCount = ResearchListCount + 1


		if (GDPSizeChk > 2) then
			-- Sea
			for _,Tech in pairs(NavalDoctrines) do
				table.insert(SeaListDoctrines, Tech)
			end
			for _,Tech in pairs(HQandSub) do
				table.insert(SeaListDoctrines, Tech)
			end
			ResearchList[ResearchListCount] = SeaListDoctrines
			MoneyTable[ResearchListCount] = MoneyNavyDoctrines
			ResearchListCount = ResearchListCount + 1

			for _,Tech in pairs(NavalWeapons) do
				table.insert(SeaListUnits, Tech)
			end
			for _,Tech in pairs(NavalVessels) do
				table.insert(SeaListUnits, Tech)
			end
			for _,Tech in pairs(NavalEquipment) do
				table.insert(SeaListUnits, Tech)
			end
			ResearchList[ResearchListCount] = SeaListUnits
			MoneyTable[ResearchListCount] = MoneyNavyUnits
			ResearchListCount = ResearchListCount + 1

			-- Air
			for _,Tech in pairs(AirDoctrines) do
				table.insert(AirListDoctrines, Tech)
			end
			for _,Tech in pairs(AirTactics) do
				table.insert(AirListDoctrines, Tech)
			end
			ResearchList[ResearchListCount] = AirListDoctrines
			MoneyTable[ResearchListCount] = MoneyAirforceDoctrines
			ResearchListCount = ResearchListCount + 1

			for _,Tech in pairs(Planes) do
				table.insert(AirListUnits, Tech)
			end
			for _,Tech in pairs(AirTechnology) do
				table.insert(AirListUnits, Tech)
			end
			ResearchList[ResearchListCount] = AirListUnits
			MoneyTable[ResearchListCount] = MoneyAirforceUnits
			ResearchListCount = ResearchListCount + 1

			if (GDPSizeChk > 3) then
				-- Political
				local PolListName = NATO
				if FactionName == "comintern" then PolListName = WarsawPact end
				ResearchList[ResearchListCount] = PolListName
				MoneyTable[ResearchListCount] = MoneyPolitical
				ResearchListCount = ResearchListCount + 1
--Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " GDPSizeChk > 3: " .. " PolListName: " .. tostring(PolListName) )

				if (GDPSizeChk > 4) then
					-- Nuclear
					ResearchList[ResearchListCount] = Nuclear
					MoneyTable[ResearchListCount] = MoneyNuclear
					ResearchListCount = ResearchListCount + 1					
									
					if (GDPSizeChk > 5) then
						-- Space
						ResearchList[ResearchListCount] = Space
						MoneyTable[ResearchListCount] = MoneySpace
						ResearchListCount = ResearchListCount + 1
					end
				end
			end
		end
	end
end	

--[[
for _,Tech in pairs(LandListUnits) do	
	Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " LandListUnits: " .. " Tech: " .. tostring(Tech) )
end
for _,Tech in pairs(SeaListUnits) do	
	Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " SeaListUnits: " .. " Tech: " .. tostring(Tech) )
end
for _,Tech in pairs(AirListUnits) do	
	Utils.LUA_DEBUGOUT("Research -" .. tostring(ActTag) .. " AirListUnits: " .. " Tech: " .. tostring(Tech) )
end
]]
	-- #############################
	-- ## End of tech gathering 

	-- ## Start of research initialisation
	-- #############################
--local EGYTag = CCountryDataBase.GetTag('EGY')
local TechDB = CTechnologyDataBase.GetTechnology

	for i = 1, #ResearchList do
		local TechList = {}						-- Need reset for each group
		local SortedTechList = {}
		local ResearchMoney = MoneyTable[i]

			for _,Tech in pairs(ResearchList[i]) do			--Fill in the scored TechLists
				
				-- Add random factor to score
				local RandX = GetRandom(7)
				local Score = 1 + RandX
				-- Are we ahead or behind in research? Add bonus/malus
				local AllowedTechlvl = (46 + (TechStatus:GetLevel(TechDB(Tech)) * 4))
					
--Utils.LUA_DEBUGOUT("Research List -" .. tostring(ActTag) .. " AllowedTechlvl: " .. tostring(AllowedTechlvl) .. " Tech: " .. tostring(Tech) )

				if ActYear >= AllowedTechlvl then
					if ActYear >= (AllowedTechlvl + 4) then
						if ActYear >= (AllowedTechlvl + 8) then
							if ActYear >= (AllowedTechlvl + 12) then
								Score = Score + 12
							else
								Score = Score + 8
							end
						else
							Score = Score + 4
						end
					else
						Score = Score + 2
					end
				elseif ActYear < AllowedTechlvl then
					if (ActYear + 4) < AllowedTechlvl then
						if (ActYear + 8) < AllowedTechlvl then
							if (ActYear + 12) < AllowedTechlvl then
								Score = Score - 12
							else
								Score = Score - 8
							end
						else
							Score = Score - 4
						end
					else
						Score = Score - 2
					end
				end

				-- Add more score changes if needed here
				-- if tech == "industry_psychology" then score = 100 end

				TechList[Score] = Tech
				table.insert(SortedTechList, { Score, Tech })

--Utils.LUA_DEBUGOUT("Scored Tech -" .. tostring(ActTag) .. " Initial scoring: " .. tostring(Score) .. " Score: " .. tostring(Tech) )
			end

			-- Sorting Start
			table.sort(SortedTechList,comp)
			local RegularList = {}
			local GoalList = {}
			for j = 1, #SortedTechList do

--Utils.LUA_DEBUGOUT("SortedTechList -" .. tostring(ActTag) .. " Check: " .. tostring(SortedTechList[j][1]) .. " Score: " .. tostring(SortedTechList[j][2]) )

				if TechStatus:CanResearch(TechDB(SortedTechList[j][2])) and (TechDB(SortedTechList[j][2])):IsValid() then
					table.insert(RegularList, (SortedTechList[j][2]))
				elseif (TechDB(SortedTechList[j][2])):IsValid() then
					table.insert(GoalList, (SortedTechList[j][2]))
				end
			end
			-- Sorting End
			
			local GoalNr = #GoalList
			local RegNr = #RegularList

--Utils.LUA_DEBUGOUT("LISTEN -" .. tostring(ActTag) .. " REGULAR: " .. tostring(RegNr) )
--Utils.LUA_DEBUGOUT("LISTEN -" .. tostring(ActTag) .. " GOAL: " .. tostring(GoalNr) )
--Utils.LUA_DEBUGOUT("LISTEN -" .. tostring(ActTag) .. " MONEY: " .. tostring(ResearchMoney) )	

			-- Research Start
			local RegularCheck = nil
			local GoalCheck = nil
			if ResearchMoney > 0 then
				for k = 1, #RegularList do
					local Stopit = nil
					if ResearchMoney > 0 then
					local techcost = (TechDB(RegularList[k])):GetCost()

--Utils.LUA_DEBUGOUT("RegularList -" .. tostring(ActTag) .. " REGULAR-TECH-COST: " .. tostring(techcost) )
--Utils.LUA_DEBUGOUT("RegularList -" .. tostring(ActTag) .. " REGULAR-TECH: " .. tostring(RegularList[k]) )
--Utils.LUA_DEBUGOUT("RegularList -" .. tostring(ActTag) .. " REGULAR-#: " .. tostring(k) )

						ActAI:Post(CStartResearchCommand(ActTag, (TechDB(RegularList[k]))))
						ResearchMoney = (ResearchMoney - techcost) --(TechDB(RegularList[k])):GetCost()
--Utils.LUA_DEBUGOUT("RegularList -" .. tostring(ActTag) .. " After substraction MONEY: " .. tostring(ResearchMoney) )
					else
						Stopit = true			-- Do we have free money to research?
					end
					if Stopit then 
						RegularCheck = true
						break
					end
				end

				RegularCheck = true
				end
				
				for m = 1, #GoalList do
--Utils.LUA_DEBUGOUT("GoalList -" .. tostring(ActTag) .. " GOAL-Number: " .. tostring(m) )
--Utils.LUA_DEBUGOUT("GoalList -" .. tostring(ActTag) .. " GOAL-Tech: " .. tostring(GoalList[m]) )
--Utils.LUA_DEBUGOUT("GoalList -" .. tostring(ActTag) .. " MONEY: " .. tostring(ResearchMoney) )

					local Stopit = nil
					if ResearchMoney > 0 then

						local techcost2 = (TechDB(GoalList[m])):GetCost()
--Utils.LUA_DEBUGOUT("GoalList -" .. tostring(ActTag) .. " TECH-COST: " .. tostring(techcost2) )
--Utils.LUA_DEBUGOUT("GoalList -" .. tostring(ActTag) .. " Stopit: " .. tostring(Stopit) )

						ActCountry:AddGoal(tostring(GoalList[m]))
						ResearchMoney = ResearchMoney - (TechDB(GoalList[m])):GetCost()
--Utils.LUA_DEBUGOUT("GoalList -" .. tostring(ActTag) .. " After substraction MONEY: " .. tostring(ResearchMoney) )
					else
						Stopit = true			-- Do we have free money to research?
					end
					if Stopit then 
						GoalCheck = true
						break
					end
				
				GoalCheck = true
				end
--Utils.LUA_DEBUGOUT("CHECK -" .. tostring(ActTag) .. " RegularCheck: " .. tostring(RegularCheck) )
--Utils.LUA_DEBUGOUT("CHECK -" .. tostring(ActTag) .. " Goal-Check: " .. tostring(GoalCheck) )
--Utils.LUA_DEBUGOUT("CHECK -" .. tostring(ActTag) .. " Money: " .. tostring(ResearchMoney) )

			-- Research End
			-- "OverMoney"(Maybe not needed) for use of additional other techs?
			-- if RegularCheck and GoalCheck then OverMoney = OverMoney + ResearchMoney end
	end
	--For loop research end


	-- #############################
	-- ## End of research initialisation

	-- end of Research
	end
-- #############################
-- ## End of Research


-- end of main method
end
-- ###############################################
-- ## End of Main Method called by the EXE
-- ###############################################

function comp(v1,v2)
	if v1[1] > v2[1] then
		return true
	end
end

-- temp help construct for debugging..
function GetTechs(ActTagTbl)

local ActYear = Grand_Country_Table["Country-" .. ActTagTbl].ActYear
local TechStatus = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus
local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
local GetRandom = math.random

local EGYTag = CCountryDataBase.GetTag('EGY')
if ActTag == EGYTag then
-- insert code here..
end


end

