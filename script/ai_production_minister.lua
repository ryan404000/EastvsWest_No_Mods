-- ###############################################
-- ## "Albert" -East vs. West- Unit Production Lua AI
-- ## Created By: Chromos	Date: 15.01.2013
-- ## Modified By: Chromos	Date: 21.02.2014
-- ###############################################
--[[
]]

-- #####################################
-- # Main Method called by the EXE
-- #####################################
function ProductionMinister_Tick(minister, fixedmoney)

	local ActMoney = fixedmoney --:Get() 100000--
	if ActMoney < 50 then
Utils.LUA_DEBUGOUT("Not enough money..(Unit production)")
		return
	end

-- ## Start Units Data Setup
-- #############################
	local minister = minister
	local ActTag = minister:GetCountryTag()
	local ActTagTbl = tostring(minister:GetCountryTag())
	local ActDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local GetRandom = math.random
	local RandNr = GetRandom(30)

-- ## Start Check for Data Tables
-- #############################
	-- Country Data Setup
	local CountryTable = Grand_Country_Table["Country-" .. ActTagTbl]			-- Just a shorter name for the long table name for better readability
	if (Grand_Country_Table["Country-" .. ActTagTbl] == nil ) then
		CountrySetup(ActTag)
	elseif (Grand_Country_Table["Country-" .. ActTagTbl].Timestamp) < (AllDays) then
		CountrySetup(ActTag)
	end
	-- New Pre-Production Check
	local Ignition = Grand_Country_Table["Ignition-" .. ActTagTbl]
	if (Ignition + 1 ) >= (AllDays) then
Utils.LUA_DEBUGOUT("-PRODUCTION-IGNITION-: " .. tostring(ActTag) .. " - " ..  tostring(Ignition) .. " - " ..  tostring(AllDays) .. " -MONEY-: " ..  tostring(ActMoney))
		return
	else
Utils.LUA_DEBUGOUT("-PRODUCTION-MONEY-: " .. tostring(ActTag) .. " - " ..  tostring(Ignition) .. " - " ..  tostring(AllDays) .. " -MONEY-: " ..  tostring(ActMoney))
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
	-- Manpower Data Setup
	local ManpowerTable = Grand_Country_Table["Manpower-" .. ActTagTbl]			-- Just a shorter name for the long table name for better readability
	if (Grand_Country_Table["Manpower-" .. ActTagTbl] == nil ) then
		ManpowerCheck(ActTagTbl)
	elseif (Grand_Country_Table["Manpower-" .. ActTagTbl].Timestamp) < (AllDays) then
		ManpowerCheck(ActTagTbl)
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

	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId
	local MobilizingNeededManpower = Grand_Country_Table["Country-" .. ActTagTbl].MobilizingNeededManpower
	local TotalAvailableManpower = Grand_Country_Table["Country-" .. ActTagTbl].TotalAvailableManpower
	local TechStatus = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus
	local SeaAvail = Grand_Country_Table["Country-" .. ActTagTbl].SeaAvail 			-- and money < 100)
	local AirAvail = Grand_Country_Table["Country-" .. ActTagTbl].AirAvail 			-- and money < 100)
	local War = Grand_Country_Table["Country-" .. ActTagTbl].War
	--local bBuildReserve = not WAR no more needed
	local tostring = tostring
	local pairs = pairs
	local tabin = table.insert
	local rounddown = math.floor

	

-- #############################
-- ## End Units Data Setup


-- ## Start initial ratio calculation
-- ##############################
	-- Check theoretical limit of manpower - Check if we are low on MP
	-- If just low, we will not build land units, but focus on sea/air, so no query for land units and ratio etc..
	-- In very low MP situations, we won't build any at all.
	local FreeMP = Grand_Country_Table["Manpower-" .. ActTagTbl].FreeMP
	local MPlow = Grand_Country_Table["Manpower-" .. ActTagTbl].MPlow
	if FreeMP < 1 then
Utils.LUA_DEBUGOUT("-PRODUCTION - Not enough Manpower: " .. tostring(ActTag) .. " -Available Manpower " .. tostring(TotalAvailableManpower) .. " -MPneededforReinf " .. tostring(MPneededforReinf) .. " -MPneedsinPool " .. tostring(MPneedsinPool) .. " -MPneedsinQueue " .. tostring(MPneedsinQueue))
	  return
	end
Utils.LUA_DEBUGOUT("-PRODUCTION - Current Manpower: " .. tostring(ActTag) .. " -Available Manpower " .. tostring(TotalAvailableManpower) .. " -MPneededforReinf " .. tostring(MPneededforReinf) .. " -MPneedsinPool " .. tostring(MPneedsinPool) .. " -MPneedsinQueue " .. tostring(MPneedsinQueue))

	-- Basic ratio
	local ProdWeightLand = 0.00
	local ProdWeightSea = 0.00
	local ProdWeightAir = 0.00

	-- Military stuff must make up 100, shift when no Sea/Air/MP at hand
	-- Note: Add eco check like in research too?
	if SeaAvail then
		if AirAvail then
			ProdWeightLand = 0.60
			ProdWeightSea = 0.20
			ProdWeightAir = 0.20
			if MPlow then													-- No MP
				ProdWeightAir = ProdWeightAir + (ProdWeightLand * 0.5)			-- Shift all to Sea
				ProdWeightSea = ProdWeightSea + (ProdWeightLand * 0.5)			-- and Air equally
				ProdWeightLand = 0												-- Set Land to 0
			end
		else																-- No Air
			ProdWeightLand = 0.70												-- Shift to Land
			ProdWeightSea = 0.30												-- Shift to Sea
			if MPlow then													-- No MP
				ProdWeightSea = ProdWeightSea + ProdWeightLand					-- Shift all to Sea
				ProdWeightLand = 0												-- Set Land to 0			
			end
		end
	elseif AirAvail then													-- No Sea
		ProdWeightLand = 0.70													-- Shift to Land
		ProdWeightAir = 0.30													-- Shift to Air
		if MPlow then														-- No MP
			ProdWeightAir = ProdWeightAir + ProdWeightLand						-- Shift all to Air
			ProdWeightLand = 0													-- Set Land to 0
		end
	else
		ProdWeightLand = 1.00
	end


--Potential Technology check area..
--[[
	-- ######### NEU Tech Check Land Build Focus Start
	--local LandBuildFocusCheck = CTechnologyDataBase.GetTechnology("Land_Build_Focus")
	--local LandBuildFocusCheckLevel = ministerCountry:GetTechnologyStatus():GetLevel(LandBuildFocusCheck)

	--Utils.LUA_DEBUGOUT("ProdWeightLand: " .. tostring(ActTag) .. tostring(ProdWeightLand))
	--Utils.LUA_DEBUGOUT("ProdWeightSea: " .. tostring(ActTag) .. tostring(ProdWeightSea))
	--Utils.LUA_DEBUGOUT("ProdWeightAir: " .. tostring(ActTag) .. tostring(ProdWeightAir))
	--Utils.LUA_DEBUGOUT("ProdWeightOther: " .. tostring(ActTag) .. tostring(ProdWeightOther))
]]

	-- Start Armament Policy influence to weight the production more in favour of the active policy
	-- note: change this to index to safe query -> Ask table!
	local ArmamentPolicy = CPolicyDataBase.GetPolicy(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.CurrentPolicy)
	local ArmamentPolicyName = ArmamentPolicy:GetKey()

	if (ArmamentPolicyName == "conventional_warfare_focus_pol" or "combined_arms_focus_pol" or "assymetric_warfare_focus_pol") and (not MPlow) then
	--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Land Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightLand = ProdWeightLand + 0.10
		ProdWeightSea = ProdWeightSea - 0.05
		ProdWeightAir = ProdWeightAir - 0.05

	elseif (ArmamentPolicyName == "littoral_waters_focus_pol" or "blue_waters_focus_pol" or "submarine_focus_pol") and SeaAvail then
	--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Naval Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightLand = ProdWeightLand - 0.20
		ProdWeightSea = ProdWeightSea + 0.25
		ProdWeightAir = ProdWeightAir - 0.05

	elseif (ArmamentPolicyName == "fighter_focus_pol" or "bomber_focus_pol" or "close_air_support_focus_pol") and AirAvail then
	--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Air Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightLand = ProdWeightLand - 0.20
		ProdWeightSea = ProdWeightSea - 0.05
		ProdWeightAir = ProdWeightAir + 0.25

	end
	-- End Armament Policy influence to weight the production more in favour of the active policy
--[[
replace names with numbers later.. less exe request..   nuclear_armaments_focus_pol, astronautical_focus_pol
]]

-- Actual unit ratio calculation
	local ActualUnitRatioLand = 0
	local ActualUnitRatioSea = 0
	local ActualUnitRatioAir = 0
	local DiffActualUnitRatioLand = 0
	local DiffActualUnitRatioSea = 0
	local DiffActualUnitRatioAir = 0

	ActualUnitRatioLand = (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllLand / Grand_Units_Table["TotalCountAllUnits-" .. ActTagTbl])
	DiffActualUnitRatioLand = (ProdWeightLand - ActualUnitRatioLand)
	if SeaAvail then
		ActualUnitRatioSea = (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSea / Grand_Units_Table["TotalCountAllUnits-" .. ActTagTbl])
		DiffActualUnitRatioSea = (ProdWeightSea - ActualUnitRatioSea)
	end
	if AirAvail then
		ActualUnitRatioAir = (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllAir / Grand_Units_Table["TotalCountAllUnits-" .. ActTagTbl])
		DiffActualUnitRatioAir = (ProdWeightAir - ActualUnitRatioAir)
	end
--[[
Utils.LUA_DEBUGOUT("DiffActualUnitRatioLand: " .. tostring(ActTag) .. tostring(DiffActualUnitRatioLand))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioSea: " .. tostring(ActTag) .. tostring(DiffActualUnitRatioSea))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioAir: " .. tostring(ActTag) .. tostring(DiffActualUnitRatioAir))
]]

-- Start of shift weights if big differences
	if DiffActualUnitRatioLand >= 0.50 then
		if SeaAvail and AirAvail then
			ProdWeightLand = ProdWeightLand + 0.20
			ProdWeightSea = ProdWeightSea - 0.10
			ProdWeightAir = ProdWeightAir - 0.10
		elseif SeaAvail then
			ProdWeightLand = ProdWeightLand + 0.15
			ProdWeightSea = ProdWeightSea - 0.15
		elseif AirAvail then
		ProdWeightLand = ProdWeightLand + 0.20
		ProdWeightAir = ProdWeightAir - 0.20
		else
		ProdWeightLand = ProdWeightLand + 0.20
		end
	elseif (DiffActualUnitRatioSea >= 0.30) and (DiffActualUnitRatioAir >= 0.30) then
		ProdWeightLand = ProdWeightLand - 0.30
		ProdWeightSea = ProdWeightSea + 0.15
		ProdWeightAir = ProdWeightAir + 0.15
	elseif DiffActualUnitRatioSea >= 0.50 then
		if AirAvail then
			ProdWeightSea = ProdWeightSea + 0.25
			ProdWeightLand = ProdWeightLand - 0.25
			--ProdWeightAir = ProdWeightAir - 0.05
		else 
		ProdWeightLand = ProdWeightLand - 0.30
		ProdWeightSea = ProdWeightSea + 0.30
		end
	elseif DiffActualUnitRatioAir >= 0.50 then
		if SeaAvail then
			ProdWeightAir = ProdWeightAir + 0.25
			ProdWeightLand = ProdWeightLand - 0.25
		else
		ProdWeightAir = ProdWeightAir + 0.30
		ProdWeightLand = ProdWeightLand - 0.30
		end
	end
-- End of shift weights if big differences

-- ##############################
-- ## End  initial ratio calculation


	-- How much money for each area
	local TotalAvailOther = 0
	local AvailMilitary = 0
	local TotalAvailLand = 0
	local TotalAvailSea = 0
	local TotalAvailAir = 0

-- testoverride start ----------------------------------
--[[
--	local ProdWeightLand = 0.1
--	local ProdWeightSea = 0.0
--	local ProdWeightAir = 0.8
--	local ProdWeightOther = 0.1
]]
-- testoverride end	  ----------------------------------

	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLand = rounddown((ActMoney * ProdWeightLand) * 1.00)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSea = rounddown((ActMoney * ProdWeightSea) * 1.00)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAir = rounddown((ActMoney * ProdWeightAir) * 1.00)
--[[
Utils.LUA_DEBUGOUT("ProdMoneyLand-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLand))
Utils.LUA_DEBUGOUT("ProdMoneySea-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSea))
Utils.LUA_DEBUGOUT("ProdMoneyAir-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAir))
]]

-- Start production branches if money available
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSea) > 0 then
		BuildSeaUnitsMain(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAir) > 0 then
		BuildAirUnitsMain(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLand) > 0 then
		BuildLandUnitsMain(ActTagTbl)
	end

	-- Priorize allways the queue
	minister:PrioritizeBuildQueue()

end
-- ###################################
-- # End of Main Method


-- # Start of Land Units Build
-- ###################################
function BuildLandUnitsMain(ActTagTbl)

	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag

--  Basic Ratio set
	local ProdWeightInfantryRatio = 0.65
	local ProdWeightMobileRatio = 0.25
	local ProdWeightSpecialRatio = 0.10

	-- Start Armament Policy influence to weight the production more in favour of the active policy
	-- note: change this to index!
	local ArmamentPolicy = CPolicyDataBase.GetPolicy(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.CurrentPolicy)
	local ArmamentPolicyName = ArmamentPolicy:GetKey()

	if (ArmamentPolicyName == "conventional_warfare_focus_pol") then
	--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Land Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightInfantryRatio = ProdWeightInfantryRatio + 0.15
		ProdWeightMobileRatio = ProdWeightMobileRatio - 0.10
		ProdWeightSpecialRatio = ProdWeightSpecialRatio - 0.05

	elseif (ArmamentPolicyName == "combined_arms_focus_pol") then
	--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Land Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightInfantryRatio = ProdWeightInfantryRatio - 0.25
		ProdWeightMobileRatio = ProdWeightMobileRatio + 0.25
		--ProdWeightSpecialRatio = ProdWeightSpecialRatio - 0.05

	elseif (ArmamentPolicyName == "assymetric_warfare_focus_pol") then
	--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Land Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightInfantryRatio = ProdWeightInfantryRatio - 0.25
		ProdWeightMobileRatio = ProdWeightMobileRatio + 0.15
		ProdWeightSpecialRatio = ProdWeightSpecialRatio + 0.10

	end
	-- End Armament Policy influence to weight the production more in favour of the active policy

-- Actual unit ratio
	local ActualUnitRatioInfantry = 0
	local ActualUnitRatioMobile = 0
	local ActualUnitRatioSpecial = 0
	local DiffActualUnitRatioInfantry = 0
	local DiffActualUnitRatioMobile = 0
	local DiffActualUnitRatioSpecial = 0

	ActualUnitRatioInfantry = ((Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllReg))
	ActualUnitRatioMobile = ((Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllMobile) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllReg))
	ActualUnitRatioSpecial = ((Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllSpecial) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllReg))

-- Difference?
	DiffActualUnitRatioInfantry = (ProdWeightInfantryRatio - ActualUnitRatioInfantry)
	DiffActualUnitRatioMobile = (ProdWeightMobileRatio - ActualUnitRatioMobile)
	DiffActualUnitRatioSpecial = (ProdWeightSpecialRatio - ActualUnitRatioSpecial)
--[[
Utils.LUA_DEBUGOUT("ActualUnitRatioInfantry" .. tostring(ActTag) .. tostring(ActualUnitRatioInfantry))
Utils.LUA_DEBUGOUT("ActualUnitRatioMobile" .. tostring(ActTag) .. tostring(ActualUnitRatioMobile))
Utils.LUA_DEBUGOUT("ActualUnitRatioSpecial" .. tostring(ActTag) .. tostring(ActualUnitRatioSpecial))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioInfantry" .. tostring(ActTag) .. tostring(DiffActualUnitRatioInfantry))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioMobile" .. tostring(ActTag) .. tostring(DiffActualUnitRatioMobile))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioSpecial" .. tostring(ActTag) .. tostring(DiffActualUnitRatioSpecial))
]]

-- Shift weights if big differences
	if DiffActualUnitRatioInfantry >= 0.50 then
		ProdWeighInfantryRatio = ProdWeightInfantryRatio + 0.20
		ProdWeightMobileRatio = ProdWeightMobileRatio - 0.15
		ProdWeightSpecialRatio = ProdWeightSpecialRatio - 0.05
	elseif DiffActualUnitRatioMobile >= 0.25 and DiffActualUnitRatioSpecial >= 0.25 then
		ProdWeighInfantryRatio = ProdWeightInfantryRatio - 0.30
		ProdWeightMobileRatio = ProdWeightMobileRatio + 0.20
		ProdWeightSpecialRatio = ProdWeightSpecialRatio + 0.10
	elseif DiffActualUnitRatioMobile >= 0.50 then
		ProdWeighInfantryRatio = ProdWeightInfantryRatio - 0.20
		ProdWeightMobileRatio = ProdWeightMobileRatio + 0.20
		--ProdWeightSpecialRatio = ProdWeightSpecialRatio - 0.05
	elseif DiffActualUnitRatioSpecial >= 0.50 then
		ProdWeighInfantryRatio = ProdWeightInfantryRatio - 0.20
		--ProdWeightMobileRatio = ProdWeightMobileRatio - 0.05
		ProdWeightSpecialRatio = ProdWeightSpecialRatio + 0.20
	end
