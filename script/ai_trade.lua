-----------------------------------------------------------
-- LUA East vs. West Trade File
-- Created By: 
-- Modified By: 
-- Date Last Modified: 
-----------------------------------------------------------

-- ######################
-- Global Variables
--    CAREFUL: Variables are remembered from country to country
-- ######################

local liMinimumTrade = 0.25
local liMoneyBuffer = 0.10
local liResourceBuffer = 1
local liCrudeBuffer = 10 

local _MONEY_ = 1
local _METAL_ = 2
local _ENERGY_ = 3
local _RARE_MATERIALS_ = 4
local _CRUDE_OIL_ = 5
local _SUPPLIES_ = 6
local _FUEL_ = 7	

local laCrossValue = {
	CGoodsPool._MONEY_,
	CGoodsPool._METAL_,
	CGoodsPool._ENERGY_,
	CGoodsPool._RARE_MATERIALS_,
	CGoodsPool._CRUDE_OIL_,
	CGoodsPool._SUPPLIES_,
	CGoodsPool._FUEL_
}

--[[
local laCrossName = {
	"CGoodsPool._MONEY_",
	"CGoodsPool._METAL_",
	"CGoodsPool._ENERGY_",
	"CGoodsPool._RARE_MATERIALS_",
	"CGoodsPool._CRUDE_OIL_",
	"CGoodsPool._SUPPLIES_",
	"CGoodsPool._FUEL_"
} 
--]]


