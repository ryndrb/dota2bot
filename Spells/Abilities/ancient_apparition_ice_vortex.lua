local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local IceVortex

function X.Cast()
    bot = GetBot()
    IceVortex = bot:GetAbilityByName('ancient_apparition_ice_vortex')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(IceVortex, Location)
        return
    end
end

function X.Consider()
    if not IceVortex:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, IceVortex:GetCastRange())
    local nRadius = IceVortex:GetSpecialValueInt('radius')
    local nCastPoint = IceVortex:GetCastPoint()
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLanecreeps = bot:GetNearbyLaneCreeps(1600, true)

    if J.IsInTeamFight(bot, 1200)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_ice_vortex')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint)
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.88 and bot:WasRecentlyDamagedByHero(enemyHero, 2.5))
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_cold_feet')
            and not enemyHero:HasModifier('modifier_ice_vortex')
            then
                return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + J.GetCorrectLoc(enemyHero, nCastPoint)) / 2
            end
        end
    end

    if  (J.IsDefending(bot) or J.IsPushing(bot))
    and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1000))
	then
		if nEnemyLanecreeps ~= nil and #nEnemyLanecreeps >= 4
        and J.CanBeAttacked(nEnemyLanecreeps[1])
        and not J.IsRunning(nEnemyLanecreeps[1])
        and not nEnemyLanecreeps[1]:HasModifier('modifier_ice_vortex')
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLanecreeps)
		end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        if nLocationAoE.count >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(1000, true)
        if  nCreeps ~= nil
        and J.CanBeAttacked(nCreeps[1])
        and not J.IsRunning(nCreeps[1])
        and not nCreeps[1]:HasModifier('modifier_ice_vortex')
        and (#nCreeps >= 3 or #nCreeps >= 2 and nCreeps[1]:IsAncientCreep())
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nCreeps)
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X