--[[
Utils.LUA_DEBUGOUT("ProdWeighInfantryRatio" .. tostring(ActTag) .. tostring(ProdWeighInfantryRatio))
Utils.LUA_DEBUGOUT("ProdWeightMobileRatio" .. tostring(ActTag) .. tostring(ProdWeightMobileRatio))
Utils.LUA_DEBUGOUT("ProdWeightSpecialRatio" .. tostring(ActTag) .. tostring(ProdWeightSpecialRatio))
]]

-- Available IC for Land Sections
	local MoneyLandUnits = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLand
	local rounddown = math.floor
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandInf = rounddown(MoneyLandUnits * ProdWeightInfantryRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandMobile = rounddown(MoneyLandUnits * ProdWeightMobileRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandSpecial = rounddown(MoneyLandUnits * ProdWeightSpecialRatio)
--[[
Utils.LUA_DEBUGOUT("Money Inf-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandInf))
Utils.LUA_DEBUGOUT("Money Mobile-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandMobile))
Utils.LUA_DEBUGOUT("Money Special-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandSpecial))
]]

	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandInf) > 0 then
		BuildLandInfantryUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandMobile) > 0 then
		BuildLandMobileUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandSpecial) > 0 then
		BuildLandSpecialUnits(ActTagTbl)
	end

end

function BuildLandInfantryUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local MilChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].militia_brigade.Tech
	local InfChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].infantry_brigade.Tech
	local MotInfChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].motorized_brigade.Tech

--[[
	Utils.LUA_DEBUGOUT("----MilChk: " .. tostring(ActTag) .. "---" .. tostring(MilChk))
	Utils.LUA_DEBUGOUT("----InfChk: " .. tostring(ActTag) .. "---" .. tostring(InfChk))
	Utils.LUA_DEBUGOUT("----MotInfChk: " .. tostring(ActTag) .. "---" .. tostring(MotInfChk))
]]

	-- Ratio check
	local ProdWeightMil = 1.00
	local ProdWeightInf = 0.00
	local ProdWeightMotInf = 0.00

-- Unit Ratio: Militia
	local ActualRatioMil = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].militia_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
	local DiffActualRatioMil = (ProdWeightMil - ActualRatioMil)
-- Unit Ratio: Infantry
	local ActualRatioInf = 0
	local DiffActualRatioInf = 0
	if InfChk then
		ProdWeightMil = ProdWeightMil - 0.95
		ProdWeightInf = ProdWeightInf + 0.95
		ActualRatioInf = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].infantry_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
		DiffActualRatioInf = (ProdWeightInf - ActualRatioInf)
	end
-- Unit Ratio: Motorised Infantry
	local ActualRatioMotInf = 0
	local DiffActualRatioMotInf = 0
	if MotInfChk then
		ProdWeightInf = ProdWeightInf - 0.40		-- At 50% by now
		ProdWeightMotInf = ProdWeightMotInf + 0.40	-- At 40% by now
		ActualRatioMotInf = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].motorized_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
		DiffActualRatioMotInf = (ProdWeightMotInf - ActualRatioMotInf)
	end

--[[
Utils.LUA_DEBUGOUT("ProdWeightMil: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMil))
Utils.LUA_DEBUGOUT("ProdWeightInf: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightInf))
Utils.LUA_DEBUGOUT("ProdWeightMotInf: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMotInf))
]]

-- Start shift weights if big differences
	if DiffActualRatioMotInf >= 0.50 then
		ProdWeightMil = ProdWeightMil - 0.05
		ProdWeightInf = ProdWeightInf - 0.15
		ProdWeightMotInf = ProdWeightMotInf + 0.20
	elseif DiffActualRatioInf >= 0.50 then
		if MotInfChk then
			ProdWeightMil = ProdWeightMil - 0.05
			ProdWeightInf = ProdWeightInf + 0.20
			ProdWeightMotInf = ProdWeightMotInf - 0.15
		else
		ProdWeightMil = ProdWeightMil - 0.05
		ProdWeightInf = ProdWeightInf + 0.05
		end
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioMil-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMil))
Utils.LUA_DEBUGOUT("DiffActualRatioInf-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioInf))
Utils.LUA_DEBUGOUT("DiffActualRatioMotInf-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMotInf))
]]

	local LandStdInfMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandInf
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyMil = rounddown(LandStdInfMoney * ProdWeightMil)
	local MoneyInf = rounddown(LandStdInfMoney * ProdWeightInf)
	local MoneyMotInf = rounddown(LandStdInfMoney * ProdWeightMotInf)
--[[
Utils.LUA_DEBUGOUT("MoneyMil-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMil))
Utils.LUA_DEBUGOUT("MoneyInf-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyInf))
Utils.LUA_DEBUGOUT("MoneyMotInf-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMotInf))
]]

	local ispuppet = nil												-- Use masters build scheme
	local has faction = nil												-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT

	if MoneyMil > 0 then

		local LandProduction = {
			Money = MoneyMil,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_militia_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_StdSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end
	if MoneyInf > 0 then

		local LandProduction = {
			Money = MoneyInf,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_infantry_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_StdSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end
	if MoneyMotInf > 0 then

		local LandProduction = {
			Money = MoneyMotInf,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_motorized_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_MobSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end

end

function BuildLandMobileUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local CavArmChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].cavalry_brigade.Tech
	local LtMechChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].light_mechanized_brigade.Tech
	local HvyMechChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].heavy_mechanized_brigade.Tech
	local ArmChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].armor_brigade.Tech
	local CavAirChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].air_cav_brigade.Tech

--[[
	Utils.LUA_DEBUGOUT("----CavArmChk: " .. tostring(ActTag) .. "---" .. tostring(CavArmChk))
	Utils.LUA_DEBUGOUT("----LtMechChk: " .. tostring(ActTag) .. "---" .. tostring(LtMechChk))
	Utils.LUA_DEBUGOUT("----HvyMechChk: " .. tostring(ActTag) .. "---" .. tostring(HvyMechChk))
	Utils.LUA_DEBUGOUT("----ArmChk: " .. tostring(ActTag) .. "---" .. tostring(ArmChk))
	Utils.LUA_DEBUGOUT("----CavAirChk: " .. tostring(ActTag) .. "---" .. tostring(CavAirChk))
]]

	-- Ratio check
	local ProdWeightCavArm = 1.00
	local ProdWeightLtMech = 0.00
	local ProdWeightHvyMech = 0.00
	local ProdWeightArmor = 0.00
	local ProdWeightCavAir = 0.00

-- Unit Ratio: Armored Cavalry
	local ActualRatioCavArm = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].cavalry_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllMobile))
	local DiffActualRatioCavArm = (ProdWeightCavArm - ActualRatioCavArm)
-- Unit Ratio: Light Mechanized
	local ActualRatioLtMech = 0
	local DiffActualRatioLtMech = 0
	if LtMechChk then
		ProdWeightCavArm = ProdWeightCavArm - 0.50
		ProdWeightLtMech = ProdWeightLtMech + 0.50
		ActualRatioLtMech = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].light_mechanized_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllMobile))
		DiffActualRatioLtMech = (ProdWeightLtMech - ActualRatioLtMech)
	end
-- Unit Ratio: Heavy Mechanized
	local ActualRatioHvyMech = 0
	local DiffActualRatioHvyMech = 0
	if HvyMechChk then
		ProdWeightCavArm = ProdWeightCavArm - 0.10		-- At 40% by now
		ProdWeightLtMech = ProdWeightLtMech - 0.10		-- At 40% by now
		ProdWeightHvyMech = ProdWeightHvyMech + 0.20	-- At 20% by now
		ActualRatioHvyMech = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].heavy_mechanized_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllMobile))
		DiffActualRatioHvyMech = (ProdWeightHvyMech - ActualRatioHvyMech)
	end
-- Unit Ratio: Armor
	local ActualRatioArmor = 0
	local DiffActualRatioArmor = 0
	if ArmChk then
		ProdWeightCavArm = ProdWeightCavArm - 0.10		-- At 30% by now
		ProdWeightLtMech = ProdWeightLtMech - 0.10		-- At 30% by now
		ProdWeightArmor = ProdWeightArmor + 0.20		-- At 20% by now
		ActualRatioArmor = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].armor_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllMobile))
		DiffActualRatioArmor = (ProdWeightArmor - ActualRatioArmor)
	end
-- Unit Ratio: Air Cavalry
	local ActualRatioCavAir = 0
	local DiffActualRatioCavAir = 0
	if CavAirChk then
		ProdWeightCavArm = ProdWeightCavArm - 0.10		-- At 20% by now
		ProdWeightLtMech = ProdWeightLtMech - 0.10		-- At 20% by now
		ProdWeightCavAir = ProdWeightCavAir + 0.20		-- At 20% by now
		ActualRatioCavAir = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].air_cav_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllMobile))
		DiffActualRatioCavAir = (ProdWeightCavAir - ActualRatioCavAir)
	end
