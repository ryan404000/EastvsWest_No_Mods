-- obfuscate info about other countries in intel screen
-- depending on number of spies in selected country

function IntelInfoRandomize(SpyCount, RealValue)
	local Uncertainity = 0

	if(SpyCount == 0) then Uncertainity = RealValue
	elseif(SpyCount == 1) then Uncertainity = RealValue * 0.65
	elseif(SpyCount == 2) then Uncertainity = RealValue * 0.5
	elseif(SpyCount == 3) then Uncertainity = RealValue * 0.4
	elseif(SpyCount == 4) then Uncertainity = RealValue * 0.325
	elseif(SpyCount == 5) then Uncertainity = RealValue * 0.25
	elseif(SpyCount == 6) then Uncertainity = RealValue * 0.175
	elseif(SpyCount == 7) then Uncertainity = RealValue * 0.125
	elseif(SpyCount == 8) then Uncertainity = RealValue * 0.075
	elseif(SpyCount == 9) then Uncertainity = RealValue * 0.025
	elseif(SpyCount == 10) then Uncertainity = RealValue * 0.01
	else Uncertainity = 0
	end
	
	return Uncertainity
end