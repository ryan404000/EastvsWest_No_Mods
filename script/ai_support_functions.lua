local P = {}
Support = P

function P.Home_Spies_Interventionist(minister)
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local liNationalUnity = ministerCountry:GetNationalUnity():Get()
	local liNeutrality = ministerCountry:GetNeutrality():Get()
	local liPartyPopularity = ministerCountry:AccessIdeologyPopularity():GetValue(ministerCountry:GetRulingIdeology()):Get()

	local newMission
	local command
	local lbHasBadSpies = false
	
	-- Calculate spies in country
	for loCountry in ministerCountry:GetSpyingOnUs() do
		local loSpyPresence = loCountry:GetCountry():GetSpyPresence(ministerTag)
		local loSpyMission = loSpyPresence:GetMission()
		
		if loSpyMission == SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY  
			or loSpyMission == SpyMission.SPYMISSION_DISRUPT_RESEARCH
			or loSpyMission == SpyMission.SPYMISSION_DISRUPT_PRODUCTION
			or loSpyMission == SpyMission.SPYMISSION_SUPPORT_RESISTANCE then
			
			lbHasBadSpies = true
			break
		end
	end	

	if not(ministerCountry:IsAtWar()) then
		-- Counter Espionage check
		if lbHasBadSpies then 
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		
		-- First Law Pass
		elseif liNeutrality > 65 then
			newMission = SpyMission.SPYMISSION_LOWER_NEUTRALITY
		elseif liNationalUnity < 60 then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY
			
		-- Second Law Pass
		elseif liNeutrality > 60 then
			newMission = SpyMission.SPYMISSION_LOWER_NEUTRALITY
		elseif liNationalUnity < 70 then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY

		-- Final Law
		elseif liNeutrality > 55 then
			newMission = SpyMission.SPYMISSION_LOWER_NEUTRALITY
			
		-- Support for our party is diminishing so raise it
		elseif liPartyPopularity < 35 then
			newMission = SpyMission.SPYMISSION_BOOST_RULING_PARTY
		
		else
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		end
	else
		-- Make sure we are not close to surrendering
		if ( liNationalUnity < 70) then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY
		
		-- Bad Spies present so get rid of them
		elseif lbHasBadSpies then 
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE

		-- Support for our party is diminishing so raise it
		elseif liPartyPopularity < 35 then
			newMission = SpyMission.SPYMISSION_BOOST_RULING_PARTY
			
		-- Having nothing else better to do
		elseif ( liNationalUnity < 90) then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY
			
		-- Nothing to do so Counter
		else
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		end	
	end
	
	return newMission
end

function P.Build_Fort(ic, minister, viProvinceID, viMax, vbGoOver)
	local ministerTag = minister:GetCountryTag()
	local land_fort = CBuildingDataBase.GetBuilding( "land_fort" )
	local loProvince = CCurrentGameState.GetProvince(viProvinceID)
	local loBuilding = loProvince:GetBuilding(land_fort)

	if loBuilding:GetMax():Get() <= viMax and loProvince:GetCurrentConstructionLevel(land_fort) == 0 then
		local land_fortCost = ministerTag:GetCountry():GetBuildCost(land_fort):Get()
		
		if (ic - land_fortCost) >= 0 or vbGoOver then
			local constructCommand = CConstructBuildingCommand( ministerTag, land_fort, viProvinceID, 1 )
			
			if constructCommand:IsValid() then
				minister:GetOwnerAI():Post( constructCommand )
				ic = ic - land_fortCost -- Upodate IC total
			end
		end
	end
	
	return ic
end

function P.Build_AirBase(ic, minister, viProvinceID, viMax, vbGoOver)
	local ministerTag = minister:GetCountryTag()
	local air_base = CBuildingDataBase.GetBuilding("air_base")
	local loProvince = CCurrentGameState.GetProvince(viProvinceID)
	local loBuilding = loProvince:GetBuilding(air_base)

	if loBuilding:GetMax():Get() <= viMax and loProvince:GetCurrentConstructionLevel(air_base) == 0 then
		local land_fortCost = ministerTag:GetCountry():GetBuildCost(air_base):Get()
		
		if (ic - land_fortCost) >= 0 or vbGoOver then
			local constructCommand = CConstructBuildingCommand( ministerTag, air_base, viProvinceID, 1 )
			
			if constructCommand:IsValid() then
				minister:GetOwnerAI():Post( constructCommand )
				ic = ic - land_fortCost -- Upodate IC total
			end
		end
	end
	
	return ic
end

return Support