-- ###########################
-- Called by the EXE and handles the Analyzing of offered trades
-- ###########################
function DiploScore_OfferTrade(ai, actor, recipient, observer, voTradeAction, voTradedFrom, voTradedTo)
	local liScore = 0
	local loTradeRoute = voTradeAction:GetRoute()
	local loBuyerTag
	local loSellerTag
	local loBuyerCountry = nil
	local loSellerCountry = nil
	local liMoney
	local laResourceRequested = {}
	local lbFreeTrader = false
	
	-- These two variables are only used if Free Trading
	--   this is typicaly Commiterm only
	local liFromCount = 0
	local liToCount = 0
	
	-- Commiterm Check
	if ai:CanTradeFreeResources(actor, recipient) then
		local liFromCount = voTradedFrom.vMetal + voTradedFrom.vEnergy + voTradedFrom.vRareMaterials + voTradedFrom.vCrudeOil + voTradedFrom.vSupplies + voTradedFrom.vFuel
		local liToCount = voTradedTo.vMetal + voTradedTo.vEnergy + voTradedTo.vRareMaterials + voTradedTo.vCrudeOil + voTradedTo.vSupplies + voTradedTo.vFuel
	
		lbFreeTrader = true
	end
	
	-- Two way trade get out!
	if voTradedTo.vMoney > 0 and voTradedFrom.vMoney > 0 then
		return liScore
		
	-- 0 cost trade but make sure they are not Commiterm
	elseif voTradedTo.vMoney == 0 and voTradedFrom.vMoney == 0 and not(lbFreeTrader) then
		return liScore
		
	elseif (voTradedTo.vMoney > 0)
	or (lbFreeTrader and liFromCount > 0 and liToCount <= 0) then
		-- Get the Money amount
		liMoney = voTradedTo.vMoney
		
		laResourceRequested = SetupResourceArray(voTradedFrom)
		loBuyerTag = loTradeRoute:GetTo()
		loSellerTag = loTradeRoute:GetFrom()
		loBuyerCountry = loBuyerTag:GetCountry()
		loSellerCountry = loSellerTag:GetCountry()
		
	else
		-- Get the Money amount
		liMoney = voTradedFrom.vMoney
		
		laResourceRequested = SetupResourceArray(voTradedTo)
		loBuyerTag = loTradeRoute:GetFrom()
		loSellerTag = loTradeRoute:GetTo()
		loBuyerCountry = loBuyerTag:GetCountry()
		loSellerCountry = loSellerTag:GetCountry()
	end
	
	local lbConvoyNeeded = loBuyerCountry:NeedConvoyToTradeWith(loSellerTag)

	-- We need transports to trade
	if lbConvoyNeeded then
		if loBuyerCountry:GetTransports() == 0 then
			return liScore
		end
	end
	
	local loRelation = ai:GetRelation(loBuyerTag, loSellerTag)
	
	if not(lbFreeTrader) then
		if loRelation:AllowDebts() then
			lbFreeTrader = true
		end
	end
	
	-- Based on what type of sell it is call a different method.
	---  This score is purely based on the raw trade itself and has nothing to do with relations.
	if actor == loSellerTag then
		liScore = BuyResources(ai, lbFreeTrader, loBuyerTag, loBuyerCountry, loSellerTag, laResourceRequested, liMoney)
	else
		liScore = SellResources(ai, lbFreeTrader, loBuyerTag, loSellerTag, loSellerCountry, laResourceRequested, liMoney)
	end
		
	-- Now shift the score based on Diplomatic relations!
	if liScore > 0 then
		-- Political checks
		local loStrategy = loSellerTag:GetCountry():GetStrategy()
		
		liScore = liScore - loStrategy:GetAntagonism(loBuyerTag) / 15			
		liScore = liScore + loStrategy:GetFriendliness(loBuyerTag) / 10
		liScore = liScore - loRelation:GetThreat():Get() / 5
		liScore = liScore + tonumber(tostring(loRelation:GetValue():GetTruncated())) / 3
		
		if loRelation:IsGuaranteed() then
			liScore = liScore + 5
		end
		if loRelation:HasFriendlyAgreement() then
			liScore = liScore + 10
		end
		if loRelation:IsFightingWarTogether() then
			liScore = liScore + 15
		end

		if loBuyerCountry:IsNeighbour(loSellerTag) then
			liScore = liScore + 15
		elseif loSellerCountry:GetActingCapitalLocation():GetContinent() == loBuyerCountry:GetActingCapitalLocation():GetContinent() then
			liScore = liScore + 10
		end
		
		if Utils.IsFriend(ai, loBuyerCountry:GetFaction(), loSellerCountry) then
			liScore = liScore + 5
		end
		
		-- Land Route gets bigger bonus
		if not(lbConvoyNeeded) then
			liScore = liScore + 5
		end
	end
	
	if liScore > 0 then
		liScore = Utils.CallScoredCountryAI(recipient, "DiploScore_OfferTrade", liScore, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	end
	
	return liScore
end

function SetupResourceArray(voTrade)
	local laResourceRequested = {}
	
	laResourceRequested[_MONEY_] = 0
	laResourceRequested[_METAL_] = voTrade.vMetal
	laResourceRequested[_ENERGY_] = voTrade.vEnergy
	laResourceRequested[_RARE_MATERIALS_] = voTrade.vRareMaterials
	laResourceRequested[_CRUDE_OIL_] = voTrade.vCrudeOil
	laResourceRequested[_SUPPLIES_] = voTrade.vSupplies
	laResourceRequested[_FUEL_] = voTrade.vFuel

	return laResourceRequested
end

function SellResources(ai, vbFreeTrader, voBuyerTag, voSellerTag, voSellerCountry, vaResourceRequested, viMoney)
	local liScore = 0
	local lbExit = false
	local lbResourceShortCount = 0		
	local liQuantityTrade = 0
	
	-- These Variables only get set if needed
	local loTradeFor = voSellerCountry:GetTradedForSansAlliedSupply()
	local loMinisterPool = nil

	-- First figure out what we have in excess of
	--   Negative numbers in the array means we have a surplus that is home produced (not traded for except for money)	
	local laSellerResources = {0,0,0,0,0,0,0}
	
	-- Figure out Short Count for the person getting the goods
	laSellerResources[_MONEY_] = Need_Resource_Check(voSellerCountry, laCrossValue[_MONEY_], true)
	laSellerResources[_METAL_] = Need_Resource_Check(voSellerCountry, laCrossValue[_METAL_], true)
	laSellerResources[_ENERGY_] = Need_Resource_Check(voSellerCountry, laCrossValue[_ENERGY_], true)
	laSellerResources[_RARE_MATERIALS_] = Need_Resource_Check(voSellerCountry, laCrossValue[_RARE_MATERIALS_], true)

	-- Figure out if the Seller is short on resources
	--  Only count Energy, Metal and Rare
	for i = _METAL_, _RARE_MATERIALS_ do
		if laSellerResources[i] > 0 then
			lbResourceShortCount = lbResourceShortCount + 1
		end
	end		
	
	for i = _METAL_, _FUEL_ do
		-- Get the total, it is used later for calculating score
		liQuantityTrade = liQuantityTrade + vaResourceRequested[i]

		if vaResourceRequested[i] > 0 then
			-- Performance: Load the resource information
			if i > _RARE_MATERIALS_ then
				laSellerResources[i] = Need_Resource_Check(voSellerCountry, laCrossValue[i], true)
			end
		
			-- The Buyer is already trading away this resource so we do not want to buy it
			if loTradeFor:GetFloat(laCrossValue[i]) > 0 then
				lbExit = true
				break
							
			-- If we are short on resources and cash offer to sell supplies
			elseif i == _SUPPLIES_ and laSellerResources[i] >= 0 and lbResourceShortCount > 0 and laSellerResources[_MONEY_] >= -0.5 then
				-- Change it to a negative number so the AI will sell supplies
				--   use your own daily expenses divide it in half as the max amount your willing to sell
				laSellerResources[_SUPPLIES_] = ((voSellerCountry:GetDailyExpense(CGoodsPool._SUPPLIES_):Get() / 2) * -1)
				
			-- Strange when you multiply 0 by -1 causes thi condition not to be true
			elseif vaResourceRequested[i] > (laSellerResources[i] * -1) or laSellerResources[i] == 0 then
				lbExit = true
				break
				
			-- Seller has a large selling pile so extra score Negative numbers mean surplus
			elseif laSellerResources[i] < -10 then
				liScore = liScore + 10
			end
		end
	end				
	
	-- Trade so far looks good now check the money part
	if not(lbExit) then
		-- Setup Base Good Trade value
		liScore = liScore + 50
		
		-- Free stuff who cares about cost
		if vbFreeTrader then
			liScore = liScore + 100
		end
					
		-- Economic checks
		if liScore > 0 then
			-- Fuel is precious don't sell
			if vaResourceRequested[_FUEL_] > 0 then
				-- Check to see if Crude got loaded as it may not have been loaded earlier
				if laSellerResources[_CRUDE_OIL_] == 0 then
					laSellerResources[_CRUDE_OIL_] = Need_Resource_Check(voSellerCountry, laCrossValue[_CRUDE_OIL_], true)
				end
			
				if loMinisterPool == nil then
					loMinisterPool = voSellerCountry:GetPool()
				end
			
				local liCrudeHomeProduced = voSellerCountry:GetHomeProduced():Get(laCrossValue[_CRUDE_OIL_]):Get()
				local liPool = loMinisterPool:GetFloat(laCrossValue[_FUEL_])
				
				-- Don't have the crude to really cover the fuel conversion
				if laSellerResources[_CRUDE_OIL_] > 0 
				or (liCrudeHomeProduced == 0 and liPool < 35000) then
					liScore = 0
				
				-- I am producing less excess crude than what I am build in excess fuel
				elseif (laSellerResources[_CRUDE_OIL_] * -1) < vaResourceRequested[_FUEL_] then
					liScore = liScore - 10
				-- They want fuel so small hit
				else
					liScore = liScore - 5
				end
			
			-- Supplies is a home produced good make sure you really want to sell it
			elseif vaResourceRequested[_SUPPLIES_] > 0 then
				-- Resource short country consider trading away supplies
				--    check to make sure they are short on money to, if not dont trade away supplies
				--    could be they are still try to find someone to buy stuff from
				---   Positive Money means they are short on it
				if lbResourceShortCount >= 2 and laSellerResources[_MONEY_] >= -0.5 then
					liScore = liScore + 20
				elseif lbResourceShortCount >= 2 and laSellerResources[_MONEY_] >= -1.5 then
					liScore = liScore + 15
				elseif lbResourceShortCount >= 1 or laSellerResources[_MONEY_] >= 0 then
					liScore = liScore + 10
				else -- Not a resource short country dont trade supplies
					liScore = liScore - 40
				end
				
			-- Countries that have a large amount of Crude to trade are willing to trade it away
			elseif vaResourceRequested[_CRUDE_OIL_] > 0 then
				local liCrudeHomeProduced = voSellerCountry:GetHomeProduced():Get(CGoodsPool._CRUDE_OIL_):Get()
				
				if liCrudeHomeProduced == 0 then
					liScore = 0
				elseif liCrudeHomeProduced > vaResourceRequested[_CRUDE_OIL_] then
					liScore = liScore - 5
				end
				
			end	
		end
		
		-- Secondary score increases are apart from primary incase 0 is set
		if liScore > 0 then
			-- More resources involved the more likely it will accept the trade
			liScore = liScore + (liQuantityTrade * 0.5)
			
			-- Seller is short on something so bigger bonus to sell
			--    Multiply by 5 for each resource short (max bonus 15)
			liScore = liScore + (5 * lbResourceShortCount)
		end
	end
	
	return liScore
end
function BuyResources(ai, vbFreeTrader, voBuyerTag, voBuyerCountry, voSellerTag, vaResourceRequested, viMoney)
	local liScore = 0
	local lbExit = false
	local liQuantityTrade = 0
	local loTradeAway = voBuyerCountry:GetTradedAwaySansAlliedSupply()

	-- First figure out what we have in excess of
	--   Negative numbers in the array means we have a surplus that is home produced (not traded for except for money)	
	--   Names kepted seperately so its easier to track through the code
	local laBuyerResources = {0,0,0,0,0,0,0}
	
	-- Flag indicating if the human player is trying to sell to the AI
	local lbResourceShortCount = 0		

	-- Figure out Short Count for the person getting the goods
	-- Only setup the buyers Resource if the other side is selling to me
	laBuyerResources[_MONEY_] = Need_Resource_Check(voBuyerCountry, laCrossValue[_MONEY_], true)
	laBuyerResources[_METAL_] = Need_Resource_Check(voBuyerCountry, laCrossValue[_METAL_], true)
	laBuyerResources[_ENERGY_] = Need_Resource_Check(voBuyerCountry, laCrossValue[_ENERGY_], true)
	laBuyerResources[_RARE_MATERIALS_] = Need_Resource_Check(voBuyerCountry, laCrossValue[_RARE_MATERIALS_], true)
	
	for i = _METAL_, _RARE_MATERIALS_ do
		if laBuyerResources[i] > 0 then
			lbResourceShortCount = lbResourceShortCount + 1
		end				
	end
	
	for i = _METAL_, _FUEL_ do
		-- Get the total, it is used later for calculating score
		liQuantityTrade = liQuantityTrade + vaResourceRequested[i]

		if vaResourceRequested[i] > 0 then
			-- Performance: Load the resource information
			if i > _RARE_MATERIALS_ then
				laBuyerResources[i] = Need_Resource_Check(voBuyerCountry, laCrossValue[i], true)
			end
		
			-- The Buyer is already trading away this resource so we do not want to buy it
			if loTradeAway:GetFloat(laCrossValue[i]) > 0 then
				lbExit = true
				break
		
			-- Since the loop has already passed Energy, Metal and Rares we can add the supply check here
			--   this is to encourage the AI to sell supplies even if it has a negative balance.
			elseif i == _SUPPLIES_ and lbResourceShortCount == 0 then
				-- If the country is not having resource problems consider making them buy supplies
				--    if they have a surplus in cash and still using sliders for supplies
				local liNeededSupplySlider = voBuyerCountry:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_SUPPLY_):GetNeeded():Get()
				
				-- Negative numbers means we have a surplus
				if laBuyerResources[_SUPPLIES_] <= 0 and liNeededSupplySlider > 0 then
					laBuyerResources[_SUPPLIES_] = voBuyerCountry:GetDailyExpense(CGoodsPool._SUPPLIES_):Get()
				end
				
			-- Strange when you multiply 0 by -1 causes this condition not to be true
			elseif vaResourceRequested[i] <= (laBuyerResources[i] * -1) or laBuyerResources[i] == 0 then
				lbExit = true
				break
			end
		end
	end				
	
	-- Trade so far looks good now check the money part
	if not(lbExit) then
		-- Setup Base Good Trade value
		liScore = liScore + 50
		
		-- Free stuff who cares about cost
		if vbFreeTrader then
			liScore = liScore + 100
			
		-- Human player trying to sell to the AI
		else
			if (laBuyerResources[_MONEY_] * -1) <= viMoney then
				liScore = 0
			end
		end
		
		-- Economic checks
		if liScore > 0 then
			-- Fuel is precious don't sell
			if vaResourceRequested[_FUEL_] > 0 then
				-- He is selling me less than or what I need
				if (laBuyerResources[_FUEL_] * -1) <= vaResourceRequested[_FUEL_] then
					liScore = liScore + 10
					
				-- I do not need fuel
				else
					liScore = 0
				end
			
			-- Supplies is a home produced good make sure you really want to sell it
			elseif vaResourceRequested[_SUPPLIES_] > 0 then
				-- Resource short country will be very much against buying supplies
				if lbResourceShortCount >= 2 then
					liScore = 0
					
				elseif lbResourceShortCount == 1 then
					liScore = liScore - 10
				else -- Not a resource short country so buying supplies is ok
					liScore = liScore + 10
				end
				
			-- Countries that have a large amount of Crude to trade are willing to trade it away
			elseif vaResourceRequested[_CRUDE_OIL_] > 0 then
				liScore = liScore + 5
			end	
		end
		
		-- Secondary score increases are apart from primary incase 0 is set
		if liScore > 0 then
			-- More resources involved the more likely it will accept the trade
			liScore = liScore + (liQuantityTrade * 0.5)
			
			-- Seller is short on something so bigger bonus to sell
			--    Multiply by 5 for each resource short (max bonus 15)
			liScore = liScore + (5 * lbResourceShortCount)
		end		
	end
	
	return liScore
