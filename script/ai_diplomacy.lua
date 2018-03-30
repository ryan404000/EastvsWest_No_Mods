-- ###############################################
-- ## "Otto's little helper" -East vs. West- Lua Diplomacy File
-- ## Created By: Chromos	Date: 16.11.2013
-- ## Modified By: Chromos	Date: 21.02.2014
-- ###############################################
require('utils')

function CalculateAlignmentFactor(voAI, country1, country2)
	local dist = voAI:GetCountryAlignmentDistance( country1, country2 ):Get()
	return math.min(dist / 400.0, 1.0)
end

function DiploScore_Negotiations(sumA, sumB, voActorTag, voRecipientTag)
	local score = 0
	if sumA > sumB then
		score = 100
	end
	return score	
end

function DiploScore_InviteToFaction(voAI, voActorTag, voRecipientTag, voObserverTag)
	local loActorCountry = voActorTag:GetCountry()
	local loRecipientCountry = voRecipientTag:GetCountry()
	local liScore = 0
	local lbCalculateScore = true
	
	-- The enemy of my enemy is my friend
	if loRecipientCountry:IsAtWar() then
		for loDiploStatus in loRecipientCountry:GetDiplomacy() do
			local loTarget = loDiploStatus:GetTarget()
			
			if loTarget:IsValid() and loDiploStatus:HasWar() then
				-- We both have a war with the same country
				if loActorCountry:GetRelation(loTarget):HasWar() then
					liScore = 100
					lbCalculateScore = false
					break
				end
			end					
		end
	end

	-- The higher their neutrality the more likely they will not get involved
	if lbCalculateScore then
		-- Calculate Neutrality
		local liNeutrality = loRecipientCountry:GetNeutrality():Get()
		
		if liNeutrality > 70 then
			liScore = ((100 - liNeutrality) / 2)
		elseif liNeutrality > 60 then
			liScore = 100 - liNeutrality
		else
			liScore = ((100 - liNeutrality) * 1.25)
		end
		
		-- Calculate Ideology
		local loActorGroup = loActorCountry:GetRulingIdeology():GetGroup()
		local loRecipientGroup = loRecipientCountry:GetRulingIdeology():GetGroup()

		-- Same ideology so a small bonus
		if loRecipientGroup == loActorGroup then
			liScore = liScore + 10
		else
			liScore = liScore - 20
		end		
			
		liScore = Utils.CallScoredCountryAI(voRecipientTag, 'DiploScore_InviteToFaction', liScore, voAI, voActorTag, voRecipientTag, voObserverTag)
	end
	
	-- these are usually pretty straight forward and annoying when ignored so we clamp upwards
	if liScore > 60 then
		liScore = 100
	elseif liScore < 20 then
		liScore = 0
	end
	
	return liScore
end

function DiploScore_NonAggression(voAI, voActorTag, voRecipientTag, voObserverTag)
	if voObserverTag == voActorTag then -- we demand nap with voRecipientTag
		return DiploScore_NonAggression(voAI, voRecipientTag, voActorTag, voObserverTag)
	else -- voActorTag demands nap with us
		local score = 0
		local rel = voAI:GetRelation(voRecipientTag, voActorTag)
		local relation = 100 + rel:GetValue():GetTruncated()
		
		if relation > 150 then -- we like them
			score = score + (relation - 150)
		elseif voAI:GetNumberOfOwnedProvinces(voActorTag) / 2 >
		       voAI:GetNumberOfOwnedProvinces(voRecipientTag) then -- much bigger than us
			score = score + 5 + relation / 5
		end
		
		local recipientCountry = voRecipientTag:GetCountry()
		local strategy = recipientCountry:GetStrategy()
		score = score + strategy:GetFriendliness(voActorTag) / 4
		score = score - strategy:GetAntagonism(voActorTag) / 4
		--score = score + strategy:GetThreat(voActorTag) / 4
		
		if not recipientCountry:IsNeighbour( voActorTag ) then
			score = score / 2
		end

		score = score - recipientCountry:GetDiplomaticDistance(voActorTag):GetTruncated() 
		--if score > 0 then
			--Utils.LUA_DEBUGOUT("NAP score: " .. score .. " for " .. tostring(voActorTag) .. " - " .. tostring(voRecipientTag) )
			--Utils.LUA_DEBUGOUT("friendlyness: " .. strategy:GetFriendliness(voActorTag) ) 
			--Utils.LUA_DEBUGOUT("antagonism: " .. strategy:GetAntagonism(voActorTag) ) 
			--Utils.LUA_DEBUGOUT("threat: " .. strategy:GetThreat(voActorTag) ) 
			--Utils.LUA_DEBUGOUT("d. dist: " ..  recipientCountry:GetDiplomaticDistance(voActorTag):GetTruncated() ) 
			--Utils.LUA_DEBUGOUT("------------------------")
		--end

		return Utils.CallScoredCountryAI(voRecipientTag, 'DiploScore_NonAggression', score, voAI, voActorTag, voRecipientTag, voObserverTag)
	end
