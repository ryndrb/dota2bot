local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

if bot.isInLanePhase == nil then bot.isInLanePhase = false end
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
	and bot:GetLevel() < 8
	then
		if bot:WasRecentlyDamagedByTower(1)
		then
			return BOT_MODE_DESIRE_VERYHIGH
		end

		local botTarget = J.GetProperTarget(bot)
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 1600)
		and J.IsChasingTarget(bot, botTarget)
		then
			local nChasingAlly = {}
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
			for _, allyHero in pairs(nInRangeAlly)
			do
				if  J.IsValidHero(allyHero)
				and J.IsChasingTarget(allyHero, botTarget)
				and allyHero ~= bot
				and not J.IsRetreating(allyHero)
				and not J.IsSuspiciousIllusion(allyHero)
				then
					table.insert(nChasingAlly, allyHero)
				end
			end

			table.insert(nChasingAlly, bot)

			-- Consider stop chasing if can't kill and need to CS
			local nHealth = botTarget:GetHealth()
			if botTarget:GetUnitName() == 'npc_dota_hero_medusa'
			then
				nHealth = nHealth + botTarget:GetMana()
			end

			if nHealth > J.GetTotalEstimatedDamageToTarget(nChasingAlly, botTarget)
			then
				local nEnemyTowers = botTarget:GetNearbyTowers(888, true)
				local nEnemyLaneFrontAmount = 1 - GetLaneFrontAmount(GetOpposingTeam(), bot:GetAssignedLane(), true)

				if nEnemyTowers ~= nil and #nEnemyTowers >= 1
				or nEnemyLaneFrontAmount > 0
				then
					return BOT_MODE_DESIRE_VERYHIGH
				end
			end
		end
	end

	if  currentTime <= 9 * 60
	and botLV <= 7
	then
		bot.isInLanePhase = true
		return 0.444
	end

	bot.isInLanePhase = false

	if  currentTime <= 12 * 60
	and botLV <= 11
	then
		if botLV <= 7 then bot.isInLanePhase = true end
		return 0.333
	end

	if botLV <= 17
	then
		return 0.222
	end

	return BOT_MODE_DESIRE_NONE
end