end

-- ###########################
-- Called by the EXE 
-- ###########################
function EvalutateExistingTrades(ai, ministerTag)
	local ministerCountry = ministerTag:GetCountry()
	
	local laDailyBalances = {}
	local laResouceExcess = {}
	
	-- Performance: Only set if needed
	local loMinisterPool = ministerCountry:GetPool()
	local loTradeFor = ministerCountry:GetTradedForSansAlliedSupply()
	
	local bWeLackCash = false
	
	if loMinisterPool:GetFloat( CGoodsPool._MONEY_ ) < 20 then
		bWeLackCash = true
	end
	
	-- Figure out if we have a glutten of resources coming in
	for i = _METAL_, _CRUDE_OIL_ do
		laDailyBalances[i] = ministerCountry:GetDailyBalance(laCrossValue[i]):Get()
		
		if laDailyBalances[i] > 5 or (bWeLackCash and laDailyBalances[i] > 1) then
			local liPool = loMinisterPool:GetFloat(laCrossValue[i])
			local liTradedFor = loTradeFor:GetFloat(laCrossValue[i])

			-- Check to see if we have an excessive stockpile
			if liTradedFor > 0 and liPool > 30000 then
				table.insert(laResouceExcess, i)
			elseif bWeLackCash and liTradedFor > 0 and liPool > 1000 then
				-- emergency. time to cut some trades
				table.insert(laResouceExcess, i)
			end
		end
	end

	for loTradeRoute in ministerCountry:AIGetTradeRoutes() do
		if loTradeRoute:IsInactive() and ai:HasTradeGoneStale(loTradeRoute) then
			local loFromTag = loTradeRoute:GetFrom()
			local loToTag = loTradeRoute:GetTo()
			local loCountryTag
			if loFromTag == ministerTag then
				loCountryTag = loToTag
			else
				loCountryTag = loFromTag
			end
			local loTradeAction = CTradeAction(ministerTag, loCountryTag)
			loTradeAction:SetRoute(loTradeRoute)
			loTradeAction:SetValue(false)
			if loTradeAction:IsSelectable() then
				ai:PostAction(loTradeAction)
			end
		-- Do we have any resources that we are hoarding
		---   and if we are and trading for them lets get rid of the trades
		elseif table.getn(laResouceExcess) > 0 then
			
			local loFromTag = loTradeRoute:GetFrom()
			local loToTag = loTradeRoute:GetTo()
			
			local loCountryTag
			local loMinisterIsFrom = false
			
			if loFromTag == ministerTag then
				loCountryTag = loToTag
				loMinisterIsFrom = true
			else
				loCountryTag = loFromTag
			end
			
			for i = 1, table.getn(laResouceExcess) do
				local liResouces
				
				--  If we are From we want the To variable etc...
				if loMinisterIsFrom then
					liResouces = loTradeRoute:GetTradedToOf(laCrossValue[laResouceExcess[i]]):Get()
				else
					liResouces = loTradeRoute:GetTradedFromOf(laCrossValue[laResouceExcess[i]]):Get()
				end
				
				-- Are we actually trading this away?
				if liResouces > 0 then
					if liResouces < laDailyBalances[laResouceExcess[i]] then
						local loTradeAction = CTradeAction(ministerTag, loCountryTag)
						loTradeAction:SetRoute(loTradeRoute)
						loTradeAction:SetValue(false)
						if loTradeAction:IsSelectable() then
							ai:PostAction(loTradeAction)
							table.remove(laResouceExcess, i) -- only one at a time
							break 
						end
					end
				end
			end -- for table.getn(laResouceExcess)
		end
	end -- for trade routes	