end

function DiploScore_Alliance(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	if voObserverTag == voActorTag then 
       	local recipientCountry = voRecipientTag:GetCountry()
		local actorCountry = voActorTag:GetCountry()
		local strategy = actorCountry:GetStrategy()
		
		if recipientCountry:IsFactionLeader() then -- as a faction leader we dont want alliances, we want faction members
			return 0
		end

		
		local score = strategy:GetFriendliness(voRecipientTag)
		
		if score < 50 then
			score = 0
		end
		return score
	else 
		local rel = voAI:GetRelation(voRecipientTag, voActorTag)
		local relation = 200 + rel:GetValue():GetTruncated()
		
		if relation < 100 then
			return 0
		end
		
		local recipientCountry = voRecipientTag:GetCountry()
		local actorCountry = voActorTag:GetCountry()
		
		local score = relation / 12.0
		
		-- if vassal we always join
		if recipientCountry:GetOverlord() == voActorTag then
			return 100
		end
				
		if actorCountry:IsFactionLeader() then -- as a faction leader we dont want alliances, we want faction members
			return 0
		end
		
		-- check location
		if not recipientCountry:IsNeighbour(voActorTag) then
			-- check if on same continent first
			local recipientContinent = recipientCountry:GetActingCapitalLocation():GetContinent()
			local actorContinent = actorCountry:GetActingCapitalLocation():GetContinent()
			if not (recipientContinent == actorContinent) then
				score = score / 2
			end
		end
		
		-- check their wars
		if actorCountry:IsAtWar() then
			local bMutualEnemies = false
			for enemy in actorCountry:GetCurrentAtWarWith() do
				if recipientCountry:IsEnemy(enemy) then -- use threat as well?
					bMutualEnemies = true
				elseif recipientCountry:IsFriend(enemy, false) then
					return 0 -- fighting our friends
				end
			end
			
			if bMutualEnemies then
				score = score + 20
			else
				score = score / 2 -- better wait until they sorted their problems
			end
		end

		score = score - recipientCountry:GetDiplomaticDistance(voActorTag):GetTruncated() / 10

		local strategy = recipientCountry:GetStrategy()
		score = score + strategy:GetFriendliness(voActorTag) / 2
		score = score - strategy:GetAntagonism(voActorTag) / 2
		score = score - rel:GetThreat():Get() / 2
	

		score = Utils.CallScoredCountryAI(voRecipientTag, 'DiploScore_Alliance', score, voAI, voActorTag, voRecipientTag, voObserverTag, action)
		if score < 50 then
			score = 0
		end
		return score
	end
end

function CalculateWarDesirability(voAI, country, target)
	local score = 0
	local countryTag = country:GetCountryTag()
	local targetCountry = target:GetCountry()
	local strategy = country:GetStrategy()

	-- can we even declare war?
	if not voAI:CanDeclareWar( countryTag, target ) then
	  return 0
	end

	--Utils.LUA_DEBUGOUT("we can declare war: " .. tostring(minister:GetCountryTag()) .. " -> " .. tostring(target) )


	local antagonism = strategy:GetAntagonism(target);
	local friendliness = strategy:GetFriendliness(target);

	-- dont declare war on people we like
	if friendliness > 0 and antagonism < 1 then
		return 0
	end

	-- no suicide :S
	if country:GetNumberOfControlledProvinces() < targetCountry:GetNumberOfControlledProvinces() / 4 then
		return 0
	end

	-- watch out if we have bad intel, should be infiltrating more
	local intel = CAIIntel(countryTag, target)
	if intel:GetFactor() < 0.1 then
		return 0
	end

	-- compare military power
	local theirStrength = intel:CalculateTheirPercievedMilitaryStrengh()
	local ourStrength = intel:CalculateOurMilitaryStrength()
	local strengthFactor = ourStrength / theirStrength

	if strengthFactor < 1.0 then
		score = score - 75 * (1.0 - strengthFactor)
	else
		score = score + 20 * (strengthFactor - 1.0)
	end

	-- personality
	if strategy:IsMilitarist() then
		score = score * 1.3
	end
	
	return Utils.CallScoredCountryAI(countryTag, 'CalculateWarDesirability', score, voAI, country, target)

end

function DiploScore_PeaceAction(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	if voObserverTag == voActorTag then
		return 0
	else
		local score = 0


		local ActAI = voAI
		local ActorTag = voRecipientTag				-- switch for now, voRecipientTag is the country that is asked for peace(running this function)
		local ActTagTbl = tostring(voRecipientTag)
		local RecipientTag = voActorTag
		local RecipientTagTbl = tostring(RecipientTag)
		local ObserverTag = voObserverTag
		local action = action
		local ActCountry = ActorTag:GetCountry()
		
		-- Get actual data
		WarStatus(ActTagTbl)
		WarStatus(RecipientTagTbl)
		CountrySetup(RecipientTag)
		-- intel first
--Utils.LUA_DEBUGOUT("----------")
--Utils.LUA_DEBUGOUT("-Actor: " .. tostring(ActorTag) ..  "-Recipient: " .. tostring(RecipientTag) ..  "-Observer: " .. tostring(ObserverTag) ..  "-Action: " .. tostring(action))

		local Warscore = 0
		local Warscore2 = 0
		local Demands = 0
		local Relation = ActorTag:GetCountry():GetRelation(RecipientTag)
--Utils.LUA_DEBUGOUT("Relation: " .. Relation:GetValue())
		if (Relation:HasWar()) then
			local RelationWar = Relation:GetWar()
			Warscore = RelationWar:GetWarScore(ActorTag, RecipientTag)
			Warscore2 = RelationWar:GetWarScore(RecipientTag, ActorTag)
			Demands = ActorTag:GetCountry():GetPeaceTermTotalValue()
		end
--Utils.LUA_DEBUGOUT("Warscore: " .. Warscore)
--Utils.LUA_DEBUGOUT("Warscore2: " .. Warscore2)
--Utils.LUA_DEBUGOUT("Demand: " .. Demands)

		local GetRandom = math.random
		local RandNr = GetRandom(30)
		local WarTable = Grand_Diplomacy_Table["WarTable-" .. ActTagTbl]	
		local WarStat = WarTable.OverallWarStat
		local OurSurrenderlvl = ActorTag:GetCountry():GetSurrenderLevel():Get() * 100
		--local TheirSurrenderlvl = RecipientTag:GetCountry():GetSurrenderLevel():Get() * 100

--Utils.LUA_DEBUGOUT("-PeaceWanted-XXX--: " .. tostring(ActTag) .. " -Enemy " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].Enemy) .. " -WarProgress " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].WarProgress) .. " -MAX-Warscore " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].MaxWarscore) .. " -WarStart " ..  tostring(WarTable["EnemyCountry-" .. EnemyCountryTagTbl].WarStart))
		--local WarscorTbl = WarTable["EnemyCountry-" .. EnemyCountryTagTbl].MaxWarscore
		
		local WarTableRE = Grand_Diplomacy_Table["WarTable-" .. RecipientTagTbl]
		local WarscoreTblAC = WarTable["EnemyCountry-" .. RecipientTagTbl].ActWarscore
		local WarscoreTblRE = 0 --WarTableRE["EnemyCountry-" .. ActTagTbl].ActWarscore
