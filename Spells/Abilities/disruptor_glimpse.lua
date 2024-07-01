local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Glimpse

function X.Cast()
    bot = GetBot()
    Glimpse = bot:GetAbilityByName('disruptor_glimpse')

    if bot.KineticFieldTimeLast == nil then bot.KineticFieldTimeLast = -1 end
    if bot.KineticFieldLocation == nil then bot.KineticFieldLocation = bot:GetLocation() end

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Glimpse, Target)
        return
    end
end

function X.Consider()
    if not Glimpse:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local _, KineticField = J.HasAbility(bot, 'disruptor_kinetic_field')
    local nCastRange = J.GetProperCastRange(false, bot, Glimpse:GetCastRange())

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local nDuration = 0
    if KineticField ~= nil then nDuration = KineticField:GetSpecialValueFloat('duration') end

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and (enemyHero:IsChanneling()
		or (J.IsGoingOnSomeone(bot)
            and (nAllyHeroes ~= nil and #nAllyHeroes <= 3 and #nEnemyHeroes <= 2)
            and bot:IsFacingLocation(enemyHero:GetLocation(), 30)
            and enemyHero:IsFacingLocation(J.GetEnemyFountain(), 30)))
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
		then
            if enemyHero:HasModifier('modifier_teleporting')
            or enemyHero:HasModifier('modifier_fountain_aura_buff')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.IsGoingOnSomeone(bot)
            then
                if J.IsChasingTarget(bot, enemyHero)
                and enemyHero:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
                and not enemyHero:HasModifier('modifier_disruptor_static_storm')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not J.IsLocationInArena(enemyHero:GetLocation(), 600)
                then
                    if KineticField ~= nil
                    then
                        if DotaTime() > bot.KineticFieldTimeLast + nDuration
                        and GetUnitToLocationDistance(enemyHero, bot.KineticFieldLocation) > 350
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero
                        end
                    else
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.75
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (J.IsChasingTarget(enemyHero, bot) or bot:WasRecentlyDamagedByHero(enemyHero, 3))
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_disruptor_static_storm')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not J.IsLocationInArena(enemyHero:GetLocation(), 600)
            then
                if KineticField ~= nil
                then
                    if DotaTime() > bot.KineticFieldTimeLast + nDuration
                    and GetUnitToLocationDistance(enemyHero, bot.KineticFieldLocation) > 350
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and J.IsCore(allyHero)
        and allyHero:GetActiveModeDesire() >= 0.75
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsChasingTarget(nAllyInRangeEnemy[1], bot)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_disruptor_static_storm')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and not J.IsLocationInArena(nAllyInRangeEnemy[1]:GetLocation(), 600)
            then
                if KineticField ~= nil
                then
                    if DotaTime() > bot.KineticFieldTimeLast + nDuration
                    and GetUnitToLocationDistance(nAllyInRangeEnemy[1], bot.KineticFieldLocation) > 350
                    then
                        return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
                end
            end
        end
    end

    local realHeroCount = 0
    local illuHeroCount = 0
    local illuTarget = nil

    for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and Glimpse:GetLevel() >= 3
		then
            if J.IsSuspiciousIllusion(enemyHero)
            then
                illuHeroCount = illuHeroCount + 1
                illuTarget = enemyHero
            else
                realHeroCount = realHeroCount + 1
            end
        end
    end

    if realHeroCount == 0 and illuHeroCount >= 1
    then
        return BOT_ACTION_DESIRE_HIGH, illuTarget
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X