--[[
Utils.LUA_DEBUGOUT("ProdWeightCavArm: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCavArm))
Utils.LUA_DEBUGOUT("ProdWeightLtMech: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightLtMech))
Utils.LUA_DEBUGOUT("ProdWeightHvyMech: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightHvyMech))
Utils.LUA_DEBUGOUT("ProdWeightArmor: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightArmor))
Utils.LUA_DEBUGOUT("ProdWeightCavAir: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCavAir))
]]

-- Start shift weights if big differences
	if DiffActualRatioCavAir >= 0.50 then
		ProdWeightCavArm = ProdWeightCavArm - 0.05
		ProdWeightLtMech = ProdWeightLtMech - 0.05
		ProdWeightHvyMech = ProdWeightHvyMech - 0.05
		ProdWeightArmor = ProdWeightArmor - 0.05
		ProdWeightCavAir = ProdWeightCavAir + 0.20
	elseif DiffActualRatioArmor >= 0.50 then
		if CavAirChk then
			ProdWeightCavArm = ProdWeightCavArm - 0.05
			ProdWeightLtMech = ProdWeightLtMech - 0.05
			ProdWeightHvyMech = ProdWeightHvyMech - 0.05
			ProdWeightArmor = ProdWeightArmor + 0.20
			ProdWeightCavAir = ProdWeightCavAir - 0.05
		else
			ProdWeightCavArm = ProdWeightCavArm - 0.08
			ProdWeightLtMech = ProdWeightLtMech - 0.07
			ProdWeightHvyMech = ProdWeightHvyMech - 0.05
			ProdWeightArmor = ProdWeightArmor + 0.20
		end
	elseif DiffActualRatioHvyMech >= 0.50 then
		if CavAirChk then
			ProdWeightCavArm = ProdWeightCavArm - 0.05
			ProdWeightLtMech = ProdWeightLtMech - 0.05
			ProdWeightHvyMech = ProdWeightHvyMech + 0.20
			ProdWeightArmor = ProdWeightArmor - 0.05
			ProdWeightCavAir = ProdWeightCavAir - 0.05
		elseif ArmChk then
			ProdWeightCavArm = ProdWeightCavArm - 0.7
			ProdWeightLtMech = ProdWeightLtMech - 0.8
			ProdWeightHvyMech = ProdWeightHvyMech + 0.20
			ProdWeightArmor = ProdWeightArmor - 0.05
		else
		ProdWeightCavArm = ProdWeightCavArm - 0.10
		ProdWeightLtMech = ProdWeightLtMech - 0.10
		ProdWeightHvyMech = ProdWeightHvyMech + 0.20
		end
	elseif DiffActualRatioLtMech >= 0.50 then
		if CavAirChk then
			ProdWeightCavArm = ProdWeightCavArm - 0.05
			ProdWeightLtMech = ProdWeightLtMech + 0.20
			ProdWeightHvyMech = ProdWeightHvyMech - 0.05
			ProdWeightArmor = ProdWeightArmor - 0.05
			ProdWeightCavAir = ProdWeightCavAir - 0.05
		elseif ArmChk then
			ProdWeightCavArm = ProdWeightCavArm - 0.07
			ProdWeightLtMech = ProdWeightLtMech + 0.20
			ProdWeightHvyMech = ProdWeightHvyMech - 0.08
			ProdWeightArmor = ProdWeightArmor - 0.05
		elseif HvyMechChk then
			ProdWeightCavArm = ProdWeightCavArm - 0.10
			ProdWeightLtMech = ProdWeightLtMech + 0.20
			ProdWeightHvyMech = ProdWeightHvyMech - 0.10
		else
		ProdWeightCavArm = ProdWeightCavArm - 0.20
		ProdWeightLtMech = ProdWeightLtMech + 0.20
		end
	elseif DiffActualRatioCavArm >= 0.50 then
		if CavAirChk then
			ProdWeightCavArm = ProdWeightCavArm + 0.20
			ProdWeightLtMech = ProdWeightLtMech - 0.05
			ProdWeightHvyMech = ProdWeightHvyMech - 0.05
			ProdWeightArmor = ProdWeightArmor - 0.05
			ProdWeightCavAir = ProdWeightCavAir - 0.05
		elseif ArmChk then
			ProdWeightCavArm = ProdWeightCavArm + 0.20
			ProdWeightLtMech = ProdWeightLtMech - 0.10
			ProdWeightHvyMech = ProdWeightHvyMech + 0.20
			ProdWeightArmor = ProdWeightArmor - 0.05
		elseif HvyMechChk then
			ProdWeightCavArm = ProdWeightCavArm + 0.20
			ProdWeightLtMech = ProdWeightLtMech - 0.10
			ProdWeightHvyMech = ProdWeightHvyMech - 0.10
		else
		ProdWeightCavArm = ProdWeightCavArm + 0.20
		ProdWeightLtMech = ProdWeightLtMech - 0.20
		end	
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioCavAir-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCavAir))
Utils.LUA_DEBUGOUT("DiffActualRatioArmor-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioArmor))
Utils.LUA_DEBUGOUT("DiffActualRatioLtMech-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioLtMech))
Utils.LUA_DEBUGOUT("DiffActualRatioHvyMech-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioHvyMech))
Utils.LUA_DEBUGOUT("DiffActualRatioCavArm-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCavArm))
Utils.LUA_DEBUGOUT("ProdWeightCavArm-FINAL: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCavArm))
]]

	local LandMobileMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandMobile
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyCavArm = rounddown(LandMobileMoney * ProdWeightCavArm)
	local MoneyLtMech = rounddown(LandMobileMoney * ProdWeightLtMech)
	local MoneyHvyMech = rounddown(LandMobileMoney * ProdWeightHvyMech)
	local MoneyArmor = rounddown(LandMobileMoney * ProdWeightArmor)
	local MoneyCavAir = rounddown(LandMobileMoney * ProdWeightCavAir)
--[[
Utils.LUA_DEBUGOUT("MoneyCavArm-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyCavArm))
Utils.LUA_DEBUGOUT("MoneyLtMech-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyLtMech))
Utils.LUA_DEBUGOUT("MoneyHvyMech-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyHvyMech))
Utils.LUA_DEBUGOUT("MoneyArmor-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyArmor))
Utils.LUA_DEBUGOUT("MoneyCavAir-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyCavAir))
]]

	local ispuppet = nil												-- Use masters build scheme
	local has faction = nil												-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT

	if MoneyCavArm > 0 then

		local LandProduction = {
			Money = MoneyCavArm,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_cavalry_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_MobSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end
	if MoneyLtMech > 0 then

		local LandProduction = {
			Money = MoneyCavArm,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_light_mechanized_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_MobSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end
	if MoneyHvyMech > 0 then

		local LandProduction = {
			Money = MoneyCavArm,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_heavy_mechanized_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_MobSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end
	if MoneyArmor > 0 then

		local LandProduction = {
			Money = MoneyCavArm,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_armor_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_MobSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end
	if MoneyCavAir > 0 then

		local LandProduction = {
			Money = MoneyCavArm,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_air_cav_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_MobSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end

end

function BuildLandSpecialUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local BergsChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].bergsjaeger_brigade.Tech
	local MarChk = Grand_Units_Table["LandUnits-" .. ActTagTbl].marine_brigade.Tech

--[[
	Utils.LUA_DEBUGOUT("----BergsChk: " .. tostring(ActTag) .. "---" .. tostring(BergsChk))
	Utils.LUA_DEBUGOUT("----MarChk: " .. tostring(ActTag) .. "---" .. tostring(MarChk))
]]

	-- Ratio check
	local ProdWeightBergs = 0
	local ProdWeightMar = 0
	local ActualRatioBergs = 0
	local DiffActualRatioBergs = 0
	local ActualRatioMar = 0
	local DiffActualRatioMar = 0
	
	if BergsChk and MarChk then
		ProdWeightBergs = 0.50
		ActualRatioBergs = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].bergsjaeger_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
		DiffActualRatioBergs = (ProdWeightBergs - ActualRatioBergs)
		ProdWeightMar = 0.50
		ActualRatioMar = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].marine_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
		DiffActualRatioMar = (ProdWeightMar - ActualRatioMar)
	elseif BergsChk then
		ProdWeightBergs = 1.00
		ActualRatioBergs = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].bergsjaeger_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
		DiffActualRatioBergs = (ProdWeightBergs - ActualRatioBergs)
	elseif MarChk then
		ProdWeightMar = 1.00
		ActualRatioMar = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].marine_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
		DiffActualRatioMar = (ProdWeightMar - ActualRatioMar)
	end

-- Unit Ratio: Bergsjaeger
	ActualRatioBergs = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].bergsjaeger_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
	DiffActualRatioBergs = (ProdWeightBergs - ActualRatioBergs)
-- Unit Ratio: Marine
	ActualRatioMar = ((Grand_Units_Table["LandUnits-" .. ActTagTbl].marine_brigade.ActCountAll) / (Grand_Units_Table["TotalCountLand-" .. ActTagTbl].CountAllInf))
	DiffActualRatioMar = (ProdWeightMar - ActualRatioMar)


--[[
Utils.LUA_DEBUGOUT("ProdWeightBergs: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightBergs))
Utils.LUA_DEBUGOUT("ProdWeightMar: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMar))
]]

-- Start shift weights if big differences
	if DiffActualRatioBergs >= 0.50 and MarChk then
		ProdWeightBergs = ProdWeightBergs + 0.25
		ProdWeightMar = ProdWeightMar - 0.25
	elseif DiffActualRatioMar >= 0.50 and BergsChk then
		ProdWeightBergs = ProdWeightBergs - 0.25
		ProdWeightMar = ProdWeightMar + 0.25
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioBergs-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioBergs))
Utils.LUA_DEBUGOUT("DiffActualRatioMar-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMar))
]]

	local LandSpecMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdLandSpecial
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyBergs = rounddown(LandSpecMoney * ProdWeightBergs)
	local MoneyMar = rounddown(LandSpecMoney * ProdWeightMar)
--[[
Utils.LUA_DEBUGOUT("MoneyBergs-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyBergs))
Utils.LUA_DEBUGOUT("MoneyMar-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMar))
]]

	local ispuppet = nil												-- Use masters build scheme
	local has faction = nil												-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT

	if MoneyBergs > 0 then

		local LandProduction = {
			Money = MoneyBergs,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_bergsjaeger_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_StdSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end
	if MoneyMar > 0 then

		local LandProduction = {
			Money = MoneyMar,
			BuildArea = tostring("_Divisions"),
			BuildDiv = tostring("_marine_brigade"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_StdSupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["LandProduction-" .. ActTagTbl] = LandProduction
		
		ProdTable = "LandProduction-"
		UnitProduction(ActTagTbl, ProdTable)

	end

end
-- ###################################
-- # End of Land Units Build


-- # Start of Sea Units Build
-- ###################################
function BuildSeaUnitsMain(ActTagTbl)

	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag

--  Basic Ratio set
	local ProdWeightCoastRatio = 0.20
	local ProdWeightSAGRatio = 0.35
	local ProdWeightCarrierRatio = 0.35
	local ProdWeightSubRatio = 0.10

	-- Start Armament Policy influence to weight the production more in favour of the active policy
	-- note: change this to index!
	local ArmamentPolicy = CPolicyDataBase.GetPolicy(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.CurrentPolicy)
	local ArmamentPolicyName = ArmamentPolicy:GetKey()

	if (ArmamentPolicyName == "littoral_waters_focus_pol") then
--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Sea Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightCoastRatio = ProdWeightCoastRatio + 0.30
		ProdWeightSAGRatio = ProdWeightSAGRatio - 0.15
		ProdWeightCarrierRatio = ProdWeightCarrierRatio - 0.15
		--ProdWeightSubRatio = ProdWeightSubRatio - 0.05

	elseif (ArmamentPolicyName == "blue_waters_focus_pol") then
--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Sea Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightCoastRatio = ProdWeightCoastRatio - 0.10
		ProdWeightSAGRatio = ProdWeightSAGRatio + 0.25
		ProdWeightCarrierRatio = ProdWeightCarrierRatio - 0.15
		--ProdWeightSubRatio = ProdWeightSubRatio - 0.05

	elseif (ArmamentPolicyName == "submarine_focus_pol") then
--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Sea Policy Focus: " .. tostring(ArmamentPolicyName))
		ProdWeightCoastRatio = ProdWeightCoastRatio - 0.10
		ProdWeightSAGRatio = ProdWeightSAGRatio - 0.15
		ProdWeightCarrierRatio = ProdWeightCarrierRatio - 0.15
		ProdWeightSubRatio = ProdWeightSubRatio + 0.40

	end
	-- End Armament Policy influence to weight the production more in favour of the active policy

-- Actual unit ratio
	local ActualUnitRatioCoast = 0
	local ActualUnitRatioSAG = 0
	local ActualUnitRatioCarrier = 0
	local ActualUnitRatioSub = 0
	local DiffActualUnitRatioCoast = 0
	local DiffActualUnitRatioSAG = 0
	local DiffActualUnitRatioCarrier = 0
	local DiffActualUnitRatioSub = 0

	-- How much Escorts used/needed in each area, important for later check if more Escorts are needed
	local EscortMod = ((ProdWeightCoastRatio + ProdWeightSAGRatio + ProdWeightCarrierRatio) * 0.01)
	local EscortCoast = ((Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllEscort) * ((ProdWeightCoastRatio / EscortMod) * 0.01))
	local EscortSAG = ((Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllEscort) * (ProdWeightSAGRatio / EscortMod * 0.01))
	local EscortCTF = ((Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllEscort) * (ProdWeightCarrierRatio / EscortMod * 0.01))

	ActualUnitRatioCoast = (((Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCoastDefense) + EscortCoast) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSea))
	ActualUnitRatioSAG = (((Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSAG) + EscortSAG) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSea))
	ActualUnitRatioCarrier = ((Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCarrier + EscortCTF) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSea))
	ActualUnitRatioSub = ((Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSubmarine) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSea))

-- Difference?
	DiffActualUnitRatioCoast = (ProdWeightCoastRatio - ActualUnitRatioCoast)
	DiffActualUnitRatioSAG = (ProdWeightSAGRatio - ActualUnitRatioSAG)
	DiffActualUnitRatioCarrier = (ProdWeightCarrierRatio - ActualUnitRatioCarrier)
	DiffActualUnitRatioSub = (ProdWeightSubRatio - ActualUnitRatioSub)
--[[
Utils.LUA_DEBUGOUT("ActualUnitRatioCoast" .. tostring(ActTag) .. tostring(ActualUnitRatioCoast))
Utils.LUA_DEBUGOUT("ActualUnitRatioSAG" .. tostring(ActTag) .. tostring(ActualUnitRatioSAG))
Utils.LUA_DEBUGOUT("ActualUnitRatioCarrier" .. tostring(ActTag) .. tostring(ActualUnitRatioCarrier))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioCoast" .. tostring(ActTag) .. tostring(DiffActualUnitRatioCoast))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioSAG" .. tostring(ActTag) .. tostring(DiffActualUnitRatioSAG))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioCarrier" .. tostring(ActTag) .. tostring(DiffActualUnitRatioCarrier))
]]

-- Shift weights if big differences
	if DiffActualUnitRatioCarrier >= 0.50 then
		ProdWeighCoastRatio = ProdWeightCoastRatio - 0.10
		ProdWeightSAGRatio = ProdWeightSAGRatio - 0.15
		ProdWeightCarrierRatio = ProdWeightCarrierRatio + 0.25
		--ProdWeightSubRatio = ProdWeightSubRatio - 0.05
	elseif DiffActualUnitRatioSAG >= 0.25 then
		ProdWeighCoastRatio = ProdWeightCoastRatio - 0.10
		ProdWeightSAGRatio = ProdWeightSAGRatio + 0.25
		ProdWeightCarrierRatio = ProdWeightCarrierRatio - 0.15
		--ProdWeightSubRatio = ProdWeightSubRatio - 0.05
	elseif DiffActualUnitRatioSub >= 0.50 then
		ProdWeighCoastRatio = ProdWeightCoastRatio - 0.05
		ProdWeightSAGRatio = ProdWeightSAGRatio - 0.25
		ProdWeightCarrierRatio = ProdWeightCarrierRatio - 0.25
		ProdWeightSubRatio = ProdWeightSubRatio + 0.55
	elseif DiffActualUnitRatioCoast >= 0.50 then
		ProdWeighCoastRatio = ProdWeightCoastRatio + 0.30
		ProdWeightSAGRatio = ProdWeightSAGRatio - 0.15
		ProdWeightCarrierRatio = ProdWeightCarrierRatio - 0.15
		-- ProdWeightSubRatio = ProdWeightSubRatio - 0.05
	end
--[[
Utils.LUA_DEBUGOUT("ProdWeighCoastRatio" .. tostring(ActTag) .. tostring(ProdWeighCoastRatio))
Utils.LUA_DEBUGOUT("ProdWeightSAGRatio" .. tostring(ActTag) .. tostring(ProdWeightSAGRatio))
Utils.LUA_DEBUGOUT("ProdWeightCarrierRatio" .. tostring(ActTag) .. tostring(ProdWeightCarrierRatio))
Utils.LUA_DEBUGOUT("ProdWeightSubRatio" .. tostring(ActTag) .. tostring(ProdWeightSubRatio))
]]

-- Check for Escort ships
	local AllEscorts = (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllEscort)
	local AllSAG = (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSAG)
	local AllCTF = (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCarrier)
	local NeededEscortShip = ((AllSAG + AllCTF) - (EscortSAG + EscortCTF))
	local EscortOverride = nil
	if (NeededEscortShip > 0) and (DiffActualUnitRatioCoast > 0) then
		--if (ProdWeightSAGRatio > 0) or (ProdWeightCarrierRatio > 0) then
			EscortOverride = true
		--end
	end

-- Available IC for Sea Sections
	local MoneySeaUnits = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSea
	local rounddown = math.floor
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCoast = rounddown(MoneySeaUnits * ProdWeightCoastRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSAG = rounddown(MoneySeaUnits * ProdWeightSAGRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCarrier = rounddown(MoneySeaUnits * ProdWeightCarrierRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSub = rounddown(MoneySeaUnits * ProdWeightSubRatio)

--[[
Utils.LUA_DEBUGOUT("Money Inf-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCoast))
Utils.LUA_DEBUGOUT("Money SAG-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSAG))
Utils.LUA_DEBUGOUT("Money Carrier-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCarrier))
Utils.LUA_DEBUGOUT("Money Sub-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSub))
]]

	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCoast) > 0 then
		BuildSeaCoastUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSAG) > 0 then
		if EscortOverride then
			Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaEscort = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSAG * 0.6
			Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSAG = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSAG * 0.4
			BuildSeaEscortUnits(ActTagTbl)
		end
		BuildSeaSAGUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCarrier) > 0 then
		if EscortOverride then
			Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaEscort = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCarrier * 0.6
			Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCarrier = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCarrier * 0.4
			BuildSeaEscortUnits(ActTagTbl)
		end
		BuildSeaCarrierUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSub) > 0 then
		BuildSeaSubUnits(ActTagTbl)
	end

end

function BuildSeaCoastUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local DestrChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].destroyer.Tech
	local MDestrChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_destroyer.Tech
	local MTBChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_boat.Tech
	local MFrigChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_frigate.Tech

--[[
	Utils.LUA_DEBUGOUT("----DestrChk: " .. tostring(ActTag) .. "---" .. tostring(DestrChk))
	Utils.LUA_DEBUGOUT("----MDestrChk: " .. tostring(ActTag) .. "---" .. tostring(MDestrChk))
	Utils.LUA_DEBUGOUT("----MTBChk: " .. tostring(ActTag) .. "---" .. tostring(MTBChk))
	Utils.LUA_DEBUGOUT("----MFrigChk: " .. tostring(ActTag) .. "---" .. tostring(MFrigChk))
]]

	-- Ratio check
	local ProdWeightDestr = 1.00
	local ProdWeightMDestr = 0
	local ProdWeightMTB = 0
	local ProdWeightMFrig = 0

	local ActualRatioDestr = 0
	local DiffActualRatioDestr = 0
	local ActualRatioMDestr = 0
	local DiffActualRatioMDestr = 0	
	local ActualRatioMTB = 0
	local DiffActualRatioMTB = 0
	local ActualRatioMFrig = 0
	local DiffActualRatioMFrig = 0
	
	if MDestrChk then
		ProdWeightDestr = ProdWeightDestr - 1.00
		ProdWeightMDestr = ProdWeightMDestr + 1.00
		--ProdWeightMTB = ProdWeightMTB 
		--ProdWeightMFrig = ProdWeightMFrig
	end
	if MFrigChk then
		--ProdWeightDestr = ProdWeightDestr - 1.00
		ProdWeightMDestr = ProdWeightMDestr - 0.50
		--ProdWeightMTB = ProdWeightMTB 
		ProdWeightMFrig = ProdWeightMFrig + 0.50
	end
	if MTBChk then
		--ProdWeightDestr = ProdWeightDestr - 1.00
		ProdWeightMDestr = ProdWeightMDestr - 0.30
		ProdWeightMTB = ProdWeightMTB + 0.60
		ProdWeightMFrig = ProdWeightMFrig - 0.30
	end

-- Unit Ratio: Missile Destroyer
	ActualRatioMDestr = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_destroyer.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCoastDefense))
	DiffActualRatioMDestr = (ProdWeightMDestr - ActualRatioMDestr)
-- Unit Ratio: Missile Frigate
	ActualRatioMFrig = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_frigate.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCoastDefense))
	DiffActualRatioMFrig = (ProdWeightMFrig - ActualRatioMFrig)
-- Unit Ratio: Missile Boat
	ActualRatioMTB = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_boat.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCoastDefense))
	DiffActualRatioMTB = (ProdWeightMTB - ActualRatioMTB)

--[[
Utils.LUA_DEBUGOUT("ProdWeightDestr: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightDestr))
Utils.LUA_DEBUGOUT("ProdWeightMDestr: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMDestr))
Utils.LUA_DEBUGOUT("ProdWeightMTB: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMTB))
Utils.LUA_DEBUGOUT("ProdWeightMFrig: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMFrig))
]]

-- Start shift weights if big differences
	if DiffActualRatioMTB >= 0.50 and MTBChk then
		ProdWeightMDestr = ProdWeightMDestr - 0.10
		ProdWeightMFrig = ProdWeightMFrig - 0.10
		ProdWeightMTB = ProdWeightMTB + 0.20
	elseif DiffActualRatioMFrig >= 0.50 and MFrigChk then
		ProdWeightMDestr = ProdWeightMDestr - 0.10
		ProdWeightMFrig = ProdWeightMFrig + 0.30
		ProdWeightMTB = ProdWeightMTB - 0.20
	elseif DiffActualRatioMDestr >= 0.50 and MDestrChk then
		ProdWeightMDestr = ProdWeightMDestr + 0.30
		ProdWeightMFrig = ProdWeightMFrig - 0.10
		ProdWeightMTB = ProdWeightMTB - 0.20
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioDestr))
Utils.LUA_DEBUGOUT("DiffActualRatioMDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMDestr))
Utils.LUA_DEBUGOUT("DiffActualRatioMFrig-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMFrig))
Utils.LUA_DEBUGOUT("DiffActualRatioMTB-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMTB))
]]

	local SeaCoastMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCoast
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyDestr = rounddown(SeaCoastMoney * ProdWeightDestr)
	local MoneyMDestr = rounddown(SeaCoastMoney * ProdWeightMDestr)
	local MoneyMFrig = rounddown(SeaCoastMoney * ProdWeightMFrig)
	local MoneyMTB = rounddown(SeaCoastMoney * ProdWeightMTB)
--[[
Utils.LUA_DEBUGOUT("MoneyDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyDestr))
Utils.LUA_DEBUGOUT("MoneyMDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMDestr))
Utils.LUA_DEBUGOUT("MoneyMFrig-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMFrig))
Utils.LUA_DEBUGOUT("MoneyMTB-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMTB))
]]

	local ispuppet = nil												-- Use masters build scheme
	local has faction = nil												-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT

	if MoneyDestr > 0 then
		
		local SeaProduction = {
			Money = MoneyDestr,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_destroyer"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyMDestr > 0 then
		
		local SeaProduction = {
			Money = MoneyMDestr,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_missile_destroyer"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyMFrig > 0 then
		
		local SeaProduction = {
			Money = MoneyMFrig,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_missile_frigate"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyMTB > 0 then
		
		local SeaProduction = {
			Money = MoneyMTB,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_missile_boat"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	
end

function BuildSeaEscortUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local DestrChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].destroyer.Tech
	local MDestrChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_destroyer.Tech
	local MFrigChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_frigate.Tech

--[[
	Utils.LUA_DEBUGOUT("----DestrChk: " .. tostring(ActTag) .. "---" .. tostring(DestrChk))
	Utils.LUA_DEBUGOUT("----MDestrChk: " .. tostring(ActTag) .. "---" .. tostring(MDestrChk))
	Utils.LUA_DEBUGOUT("----MFrigChk: " .. tostring(ActTag) .. "---" .. tostring(MFrigChk))
]]

	-- Ratio check
	local ProdWeightDestr = 1.00
	local ProdWeightMDestr = 0
	local ProdWeightMFrig = 0

	local ActualRatioDestr = 0
	local DiffActualRatioDestr = 0
	local ActualRatioMDestr = 0
	local DiffActualRatioMDestr = 0	
	local ActualRatioMFrig = 0
	local DiffActualRatioMFrig = 0
	
	if MDestrChk then
		ProdWeightDestr = ProdWeightDestr - 1.00
		ProdWeightMDestr = ProdWeightMDestr + 1.00
		--ProdWeightMFrig = ProdWeightMFrig
	end
	if MFrigChk then
		--ProdWeightDestr = ProdWeightDestr - 1.00
		ProdWeightMDestr = ProdWeightMDestr - 0.50
		ProdWeightMFrig = ProdWeightMFrig + 0.50
	end

-- Unit Ratio: Missile Destroyer
	ActualRatioMDestr = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_destroyer.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCoastDefense))
	DiffActualRatioMDestr = (ProdWeightMDestr - ActualRatioMDestr)
-- Unit Ratio: Missile Frigate
	ActualRatioMFrig = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_frigate.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCoastDefense))
	DiffActualRatioMFrig = (ProdWeightMFrig - ActualRatioMFrig)

--[[
Utils.LUA_DEBUGOUT("ProdWeightDestr: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightDestr))
Utils.LUA_DEBUGOUT("ProdWeightMDestr: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMDestr))
Utils.LUA_DEBUGOUT("ProdWeightMFrig: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMFrig))
]]

-- Start shift weights if big differences
	if DiffActualRatioMDestr >= 0.50 and MDestrChk then
		ProdWeightMDestr = ProdWeightMDestr + 0.30
		ProdWeightMFrig = ProdWeightMFrig - 0.30
	elseif DiffActualRatioMFrig >= 0.50 and MFrigChk then
		ProdWeightMDestr = ProdWeightMDestr - 0.30
		ProdWeightMFrig = ProdWeightMFrig + 0.30
	end
-- End shift weights if big differences

--[[
Utils.LUA_DEBUGOUT("DiffActualRatioDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioDestr))
Utils.LUA_DEBUGOUT("DiffActualRatioMDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMDestr))
Utils.LUA_DEBUGOUT("DiffActualRatioMFrig-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMFrig))
]]

	local SeaEscMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaEscort
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyDestr = rounddown(SeaEscMoney * ProdWeightDestr)
	local MoneyMDestr = rounddown(SeaEscMoney * ProdWeightMDestr)
	local MoneyMFrig = rounddown(SeaEscMoney * ProdWeightMFrig)
--[[
Utils.LUA_DEBUGOUT("MoneyDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyDestr))
Utils.LUA_DEBUGOUT("MoneyMDestr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMDestr))
Utils.LUA_DEBUGOUT("MoneyMFrig-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMFrig))
]]

	local ispuppet = nil												-- Use masters build scheme
	local has faction = nil												-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT

	if MoneyDestr > 0 then
		
		local SeaProduction = {
			Money = MoneyDestr,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_destroyer"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyMDestr > 0 then
		
		local SeaProduction = {
			Money = MoneyMDestr,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_missile_destroyer"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyMFrig > 0 then
		
		local SeaProduction = {
			Money = MoneyMFrig,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_missile_frigate"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

end

function BuildSeaSAGUnits(ActTagTbl)
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local CruiserChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].cruiser.Tech
	local MCruiserChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_cruiser.Tech
	local NBCruiserChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].nuclear_battlecruiser.Tech
	local BattleshipChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].battleship.Tech

--[[
	Utils.LUA_DEBUGOUT("----CruiserChk: " .. tostring(ActTag) .. "---" .. tostring(CruiserChk))
	Utils.LUA_DEBUGOUT("----MCruiserChk: " .. tostring(ActTag) .. "---" .. tostring(MCruiserChk))
	Utils.LUA_DEBUGOUT("----NBCruiserChk: " .. tostring(ActTag) .. "---" .. tostring(NBCruiserChk))
	Utils.LUA_DEBUGOUT("----BattleshipChk: " .. tostring(ActTag) .. "---" .. tostring(BattleshipChk))
]]

	-- Ratio check
	local ProdWeightCA = 1.00
	local ProdWeightMCA = 0
	local ProdWeightNBC = 0
	local ProdWeightBB = 0

	local ActualRatioCA = 0
	local DiffActualRatioCA = 0
	local ActualRatioMCA = 0
	local DiffActualRatioMCA = 0	
	local ActualRatioNBC = 0
	local DiffActualRatioNBC = 0
	local ActualRatioBB = 0
	local DiffActualRatioBB = 0
	

	if BattleshipChk then
		ProdWeightCA = ProdWeightCA - 0.10
		--ProdWeightMCA = ProdWeightMCA - 0.05
		--ProdWeightNBC = ProdWeightNBC 
		ProdWeightBB = ProdWeightBB + 0.10
	end
	if MCruiserChk then
		ProdWeightCA = ProdWeightCA - 0.90
		ProdWeightMCA = ProdWeightMCA + 0.90
		--ProdWeightNBC = ProdWeightNBC 
		--ProdWeightBB = ProdWeightBB
	end
	if NBCruiserChk then
		--ProdWeightCA = ProdWeightCA - 1.00
		ProdWeightMCA = ProdWeightMCA - 0.30
		ProdWeightNBC = ProdWeightNBC + 0.30
		--ProdWeightBB = ProdWeightBB - 0.30
	end

-- Unit Ratio: Cruiser
	ActualRatioCA = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].cruiser.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSAG))
	DiffActualRatioCA = (ProdWeightCA - ActualRatioCA)
-- Unit Ratio: Missile Cruiser
	ActualRatioMCA = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].missile_cruiser.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSAG))
	DiffActualRatioMCA = (ProdWeightMCA - ActualRatioMCA)
-- Unit Ratio: Nuclear Battlecruiser
	ActualRatioNBC = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].nuclear_battlecruiser.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSAG))
	DiffActualRatioNBC = (ProdWeightNBC - ActualRatioNBC)
-- Unit Ratio: Battleship
	ActualRatioBB = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].battleship.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSAG))
	DiffActualRatioBB = (ProdWeightBB - ActualRatioBB)


--[[
Utils.LUA_DEBUGOUT("ProdWeightBergs: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightBergs))
Utils.LUA_DEBUGOUT("ProdWeightMar: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMar))
Utils.LUA_DEBUGOUT("ProdWeightBergs: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightBergs))
Utils.LUA_DEBUGOUT("ProdWeightMar: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMar))
]]

-- Start shift weights if big differences
	if DiffActualRatioNBC >= 0.50 and NBCruiserChk then
		--ProdWeightCA = ProdWeightCA - 0.20
		ProdWeightMCA = ProdWeightMCA - 0.20
		--ProdWeightBB = ProdWeightBB - 0.10
		ProdWeightNBC = ProdWeightNBC + 0.20
	elseif DiffActualRatioMCA >= 0.50 and MCruiserChk then
		--ProdWeightCA = ProdWeightCA - 0.20
		ProdWeightMCA = ProdWeightMCA + 0.20
		--ProdWeightBB = ProdWeightBB - 0.10
		ProdWeightNBC = ProdWeightNBC - 0.20
	elseif DiffActualRatioCA >= 0.50 and CruiserChk then
		--ProdWeightCA = ProdWeightCA - 0.20
		ProdWeightMCA = ProdWeightMCA - 0.20
		--ProdWeightBB = ProdWeightBB - 0.10
		ProdWeightNBC = ProdWeightNBC + 0.20
	elseif DiffActualRatioBB >= 0.50 and BattleshipChk then
		ProdWeightCA = ProdWeightCA - 0.20
		ProdWeightBB = ProdWeightBB + 0.20
		if MCruiserChk then
			ProdWeightMCA = ProdWeightMCA - 0.20
			ProdWeightBB = ProdWeightBB + 0.10
		end
		if NBCruiserChk then
			ProdWeightNBC = ProdWeightNBC - 0.10
			ProdWeightBB = ProdWeightBB - 0.10
		end
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioCA-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCA))
Utils.LUA_DEBUGOUT("DiffActualRatioMCA-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMCA))
Utils.LUA_DEBUGOUT("DiffActualRatioBB-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioBB))
Utils.LUA_DEBUGOUT("DiffActualRatioNBC-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioNBC))
]]

	local SeaSAGMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSAG
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyCA = rounddown(SeaSAGMoney * ProdWeightCA)
	local MoneyMCA = rounddown(SeaSAGMoney * ProdWeightMCA)
	local MoneyBB = rounddown(SeaSAGMoney * ProdWeightBB)
	local MoneyNBC = rounddown(SeaSAGMoney * ProdWeightNBC)
--[[
Utils.LUA_DEBUGOUT("MoneyCA-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyCA))
Utils.LUA_DEBUGOUT("MoneyMCA-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMCA))
Utils.LUA_DEBUGOUT("MoneyBB-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyBB))
Utils.LUA_DEBUGOUT("MoneyNBC-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyNBC))
]]

	local ispuppet = nil												-- Use masters build scheme
	local has faction = nil												-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT

	if MoneyCA > 0 then
		
		local SeaProduction = {
			Money = MoneyCA,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_cruiser"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyMCA > 0 then
		
		local SeaProduction = {
			Money = MoneyMCA,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_missile_cruiser"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyNBC > 0 then
		
		local SeaProduction = {
			Money = MoneyNBC,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_nuclear_battlecruiser"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyBB > 0 then
		
		local SeaProduction = {
			Money = MoneyBB,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_battleship"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

end

function BuildSeaCarrierUnits(ActTagTbl)
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local CVEChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].escort_carrier.Tech
	local CVHChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].helicopter_carrier.Tech
	local CVChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].carrier.Tech
	local CVSChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].supercarrier.Tech

--[[
	Utils.LUA_DEBUGOUT("----CVEChk: " .. tostring(ActTag) .. "---" .. tostring(CVEChk))
	Utils.LUA_DEBUGOUT("----CVHChk: " .. tostring(ActTag) .. "---" .. tostring(CVHChk))
	Utils.LUA_DEBUGOUT("----CVChk: " .. tostring(ActTag) .. "---" .. tostring(CVChk))
	Utils.LUA_DEBUGOUT("----CVSChk: " .. tostring(ActTag) .. "---" .. tostring(CVSChk))
]]

	-- Ratio check
	local ProdWeightCVE = 1.00
	local ProdWeightCVH = 0
	local ProdWeightCV = 0
	local ProdWeightCVS = 0

	local ActualRatioCVE = 0
	local DiffActualRatioCVE = 0
	local ActualRatioCVH = 0
	local DiffActualRatioCVH = 0	
	local ActualRatioCV = 0
	local DiffActualRatioCV = 0
	local ActualRatioCVS = 0
	local DiffActualRatioCVS = 0

	if CVHChk then
		ProdWeightCVE = ProdWeightCVE - 0.20
		ProdWeightCVH = ProdWeightCVH + 0.20
		--ProdWeightCV = ProdWeightNBC - 0.05
		--ProdWeightCVS = ProdWeightCVS + 0.10
	end
	if CVChk then
		ProdWeightCVE = ProdWeightCVE - 0.50
		--ProdWeightCVH = ProdWeightMCA + 0.20
		ProdWeightCV = ProdWeightCV + 0.50
		--ProdWeightCVS = ProdWeightCVS + 0.10
	end
	if CVSChk then
		ProdWeightCVE = ProdWeightCVE - 0.20
		--ProdWeightCVH = ProdWeightMCA - 0.05
		--ProdWeightCV = ProdWeightNBC - 0.05
		ProdWeightCVS = ProdWeightCVS + 0.10
	end

-- Unit Ratio: escort_carrier
	ActualRatioCVE = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].escort_carrier.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCarrier))
	DiffActualRatioCVE = (ProdWeightCVE - ActualRatioCVE)
-- Unit Ratio: Heli Carrier
	ActualRatioCVH = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].helicopter_carrier.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCarrier))
	DiffActualRatioCVH = (ProdWeightCVH - ActualRatioCVH)
-- Unit Ratio: Carrier
	ActualRatioCV = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].carrier.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCarrier))
	DiffActualRatioCV = (ProdWeightCV - ActualRatioCV)
-- Unit Ratio: Supercarrier
	ActualRatioCVS = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].supercarrier.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllCarrier))
	DiffActualRatioCVS = (ProdWeightCVS - ActualRatioCVS)


--[[
Utils.LUA_DEBUGOUT("ProdWeightCVE: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCVE))
Utils.LUA_DEBUGOUT("ProdWeightCVH: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCVH))
Utils.LUA_DEBUGOUT("ProdWeightCV: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCV))
Utils.LUA_DEBUGOUT("ProdWeightCVS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCVS))
]]

-- Start shift weights if big differences
	if DiffActualRatioCVS >= 0.50 and CVSChk then
		ProdWeightCVE = ProdWeightCVE - 0.10
		ProdWeightCVH = ProdWeightCVH - 0.10
		ProdWeightCV = ProdWeightCV - 0.20
		ProdWeightCVS = ProdWeightCVS + 0.40
	elseif DiffActualRatioCV >= 0.50 and CVChk then
		ProdWeightCVE = ProdWeightCVE - 0.10
		ProdWeightCVH = ProdWeightCVH - 0.10
		ProdWeightCV = ProdWeightCV + 0.20
		--ProdWeightCVS = ProdWeightCVS + 0.20
	elseif DiffActualRatioCVH >= 0.50 and CVHChk then
		ProdWeightCVE = ProdWeightCVE - 0.10
		ProdWeightCVH = ProdWeightCVH + 0.30
		ProdWeightCV = ProdWeightCV - 0.30
		--ProdWeightCVS = ProdWeightCVS + 0.20
	elseif DiffActualRatioCVE >= 0.50 and CVEChk then
		if CVHChk then
			ProdWeightCVE = ProdWeightCVE + 0.10
			ProdWeightCVH = ProdWeightCVH - 0.10
		end
		if CVChk then
			ProdWeightCVE = ProdWeightCVE + 0.20
			ProdWeightCV = ProdWeightCVH - 0.20
		end
		--ProdWeightCVS = ProdWeightCVS + 0.20
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioCVE-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCVE))
Utils.LUA_DEBUGOUT("DiffActualRatioCVH-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCVH))
Utils.LUA_DEBUGOUT("DiffActualRatioCV-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCV))
Utils.LUA_DEBUGOUT("DiffActualRatioCVS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCVS))
]]

	local SeaCarrierMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaCarrier
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyCVE = 0--rounddown(SeaCarrierMoney * ProdWeightCVE)
	local MoneyCVH = 0--rounddown(SeaCarrierMoney * ProdWeightCVH)
	local MoneyCV = 0--rounddown(SeaCarrierMoney * ProdWeightCV)
	local MoneyCVS = 0--rounddown(SeaCarrierMoney * ProdWeightCVS)
--[[
Utils.LUA_DEBUGOUT("MoneyCA-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyCA))
Utils.LUA_DEBUGOUT("MoneyMCA-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMCA))
Utils.LUA_DEBUGOUT("MoneyBB-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyBB))
Utils.LUA_DEBUGOUT("MoneyNBC-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyNBC))
]]


	if MoneyCVE > 0 then
		
		local SeaProduction = {
			Money = MoneyCVE,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_escort_carrier"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyCVH > 0 then
		
		local SeaProduction = {
			Money = MoneyCVH,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_helicopter_carrier"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyCV > 0 then
		
		local SeaProduction = {
			Money = MoneyCV,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_carrier"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyCVS > 0 then
		
		local SeaProduction = {
			Money = MoneyCVS,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_supercarrier"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

end

function BuildSeaSubUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local SubChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].submarine.Tech
	local AttSubChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].attack_submarine.Tech
	local NucAttSubChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].nuclear_submarine.Tech
	local GuidedSubChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].guided_submarine.Tech
	local NucGuidSubChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].nuclear_guided_submarine.Tech
	local BMSubChk = Grand_Units_Table["SeaUnits-" .. ActTagTbl].ballistic_missile_submarine.Tech
	
--[[
	Utils.LUA_DEBUGOUT("----SubChk: " .. tostring(ActTag) .. "---" .. tostring(SubChk))
	Utils.LUA_DEBUGOUT("----AttSubChk: " .. tostring(ActTag) .. "---" .. tostring(AttSubChk))
	Utils.LUA_DEBUGOUT("----GuidedSubChk: " .. tostring(ActTag) .. "---" .. tostring(GuidedSubChk))
	Utils.LUA_DEBUGOUT("----NucSubChk: " .. tostring(ActTag) .. "---" .. tostring(NucSubChk))
	Utils.LUA_DEBUGOUT("----BMSubChk: " .. tostring(ActTag) .. "---" .. tostring(BMSubChk))
]]

	-- Ratio check
	local ProdWeightSS = 1.00
	local ProdWeightASS = 0
	local ProdWeightNASS = 0
	local ProdWeightGSS = 0
	local ProdWeightNGSS = 0
	local ProdWeightBMSS = 0

	local ActualRatioSS = 0
	local DiffActualRatioSS = 0
	local ActualRatioASS = 0
	local DiffActualRatioASS = 0
	local ActualRatioNASS = 0
	local DiffActualRatioNASS = 0
	local ActualRatioGSS = 0
	local DiffActualRatioGSS = 0
	local ActualRatioNGSS = 0
	local DiffActualRatioNGSS = 0
	local ActualRatioBMSS = 0
	local DiffActualRatioBMSS = 0	


	if AttSubChk then
		ProdWeightSS = ProdWeightSS - 0.95
		ProdWeightASS = ProdWeightASS + 0.95
	end
	if NucAttSubChk then
		ProdWeightSS = ProdWeightSS - 0.05
		ProdWeightASS = ProdWeightASS - 0.90
		ProdWeightNASS = ProdWeightNASS + 0.95
	end
	if GuidedSubChk then
		ProdWeightASS = ProdWeightASS - 0.50
		ProdWeightNASS = ProdWeightNASS - 0.50
		ProdWeightGSS = ProdWeightGSS + 0.50
	end
	if NucGuidSubChk then
		ProdWeightNASS = ProdWeightNASS - 0.40
		ProdWeightGSS = ProdWeightGSS - 0.45
		ProdWeightNGSS = ProdWeightNGSS + 0.50
	end
	if BMSubChk then
		ProdWeightSS = ProdWeightSS - 0.05
		ProdWeightASS = ProdWeightASS - 0.05
		ProdWeightNASS = ProdWeightNASS - 0.05
		ProdWeightGSS = ProdWeightGSS - 0.05
		ProdWeightNGSS = ProdWeightNGSS - 0.05
		ProdWeightBMSS = ProdWeightBMSS + 0.15
	end

-- Unit Ratio: Submarine
	ActualRatioSS = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].submarine.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSubmarine))
	DiffActualRatioSS = (ProdWeightSS - ActualRatioSS)
-- Unit Ratio: Attack Submarine
	ActualRatioASS = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].attack_submarine.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSubmarine))
	DiffActualRatioASS = (ProdWeightASS - ActualRatioASS)
-- Unit Ratio: Nuclear Attack Submarine
	ActualRatioNASS = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].nuclear_submarine.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSubmarine))
	DiffActualRatioNASS = (ProdWeightNASS - ActualRatioNASS)
