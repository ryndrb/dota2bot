local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Nightmare

function X.Cast()
    bot = GetBot()
    Nightmare = bot:GetAbilityByName('bane_nightmare')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Nightmare, Target)
        return
    end
end

function X.Consider()
    if not Nightmare:IsFullyCastable() then return 0 end

	local nCastRange = Nightmare:GetCastRange()
	local nInRangeEnemyList = J.GetAroundEnemyHeroList(nCastRange)
    local nAllyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local botTarget = J.GetProperTarget(bot)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if  J.IsRetreating(bot)
    and (bot:WasRecentlyDamagedByAnyHero(3) or bot:GetActiveModeDesire() > 0.7)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local npcStrongestEnemy = nil
		local nStrongestPower = 0
		local nEnemyCount = 0

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				nEnemyCount = nEnemyCount + 1
				if  J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
				then
					local npcEnemyPower = enemyHero:GetEstimatedDamageToTarget(true, bot, 6.0, DAMAGE_TYPE_ALL)
					if npcEnemyPower > nStrongestPower
					then
						nStrongestPower = npcEnemyPower
						npcStrongestEnemy = enemyHero
					end
				end
			end
		end

		if  npcStrongestEnemy ~= nil and nEnemyCount >= 2
		and J.IsInRange(bot, npcStrongestEnemy, nCastRange + 150)
		then
			return BOT_ACTION_DESIRE_HIGH, npcStrongestEnemy
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
		then
			for _, enemyHero in pairs( nInRangeEnemyList )
			do
				if  J.IsValid(enemyHero)
                and enemyHero ~= botTarget
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if  J.IsInRange(bot, botTarget, nCastRange)
            and not J.IsInRange(bot, botTarget, 500)
            and J.IsRunning(botTarget)
            and bot:IsFacingLocation(botTarget:GetLocation(), 30)
            and not botTarget:IsFacingLocation(bot:GetLocation(), 150)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.CanCastOnTargetAdvanced(botTarget)
			then
				local nInRangeAlly = botTarget:GetNearbyHeroes(600, true, BOT_MODE_NONE)
				if nInRangeAlly ~= nil and #nInRangeAlly == 0
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X