-----------------------------------------------------------
-- LUA East vs. West Auto EXE File
--
-- NOTES: This file is run on app start after exports are done inside 
-- 		  the engine (once per context created)
-----------------------------------------------------------

-- check for user mod files
if CAI.HasUserExtension() then
	local modDir = tostring(CAI.GetModDirectory())
	package.path = package.path .. ";" .. modDir .. "\\?.lua;" .. modDir .. "\\country\\?.lua"
end

package.path = package.path .. ";script\\?.lua;script\\country\\?.lua"

if CAI.HasCommonExtension() then
	local modDir = tostring(CAI.GetCommonModDirectory())
	package.path = package.path .. ";" .. modDir .. "\\?.lua"
end

package.path = package.path .. ";common\\?.lua"

--require('hoi') -- already imported by game, contains all exported classes
require('ai_rucksack')
require('utils')
require('defines')
require('ai_country')
require('ai_foreign_minister')
require('ai_intelligence_minister')
require('ai_politics_minister')
require('ai_production_minister')
require('ai_support_functions')
require('ai_tech_minister')
require('ai_trade')
require('intel_info_obfuscate')
require('economy')
require('ai_economy_minister')
require('ai_nuclear')
require('ai_nuclear_minister')

-- Load country specific AI modules. Temporary commented out.
--require('CountryTag')


-- Web
require('webutils')