-- Unit Ratio: Missile Submarine
	ActualRatioGSS = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].guided_submarine.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSubmarine))
	DiffActualRatioGSS = (ProdWeightGSS - ActualRatioGSS)
-- Unit Ratio: Nuclear Missile Submarine
	ActualRatioNGSS = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].nuclear_guided_submarine.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSubmarine))
	DiffActualRatioNGSS = (ProdWeightNGSS - ActualRatioNGSS)
-- Unit Ratio: Nuclear Balistic Missile Submarine
	ActualRatioBMSS = ((Grand_Units_Table["SeaUnits-" .. ActTagTbl].ballistic_missile_submarine.ActCountAll) / (Grand_Units_Table["TotalCountSea-" .. ActTagTbl].CountAllSubmarine))
	DiffActualRatioBMSS = (ProdWeightBMSS - ActualRatioBMSS)

--[[
Utils.LUA_DEBUGOUT("ProdWeightSS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightSS))
Utils.LUA_DEBUGOUT("ProdWeightASS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightASS))
Utils.LUA_DEBUGOUT("ProdWeightNASS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightNASS))
Utils.LUA_DEBUGOUT("ProdWeightGSS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightGSS))
Utils.LUA_DEBUGOUT("ProdWeightNGSS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightNGSS))
Utils.LUA_DEBUGOUT("ProdWeightBMSS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightBMSS))
]]

-- Start shift weights if big differences
	if DiffActualRatioBMSS >= 0.50 and BMSubChk then
		ProdWeightSS = ProdWeightSS - 0.05
		ProdWeightASS = ProdWeightASS - 0.05
		ProdWeightNASS = ProdWeightNASS - 0.05
		ProdWeightGSS = ProdWeightGSS - 0.05
		ProdWeightNGSS = ProdWeightNGSS - 0.05
		ProdWeightBMSS = ProdWeightBMSS + 0.20
	elseif DiffActualRatioASS >= 0.50 and AttSubChk then
		ProdWeightSS = ProdWeightSS - 0.05
		ProdWeightASS = ProdWeightASS + 0.20
		ProdWeightNASS = ProdWeightNASS - 0.05
		ProdWeightGSS = ProdWeightGSS - 0.05
		ProdWeightNGSS = ProdWeightNGSS - 0.05
		ProdWeightBMSS = ProdWeightBMSS - 0.05
	elseif DiffActualRatioNASS >= 0.50 and NucAttSubChk then
		ProdWeightSS = ProdWeightSS - 0.05
		ProdWeightASS = ProdWeightASS - 0.05
		ProdWeightNASS = ProdWeightNASS + 0.20
		ProdWeightGSS = ProdWeightGSS - 0.05
		ProdWeightNGSS = ProdWeightNGSS - 0.05
		ProdWeightBMSS = ProdWeightBMSS - 0.05
	elseif DiffActualRatioGSS >= 0.50 and GuidedSubChk then
		ProdWeightSS = ProdWeightSS - 0.05
		ProdWeightASS = ProdWeightASS - 0.05
		ProdWeightNASS = ProdWeightNASS - 0.05
		ProdWeightGSS = ProdWeightGSS + 0.20
		ProdWeightNGSS = ProdWeightNGSS - 0.05
		ProdWeightBMSS = ProdWeightBMSS - 0.05
	elseif DiffActualRatioNGSS >= 0.50 and NucGuidSubChk then
		ProdWeightSS = ProdWeightSS - 0.05
		ProdWeightASS = ProdWeightASS - 0.05
		ProdWeightNASS = ProdWeightNASS - 0.05
		ProdWeightGSS = ProdWeightGSS - 0.05
		ProdWeightNGSS = ProdWeightNGSS + 0.20
		ProdWeightBMSS = ProdWeightBMSS - 0.05
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioSS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioSS))
Utils.LUA_DEBUGOUT("DiffActualRatioASS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioASS))
Utils.LUA_DEBUGOUT("DiffActualRatioNASS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioNASS))
Utils.LUA_DEBUGOUT("DiffActualRatioGSS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioGSS))
Utils.LUA_DEBUGOUT("DiffActualRatioNGSS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioNGSS))
Utils.LUA_DEBUGOUT("DiffActualRatioBMSS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioBMSS))
]]

	local SeaSubMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdSeaSub
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneySS = rounddown(SeaSubMoney * ProdWeightSS)
	local MoneyASS = rounddown(SeaSubMoney * ProdWeightASS)
	local MoneyNASS = rounddown(SeaSubMoney * ProdWeightNASS)
	local MoneyGSS = rounddown(SeaSubMoney * ProdWeightGSS)
	local MoneyNGSS = rounddown(SeaSubMoney * ProdWeightNGSS)
	local MoneyBMSS = rounddown(SeaSubMoney * ProdWeightBMSS)
--[[
Utils.LUA_DEBUGOUT("MoneySS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneySS))
Utils.LUA_DEBUGOUT("MoneyASS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyASS))
Utils.LUA_DEBUGOUT("MoneyNASS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyNASS))
Utils.LUA_DEBUGOUT("MoneyGSS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyGSS))
Utils.LUA_DEBUGOUT("MoneyNGSS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyNGSS))
Utils.LUA_DEBUGOUT("MoneyBMSS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyBMSS))
]]

	local ispuppet = nil												-- Use masters build scheme
	local has faction = nil												-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT

	if MoneySS > 0 then
		
		local SeaProduction = {
			Money = MoneySS,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_submarine"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyASS > 0 then
		
		local SeaProduction = {
			Money = MoneyASS,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_attack_submarine"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyNASS > 0 then
		
		local SeaProduction = {
			Money = MoneyNASS,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_nuclear_attack_submarine"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyGSS > 0 then
		
		local SeaProduction = {
			Money = MoneyGSS,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_guided_submarine"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyNGSS > 0 then
		
		local SeaProduction = {
			Money = MoneyNGSS,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_nuclear_guided_submarine"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

	if MoneyBMSS > 0 then
		
		local SeaProduction = {
			Money = MoneyBMSS,
			BuildArea = tostring("_Ships"),
			BuildDiv = tostring("_ballistic_missile_submarine"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["SeaProduction-" .. ActTagTbl] = SeaProduction
		
		ProdTable = "SeaProduction-"
		ShipProduction(ActTagTbl, ProdTable)
	end

end
-- ###################################
-- # End of Sea Units Build


-- # Start of Air Units Build
-- ###################################
function BuildAirUnitsMain(ActTagTbl)

	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local SeaAvail = Grand_Country_Table["Country-" .. ActTagTbl].SeaAvail

--  Basic Ratio set
	local ProdWeightFighterRatio = 0.55
	local ProdWeightGroundRatio = 0.20
	local ProdWeightBomberRatio = 0.15
	local ProdWeightNavalRatio = 0
	local ProdWeightReconRatio = 0.10
	if SeaAvail then
		ProdWeightFighterRatio = 0.50
		ProdWeightGroundRatio = 0.14
		ProdWeightBomberRatio = 0.13
		ProdWeightNavalRatio = 0.13
		ProdWeightReconRatio = 0.10
	end

	-- Start Armament Policy influence to weight the production more in favour of the active policy
	-- note: change this to index!
	local ArmamentPolicy = CPolicyDataBase.GetPolicy(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.CurrentPolicy)
	local ArmamentPolicyName = ArmamentPolicy:GetKey()
--"conventional_warfare_focus_pol" or "combined_arms_focus_pol" or "assymetric_warfare_focus_pol")
--"littoral_waters_focus_pol" or "blue_waters_focus_pol" or "submarine_focus_pol") and SeaAvail 
	if (ArmamentPolicyName == "fighter_focus_pol") then
--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Fighter Policy Focus(AIR check): " .. tostring(ArmamentPolicyName))
		if SeaAvail then
			ProdWeightFighterRatio = ProdWeightFighterRatio + 0.20
			ProdWeightGroundRatio = ProdWeightGroundRatio - 0.05
			ProdWeightBomberRatio = ProdWeightBomberRatio - 0.05
			ProdWeightNavalRatio = ProdWeightNavalRatio - 0.05
			ProdWeightReconRatio = ProdWeightReconRatio - 0.05
		else
			ProdWeightFighterRatio = ProdWeightFighterRatio + 0.20
			ProdWeightGroundRatio = ProdWeightGroundRatio - 0.08
			ProdWeightBomberRatio = ProdWeightBomberRatio - 0.07
			ProdWeightReconRatio = ProdWeightReconRatio - 0.05
		end
	elseif (ArmamentPolicyName == "bomber_focus_pol") then
--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Bomber Policy Focus(AIR check): " .. tostring(ArmamentPolicyName))
		if SeaAvail then
			ProdWeightFighterRatio = ProdWeightFighterRatio - 0.05
			ProdWeightGroundRatio = ProdWeightGroundRatio - 0.05
			ProdWeightBomberRatio = ProdWeightBomberRatio + 0.15
			ProdWeightNavalRatio = ProdWeightNavalRatio - 0.05
			--ProdWeightReconRatio = ProdWeightReconRatio - 0.05
		else
			ProdWeightFighterRatio = ProdWeightFighterRatio - 0.08
			ProdWeightGroundRatio = ProdWeightGroundRatio - 0.07
			ProdWeightBomberRatio = ProdWeightBomberRatio + 0.15
			--ProdWeightReconRatio = ProdWeightReconRatio - 0.05
		end
	elseif (ArmamentPolicyName == ("close_air_support_focus_pol" or "combined_arms_focus_pol")) then
--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has CAS Policy Focus(AIR check): " .. tostring(ArmamentPolicyName))
		if SeaAvail then
			ProdWeightFighterRatio = ProdWeightFighterRatio - 0.05
			ProdWeightGroundRatio = ProdWeightGroundRatio + 0.15
			ProdWeightBomberRatio = ProdWeightBomberRatio - 0.05
			ProdWeightNavalRatio = ProdWeightNavalRatio - 0.05
			--ProdWeightReconRatio = ProdWeightReconRatio - 0.05
		else
			ProdWeightFighterRatio = ProdWeightFighterRatio - 0.08
			ProdWeightGroundRatio = ProdWeightGroundRatio + 0.15
			ProdWeightBomberRatio = ProdWeightBomberRatio - 0.07
			--ProdWeightReconRatio = ProdWeightReconRatio - 0.05
		end
	elseif (ArmamentPolicyName == "littoral_waters_focus_pol" or "blue_waters_focus_pol" or "submarine_focus_pol") and SeaAvail then
--Utils.LUA_DEBUGOUT(tostring(ActTag) .. "-- has Naval Policy Focus(AIR check): " .. tostring(ArmamentPolicyName))
		ProdWeightFighterRatio = ProdWeightFighterRatio - 0.05
		ProdWeightGroundRatio = ProdWeightGroundRatio - 0.05
		ProdWeightBomberRatio = ProdWeightBomberRatio - 0.05
		ProdWeightNavalRatio = ProdWeightNavalRatio + 0.15
		--ProdWeightReconRatio = ProdWeightReconRatio - 0.10
	end
	-- End Armament Policy influence to weight the production more in favour of the active policy

-- Actual unit ratio
	local ActualUnitRatioFighter = 0
	local ActualUnitRatioGround = 0
	local ActualUnitRatioBomber = 0
	local ActualUnitRatioNaval = 0
	local ActualUnitRatioRecon = 0
	local DiffActualUnitRatioFighter = 0
	local DiffActualUnitRatioGround = 0
	local DiffActualUnitRatioBomber = 0
	local DiffActualUnitRatioNaval = 0
	local DiffActualUnitRatioRecon = 0

	ActualUnitRatioFighter = ((Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllFighter) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllAir))
	ActualUnitRatioGround = ((Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllGround) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllAir))
	ActualUnitRatioBomber = ((Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllBomber) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllAir))
	ActualUnitRatioNaval = ((Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllMaritime) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllAir))
	ActualUnitRatioRecon = ((Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllSupport) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllAir))
	
-- Difference?
	DiffActualUnitRatioFighter = (ProdWeightFighterRatio - ActualUnitRatioFighter)
	DiffActualUnitRatioGround = (ProdWeightGroundRatio - ActualUnitRatioGround)
	DiffActualUnitRatioBomber = (ProdWeightBomberRatio - ActualUnitRatioBomber)
	DiffActualUnitRatioNaval = (ProdWeightNavalRatio - ActualUnitRatioNaval)
	DiffActualUnitRatioRecon = (ProdWeightReconRatio - ActualUnitRatioRecon)
--[[
Utils.LUA_DEBUGOUT("ActualUnitRatioFighter" .. tostring(ActTag) .. tostring(ActualUnitRatioFighter))
Utils.LUA_DEBUGOUT("ActualUnitRatioGround" .. tostring(ActTag) .. tostring(ActualUnitRatioGround))
Utils.LUA_DEBUGOUT("ActualUnitRatioBomber" .. tostring(ActTag) .. tostring(ActualUnitRatioBomber))
Utils.LUA_DEBUGOUT("ActualUnitRatioNaval" .. tostring(ActTag) .. tostring(ActualUnitRatioNaval))
Utils.LUA_DEBUGOUT("ActualUnitRatioRecon" .. tostring(ActTag) .. tostring(ActualUnitRatioRecon))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioFighter" .. tostring(ActTag) .. tostring(DiffActualUnitRatioFighter))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioGround" .. tostring(ActTag) .. tostring(DiffActualUnitRatioGround))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioBomber" .. tostring(ActTag) .. tostring(DiffActualUnitRatioBomber))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioNaval" .. tostring(ActTag) .. tostring(DiffActualUnitRatioNaval))
Utils.LUA_DEBUGOUT("DiffActualUnitRatioRecon" .. tostring(ActTag) .. tostring(DiffActualUnitRatioRecon))
]]

-- Shift weights if big differences
	if DiffActualUnitRatioFighter >= 0.50 then
		ProdWeighFighterRatio = ProdWeightFighterRatio + 0.20
		ProdWeightGroundRatio = ProdWeightGroundRatio - 0.08
		ProdWeightBomberRatio = ProdWeightBomberRatio - 0.07
		ProdWeightReconRatio = ProdWeightReconRatio - 0.05
	elseif DiffActualUnitRatioGround >= 0.25 then
		ProdWeighFighterRatio = ProdWeightFighterRatio - 0.13
		ProdWeightGroundRatio = ProdWeightGroundRatio + 0.25
		ProdWeightBomberRatio = ProdWeightBomberRatio - 0.07
		ProdWeightReconRatio = ProdWeightReconRatio - 0.05
	elseif DiffActualUnitRatioBomber >= 0.50 then
		ProdWeighFighterRatio = ProdWeightFighterRatio - 0.12
		ProdWeightGroundRatio = ProdWeightGroundRatio - 0.08
		ProdWeightBomberRatio = ProdWeightBomberRatio + 0.25
		ProdWeightReconRatio = ProdWeightReconRatio - 0.05
	elseif DiffActualUnitRatioRecon >= 0.50 then
		ProdWeighFighterRatio = ProdWeightFighterRatio + 0.20
		ProdWeightGroundRatio = ProdWeightGroundRatio - 0.08
		ProdWeightBomberRatio = ProdWeightBomberRatio - 0.07
		ProdWeightReconRatio = ProdWeightReconRatio - 0.05
	elseif DiffActualUnitRatioNaval >= 0.50 then
		ProdWeighFighterRatio = ProdWeightFighterRatio - 0.10
		ProdWeightGroundRatio = ProdWeightGroundRatio - 0.05
		ProdWeightBomberRatio = ProdWeightBomberRatio - 0.05
		ProdWeightReconRatio = ProdWeightReconRatio - 0.05
		ProdWeightNavalRatio = ProdWeightNavalRatio + 0.25
	end
--[[
Utils.LUA_DEBUGOUT("ProdWeighFighterRatio" .. tostring(ActTag) .. tostring(ProdWeighFighterRatio))
Utils.LUA_DEBUGOUT("ProdWeightGroundRatio" .. tostring(ActTag) .. tostring(ProdWeightGroundRatio))
Utils.LUA_DEBUGOUT("ProdWeightBomberRatio" .. tostring(ActTag) .. tostring(ProdWeightBomberRatio))
Utils.LUA_DEBUGOUT("ProdWeightNavalRatio" .. tostring(ActTag) .. tostring(ProdWeightNavalRatio))
Utils.LUA_DEBUGOUT("ProdWeightReconRatio" .. tostring(ActTag) .. tostring(ProdWeightReconRatio))
]]

-- Available IC for Sea Sections
	local MoneyAirUnits = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAir
	local rounddown = math.floor
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirFighter = rounddown(MoneyAirUnits * ProdWeightFighterRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirGround = rounddown(MoneyAirUnits * ProdWeightGroundRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirBomber = rounddown(MoneyAirUnits * ProdWeightBomberRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirNaval = rounddown(MoneyAirUnits * ProdWeightNavalRatio)
	Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirSpecial = rounddown(MoneyAirUnits * ProdWeightReconRatio)

--[[
Utils.LUA_DEBUGOUT("Money Fighter-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirFighter))
Utils.LUA_DEBUGOUT("Money Ground-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirGround))
Utils.LUA_DEBUGOUT("Money Bomber-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirBomber))
Utils.LUA_DEBUGOUT("Money Naval-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirNaval))
Utils.LUA_DEBUGOUT("Money Recon-FINAL: " .. tostring(ActTag) .. "---" .. tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirRecon))
]]

	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirFighter) > 0 then
		BuildAirFighterUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirGround) > 0 then
		BuildAirGroundUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirBomber) > 0 then
		BuildAirBomberUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirNaval) > 0 then
		BuildAirNavalUnits(ActTagTbl)
	end
	if (Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirSpecial) > 0 then
		BuildAirSpecialUnits(ActTagTbl)
	end

end

function BuildAirFighterUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local FtrChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].fighter.Tech
	local MtrlChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].multi_role.Tech
	
--[[
	Utils.LUA_DEBUGOUT("----FtrChk: " .. tostring(ActTag) .. "---" .. tostring(FtrChk))
	Utils.LUA_DEBUGOUT("----MtrlChk: " .. tostring(ActTag) .. "---" .. tostring(MtrlChk))
]]

	-- Ratio check
	local ProdWeightFtr = 1.00
	local ProdWeightMtrl = 0

	local ActualRatioFtr = 0
	local DiffActualRatioFtr = 0
	local ActualRatioMtrl = 0
	local DiffActualRatioMtrl = 0

	if MtrlChk then
		ProdWeightFtr = ProdWeightFtr - 0.60
		ProdWeightMtrl = ProdWeightMtrl + 0.60
	end

-- Unit Ratio: Fighter
	ActualRatioFtr = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].fighter.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllFighter))
	DiffActualRatioFtr = (ProdWeightFtr - ActualRatioFtr)
-- Unit Ratio: Attack Multirole
	ActualRatioMtrl = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].multi_role.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllFighter))
	DiffActualRatioMtrl = (ProdWeightMtrl - ActualRatioMtrl)

--[[
Utils.LUA_DEBUGOUT("ProdWeightFtr: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightFtr))
Utils.LUA_DEBUGOUT("ProdWeightMtrl: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightMtrl))
]]

-- Start shift weights if big differences
	if DiffActualRatioFtr >= 0.50 and MtrlChk then
		ProdWeightFtr = ProdWeightFtr + 0.20
		ProdWeightMtrl = ProdWeightMtrl - 0.20
	elseif DiffActualRatioMtrl >= 0.50 then
		ProdWeightFtr = ProdWeightFtr - 0.20
		ProdWeightMtrl = ProdWeightMtrl + 0.20
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioFtr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioFtr))
Utils.LUA_DEBUGOUT("DiffActualRatioMtrl-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioMtrl))
]]

	local AirFighterMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirFighter
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyFtr = rounddown(AirFighterMoney * ProdWeightFtr)
	local MoneyMtrl = rounddown(AirFighterMoney * ProdWeightMtrl)

--[[
Utils.LUA_DEBUGOUT("MoneyFtr-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyFtr))
Utils.LUA_DEBUGOUT("MoneyMtrl-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyMtrl))
]]

	if MoneyFtr > 0 then
		
		local AirProduction = {
			Money = MoneyFtr,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_fighter"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

	if MoneyMtrl > 0 then
		
		local AirProduction = {
			Money = MoneyMtrl,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_multi_role"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

end

function BuildAirGroundUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local CASChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].cas.Tech
	local HCASChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].helo_cas.Tech
	local HGunChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].helo_gunship.Tech
	
--[[
	Utils.LUA_DEBUGOUT("----CASChk: " .. tostring(ActTag) .. "---" .. tostring(CASChk))
	Utils.LUA_DEBUGOUT("----HCASChk: " .. tostring(ActTag) .. "---" .. tostring(HCASChk))
	Utils.LUA_DEBUGOUT("----HGunChk: " .. tostring(ActTag) .. "---" .. tostring(HGunChk))
]]

	-- Ratio check
	local ProdWeightCAS = 1.00
	local ProdWeightHCAS = 0
	local ProdWeightHGun = 0

	local ActualRatioCAS = 0
	local DiffActualRatioCAS = 0
	local ActualRatioHCAS = 0
	local DiffActualRatioHCAS = 0
	local ActualRatioHGun = 0
	local DiffActualRatioHGun = 0

	if HCASChk or HGunChk then
		ProdWeightCAS = ProdWeightCAS - 0.60
		ProdWeightHCAS = ProdWeightHCAS + 0.30
		ProdWeightHGun = ProdWeightHGun + 0.30
	end

-- Unit Ratio: CAS
	ActualRatioCAS = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].cas.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllGround))
	DiffActualRatioCAS = (ProdWeightCAS - ActualRatioCAS)
-- Unit Ratio: Helo CAS
	ActualRatioHCAS = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].helo_cas.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllGround))
	DiffActualRatioHCAS = (ProdWeightHCAS - ActualRatioHCAS)