--Utils.LUA_DEBUGOUT("WARSCORE CHECK Table:    Asking for Peace" .. tostring(RecipientTag) .. " with Warscore unknown for now  " .. " To Country(us)" .. tostring(ActorTag) .. " with Warscore " .. tostring(WarscoreTblAC))
		local PeaceWanted =  WarStat.PeaceWanted
		if (OurSurrenderlvl > 33) then
			if PeaceWanted == 1 then																	-- but we win currently! No peace for now!
				score = 0
			elseif PeaceWanted == 2 then																-- static
				--if RandNr > 50 then																		-- 50/50 chance for peace
					score = 100
				--end
			elseif PeaceWanted == 3 then																-- we loose.. - >Peace please..
				--if RandNr > 5 then																		-- little random
					score = 100
				--end
			end
		elseif (OurSurrenderlvl > 75) then
			if PeaceWanted == 1 then																	-- but we win currently! No peace for now!
				score = 0
			elseif PeaceWanted == 2 then																-- static
				--if RandNr > 5 then																		-- big chance for peace
					score = 100
				--end
			elseif PeaceWanted == 3 then																-- we loose.. - >Peace please..
				--if RandNr > 5 then																		-- little random
					score = 100
				--end
			end
		else																							-- make war, not peace
			score = 0
		end
		-- end of: if (OurSurrenderlvl < 33) then
		local TotalActualProvincesCounter = 0
		for ControlledProvinceID in ActCountry:GetOwnedProvinces() do
			TotalActualProvincesCounter = TotalActualProvincesCounter + 1
		end
		if (TotalActualProvincesCounter < 2) then
			PeaceWanted = 3
			score = 100
		end
		if (Demands > Warscore2) then
			score = score - 1000
		end
