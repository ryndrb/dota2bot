local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

function GetDesire()

	local currentTime = DotaTime()
	local botLV = bot:GetLevel()
	local networth = bot:GetNetWorth()
	local isBotCore = J.IsCore(bot)
	local isEarlyGame = J.IsModeTurbo() and DotaTime() < 8 * 60 or DotaTime() < 12 * 60

	if currentTime < 0 then
		return BOT_ACTION_DESIRE_NONE
	end

	if isEarlyGame or botLV < 6
	then
		if isBotCore
		then
			return BOT_MODE_DESIRE_HIGH
		end

		return BOT_MODE_DESIRE_MODERATE
	end

	if isBotCore and networth < 4500
	then
		return BOT_MODE_DESIRE_HIGH
	end

	return BOT_MODE_DESIRE_VERYLOW
end