-- Unit Ratio: Helo Gunship
	ActualRatioHGun = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].helo_gunship.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllGround))
	DiffActualRatioHGun = (ProdWeightHGun - ActualRatioHGun)

--[[
Utils.LUA_DEBUGOUT("ProdWeightCAS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightCAS))
Utils.LUA_DEBUGOUT("ProdWeightHCAS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightHCAS))
Utils.LUA_DEBUGOUT("ProdWeightHGun: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightHGun))
]]

-- Start shift weights if big differences
	if DiffActualRatioHGun >= 0.50 and HGunChk then
		ProdWeightCAS = ProdWeightCAS - 0.10
		ProdWeightHCAS = ProdWeightHCAS - 0.10
		ProdWeightHGun = ProdWeightHGun + 0.20
	elseif DiffActualRatioHCAS >= 0.50 and HCASChk then
		ProdWeightCAS = ProdWeightCAS - 0.10
		ProdWeightHCAS = ProdWeightHCAS + 0.20
		ProdWeightHGun = ProdWeightHGun - 0.10
	elseif DiffActualRatioCAS >= 0.50 and HCASChk and HGunChk then
		ProdWeightCAS = ProdWeightCAS + 0.20
		ProdWeightHCAS = ProdWeightHCAS - 0.10
		ProdWeightHGun = ProdWeightHGun - 0.10
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioCAS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioCAS))
Utils.LUA_DEBUGOUT("DiffActualRatioHCAS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioHCAS))
Utils.LUA_DEBUGOUT("DiffActualRatioHGun-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioHGun))
]]

	local AirGroundMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirGround
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyCAS = rounddown(AirGroundMoney * ProdWeightCAS)
	local MoneyHCAS = rounddown(AirGroundMoney * ProdWeightHCAS)
	local MoneyHGun = rounddown(AirGroundMoney * ProdWeightHGun)
--[[
Utils.LUA_DEBUGOUT("MoneyCAS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyCAS))
Utils.LUA_DEBUGOUT("MoneyHCAS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyHCAS))
Utils.LUA_DEBUGOUT("MoneyHGun-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyHGun))
]]


	if MoneyCAS > 0 then
		
		local AirProduction = {
			Money = MoneyCAS,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_cas"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

	if MoneyHCAS > 0 then
		
		local AirProduction = {
			Money = MoneyHCAS,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_helo_cas"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

	if MoneyHGun > 0 then
		
		local AirProduction = {
			Money = MoneyHGun,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_helo_gunship"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

end

function BuildAirBomberUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local StrBombChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_strike.Tech
	local StratBombChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_strategic.Tech
	
--[[
	Utils.LUA_DEBUGOUT("----StrBombChk: " .. tostring(ActTag) .. "---" .. tostring(StrBombChk))
	Utils.LUA_DEBUGOUT("----StratBombChk: " .. tostring(ActTag) .. "---" .. tostring(StratBombChk))
]]

	-- Ratio check
	local ProdWeightStrBombChk = 1.00
	local ProdWeightStratBomb = 0

	local ActualRatioStrBombChk = 0
	local DiffActualRatioStrBombChk = 0
	local ActualRatioStratBomb = 0
	local DiffActualRatioStratBomb = 0

	if StratBombChk then
		ProdWeightStrBombChk = ProdWeightStrBombChk - 0.50
		ProdWeightStratBomb = ProdWeightStratBomb + 0.50
	end

-- Unit Ratio: Strike Bomber
	ActualRatioStrBombChk = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_strike.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllBomber))
	DiffActualRatioStrBombChk = (ProdWeightStrBombChk - ActualRatioStrBombChk)
-- Unit Ratio: Strategic Bomber
	ActualRatioStratBomb = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_strategic.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllBomber))
	DiffActualRatioStratBomb = (ProdWeightStratBomb - ActualRatioStratBomb)

--[[
Utils.LUA_DEBUGOUT("ProdWeightStrBombChk: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightStrBombChk))
Utils.LUA_DEBUGOUT("ProdWeightStratBomb: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightStratBomb))
]]

-- Start shift weights if big differences
	if DiffActualRatioStrBombChk >= 0.50 and StrBombChk then
		ProdWeightStrBombChk = ProdWeightStrBombChk + 0.20
		ProdWeightStratBomb = ProdWeightStratBomb - 0.20
	elseif DiffActualRatioStratBomb >= 0.50 and StratBombChk then
		ProdWeightStrBombChk = ProdWeightStrBombChk - 0.20
		ProdWeightStratBomb = ProdWeightStratBomb + 0.20
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioStrBombChk-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioStrBombChk))
Utils.LUA_DEBUGOUT("DiffActualRatioStratBomb-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioStratBomb))
]]

	local AirBomberMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirBomber
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyStrBombChk = rounddown(AirBomberMoney * ProdWeightStrBombChk)
	local MoneyStratBomb = rounddown(AirBomberMoney * ProdWeightStratBomb)
--[[
Utils.LUA_DEBUGOUT("MoneyStrBombChk-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyStrBombChk))
Utils.LUA_DEBUGOUT("MoneyStratBomb-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyStratBomb))
]]


	if MoneyStrBombChk > 0 then
		
		local AirProduction = {
			Money = MoneyStrBombChk,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_bomber_strike"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

	if MoneyStratBomb > 0 then
		
		local AirProduction = {
			Money = MoneyStratBomb,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_bomber_strategic"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

end

function BuildAirNavalUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local ASWChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_antisub.Tech
	local NavChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_maritime.Tech
	local HNavChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].helo_maritime.Tech
	
--[[
	Utils.LUA_DEBUGOUT("----ASWChk: " .. tostring(ActTag) .. "---" .. tostring(ASWChk))
	Utils.LUA_DEBUGOUT("----NavChk: " .. tostring(ActTag) .. "---" .. tostring(NavChk))
	Utils.LUA_DEBUGOUT("----HNavChk: " .. tostring(ActTag) .. "---" .. tostring(HNavChk))
]]

	-- Ratio check
	local ProdWeightASW = 0.50
	local ProdWeightNav = 0.50
	local ProdWeightHNav = 0

	local ActualRatioASW = 0
	local DiffActualRatioASW = 0
	local ActualRatioNav = 0
	local DiffActualRatioNav = 0
	local ActualRatioHNav = 0
	local DiffActualRatioHNav = 0

	if HNavChk then
		ProdWeightASW = ProdWeightASW - 0.15
		ProdWeightNav = ProdWeightNav - 0.15
		ProdWeightHNav = ProdWeightHNav + 0.30
	end

-- Unit Ratio: ASW
	ActualRatioASW = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_antisub.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllNaval))
	DiffActualRatioASW = (ProdWeightASW - ActualRatioASW)
-- Unit Ratio: Helo CAS
	ActualRatioNav = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].bomber_maritime.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllNaval))
	DiffActualRatioNav = (ProdWeightNav - ActualRatioNav)