end

-- ###########################
-- Called by the EXE to propose new trades
-- ###########################
function ProposeTrades(ai, ministerTag)
	local ministerCountry = ministerTag:GetCountry()
	local laResourceNeeds = {}
	
	
	-- First figure out what we need of each type
	--   Negative numbers in the array means we have a surplus that is home produced (not traded for except for money)	
	laResourceNeeds[_MONEY_] = Need_Resource_Check(ministerCountry, laCrossValue[_MONEY_], false)
	laResourceNeeds[_METAL_] = Need_Resource_Check(ministerCountry, laCrossValue[_METAL_], false)
	laResourceNeeds[_ENERGY_] = Need_Resource_Check(ministerCountry, laCrossValue[_ENERGY_], false)
	laResourceNeeds[_RARE_MATERIALS_] = Need_Resource_Check(ministerCountry, laCrossValue[_RARE_MATERIALS_], false)
	laResourceNeeds[_CRUDE_OIL_] = Need_Resource_Check(ministerCountry, laCrossValue[_CRUDE_OIL_], false)
	laResourceNeeds[_SUPPLIES_] = Need_Resource_Check(ministerCountry, laCrossValue[_SUPPLIES_], false)
	laResourceNeeds[_FUEL_] = Need_Resource_Check(ministerCountry, laCrossValue[_FUEL_], false)
	
	local locTransAction = nil
	local loTransAction
	local licChance = 0
	local liChance
	local liResourceShortCount = 0
	local liMaxArray = _FUEL_
	
	local loTradeAway = ministerCountry:GetTradedAwaySansAlliedSupply()
	local loTradeFor = ministerCountry:GetTradedForSansAlliedSupply()
	local loMinisterPool = ministerCountry:GetPool()
	
	
	-- Check to see if we need to cancel anything
	for i = _METAL_, _FUEL_ do
		-- First see if we can solve our problem by cancelling old trades
		--    also if the trade exceeds 50 then change it to 50
		if loTradeAway:GetFloat(laCrossValue[i]) > 0 then
			-- Special rules for supplies to help prevent selling and buying at the same time!
			if i == _SUPPLIES_ and laResourceNeeds[_SUPPLIES_] > 0 then
				local liSevenWeekSupplyUse = ministerCountry:GetDailyExpense(laCrossValue[_SUPPLIES_]):Get() * 7
				local liStockPile = loMinisterPool:GetFloat(laCrossValue[_SUPPLIES_])
				
				if liSevenWeekSupplyUse > liStockPile then
					laResourceNeeds[_SUPPLIES_] = ai:EvaluateCancelTrades( laResourceNeeds[_SUPPLIES_], laCrossValue[_SUPPLIES_] )
				else
					laResourceNeeds[_SUPPLIES_] = 0
				end
			elseif laResourceNeeds[i] > 0 then
				laResourceNeeds[i] = ai:EvaluateCancelTrades( laResourceNeeds[i], laCrossValue[i] )
			end
		end
		
		-- Trades have a 50 max cap (just like a human)
		if laResourceNeeds[i] > 50 then
			laResourceNeeds[i] = 50
		end

		-- Figure out if the AI has a real resource problem and if so do not buy supplies, crude or fuel
		--   till you get your resource issues settled
		if i <= _RARE_MATERIALS_ and laResourceNeeds[i] > 0 then
			liResourceShortCount = liResourceShortCount + 1
			liMaxArray = _RARE_MATERIALS_
		elseif laResourceNeeds[i] > 0 then
			liResourceShortCount = liResourceShortCount + 1
		end
	end
	-- End of check	
		
	-- Do we have money to use for trading
	--   Negative number means I have a surplus
	if laResourceNeeds[_MONEY_] < 0 then
		local liSupplyTradeAway = ministerCountry:GetTradedAwaySansAlliedSupply():GetFloat(laCrossValue[_SUPPLIES_])
		
		-- If the country is not having resource problems consider making them buy supplies
		--    if they have a surplus in cash and still using sliders for supplies
		if liMaxArray == _FUEL_ and liSupplyTradeAway == 0 then
			local liNeededSupplySlider = ministerCountry:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_SUPPLY_):GetNeeded():Get()
			
			-- Negative numbers means we have a surplus
			if laResourceNeeds[_SUPPLIES_] <= 0 and liNeededSupplySlider > 0 then
				laResourceNeeds[_SUPPLIES_] = ministerCountry:GetDailyExpense(CGoodsPool._SUPPLIES_):Get()
				
				if laResourceNeeds[_SUPPLIES_] > 50 then
					laResourceNeeds[_SUPPLIES_] = 50
				end
				liResourceShortCount = liResourceShortCount + 1 -- Make sure it is atleast one so it goes into main loop
			end
		end
		
		if liResourceShortCount > 0 then
			for loTCountry in CCurrentGameState.GetCountries() do
				-- Make sure its not the same country
				local loTradeToTag = loTCountry:GetCountryTag()
				
				if not(loTradeToTag == ministerTag) then
					if not(ministerCountry:HasDiplomatEnroute(loTradeToTag)) and loTCountry:Exists() then
					
						-- Now loop throught each resource to see if this country can do something
						for i = _METAL_, liMaxArray do
							if laResourceNeeds[i] >= liMinimumTrade then
								loTransAction, liChance = SetupBuyTrade(ai, ministerTag, loTCountry, laResourceNeeds[i], laCrossValue[i], laResourceNeeds[_MONEY_])

								-- Get the best chance for trade to succeed
								if not(loTransAction == nil) then
									-- Pool Check
									--    if the pool is less than 50 be desperate to find this resource above others
									if loMinisterPool:GetFloat(laCrossValue[i]) < 500 then
										liChance = liChance + 100
									end
									
									-- Give it a small random chance
									if (liChance * (math.random(100, 110) * .01)) >  licChance then
										locTransAction = loTransAction
										licChance = liChance
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	-- Here starts the selling code
	local liResourceExcess = false
	for i = _METAL_, _RARE_MATERIALS_ do
		if loTradeFor:GetFloat(laCrossValue[i]) == 0 then	
			if laResourceNeeds[i] < 0 then
				liResourceExcess = true
				
				if laResourceNeeds[i] < -50 then
					laResourceNeeds[i] = -50
				end
			end
		end
	end
	
	if liResourceExcess then
		for loTCountry in CCurrentGameState.GetCountries() do
			local loTradeToTag = loTCountry:GetCountryTag()
			
			if not(loTradeToTag == ministerTag) then
				if not(ministerCountry:HasDiplomatEnroute(loTradeToTag)) and loTCountry:Exists() then
					for i = _METAL_, _RARE_MATERIALS_ do
						if laResourceNeeds[i] < 0
						and  loTradeFor:GetFloat(laCrossValue[i]) == 0 then
						
							loTransAction, liChance = SetupSellTrade(ai, ministerTag, loTCountry, laResourceNeeds[i], laCrossValue[i])

							-- Get the best chance for trade to succeed
							if not(loTransAction == nil) then
								-- Give it a small random chance
								if (liChance * (math.random(100, 110) * .01)) >  licChance then
									locTransAction = loTransAction
									licChance = liChance
								end
							end
						end
					end
				end
			end
		end
	end
	-- End of Selling Code
	
	if not(locTransAction == nil) then
		ai:PostAction(locTransAction)
	end
