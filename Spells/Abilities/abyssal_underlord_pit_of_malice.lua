local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local PitOfMalice

function X.Cast()
    bot = GetBot()
    PitOfMalice = bot:GetAbilityByName('abyssal_underlord_pit_of_malice')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(PitOfMalice, Location)
        return
    end
end

function X.Consider()
    if not PitOfMalice:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, PitOfMalice:GetCastRange())
	local nRadius = PitOfMalice:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        then
            if not J.IsInRange(bot, enemyHero, nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, enemyHero:GetLocation(), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nCastRange + nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                if GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nInRangeEnemy)) > nCastRange
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end
            end

            if not J.IsInRange(bot, botTarget, nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.7 or bot:WasRecentlyDamagedByHero(enemyHero, 2))
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                if J.IsInRange(bot, enemyHero, nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
                else
                    return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
                end
            end
        end
    end

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + nRadius, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if  nAllyHeroes ~= nil
        and #nInRangeEnemy >= 1
        and not (#nAllyHeroes > #nInRangeEnemy + 1)
		then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and not J.IsDisabled(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X