-- Unit Ratio: Helo Gunship
	ActualRatioHNav = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].helo_maritime.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllNaval))
	DiffActualRatioHNav = (ProdWeightHNav - ActualRatioHNav)

--[[
Utils.LUA_DEBUGOUT("ProdWeightASW: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightASW))
Utils.LUA_DEBUGOUT("ProdWeightNav: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightNav))
Utils.LUA_DEBUGOUT("ProdWeightHNav: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightHNav))
]]

-- Start shift weights if big differences
	if DiffActualRatioHNav >= 0.50 and HNavChk then
		ProdWeightASW = ProdWeightASW - 0.10
		ProdWeightNav = ProdWeightNav - 0.10
		ProdWeightHNav = ProdWeightHNav + 0.20
	elseif DiffActualRatioNav >= 0.50 and NavChk then
		ProdWeightASW = ProdWeightASW - 0.10
		ProdWeightNav = ProdWeightNav + 0.20
		ProdWeightHNav = ProdWeightHNav - 0.10
	elseif DiffActualRatioASW >= 0.50 and NavChk and HNavChk then
		ProdWeightASW = ProdWeightASW + 0.20
		ProdWeightNav = ProdWeightNav - 0.10
		ProdWeightHNav = ProdWeightHNav - 0.10
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioASW-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioASW))
Utils.LUA_DEBUGOUT("DiffActualRatioNav-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioNav))
Utils.LUA_DEBUGOUT("DiffActualRatioHNav-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioHNav))
]]

	local AirNavalMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirNaval
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyASW = rounddown(AirNavalMoney * ProdWeightASW)
	local MoneyNav = rounddown(AirNavalMoney * ProdWeightNav)
	local MoneyHNav = rounddown(AirNavalMoney * ProdWeightHNav)
--[[
Utils.LUA_DEBUGOUT("MoneyASW-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyASW))
Utils.LUA_DEBUGOUT("MoneyNav-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyNav))
Utils.LUA_DEBUGOUT("MoneyHNav-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyHNav))
]]


	if MoneyASW > 0 then
		
		local AirProduction = {
			Money = MoneyASW,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_bomber_antisub"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

	if MoneyNav > 0 then
		
		local AirProduction = {
			Money = MoneyNav,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_bomber_maritime"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

	if MoneyHNav > 0 then
		
		local AirProduction = {
			Money = MoneyHNav,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_helo_maritime"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

end

function BuildAirSpecialUnits(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId

	-- Unit availibility check
	local RecChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].recon_plane.Tech
	local AWACSChk = Grand_Units_Table["AirUnits-" .. ActTagTbl].awacs_air_plane.Tech

--[[
	Utils.LUA_DEBUGOUT("----RecChk: " .. tostring(ActTag) .. "---" .. tostring(RecChk))
	Utils.LUA_DEBUGOUT("----AWACSChk: " .. tostring(ActTag) .. "---" .. tostring(AWACSChk))
]]

	-- Ratio check
	local ProdWeightRec = 1.00
	local ProdWeightAWACS = 0

	local ActualRatioRec = 0
	local DiffActualRatioRec = 0
	local ActualRatioAWACS = 0
	local DiffActualRatioAWACS = 0

	if AWACSChk then
		ProdWeightRec = ProdWeightRec - 0.60
		ProdWeightAWACS = ProdWeightAWACS + 0.60
	end

-- Unit Ratio: Recon
	ActualRatioRec = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].recon_plane.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllSupport))
	DiffActualRatioRec = (ProdWeightRec - ActualRatioRec)
-- Unit Ratio: AWACS
	ActualRatioAWACS = ((Grand_Units_Table["AirUnits-" .. ActTagTbl].awacs_air_plane.ActCountAll) / (Grand_Units_Table["TotalCountAir-" .. ActTagTbl].CountAllSupport))
	DiffActualRatioAWACS = (ProdWeightAWACS - ActualRatioAWACS)

--[[
Utils.LUA_DEBUGOUT("ProdWeightRec: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightRec))
Utils.LUA_DEBUGOUT("ProdWeightAWACS: " .. tostring(ActTag) .. "---" .. tostring(ProdWeightAWACS))
]]

-- Start shift weights if big differences
	if DiffActualRatioRec >= 0.50 and AWACSChk then
		ProdWeightRec = ProdWeightRec + 0.20
		ProdWeightAWACS = ProdWeightAWACS - 0.20
	elseif DiffActualRatioAWACS >= 0.50 then
		ProdWeightRec = ProdWeightRec - 0.20
		ProdWeightAWACS = ProdWeightAWACS + 0.20
	end
-- End shift weights if big differences
--[[
Utils.LUA_DEBUGOUT("DiffActualRatioRec-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioRec))
Utils.LUA_DEBUGOUT("DiffActualRatioAWACS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(DiffActualRatioAWACS))
]]

	local AirSpecialMoney = Grand_Country_Table["Country-" .. ActTagTbl].ActMoneyProdAirSpecial
	local rounddown = math.floor
-- Money available  for sub sections
	local MoneyRec = rounddown(AirSpecialMoney * ProdWeightRec)
	local MoneyAWACS = rounddown(AirSpecialMoney * ProdWeightAWACS)

--[[
Utils.LUA_DEBUGOUT("MoneyRec-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyRec))
Utils.LUA_DEBUGOUT("MoneyAWACS-FINAL: " .. tostring(ActTag) .. "---" .. tostring(MoneyAWACS))
]]

	if MoneyRec > 0 then

		local AirProduction = {
			Money = MoneyRec,

			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_recon_plane"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

	if MoneyAWACS > 0 then
		
		local AirProduction = {
			Money = MoneyAWACS,
			BuildArea = tostring("_Planes"),
			BuildDiv = tostring("_awacs_air_plane"),
			BuildComp = tostring("_Default"),
			BuildSup = tostring("_SupportUnit"),
			BuildSupPref = tostring("Default")		
		}
		UnitProductionTable["AirProduction-" .. ActTagTbl] = AirProduction
		
		ProdTable = "AirProduction-"
		UnitProduction(ActTagTbl, ProdTable)
	end

end
-- ###################################
-- # End of Air Units Build


-- # Start of Units Production
-- ###################################
function UnitProduction(ActTagTbl, ProdTable)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId
	local bBuildReserve = false  																	-- Tabelle?
	local ispuppet = nil																			-- Use masters build scheme
	-- puppet, lead country tag needed put in ActTagTbl otherwise DEFAULT?
	local UnitType = nil
	local UnitCost = 0
	local UnitMPCost = 0
	local OrderList = SubUnitList()
	local Money = 0
	local BuildArea = nil
	local BuildDiv = nil
	local BuildComp = nil
	local BuildSup = nil
	local BuildSupPref = nil
	local HasFaction = Grand_Country_Table["Country-" .. ActTagTbl].HasFaction						-- Use faction leaders scheme
	local FactionName = tostring(Grand_Country_Table["Country-" .. ActTagTbl].FactionName)

	local FreeMP = Grand_Country_Table["Manpower-" .. ActTagTbl].FreeMP
	if FreeMP < 1 then
	  return
	end
	
	if ProdTable == "LandProduction-" then																--Check wich Land template to use
		Money = UnitProductionTable[ProdTable .. ActTagTbl].Money
		BuildArea = UnitProductionTable[ProdTable .. ActTagTbl].BuildArea
		BuildDiv = UnitProductionTable[ProdTable .. ActTagTbl].BuildDiv
		BuildComp = UnitProductionTable[ProdTable .. ActTagTbl].BuildComp
		BuildSup = UnitProductionTable[ProdTable .. ActTagTbl].BuildSup
		BuildSupPref = UnitProductionTable[ProdTable .. ActTagTbl].BuildSupPref

		if HasFaction == true then																		--Check for faction template to use
			if FactionName == ("allies") then
				BuildComp = tostring("_NATO")
				if BuildsTable["Area" .. BuildArea]["Unit" .. BuildDiv]["Comp" .. BuildComp] == nil then
					BuildComp = tostring("_Default")
				end
--Utils.LUA_DEBUGOUT("--1---Produktion---Faction---: " .. tostring(ActTag) .. "--NATO--" ..  tostring(FactionName))
			elseif FactionName == "comintern" then
				BuildComp = tostring("_WP")
				if BuildsTable["Area" .. BuildArea]["Unit" .. BuildDiv]["Comp" .. BuildComp] == nil then
					BuildComp = tostring("_Default")
				end
--Utils.LUA_DEBUGOUT("--2---Produktion---Faction---: " .. tostring(ActTag) .. "--WP--" ..  tostring(FactionName))
			else
--Utils.LUA_DEBUGOUT("--3---Produktion---Faction---: " .. tostring(ActTag) .. "--???--" ..  tostring(FactionName))
			end
		end
	end
	if ProdTable == "SeaProduction-" then																--Check wich Sea template to use
		Money = UnitProductionTable[ProdTable .. ActTagTbl].Money
		BuildArea = UnitProductionTable[ProdTable .. ActTagTbl].BuildArea
		BuildDiv = UnitProductionTable[ProdTable .. ActTagTbl].BuildDiv
		BuildComp = UnitProductionTable[ProdTable .. ActTagTbl].BuildComp
		BuildSup = UnitProductionTable[ProdTable .. ActTagTbl].BuildSup
		BuildSupPref = UnitProductionTable[ProdTable .. ActTagTbl].BuildSupPref
	end
	if ProdTable == "AirProduction-" then																--Check wich Air template to use
		Money = UnitProductionTable[ProdTable .. ActTagTbl].Money
		BuildArea = UnitProductionTable[ProdTable .. ActTagTbl].BuildArea
		BuildDiv = UnitProductionTable[ProdTable .. ActTagTbl].BuildDiv
		BuildComp = UnitProductionTable[ProdTable .. ActTagTbl].BuildComp
		BuildSup = UnitProductionTable[ProdTable .. ActTagTbl].BuildSup
		BuildSupPref = UnitProductionTable[ProdTable .. ActTagTbl].BuildSupPref
	end
	

	local mainkey = ""
	for Component = 1, #BuildsTable["Area" .. BuildArea]["Unit" .. BuildDiv]["Comp" .. BuildComp] do 	-- Build Division composition
		local ActComp = (BuildsTable["Area" .. BuildArea]["Unit" .. BuildDiv]["Comp" .. BuildComp][Component])
Utils.LUA_DEBUGOUT("ActComp -> INITIAL: " .. tostring(ActTag) .. "--" ..  tostring(ActComp))
	--TestUnit = BuildsTable.Area_Divisions.Unit_Cavalry.Comp_Default
		if (ActComp ~= nil) then
--Utils.LUA_DEBUGOUT("ActComp -> VALID: " .. tostring(ActTag) .. "--" ..  tostring(ActComp))
			-- Support unit?
			if (ActComp == "StdSupportUnit") or (ActComp == "MobSupportUnit") or (ActComp == "SpecSupportUnit") then
--Utils.LUA_DEBUGOUT("ActComp -> Support: " .. tostring(ActTag) .. "--" ..  tostring(ActComp))
				local SupportUnit = BuildsTable["Area" .. BuildArea]["Unit" .. BuildDiv]["Comp" .. BuildSup][BuildSupPref]
				UnitType = CSubUnitDataBase.GetSubUnit(SupportUnit)
				UnitCost = UnitCost + ActCountry:GetBuildCostIC( UnitType, 1, bBuildReserve):Get()
				UnitMPCost = UnitMPCost + UnitType:GetBuildCostMP():Get()
			else
			-- Main unit
				UnitType = CSubUnitDataBase.GetSubUnit(ActComp)
				UnitCost = UnitCost + ActCountry:GetBuildCostIC( UnitType, 1, bBuildReserve):Get()
				UnitMPCost = UnitMPCost + UnitType:GetBuildCostMP():Get()
				mainkey = UnitType:GetKey()
			end
		else
--Utils.LUA_DEBUGOUT("ActComp -> NIL: " .. tostring(ActTag) .. "-" ..  tostring(ActComp))
		end
		SubUnitList.Append( OrderList, UnitType )
	end

	local buildcount = 1
	while (Money > (UnitCost * 0.5)) and (FreeMP > UnitMPCost) do
		ActAI:Post(CConstructUnitCommand(ActTag, OrderList, CapitalProvId, buildcount, bBuildReserve, CNullTag(), CID()))
		Money = Money - UnitCost
		FreeMP = FreeMP - UnitMPCost
--Utils.LUA_DEBUGOUT("Land/air production: " .. tostring(ActTag) .. "UnitCost: " ..  tostring(UnitCost) .. " Buildcount: " .. tostring(buildcount) .. " Unit: " .. tostring(mainkey))
--Utils.LUA_DEBUGOUT("--Money for Country: " .. tostring(ActTag) .. " : " ..  tostring(Money))

	end
	-- refresh MP for Global Table
	Grand_Country_Table["Manpower-" .. ActTagTbl].FreeMP = FreeMP
	
	
end

function ShipProduction(ActTagTbl, ProdTable)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local CapitalProvId = Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId
	local bBuildReserve = false  																	-- Tabelle?
	local TechStatus = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus
	local ispuppet = nil																			-- Use masters build scheme
	local has faction = nil																			-- Use faction leaders scheme
	-- puppet/faction lead country tag needed put in ActTagTbl otherwise DEFAULT?
	
	local UnitType = nil
	local UnitCost = 0
	local UnitMPCost = 0
	local MaxUnitCost = 0
	local OrderList = SubUnitList()
	local Money = UnitProductionTable[ProdTable .. ActTagTbl].Money
	local BuildArea = UnitProductionTable[ProdTable .. ActTagTbl].BuildArea
	local BuildDiv = UnitProductionTable[ProdTable .. ActTagTbl].BuildDiv
	local BuildComp = UnitProductionTable[ProdTable .. ActTagTbl].BuildComp
	local BuildSup = nil --UnitProductionTable[ProdTable .. ActTagTbl].BuildSup
	local BuildSupPref = nil --UnitProductionTable[ProdTable .. ActTagTbl].BuildSupPref
	local buildcount = 1

	local FreeMP = Grand_Country_Table["Manpower-" .. ActTagTbl].FreeMP
	if FreeMP < 1 then
	  return
	end
	
	for Component = 1, #BuildsTable["Area" .. BuildArea]["Unit" .. BuildDiv]["Comp" .. BuildComp] do
		local ActComp = (BuildsTable["Area" .. BuildArea]["Unit" .. BuildDiv]["Comp" .. BuildComp][Component])
--Utils.LUA_DEBUGOUT("ActComp -> INITIAL: " .. tostring(ActTag) .. "--" ..  tostring(ActComp))

		if (ActComp ~= nil) then
--Utils.LUA_DEBUGOUT("ActComp -> VALID: " .. tostring(ActTag) .. "--" ..  tostring(ActComp))
			while Money > (MaxUnitCost * 0.5) and (FreeMP > 0) do
			--for l = 1, buildcount do
				UnitType = CSubUnitDataBase.GetSubUnit(ActComp)
				UnitCost = UnitCost + ActCountry:GetBuildCostIC( UnitType, 1, bBuildReserve):Get()
				UnitMPCost = UnitMPCost + UnitType:GetBuildCostMP():Get()
--Utils.LUA_DEBUGOUT("ActComp -> UnitCost: " .. tostring(ActTag) .. "--" ..  tostring(UnitCost))
				local numshipslots = CModelDataBase.GetNumOfSlots(UnitType, ActTag )
--Utils.LUA_DEBUGOUT("Act #Shipslots: " .. tostring(ActTag) .. "--" ..  tostring(numshipslots))
				for i = 1, numshipslots, 1 do
--Utils.LUA_DEBUGOUT("In loop! " .. tostring(ActTag) .. "--" ..  tostring(i))
					local slot = CModelDataBase.GetSlot(UnitType, ActTag, i-1 )-- Must start loop with "1", but first component is "0"! So "i-1"!
					if slot ~= nil then
						local slotunit = slot:GetSubUnit()
						local slotkey = slot:GetSubUnit():GetKey()
--Utils.LUA_DEBUGOUT("Act slotkey of ship: " .. tostring(ActTag) .. "--" ..  tostring(slotkey))
--Utils.LUA_DEBUGOUT("Act slotunit of ship: " .. tostring(ActTag) .. "--" ..  tostring(slotunit))
						local level = slot:GetLevel()
--Utils.LUA_DEBUGOUT("ActSlotType of Ship: " .. tostring(ActTag) .. "--" ..  tostring(level))
					
						UnitCost = UnitCost + ActCountry:GetBuildCostIC( slotunit, 1, bBuildReserve):Get()
						--Below does not work anymore, needs check..
						if (slotunit:IsCag()) then
							SubUnitList.Append( OrderList, slotunit )
							ActAI:Post(CConstructUnitCommand(ActTag, OrderList, CapitalProvId, buildcount, bBuildReserve, CNullTag(), CID()))
--Utils.LUA_DEBUGOUT("CAG production " .. tostring(ActTag) .. " " ..  tostring(buildcount) .. " " .. tostring(slotkey) )
						end
					end
				end
				if MaxUnitCost == 0 then MaxUnitCost = UnitCost end
				if (Money > (UnitCost * 0.5)) and (FreeMP > UnitMPCost) then
					ActAI:Post(CConstructShipCommand(ActTag, UnitType, CapitalProvId, buildcount,  CID()))
					Money = Money - UnitCost
					FreeMP = FreeMP - UnitMPCost
				end
--Utils.LUA_DEBUGOUT("Ship production " .. tostring(ActTag) .. "MaxUnitCost: " ..  tostring(MaxUnitCost) .. " Buildcount: " .. tostring(buildcount) .. " Unit: " .. tostring(UnitType:GetKey()) )
--Utils.LUA_DEBUGOUT("--Money: " .. tostring(ActTag) .. "-" ..  tostring(Money))
			end		
		else	
--Utils.LUA_DEBUGOUT("ActComp -> NIL: " .. tostring(ActTag) .. "-" ..  tostring(ActComp))
		end
	end
	-- refresh MP for Global Table
	Grand_Country_Table["Manpower-" .. ActTagTbl].FreeMP = FreeMP

end

-- ###################################
-- # End of Units Production


-- ########################################################################
-- ###				-<= End of new code =>-								###
-- ########################################################################


-- #######################
-- Building Construction
-- #######################
function BuildOtherUnits(ic)
	-- Buildings
	if ic > 0.1 then
		local liTotalBuildings = 11
	
		--Setup the building object
		local loBuildings = {
			coastal_fort = CBuildingDataBase.GetBuilding("coastal_fort" ),
			land_fort = CBuildingDataBase.GetBuilding( "land_fort" ),
			anti_air = CBuildingDataBase.GetBuilding("anti_air" ),
			industry = CBuildingDataBase.GetBuilding("industry" ),
			radar_station = CBuildingDataBase.GetBuilding("radar_station" ),
			nuclear_reactor = CBuildingDataBase.GetBuilding("nuclear_reactor" ),
			rocket_test = CBuildingDataBase.GetBuilding("rocket_test" ),
			infra = CBuildingDataBase.GetBuilding("infra"),
			air_base = CBuildingDataBase.GetBuilding("air_base"),
			naval_base = CBuildingDataBase.GetBuilding("naval_base"),
			underground = CBuildingDataBase.GetBuilding("underground"),
		}
		
		-- Setup which buildings can be built
		loBuildings.lbCoastal_fort = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.coastal_fort)
		loBuildings.lbLand_fort = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.land_fort)
		loBuildings.lbAnti_air = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.anti_air)
		loBuildings.lbIndustry = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.industry)
		loBuildings.lbRadar_station = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.radar_station)
		loBuildings.lbNuclear_reactor = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.nuclear_reactor)
		loBuildings.lbRocket_test = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.rocket_test)
		loBuildings.lbInfra = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.infra)
		loBuildings.lbAir_base = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.air_base)
		loBuildings.lbNaval_base = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.naval_base)
		loBuildings.lbUnderground = ProductionData.TechStatus:IsBuildingAvailable(loBuildings.underground)
		
		
		local liRandomBuildArray = {}
		
		for i = 1, liTotalBuildings do
			liRandomBuildArray[i] = i
		end
		
		-- Produce buildings until your out of IC that has been allocated
		--   Never have more than 1 rocket sites
		local liRocketCap = 1
		local liReactorCap = 2
		local loCorePrv = CoreProvincesLoop(loBuildings, liRocketCap, liReactorCap)
		local lbProcess = true -- Flag used to indicate to process regular code as well

		for i = 1, liTotalBuildings do
			local liBuilding = math.random(table.getn(liRandomBuildArray))

			if liRandomBuildArray[liBuilding] == 1 then
				-- Underground base
				if ic > 0.1 and loBuildings.lbUnderground then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_Underground")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
				
					if lbProcess then
						if ic > 0.1 then
							local liProvinceID = ProductionData.ministerCountry:GetRandomUnderGroundTarget()
							if liProvinceID > 0 then
								local loCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.underground, liProvinceID, 1)

								if loCommand:IsValid() then
									ProductionData.ministerAI:Post(loCommand)
									
									local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.underground):Get()
									ic = ic - liCost -- Update IC total	
									break
								end
							end
						end				
					else
						lbProcess = true -- Reset Flag for next check
					end
				end
			elseif liRandomBuildArray[liBuilding] == 2 then
				-- Nuclear Reactors stations
				if ic > 0.1 and loBuildings.lbNuclear_reactor then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_NuclearReactor")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
					
					if lbProcess then
						if loCorePrv.ReactorSites < liReactorCap then
							if ic > 0.1 then
								if table.getn(loCorePrv.PrvForBuilding) > 0 then
									local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.nuclear_reactor, loCorePrv.PrvForBuilding[math.random(table.getn(loCorePrv.PrvForBuilding))], 1 )

									if constructCommand:IsValid() then
										ProductionData.ministerAI:Post( constructCommand )
										
										local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.nuclear_reactor):Get()
										ic = ic - liCost -- Upodate IC total	
									end
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end
				end
			elseif liRandomBuildArray[liBuilding] == 3 then
				-- Rocket Test Site stations
				if ic > 0.1 and loBuildings.lbRocket_test then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_RocketTest")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
					
					if lbProcess then
						if not(ProductionData.BuiltRocketSite) then
							if loCorePrv.RocketSites < liRocketCap then
								-- Limits minors to only consider building Rocket Test sites after 1943
								if ProductionData.IsMajor or ProductionData.Year > 1943 then
									if ic > 0.1 then
										if table.getn(loCorePrv.PrvForBuilding) > 0 then
											local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.rocket_test, loCorePrv.PrvForBuilding[math.random(table.getn(loCorePrv.PrvForBuilding))], 1 )

											if constructCommand:IsValid() then
												ProductionData.ministerAI:Post( constructCommand )
												
												local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.rocket_test):Get()
												ic = ic - liCost -- Update IC total	
												ProductionData.BuiltRocketSite = true
											end
										end
									end
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end
				end
			elseif liRandomBuildArray[liBuilding] == 4 then
				-- Industry
				if ic > 0.1 and loBuildings.lbIndustry then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_Industry")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
					
					if lbProcess then
						if ic > 0.1 then
							if table.getn(loCorePrv.PrvForBuildingIndustry) > 0 then
								local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.industry, loCorePrv.PrvForBuildingIndustry[math.random(table.getn(loCorePrv.PrvForBuildingIndustry))], 1 )

								if constructCommand:IsValid() then
									ProductionData.ministerAI:Post( constructCommand )
									
									local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.industry):Get()
									ic = ic - liCost -- Upodate IC total	
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end
				end						
			elseif liRandomBuildArray[liBuilding] == 5 then
				-- Build Forts
				--   Since there is no practical way to teach the AI to build forts just allow hooks for country specific stuff
				if ic > 0.1 and loBuildings.lbLand_fort then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_Fort")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
				
					-- Don't build a fort on the capital unless there is nothing else to do
					if lbProcess then
						if ic > 0.1 then
							-- Get Costal Fort information
							local loProvince = ProductionData.ministerCountry:GetActingCapitalLocation()
							local loLandFort = loProvince:GetBuilding(loBuildings.land_fort)

							-- Make sure the Capital does not already have a size 2 fort
							if loLandFort:GetMax():Get() < 2 and loProvince:GetCurrentConstructionLevel(loBuildings.land_fort) == 0 then
								if ProductionData.ministerCountry:IsBuildingAllowed(loBuildings.land_fort, loProvince) then
									local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.land_fort, loProvince:GetProvinceID(), 1 )

									if constructCommand:IsValid() then
										ProductionData.ministerAI:Post( constructCommand )
										
										local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.land_fort):Get()
										ic = ic - liCost -- Upodate IC total
										break 
									end
								end
							end
						end
					else
						lbProcess = true
					end
				end
			elseif liRandomBuildArray[liBuilding] == 6 then
				-- Build Coastal Forts
				if ic > 0.1 and loBuildings.lbCoastal_fort then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_CoastalFort")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
				
					if lbProcess then
						if ic > 0.1 then
							if table.getn(loCorePrv.PrvCoastalFort) > 0 then
								local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.coastal_fort, loCorePrv.PrvCoastalFort[math.random(table.getn(loCorePrv.PrvCoastalFort))], 1 )

								if constructCommand:IsValid() then
									ProductionData.ministerAI:Post( constructCommand )
									
									local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.coastal_fort):Get()
									ic = ic - liCost -- Upodate IC total	
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end				
				end
			elseif liRandomBuildArray[liBuilding] == 7 then
				-- Build Anti Air
				if ic > 0.1 and loBuildings.lbAnti_air then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_AntiAir")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
				
					if lbProcess then
						if ic > 0.1 then
							if table.getn(loCorePrv.PrvAntiAir) > 0 then
								local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.anti_air, loCorePrv.PrvAntiAir[math.random(table.getn(loCorePrv.PrvAntiAir))], 1 )

								if constructCommand:IsValid() then
									ProductionData.ministerAI:Post( constructCommand )
									
									local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.anti_air):Get()
									ic = ic - liCost -- Upodate IC total	
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end				
				end
			elseif liRandomBuildArray[liBuilding] == 8 then
				-- Radar stations
				if ic > 0.1 and loBuildings.lbRadar_station then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_Radar")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
				
					if lbProcess then
						if ic > 0.1 then
							if table.getn(loCorePrv.PrvRadarStation) > 0 then
								local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.radar_station, loCorePrv.PrvRadarStation[math.random(table.getn(loCorePrv.PrvRadarStation))], 1 )

								if constructCommand:IsValid() then
									ProductionData.ministerAI:Post( constructCommand )
									
									local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.radar_station):Get()
									ic = ic - liCost -- Upodate IC total	
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end	
				end
			elseif liRandomBuildArray[liBuilding] == 9 then
				-- Build Airfields
				if ic > 0.1 and loBuildings.lbAir_base then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_AirBase")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
				
					if lbProcess then
						if ic > 0.1 then
							if table.getn(loCorePrv.PrvAirBase) > 0 then
								local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.air_base, loCorePrv.PrvAirBase[math.random(table.getn(loCorePrv.PrvAirBase))], 1 )

								if constructCommand:IsValid() then
									ProductionData.ministerAI:Post( constructCommand )
									
									local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.air_base):Get()
									ic = ic - liCost -- Upodate IC total	
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end					
				end
			elseif liRandomBuildArray[liBuilding] == 10 then
				-- Infrastructure
				if ic > 0.1 and loBuildings.lbInfra then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_Infrastructure")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end
				
					if lbProcess then
						if ic > 0.1 then
							local liRandomIndex
							local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.infra):Get()
							
							-- Limit it to three provinces at a time
							for i = 1, 3 do
								if table.getn(loCorePrv.PrvLowInfra69) > 0 then
									liRandomIndex = math.random(table.getn(loCorePrv.PrvLowInfra69))
									local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.infra, loCorePrv.PrvLowInfra69[liRandomIndex], 1 )

									if constructCommand:IsValid() then
										if ic > 0.1 then
											ProductionData.ministerAI:Post( constructCommand )
											ic = ic - liCost -- Upodate IC total	
											table.remove(loCorePrv.PrvLowInfra69, liRandomIndex)
										else
											break
										end
									end
								elseif table.getn(loCorePrv.PrvLowInfra99) > 0 then
									liRandomIndex = math.random(table.getn(loCorePrv.PrvLowInfra99))
									local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.infra, loCorePrv.PrvLowInfra99[liRandomIndex], 1 )

									if constructCommand:IsValid() then
										if ic > 0.1 then
											ProductionData.ministerAI:Post( constructCommand )
											ic = ic - liCost -- Upodate IC total	
											table.remove(loCorePrv.PrvLowInfra99, liRandomIndex)
										else
											break
										end
									end
								end
								
								-- If there is no IC left do not loop another time
								if ic <= 0.2 then
									break
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end
				end	
			elseif liRandomBuildArray[liBuilding] == 11 then
				-- Expand a port since there is nothing else left to do
				if ic > 0.1 and loBuildings.lbNaval_base then
					local loFunRef = Utils.GetFunctionReference(ProductionData.ministerTag, ProductionData.IsNaval, "Build_NavalBase")
					if loFunRef then
						ic, lbProcess = loFunRef(ic, ProductionData)
					end

					if lbProcess then
						if ic > 0.1 then
							if table.getn(loCorePrv.PrvNavalBase) > 0 then
								local constructCommand = CConstructBuildingCommand(ProductionData.ministerTag, loBuildings.naval_base, loCorePrv.PrvNavalBase[math.random(table.getn(loCorePrv.PrvNavalBase))], 1 )

								if constructCommand:IsValid() then
									ProductionData.ministerAI:Post( constructCommand )
									
									local liCost = ProductionData.ministerCountry:GetBuildCost(loBuildings.naval_base):Get()
									ic = ic - liCost -- Upodate IC total	
								end
							end
						end
					else
						lbProcess = true -- Reset Flag for next check
					end						
				end
			end
			
			table.remove(liRandomBuildArray, i)
		end
	end
	
	return ic