end

-- #######################
-- Setup Trades that we need
-- #######################
function SetupBuyTrade(ai, FromTag, voTCountry, viQuantity, voResourceType, viMoney)

	-- If we can free trade then set it up no matter what
	if FreeTradeCheck(ai, FromTag, voTCountry:GetCountryTag(), nil) then
		viMoney = -999
	end
	
	local liResouce = Need_Resource_Check(voTCountry, voResourceType, true)
	
	-- Negative numbers means they have a surplus
	if liResouce < 0 and (liResouce * -1) >= liMinimumTrade then
		local ToTag = voTCountry:GetCountryTag()
		
		local loTradeAction = CTradeAction( FromTag, ToTag )
		local liRequested = math.min(viQuantity, (liResouce * -1))
		
		loTradeAction:SetTrading( CFixedPoint(liRequested), voResourceType )
		
		if not(ai:AlreadyTradingDisabledResource(loTradeAction:GetRoute())) then
			if loTradeAction:IsValid() and loTradeAction:IsSelectable() then
				local liCost = loTradeAction:GetTrading( CGoodsPool._MONEY_, FromTag ):Get()
				local liSpamPenalty = ai:GetSpamPenalty(ToTag)
				local liChance = loTradeAction:GetAIAcceptance() - liSpamPenalty

				-- Negative is a surplus positive number
				if liCost <= (viMoney * -1) and liChance > 50 then
					return loTradeAction, liChance
					
				elseif liChance > 50 then
					-- First setup a fake trade to get the multiplier
					loTradeAction = CTradeAction( FromTag, ToTag )
					loTradeAction:SetTrading( CFixedPoint(1), voResourceType )
					local liMultiplier = loTradeAction:GetTrading( CGoodsPool._MONEY_, FromTag ):Get()
					
					-- Figure out what we can afford
					--     Negative is a surplus positive number
					liRequested = tonumber(tostring((viMoney * -1) / liMultiplier))
					
					if liRequested >= liMinimumTrade then
						-- Now Setup the real trade
						loTradeAction = CTradeAction( FromTag, ToTag )
						loTradeAction:SetTrading( CFixedPoint(liRequested), voResourceType )
						
						-- Recalculate Chance
						liChance = loTradeAction:GetAIAcceptance() - liSpamPenalty
						
						if liChance > 50 then
							return loTradeAction, liChance
						end
					end
				end
			end
		end
	end

	return nil, 0
