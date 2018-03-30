-- ###############################################
-- ## "Atlas" -East vs. West- Lua AI Setup File
-- ## Created By: Chromos	Date: 12.04.2013
-- ## Modified By: Chromos	Date: 03.03.2014
-- ###############################################
--[[
]]

-- Country Basic Master Table Start
Grand_Country_Table = { }
Grand_Diplomacy_Table = { }
Grand_Nation_Table = { }
Grand_Laws_Table = { }
Grand_Policies_Table = { }
Grand_Units_Table = { }
UnitProductionTable = { }

BuildsTable = {
	Area_Divisions = {															-- Different Division build setups
		Unit_hq_brigade = {														-- Division Type
			Comp_Default = { 													-- "Country" (DEFAULT, NATO, WP, country tag..)
				"hq_brigade",
				"StdSupportUnit",
				nil,
				nil,
				nil
			},
			Comp_SupportUnit = {
				Default = "artillery_brigade"
			}
		},
		Unit_militia_brigade = {												-- Division Type
			Comp_Default = { 													-- "Country" (DEFAULT, NATO, WP, country tag..)
				"militia_brigade",
				"militia_brigade",
				"militia_brigade",
				nil,
				nil
			},
			Comp_StdSupportUnit = {
				Default = "artillery_brigade",
			}
		},
		Unit_infantry_brigade = {												-- Division Type
			Comp_Default = { 													-- "Country" (DEFAULT, NATO, WP, country tag..)
				"infantry_brigade",
				"infantry_brigade",
				"infantry_brigade",
				"StdSupportUnit",
				nil
			},
			Comp_NATO = { 														-- NATO
				"infantry_brigade",
				"infantry_brigade",
				"infantry_brigade",
				"infantry_brigade",
				"StdSupportUnit"
			},
			Comp_WP = { 														-- WP
				"infantry_brigade",
				"infantry_brigade",
				"infantry_brigade",
				"infantry_brigade",
				"StdSupportUnit"
			},
			Comp_StdSupportUnit = {
				Default = "artillery_brigade",
			}
		},
		Unit_motorized_brigade = {												-- Division Type
			Comp_Default = { 													-- "Country" (DEFAULT, NATO, WP, country tag..)
				"motorized_brigade",
				"motorized_brigade",
				"motorized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_NATO = { 														-- NATO
				"motorized_brigade",
				"motorized_brigade",
				"heavy_mechanized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_WP = { 														-- WP
				"motorized_brigade",
				"light_mechanized_brigade",
				"heavy_mechanized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_MobSupportUnit = {
				Default = "sp_artillery_brigade",
			}
		},
		Unit_cavalry_brigade = {												-- Division Type
			Comp_Default = { 													-- "Country" (DEFAULT, NATO, WP, country tag..)
				"cavalry_brigade",
				"cavalry_brigade",
				"cavalry_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_NATO = { 													-- NATO
				"cavalry_brigade",
				"cavalry_brigade",
				"cavalry_brigade",
				"cavalry_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_WP = { 													-- WP
				"cavalry_brigade",
				"cavalry_brigade",
				"cavalry_brigade",
				"cavalry_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_MobSupportUnit = {
				Default = "sp_artillery_brigade"
			}
		},
		Unit_air_cav_brigade = {												-- Division Type
			Comp_Default = { 													-- "Country" (DEFAULT, NATO, WP, country tag..)
				"air_cav_brigade",
				"air_cav_brigade",
				"air_cav_brigade",
				"air_cav_brigade",
				nil
			},
			Comp_MobSupportUnit = {
				Default = "sp_artillery_brigade"
			}
		},
		Unit_light_mechanized_brigade = {											-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"light_mechanized_brigade",
				"light_mechanized_brigade",
				"light_mechanized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_NATO = { 														-- NATO
				"light_mechanized_brigade",
				"light_mechanized_brigade",
				"heavy_mechanized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_WP = { 														-- WP
				"light_mechanized_brigade",
				"light_mechanized_brigade",
				"heavy_mechanized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_MobSupportUnit = {
				Default = "sp_artillery_brigade"
			}
		},
		Unit_heavy_mechanized_brigade = {											-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"heavy_mechanized_brigade",
				"heavy_mechanized_brigade",
				"light_mechanized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_NATO = { 														-- NATO
				"heavy_mechanized_brigade",
				"heavy_mechanized_brigade",
				"light_mechanized_brigade",
				"armor_brigade",
				"MobSupportUnit"
			},
			Comp_WP = { 														-- WP
				"heavy_mechanized_brigade",
				"heavy_mechanized_brigade",
				"light_mechanized_brigade",
				"armor_brigade",
				"MobSupportUnit"
			},
			Comp_MobSupportUnit = {
				Default = "sp_artillery_brigade"
			}
		},
		Unit_armor_brigade = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"armor_brigade",
				"armor_brigade",
				"heavy_mechanized_brigade",
				"MobSupportUnit",
				nil
			},
			Comp_NATO = { 														-- NATO
				"armor_brigade",
				"armor_brigade",
				"heavy_mechanized_brigade",
				"light_mechanized_brigade",
				"MobSupportUnit"
			},
			Comp_WP = { 														-- WP
				"armor_brigade",
				"armor_brigade",
				"armor_brigade",
				"heavy_mechanized_brigade",
				"MobSupportUnit"
			},
			Comp_MobSupportUnit = {
				Default = "sp_artillery_brigade"
			}
		},
		Unit_bergsjaeger_brigade = {												-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"bergsjaeger_brigade",
				"bergsjaeger_brigade",
				"bergsjaeger_brigade",
				"bergsjaeger_brigade",
				nil
			},
			Comp_SupportUnit = {
				Default = "sp_artillery_brigade"
			}
		},
		Unit_marine_brigade = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"marine_brigade",
				"marine_brigade",
				"marine_brigade",
				"marine_brigade",
				nil
			},
			Comp_SupportUnit = {
				Default = "sp_artillery_brigade"
			}
		},
		Unit_partisan_brigade = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"partisan_brigade",
				"partisan_brigade",
				nil,
				nil,
				nil
			},
			Comp_SupportUnit = {
				Default = "sp_artillery_brigade"
			}
		}
--Div end
	},
--Div end
	Area_Ships = {																	-- Different Division build setups
		Unit_submarine = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"submarine"
			}
		},
		Unit_attack_submarine = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"attack_submarine"
			}
		},
		Unit_nuclear_submarine = {											-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"nuclear_submarine"
			}
		},
		Unit_ballistic_missile_submarine = {										-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"ballistic_missile_submarine"
			}
		},
		Unit_guided_submarine = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"guided_submarine"
			}
		},
		Unit_nuclear_guided_submarine = {											-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"nuclear_guided_submarine"
			}
		},
		Unit_missile_boat = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"missile_boat"
			}
		},
		Unit_destroyer = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"destroyer"
			}
		},
		Unit_missile_destroyer = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"missile_destroyer"
			}
		},
		Unit_missile_frigate = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"missile_frigate"
			}
		},
		Unit_cruiser = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"cruiser"
			}
		},
		Unit_missile_cruiser = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"missile_cruiser"
			}
		},
		Unit_nuclear_battlecruiser = {												-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"nuclear_battlecruiser"
			}
		},
		Unit_battleship = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"battleship"
			}
		},
		Unit_escort_carrier = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"escort_carrier"
			}
		},
		Unit_carrier = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"carrier"
			}
		},
		Unit_helicopter_carrier = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"helicopter_carrier"
			}
		},
		Unit_supercarrier = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"supercarrier"
			}
		},
		Unit_transport = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"transport"
			}
		}
--ships end
	},
--ships end
	Area_Planes = {																	-- Different Division build setups
		Unit_fighter = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"fighter"
			}
		},
		Unit_multi_role = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"multi_role"
			}
		},
		Unit_cas = {																-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"cas"
			}
		},
		Unit_helo_cas = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"helo_cas"
			}
		},
		Unit_helo_gunship = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"helo_gunship"
			}
		},
		Unit_helo_maritime = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"helo_maritime"
			}
		},
		Unit_bomber_maritime = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"bomber_maritime"
			}
		},
		Unit_bomber_antisub = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"bomber_antisub"
			}
		},
		Unit_cag_attack = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"cag_attack"
			}
		},
		Unit_cag_fighter = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"cag_fighter"
			}
		},
		Unit_cag_mltr = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"cag_mltr"
			}
		},
		Unit_cag_vtol = {															-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"cag_vtol"
			}
		},
		Unit_bomber_strike = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"bomber_strike"
			}
		},
		Unit_bomber_strategic = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"bomber_strategic"
			}
		},
		Unit_recon_plane = {														-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"recon_plane"
			}
		},
		Unit_awacs_air_plane = {													-- Division Type
			Comp_Default = { 														-- "Country" (DEFAULT, NATO, WP, country tag..)
				"awacs_air_plane"
			}
		}
-- planes end
	}
-- planes end
-- All units end
}
-- All units end

-- Country Basic Master Table End

function CountrySetup(ActTag)

	--local minister = minister
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local ActTag = ActTag--minister:GetCountryTag()
	local ActTagTbl = tostring(ActTag)
	local ActCountry = ActTag:GetCountry()
--Utils.LUA_DEBUGOUT("Check before Loop-ActTagTbl -: " .. tostring(ActTagTbl) .. " -ActCountry  : " .. tostring(ActCountry))
	--local ActAI = minister:GetOwnerAI()
	local Defcon = ActCountry:GetDefconLevel()
	--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Defcon---: " .. tostring(ActTag) .. "--#--" ..  tostring(Defcon))
	-- #############################
	local HighestThreatCtry = ActCountry:GetHighestThreat()
	local HighestThreat = ActCountry:GetRelation(HighestThreatCtry):GetThreat():Get()
--Utils.LUA_DEBUGOUT("Check HighestThreatCtry -: " .. tostring(ActTagTbl) .. " -HighestThreatCtry  : " .. tostring(HighestThreatCtry))
	-- #############################
	local HasFaction = ActCountry:HasFaction()
	local Faction = nil
	local FactionName = nil
	local ActFactionLeader = nil
	local ActFactionLeaderTag = nil
	local FactionLeader = ActCountry:IsFactionLeader()
	
	if HasFaction == true then
		Faction = ActCountry:GetFaction()
		FactionName = Faction:GetTag()
		ActFactionLeader = Faction:GetFactionLeader():GetCountry()
		--ActFactionLeaderTag = ActFactionLeader:GetTag()
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Faction---: " .. tostring(ActTag) .. "--Faction Name--" ..  tostring(FactionName))
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---ActFactionLeader---: " .. tostring(ActTag) .. "--Faction Name--" ..  tostring(ActFactionLeader))
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---ActFactionLeaderTag---: " .. tostring(ActTag) .. "--Faction Name--" ..  tostring(ActFactionLeaderTag))
	end
	
	-- #############################
	local DiploPoints = ActCountry:GetDiplomaticInfluence():Get()
	--Utils.LUA_DEBUGOUT("--1---RUCKSACK---DiploPoints---: " .. tostring(ActTag) .. "--#--" ..  tostring(DiploPoints))
	local OurSurrenderLevel =  ActCountry:GetSurrenderLevel():Get() * 100
	local OurPeaceTermTotalValue= ActCountry:GetPeaceTermTotalValue()
	local War = ActCountry:IsAtWar()
	local Warscore = 0
	local ActStrategy = ActCountry:GetStrategy()
	local ActDesperation = ActCountry:CalcDesperation():Get()

	-- #############################
	local ActGDP = ActCountry:GetDailyIncome(CGoodsPool._INCOME_):Get()
	--Utils.LUA_DEBUGOUT("Daily-GDP" .. " - " ..  tostring(ActTag) .. " - "  .. tostring(DailyGDP))
	local GDPSizeChk = 0

	if ActGDP < 500 then
		GDPSizeChk = 1										-- Economy Only
	elseif ActGDP < 1500 then
		GDPSizeChk = 2										-- Infantry Unit advances
	elseif ActGDP < 5000 then
		GDPSizeChk = 3										-- Air / Land / Sea
	elseif ActGDP < 10000 then
		GDPSizeChk = 4										-- ALL units
	elseif ActGDP < 15000 then
		GDPSizeChk = 5										-- Nuclear
	else
		GDPSizeChk = 6										-- Space race
	end
--Utils.LUA_DEBUGOUT("Research - 1 - " .. tostring(ActTag) .. " CountrySizeChk: " .. tostring(CountrySizeChk) )
	-- #############################

		--Utils.LUA_DEBUGOUT("CountrySetup" .. " - " ..  tostring(ActTag) .. "--- GetActingCapitalLocation ---"  .. tostring(Capital))
		--Utils.LUA_DEBUGOUT("CountrySetup" .. " - " ..  tostring(ActTag) .. "--- CapitalProvId ---"  .. tostring(CapitalProvId))
		--Utils.LUA_DEBUGOUT("CountrySetup" .. " - " ..  tostring(ActTag) .. "--- CapitalContinent ---"  .. tostring(CapitalContinent))
--[[
Continents =
north_america
europe
africa
asia
south_america
oceania
]]

	-- reset, easier then to cycle over and check wich one might be not valid any more
	--AllyTable[ActTagTbl] = nil
	local AllyTable = {}
	for AllyCountry in ActCountry:GetAllies() do													-- With who?
		--local AllyCountryTag = AllyCountry:GetCountryTag()
		local AllyCountryTagTbl = tostring(AllyCountry)
		table.insert(AllyTable, AllyCountryTagTbl)
	end
	-- End of: for AllyTag in ActCountry:GetAllies() do

	-- reset, easier then to cycle over and check wich one might be not valid any more
	--PuppetTable[ActTagTbl] = nil
	local PuppetTable = {}
	for PuppetCountry in ActCountry:GetVassals() do													-- Do we have puppets?
		--local PuppetCountryTag = PuppetCountry:GetCountryTag()
		local PuppetCountryTagTbl = tostring(PuppetCountry)
		table.insert(PuppetTable, PuppetCountryTagTbl)
	end
	-- End of: for PuppetTag in ActCountry:GetVassals() do

	local OverlordTag = nil
	if ActCountry:IsSubject() then																-- Are we a puppet?
		OverlordTag = ActCountry:GetOverlord()
	end
	--local PossibleWarAidTarget = {}
	-- #############################
--if ( ActTagTbl == "USA") then
--GDPSizeChk = 6
--end
	local ControlledProvincesNew = ActCountry:GetNumberOfControlledProvinces()
	local Country = {
		Timestamp = AllDays,
		Minister = nil, --minister,
		ActTag = ActTag,
		ActTagTbl = ActTagTbl,
		ActAI = nil,--ActAI,
		ActCountry = ActCountry,
		ControlledProvincesNew = ControlledProvincesNew,
		CapitalProvId = ActCountry:GetActingCapitalLocation():GetProvinceID(),
		CapitalContinent = ActCountry:GetActingCapitalLocation():GetContinent():GetTag(),
		MobilizingNeededManpower = ActCountry:HasExtraManpowerLeft(),
		TotalAvailableManpower = ActCountry:GetManpower():Get(),
		MPLow = false,
		TechStatus = ActCountry:GetTechnologyStatus(),
		SeaAvail = (ActCountry:GetNumOfPorts() > 0),				-- and money < 100)
		AirAvail = (ActCountry:GetNumOfAirfields() > 0), 			-- and money < 100)
		ActYear = CCurrentGameState.GetCurrentDate():GetYear(),
		ActMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),
		ActDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),
		ActDissent = ActCountry:GetDissent():Get(),
		ActNU = ActCountry:GetNationalUnity():Get(),
		HasFaction = HasFaction,
		Faction = Faction,
		FactionName = FactionName,
		FactionLeader = FactionLeader,
		ActFactionLeader = ActFactionLeader,
		DiploPoints = DiploPoints,
		OurSurrenderLevel =  OurSurrenderLevel,
		OurPeaceTermTotalValue = OurPeaceTermTotalValue,
		Neutrality = ActCountry:GetNeutrality():Get(),
		EffectiveNeutrality = ActCountry:GetEffectiveNeutrality(),
		HighestThreatCtry = HighestThreatCtry,
		HighestThreat = HighestThreat,
		Defcon = Defcon,
		War = War,
		WarTable = WarTable,
		PeaceTable = PeaceTable,
		AllyTable = AllyTable,
		PuppetTable = PuppetTable,
		OverlordTag = OverlordTag,
		PossibleWarAidTarget = nil,
		WarStat = nil,
		Warscore = Warscore,
		ActStrategy = ActStrategy,
		ActDesperation = ActDesperation,
		ControlledProvinces = nil,
		ControlledProvincesOld = nil,
		Clock = CAI.GetDoomsDayClockMinutes(),
		LastElectionDate = ActCountry:GetLastElectionDate(),
		RatingMajor = ActCountry:GetMajorRating(),
		ActDATE = nil,
		ActMoney = nil, 			-- wich to choose balance/actual?..
		ActGDP = ActGDP,			-- How much we gain each day..(can be + or -)
		GDPSizeChk = GDPSizeChk,	-- Number for easy chk
		ActMoneyProdLand = nil,
		ActMoneyProdLandInf = nil,
		ActMoneyProdLandMobile = nil,
		ActMoneyProdLandSpecial = nil,
		ActMoneyProdSea = nil,
		ActMoneyProdSeaEscort = nil,
		ActMoneyProdSeaCoast = nil,
		ActMoneyProdSeaSAG = nil,
		ActMoneyProdSeaCarrier = nil,
		ActMoneyProdSeaSub = nil,
		ActMoneyProdAir = nil,
		ActMoneyProdAirFighter = nil,
		ActMoneyProdAirGround = nil,
		ActMoneyProdAirBomber = nil,
		ActMoneyProdAirNaval = nil,
		ActMoneyProdAirSpecial = nil,
		FactionAlignment = nil,
		Prestige = nil
	}
	-- New Pre-Production Check
	if Grand_Country_Table["Ignition-" .. ActTagTbl] == nil then
		--local Ignition = AllDays
		--table.insert(Country, Ignition)
		Grand_Country_Table["Ignition-" .. ActTagTbl] = AllDays
--Utils.LUA_DEBUGOUT("-IGNITION-RUCKSACK-1-: " .. tostring(ActTag) .. "-" ..  tostring(Grand_Country_Table["Ignition-" .. ActTagTbl]))
	else
--Utils.LUA_DEBUGOUT("-IGNITION-RUCKSACK-2-: " .. tostring(ActTag) .. "-" ..  tostring(Grand_Country_Table["Ignition-" .. ActTagTbl]))
	
	end

	-- Put all in the global table
	Grand_Country_Table["Country-" .. ActTagTbl] = Country
	--ProductionNeed(ActTagTbl)