end

function CoreProvincesLoop(voBuildings, viRocketCap, viReactorCap)
	local lbBuildIndustry = false  -- Should the AI consider building Industry
	local laAtWarWith = {} -- Holds an array of country tags they are atwar with and are holding a core province
	
	local loCorePrv = {
		RocketSites = ProductionData.ministerCountry:GetTotalCoreBuildingLevels(voBuildings.rocket_test:GetIndex()):Get(),
		ReactorSites = ProductionData.ministerCountry:GetTotalCoreBuildingLevels(voBuildings.nuclear_reactor:GetIndex()):Get(),
		PrvLowInfra69 = {}, -- Provinces less than 70 infrastructure
		PrvLowInfra99 = {}, -- Provinces less than 100 infrastructure
		PrvForBuilding = {}, -- Provinces that qualify for any building
		PrvForBuildingIndustry = {}, -- Provinces that qualify for Industry to be built in them
		PrvAntiAir = {}, -- Provinces that qualify for Anti Air
		PrvCoastalFort = {}, -- Provinces that qualify for Coastal Fort
		PrvRadarStation = {}, -- Provinces that qualify for Radar Station
		PrvAirBase = {}, -- Provinces that qualify for an Air Base
		PrvNavalBase = {} -- Provinces that qualify for a Naval Base
	}	
	
	-- Performance check, no need to count resources if you can't build a factory
	if voBuildings.lbIndustry then
		local liExpenseFactor, liHomeFactor = Support.CalculateExpenseResourceFactor(ProductionData.ministerCountry)
		
		-- We produce more than what we use so build more industry
		if liHomeFactor > liExpenseFactor then
			lbBuildIndustry = true
		end
	end
	
	for liProvinceId in ProductionData.ministerCountry:GetControlledProvinces() do
		local loProvince = CCurrentGameState.GetProvince(liProvinceId)
		local loProvinceInfra = loProvince:GetBuilding(voBuildings.infra)
		local liInfraSize = loProvinceInfra:GetMax():Get()
		
		if liInfraSize > 1 then
			local isFrontProvince = loProvince:IsFrontProvince(false)
			local liConstructionLevel = loProvince:GetCurrentConstructionLevel(voBuildings.infra)
			local loOwnerTag = loProvince:GetOwner()
			
			-- Any province can have their infra improved not just owned ones
			if voBuildings.lbInfra then
				if liInfraSize < 7 and not(liConstructionLevel > 0) and not(isFrontProvince) then
					table.insert(loCorePrv.PrvLowInfra69, liProvinceId)
				elseif liInfraSize < 10 and not(liConstructionLevel > 0) and not(isFrontProvince) then
					table.insert(loCorePrv.PrvLowInfra99, liProvinceId)
				end
			end
			
			if not(isFrontProvince) then
				local lbHasNavalBase = loProvince:HasBuilding(voBuildings.naval_base)
				local lbHasIndustry = loProvince:HasBuilding(voBuildings.industry)
				local lbHasAirField = loProvince:HasBuilding(voBuildings.air_base)
				local lbHasNavalBase = loProvince:HasBuilding(voBuildings.naval_base)

				-- Plan Anti Aircraft layout
				if lbHasNavalBase or lbHasIndustry or lbHasAirField then
					-- Provinces that qualify for Anti-Air
					if voBuildings.lbAnti_air then
						if loProvince:GetBuilding(voBuildings.anti_air):GetMax():Get() < 5 then
							if loProvince:GetCurrentConstructionLevel(voBuildings.anti_air) == 0 then
								table.insert(loCorePrv.PrvAntiAir, liProvinceId)
							end
						end
					end
					
					if lbHasNavalBase then
						-- Provinces that qualify for Coastal Base
						if voBuildings.lbCoastal_fort then
							if loProvince:GetBuilding(voBuildings.coastal_fort):GetMax():Get() < 2 then
								if loProvince:GetCurrentConstructionLevel(voBuildings.coastal_fort) == 0 then
									table.insert(loCorePrv.PrvCoastalFort, liProvinceId)
								end
							end
						end
						
						-- Provinces that qualify for a Naval Base
						if voBuildings.lbNaval_base then
							if loProvince:GetBuilding(voBuildings.naval_base):GetMax():Get() < 10 then
								if loProvince:GetCurrentConstructionLevel(voBuildings.naval_base) == 0 then
									table.insert(loCorePrv.PrvNavalBase, liProvinceId)
								end
							end
						end
					end
					
					if lbHasAirField then
						-- Provinces that qualify for an Air Base
						if voBuildings.lbAir_base then
							if loProvince:GetBuilding(voBuildings.air_base):GetMax():Get() < 10 then
								if loProvince:GetCurrentConstructionLevel(voBuildings.air_base) == 0 then
									table.insert(loCorePrv.PrvAirBase, liProvinceId)
								end
							end
						end
						
						--Provinces that qualify for Radar Station
						if voBuildings.lbRadar_station then
							if loProvince:GetBuilding(voBuildings.radar_station):GetMax():Get() < 5 then
								if loProvince:GetCurrentConstructionLevel(voBuildings.radar_station) == 0 then
									table.insert(loCorePrv.PrvRadarStation, liProvinceId)
								end
							end
						end
					end
				end
				
				-- First make sure the province has Industry (performance reasons done first)
				if lbHasIndustry and ProductionData.ministerTag == loOwnerTag then
					-- Provinces that qualify for Nuclear Reactor and Rocket test sites
					if voBuildings.lbNuclear_reactor or voBuildings.lbRocket_test then
						if (voBuildings.lbRocket_test and loCorePrv.RocketSites < viRocketCap)
						or (voBuildings.lbNuclear_reactor and loCorePrv.ReactorSites < viReactorCap) then
							if not(loProvince:GetCurrentConstructionLevel(voBuildings.rocket_test) > 0) and not(loProvince:GetCurrentConstructionLevel(voBuildings.nuclear_reactor) > 0) then
								table.insert(loCorePrv.PrvForBuilding, liProvinceId)
							end
						end
					end
					
					-- If the Build Industry flag is set figure out provinces that qualify for Industry
					if lbBuildIndustry and voBuildings.lbIndustry then
						if loProvince:GetBuilding(voBuildings.industry):GetMax():Get() < 9
						and not(loProvince:GetCurrentConstructionLevel(voBuildings.industry) > 0) then
							table.insert(loCorePrv.PrvForBuildingIndustry, liProvinceId)
						end
					end
				end
			end
		end
	end
	
	return loCorePrv
