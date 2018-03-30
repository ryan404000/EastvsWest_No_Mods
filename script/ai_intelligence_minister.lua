-----------------------------------------------------------
-- LUA East vs. West Spy File
-- Created By: 
-- Modified By: 
-- Date Last Modified: 
-----------------------------------------------------------

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function IntelligenceMinister_Tick(minister)
	if math.mod( CCurrentGameState.GetAIRand(), 9) == 0 then
		local ministerTag = minister:GetCountryTag()
		local ministerCountry = minister:GetCountry()
		local loAI = minister:GetOwnerAI() 
		ManageSpiesAtHome(loAI, minister, ministerTag, ministerCountry)
		ManageSpiesAbroad(loAI, minister, ministerTag, ministerCountry)
	end
end

function ManageSpiesAtHome(voAI, minister, ministerTag, ministerCountry)
	local domesticSpyPresence = ministerCountry:GetSpyPresence( ministerTag )
	local currentMission = domesticSpyPresence:GetMission()
	local newMission

	-- Default is more of an isolationist perspective
	if Utils.HasCountryAIFunction(minister:GetCountryTag(), "Home_Spies") then
		newMission = Utils.CallCountryAI(minister:GetCountryTag(), "Home_Spies", minister)				
	else
		local lbHasBadSpies = false
		local liNationalUnity = ministerCountry:GetNationalUnity():Get()
		local liNeutrality = ministerCountry:GetNeutrality():Get()
		local lsFaction = tostring(ministerCountry:GetFaction():GetTag()) 
		local liPartyPopularity = ministerCountry:AccessIdeologyPopularity():GetValue(ministerCountry:GetRulingIdeology()):Get()
		
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
	
		-- Raise our unity so we dont surrender so easy and can get special laws past
		if liNationalUnity < 70 then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY
		
		-- Counter Espionage check
		elseif lbHasBadSpies then 
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		
		-- Support for our party is diminishing so raise it
		elseif liPartyPopularity < 35 then
			newMission = SpyMission.SPYMISSION_BOOST_RULING_PARTY
		
		-- If not Communist lower neutrality if your not at war
		--   if you are Communist no need to lower it once it hits 70
		elseif (not(ministerCountry:IsAtWar()) and lsFaction ~= "comintern")
		or (lsFaction == "comintern" and liNeutrality > 70) then
			newMission = SpyMission.SPYMISSION_LOWER_NEUTRALITY
			
		-- Nothing really to do but our unity is not 90 so raise it
		elseif liNationalUnity < 90 then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY

		-- If there is nothing else to do just counter		
		else
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		end
	end
	
	-- Assign the mission
	if not (currentMission == newMission) then
		voAI:Post(CChangeSpyMission( ministerTag, ministerTag, newMission ))
	end
	
	-- Always set your home priority to the highest
	if domesticSpyPresence:GetPriority() < CSpyPresence.MAX_SPY_PRIORITY then
		--voAI:Post(CChangeSpyPriority( ministerTag, ministerTag, CSpyPresence.MAX_SPY_PRIORITY ))
	end
end