--[[

Utils.LUA_DEBUGOUT("--1---RUCKSACK-----: " .. tostring(ActTag) .. "--CapitalprovID--" ..  tostring(Country.CapitalProvId))
Utils.LUA_DEBUGOUT("--1---RUCKSACK-----: " .. tostring(ActTag) .. "--CapitalContinent--" ..  tostring(Country.CapitalContinent))
if Country.HasFaction == true then
	Utils.LUA_DEBUGOUT("--2---RUCKSACK---Faction---: " .. tostring(ActTag) .. "--ActDate--" ..  tostring(Country.FactionName))
end
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Faction---: " .. tostring(ActTag) .. "--ActDate--" ..  tostring(Grand_Country_Table["Country-" .. ActTagTbl].Faction))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Country---: " .. tostring(ActTag) .. "--RUCKSACK--" ..  "--RUCKSACK--")
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Country---: " .. tostring(ActTag) .. "--ActDate--" ..  tostring(ActDate))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Country---: " .. tostring(ActTag) .. "--ActTagTbl--" ..  tostring(ActTagTbl))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Country---: " .. tostring(ActTag) .. "--Timestamp--" ..  tostring(Grand_Country_Table["Country-" .. ActTagTbl].Timestamp))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Country---: " .. tostring(ActTag) .. "--ActMonth--" ..  tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActMonth))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Country---: " .. tostring(ActTag) .. "--ActDay--" ..  tostring(Grand_Country_Table["Country-" .. ActTagTbl].ActDay))
]]

end

function DiplomacySetup(ActTagTbl)

	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()

	local GDPSizeChk = Grand_Country_Table["Country-" .. ActTagTbl].GDPSizeChk
	--local WarTable = Grand_Country_Table["Country-" .. ActTagTbl].WarTable
	local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]
-- ## Start initial diplo situation
-- ##############################



	local score = 0
	-- reset, easier then to cycle over and check wich one might be not valid any more
	local RelationTable = {
		Timestamp = {							-- Timestamp, how actual is the list
			Score = 50,
			Day = AllDays,
			Month = 0,
			Year = 0
		}
	}
	local ForeignWarAidTarget = {}

	-- Setup basic info of foreign countries relation for later use
	for ForeignCountry in CCurrentGameState.GetCountries() do					--ForeignCountry Tag or Country?
		local ForeignCountryTag = ForeignCountry:GetCountryTag()
		local ForeignCountryCtry = ForeignCountryTag:GetCountry()
		local ForeignCountryTagTbl = tostring(ForeignCountryTag)

		if not(ForeignCountryTag == ActTag)
		--and ForeignCountryTag:Exists()
		and ForeignCountryTag:IsReal()
		and ForeignCountryTag:IsValid() then

			
			local ForeignCountryTbl = {
				ForeignCountryTagTbl = nil,
				ForeignCountryRelation = nil,
				ForeignCountryThreat = nil,
				Neighbour = nil,
				SameContinent = nil,
				World = nil
			}
			local ForeignCountryRelationArray = ActAI:GetRelation(ActTag, ForeignCountryTag)
			ForeignCountryTbl.ForeignCountryTagTbl = ForeignCountryTagTbl
			ForeignCountryTbl.ForeignCountryRelation = ForeignCountryRelationArray:GetValue():GetTruncated() 		-- Or just :Get for the float?
			--ForeignCountryThreat = ForeignCountryRelationArray:GetThreat():Get()					-- .. 
			-- .. Need to check out the multiplier of threat further, values ranged from 2450 to 12..
			ForeignCountryTbl.ForeignCountryThreat = math.floor((ForeignCountryRelationArray:GetThreat():Get() * 1000))

			-- Country Data Setup needed(threading..)
			if (Grand_Country_Table["Country-" .. ForeignCountryTagTbl] == nil ) then
			--if next(Grand_Country_Table["Country-" .. ForeignCountryTagTbl]) == nil then
				CountrySetup(ForeignCountryTag)
--Utils.LUA_DEBUGOUT("CountrySetup" .. " - " ..  tostring(ActTag) .. "--- ForeignCountryTagTbl] == nil ---"  .. tostring(ForeignCountryTagTbl))
			elseif (Grand_Country_Table["Country-" .. ForeignCountryTagTbl].Timestamp) < (AllDays) then
				CountrySetup(ForeignCountryTag)
			end
--Utils.LUA_DEBUGOUT("CountrySetup" .. " - " ..  tostring(ActTag) .. "--- AllDays ---"  .. tostring(AllDays))
--Utils.LUA_DEBUGOUT("CountrySetup" .. " - " ..  tostring(ActTag) .. "--- Timestamp ---"  .. tostring(Grand_Country_Table["Country-" .. ForeignCountryTagTbl].Timestamp))


			local World = nil
			local SameContinent = nil
			local Neighbour = nil
				
			if ActCountry:IsNeighbour(ForeignCountryTag) then
				Neighbour = true
				ForeignCountryTbl.Neighbour = true
					
				--table.insert(Neighbour_Relation_Table, ForeignCountryTbl[ForeignCountryTagTbl])
				--RelationTable["Country-" .. ForeignCountryTagTbl] = ForeignCountryTbl
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--Neighbour-1-" ..  tostring(Neighbour))
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--Neighbour-2-" ..  tostring(ForeignCountryTagTbl))
			elseif GDPSizeChk > 3 then
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--Within Continent-" ..  tostring(GDPSizeChk))
				local OurContinent = tostring(Grand_Country_Table["Country-" .. ActTagTbl].CapitalContinent)
				local TheirContinent = tostring(Grand_Country_Table["Country-" .. ForeignCountryTagTbl].CapitalContinent)
				if OurContinent == TheirContinent then
					SameContinent = true
					ForeignCountryTbl.SameContinent = true

					--table.insert(Continent_Relation_Table, ForeignCountryTbl[ForeignCountryTagTbl])
					--RelationTable["Country-" .. ForeignCountryTagTbl] = ForeignCountryTbl
				--end
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--SameContinent-1-" ..  tostring(SameContinent))
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--SameContinent-2-" ..  tostring(ForeignCountryTagTbl))
				elseif GDPSizeChk > 4 then
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--Within World-" ..  tostring(GDPSizeChk))
					World = true
					ForeignCountryTbl.World = true
					--Grand_Diplomacy_Table["Country-" .. ActTagTbl] = Country
					--table.insert(World_Relation_Table, ForeignCountryTbl["Country-" .. ForeignCountryTagTbl])
					--RelationTable["Country-" .. ForeignCountryTagTbl] = ForeignCountryTbl
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--TEST-Relation-" ..  tostring(ForeignCountryTagTbl) ..  tostring(World_Relation_Table["Country-" .. ForeignCountryTagTbl].ForeignCountryRelation))
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--TEST-Threat-" ..  tostring(ForeignCountryTagTbl) ..  tostring(World_Relation_Table["Country-" .. ForeignCountryTagTbl].ForeignCountryThreat))
				end
			end

			-- Adding more checks and writing the table entry if the country is valid
			if (Neighbour or SameContinent or World) then

				-- Faction?
				local ForeignCountryFaction = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].FactionName
				local ActFaction = Grand_Country_Table["Country-" .. ActTagTbl].FactionName

				local OurFaction = nil
				local OtherFaction = nil
						
				if ForeignCountryFaction == ActFaction then											-- In our faction
					OurFaction = true
					score = score + 10
				elseif Grand_Country_Table["Country-" .. ForeignCountryTagTbl].HasFaction then		-- In another faction
					OtherFaction = true
					score = score + 0
				else																				-- In none faction yet
					score = score + 5
				end

				-- Alignement?
				local AligningOurFactionValue = 0
				local AligningOtherFactionValue = 0
				local AligningFactionTag = nil
				local AligningFactionValue = 200
				
				local FactionLeadNeighbour = nil
				
				for Faction in CCurrentGameState.GetFactions() do
					local FactionName = Faction:GetTag()
					local FactionLeader = Faction:GetFactionLeader():GetCountry()
					local FactionLeaderTag = FactionLeader:GetCountryTag()
					local FactionLeaderTagTbl = tostring(FactionLeaderTag)
					
					local AlignmentValue = ActAI:GetCountryAlignmentDistance(ForeignCountry, FactionLeader):Get()
					if AlignmentValue < AligningFactionValue then
						AligningFactionTag = Faction:GetTag()
						AligningFactionValue = AlignmentValue
					end
					-- Neighbour of another faction leader? Leave them out?
					-- Not yet, as the big guy could take just one by one..
					if FactionName ~= ActFaction then
						if ForeignCountryCtry:IsNeighbour(FactionLeaderTag) then
							--FactionLeadNeighbour = true
						end
					end
					
				end

				if AligningFactionTag == ActFaction then			-- Leaning towards our faction
					--score = score + 5
				else												-- Leaning towards other faction
					--score = score + 0
				end

--################################################################
 --if ( ActTagTbl == "USA") then

			-- Are they at war, and with who?
			-- faction/alliance needs to make sure if any members neighbours involved?
			

			
			local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]
			--local ForeignWarTable = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].WarTable
			--if ForeignWarTable ~= (nil) then												-- They are at war..
			if not(OtherFaction) or not(FactionLeadNeighbour) then
				if WarTable ~= nil then
					-- ForeignWarTable is empty
	--Utils.LUA_DEBUGOUT("-1-RUCKSACK-ForeignWarTable ~= (nil)---: " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) )

					for k, v in pairs(WarTable) do
						if (k ~= ("Timestamp")) and (k ~= ("OverallWarStat")) then
							local ForeignEnemyTagTbl = tostring(v.Enemy)
							local ForeignWarStart = v.WarStart
							local ForeignWarEnd = v.WarEnd
							local OurEnemy = nil
							local OurWarStart = nil
							local OurWarEnd = nil
							--local ForeignEnemy = Grand_Country_Table["Country-" .. ForeignEnemyTagTbl].ActCountry
							--local ForeignEnemyFaction = Grand_Country_Table["Country-" .. ForeignEnemyTagTbl].FactionName
							
							local ActWar = v.ActWar

							if not(ActWar) then
--Utils.LUA_DEBUGOUT("-3-RUCKSACK-ForeignWarTable In AID TBL " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) )
								ForeignWarAidTarget[ForeignEnemyTagTbl] = ForeignEnemyTagTbl
							end
							-- end of: if not(ActWar) then
--Utils.LUA_DEBUGOUT("-RUCKSACK-Main Loop: " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) .. "-#ForeignWarTable-" ..  tostring(#ForeignWarTable) .. "-Loop#-" ..  tostring(j) .. "-Enemy-" ..  tostring(ForeignEnemyTagTbl) )
						end
						-- end of: if ForeignWarTable[j] ~= ("Timestamp" or "OverallWarStat") then
					end
					-- end of: for k, v in pairs(WarTable) do
				end
				--end of: if not(next(ForeignWarTable) == nil) then
			end
			-- end of: if not(OtherFaction) or not(FactionLeadNeighbour) then
			
--end
-- end of: if ( ActTagTbl == "USA") then 
--################################################################


				--Grand_Country_Table["Country-" .. ActTagTbl].PossibleWarAidTarget = ForeignWarAidTarget
				Grand_Diplomacy_Table["PossibleWarAid-" .. ActTagTbl] = ForeignWarAidTarget
			end
			-- end of: Adding more checks and writing the table entry if the country is valid
			
			-- Writing the entries in tables
			RelationTable["Country-" .. ForeignCountryTagTbl] = ForeignCountryTbl

		end
		-- end of: if not(ForeignCountryTag == ActTag)

	end
	-- end of: Setup basic info of foreign countries relation for later use

	--Grand_Diplomacy_Table["Country-" .. ActTagTbl] = Country
	--if RelationTable ~= (nil) then
	if not(next(RelationTable) == nil) then
		-- ForeignWarTable is empty
		Grand_Diplomacy_Table["RelationTable-" .. ActTagTbl] = RelationTable
		--AllCountryCheck(ActTagTbl, TableName)
	end	


--[[
-- more data storing needed ir this just in case of need,
-- as it would not been need to query that often?
	local Country = {

		Alliance = nil,
		Faction = nil,
		UNLeader = nil,
		UNMember = nil,

		MilitaryAccessIn = {},
		MilitaryAccessTo = {},
		GuranteeFrom = {},
		GuranteeTo = {},
		EmbargoFrom = {},
		EmbargoTo = {},
		InfluencedFrom = {},
		InfluencingTo = {},
		NonAggressionPactWith = {},

		HasCoresFromUs = nil,
		WeHaveCoresFromThem = nil,
		Warscore = nil,
		Relations = nil,
		ThreatToThem = nil,
		ThreatToUs = nil,

		TechsForUs = nil,
		TechsForThem = nil,
		LicenceForUs = nil,
		LicenceForThem = nil,
		FuelForUs = nil,
		FuelForThem = nil,
		SupplyForUs = nil,
		SupplyForThem = nil
	}

	-- Put all in the global table
	DiploTable["DiploInfo-" .. ActTagTbl] = Country
	DiploTable["DiploInfo-" .. ActTagTbl] = Country
	DiploTable["Relation-" .. ActTagTbl]NeighboursTable["Neighbour-" .. NeighbourTagTbl] = Country
	DiploTable["Relation-" .. ActTagTbl]ContinentTable["Continent-" .. ContinentTagTbl] = Country
	DiploTable["Relation-" .. ActTagTbl]WorldTable["World-" .. WorldTagTbl] = Country
]]



-- #############################
-- ## End initial diplo situation

end

function NationSetup(ActTagTbl)

	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()

-- ##  Start of Culture Setup
-- #############################
	local ActNation = {									-- Country check table
		Timestamp = {									-- Timestamp, how actual is the list
			Score = 50,
			Day = 0,
			Month = 0,
			Year = 0,
			MaxEndIndex = 31							-- Needed for Check in Nation change code, put in here the EndIndex from last Nation Group!
		},
		Ideology = nil,									-- Single value Ideology
		Government = nil,								-- Single value Goverment
		Culture = {										-- Culture groups with start and end date of index(the following tsart date is the end date of the current..)
			CultureGroup = nil,							-- CultureGroup used "internal" by the engine, needed eventually for the post ai command
			CurrentCulture = nil,						-- Current "culture entry" index, the name can be generated or written in a seperate table
			StartIndex = 1,								-- First start index from the "culture entries" of this group(common\national_ideas.txt.txt)
			EndIndex = 10								-- End index +1 from the "culture entries" of this group(common\national_ideas.txt.txt)
		},
		Religion = {
			CultureGroup = nil,
			CurrentCulture = nil,
			StartIndex = 10,
			EndIndex = 18
		},
		Identity = {
			CultureGroup = nil,
			CurrentCulture = nil,
			StartIndex = 18,
			EndIndex = 25
		},
		Attitude = {
			CultureGroup = nil,
			CurrentCulture = nil,
			StartIndex = 25,
			EndIndex = 31
		}
	}

	--Set Timestamp
	ActNation.Timestamp.Day = AllDays

	-- Ideology and Goverment
	ActNation.Ideology = ActCountry:GetRulingIdeology():GetKey()
	ActNation.Government = ActCountry:GetGovernment():GetIndex() 
	-- :GetKey() does not work.. So no gov name possible only numbers.. need a number description then for better readability

	-- Here we fill the ActNation table, the end index of the current Culture Group is taken from the start index of the following Culture Group
	local CultureGroup = nil
	for CultureGroup in CNIdeaDataBase.GetGroups() do	-- Initial check for all current Culture settings

		local CultureIndex = (ActCountry:GetNIdea(CultureGroup)):GetIndex()

		if (CultureIndex >= ActNation.Culture.StartIndex) and (CultureIndex < ActNation.Culture.EndIndex) then
			ActNation.Culture.CultureGroup = CultureGroup
			ActNation.Culture.CurrentCulture = CultureIndex

		elseif (CultureIndex >= ActNation.Religion.StartIndex) and (CultureIndex < ActNation.Religion.EndIndex) then
			ActNation.Religion.CultureGroup = CultureGroup
			ActNation.Religion.CurrentCulture = CultureIndex

		elseif (CultureIndex >= ActNation.Identity.StartIndex) and (CultureIndex < ActNation.Identity.EndIndex) then
			ActNation.Identity.CultureGroup = CultureGroup
			ActNation.Identity.CurrentCulture = CultureIndex

		elseif (CultureIndex >= ActNation.Attitude.StartIndex) and (CultureIndex < ActNation.Attitude.EndIndex) then
			ActNation.Attitude.CultureGroup = CultureGroup
			ActNation.Attitude.CurrentCulture = CultureIndex

		end
		-- no more checks needed
	-- end of culture
	end
-- #############################
-- ## End of Culture Setup

	-- Put all in the global table
	Grand_Nation_Table["ActNation-" .. ActTagTbl] = ActNation

--[[

Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--Nation--" ..  "--RUCKSACK--")
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--ActTagTbl--" ..  tostring(ActTagTbl))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--Ideology--" ..  tostring(Grand_Nation_Table["ActNation-" .. ActTagTbl].Ideology))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--Government--" ..  tostring(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--Culture--" ..  tostring(Grand_Nation_Table["ActNation-" .. ActTagTbl].Culture.CurrentCulture))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--Religion--" ..  tostring(Grand_Nation_Table["ActNation-" .. ActTagTbl].Religion.CurrentCulture))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--Identity--" ..  tostring(Grand_Nation_Table["ActNation-" .. ActTagTbl].Identity.CurrentCulture))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Nation---: " .. tostring(ActTag) .. "--Attitude--" ..  tostring(Grand_Nation_Table["ActNation-" .. ActTagTbl].Attitude.CurrentCulture))
]]

end

function LawsSetup(ActTagTbl)

	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()