end

function SetupSellTrade(ai, FromTag, voTCountry, viQuantity, voResourceType)
	local liResouce = Need_Resource_Check(voTCountry, voResourceType, true)
	local liQuantity =  math.max(viQuantity, (liResouce * -1)) 
	local liMoney

	-- If we can free trade then set it up no matter what
	if FreeTradeCheck(ai, voTCountry:GetCountryTag(), FromTag, nil) then
		liMoney = -999
	else
		liMoney = Need_Resource_Check(voTCountry, laCrossValue[_MONEY_], false)
	end
	
	-- Resource is negative number so we must invert to compare it to Minmum trade
	if liMoney < 0 and (liQuantity * -1) >= liMinimumTrade then
		local ToTag= voTCountry:GetCountryTag()
		
		local loTradeAction = CTradeAction( FromTag, ToTag )
		loTradeAction:SetTrading( CFixedPoint(liQuantity), voResourceType )
		
		if not(ai:AlreadyTradingDisabledResource(loTradeAction:GetRoute())) then
			if loTradeAction:IsValid() and loTradeAction:IsSelectable() then
				local liCost = loTradeAction:GetTrading( CGoodsPool._MONEY_, ToTag ):Get()
				local liSpamPenalty = ai:GetSpamPenalty(ToTag)
				local liChance = loTradeAction:GetAIAcceptance() - liSpamPenalty
				
				-- Negative is a surplus positive number
				if liCost <= (liMoney * -1) and liChance > 50 then
					return loTradeAction, liChance
					
				elseif liChance > 50 then
					-- First setup a fake trade to get the multiplier
					loTradeAction = CTradeAction( FromTag, ToTag )
					loTradeAction:SetTrading( CFixedPoint(1), voResourceType )
					local liMultiplier = loTradeAction:GetTrading( CGoodsPool._MONEY_, ToTag ):Get()
					
					-- Figure out what we can afford
					--     Negative is a surplus positive number
					liQuantity = tonumber(tostring((liMoney * -1) / liMultiplier))
					
					if liQuantity >= liMinimumTrade then
						-- Now Setup the real trade
						loTradeAction = CTradeAction( FromTag, ToTag )
						loTradeAction:SetTrading( CFixedPoint((liQuantity * -1)), voResourceType )
						
						-- Recalculate Chance
						liChance = loTradeAction:GetAIAcceptance() - liSpamPenalty
						
						if liChance > 50 then
							return loTradeAction, liChance
						end
					end			
				end
			end
		end
	end
	
	return nil, 0
