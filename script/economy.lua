-----------------------------------------------------------
-- LUA East vs. West New Economy and Population File
-- Created By: 
-- Modified By: 
-- Date Last Modified: 
-----------------------------------------------------------
--local POP_GROWTH = 0.02
local DEATH_RATE = 0.001
local STEPSIZE = 5 -- must be same as in population_templates.txt granularity
local TIMEBASE = 1/12-- one month - 1 year / 12 months
local NSTEPSIZE = -5
local BABY=0.0501
local MAX_AGE=85

-- unused, moved to exe. above pop variables moved to defines.lua
function GetNextTimePopulation(PopulationPyramid,POP_GROWTH)
	total = PopulationPyramid:GetTotalPopulation()
	epidemic = PopulationPyramid:GetEpidemic()
	k = 0.6
	ageData = PopulationPyramid:GetAgeData()
	for j=MAX_AGE,1,NSTEPSIZE do
		currVal = ageData:GetAt(j/STEPSIZE - 1)
		nextVal = ageData:GetAt(j/STEPSIZE)
		i = currVal/STEPSIZE * TIMEBASE
		ageData:SetAt(j/STEPSIZE, nextVal + i)
		ageData:SetAt(j/STEPSIZE - 1, currVal - i)
	end
	for j=MAX_AGE,1,NSTEPSIZE do
		i = j
		epVal = i/100 * PopulationPyramid:GetEpidemic()
		val = ageData:GetAt(j/STEPSIZE) * (1 - (epVal + k) * TIMEBASE)
		ageData:SetAt(j/STEPSIZE, val)
		k = k * 0.6
	end
	workers = PopulationPyramid:GetWorkers()
	val = workers * (BABY + POP_GROWTH * 40 * POP_GROWTH + POP_GROWTH * 1.35) * TIMEBASE
	currVal = ageData:GetAt(0)
	ageData:SetAt(0, val + currVal)
end

function fixed_min(fixed_first, fixed_second)
	if (fixed_first < fixed_second) then
		return fixed_first
	else
		return fixed_second
	end
end

function GetTaxesInfluence(tax_slider_percent, min_val)
	local tax_inc = tax_slider_percent + 1.4
	local tax_div = tax_slider_percent / 20
	local tax_log = tax_inc:Log() * 35
	local tax_exp = tax_div
	tax_exp:Exp()
	tax_min = fixed_min(tax_log + tax_exp, min_val)
	return tax_min
end

function GetRevoltRiskInfluence(revolt_risk, from_what)
	ret = from_what - revolt_risk
	return ret
end

local BASE_TIME = 10

function GetWantedDVI(market_size, infrastructure, taxes_slider, revolt_risk, min_val)
	taxes_influence = GetTaxesInfluence(taxes_slider, min_val)
	revolt_influence = GetRevoltRiskInfluence(revolt_risk)
	desired = infrastructure * market_size * taxes_influence * revolt_influence
	return desired
end

function UpdateDVI(province_economy, infrastructure, wanted_dvi)
	dvi = province_economy:GetDVI()
	--wanted_dvi = GetWantedDVI(market_size, infrastructure, taxes_slider, revolt_risk, min_val)
	btime = BASE_TIME * 365
	dvi = dvi + ((wanted_dvi - dvi) + infrastructure/10)/btime
	province_economy:SetDVI(dvi)
end

function GetFactoryCapacity(level)
	ret = 0
	if level == 1 then ret=1
	elseif level == 2 then ret=2
	elseif level == 3 then ret=3
	elseif level == 4 then ret=5
	elseif level == 5 then ret=9
	elseif level == 6 then ret=14
	elseif level == 7 then ret=24
	elseif level == 8 then ret=41
	elseif level == 9 then ret=69
	elseif level == 10 then ret=82
	end
	return ret
end

function GetFactoryPrice(level)
	ret = 0
	if level == 1 then ret=1
	elseif level == 2 then ret=2
	elseif level == 3 then ret=3
	elseif level == 4 then ret=5
	elseif level == 5 then ret=9
	elseif level == 6 then ret=14
	elseif level == 7 then ret=24
	elseif level == 8 then ret=41
	elseif level == 9 then ret=69
	elseif level == 10 then ret=82
	end

	return ret
end

local PopsResourcesUsage = { 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 }
local DIVIDER = 1000

function GetPopulationDemand(population_count, resource_num, dvi)
	ret = population_count / DIVIDER
	ret = ret * PopsResourcesUsage[resource_num]
	ret = ret * dvi
	return ret
end
		
 	
	