-- ## Start of Laws Setup
-- #############################
	local ActLaws = {									-- Law check table
		Timestamp = {									-- Timestamp, how actual is the list
			Score = 50,
			Day = 0,
			Month = 0,
			Year = 0,
			MaxEndIndex = 39							-- Needed for Check in Laws change code, put in here the EndIndex from last Law Group!
		},
		CivilLiberties = {								-- Law Group Name
			LawGroup = nil,								-- LawGroup used "internal" by the engine, needed for the post ai command
			CurrentLaw = nil,							-- Current Law index, the name can be generated or written in a seperate table
			Score = 50,									-- Can be +1/-1 to change the Law in the change section
			StartIndex = 1,								-- First start index from the laws of this group(common\laws.txt)
			EndIndex = 6								-- End index +1 from the laws of this group(common\laws.txt)
		},
		RuleOfLaw = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 6,
			EndIndex = 11
		},
		ElectionsAndVoting  = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 11,
			EndIndex = 17
		},
		HumanRights = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 17,
			EndIndex = 21
		},
		PublicOversight = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 21,
			EndIndex = 26
		},
		FreedomOfThePress = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 26,
			EndIndex = 31
		},
		MilitaryService = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 31,
			EndIndex = 37
		},
		OrganizedReligionsLaw = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 37,
			EndIndex = 39
		}
	}

	--Set Timestamp
	ActLaws.Timestamp.Day = AllDays

	-- Here we fill the ActLaws table, the end index of the current Law Group is taken from the start index of the following Law Group
	local LawGroup = nil
	for LawGroup in CLawDataBase.GetGroups() do			-- Initial check for all current Laws

		local LawIndex = (ActCountry:GetLaw(LawGroup)):GetIndex()

		if (LawIndex >= ActLaws.CivilLiberties.StartIndex) and (LawIndex < ActLaws.CivilLiberties.EndIndex) then
			ActLaws.CivilLiberties.LawGroup = LawGroup
			ActLaws.CivilLiberties.CurrentLaw = LawIndex

		elseif (LawIndex >= ActLaws.RuleOfLaw.StartIndex) and (LawIndex < ActLaws.RuleOfLaw.EndIndex) then
			ActLaws.RuleOfLaw.LawGroup = LawGroup
			ActLaws.RuleOfLaw.CurrentLaw = LawIndex

		elseif (LawIndex >= ActLaws.ElectionsAndVoting.StartIndex) and (LawIndex < ActLaws.ElectionsAndVoting.EndIndex) then
			ActLaws.ElectionsAndVoting.LawGroup = LawGroup
			ActLaws.ElectionsAndVoting.CurrentLaw = LawIndex
			
		elseif (LawIndex >= ActLaws.HumanRights.StartIndex) and (LawIndex < ActLaws.HumanRights.EndIndex) then
			ActLaws.HumanRights.LawGroup = LawGroup
			ActLaws.HumanRights.CurrentLaw = LawIndex

		elseif (LawIndex >= ActLaws.PublicOversight.StartIndex) and (LawIndex < ActLaws.PublicOversight.EndIndex) then
			ActLaws.PublicOversight.LawGroup = LawGroup
			ActLaws.PublicOversight.CurrentLaw = LawIndex

		elseif (LawIndex >= ActLaws.FreedomOfThePress.StartIndex) and (LawIndex < ActLaws.FreedomOfThePress.EndIndex) then
			ActLaws.FreedomOfThePress.LawGroup = LawGroup
			ActLaws.FreedomOfThePress.CurrentLaw = LawIndex

		elseif (LawIndex >= ActLaws.MilitaryService.StartIndex) and (LawIndex < ActLaws.MilitaryService.EndIndex) then
			ActLaws.MilitaryService.LawGroup = LawGroup
			ActLaws.MilitaryService.CurrentLaw = LawIndex

		elseif (LawIndex >= ActLaws.OrganizedReligionsLaw.StartIndex) and (LawIndex < ActLaws.OrganizedReligionsLaw.EndIndex) then
			ActLaws.OrganizedReligionsLaw.LawGroup = LawGroup
			ActLaws.OrganizedReligionsLaw.CurrentLaw = LawIndex

		-- no more checks
		end
	-- end of law
	end
-- #############################
-- ## End of Laws Setup

	-- Put all in the global table
	Grand_Laws_Table["ActLaws-" .. ActTagTbl] = ActLaws

--[[

Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--RUCKSACK--" ..  "--RUCKSACK--")
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--ActTagTbl--" ..  tostring(ActTagTbl))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--CivilLiberties--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.CurrentLaw))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--CivilLiberties--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].CivilLiberties.Score))

Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--RuleOfLaw--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].RuleOfLaw.CurrentLaw))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--ElectionsAndVoting--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].ElectionsAndVoting.CurrentLaw))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--HumanRights--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].HumanRights.CurrentLaw))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--PublicOversight--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].PublicOversight.CurrentLaw))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--FreedomOfThePress--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].FreedomOfThePress.CurrentLaw))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--MilitaryService--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].MilitaryService.CurrentLaw))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Laws---: " .. tostring(ActTag) .. "--OrganizedReligionsLaw--" ..  tostring(Grand_Laws_Table["ActLaws-" .. ActTagTbl].OrganizedReligionsLaw.CurrentLaw))
]]

end

function PoliciesSetup(ActTagTbl)

	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()

-- ## Start Policies Setup
-- #############################
	local ActPolicies = {								-- Policy check table
		Timestamp = {									-- Timestamp, how actual is the list
			Score = 50,
			Day = 0,
			Month = 0,
			Year = 0,
			MaxEndIndex = 71							-- Needed for Check in Politics change code, put in here the EndIndex from last Policy Group!
		},
		ForeignPolicy = {								-- Policy Group Name
			PolicyGroup = nil,							-- PolicyGroup used "internal" by the engine, needed for the post ai command
			CurrentPolicy = nil,						-- Current Policy index, the name can be generated or written in a seperate table
			Score = 50,									-- Can be +1/-1 to change the Policy in the change section
			StartIndex = 1,								-- First start index from the Policy of this group(common\policies.txt)
			EndIndex = 6								-- End index +1 from the laws of this group(common\policies.txt)
		},
		DomesticPolicy = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 6,
			EndIndex = 13
		},
		IntelligencePolicy  = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 13,
			EndIndex = 21
		},
		InternalPolicy = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 21,
			EndIndex = 26
		},
		ArmamentsPolicy = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 26,
			EndIndex = 37
		},
		EconomicPolicy = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 37,
			EndIndex = 46
		},
		MilitaryPolicy = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 46,
			EndIndex = 54
		},
		FiscalPolicy = {
			LawGroup = nil,
			CurrentLaw = nil,
			Score = 50,
			StartIndex = 54,
			EndIndex = 62
		},
		NuclearPolicy = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 62,
			EndIndex = 66
		},
		EducationPolicy = {
			PolicyGroup = nil,
			CurrentPolicy = nil,
			Score = 50,
			StartIndex = 66,
			EndIndex = 71
		}
	}

	--Set Timestamp
	ActPolicies.Timestamp.Day = AllDays

	-- Here we fill the ActPolicies table, the end index of the current Policy Group is taken from the start index of the following Policy Group
	local PolicyGroup = nil
	for PolicyGroup in CPolicyDataBase.GetGroups() do	-- Initial check for all current Policies

		local PolicyIndex = (ActCountry:GetPolicy(PolicyGroup)):GetIndex()

		if (PolicyIndex >= ActPolicies.ForeignPolicy.StartIndex) and (PolicyIndex < ActPolicies.ForeignPolicy.EndIndex) then
			ActPolicies.ForeignPolicy.PolicyGroup = PolicyGroup
			ActPolicies.ForeignPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.DomesticPolicy.StartIndex) and (PolicyIndex < ActPolicies.DomesticPolicy.EndIndex) then
			ActPolicies.DomesticPolicy.PolicyGroup = PolicyGroup
			ActPolicies.DomesticPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.IntelligencePolicy.StartIndex) and (PolicyIndex < ActPolicies.IntelligencePolicy.EndIndex) then
			ActPolicies.IntelligencePolicy.PolicyGroup = PolicyGroup
			ActPolicies.IntelligencePolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.InternalPolicy.StartIndex) and (PolicyIndex < ActPolicies.InternalPolicy.EndIndex) then
			ActPolicies.InternalPolicy.PolicyGroup = PolicyGroup
			ActPolicies.InternalPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.ArmamentsPolicy.StartIndex) and (PolicyIndex < ActPolicies.ArmamentsPolicy.EndIndex) then
			ActPolicies.ArmamentsPolicy.PolicyGroup = PolicyGroup
			ActPolicies.ArmamentsPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.EconomicPolicy.StartIndex) and (PolicyIndex < ActPolicies.EconomicPolicy.EndIndex) then
			ActPolicies.EconomicPolicy.PolicyGroup = PolicyGroup
			ActPolicies.EconomicPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.MilitaryPolicy.StartIndex) and (PolicyIndex < ActPolicies.MilitaryPolicy.EndIndex) then
			ActPolicies.MilitaryPolicy.PolicyGroup = PolicyGroup
			ActPolicies.MilitaryPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.FiscalPolicy.StartIndex) and (PolicyIndex < ActPolicies.FiscalPolicy.EndIndex) then
			ActPolicies.FiscalPolicy.PolicyGroup = PolicyGroup
			ActPolicies.FiscalPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.NuclearPolicy.StartIndex) and (PolicyIndex < ActPolicies.NuclearPolicy.EndIndex) then
			ActPolicies.NuclearPolicy.PolicyGroup = PolicyGroup
			ActPolicies.NuclearPolicy.CurrentPolicy = PolicyIndex

		elseif (PolicyIndex >= ActPolicies.EducationPolicy.StartIndex) and (PolicyIndex < ActPolicies.EducationPolicy.EndIndex) then
			ActPolicies.EducationPolicy.PolicyGroup = PolicyGroup
			ActPolicies.EducationPolicy.CurrentPolicy = PolicyIndex

		-- no more checks
		end
	-- end of policy
	end
-- #############################
-- ## End of Policies Setup

	-- Put all in the global table
	Grand_Policies_Table["ActPolicies-" .. ActTagTbl] = ActPolicies

--[[

Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--RUCKSACK--" ..  "--RUCKSACK--")
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--ActTagTbl--" ..  tostring(ActTagTbl))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--ForeignPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--FP-Score--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ForeignPolicy.Score))

Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--DomesticPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].DomesticPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--IntelligencePolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].IntelligencePolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--InternalPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].InternalPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--ArmamentsPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].ArmamentsPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--EconomicPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EconomicPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--MilitaryPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].MilitaryPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--FiscalPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].FiscalPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--NuclearPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].NuclearPolicy.CurrentPolicy))
Utils.LUA_DEBUGOUT("--1---RUCKSACK---Policies---: " .. tostring(ActTag) .. "--EducationPolicy--" ..  tostring(Grand_Policies_Table["ActPolicies-" .. ActTagTbl].EducationPolicy.CurrentPolicy))
]]

end

function UnitsSetup(ActTagTbl)

	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local SeaAvail = Grand_Country_Table["Country-" .. ActTagTbl].SeaAvail 			-- and money < 100)
	local AirAvail = Grand_Country_Table["Country-" .. ActTagTbl].AirAvail 			-- and money < 100)
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local bBuildReserve = false  