end

-- #######################
-- End Setup Trades that we need
-- #######################

-- Returns how many of the specified resource the AI needs
--   this is calculated after cancelling trades that the AI had giving the resource away
function Need_Resource_Check(ministerCountry, voResourceType, vbCancelOveride)
	-- Money is not really home produced so dump it out right away
	if voResourceType == CGoodsPool._MONEY_ then
		return (((ministerCountry:GetDailyBalance(voResourceType):Get()) - liMoneyBuffer) * -1)
	end

	local loResource = CResourceValues()
	
	loResource:GetResourceValues(ministerCountry, voResourceType)
	
	local liDailyBalance = loResource.vDailyBalance
	local liDailyExpense = loResource.vDailyExpense
	local liDailyHome = Utils.CalculateHomeProduced(loResource)
	local liDailyIncome = loResource.vDailyIncome
	local liPool = loResource.vPool
	local liActualBuffer = liResourceBuffer
	local lbLargeEconomy = (ministerCountry:GetTotalIC() > 50) -- Tells us if they are a strong country or not
	
	if voResourceType == CGoodsPool._CRUDE_OIL_ then
		-- They have a large base of IC so more than likely need fuel
		if lbLargeEconomy then
			liActualBuffer = liCrudeBuffer
		end
	end
	
	-- Process it if the daily balance meets conditions
	--   AI will always try and strive to have a small increase on each resource
	if liDailyBalance < liActualBuffer and not(vbCancelOveride) then
		-- Now check to make sure the reservers are not high, if so no need to panick yet as it could just be a blip
		if (liPool > 25000 and not(lbLargeEconomy)) or (liPool > 50000 and lbLargeEconomy) then
			return 0
		elseif voResourceType == CGoodsPool._CRUDE_OIL_ then
			local loFuel = CResourceValues()
			loFuel:GetResourceValues(ministerCountry, CGoodsPool._FUEL_)
		
			-- Ignore the crude negative due to conversion as long as we have some reserve
			if (liDailyBalance * -1) <= loFuel.vDailyIncome and loFuel.vDailyBalance > 0 and loFuel.vPool > 5000 then
				return 0
			end
		elseif voResourceType == CGoodsPool._FUEL_ then
			local loCrued = CResourceValues()
			loCrued:GetResourceValues(ministerCountry, CGoodsPool._CRUDE_OIL_)
		
			-- Our crude is in the positive so ignore the fuel shortage as long as we have some reserve
			if loCrued.vDailyBalance > 0 and liPool > 5000 then
				return 0
			end
		end
	end

	-- If our Pool is to small there is a potenital our resources are being reported in positive when
	--   they really are negative
	if liPool < 100 or liDailyExpense > liDailyIncome then
		return (liDailyExpense - liDailyIncome + liActualBuffer)

	-- Check to see if we have resources to trade away
	--    if so make them negative numbers and don't trade away more than what we really have home produced
	elseif liDailyBalance > liActualBuffer and liDailyHome > liDailyExpense then
		-- If the Daily Home is very close to the daily Expense the nubmers may invert
		--    causing the AI to think it needs to buy rather than sell.
		return math.min(0, (liDailyHome - liDailyExpense - liActualBuffer) * -1)

	-- We have a surplus but it is being generated by trade not by home produced resources
	---  Exclude supplies
	elseif liDailyBalance > liActualBuffer and not(voResourceType == laCrossValue[_SUPPLIES_]) then
		return 0
		
	-- We have a simple negative balance so just return it
	else
		return ((liDailyBalance - liActualBuffer) * -1)
	end
end

function FreeTradeCheck(voAI, voBuyerTag, voSellerTag, voRelation)
	-- If relation object is nil then create it
	if voRelation == nil then
		voRelation = voAI:GetRelation(voBuyerTag, voSellerTag)
	end

	-- Commiterm Check or ALlow Debt check
	if voAI:CanTradeFreeResources(voSellerTag, voBuyerTag) or voRelation:AllowDebts() then
		return true
	else
		return false
	end
end