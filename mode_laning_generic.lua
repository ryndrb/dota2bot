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

	if  J.IsGoingOnSomeone(bot)
	and J.IsInLaningPhase()
	then
		local botTarget = J.GetProperTarget(bot)
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 1600)
		and J.IsChasingTarget(bot, botTarget)
		then
			local chasingAlly = {}
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			for _, allyHero in pairs(nInRangeAlly)
			do
				if  J.IsValidHero(allyHero)
				and J.IsChasingTarget(allyHero, botTarget)
				and allyHero ~= bot
				and not J.IsRetreating(allyHero)
				and not J.IsSuspiciousIllusion(allyHero)
				then
					table.insert(chasingAlly, allyHero)
				end
			end

			table.insert(chasingAlly, bot)

			local nEnemyTowers = bot:GetNearbyTowers(888, true)
			if nEnemyTowers ~= nil and #nEnemyTowers >= 1
			then
				if botTarget:GetHealth() > J.GetTotalEstimatedDamageToTarget(chasingAlly, botTarget)
				then
					return bot:GetActiveModeDesire() + 0.1
				end
			end
		end
	end

	if  currentTime <= 9 * 60
	and botLV <= 7
	then
		return 0.444
	end

	if  currentTime <= 12 * 60
	and botLV <= 11
	then
		return 0.333
	end

	if botLV <= 17
	then
		return 0.222
	end

	return BOT_MODE_DESIRE_NONE
end