-- ## Units pre-setup table start
-- ##############################
local LandUnits = {
	Timestamp = {							-- Timestamp, how actual is the list
		Score = 50,
		Day = 0,
		Month = 0,
		Year = 0
	},
-- ## Land units Start
-- ##############################
	hq_brigade = {							-- Unit name
		Name = "hq_brigade",				-- Unit name for further use in code(Unit name as in units folder with " around)
		Type = "Land",						-- To wich main type the unit belongs
		Role = "HQ",						-- Role of the unit in the game(Survive, Armor, Mech, Infantry)
		Tech = nil,							-- Is technology available(or do we need license)
		MoneyCost = 0,						-- The actual unit cost in money
		ManpowerCost = 0,					-- The actual unit cost in manpower
		TheatreNeed = 0,					-- The Actual amount of these units requested by theatre ai
		ActCountAll = 0,					-- The Actual amount of these units in total
		ActCountMap = 0,					-- The Actual amount of these units on the map
		ActCountPool = 0,					-- The Actual amount of these units in the unit pool
		ActCountProduction = 0				-- The Actual amount of these units in production
	},
	militia_brigade = {
		Name = "militia_brigade",
		Type = "Land",
		Role = "Survive",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	infantry_brigade = {
		Name = "infantry_brigade",
		Type = "LandStd",
		Role = "Inf",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	motorized_brigade = {
		Name = "motorized_brigade",
		Type = "LandStd",
		Role = "Inf",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	light_mechanized_brigade = {
		Name = "light_mechanized_brigade",
		Type = "LandMob",
		Role = "Mech",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	heavy_mechanized_brigade = {
		Name = "heavy_mechanized_brigade",
		Type = "LandMob",
		Role = "Mech",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	cavalry_brigade = {
		Name = "cavalry_brigade",
		Type = "LandMob",
		Role = "Cavalry",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	air_cav_brigade = {
		Name = "air_cav_brigade",
		Type = "LandMob",
		Role = "Cavalry",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	armor_brigade = {
		Name = "armor_brigade",
		Type = "LandMob",
		Role = "Armor",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	bergsjaeger_brigade = {
		Name = "bergsjaeger_brigade",
		Type = "LandSpec",
		Role = "Mountain",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	marine_brigade = {
		Name = "marine_brigade",
		Type = "LandSpec",
		Role = "Naval",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	partisan_brigade = {
		Name = "partisan_brigade",
		Type = "Land",
		Role = "Revolt",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
-- ##############################
-- ## Land units End


-- ## Support units Start
-- ##############################
	all_terrain_vehicles = {	-- Hägglunds!
		Name = "all_terrain_vehicles",
		Type = "LandSuppMob",
		Role = "SpecialSupport",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	anti_air_brigade = {
		Name = "anti_air_brigade",
		Type = "LandSuppStd",
		Role = "AA",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	anti_tank_brigade = {
		Name = "anti_tank_brigade",
		Type = "LandSuppStd",
		Role = "AT",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	artillery_brigade = {
		Name = "artillery_brigade",
		Type = "LandSuppStd",
		Role = "Art",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	rocket_artillery_brigade = {
		Name = "rocket_artillery_brigade",
		Type = "LandSuppStd",
		Role = "RakArt",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	engineer_brigade = {
		Name = "engineer_brigade",
		Type = "LandSuppStd",
		Role = "Eng",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	attack_helo_brigade = {
		Name = "attack_helo_brigade",
		Type = "LandSuppMob",
		Role = "CavSupport",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	armored_engineer_brigade = {
		Name = "armored_engineer_brigade",
		Type = "LandSuppMob",
		Role = "Eng",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	sp_anti_air_brigade = {
		Name = "sp_anti_air_brigade",
		Type = "LandSuppMob",
		Role = "AA",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	tank_destroyer_brigade = {
		Name = "tank_destroyer_brigade",
		Type = "LandSuppMob",
		Role = "AT",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	sp_artillery_brigade = {
		Name = "sp_artillery_brigade",
		Type = "LandSuppMob",
		Role = "Art",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	sp_rct_artillery_brigade = {
		Name = "sp_rct_artillery_brigade",
		Type = "LandSuppMob",
		Role = "RakArt",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	long_range_anti_air_brigade = {
		Name = "long_range_anti_air_brigade",
		Type = "Land",
		Role = "AABuilding",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	police_brigade = {
		Name = "police_brigade",
		Type = "Land",
		Role = "Police",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	}
}
-- ##############################
-- ## Support units End

local SeaUnits = {
	Timestamp = {							-- Timestamp, how actual is the list
		Score = 50,
		Day = 0,
		Month = 0,
		Year = 0
	},
-- ##  Ships Start
-- ##############################
	submarine = {							-- Unit name
		Name = "submarine",					-- Unit name for further use in code(Unit name as in units folder with " around)
		Type = "Naval",						-- To wich main type the unit belongs
		Role = "Submarine",					-- Role of the unit in the game(Survive, Armor, Mech, Infantry)
		Tech = nil,							-- Is technology available(or do we need license)
		MoneyCost = 0,						-- The actual unit cost in money
		ManpowerCost = 0,					-- The actual unit cost in manpower
		TheatreNeed = 0,					-- The Actual amount of these units requested by theatre ai
		ActCountAll = 0,					-- The Actual amount of these units in total
		ActCountMap = 0,					-- The Actual amount of these units on the map
		ActCountPool = 0,					-- The Actual amount of these units in the unit pool
		ActCountProduction = 0				-- The Actual amount of these units in production
	},
	attack_submarine = {
		Name = "attack_submarine",
		Type = "Naval",
		Role = "Submarine",	
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	nuclear_submarine = {
		Name = "nuclear_submarine",
		Type = "Naval",
		Role = "Submarine",	
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	guided_submarine = {
		Name = "guided_submarine",
		Type = "Naval",
		Role = "Submarine",	
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	nuclear_guided_submarine = {
		Name = "nuclear_guided_submarine",
		Type = "Naval",
		Role = "Submarine",	
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	ballistic_missile_submarine = {
		Name = "ballistic_missile_submarine",
		Type = "Naval",	
		Role = "Submarine",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	missile_boat = {
		Name = "missile_boat",
		Type = "Naval",	
		Role = "Coast",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	missile_frigate = {
		Name = "missile_frigate",
		Type = "Naval",	
		Role = "Escort",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	destroyer = {
		Name = "destroyer",
		Type = "Naval",	
		Role = "Escort",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	missile_destroyer = {
		Name = "missile_destroyer",
		Type = "Naval",	
		Role = "Escort",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	cruiser = {
		Name = "cruiser",
		Type = "Naval",	
		Role = "Cruiser",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	missile_cruiser = {
		Name = "missile_cruiser",
		Type = "Naval",	
		Role = "Cruiser",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	nuclear_battlecruiser = {
		Name = "nuclear_battlecruiser",
		Type = "Naval",	
		Role = "Battle",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	battleship = {
		Name = "battleship",
		Type = "Naval",	
		Role = "Battle",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	escort_carrier = {
		Name = "escort_carrier",
		Type = "Naval",	
		Role = "Carrier",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	carrier = {
		Name = "carrier",
		Type = "Naval",	
		Role = "Carrier",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	helicopter_carrier = {
		Name = "helicopter_carrier",
		Type = "Naval",	
		Role = "Carrier",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	supercarrier = {
		Name = "supercarrier",
		Type = "Naval",	
		Role = "Carrier",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	transport_ship = {
		Name = "transport_ship",
		Type = "Naval",	
		Role = "Transport",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	}
}
-- ##############################
-- ##  Ships End

local AirUnits = {
	Timestamp = {								-- Timestamp, how actual is the list
		Score = 50,
		Day = 0,
		Month = 0,
		Year = 0
	},
-- ##  Air Starts
-- ##############################
	awacs_air_plane = {						-- Unit name
		Name = "awacs_air_plane",			-- Unit name for further use in code(Unit name as in units folder with " around)
		Type = "Air",						-- To wich main type the unit belongs
		Role = "Support",					-- Role of the unit in the game(Fighter, Bomber, Helo, Naval)
		Tech = nil,							-- Is technology available(or do we need license)
		MoneyCost = 0,						-- The actual unit cost in money
		ManpowerCost = 0,					-- The actual unit cost in manpower
		TheatreNeed = 0,					-- The Actual amount of these units requested by theatre ai
		ActCountAll = 0,					-- The Actual amount of these units in total
		ActCountMap = 0,					-- The Actual amount of these units on the map
		ActCountPool = 0,					-- The Actual amount of these units in the unit pool
		ActCountProduction = 0				-- The Actual amount of these units in production
	},
	bomber_antisub = {
		Name = "bomber_antisub",
		Type = "Air",
		Role = "Naval",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	bomber_maritime = {
		Name = "bomber_maritime",
		Type = "Air",
		Role = "Naval",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	bomber_strategic = {
		Name = "bomber_strategic",
		Type = "Strat",
		Role = "Bomber",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	bomber_strike = {
		Name = "bomber_strike",
		Type = "Tac",
		Role = "Bomber",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	cag_attack = {
		Name = "cag_attack",
		Type = "Air",
		Role = "CAG",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	cag_fighter = {
		Name = "cag_fighter",
		Type = "Air",
		Role = "CAG",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	cag_mltr = {
		Name = "cag_mltr",
		Type = "Air",
		Role = "CAG",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	cag_vtol = {
		Name = "cag_vtol",
		Type = "Air",
		Role = "CAG",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	cas = {
		Name = "cas",
		Type = "Air",
		Role = "CAS",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	fighter = {
		Name = "fighter",
		Type = "Air",
		Role = "Fighter",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	helo_cas = {
		Name = "helo_cas",
		Type = "Helo",
		Role = "CAS",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	helo_gunship = {
		Name = "helo_gunship",
		Type = "Helo",
		Role = "CAS",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	helo_maritime = {
		Name = "helo_maritime",
		Type = "Helo",
		Role = "Naval",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	multi_role = {
		Name = "multi_role",
		Type = "Air",
		Role = "Fighter",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	recon_plane = {
		Name = "recon_plane",
		Type = "Air",
		Role = "Support",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	},
	transport_plane = {
		Name = "transport_plane",
		Type = "Air",
		Role = "Transport",
		Tech = nil,
		MoneyCost = 0,
		ManpowerCost = 0,
		TheatreNeed = 0,
		ActCountAll = 0,
		ActCountMap = 0,
		ActCountPool = 0,
		ActCountProduction = 0
	}
}
-- ##############################
-- ##  Air Ends

	--Set Timestamp
	LandUnits.Timestamp.Day = AllDays
	SeaUnits.Timestamp.Day = AllDays
	AirUnits.Timestamp.Day = AllDays

-- Start Tables for later build ratio calculations
local TotalCountLand = {
		CountAllInf = 0,									-- All Inf(Std/Mot)
		CountAllCav = 0,									-- All Cav(Std/Air)
		CountAllMech = 0,									-- All Mech(Light/Hvy)
		CountAllArmor = 0,									-- All Armor(Std/Hvy)
		CountAllMobile = 0,								-- All Mobile(Cav/Mech/Arm)
		CountAllSpecial = 0,								-- All Special(Bergs/Mar)
		CountAllReg = 0,								-- All Regular Units
		CountAllAA = 0,										-- All AntiAir(Std/SP)
		CountAllAT = 0,										-- All AntiTank(Std/SP)
		CountAllStdArt = 0,									-- All Art(Std/SP)
		CountAllRakArt = 0,									-- All RakArt(Std/SP)
		CountAllArt = 0,									-- All Art(Std/SP - Std/Rak)
		CountAllEng = 0,									-- All Eng(Std/Arm)
		CountAllSpec = 0,									-- All Special Support(all_terrain_vehicles..)
		CountAllSuppStd = 0,							-- All Supp(Std)
		CountAllSuppMob = 0,							-- All Supp(SP)
		CountAllSupp = 0,							-- All Support Units
		CountAllOther = 0,						-- All other not defined Land units
		CountAllLand = 0,						-- All Land Units
		CountAllProduction = 0,
		CountAllPool = 0,
		CountAllMap = 0,
		NeedAllInf = 0,									-- All Inf(Std/Mot)
		NeedAllCav = 0,									-- All Cav(Std/Air)
		NeedAllMech = 0,									-- All Mech(Light/Hvy)
		NeedAllArmor = 0,									-- All Armor(Std/Hvy)
		NeedAllMobile = 0,								-- All Mobile(Cav/Mech/Arm)
		NeedAllSpecial = 0,								-- All Special(Bergs/Mar)
		NeedAllReg = 0,								-- All Regular Units
		NeedAllAA = 0,										-- All AntiAir(Std/SP)
		NeedAllAT = 0,										-- All AntiTank(Std/SP)
		NeedAllStdArt = 0,									-- All Art(Std/SP)
		NeedAllRakArt = 0,									-- All RakArt(Std/SP)
		NeedAllArt = 0,									-- All Art(Std/SP - Std/Rak)
		NeedAllEng = 0,									-- All Eng(Std/Arm)
		NeedAllSpec = 0,									-- All Special Support(all_terrain_vehicles..)
		NeedAllSuppStd = 0,							-- All Supp(Std)
		NeedAllSuppMob = 0,							-- All Supp(SP)
		NeedAllSupp = 0,							-- All Support Units
		NeedAllOther = 0,						-- All other not defined Land units
		NeedAllLand = 0,						-- All Land Units
		NeedAllProduction = 0,
		NeedAllPool = 0,
		NeedAllMap = 0
	}
local TotalCountSea = {
		CountAllTransportShip = 0,							-- All Transportship
		CountAllSubmarine = 0,								-- All Submarines
		CountAllEscort = 0,									-- All Escort
		CountAllConvoy = 0,								-- Escort + Tranport
		CountAllCoastDefense = 0,							-- All Coast Defense(MTB)
		CountAllCruiser = 0,								-- All Cruiser Ships
		CountAllBattle = 0,								-- All Big surface Ships
		CountAllSAG = 0,								-- All surface Ships
		CountAllCarrier = 0,								-- All Carrier
		CountAllCTF = 0,								-- All Carrier + CAG
		CountAllOther = 0,						-- All other not defined Sea units
		CountAllSea = 0,							-- All Ships
		CountAllProduction = 0,
		CountAllPool = 0,
		CountAllMap = 0,
		NeedAllTransportShip = 0,							-- All Transportship
		NeedAllSubmarine = 0,								-- All Submarines
		NeedAllEscort = 0,									-- All Escort
		NeedAllConvoy = 0,								-- Escort + Tranport
		NeedAllCoastDefense = 0,							-- All Coast Defense(MTB)
		NeedAllCruiser = 0,								-- All Cruiser Ships
		NeedAllBattle = 0,								-- All Big surface Ships
		NeedAllSAG = 0,								-- All surface Ships
		NeedAllCarrier = 0,								-- All Carrier
		NeedAllCTF = 0,								-- All Carrier + CAG
		NeedAllOther = 0,						-- All other not defined Sea units
		NeedAllSea = 0,							-- All Ships
		NeedAllProduction = 0,
		NeedAllPool = 0,
		NeedAllMap = 0
	}
local TotalCountAir = {
		CountAllFighter = 0,							-- All Fighter
		CountAllBomber = 0,								-- All Bomber
		CountAllHeloCAS = 0,							-- All CAS Helicopter
		CountAllCAS = 0,								-- All CAS planes
		CountAllGround = 0,							-- All Ground Attack
		CountAllCAG = 0,								-- All CAG
		CountAllHeloNaval = 0,							-- All Helo Naval
		CountAllNaval = 0,								-- All Naval planes
		CountAllMaritime = 0,						-- All maritime planes
		CountAllSupport = 0,							-- All support planes(Recon/AWACS)
		CountAllTransport = 0,							-- All Transport planes
		CountAllHelo = 0,						-- All Helos
		CountAllPlanes = 0,						-- All Planes
		CountAllOther = 0,					-- All other Air units
		CountAllAir = 0,						-- All Air
		CountAllProduction = 0,
		CountAllPool = 0,
		CountAllMap = 0,
		NeedAllFighter = 0,							-- All Fighter
		NeedAllBomber = 0,								-- All Bomber
		NeedAllHeloCAS = 0,							-- All CAS Helicopter
		NeedAllCAS = 0,								-- All CAS planes
		NeedAllGround = 0,							-- All Ground Attack
		NeedAllCAG = 0,								-- All CAG
		NeedAllHeloNaval = 0,							-- All Helo Naval
		NeedAllNaval = 0,								-- All Naval planes
		NeedAllMaritime = 0,						-- All maritime planes
		NeedAllSupport = 0,							-- All support planes(Recon/AWACS)
		NeedAllTransport = 0,							-- All Transport planes
		NeedAllHelo = 0,						-- All Helos
		NeedAllPlanes = 0,						-- All Planes
		NeedAllOther = 0,					-- All other Air units
		NeedAllAir = 0,						-- All Air
		NeedAllProduction = 0,
		NeedAllPool = 0,
		NeedAllMap = 0
	}
-- End Tables for later build ratio calculations


-- ##############################
-- ## Units pre-setup table end

-- ## Start counting the units
-- ##############################
--SeaAvail = false
--AirAvail = false
	for k, v in pairs(LandUnits) do				-- Query all the Land units in the land units table
		if k ~= ("Timestamp") then				-- Dont check the values in the Timesptamp section, just units please..
			v.ActCountProduction = ActCountry:GetProductionSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
			v.ActCountPool = ActCountry:GetPooledSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
			v.ActCountMap = ActCountry:GetDeployedSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
			v.ActCountAll = (v.ActCountProduction + v.ActCountMap) + v.ActCountPool
			v.Tech = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit(v.Name))
			local UnitType = CSubUnitDataBase.GetSubUnit(v.Name)
			v.MoneyCost = ActCountry:GetBuildCostIC( UnitType, 1, bBuildReserve):Get()
			v.ManpowerCost = UnitType:GetBuildCostMP():Get()			
			v.TheatreNeed = ActCountry:GetSubUnitBuild(CSubUnitDataBase.GetSubUnit(k):GetIndex())
			TotalCountLand.CountAllProduction = TotalCountLand.CountAllProduction + v.ActCountProduction
			TotalCountLand.CountAllPool = TotalCountLand.CountAllPool + v.ActCountPool
			TotalCountLand.CountAllMap = TotalCountLand.CountAllMap + v.ActCountMap
		-- Counting 
		-- First some types wich are not checked in the roles below
			if v.Type == "LandSpec" then			-- Special (Bergs/Marine)
				TotalCountLand.CountAllSpecial = TotalCountLand.CountAllSpecial + v.ActCountAll
				TotalCountLand.NeedAllSpecial = TotalCountLand.NeedAllSpecial + v.TheatreNeed
		-- Then check for roles
			elseif v.Role == "Inf" then
				TotalCountLand.CountAllInf = TotalCountLand.CountAllInf + v.ActCountAll
				TotalCountLand.NeedAllInf = TotalCountLand.NeedAllInf + v.TheatreNeed
			elseif v.Role == "Cavalry" then
				TotalCountLand.CountAllCav = TotalCountLand.CountAllCav + v.ActCountAll
				TotalCountLand.NeedAllCav = TotalCountLand.NeedAllCav + v.TheatreNeed
			elseif v.Role == "Mech" then
				TotalCountLand.CountAllMech = TotalCountLand.CountAllMech + v.ActCountAll
				TotalCountLand.NeedAllMech = TotalCountLand.NeedAllMech + v.TheatreNeed
			elseif v.Role == "Armor" then
				TotalCountLand.CountAllArmor = TotalCountLand.CountAllArmor + v.ActCountAll
				TotalCountLand.NeedAllArmor = TotalCountLand.NeedAllArmor + v.TheatreNeed
		-- Support has additional check
			elseif v.Role == "AA" then
				TotalCountLand.CountAllAA = TotalCountLand.CountAllAA + v.ActCountAll
				TotalCountLand.NeedAllAA = TotalCountLand.NeedAllAA + v.TheatreNeed
				if v.Type == "LandSuppStd" then		-- Std Support
					TotalCountLand.CountAllSuppStd = TotalCountLand.CountAllSuppStd + v.ActCountAll
					TotalCountLand.NeedAllSuppStd = TotalCountLand.NeedAllSuppStd + v.TheatreNeed
				else								-- Otherwise Mobile
					TotalCountLand.CountAllSuppMob = TotalCountLand.CountAllSuppMob + v.ActCountAll
					TotalCountLand.NeedAllSuppMob = TotalCountLand.NeedAllSuppMob + v.TheatreNeed
				end
			elseif v.Role == "AT" then
				TotalCountLand.CountAllAT = TotalCountLand.CountAllAT + v.ActCountAll
				TotalCountLand.NeedAllAT = TotalCountLand.NeedAllAT + v.TheatreNeed
				if v.Type == "LandSuppStd" then
					TotalCountLand.CountAllSuppStd = TotalCountLand.CountAllSuppStd + v.ActCountAll
					TotalCountLand.NeedAllSuppStd = TotalCountLand.NeedAllSuppStd + v.TheatreNeed
				else
					TotalCountLand.CountAllSuppMob = TotalCountLand.CountAllSuppMob + v.ActCountAll
					TotalCountLand.NeedAllSuppMob = TotalCountLand.NeedAllInf + v.TheatreNeed
				end
			elseif v.Role == "Art" then
				TotalCountLand.CountAllStdArt = TotalCountLand.CountAllStdArt + v.ActCountAll
				TotalCountLand.NeedAllStdArt = TotalCountLand.NeedAllStdArt + v.TheatreNeed
				if v.Type == "LandSuppStd" then
					TotalCountLand.CountAllSuppStd = TotalCountLand.CountAllSuppStd + v.ActCountAll
					TotalCountLand.NeedAllSuppStd = TotalCountLand.NeedAllSuppStd + v.TheatreNeed
				else
					TotalCountLand.CountAllSuppMob = TotalCountLand.CountAllSuppMob + v.ActCountAll
					TotalCountLand.NeedAllSuppMob = TotalCountLand.NeedAllInf + v.TheatreNeed
				end
			elseif v.Role == "RakArt" then
				TotalCountLand.CountAllRakArt = TotalCountLand.CountAllRakArt + v.ActCountAll
				TotalCountLand.NeedAllRakArt = TotalCountLand.NeedAllRakArt + v.TheatreNeed
				if v.Type == "LandSuppStd" then
					TotalCountLand.CountAllSuppStd = TotalCountLand.CountAllSuppStd + v.ActCountAll
					TotalCountLand.NeedAllSuppStd = TotalCountLand.NeedAllSuppStd + v.TheatreNeed
				else
					TotalCountLand.CountAllSuppMob = TotalCountLand.CountAllSuppMob + v.ActCountAll
					TotalCountLand.NeedAllSuppMob = TotalCountLand.NeedAllSuppMob + v.TheatreNeed
				end
			elseif v.Role == "SpecialSupport" then
				TotalCountLand.CountAllSpec = TotalCountLand.CountAllSpec + v.ActCountAll
				TotalCountLand.NeedAllSpec = TotalCountLand.NeedAllSpec + v.TheatreNeed
				if v.Type == "LandSuppStd" then		-- Bergs Mule Support, Bergs Art etc..
					TotalCountLand.CountAllSuppStd = TotalCountLand.CountAllSuppStd + v.ActCountAll
					TotalCountLand.NeedAllSuppStd = TotalCountLand.NeedAllSuppStd + v.TheatreNeed
				else
					TotalCountLand.CountAllSuppMob = TotalCountLand.CountAllSuppMob + v.ActCountAll
					TotalCountLand.NeedAllSuppMob = TotalCountLand.NeedAllSuppMob + v.TheatreNeed
				end
			else									-- All else will be Land anyway..
				TotalCountLand.CountAllOther = TotalCountLand.CountAllOther + v.ActCountAll
				TotalCountLand.NeedAllOther = TotalCountLand.NeedAllOther + v.TheatreNeed
			end
			--if (ActTagTbl == "SOV") then
			--Utils.LUA_DEBUGOUT("--1--UNIT-LAND---v.Name-: " .. tostring(ActTag) .. "-" ..  tostring(v.Name))
			--Utils.LUA_DEBUGOUT("--1--UNIT-LAND---v.Tech-: " .. tostring(ActTag) .. "-" ..  tostring(v.Tech))
			--Utils.LUA_DEBUGOUT("--1--UNIT-LAND---v.ActCountMap-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountMap))
			--Utils.LUA_DEBUGOUT("--1--UNIT-LAND---v.ActCountPool-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountPool))
			--Utils.LUA_DEBUGOUT("--1--UNIT-LAND---v.ActCountProduction-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountProduction))
			--Utils.LUA_DEBUGOUT("--1--UNIT-LAND---v.ActCountAll-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountAll))
			--end
		end
	end
	if SeaAvail then
		for k, v in pairs(SeaUnits) do					-- Query all the Sea units in the sea units table
			if k ~= ("Timestamp") then
				v.ActCountProduction = ActCountry:GetProductionSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				v.ActCountMap = ActCountry:GetDeployedSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				v.ActCountPool = ActCountry:GetPooledSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				v.ActCountAll = (v.ActCountProduction + v.ActCountMap) + v.ActCountPool
				v.Tech = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit(v.Name))
				local UnitType = CSubUnitDataBase.GetSubUnit(v.Name)
				v.MoneyCost = ActCountry:GetBuildCostIC( UnitType, 1, bBuildReserve):Get()
				v.ManpowerCost = UnitType:GetBuildCostMP():Get()		
				v.TheatreNeed = ActCountry:GetSubUnitBuild(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				TotalCountSea.CountAllProduction = TotalCountLand.CountAllProduction + v.ActCountProduction
				TotalCountSea.CountAllPool = TotalCountLand.CountAllPool + v.ActCountPool
				TotalCountSea.CountAllMap = TotalCountLand.CountAllMap + v.ActCountMap
		-- Counting 
		-- Check for roles
			if v.Role == "Submarine" then
				TotalCountSea.CountAllSubmarine = TotalCountSea.CountAllSubmarine + v.ActCountAll
				TotalCountSea.NeedAllSubmarine = TotalCountSea.NeedAllSubmarine + v.TheatreNeed
			elseif v.Role == "Coast" then
				TotalCountSea.CountAllCoastDefense = TotalCountSea.CountAllCoastDefense + v.ActCountAll
				TotalCountSea.NeedAllCoastDefense = TotalCountSea.NeedAllCoastDefense + v.TheatreNeed
			elseif v.Role == "Escort" then
				TotalCountSea.CountAllEscort = TotalCountSea.CountAllEscort + v.ActCountAll
				TotalCountSea.NeedAllEscort = TotalCountSea.NeedAllEscort + v.TheatreNeed
			elseif v.Role == "Cruiser" then
				TotalCountSea.CountAllCruiser = TotalCountSea.CountAllCruiser + v.ActCountAll
				TotalCountSea.NeedAllCruiser = TotalCountSea.NeedAllCruiser + v.TheatreNeed
			elseif v.Role == "Battle" then
				TotalCountSea.CountAllBattle = TotalCountSea.CountAllBattle + v.ActCountAll
				TotalCountSea.NeedAllBattle = TotalCountSea.NeedAllBattle + v.TheatreNeed
			elseif v.Role == "Carrier" then
				TotalCountSea.CountAllCarrier = TotalCountSea.CountAllCarrier + v.ActCountAll
				TotalCountSea.NeedAllCarrier = TotalCountSea.NeedAllCarrier + v.TheatreNeed
			elseif v.Role == "Transport" then
				TotalCountSea.CountAllTransportShip = TotalCountSea.CountAllTransportShip + v.ActCountAll
				TotalCountSea.NeedAllTransportShip = TotalCountSea.NeedAllTransportShip + v.TheatreNeed
			else									-- All else wich are not defined
				TotalCountSea.CountAllOther = TotalCountSea.CountAllOther + v.ActCountAll
				TotalCountSea.NeedAllOther = TotalCountSea.NeedAllOther + v.TheatreNeed
			end
--Utils.LUA_DEBUGOUT("--1-----UNIT-SEA-: " .. tostring(ActTag) .. "-" ..  tostring(v.Name))
--Utils.LUA_DEBUGOUT("--1-----UNIT-SEA-: " .. tostring(ActTag) .. "-" ..  tostring(v.Tech))
--Utils.LUA_DEBUGOUT("--1-----UNIT-SEA-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountMap))
--Utils.LUA_DEBUGOUT("--1-----UNIT-SEA-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountPool))
--Utils.LUA_DEBUGOUT("--1-----UNIT-SEA-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountProduction))
--Utils.LUA_DEBUGOUT("--1-----UNIT-SEA-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountAll))
			end
		end
	end
	if AirAvail then
		for k, v in pairs(AirUnits) do					-- Query all the Air units in the air units table
			if k ~= ("Timestamp") then
				v.ActCountProduction = ActCountry:GetProductionSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				v.ActCountMap = ActCountry:GetDeployedSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				v.ActCountPool = ActCountry:GetPooledSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				v.ActCountAll = (v.ActCountProduction + v.ActCountMap) + v.ActCountPool
				v.Tech = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit(v.Name))
				local UnitType = CSubUnitDataBase.GetSubUnit(v.Name)
				v.MoneyCost = ActCountry:GetBuildCostIC( UnitType, 1, bBuildReserve):Get()
				v.ManpowerCost = UnitType:GetBuildCostMP():Get()		
				v.TheatreNeed = ActCountry:GetSubUnitBuild(CSubUnitDataBase.GetSubUnit(k):GetIndex())
				TotalCountAir.CountAllProduction = TotalCountLand.CountAllProduction + v.ActCountProduction
				TotalCountAir.CountAllPool = TotalCountLand.CountAllPool + v.ActCountPool
				TotalCountAir.CountAllMap = TotalCountLand.CountAllMap + v.ActCountMap
		-- Counting 
		-- First some types wich are not checked in the roles below
			if (v.Type == "Helo" and v.Role == "CAS") then											-- CAS Helo
				TotalCountAir.CountAllHeloCAS = TotalCountAir.CountAllHeloCAS + v.ActCountAll
				TotalCountAir.NeedAllHeloCAS = TotalCountAir.NeedAllHeloCAS + v.TheatreNeed
			elseif (v.Type == "Helo" and v.Role == "Naval") then									-- Naval Helo
				TotalCountAir.CountAllHeloNaval = TotalCountAir.CountAllHeloNaval + v.ActCountAll
				TotalCountAir.NeedAllHeloNaval= TotalCountAir.NeedAllHeloNaval + v.TheatreNeed
			elseif (v.Type == "Air" and v.Role == "Naval") then										-- Naval Planes
				TotalCountAir.CountAllNaval = TotalCountAir.CountAllNaval + v.ActCountAll
				TotalCountAir.NeedAllNaval = TotalCountAir.NeedAllNaval + v.TheatreNeed
		-- Then check for roles
			elseif v.Role == "Fighter" then
				TotalCountAir.CountAllFighter = TotalCountAir.CountAllFighter + v.ActCountAll
				TotalCountAir.NeedAllFighter = TotalCountAir.NeedAllFighter + v.TheatreNeed
			elseif v.Role == "Bomber" then
				TotalCountAir.CountAllBomber = TotalCountAir.CountAllBomber + v.ActCountAll
				TotalCountAir.NeedAllBomber = TotalCountAir.NeedAllBomber + v.TheatreNeed
			elseif v.Role == "CAS" then
				TotalCountAir.CountAllCAS = TotalCountAir.CountAllCAS + v.ActCountAll
				TotalCountAir.NeedAllCAS= TotalCountAir.NeedAllCAS + v.TheatreNeed
			elseif v.Role == "Support" then
				TotalCountAir.CountAllSupport = TotalCountAir.CountAllSupport + v.ActCountAll
				TotalCountAir.NeedAllSupport = TotalCountAir.NeedAllSupport + v.TheatreNeed
			elseif v.Role == "CAG" then
				TotalCountAir.CountAllCAG = TotalCountAir.CountAllCAG + v.ActCountAll
				TotalCountAir.NeedAllCAG = TotalCountAir.NeedAllCAG + v.TheatreNeed
			elseif v.Role == "Transport" then
				TotalCountAir.CountAllTransport = TotalCountAir.CountAllTransport + v.ActCountAll
				TotalCountAir.NeedAllTransport = TotalCountAir.NeedAllTransport + v.TheatreNeed
			else																					-- All else will be Air somehow..
				TotalCountAir.CountAllOther = TotalCountAir.CountAllOther + v.ActCountAll
				TotalCountAir.NeedAllOther = TotalCountAir.NeedAllOther + v.TheatreNeed
			end
--Utils.LUA_DEBUGOUT("--1---------UNIT-AIR---v.Name-: " .. tostring(ActTag) .. "-" ..  tostring(v.Name))
--Utils.LUA_DEBUGOUT("--1---------UNIT-AIR---v.Tech-: " .. tostring(ActTag) .. "-" ..  tostring(v.Tech))
--Utils.LUA_DEBUGOUT("--1---------UNIT-AIR---v.ActCountMap-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountMap))
--Utils.LUA_DEBUGOUT("--1---------UNIT-AIR---v.ActCountPool-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountPool))
--Utils.LUA_DEBUGOUT("--1---------UNIT-AIR---v.ActCountProduction-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountProduction))
--Utils.LUA_DEBUGOUT("--1---------UNIT-AIR----v.ActCountAll-: " .. tostring(ActTag) .. "-" ..  tostring(v.ActCountAll))
			end
		end
	end

	-- Land
	TotalCountLand.CountAllMobile = ((TotalCountLand.CountAllCav + TotalCountLand.CountAllMech) + TotalCountLand.CountAllArmor)
	TotalCountLand.CountAllReg = ((TotalCountLand.CountAllInf + TotalCountLand.CountAllMobile) + TotalCountLand.CountAllSpecial)
	TotalCountLand.CountAllSupp = (TotalCountLand.CountAllSuppStd + TotalCountLand.CountAllSuppMob)
	TotalCountLand.CountAllLand = ((TotalCountLand.CountAllReg + TotalCountLand.CountAllSupp) + TotalCountLand.CountAllOther)
	TotalCountLand.NeedAllMobile = ((TotalCountLand.NeedAllCav + TotalCountLand.NeedAllMech) + TotalCountLand.NeedAllArmor)
	TotalCountLand.NeedAllReg = ((TotalCountLand.NeedAllInf + TotalCountLand.NeedAllMobile) + TotalCountLand.NeedAllSpecial)
	TotalCountLand.NeedAllSupp = (TotalCountLand.NeedAllSuppStd + TotalCountLand.NeedAllSuppMob)
	TotalCountLand.NeedAllLand = ((TotalCountLand.NeedAllReg + TotalCountLand.NeedAllSupp) + TotalCountLand.NeedAllOther)
--[[
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllInf: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllInf))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllCav: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllCav))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllMech: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllMech))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllArmor: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllArmor))
Utils.LUA_DEBUGOUT("--1-------UNIT-LAND-CountAllMobile: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllMobile))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllSpecial: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllSpecial))
Utils.LUA_DEBUGOUT("--1--------------------UNIT-LAND-CountAllReg: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllReg))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllAA: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllAA))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllAT: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllAT))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllStdArt: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllStdArt))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllRakArt: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllRakArt))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllArt: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllArt))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllEng: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllEng))
Utils.LUA_DEBUGOUT("--1--UNIT-LAND-CountAllSpec: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllSpec))
Utils.LUA_DEBUGOUT("--1-----UNIT-LAND-CountAllSuppStd: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllSuppStd))
Utils.LUA_DEBUGOUT("--1-----UNIT-LAND-CountAllSuppMob: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllSuppMob))
Utils.LUA_DEBUGOUT("--1---------------UNIT-LAND-CountAllSupp: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllSupp))
Utils.LUA_DEBUGOUT("--1--------------------------UNIT-LAND-CountAllLand: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountLand.CountAllLand))
]]
	-- Sea
	TotalCountSea.CountAllConvoy = (TotalCountSea.CountAllEscort + TotalCountSea.CountAllTransportShip)
	TotalCountSea.CountAllSAG = (TotalCountSea.CountAllCruiser + TotalCountSea.CountAllBattle)
	TotalCountSea.CountAllCTF = (TotalCountSea.CountAllCarrier + TotalCountAir.CountAllCAG)
	TotalCountSea.CountAllSea = ((TotalCountSea.CountAllSubmarine + TotalCountSea.CountAllConvoy) + (TotalCountSea.CountAllCoastDefense + TotalCountSea.CountAllOther) + (TotalCountSea.CountAllSAG + TotalCountSea.CountAllCTF))
	TotalCountSea.NeedAllConvoy = (TotalCountSea.NeedAllEscort + TotalCountSea.NeedAllTransportShip)
	TotalCountSea.NeedAllSAG = (TotalCountSea.NeedAllCruiser + TotalCountSea.NeedAllBattle)
	TotalCountSea.NeedAllCTF = (TotalCountSea.NeedAllCarrier + TotalCountAir.NeedAllCAG)
	TotalCountSea.NeedAllSea = ((TotalCountSea.NeedAllSubmarine + TotalCountSea.NeedAllConvoy) + (TotalCountSea.NeedAllCoastDefense + TotalCountSea.NeedAllOther) + (TotalCountSea.NeedAllSAG + TotalCountSea.NeedAllCTF))
--[[
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllSubmarine: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllSubmarine))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllCoastDefense: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllCoastDefense))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllEscort: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllEscort))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllCruiserTF: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllCruiserTF))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllBattleTF: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllBattleTF))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllSAG: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllSAG))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllCAG: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllCAG))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllCarrier: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllCarrier))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllCTF: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllCTF))
Utils.LUA_DEBUGOUT("--1--UNIT-SEA-CountAllTransportShip: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllTransportShip))
Utils.LUA_DEBUGOUT("--1--------------------UNIT-SEA-CountAllSea: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountSea.CountAllSea))
]]
	-- Air
	TotalCountAir.CountAllGround = (TotalCountAir.CountAllHeloCAS + TotalCountAir.CountAllCAS)
	TotalCountAir.CountAllMaritime = (TotalCountAir.CountAllHeloNaval + TotalCountAir.CountAllNaval)
	TotalCountAir.CountAllHelo = (TotalCountAir.CountAllHeloCAS + TotalCountAir.CountAllHeloNaval)
	TotalCountAir.CountAllPlanes = ((TotalCountAir.CountAllFighter + TotalCountAir.CountAllBomber) + (TotalCountAir.CountAllHeloNaval + TotalCountAir.CountAllCAS) + (TotalCountAir.CountAllSupport + TotalCountAir.CountAllTransport))
	TotalCountAir.CountAllAir = ((TotalCountAir.CountAllPlanes + TotalCountAir.CountAllHelo) + TotalCountAir.CountAllOther)
	TotalCountAir.NeedAllGround = (TotalCountAir.NeedAllHeloCAS + TotalCountAir.NeedAllCAS)
	TotalCountAir.NeedAllMaritime = (TotalCountAir.NeedAllHeloNaval + TotalCountAir.NeedAllNaval)
	TotalCountAir.NeedAllHelo = (TotalCountAir.NeedAllHeloCAS + TotalCountAir.NeedAllHeloNaval)
	TotalCountAir.NeedAllPlanes = ((TotalCountAir.NeedAllFighter + TotalCountAir.NeedAllBomber) + (TotalCountAir.NeedAllHeloNaval + TotalCountAir.NeedAllCAS) + (TotalCountAir.NeedAllSupport + TotalCountAir.NeedAllTransport))
	TotalCountAir.NeedAllAir = ((TotalCountAir.NeedAllPlanes + TotalCountAir.NeedAllHelo) + TotalCountAir.NeedAllOther)
--[[		
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllFighter: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllFighter))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllBomber: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllBomber))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllCAS: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllCAS))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllHeloCAS: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllHeloCAS))
Utils.LUA_DEBUGOUT("--1--------UNIT-AIR-CountAllGround: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllGround))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllSupport: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllSupport))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllTransport: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllTransport))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllNaval: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllNaval))
Utils.LUA_DEBUGOUT("--1--UNIT-AIR-CountAllHeloNaval: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllHeloNaval))
Utils.LUA_DEBUGOUT("--1--------UNIT-AIR-CountAllMaritime: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllMaritime))
Utils.LUA_DEBUGOUT("--1--------UNIT-AIR-CountAllOther: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllOther))
Utils.LUA_DEBUGOUT("--1--------------------UNIT-AIR-CountAllPlanes: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllPlanes))
Utils.LUA_DEBUGOUT("--1--------------------UNIT-AIR-CountAllHelo: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllHelo))
Utils.LUA_DEBUGOUT("--1--------------------UNIT-AIR-CountAllAir: " .. tostring(ActTag) .. "-" ..  tostring(TotalCountAir.CountAllAir))
]]

	local TotalCountAllUnits = ((TotalCountLand.CountAllLand + TotalCountSea.CountAllSea) + TotalCountAir.CountAllAir)
	local TotalNeedAllUnits = ((TotalCountLand.NeedAllLand + TotalCountSea.NeedAllSea) + TotalCountAir.NeedAllAir)
-- ##############################
-- ## End counting the units

	Grand_Units_Table["LandUnits-" .. ActTagTbl] = LandUnits
	Grand_Units_Table["SeaUnits-" .. ActTagTbl] = SeaUnits
	Grand_Units_Table["AirUnits-" .. ActTagTbl] = AirUnits
	Grand_Units_Table["TotalCountLand-" .. ActTagTbl] = TotalCountLand
	Grand_Units_Table["TotalCountSea-" .. ActTagTbl] = TotalCountSea
	Grand_Units_Table["TotalCountAir-" .. ActTagTbl] = TotalCountAir
	Grand_Units_Table["TotalCountAllUnits-" .. ActTagTbl] = TotalCountAllUnits
	Grand_Units_Table["TotalNeedAllUnits-" .. ActTagTbl] = TotalNeedAllUnits



end

-- Helper functions below
-- Function to decide if another Country's capital is a core province of us.
function HasCapitalCoreFunction(ActTagTbl, TargetCountryTag)

	local ActTagTbl = ActTagTbl
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local TargetCountryTag = TargetCountryTag	--Grand_Country_Table["Country-" .. TargetCountryTagTbl].ActTag
	local TargetCountryTagTbl = tostring(TargetCountryTag)
	local TargetCountry = TargetCountryTag:GetCountry() --Grand_Country_Table["Country-" .. TargetCountryTagTbl].ActCountry
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local HasCapitalCore = false
	--Table has Capital Prov ID.. We need the prov.. Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId
	local CapitalProvId = ActCountry:GetActingCapitalLocation()--CapitalProvId:GetProvince():GetProvinceID()
--Utils.LUA_DEBUGOUT(" Rucksack - Province Distance - Country -1- " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl))
	local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]
	local WarStat = WarTable.OverallWarStat
	local Warscore = WarStat.MaxWarscore

	local SortedProvListCore = { }
	local SortedProvListExtra = { }
	local Province = nil
	local ProvinceValue = 0
	local WarValue = 0
	local CoreProvincesValue = 0
	local ExtraProvincesValue = 0
	local ProvinceID = 0
	local ProvinceDistance = 0
	local ProvinceRegionName = nil
	local TargetCountryValue = TargetCountry:GetTotalWarWorth()
	
	for CoreProvinceID in ActCountry:GetCoreProvinces() do
		Province = CCurrentGameState.GetProvince(CoreProvinceID)
		if (Province:GetOwner() == TargetCountryTag) then -- or (Province:GetController() == TargetCountryTag) then
			if (CoreProvinceID == TargetCountry:GetCapitalLocation()) then
				HasCapitalCore = true
			end
		end
	end
	
	return HasCapitalCore
	
end

-- Function to decide if another Country has a core province of us.
function HasAnyCores(ActTagTbl, TargetCountryTag)

	local ActTagTbl = ActTagTbl
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local TargetCountryTag = TargetCountryTag	--Grand_Country_Table["Country-" .. TargetCountryTagTbl].ActTag
	local TargetCountryTagTbl = tostring(TargetCountryTag)
	local TargetCountry = TargetCountryTag:GetCountry() --Grand_Country_Table["Country-" .. TargetCountryTagTbl].ActCountry
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local HasCore = false
	--Table has Capital Prov ID.. We need the prov.. Grand_Country_Table["Country-" .. ActTagTbl].CapitalProvId
	local CapitalProvId = ActCountry:GetActingCapitalLocation()--CapitalProvId:GetProvince():GetProvinceID()
--Utils.LUA_DEBUGOUT(" Rucksack - Province Distance - Country -1- " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl))
	local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]
	local WarStat = WarTable.OverallWarStat
	local Warscore = WarStat.MaxWarscore

	local SortedProvListCore = { }
	local SortedProvListExtra = { }
	local Province = nil
	local ProvinceValue = 0
	local WarValue = 0
	local CoreProvincesValue = 0
	local ExtraProvincesValue = 0
	local ProvinceID = 0
	local ProvinceDistance = 0
	local ProvinceRegionName = nil
	local TargetCountryValue = TargetCountry:GetTotalWarWorth()

--[[
War leader is strongest nation(most military might)
LuaDef needs entry for when the war leader switch to another country.(percantage value)
-> Another nation is twice as strong as the country that started the war.

War Leader will partition the spoils of war.
WarLeader is faction leader or in alliances the country that starts the war.
(most military might)
If you have cores as minor ally you'll get them in peace event.

Need these for handling core provinces.
class_< CProvince >("CProvince") ...
             .def( "SetController", &CProvince::SetController )
             .def( "SetOwner", &CProvince::SetOwner )
             .def( "SetCore", &CProvince::SetCore )
             .def( "ReSetCore", &CProvince::ReSetCore )    #Maybe remove core could be done with SetCore on a prov we have already a core?

PeaceAction work in the way that country leader is making peace with all countries in the alliance/faction.
Cores get to countries that have cores of that alliance/faction.

Provinces check
Cores
Near/Away Rich/Wanted(Port)
Score

War Goals:
1) Take cores
2) remove their core on any province we own
3) take regions that we have some provinces in


]]

--Utils.LUA_DEBUGOUT(" Rucksack - TargetCountryValue - Our Country " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl) .. " TargetCountryValue: " .. tostring(TargetCountryValue))

	-- Look for core provinces
	local CoreProvincesCounter = 0
	for CoreProvinceID in ActCountry:GetCoreProvinces() do
		Province = CCurrentGameState.GetProvince(CoreProvinceID)
		if (Province:GetOwner() == TargetCountryTag) then -- or (Province:GetController() == TargetCountryTag) then
			HasCore = true
			ProvinceDistance = CapitalProvId:GetDistance(CoreProvinceID)
			ProvinceRegionName = Province:GetRegion():GetName()
			ProvinceValue = ((Province:GetWarValue() / TargetCountryValue) * 100)
			CoreProvincesValue = CoreProvincesValue + ProvinceValue
			CoreProvincesCounter = CoreProvincesCounter + 1
			WarValue = WarValue + ProvinceValue
			table.insert(SortedProvListCore, { ProvinceDistance, ProvinceRegionName, ProvinceValue, CoreProvinceID })
		end
	end
	table.sort(SortedProvListCore, comps)
--Utils.LUA_DEBUGOUT(" Rucksack - CoreProvinces Check - Our Country " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl) .. " CoreProvincesCounter: " .. tostring(CoreProvincesCounter) .. " CoreProvincesValue: " .. tostring(CoreProvincesValue))

	-- check for provinces/regions to grap from enemy
	local TotalProvincesCounter = 0
	for OwnedProvinceID in TargetCountry:GetOwnedProvinces() do
		Province = CCurrentGameState.GetProvince(OwnedProvinceID)
		ProvinceDistance = CapitalProvId:GetDistance(OwnedProvinceID)
		ProvinceRegionName = Province:GetRegion():GetName()
		ProvinceValue = ((Province:GetWarValue() / TargetCountryValue) * 100)
		ExtraProvincesValue = ExtraProvincesValue + ProvinceValue
		TotalProvincesCounter = TotalProvincesCounter + 1
		WarValue = WarValue + ProvinceValue
		table.insert(SortedProvListExtra, { ProvinceDistance, ProvinceRegionName, ProvinceValue, OwnedProvinceID })
	end
	table.sort(SortedProvListExtra, comps)
--Utils.LUA_DEBUGOUT(" Rucksack - OwnedProvince Check - Our Country " .. tostring(ActTagTbl) .. " Other Country: " .. tostring(TargetCountryTagTbl) .. " TotalProvincesCounter: " .. tostring(TotalProvincesCounter))

	local TotalActualProvincesCounter = 0
	for ControlledProvinceID in TargetCountry:GetOwnedProvinces() do
		TotalActualProvincesCounter = TotalActualProvincesCounter + 1
	end
					
	WarTable["EnemyCountry-" .. TargetCountryTagTbl].CoreProvincesCounter = CoreProvincesCounter
	WarTable["EnemyCountry-" .. TargetCountryTagTbl].TotalProvincesCounter = TotalProvincesCounter
	WarTable["EnemyCountry-" .. TargetCountryTagTbl].TotalActualProvincesCounter = TotalActualProvincesCounter
	WarTable["EnemyCountry-" .. TargetCountryTagTbl].CoreProvincesValue = CoreProvincesValue
	WarTable["EnemyCountry-" .. TargetCountryTagTbl].ExtraProvincesValue = ExtraProvincesValue
	WarTable["EnemyCountry-" .. TargetCountryTagTbl].OurCoreProvinces = SortedProvListCore
	WarTable["EnemyCountry-" .. TargetCountryTagTbl].ExtraPossibleProvinces = SortedProvListExtra

	return HasCore, WarValue, TotalActualProvincesCounter

end

function PeaceWanted(ActTagTbl)

	local ActMinister = Grand_Country_Table["Country-" .. ActTagTbl].Minister
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	--local ActTag = ActMinister:GetCountryTag()
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local OurSurrenderLevel = Grand_Country_Table["Country-" .. ActTagTbl].OurSurrenderLevel
	local ActDesperation = Grand_Country_Table["Country-" .. ActTagTbl].ActDesperation


	-- Do we want peace?
	local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]

	-- Set current country scores and willingness for peace(winning or loosing)
	if not(next(WarTable) == nil) then
		local WarStat = WarTable.OverallWarStat
		WarStat.PeaceWanted = 0
		local PeaceCountry = nil
		for k, v in pairs(WarTable) do
			if (k ~= ("OverallWarStat")) and (k ~= ("Timestamp")) and (v.WarStart ~= nil) then
				local EnemyTag = v.Enemy
				local WarStart = v.WarStart
				local WarEnd = v.WarEnd
				local Warscore = v.ActWarscore
				local MaxWarscore = v.MaxWarscore
				local MinWarscore = v.LowestWarscore
				local OldWarscore = v.OldWarscore
				local VictoryScore = 0
				local ActWar = v.ActWar
				local WarValue = 0
				local TotalActualProvincesCounter = 0
				local NoDemocracy = nil
				if v.ActWar ~= nil then
					ActWar = ActCountry:GetRelation(EnemyTag):HasWar()
					v.ActWar = ActWar
				end
				
				
				if ActWar then

				-- Set current Wargoal(Provinces or more..)
				-- Need entry, new list call subfunction for cores etc amount of cores and province list price of cores..
					
--[[
War Goals:
1) Take cores
2) remove their core on any province we own
3) take regions that we have some provinces in
4) NOT RECOGNIZED COUNTRY = ANNEX
5) NUKES USED = VICTORY OR VALHALLA
6) if war started by means of UN - goal is demilitarize
Evaluate:
1- FACTION LEADER) Puppet - 80%
1- EVIL) Annex - 100%
1- GOOD) Puppet - 80%
	we try to get these if none of the above aplies
2- FACTION LEADER) Demilitarize
2 - EVIL) Take new regions
2 - GOOD) Demilitarize
	3- FACTION LEADER)  Humiliate and Mil Access
3 - EVIL) Demilitarize / Humiliate and Mil Access
3 - 
]]
--Utils.LUA_DEBUGOUT("-function PeaceWanted-1--: " .. tostring(ActTag) .. " -Enemy " ..  tostring(EnemyTag) .. " -WarProgress " ..  tostring(WarStat.WarProgress) .. " -MAX-Warscore " ..  tostring(WarStat.MaxWarscore) .. " -Victory Score " ..  tostring(VictoryScore) .. " -Warscore " ..  tostring(Warscore) .. " -PeaceWanted " ..  tostring(WarStat.PeaceWanted) .. " -PeaceWanted Ctry " ..  tostring(WarStat.MaxWarscoreTag))				
					-- Check value of cores or demand of nearby provinces/region we want
					local HasCore = nil --HasAnyCores(ActTagTbl, EnemyTag)	-- expand this
					HasCore, WarValue, TotalActualProvincesCounter = HasAnyCores(ActTagTbl, EnemyTag)
					local HasCapitalCore = false
					HasCapitalCore = HasCapitalCoreFunction(ActTagTbl, EnemyTag)

					-- remove their core on any province we own
					-- Check value of Regions we have cores in
					-- if (not recognized) then VictoryScore = MaxVictoryScore end
					-- if (nukes used) then VictoryScore = MaxVictoryScore end
					-- if (UN war) then VictoryScore = 60 end --Disarment!
					
					-- Otherwise
					-- Check for Government set MaxWarscore
					if (Grand_Nation_Table["ActNation-" .. ActTagTbl].FactionLeader) then				-- Faction Leader?
						MaxVictoryScore = 84
					elseif (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (1)) or			-- Totalitarian
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (2)) or			-- Authoritarian
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (3)) or			-- Theocracy
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (4)) then 			-- Absolute Monarchy
						MaxVictoryScore = 98
						NoDemocracy = true
					elseif (Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (5)) or			-- Constitutional Monarchy
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (6)) or			-- Republic
						(Grand_Nation_Table["ActNation-" .. ActTagTbl].Government == (7)) then			-- Constitutional Republic
						MaxVictoryScore = 84
					else
						MaxVictoryScore = 29	--Humilate? What should Democracies aim for?
					end
					
					if HasCore then
						if HasCapitalCore then
							MaxVictoryScore = 100
						else
							MaxVictoryScore = WarValue
							if MaxVictoryScore > 97 then 
								MaxVictoryScore = 98 
							end
						end
					elseif NoDemocracy then
						MaxVictoryScore = WarValue
						if MaxVictoryScore > 97 then MaxVictoryScore = 98 end
					end
					
					--save max scors for later use
					WarStat.MaxVictoryScore = MaxVictoryScore

--[[					
					-- 	Else
					--		FACTION LEADER) Demilitarize
					--		EVIL) Take new regions
					--		GOOD) Demilitarize

					-- none above apply
					--		FACTION LEADER)  Humiliate and Mil Access
					-- 		EVIL) Demilitarize / Humiliate and Mil Access
					--		GOOD) Humiliate and Mil Access
]]

					local GetRandom = math.random
					local RandNr = GetRandom(100)

					-- Check for WarProgress numbers
					if WarStat.WarProgress == 1 then
						if WarStat.Loosing and RandNr > 99 then
							WarStat.PeaceWanted = 1
						end
					elseif WarStat.WarProgress == 3 or WarStat.WarProgress == 4 then
						if WarStat.Loosing and RandNr > 75 then
							WarStat.PeaceWanted = 1
						elseif RandNr > 95 then
							WarStat.PeaceWanted = 1
						end
					elseif WarStat.WarProgress == 7 then
						if WarStat.Loosing and RandNr > 75 then
							WarStat.PeaceWanted = 1
						elseif RandNr > 25 then
							WarStat.PeaceWanted = 1
						end				
					elseif WarStat.WarProgress == 2 then
						if WarStat.Static then
							WarStat.PeaceWanted = 2
						elseif RandNr > 85 then
							--WarStat.PeaceWanted = 2
						else
							WarStat.PeaceWanted = 2
						end
					elseif WarStat.WarProgress == 5 or WarStat.WarProgress == 6 then
						if WarStat.Static then
							WarStat.PeaceWanted = 2
						elseif WarStat.Winning and RandNr > 55 then
							--WarStat.PeaceWanted = 2
						elseif WarStat.Loosing then
							WarStat.PeaceWanted = 2
						elseif RandNr > 25 then
							WarStat.PeaceWanted = 2
						end
					elseif WarStat.WarProgress == 8 or WarStat.WarProgress == 9 then
						if WarStat.Winning and RandNr > 75 then
							--WarStat.PeaceWanted = 3
						elseif WarStat.Loosing then
							WarStat.PeaceWanted = 3
						else
							WarStat.PeaceWanted = 3
						end
					end
					
					-- Override
					if (Warscore > MaxVictoryScore) then
						WarStat.PeaceWanted = 1
					end


					if WarStat.PeaceWanted == 1 then
						WarStat.MaxWarscore = Warscore
						WarStat.MaxWarscoreTag = EnemyTag
						v.WarProgress = 1
						v.VictoryScore = VictoryScore
						--WarStat.PeaceWanted = WarStat.WarProgress
						WarStat.PeaceWantedTag = WarStat.MaxWarscoreTag
					elseif WarStat.PeaceWanted == 2 then
						WarStat.PeaceWanted = 2
						WarStat.MaxWarscore = Warscore
						WarStat.MaxWarscoreTag = EnemyTag
						v.WarProgress = 2
						v.VictoryScore = VictoryScore
						--WarStat.PeaceWanted = WarStat.WarProgress
						WarStat.PeaceWantedTag = WarStat.MaxWarscoreTag
					elseif WarStat.PeaceWanted == 3 then
						WarStat.PeaceWanted = 3
						WarStat.MaxWarscore = Warscore
						WarStat.MaxWarscoreTag = EnemyTag
						v.WarProgress = 3
						v.VictoryScore = VictoryScore
						--WarStat.PeaceWanted = WarStat.WarProgress
						WarStat.PeaceWantedTag = WarStat.MaxWarscoreTag
					end

--Utils.LUA_DEBUGOUT("-function PeaceWanted-2--: " .. tostring(ActTag) .. " -Enemy " ..  tostring(EnemyTag) .. " -WarProgress " ..  tostring(WarStat.WarProgress) .. " -MAX-Warscore " ..  tostring(WarStat.MaxWarscore) .. " -Victory Score " ..  tostring(VictoryScore) .. " -Warscore " ..  tostring(Warscore) .. " -PeaceWanted " ..  tostring(WarStat.PeaceWanted) .. " -PeaceWanted Ctry " ..  tostring(WarStat.MaxWarscoreTag) .. " -RandNr was " ..  tostring(RandNr) .. " -LOOP- " ..  tostring(test))
				else
				-- no actual war anymore set peace(date, reset values..)
					v.SurrenderLevel = nil
					v.PeaceTermTotalValue = nil
					v.Desperation = nil
					if v.WarStart ~= nil then
						v.WarStart = nil
						v.WarEnd = AllDays
					end
					v.WarCounter = 0
					v.PeaceWanted = 0
					v.WarProgress = 0
					v.ControlledProvincesOld = 0
					v.Trend = 1
					v.Factor = 0
					v.FactorOld = 0
					v.Winning = nil
					v.Loosing = nil
					v.Static = nil
					v.FullStatic = 0
					v.StaticWarDays = 0
					v.WinningWarDays = 0
					v.LoosingWarDays = 0
					v.AllWarDays = 0
					v.OldWarscore = 0
					v.ActWarscore = 0
					v.LowestWarscore = 0
					v.MaxWarscore = 0
					v.VictoryScore = 0
					v.MaxVictoryScore = 0
					v.CoreProvincesValue = 0
					v.ExtraProvincesValue = 0
					v.CoreProvincesCounter = 0
					v.TotalProvincesCounter = 0
					v.TotalActualProvincesCounter = 0
					v.OurCoreProvinces = nil
					v.ExtraPossibleProvinces = nil

				end
				-- end of: if ActWar then
			end
			-- end of: if WarTable[i] ~= ("Timestamp") and ForeignWarTable[i] ~= ("OverallWarStat") then
		end
		-- end of: for i = 1, #WarTable do

--if ActTagTbl == "PAL" or ActTagTbl == "ISR" then
--Utils.LUA_DEBUGOUT("Rucksack - Peace Value- " .. tostring(ActTagTbl) .. " SurrenderLvl: " .. tostring(OurSurrenderLevel) .. " ActDesperation: " .. tostring(ActDesperation) .. " WarStat.WarProgress: " .. tostring(WarStat.WarProgress) .. " Peace Wanted: " .. tostring(WarStat.PeaceWanted))
--end
	end
	-- end of: if not(next(WarTable) == nil) then

end

function WarStatus(ActTagTbl)

	local ActMinister = Grand_Country_Table["Country-" .. ActTagTbl].Minister
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	--local ActTag = ActMinister:GetCountryTag()
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local War = Grand_Country_Table["Country-" .. ActTagTbl].War
	local ActStrategy = Grand_Country_Table["Country-" .. ActTagTbl].ActStrategy

	local OurStrength = 0
	local AllyStrength = 0
	local EnemyStrength = 0
	local EnemySurrenderLevel = 0
	local AllySurrenderLevel = 0
	local EnemyCounter = 0
	local AllyCounter = 0
	local FactionLeader = nil
	local PeaceCountry = nil

	local Warscore = 0
	local ControlledProvincesOld = 0
	local FactorOld = 0
	local StaticWarDaysOld = 0
	local WinningWarDaysOld = 0
	local LoosingWarDaysOld = 0
	local WarDaysOld = 0

	local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]
	if (WarTable == nil) then						-- initial initialisation
		WarTable = {
			Timestamp = {							-- Timestamp, how actual is the list
				Score = 50,
				Day = AllDays,
				Month = 0,
				Year = 0
			},
			OverallWarStat = {
				WarStart = nil,
				WarEnd = nil,
				WarCounter = 0,
				PeaceWanted = 0,
				PeaceWantedTag = nil,
				WarProgress = 0,
				OurStrength = 0,
				AllyStrength = 0,
				EnemyStrength = 0,
				SurrenderLevel = nil,
				PeaceTermTotalValue = nil,
				Strategy = nil,
				Desperation = nil,
				ControlledProvincesOld = 0,
				Trend = 1,
				Factor = 0,
				FactorOld = 100,
				Winning = nil,
				Loosing = nil,
				Static = nil,
				FullWinning = 0,
				FullLoosing = 0,
				FullStatic = 0,
				StaticWarDays = 0,
				WinningWarDays = 0,
				LoosingWarDays = 0,
				AllWarDays = 0,
				LowestWarscore = 0,
				LowestWarscoreTag = 0,
				MaxWarscore = 0,
				MaxWarscoreTag = 0,
				MaxVictoryScore = 0
			}
		}
	end
	WarTable.Timestamp.Day = AllDays
	Grand_Diplomacy_Table["WarTable-" .. ActTagTbl] = WarTable

	-- ######################
	-- ## Check for Enemy Countries Data and Overall War Status
	-- ######################
	if ActCountry:IsAtWar() then
		local WarStat = WarTable.OverallWarStat
		WarStat.OurSurrenderLevel =  ActCountry:GetSurrenderLevel():Get() * 100
		WarStat.OurPeaceTermTotalValue = ActCountry:GetPeaceTermTotalValue()
		WarStat.ActStrategy = ActCountry:GetStrategy()
		WarStat.ActDesperation = ActCountry:CalcDesperation():Get()
		WarStat.WarProgress = 0
		WarStat.MaxWarscore = 0
		WarStat.MaxWarscoreTag = nil
		WarStat.LowestWarscore = 0
		WarStat.LowestWarscoreTag = nil
	
		local ControlledProvincesOld = WarStat.ControlledProvincesOld
		local ControlledProvincesNew = ActCountry:GetNumberOfControlledProvinces()
		--local ControlledProvincesNew = Grand_Country_Table["Country-" .. ActTagTbl].ControlledProvincesNew
		-- Overall War Status
--Utils.LUA_DEBUGOUT("-More Provs-: " .. tostring(ActTagTbl) .. " -EnemyTag: " .. tostring(EnemyTag) .. " -ControlledProvincesOld: " .. tostring(ControlledProvincesOld) .. " -ControlledProvincesNew: " .. tostring(ControlledProvincesNew) )

		WarStat.AllWarDays = WarStat.AllWarDays + 1
		WarStat.ControlledProvincesOld = ControlledProvincesNew

		--Winning needs a check for units losses too?(reinforce need?, amount of units etc..?)
		if ControlledProvincesOld > ControlledProvincesNew then											-- loosing
			WarStat.LoosingWarDays = WarStat.LoosingWarDays + 1
			WarStat.Trend = 3
			if WarStat.FullStatic > 0 then
				WarStat.FullStatic = WarStat.FullStatic - 1
			end
		elseif WarStat.ControlledProvincesOld < ControlledProvincesNew then								-- winning
			WarStat.WinningWarDays = WarStat.WinningWarDays + 1
			WarStat.Trend = 1
			if WarStat.FullStatic > 0 then
				WarStat.FullStatic = WarStat.FullStatic - 1
			end
		else																							-- static
			WarStat.StaticWarDays = WarStat.StaticWarDays + 1
			WarStat.Trend = 2
			if WarStat.FullStatic > 0 then
				WarStat.FullStatic = WarStat.FullStatic + 1
			end
		end

		-- Reset first
		WarStat.Winning = nil
		WarStat.Loosing = nil
		WarStat.Static = nil
--Utils.LUA_DEBUGOUT("-We have enemy-: " .. tostring(ActTagTbl) .. "WinningWarDays: " .. tostring(WarStat.WinningWarDays) .. " -LoosingWarDays: " .. tostring(WarStat.LoosingWarDays) .. " -StaticWarDays: " .. tostring(WarStat.StaticWarDays) )

--[[
		-- Is war overall going static or winning or loosing in overall days?
		if (WarStat.StaticWarDays > WarStat.WinningWarDays) and (WarStat.StaticWarDays > WarStat.LoosingWarDays) then				-- static
				WarStat.Static = true
		elseif (WarStat.StaticWarDays > WarStat.WinningWarDays) and (WarStat.StaticWarDays < WarStat.LoosingWarDays) then			-- loosing
			WarStat.Loosing = true
		elseif (WarStat.StaticWarDays < WarStat.WinningWarDays) and (WarStat.StaticWarDays > WarStat.LoosingWarDays) then			-- winning
			WarStat.Winning = true
		elseif (WarStat.StaticWarDays < WarStat.WinningWarDays) and (WarStat.StaticWarDays < WarStat.LoosingWarDays) then			-- ? less static than wining/loosing
			if (WarStat.WinningWarDays > WarStat.LoosingWarDays) then																-- winning
				WarStat.Winning = true
			else																													-- loosing
				WarStat.Loosing = true
			end
		end
]]
		-- The factor is needed to have a better view of how the overall situation was progressing
		-- So -1 up to +1 represents loosig or winning. The Days are just a rough first view on how the war is going.
		WarStat.Factor = (WarStat.WinningWarDays - WarStat.LoosingWarDays) / WarStat.AllWarDays
--[[
				if (WarStat.Winning) then
				
				elseif (WarStat.Static) then
				
				elseif (WarStat.Loosing) then
]]

		-- Overall situation(winning/loosing/static)
		if WarStat.AllWarDays > 5 then
			if (WarStat.Trend == 1 ) then											-- Actually winning ground
				if WarStat.Factor > -0.25 then											-- winning most times
					WarStat.WarProgress = 1													-- Keep on fighting until max goal reached
				elseif WarStat.Factor > -0.75 and WarStat.Factor < -0.25 then			-- static - back and forth
					WarStat.WarProgress = 2													-- Lets make peace now that we are winning
				elseif WarStat.Factor < -0.75 then										-- loosing most times
					WarStat.WarProgress = 3													-- Keep on fighting maybe its getting better now
				end	
			elseif (WarStat.Trend == 2 ) then										-- Actually no change
				if WarStat.Factor > 0 then											-- winning most times
					WarStat.WarProgress = 4													-- Keep on fighting until max goal reached
				elseif WarStat.Factor > -0.50 and WarStat.Factor < 0 then			-- static - back and forth
					WarStat.WarProgress = 5													-- Lets make peace now
				elseif WarStat.Factor < -0.50 then										-- loosing most times
					WarStat.WarProgress = 6													-- Lets make peace now before it gets worse
				end
			elseif (WarStat.Trend == 3 ) then										-- Actually loosing ground
				if WarStat.Factor > 0.25 then											-- winning most times
					WarStat.WarProgress = 7													-- Keep on fighting maybe its getting better now
				elseif WarStat.Factor > -0.25 and WarStat.Factor < 0.25 then			-- static - back and forth
					WarStat.WarProgress = 8													-- Lets make peace now before it gets worse
				elseif WarStat.Factor < -0.25 then										-- loosing most times
					WarStat.WarProgress = 9													-- Peace please
				end
			end
		end
		--end of: if WarStat.AllWarDays > 5 then

		if WarStat.FactorOld == 100 then 
			WarStat.FactorOld = WarStat.Factor		
		elseif (WarStat.Factor < (WarStat.FactorOld + 0.15)) then
			WarStat.FactorOld = WarStat.Factor
			WarStat.Winning = true
		elseif (WarStat.Factor > (WarStat.FactorOld - 0.15)) then
			WarStat.FactorOld = WarStat.Factor
			WarStat.Loosing = true
		end

		-- Check if we're really stuck, or if some more Prov changes take place
		if WarStat.FullStatic > 15 then																	-- FullStatic, 15 days of continous no change
			WarStat.Static = true
		end

		-- Check for Enemy Countries Data
		for Enemy in ActCountry:GetCurrentAtWarWith() do											-- With who?
			--local EnemyCountryTag = Enemy:GetCountryTag()
			--local EnemyCountry = Enemy:GetCountry()
			local EnemyCountryTagTbl = tostring(Enemy)
			local EnemyCountryTable = WarTable["EnemyCountry-" .. EnemyCountryTagTbl]
			if (EnemyCountryTable == nil) then												-- initial initialisation
				EnemyCountryTable = {
					Enemy = Enemy,
					ActWar = nil,
					SurrenderLevel = nil,
					PeaceTermTotalValue = nil,
					Desperation = nil,
					WarStart = nil,
					WarEnd = nil,
					WarCounter = 0,
					PeaceWanted = 0,
					WarProgress = 0,
					ControlledProvincesOld = 0,
					Trend = 1,
					Factor = 0,
					FactorOld = 0,
					Winning = nil,
					Loosing = nil,
					Static = nil,
					FullStatic = 0,
					StaticWarDays = 0,
					WinningWarDays = 0,
					LoosingWarDays = 0,
					AllWarDays = 0,
					OldWarscore = 0,
					ActWarscore = 0,
					LowestWarscore = 0,
					MaxWarscore = 0,
					VictoryScore = 0,
					MaxVictoryScore = 0,
					CoreProvincesValue = 0,
					ExtraProvincesValue = 0,
					CoreProvincesCounter = 0,
					TotalProvincesCounter = 0,
					TotalActualProvincesCounter = 0,
					OurCoreProvinces = { },
					ExtraPossibleProvinces = { }
					
				}
			end
			local Relation = ActCountry:GetRelation(Enemy)
			local RelationWar = Relation:GetWar()
			EnemyCountryTable.ActWarscore = RelationWar:GetWarScore(ActTag, Enemy)
			EnemyCountryTable.ActWar = true

			if EnemyCountryTable.WarStart == nil then
				EnemyCountryTable.WarStart = AllDays
			end
			EnemyCountryTable.SurrenderLevel = Enemy:GetCountry():GetSurrenderLevel():Get() * 100
			EnemyCountryTable.PeaceTermTotalValue = Enemy:GetCountry():GetPeaceTermTotalValue()
			EnemyCountryTable.Desperation = Enemy:GetCountry():CalcDesperation():Get()

			--winning, loosing, static?
			-- reset first
			EnemyCountryTable.Winning = nil
			EnemyCountryTable.Loosing = nil
			EnemyCountryTable.Static = nil
			if EnemyCountryTable.ActWarscore > EnemyCountryTable.OldWarscore then
				EnemyCountryTable.Winning = true
			elseif EnemyCountryTable.ActWarscore < EnemyCountryTable.OldWarscore then
				EnemyCountryTable.Loosing = true
			elseif EnemyCountryTable.ActWarscore == EnemyCountryTable.OldWarscore then
				EnemyCountryTable.Static = true
			end
			
			-- Set some data for another usage
			-- See if the current warscore is the biggest/smallest for this country by now
			if EnemyCountryTable.ActWarscore > EnemyCountryTable.MaxWarscore then
				EnemyCountryTable.MaxWarscore = EnemyCountryTable.ActWarscore
			elseif EnemyCountryTable.ActWarscore < EnemyCountryTable.LowestWarscore then
				EnemyCountryTable.LowestWarscore = EnemyCountryTable.ActWarscore
			end
			-- See if the current warscore is the biggest/smallest overall by now
			if EnemyCountryTable.ActWarscore > WarStat.MaxWarscore then
				WarStat.MaxWarscore = EnemyCountryTable.ActWarscore
				WarStat.MaxWarscoreTag = Enemy
			elseif EnemyCountryTable.ActWarscore < WarStat.LowestWarscore then
				WarStat.LowestWarscore = EnemyCountryTable.ActWarscore
				WarStat.LowestWarscoreTag = Enemy
			end
			EnemyCountryTable.OldWarscore = EnemyCountryTable.ActWarscore
			
			-- Write the table
			WarTable["EnemyCountry-" .. EnemyCountryTagTbl] = EnemyCountryTable
--Utils.LUA_DEBUGOUT("-function WarStat-: " .. tostring(ActTag) .. " -Enemy " ..  tostring(EnemyCountryTable.Enemy) .. " -WarProgress " ..  tostring(WarStat.WarProgress) .. " -MAX-Warscore " ..  tostring(WarStat.MaxWarscore) .. " -WarStart " ..  tostring(EnemyCountryTable.WarStart))
--Utils.LUA_DEBUGOUT("-function WarStat-2: " .. tostring(ActTag) .. " -Enemy " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].Enemy) .. " -WarProgress " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].WarProgress) .. " -MAX-Warscore " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].ActWarscore) .. " -WarStart " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].WarStart))

		end
		-- end of: for Enemy in ActCountry:GetCurrentAtWarWith() do
	
	end
	-- end of: if ActCountry:IsAtWar() then


	-- Writing tables for later usage
	Grand_Country_Table["WarTable-" .. ActTagTbl] = WarTable

end

function ManpowerCheck(ActTagTbl)

	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local War = Grand_Country_Table["Country-" .. ActTagTbl].War

	if Grand_Country_Table["Manpower-" .. ActTagTbl] == nil then
		local ManpowerTable = {
			Timestamp = 0,
			TotalAvailableManpower = 0,
			theoMaxMP = 0,
			MPneedsinQueue = 0,
			MPneedsinPool = 0,
			MPneededforReinf = 0,
			FreeMP = 0,
			MPLow = false
		}
		Grand_Country_Table["Manpower-" .. ActTagTbl] = ManpowerTable
	end

	local TotalAvailableManpower = ActCountry:GetManpower():Get()
	local theoMaxMP = ActCountry:GetMaxManpower():Get()
	local MPneedsinQueue = ActCountry:GetRequiredManpowerForQueue():Get()
	local MPneedsinPool = ActCountry:GetRequiredManpowerForPool():Get()
	local MPneededforReinf = ActCountry:GetReinfManpowerNeeded():Get()

	-- Check if we are "low" on MP
	local CountrySmallMP = ((TotalAvailableManpower < 11) or (War and TotalAvailableManpower < 31)) -- And Manpowerbase X..
	local CountryMedMP = ((TotalAvailableManpower < 50) or (War and TotalAvailableManpower < 100)) 	-- And Manpowerbase X..
	local CountryBigMP = ((TotalAvailableManpower < 100) or (War and TotalAvailableManpower < 300)) -- And Manpowerbase X..
	if CountrySmallMP then
		Grand_Country_Table["Manpower-" .. ActTagTbl].MPlow = true
	elseif CountryMedMP then
		Grand_Country_Table["Manpower-" .. ActTagTbl].MPlow = true
	elseif CountryBigMP then
		Grand_Country_Table["Manpower-" .. ActTagTbl].MPlow = true
	else
		Grand_Country_Table["Manpower-" .. ActTagTbl].MPlow = false
	end
	Grand_Country_Table["Manpower-" .. ActTagTbl].Timestamp = Grand_Country_Table["Country-" .. ActTagTbl].Timestamp
	Grand_Country_Table["Manpower-" .. ActTagTbl].TotalAvailableManpower = TotalAvailableManpower
	Grand_Country_Table["Manpower-" .. ActTagTbl].theoMaxMP = theoMaxMP
	Grand_Country_Table["Manpower-" .. ActTagTbl].MPneedsinQueue = MPneedsinQueue
	Grand_Country_Table["Manpower-" .. ActTagTbl].MPneedsinPool = MPneedsinPool
	Grand_Country_Table["Manpower-" .. ActTagTbl].MPneededforReinf = MPneededforReinf
	Grand_Country_Table["Manpower-" .. ActTagTbl].FreeMP = TotalAvailableManpower - (MPneedsinQueue + MPneedsinPool + Grand_Country_Table["Manpower-" .. ActTagTbl].MPneededforReinf)
--Utils.LUA_DEBUGOUT("-Manpower-RUCKSACK-1-: " .. tostring(ActTag) .. "-" ..  tostring(Grand_Country_Table["Ignition-" .. ActTagTbl]))

	
end

function ProductionNeed(ActTagTbl, Money)
--[[


	for k, v in pairs(LandUnits) do				-- Query all the Land units in the land units table
		if k ~= ("Timestamp") then				-- Dont check the values in the Timesptamp section, just units please..
			v.ActCountProduction = ActCountry:GetProductionSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
			v.ActCountPool = ActCountry:GetPooledSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
			v.ActCountMap = ActCountry:GetDeployedSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
			v.ActCountAll = (v.ActCountProduction + v.ActCountMap) + v.ActCountPool
			v.Tech = Grand_Country_Table["Country-" .. ActTagTbl].TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit(v.Name))
			TotalCountLand.CountAllProduction = TotalCountLand.CountAllProduction + v.ActCountProduction
			TotalCountLand.CountAllPool = TotalCountLand.CountAllPool + v.ActCountPool
			TotalCountLand.CountAllMap = TotalCountLand.CountAllMap + v.ActCountMap

you can simply use
.def( "GetSubUnitBuild", &CCountry::GetSubUnitBuild)
[24.01.2014 16:35:43] fluidbiga: country:GetSubUnitBuild(subunitindex)

subunitindex is subunit::GetIndex()  (int)



			.def( "GetDeployedSubUnitCounts", &CCountry::GetDeployedSubUnitCounts )
			.def( "GetPooledSubUnitCounts", &CCountry::GetPooledSubUnitCounts )
			.def( "GetProductionSubUnitCounts", &CCountry::GetProductionSubUnitCounts )
			.def( "GetTheatreSubUnitNeedCounts", &CCountry::GetTheatreSubUnitNeedCounts )

				UnitCost = UnitCost + ActCountry:GetBuildCostIC( UnitType, 1, bBuildReserve):Get()
				UnitMPCost = UnitMPCost + UnitType:GetBuildCostMP():Get()


	for SubUnit in CSubUnitDataBase.GetSubUnitList() do
		local ActualUnitNumber = SubUnit:GetIndex()
		local ActualUnitType = SubUnit:GetKey():GetString()
		--local Need = ActCountry:GetSubUnitBuild(SubUnit)
		local Need = ActCountry:GetSubUnitBuild(SubUnit:GetIndex())
		local Need2 = ActCountry:GetSubUnitBuild(CSubUnitDataBase.GetSubUnit(ActualUnitType):GetIndex())
					--ActCountry:GetPooledSubUnitCounts():GetAt(CSubUnitDataBase.GetSubUnit(k):GetIndex())
		if Need > 0 then
--local OldTheatreNeed =  ActCountry:GetTheatreSubUnitNeedCounts():GetAt(CSubUnitDataBase.GetSubUnit(ActualUnitType):GetIndex())

Utils.LUA_DEBUGOUT("-UNIT-NEEDS-RUCKSACK-New CHAR TEST-: " .. tostring(ActTagTbl) .. " -Unit Type " ..  tostring(ActualUnitType) .. " - " ..  tostring(Need2))

Utils.LUA_DEBUGOUT("-UNIT-NEEDS-RUCKSACK-NewCode-: " .. tostring(ActTagTbl) .. " -Unit Type " ..  tostring(ActualUnitType) .. " - " ..  tostring(Need))

		end
	end
]]
	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local SeaAvail = Grand_Country_Table["Country-" .. ActTagTbl].SeaAvail 			-- and money < 100)
	local AirAvail = Grand_Country_Table["Country-" .. ActTagTbl].AirAvail 			-- and money < 100)
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	local bBuildReserve = false  

	-- Manpower Data Setup
	local ManpowerTable = Grand_Country_Table["Manpower-" .. ActTagTbl]			-- Just a shorter name for the long table name for better readability
	if (Grand_Country_Table["Manpower-" .. ActTagTbl] == nil ) then
		ManpowerCheck(ActTagTbl)
	elseif (Grand_Country_Table["Manpower-" .. ActTagTbl].Timestamp) < (AllDays) then
		ManpowerCheck(ActTagTbl)
	end
	--	# Check theoretical limit of manpower
	local FreeMP = Grand_Country_Table["Manpower-" .. ActTagTbl].FreeMP
	local MinMP = 1
	if FreeMP < MinMP then
--if (ActTagTbl == "USA") or (ActTagTbl == "ENG") or (ActTagTbl == "SOV") or (ActTagTbl == "FRA") then
--Utils.LUA_DEBUGOUT("-Rucksack Production Need- Not enough Manpower: " .. tostring(ActTag) .. " -MinMP " .. tostring(MinMP) .. " -FreeMP " .. tostring(FreeMP))
--end
	  return 0
	end
--Utils.LUA_DEBUGOUT("-Rucksack Production Need-- Current Manpower: " .. tostring(ActTag) .. " -Available Manpower " .. tostring(TotalAvailableManpower) .. " -MPneededforReinf " .. tostring(MPneededforReinf) .. " -MPneedsinPool " .. tostring(MPneedsinPool) .. " -MPneedsinQueue " .. tostring(MPneedsinQueue))
	
	-- ###################################
	-- ## New money need calculations
	local OldMoney = Money
	local MoneyNeed = 0
	local ManpowerNeed = 0
	local LandUnits = Grand_Units_Table["LandUnits-" .. ActTagTbl]
	local SeaUnits = Grand_Units_Table["SeaUnits-" .. ActTagTbl]
	local AirUnits = Grand_Units_Table["AirUnits-" .. ActTagTbl]
	local TotalCountLand = Grand_Units_Table["TotalCountLand-" .. ActTagTbl] 
	local TotalCountSea = Grand_Units_Table["TotalCountSea-" .. ActTagTbl] 
	local TotalCountAir = Grand_Units_Table["TotalCountAir-" .. ActTagTbl] 
	if LandUnits == nil then UnitsSetup(ActTagTbl) end

--if (ActTagTbl == "USA") or (ActTagTbl == "ENG") or (ActTagTbl == "SOV") or (ActTagTbl == "FRA") then
--Utils.LUA_DEBUGOUT("-ProductionNeed-VProduction-1-: " .. tostring(ActTagTbl) .. " -AllDays- " ..  tostring(AllDays) .. " -MONEY BEFORE NEED-: " ..  tostring(OldMoney) .. " -MONEY NEED-: " ..  tostring(MoneyNeed))
--end
	for k, v in pairs(LandUnits) do												-- Query all the Land units in the land units table
		if (v.TheatreNeed > v.ActCountAll) and (FreeMP > MinMP) then			-- Is the theatre need higher as our current unit status?
			if k ~= ("Timestamp") then											-- Dont check the values in the Timesptamp section, just units please..
				-- check of roles
				if v.Type == "LandSpec" then			-- Special (Bergs/Marine)
					if TotalCountLand.NeedAllSpecial > TotalCountLand.CountAllSpecial then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				-- Then check for roles
				elseif v.Role == "Inf" then
					if TotalCountLand.NeedAllInf > TotalCountLand.CountAllInf then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				elseif v.Role == "Cavalry" then
					if TotalCountLand.NeedAllCav > TotalCountLand.CountAllCav then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				elseif v.Role == "Mech" then
					if TotalCountLand.NeedAllMech > TotalCountLand.CountAllMech then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				elseif v.Role == "Armor" then
					if TotalCountLand.NeedAllArmor > TotalCountLand.CountAllArmor then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
			-- Support has additional check
				elseif v.Role == "AA" then
					if TotalCountLand.NeedAllAA > TotalCountLand.CountAllAA then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				elseif v.Role == "AT" then
					if TotalCountLand.NeedAllAT > TotalCountLand.CountAllAT then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				elseif v.Role == "Art" then
					if TotalCountLand.NeedAllStdArt > TotalCountLand.CountAllStdArt then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				elseif v.Role == "RakArt" then
					if TotalCountLand.NeedAllRakArt > TotalCountLand.CountAllRakArt then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				elseif v.Role == "SpecialSupport" then
					if TotalCountLand.NeedAllSpec > TotalCountLand.CountAllSpec then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				else									-- All else will be Land anyway..
					if TotalCountLand.NeedAllOther > TotalCountLand.CountAllOther then
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
						ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
					else	-- Need is halved as we have more in other subareas 
						MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
					end
				end
				-- end of: check of roles
			end
			-- end of: if k ~= ("Timestamp") then
		else
			break
		end
		-- end of: if (v.TheatreNeed > v.ActCountAll) and (FreeMP > MinMP) then
		FreeMP = FreeMP - ManpowerNeed
	end
	-- end of: for k, v in pairs(LandUnits) do

	if SeaAvail then
		for k, v in pairs(SeaUnits) do											-- Query all the Sea units in the sea units table
			if (v.TheatreNeed > v.ActCountAll) and (FreeMP > MinMP) then		-- Is the theatre need higher as our current unit status?
				if k ~= ("Timestamp") then										-- Dont check the values in the Timesptamp section, just units please..
					-- Check for roles
					if v.Role == "Submarine" then
						if TotalCountSea.NeedAllSubmarine > TotalCountSea.CountAllSubmarine then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Coast" then
						if TotalCountSea.NeedAllCoastDefense > TotalCountSea.CountAllCoastDefense then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Escort" then
						if TotalCountSea.NeedAllEscort > TotalCountSea.CountAllEscort then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Cruiser" then
						if TotalCountSea.NeedAllCruiser > TotalCountSea.CountAllCruiser then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Battle" then
						if TotalCountSea.NeedAllBattle > TotalCountSea.CountAllBattle then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Carrier" then
						if TotalCountSea.NeedAllCarrier > TotalCountSea.CountAllCarrier then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Transport" then
						if TotalCountSea.NeedAllTransport > TotalCountSea.CountAllTransport then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					else									-- All else wich are not defined
						if TotalCountSea.NeedAllOther > TotalCountSea.CountAllOther then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					end
					-- end of: -- Check for roles
				end
				-- end of: if k ~= ("Timestamp") then
			else
				break
			end
			-- end of: if (v.TheatreNeed > v.ActCountAll) and (FreeMP > MinMP) then
			FreeMP = FreeMP - ManpowerNeed
		end
		-- end of: for k, v in pairs(SeaUnits) do
	end
	-- end of: if SeaAvail then

	if AirAvail then
		for k, v in pairs(AirUnits) do											-- Query all the Air units in the air units table
			if (v.TheatreNeed > v.ActCountAll) and (FreeMP > MinMP) then		-- Is the theatre need higher as our current unit status?
				if k ~= ("Timestamp") then										-- Dont check the values in the Timesptamp section, just units please..
				-- Counting 
				-- First some types wich are not checked in the roles below
					if (v.Type == "Helo" and v.Role == "CAS") then											-- CAS Helo
						if TotalCountAir.NeedAllHeloCAS > TotalCountAir.CountAllHeloCAS then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif (v.Type == "Helo" and v.Role == "Naval") then									-- Naval Helo
						if TotalCountAir.NeedAllHeloNaval > TotalCountAir.CountAllHeloNaval then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif (v.Type == "Air" and v.Role == "Naval") then										-- Naval Planes
						if TotalCountAir.NeedAllNaval > TotalCountAir.CountAllNaval then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
				-- Then check for roles
					elseif v.Role == "Fighter" then
						if TotalCountAir.NeedAllFighter > TotalCountAir.CountAllFighter then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Bomber" then
						if TotalCountAir.NeedAllBomber > TotalCountAir.CountAllBomber then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "CAS" then
						if TotalCountAir.NeedAllCAS > TotalCountAir.CountAllCAS then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Support" then
						if TotalCountAir.NeedAllSupport > TotalCountAir.CountAllSupport then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "CAG" then
						if TotalCountAir.NeedAllCAG > TotalCountAir.CountAllCAG then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					elseif v.Role == "Transport" then
						if TotalCountAir.NeedAllTransport > TotalCountAir.CountAllTransport then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					else																					-- All else will be Air somehow..
						if TotalCountAir.NeedAllOther > TotalCountAir.CountAllOtherS then
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll))
							ManpowerNeed = ManpowerNeed  + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll))
						else	-- Need is halved as we have more in other subareas 
							MoneyNeed = MoneyNeed + (v.MoneyCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
							ManpowerNeed = ManpowerNeed + (v.ManpowerCost * (v.TheatreNeed - v.ActCountAll) * 0.5)
						end
					end
					-- end of: -- Check for roles
				end
				-- end of: if k ~= ("Timestamp") then
			else
				break
			end
			-- end of: if (v.TheatreNeed > v.ActCountAll) and (FreeMP > MinMP) then
			FreeMP = FreeMP - ManpowerNeed
		end
		-- end of: for k, v in pairs(SeaUnits) do
	end
	-- end of: if AirAvail then
--if (ActTagTbl == "USA") or (ActTagTbl == "ENG") or (ActTagTbl == "SOV") or (ActTagTbl == "FRA") then
--	Utils.LUA_DEBUGOUT("-ProductionNeed-VProduction-2-: " .. tostring(ActTagTbl) .. " -AllDays- " ..  tostring(AllDays) .. " -MONEY BEFORE NEED-: " ..  tostring(OldMoney) .. " -MONEY NEED-: " ..  tostring(MoneyNeed))
--end

	if MoneyNeed > OldMoney then
		return MoneyNeed
	else
		return OldMoney
	end

end

function comps(v1,v2)
	if v1[1] < v2[1] then
		return true
	end
end


--### Old stuff..

-- General NeigbourCountryCheck
function NeigbourCountryCheck(ActTagTbl)

	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()

	local Score = 0
	local TagList = {}						-- Need reset for each group
	local SortedTagList = {}
	
	for Neighbor in ActCountry:GetNeighbours() do
		local NeighborString = tostring(Neighbor)
		-- check if target has faction/allies/Strength/cores.. ->scoring function?
		if HasAnyCores(ActTagTbl, Neighbor) then										-- If they have any of our cores
			Score = Score + 50
		end
		-- ..
		TagList[Score] = NeighborString
		table.insert(SortedTagList, { Score, NeighborString })
		

		end
	
	return SortedTagList
end

-- General CountryCheck for all countries
function AllCountryCheck(ActTagTbl, TableName)

	local ActTagTbl = ActTagTbl
	local ActCountry = Grand_Country_Table["Country-" .. ActTagTbl].ActCountry
	local ActTag = Grand_Country_Table["Country-" .. ActTagTbl].ActTag
	local ActAI = Grand_Country_Table["Country-" .. ActTagTbl].ActAI
	local AllDays = CCurrentGameState.GetCurrentDate():GetTotalDays()

	local CheckTable = Grand_Diplomacy_Table["RelationTable-" .. ActTagTbl]  --{}
	local score = 0
--[[
	if TableName == "Neighbour" then
		score = score + 15
		CheckTable = Grand_Diplomacy_Table["NeighbourRelationTable-" .. ActTagTbl]
	elseif TableName == "Continent" then
		score = score + 5
		CheckTable = Grand_Diplomacy_Table["ContinentRelationTable-" .. ActTagTbl]
	elseif TableName == "World" then
		CheckTable = Grand_Diplomacy_Table["WorldRelationTable-" .. ActTagTbl]
	end
]]

--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck---: " .. tostring(ActTagTbl) .. "--Table--" ..  tostring(TableName))

	-- Different Scores
	local DeclareWar = 0
	local HelpWar = 0
	local Influence = 0
	local Trade = 0
	
	--neighbour of wartarget?
	
	-- Starting the checks
	local Zahl = 0
	for k, v in pairs(CheckTable) do
		Zahl = Zahl + 1
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck--2-: ")

		local ForeignCountryTagTbl = v.ForeignCountryTagTbl
		local ForeignCountry = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].ActCountry
		local ForeignCountryTag = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].ActTag
		local ForeignCountryRelation = v.ForeignCountryRelation
		local ForeignCountryThreat = v.ForeignCountryThreat
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck--Actag-: " .. tostring(ActTag) .. "---ForeignTagTbl---" ..  tostring(ForeignCountryTagTbl))
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck---: " .. tostring(ForeignCountryTag) .. "--Relation--" ..  tostring(ForeignCountryRelation))
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck---: " .. tostring(ForeignCountryTag) .. "--Threat--" ..  tostring(ForeignCountryThreat))

		-- Are we influencing them already?
		local WeInfluence = ActAI:IsInfluencing(ActTag, ForeignCountryTag)
	
	-- if we are influencing them help our Ideology
	--	elseif ( TargetCountry:GetRelation(ministerTag):IsBeingInfluenced() ) then	
	
		-- Score Relationship: The higher the relationship, the higher the score
		if ForeignCountryRelation < -125 then													-- value -126 to -200(range 75 = very bad)
			score = score + 0
		elseif ForeignCountryRelation < -50 then												-- value -51 to -125(range 75 = bad)
			score = score + 0
		elseif ForeignCountryRelation > 50 then													-- value 51 to 125(range 75 = good)
			score = score + 0				
		elseif ForeignCountryRelation > 125 then												-- value 126 to 200(range 75 = very good)
			score = score + 0
		else																					-- value -49 to 50(range 100 = neutral)
			score = score + 0		
		end

		-- Score Threat: The lower the threat, the higher the score
		if ForeignCountryThreat < 15 then													-- value 0 to 14(range 10 = very low)
			score = score + 0
		elseif ForeignCountryThreat < 35 then												-- value 15 to 34(range 20 = low)
			score = score + 0
		elseif ForeignCountryThreat < 75 then												-- value 35 to 74(range 40 = middle)
			score = score + 0
		elseif ForeignCountryThreat < 125 then												-- value 75 to 124(range 50 = high)
			score = score + 0
		else																				-- value 125 to x(range 75 = very high)
			score = score + 0
		end

		-- Faction?
		local ForeignCountryFaction = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].FactionName
		local ActFaction = Grand_Country_Table["Country-" .. ActTagTbl].FactionName

		local OurFaction = nil
		local OtherFaction = nil
				
		if ForeignCountryFaction == ActFaction then											-- In our faction
			OurFaction = true
			score = score + 10
		elseif Grand_Country_Table["Country-" .. ForeignCountryTagTbl].HasFaction then		-- In another faction
			OtherFaction = true
			score = score + 0
		else																				-- In none faction yet
			score = score + 5
		end

		
		-- Alignement?
		local AligningOurFactionValue = 0
		local AligningOtherFactionValue = 0
		local AligningFactionTag = nil
		local AligningFactionValue = 200
		
		for Faction in CCurrentGameState.GetFactions() do
			local FactionLeader = Faction:GetFactionLeader():GetCountry()
			local AlignmentValue = ActAI:GetCountryAlignmentDistance(ForeignCountry, FactionLeader):Get()
			if AlignmentValue < AligningFactionValue then
				AligningFactionTag = Faction:GetTag()
				AligningFactionValue = AlignmentValue
			end
		end

		if AligningFactionTag == ActFaction then			-- Leaning towards our faction
			score = score + 5
		else												-- Leaning towards other faction
			score = score + 0
		end


		-- Our Puppet?
		local CheckOverlordTag = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].OverlordTag
		if CheckOverlordTag == ActTag then
		-- They're our puppet
		end
		-- Or
		--[[
		local PuppetTable = Grand_Country_Table["Country-" .. ActTagTbl].PuppetTable
		if PuppetTable ~= (nil) then														-- We have puppets..
		
			for m = 1, #PuppetTable do
			local PuppetTagTbl = PuppetTable[m]
			if ForeignCountryTagTbl == PuppetTagTbl then									-- They're our puppet

			end
		end
		]]

		-- Their Puppets?
		local ForeignPuppetTable = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].PuppetTable
		if ForeignPuppetTable ~= (nil) then														-- They have puppets..
		
			for m = 1, #ForeignPuppetTable do
			--"Puppet of who" remark?
			local ForeignPuppetTagTbl = ForeignPuppetTable[m]
			local ForeignPuppet = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].ActCountry
				if ForeignPuppet:IsFriend(ActTag, true) then									-- Puppet is friends
				
				elseif ForeignPuppet:IsEnemy(ActTag) then										-- Puppet is our enemy
				
				else																			-- Otherwise
				
				end
			end
		end


	-- -> at war with them? check war table
		local WarTable = Grand_Country_Table["Country-" .. ActTagTbl].WarTable
		if WarTable ~= (nil) then
			for i = 1, #WarTable do

				local EnemyTagTbl = WarTable[i]
				if ForeignCountryTagTbl == EnemyTagTbl then							-- we are at war with them!
				--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck--wartable-: " .. tostring(ForeignCountryTag) .. "-- in Wartable--" ..  tostring(EnemyTag))
				else
				--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck--wartable-: " .. tostring(ForeignCountryTag) .. "--not current country--" ..  tostring(EnemyTag))
				end
				--table.insert(WarTable, {Enemy, EnemyCountry, EnemyCountryTagTbl})
				
				local EnemyTag = Grand_Country_Table["Country-" .. EnemyTagTbl].ActTag
				if ForeignCountry:IsEnemy(EnemyTag) then							-- They're enemy of our enemy

				elseif ForeignCountry:IsFriend(EnemyTag, true) then					-- They're friend of our enemy
				-- table?
				else																-- They're neutral to our enemy
				
				end
			end
		end


		-- Our enemies/friends or neutral?
		if Grand_Country_Table["Country-" .. ForeignCountryTagTbl].ActCountry:IsEnemy(ActTag) then					-- They're enemy of us
			score = score + 0
		elseif Grand_Country_Table["Country-" .. ForeignCountryTagTbl].ActCountry:IsFriend(ActTag, true) then		-- They're friend of us
			score = score + 10
		else																										-- They're neutral to us
			score = score + 5
		end



		-- Highest threat for them is our "enemy"?
		local ForeignHighestThreatCountry = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].HighestThreatCtry:GetCountry()
		local ForeignHighestThreat = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].HighestThreat
		if ForeignHighestThreatCountry:IsEnemy(ActTag) then										-- Their "Threat" is enemy of us
		
		elseif ForeignHighestThreatCountry:IsFriend(ActTag, true) then							-- Their "Threat" is friend of us
		
		end



