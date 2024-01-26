local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

function GetDesire()

	local currentTime = DotaTime()
	local botLV = bot:GetLevel()
	local networth = bot:GetNetWorth()
	local lastHits = bot:GetLastHits()
	local isBotCore = J.IsCore(bot)
	local isEarlyGame = J.IsModeTurbo() and DotaTime() < 8 * 60 or DotaTime() < 12 * 60
	local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
	local nAllyHeroes = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

	if currentTime < 0 then
		return BOT_ACTION_DESIRE_NONE
	end

	if  J.GetHP(bot) < 0.25
	and (nEnemyHeroes ~= nil and #nEnemyHeroes > 0)
	then
		return BOT_MODE_DESIRE_LOW
	end

	if  (nEnemyHeroes ~= nil and nAllyHeroes ~= nil)
	and (#nAllyHeroes < #nAllyHeroes)
	and J.GetHP(bot) < 0.5
	then
		return BOT_MODE_DESIRE_MODERATE
	end

	if isEarlyGame or botLV < 6
	then
		if isBotCore
		then
			return BOT_MODE_DESIRE_VERYHIGH
		end

		return BOT_MODE_DESIRE_MODERATE
	end

	if isBotCore and lastHits < 50
	then
		return BOT_MODE_DESIRE_VERYHIGH
	end

	return BOT_MODE_DESIRE_NONE
end