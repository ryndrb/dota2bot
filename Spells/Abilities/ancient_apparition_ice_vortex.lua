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

    if J.IsInTeamFight(bot, 1200)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if nInRangeEnemy ~= nil and #nInRangeEnemy
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
        then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(nCastPoint)
            end
        end
    end

    if J.IsRetreating(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        then
            for _, enemyHero in pairs(nInRangeEnemy)
            do
                if (#nInRangeAlly > #nInRangeEnemy
                    or bot:WasRecentlyDamagedByHero(enemyHero, 1.5))
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_cold_feet')
                and not enemyHero:HasModifier('modifier_ice_vortex')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetExtrapolatedLocation(nCastPoint)
                end
            end
        end
    end

    if  (J.IsDefending(bot) or J.IsPushing(bot))
    and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1000))
	then
		local nEnemyLanecreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

		if  nEnemyLanecreeps ~= nil and #nEnemyLanecreeps >= 4
        and nLocationAoE.count >= 4
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLanecreeps)
		end

        nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        if nLocationAoE.count >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyLaneCreeps(1000, true)
        if  nCreeps ~= nil
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