if ( ActTagTbl == "USA") and (ForeignCountryTagTbl == "ISR") then
		-- Are they at war, and with who?
		-- faction/alliance needs to make sure if any members neighbours involved?
		local PossibleWarAid = { }
		local ForeignWarTable = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].WarTable
		if ForeignWarTable ~= (nil) then												-- They are at war..
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---Diplo---: " .. tostring(ActTagTbl) .. "--ForeignWarTable ~= (nil)-" )

			for j = 1, #ForeignWarTable do
				local ForeignEnemyTagTbl = ForeignWarTable[j]
				local ForeignEnemy = Grand_Country_Table["Country-" .. ForeignEnemyTagTbl].ActCountry
				local ForeignEnemyFaction = Grand_Country_Table["Country-" .. ForeignEnemyTagTbl].FactionName
Utils.LUA_DEBUGOUT("-RUCKSACK-Main Loop: " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) .. "-#ForeignWarTable-" ..  tostring(#ForeignWarTable) .. "-Loop#-" ..  tostring(j) .. "-Enemy-" ..  tostring(ForeignEnemyTagTbl) .. "-TableName-" ..  tostring(TableName) )
				if ForeignEnemyTagTbl ~= ActTagTbl then							-- We don't look at ourselfs..

					if Grand_Country_Table["Country-" .. ForeignEnemyTagTbl].HasFaction then				-- Fighting faction?
						--if Grand_Country_Table["Country-" .. ForeignEnemyTagTbl].FactionLeader
						if (ForeignEnemyFaction ~= nil) and (ForeignEnemyFaction ~= ActFaction) then		-- Another Faction!
							score = score + 15
							PossibleWarAid[ForeignEnemyTagTbl] = ForeignEnemyTagTbl
--Utils.LUA_DEBUGOUT("-RUCKSACK- HasFaction: " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) .. "-#ForeignWarTable-" ..  tostring(#ForeignWarTable) .. "-Loop#-" ..  tostring(j) .. "-Enemy-" ..  tostring(ForeignEnemyTagTbl) .. "-TableName-" ..  tostring(TableName) )

						end
					elseif ForeignEnemy:IsEnemy(ActTag) then												-- If we have common enemies
						PossibleWarAid[ForeignEnemyTagTbl] = ForeignEnemyTagTbl
--Utils.LUA_DEBUGOUT("-RUCKSACK- IsEnemy: " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) .. "-#ForeignWarTable-" ..  tostring(#ForeignWarTable) .. "-Loop#-" ..  tostring(j) .. "-Enemy-" ..  tostring(ForeignEnemyTagTbl) .. "-TableName-" ..  tostring(TableName) )
						
					elseif ForeignEnemy:IsFriend(ActTag, true) then											-- They are at war with friends
						--table.insert(TempTable, ForeignCountryTagTbl )
						PossibleWarAid[ForeignCountryTagTbl] = ForeignCountryTagTbl
--Utils.LUA_DEBUGOUT("-RUCKSACK- IsFriend: " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) .. "-#ForeignWarTable-" ..  tostring(#ForeignWarTable) .. "-Loop#-" ..  tostring(j) .. "-Enemy-" ..  tostring(ForeignEnemyTagTbl) .. "-TableName-" ..  tostring(TableName) )
						
					else																					-- Otherwise
						PossibleWarAid[ForeignEnemyTagTbl] = ForeignEnemyTagTbl
--Utils.LUA_DEBUGOUT("-RUCKSACK- ELSE: " .. tostring(ActTagTbl) .. "-ForeignTag-" .. tostring(ForeignCountryTagTbl) .. "-#ForeignWarTable-" ..  tostring(#ForeignWarTable) .. "-Loop#-" ..  tostring(j) .. "-Enemy-" ..  tostring(ForeignEnemyTagTbl) .. "-TableName-" ..  tostring(TableName) )

					end
				end


--Utils.LUA_DEBUGOUT("--1---RUCKSACK---LOOP---: " .. tostring(ActTagTbl) .. "--PossibleWarAid COUNT-" .. tostring(count) )
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---LOOP---: " .. tostring(ActTagTbl) .. "--PossibleWarAid-" .. tostring(PossibleWarAid[j]) )
			end
			
		end
		
		if PossibleWarAid ~= (nil) then
			table.insert(Grand_Diplomacy_Table["PossibleWarAid-" .. ActTagTbl], PossibleWarAid)
			if ( ActTagTbl == "USA") then
				local count2 = 0
				--for l = 1, #testtbl do
				for k, v in pairs(PossibleWarAid) do
					count2 = count2 + 1
Utils.LUA_DEBUGOUT("--1---RUCKSACK--TABLE-: " .. tostring(ActTagTbl) .. "--Count-" .. tostring(count2) .. "--PossibleWarAid-" .. tostring(Grand_Diplomacy_Table["PossibleWarAid-" .. ActTagTbl][k]) )
				end
--Utils.LUA_DEBUGOUT("--1---RUCKSACK---PossibleWarAid ~= (nil)---: " .. tostring(ActTagTbl) .. "--All-" .. tostring(count2) )
			end
		end
end

		-- Do we have friends/enemies among their allies?
		local ForeignAllyTable = Grand_Country_Table["Country-" .. ForeignCountryTagTbl].AllyTable
		if ForeignAllyTable ~= (nil) then													-- They have allies..
		
			for l = 1, #ForeignAllyTable do
			local ForeignAllyTagTbl = ForeignAllyTable[l]
			local ForeignAlly = Grand_Country_Table["Country-" .. ForeignAllyTagTbl].ActCountry
				if ForeignAlly:IsFriend(ActTag, true) then									-- If we have common friends
				
				elseif ForeignAlly:IsEnemy(ActTag) then										-- Their ally is our enemy
				
				else																		-- Otherwise
				
				end
			end
		end








	end
	-- End of: Starting the checks

--Utils.LUA_DEBUGOUT("--1---RUCKSACK---AllCheck--Actag-: " .. tostring(ActTag) .. "---Zahl---" ..  tostring(Zahl))










	--return
end