--Utils.LUA_DEBUGOUT("Peace Score: " .. score .. "PeaceWanted: " .. tostring(PeaceWanted) .. " MaxWarscoreTag: " .. tostring(WarStat.MaxWarscoreTag) .. " MaxWarscore: " .. tostring(WarStat.MaxWarscore)  )
--Utils.LUA_DEBUGOUT("Diplomacy: Asking for Peace " .. tostring(RecipientTag) .. " with Warscore " .. tostring(Warscore2) .. " To Country(us) " .. tostring(ActorTag) .. " with Warscore " .. tostring(WarscoreTblAC) .. " Peace Score: " .. score .. " PeaceWanted: " .. tostring(PeaceWanted))

		--score = 100
		return score
	end
end

function DiploScore_SendExpeditionaryForce(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	if voObserverTag == voActorTag then
		return 0 
	else
		local  score = 0
		-- do we want to accept?
		local recipientCountry = voRecipientTag:GetCountry()
		if recipientCountry:GetDailyBalance( CGoodsPool._SUPPLIES_ ):Get() > 1.0 then
			-- maybe we have enough stockpiles
			local supplyStockpile = recipientCountry:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
			local weeksSupplyUse = recipientCountry:GetDailyExpense( CGoodsPool._SUPPLIES_ ):Get() * 7
			if supplyStockpile > weeksSupplyUse * 20.0 then
				score = score + 70
			elseif supplyStockpile > weeksSupplyUse * 10.0 then
				score = score + 40
			end
			
			if recipientCountry:IsAtWar() then
				score = score + 20
			else
				score = 0 -- no war, no need for troops
			end
		end
		return score
	end
end

function DiploScore_LicenceTechnology(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	if voObserverTag == voActorTag then
		return 0 
	else
		--Utils.LUA_DEBUGOUT("LICENS ------------------------------")
		if not action:GetSubunit() then
			return 0
		end
	
		local score = 0
		local actorCountry = voActorTag:GetCountry()
		local recipientCountry = voRecipientTag:GetCountry()
		local rel = voAI:GetRelation(voRecipientTag, voActorTag)
		
		if rel:GetValue():GetTruncated() < 0 then
			return 0
		end
		
		if rel:HasWar() then
			return 0
		end
		--Utils.LUA_DEBUGOUT("1 LICENS " .. tostring(voActorTag) .. " -> " ..  tostring(voRecipientTag) .. " = " .. score)
		-- we can give tech to
		-- - people in faction
		-- - people in alliance
		-- - people fighting our enemies
		-- - people close in triangle (not far away! scale price here too)
		local allied = false
		if ( recipientCountry:HasFaction() and recipientCountry:GetFaction() == actorCountry:GetFaction() ) then
			score = score + 70
			allied = true
		elseif rel:HasAlliance() then
			score = score + 60
			allied = true
		end
		--Utils.LUA_DEBUGOUT("2 LICENS " .. tostring(voActorTag) .. " -> " ..  tostring(voRecipientTag) .. " = " .. score)
		local fightingFriend = false
		local fightingEnemy = false
		if actorCountry:IsAtWar() then
			for enemy in actorCountry:GetCurrentAtWarWith() do
				if recipientCountry:IsEnemy(enemy) then
					--Utils.LUA_DEBUGOUT("mutual enemy: " .. tostring(enemy) .. " for " ..  tostring(voActorTag) .. " and " . .tostring(voRecipientTag))
					fightingEnemy = true
					--Utils.LUA_DEBUGOUT("mutual enemy")
				elseif recipientCountry:IsFriend(enemy, true)
				and voAI:GetRelation(enemy, voActorTag):GetValue():GetTruncated() > 20
				then
					fightingFriend = true
				end
			end
		end
		
		if fightingFriend then
			return 0
		end
		--Utils.LUA_DEBUGOUT("3 LICENS " .. tostring(voActorTag) .. " -> " ..  tostring(voRecipientTag) .. " = " .. score)
		if fightingEnemy then
			if not allied then
				score = 20 -- need some base
			end
			score = score + 30
			--Utils.LUA_DEBUGOUT("fightingenemy")
		else
			--Utils.LUA_DEBUGOUT("factor: " .. CalculateAlignmentFactor(voAI, actorCountry, recipientCountry) * 50)
			score = score - CalculateAlignmentFactor(voAI, actorCountry, recipientCountry) * 50
			
		end
		--Utils.LUA_DEBUGOUT("4 LICENS " .. tostring(voActorTag) .. " -> " ..  tostring(voRecipientTag) .. " = " .. score)
		local threat = rel:GetThreat():Get()
		score = score - threat * CalculateAlignmentFactor(voAI, actorCountry, recipientCountry)
		--Utils.LUA_DEBUGOUT("5 LICENS " .. tostring(voActorTag) .. " -> " ..  tostring(voRecipientTag) .. " = " .. score)
		-- consider the money
		local offeredMoney = action:GetMoney():Get()
		local moneyPile = math.max( recipientCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get(), 100.0)
		if offeredMoney > moneyPile * 0.3 then
			score = score + 30
		elseif offeredMoney > moneyPile * 0.2 then
			score = score + 20
		elseif offeredMoney > moneyPile * 0.1 then
			score = score + 10
		elseif offeredMoney < moneyPile * 0.03 then
			score = score - 30
		else
			score = score - 15
		end
		
		--Utils.LUA_DEBUGOUT("6 LICENS " .. tostring(voActorTag) .. " -> " ..  tostring(voRecipientTag) .. " = " .. score)
		--Utils.LUA_DEBUGOUT("LICENS ------------------------------")
		return score
	end
end

function DiploScore_CallAlly(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	if voObserverTag == voActorTag then
		return 100
	else
		local actorCountry = voActorTag:GetCountry()
		local recipientCountry = voRecipientTag:GetCountry()
		local liScore = 0
		
		if actorCountry:GetFaction() == recipientCountry:GetFaction() then
			liScore = 100
		elseif recipientCountry:GetOverlord() == voActorTag then
			liScore = 100
		else
			if DiploScore_Alliance(voAI, voActorTag, voRecipientTag, voObserverTag, nil) < 50 then
				liScore = 40
			else
				liScore = 100
			end
		end
		
		return Utils.CallScoredCountryAI(voActorTag, "DiploScore_CallAlly", liScore, voAI, voActorTag, voRecipientTag, voObserverTag)
	end
end

-- #######################
-- Military Access
-- #######################
function DiploScore_DemandMilitaryAccess(voAI, voActorTag, voRecipientTag, voObserverTag)
	local liScore = Generate_MilitaryAccess_Score(voAI, voActorTag, voRecipientTag, voObserverTag)
	
	if liScore > 0 then
		-- Same as Offer but reverse the voActorTag and voRecipientTag
		liScore = Utils.CallScoredCountryAI(voRecipientTag, "DiploScore_DemandMilitaryAccess", liScore, voAI, voActorTag, voRecipientTag, voObserverTag)			
	end

	return liScore
end
function DiploScore_OfferMilitaryAccess(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	-- voAI never offers military Access so its always 0
	local liScore = Generate_MilitaryAccess_Score(voAI, voActorTag, voRecipientTag, voObserverTag)
	
	if liScore > 0 then
		-- Same as Demand but reverse the voActorTag and voRecipientTag
		liScore = Utils.CallScoredCountryAI(voRecipientTag, "DiploScore_OfferMilitaryAccess", liScore, voAI, voRecipientTag, voActorTag, voObserverTag)			
	end

	return liScore	
end
function Generate_MilitaryAccess_Score(voAI, voActorTag, voRecipientTag, voObserverTag)
	local liScore = 0
	local loRelation = voAI:GetRelation(voRecipientTag, voActorTag)
	
	-- If they are atwar with eachother this is impossible
	if not(loRelation:HasWar()) then
		local loRecipientCountry = voRecipientTag:GetCountry()
		
		-- If they are in a faction then exit
		if not(loRecipientCountry:HasFaction()) then
			local loActorCountry = voActorTag:GetCountry()
			local lbMajorNeighborCheck = false
			local loRecipientGroup = loRecipientCountry:GetRulingIdeology():GetGroup()
			local loActorGroup = loActorCountry:GetRulingIdeology():GetGroup()
		
			-- Same ideology so a small bonus
			if loRecipientGroup == loActorGroup then
				liScore = liScore + 25
			else
				liScore = liScore - 10
			end
			
			-- Check to see who they are after, if it is another major do not get involved
			for loCountryTag in loRecipientCountry:GetNeighbours() do
				local loRelation2 = voAI:GetRelation(voActorTag, loCountryTag)
				
				if loRelation2:HasWar() then
					local loCountry2 = loCountryTag:GetCountry()
					if loCountry2:IsMajor() then
						lbMajorNeighborCheck = true
						liScore = liScore - 25
						break
					end
				end
			end
			
			-- They are after a minor so go ahead and give them a small bonus
			if not(lbMajorNeighborCheck) then
				liScore = liScore + 25
			end

			-- Calculate strength based on IC
			--   The smaller the minor the more likely they will say yes
			local liRecipientIC = loRecipientCountry:GetMajorRating():Get()
			local liActorIC = loActorCountry:GetMajorRating():Get()
			
			if liActorIC > (liRecipientIC * 7) then
				liScore = liScore + 25
			elseif liActorIC > (liRecipientIC * 5) then
				liScore = liScore + 10
			elseif liActorIC > (liRecipientIC * 3) then
				liScore = liScore + 5
			end

			-- If they are heavily neutral then don't let them through
			local liEffectiveNeutrality = loRecipientCountry:GetEffectiveNeutrality():Get()
			if liEffectiveNeutrality > 90 then
				liScore = liScore - 50
			elseif liEffectiveNeutrality > 80 then
				liScore = liScore - 25
			elseif liEffectiveNeutrality > 70 then
				liScore = liScore - 10
			end
			
			-- Now Calculate Threat and Relations into the score
			liScore = liScore - loRelation:GetThreat():Get() / 5
			liScore = liScore + loRelation:GetValue():GetTruncated() / 3
		end
	end
	
	return liScore
end
-- #######################

-- ############################
--  Methods that do not use the GetAIAcceptance()
-- ############################
function DiploScore_InfluenceNation(voAI, voActorTag, voRecipientTag, voObserverTag)
	if voObserverTag == voActorTag then
		local liScore = 500
	
		local recipientCountry = voRecipientTag:GetCountry()
		local actorCountry = voActorTag:GetCountry()
		local actorFaction = actorCountry:GetFaction()
		
		-- Performance Check, are they already in our corner if so exit out do not influence
		if voAI:GetCountryAlignmentDistance(recipientCountry, actorFaction:GetFactionLeader():GetCountry()):Get() < 10 then
			return 0
		end
		
		-- Calculate Importance based on IC
		---   Remember on Majors can Influence
		local maxIC = recipientCountry:GetMaxIC()
		local ourMaxIC = actorCountry:GetMaxIC()
		if maxIC > ourMaxIC then
			liScore = liScore + 70
		elseif maxIC > ourMaxIC * 0.5 then
			liScore = liScore + 40
		elseif maxIC > ourMaxIC * 0.3 then
			liScore = liScore + 30
		elseif maxIC > ourMaxIC * 0.2 then
			liScore = liScore + 20
		elseif maxIC > ourMaxIC * 0.1 then
			liScore = liScore + 10
		elseif maxIC > ourMaxIC * 0.05 then
			liScore = liScore + 5
		end
		
		-- factor neutrality
		if actorCountry:IsAtWar() then
			local effectiveNeutrality = recipientCountry:GetEffectiveNeutrality():Get()
			if effectiveNeutrality > 90 then
				liScore = liScore - 100
			elseif effectiveNeutrality > 80 then
				liScore = liScore - 70
			elseif effectiveNeutrality > 70 then
				liScore = liScore - 10
			elseif effectiveNeutrality < defines.diplomacy.JOIN_FACTION_NEUTRALITY + 10 then
				liScore = liScore + 50
			end
		end
		
		-- Political checks
		local loRelation = voAI:GetRelation(voActorTag, voRecipientTag)
		--local loStrategy = voRecipientTag:GetCountry():GetStrategy()
		
		--liScore = liScore - loStrategy:GetAntagonism(voActorTag) / 15			
		--liScore = liScore + loStrategy:GetFriendliness(voActorTag) / 10
		liScore = liScore - loRelation:GetThreat():Get() / 5
		liScore = liScore + loRelation:GetValue():GetTruncated() / 3
		
		if loRelation:IsGuaranteed() then
			liScore = liScore + 10
		end
		if loRelation:HasFriendlyAgreement() then
			liScore = liScore + 10
		end
		if loRelation:AllowDebts() then
			liScore = liScore + 5
		end
		if actorCountry:IsNeighbour(voRecipientTag) then
			liScore = liScore + 50
		elseif recipientCountry:GetActingCapitalLocation():GetContinent() == actorCountry:GetActingCapitalLocation():GetContinent() then
			liScore = liScore + 40
		end
		if Utils.IsFriend(voAI, actorCountry:GetFaction(), recipientCountry) then
			liScore = liScore + 20
		else
			liScore = liScore - 20
		end
		if recipientCountry:IsMajor() then
			liScore = liScore + 10
		end
		if recipientCountry:HasNeighborInFaction(actorFaction) then
			liScore = liScore + 20
		end
		if recipientCountry:GetRulingIdeology():GetGroup() ~= actorCountry:GetRulingIdeology():GetGroup() then
			liScore = liScore - 15
		else
			liScore = liScore + 15
		end		
		
		return Utils.CallScoredCountryAI(voActorTag, 'DiploScore_InfluenceNation', liScore, voAI, voActorTag, voRecipientTag, voObserverTag)
	else
		return 100 -- we cant respond to this
	end
end
function DiploScore_Embargo(voAI, voActorTag, voRecipientTag, voObserverTag)
	if voObserverTag == voActorTag then
		local score = 0
		local actorCountry = voActorTag:GetCountry() 
		local recipientCountry = voRecipientTag:GetCountry() 

		if actorCountry:IsAtWar() then
			for enemy in actorCountry:GetCurrentAtWarWith() do
				if voRecipientTag:GetCountry():IsFriend(enemy, true) then
					--Utils.LUA_DEBUGOUT( "embargo score " .. tostring(voActorTag) .. " -> " .. tostring(voRecipientTag) .. " = " .. 100 )
					return 80 -- fighting our friends
				end
			end
		end
		--Utils.LUA_DEBUGOUT( "embargo score " .. tostring(voActorTag) .. " -> " .. tostring(voRecipientTag) .. " = " .. score )
		-- dont use up the last of our points for this
		if actorCountry:GetDiplomaticInfluence():Get() < (defines.diplomacy.EMBARGO_DIPLO_COST + 2) then
			score = score / 2 - 1
		end
		--Utils.LUA_DEBUGOUT( "embargo score " .. tostring(voActorTag) .. " -> " .. tostring(voRecipientTag) .. " = " .. score )
		return Utils.CallScoredCountryAI(voActorTag, 'DiploScore_Embargo', score, voAI, voActorTag, voRecipientTag, voObserverTag)
	else
		return 0 -- cant respond to this action
	end
end
function DiploScore_Guarantee(voAI, voActorTag, voRecipientTag, voObserverTag)
	local score = 0

	if voObserverTag == voActorTag then
		local actorCountry = voActorTag:GetCountry()
		local recipientCountry = voRecipientTag:GetCountry()
		if actorCountry:HasFaction() and actorCountry:GetFaction() == recipientCountry:GetFaction() then
			return 0 -- pointless
		end
		
		if actorCountry:IsGovernmentInExile() then
			return 0 -- pointless
		end
		
		local strategy = voActorTag:GetCountry():GetStrategy()
		score = score + strategy:GetFriendliness(voRecipientTag) / 2
		score = score + strategy:GetProtectionism(voRecipientTag)
		score = score - strategy:GetAntagonism(voRecipientTag) / 2
		score = score - voActorTag:GetCountry():GetDiplomaticDistance(voRecipientTag):GetTruncated() 
		
	end

	score = Utils.CallScoredCountryAI(voActorTag, 'DiploScore_Guarantee', score, voAI, voActorTag, voRecipientTag, voObserverTag)
	return score
end
function DiploScore_Debt(voAI, voActorTag, voRecipientTag, voObserverTag)
	local actorCountry = voActorTag:GetCountry()
	local recipientCountry = voRecipientTag:GetCountry()
	
	if voObserverTag == voActorTag then
		if recipientCountry:IsAtWar() 
		and ( recipientCountry:HasFaction() and recipientCountry:GetFaction() == actorCountry:GetFaction() )
		then
			if actorCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get() < 10 
			and actorCountry:GetDailyBalance(CGoodsPool._MONEY_):Get() < 0
			then 
				return 100
			else
				return 0
			end
		else
			return 0
		end
	else
		if recipientCountry:IsAtWar() 
		and ( recipientCountry:HasFaction() and recipientCountry:GetFaction() == actorCountry:GetFaction() )
		then
			local recipientMoney = recipientCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()
			local actorMoney = actorCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()
			if (recipientMoney * 5 > actorMoney) 
			and (recipientMoney > 200) then 
				return 100
			else
				return 0
			end
		else
			return 0
		end
	end
end
function DiploScore_BreakAlliance(voAI, voActorTag, voRecipientTag, voObserverTag)
	local liScore = 0

	if voActorTag == voObserverTag then
		local actorCountry = voActorTag:GetCountry()
		local recipientCountry = voRecipientTag:GetCountry()
		local loStrategy = actorCountry:GetStrategy()

		local loRealtions = actorCountry:GetRelation(voRecipientTag)
		local liRealtionValue = loRealtions:GetValue():GetTruncated()

		local liThreat = loRealtions:GetThreat():Get() * CalculateAlignmentFactor(voAI, actorCountry, recipientCountry)
		local liAntagonism = loStrategy:GetAntagonism(voRecipientTag) / 4
		local liFriendliness = loStrategy:GetFriendliness(voRecipientTag) / 4

		liScore = ((liAntagonism + liThreat) / 2.0) - liFriendliness
		liScore = liScore - liRealtionValue / 2.0
	end
	
	return liScore
end

function DiploScore_CallToArms(voAI, voActorTag, voRecipientTag, voObserverTag)
	local liScore = 100

	return liScore
end