function ManageSpiesAbroad(voAI, minister, ministerTag, ministerCountry)
	local nSpyWeight = 0
	
	--Utils.LUA_DEBUGOUT("Country: " .. tostring(ministerTag))
	local ministerFaction = ministerCountry:GetFaction()
	local ministerIsMajor = ministerCountry:IsMajor()
	local ministerContinent = ministerCountry:GetActingCapitalLocation():GetContinent()
	local currentDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
	
	for loTCountry in CCurrentGameState.GetCountries() do
		if loTCountry:Exists() then
			-- Make sure its not the same country
			local voTargetTag = loTCountry:GetCountryTag()
		
			if voTargetTag ~= ministerTag then
				--Utils.LUA_DEBUGOUT("Inside")
				local SpyPresence = ministerCountry:GetSpyPresence(voTargetTag)
				local isAlly = ministerCountry:CalculateIsAllied(voTargetTag)
				
				-- If they are allies just go to the next country
				if isAlly == false then
					local cRelation = ministerCountry:GetRelation(voTargetTag)
					local isFriend = Utils.IsFriend(voAI, ministerFaction, loTCountry)
					local isNeighbor = false
					local isInfluencing = false
					
					nSpyWeight = 0

					-- Only Major Powers can influence
					if ministerIsMajor then
						isInfluencing = voAI:IsInfluencing(ministerTag, voTargetTag)
						
						-- If we are influencing them add a + 1
						if isInfluencing then
							nSpyWeight = nSpyWeight + 1
						end
					end
					
					-- if its a neighbor always give them level 1 spy
					if ministerCountry:IsNeighbour(voTargetTag) and not isFriend then
						isNeighbor = true
						nSpyWeight = nSpyWeight + 1
					end

					-- If its another major power and not a friend
					---   Mainly covers situations when USA invades France then Germany will increase 
					---   it spies priority in the USA from 1 to a 2 as they would be neighbors then.
					if ministerIsMajor and loTCountry:IsMajor() and not isFriend then
						nSpyWeight = nSpyWeight + 1
					end
					
					-- if they are on the same continent proceed
					if ministerContinent == loTCountry:GetActingCapitalLocation():GetContinent() then
						-- If they are not a friend add another weight
						if not isFriend then
							nSpyWeight = nSpyWeight + 1
						end
						
						-- If we are atwar with them
						if cRelation:HasWar() then
							nSpyWeight = nSpyWeight + 1
						end
					end
					
					nSpyWeight = math.min( nSpyWeight, CSpyPresence.MAX_SPY_PRIORITY )

					-- If prio changes then update it
					if SpyPresence:GetPriority() ~= nSpyWeight then
						local command = CChangeSpyPriority( ministerTag, voTargetTag, nSpyWeight )
						voAI:Post( command )
					end
					
					-- If there is no weight set then we do not want to disrupt relations with them
					if nSpyWeight == 0 then
						--Grab what the current mission is
						if SpyPresence:GetMission() ~= SpyMission.SPYMISSION_NONE then
							local missionCommand = CChangeSpyMission( ministerTag, voTargetTag, SpyMission.SPYMISSION_NONE )
							voAI:Post( missionCommand )
						end
					else
						local nMission = PickBestMission(voAI, SpyPresence, cRelation, isFriend, isNeighbor, isInfluencing, loTCountry, ministerCountry, currentDays )
						
						--Grab what the current mission is
						if nMission and SpyPresence:GetMission() ~= nMission then
							local missionCommand = CChangeSpyMission( ministerTag, voTargetTag, nMission )
							voAI:Post( missionCommand )
						end
					end
				else
					-- We are allies set the priority to 0
					if SpyPresence:GetPriority() > 0 then
						local command = CChangeSpyPriority( ministerTag, voTargetTag, 0 )
						voAI:Post( command )
					end

					-- If we haven't already set it to counter espionage just in case we do have spies in there still.
					if SpyPresence:GetMission() ~= SpyMission.SPYMISSION_COUNTER_ESPIONAGE then
						local missionCommand = CChangeSpyMission( ministerTag, voTargetTag, SpyMission.SPYMISSION_COUNTER_ESPIONAGE )
						--voAI:Post( missionCommand )
					end
				end
			end
		end
	end
end

function PickBestMission(voAI, SpyPresence, cRelation, isFriend, isNeighbor, isInfluencing, voTCountry, ministerCountry, currentDays )
	local nMission = nil

	if ministerCountry:IsGovernmentInExile() then
		local capitalController = ministerCountry:GetCapitalLocation():GetController()
		
		-- They control our capital
		if capitalController == voTCountry:GetCountryTag() then
			nMission = SpyMission.SPYMISSION_SUPPORT_RESISTANCE
		else
			nMission = SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY
		end
	else
		-- Are the two countries NOT at war
		if not cRelation:HasWar() then
			local LastMissionDate = SpyPresence:GetLastMissionChangeDate()
			LastMissionDate:AddDays(60)

			-- If the missions is more than 60 days old change it
			if LastMissionDate:GetTotalDays() >= currentDays and not (SpyPresence:GetMission() == SpyMission.SPYMISSION_NONE)  then
				nMission = SpyPresence:GetMission()
			else
				-- We are influencing them so assist that with our spies
				if isInfluencing then
					nMission = SpyMission.SPYMISSION_BOOST_OUR_PARTY
				else
					-- We are not at war with each other so only pick passive spy missions
					local RandomMission = math.random(4)
				
					if RandomMission == 1 then
						nMission = SpyMission.SPYMISSION_MILITARY
					elseif RandomMission == 2 then
						nMission = SpyMission.SPYMISSION_TECH
					elseif RandomMission == 3 then
						nMission = SpyMission.SPYMISSION_POLITICAL
					elseif RandomMission == 4 then
						nMission = SpyMission.SPYMISSION_BOOST_OUR_PARTY
					end
				end
			end
		-- The two countries are at war
		else
			-- If we are neighbors and they are close to surrendering
			if isNeighbor and ( voTCountry:GetSurrenderLevel():Get() > 0.6 ) then
				nMission = SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY
			
			-- Pick a random mission then
			else
				local LastMissionDate = SpyPresence:GetLastMissionChangeDate()
				LastMissionDate:AddDays(60)
				
				-- If the missions is more than 60 days old change it
				if LastMissionDate:GetTotalDays() >= currentDays and not (SpyPresence:GetMission() == SpyMission.SPYMISSION_NONE)  then
					nMission = SpyPresence:GetMission()
				else
					local RandomMission = math.random(5)
									
					if RandomMission == 1 then
						nMission = SpyMission.SPYMISSION_MILITARY
					elseif RandomMission == 2 then
						nMission = SpyMission.SPYMISSION_TECH
					elseif RandomMission == 3 then
						nMission = SpyMission.SPYMISSION_POLITICAL
					elseif RandomMission == 4 then
						nMission = SpyMission.SPYMISSION_DISRUPT_RESEARCH
					elseif RandomMission == 5 then
						nMission = SpyMission.SPYMISSION_DISRUPT_PRODUCTION
					end
				end
			end
		end
	end

	return nMission
end

