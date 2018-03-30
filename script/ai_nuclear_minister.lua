-----------------------------------------------------------
-- LUA East vs. West Nuclear AI minister
-- Created By: Biga
-- Modified By: Biga
-- Date Last Modified: 17/05/2013
-----------------------------------------------------------
require('utils')

local	DEFCON_5 = 0
local	DEFCON_4 = 1
local	DEFCON_3 = 2
local	DEFCON_2 = 3
local	DEFCON_1 = 4


function NuclearMinister_Tick(minister, isAI)
  local mCountry = minister:GetCountry()
  local ministerTag = minister:GetCountryTag()
  local NuclearForces = mCountry:GetNuclearForces()
  local ai = minister:GetOwnerAI()
  local loStrategy = mCountry:GetStrategy()
  local usaTag = CCountryDataBase.GetTag('USA')
  local sovTag = CCountryDataBase.GetTag('SOV')
  
  --Utils.LUA_DEBUGOUT("nuclear minister tick " .. tostring(ministerTag))
  
  -- player AI only responds
  if mCountry:GetNukeLauncher() == CNullTag() and isAI == false then
    Utils.LUA_DEBUGOUT("  nuclearminister player AI return")
	return
  end
  
  
  -- call setting command
  
  if ministerTag == usaTag then
	--loStrategy:PrepareWar(sovTag, 100)
	--Utils.LUA_DEBUGOUT("  preparewar USA")
  end
  

  
end  