end
-- #######################
-- End Building Construction
-- #######################



-- ###################################
-- # Main Method called by the EXE
-- #####################################


-- Biga: updated to new distributions/algorithm
function BalanceProductionSliders(ai, ministerCountry, prioSelection, vParams, bHasReinforceBonus, aifocus)

	local liOrigPrio = prioSelection
	
	local vInvestment = vParams.vInvestment
	local vProduction = vParams.vProduction
	local vReinforce = vParams.vReinforcement
	local vResearch = vParams.vResearch
	local vUpgrade = vParams.vUpgrade
	local vUpkeep = vParams.vUpkeep
	local vInfra = vParams.vInfra
	local vMoney = vParams.vMoneyPool

	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local ActTagTbl = tostring(ai:GetCountry():GetCountryTag())
	-- New Pre-Production Check
	local Ignition = Grand_Country_Table["Ignition-" .. ActTagTbl]
	if (Ignition == nil) or ((Ignition + 1 ) >= (AllDays)) then
--if (ActTagTbl == "USA") or (ActTagTbl == "ENG") then --or (ActTagTbl == "SOV") or (ActTagTbl == "FRA") then
--Utils.LUA_DEBUGOUT("-BalanceProductionSliders-IGNITION-: " .. tostring(ActTagTbl) .. " - " ..  tostring(Ignition) .. " - " ..  tostring(AllDays) .. " -MONEY-: " ..  tostring(vMoney))
--end
		return
	else
--Utils.LUA_DEBUGOUT("-BalanceProductionSliders-MONEY-: " .. tostring(ActTagTbl) .. " - " ..  tostring(Ignition) .. " - " ..  tostring(AllDays) .. " -MONEY-: " ..  tostring(vMoney))
	end
	--Utils.LUA_DEBUGOUT("balance " .. tostring(ministerCountry:GetCountryTag()))

	--Utils.LUA_DEBUGOUT("old balance " .. tostring(prioSelection) .. ": " .. tostring(vInvestment) .. "\t" .. tostring(vProduction) .. "\t" .. tostring(vReinforce) .. "\t" .. tostring(vResearch) .. "\t" .. tostring(vUpgrade) .. "\t" .. tostring(vUpkeep) .. "\t" .. tostring(vInfra))
	
	local vInvestmentOriginal = vInvestment
	local vProductionOriginal = vProduction
	local vReinforceOriginal = vReinforce
	local vUpgradeOriginal = vUpgrade
	local vInfraOriginal = vInfra
	local vResearchOriginal = vResearch
	local vUpkeepOriginal = vUpkeep
	
	-- New override value for the prodcution need based on theatres need etc..
--if (ActTagTbl == "USA") or (ActTagTbl == "ENG") then --or (ActTagTbl == "SOV") or (ActTagTbl == "FRA") then
--Utils.LUA_DEBUGOUT("-BalanceProductionSliders-VProduction-1-: " .. tostring(ActTagTbl) .. " -AllDays- " ..  tostring(AllDays) .. " -MONEY BEFORE NEED-: " ..  tostring(vProduction))
--end

	vProduction = ProductionNeed(ActTagTbl, vProduction)

--if (ActTagTbl == "USA") or (ActTagTbl == "ENG") then -- or (ActTagTbl == "SOV") or (ActTagTbl == "FRA") then
--Utils.LUA_DEBUGOUT("-BalanceProductionSliders-VProduction-2-: " .. tostring(ActTagTbl) .. " -AllDays- " ..  tostring(AllDays) .. " -MONEY AFTER NEED-: " ..  tostring(vProduction))
--end

	local vInvestment, vProduction, vInfra, vReinforce, vUpgrade, vResearch, vUpkeep, money_left = CAI.FastNormalizeByPriority( prioSelection, vParams, ministerCountry )

--if (ActTagTbl == "USA") or (ActTagTbl == "ENG") then --or (ActTagTbl == "SOV") or (ActTagTbl == "FRA") then
--Utils.LUA_DEBUGOUT("-BalanceProductionSliders-VProduction-3-: " .. tostring(ActTagTbl) .. " -AllDays- " ..  tostring(AllDays) .. " -MONEY AFTER Normalisation-: " ..  tostring(vProduction))
--end
	--Utils.LUA_DEBUGOUT("new balance " .. tostring(prioSelection) .. ": " .. tostring(vInvestment) .. "\t" .. tostring(vProduction) .. "\t" .. tostring(vReinforce) .. "\t" .. tostring(vResearch) .. "\t" .. tostring(vUpgrade) .. "\t" .. tostring(vUpkeep) .. "\t" .. tostring(vInfra))
	
   	-- infra, check aifocus
	if prioSelection == 3 then
	  local infrasetting = ministerCountry:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_INVESTMENT_)
	  local aifocus = infrasetting:GetAIFocus()
	
		if prioSelection == 3 and aifocus > 0 and money_left > 0 then
		  vInfra = vInfra + (money_left / vParams.vMoneyPool)
		end
	end

	local command = CChangeInvestmentCommand( ministerCountry:GetCountryTag(), vInvestment, vProduction, vInfra, vReinforce, vUpgrade, vResearch, vUpkeep )
	ai:Post( command )
	--Utils.LUA_DEBUGOUT("balance command sent")
end

function BalanceStockSliders(ai, ministerCountry, vBaseSupplyPrice, vBaseFuelPrice, vCurrentSupplyPrice, vCurrentFuelPrice)
	
	local vMinSupply = ministerCountry:GetMinStockpile( CGoodsPool._SUPPLIES_ ):Get()
	local vMinFuel = ministerCountry:GetMinStockpile( CGoodsPool._FUEL_ ):Get()
	
	local vWantedSupply = vMinSupply * 1.5 * vBaseSupplyPrice / vCurrentSupplyPrice
	local vWantedFuel = vMinFuel * 1.5 * vBaseFuelPrice / vCurrentFuelPrice
	
	local command = CChangeStockCommand( ministerCountry:GetCountryTag(), vWantedSupply, vWantedFuel )
	ai:Post( command )
end
