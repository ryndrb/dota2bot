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

	if isEarlyGame and botLV < 6
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

	if  not isBotCore
	and not J.IsInLaningPhase()
	then
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(700, true)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil and nEnemyLaneCreeps ~= nil
		and #nInRangeAlly == 0 and #nInRangeEnemy == 0 and #nEnemyLaneCreeps >= 1
		and not J.IsPushing()
		and not J.IsDefending()
		and not J.IsDoingRoshan()
		and not J.IsDoingTormentor()
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_MODE_DESIRE_VERYLOW
end