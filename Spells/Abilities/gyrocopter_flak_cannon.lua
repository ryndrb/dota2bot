local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FlakCannon

function X.Cast()
    bot = GetBot()
    FlakCannon = bot:GetAbilityByName('gyrocopter_flak_cannon')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FlakCannon)
        return
    end
end

function X.Consider()
    if not FlakCannon:IsFullyCastable()
    or bot:IsDisarmed()
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = FlakCannon:GetSpecialValueInt('radius')
    local nAbilityLevel = FlakCannon:GetLevel()
    local botTarget = J.GetProperTarget(bot)
    local nInRangeIllusion = J.GetIllusionsNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and (not J.IsSuspiciousIllusion(botTarget) and not botTarget:IsAttackImmune()
            or J.IsSuspiciousIllusion(botTarget) and #nInRangeIllusion >= 2 and not J.IsInTeamFight(bot, 1200))
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  ((J.IsPushing(bot) and nEnemyHeroes ~= nil and #nEnemyHeroes == 0) or J.IsDefending(bot))
    and nAbilityLevel >= 2
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) <= nRadius
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if  J.IsFarming(bot)
    and nAbilityLevel >= 2
    and J.GetManaAfter(FlakCannon:GetManaCost()) > 0.35
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    and J.IsAttacking(bot)
    and not bot:HasModifier('modifier_gyrocopter_rocket_barrage')
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(bot:GetAttackRange() + 150)

        if  nNeutralCreeps ~= nil
        and J.IsValid(nNeutralCreeps[1])
        and (#nNeutralCreeps >= 3
            or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) <= nRadius
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X