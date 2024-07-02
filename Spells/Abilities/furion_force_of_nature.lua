local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local NaturesCall

function X.Cast()
    bot = GetBot()
    NaturesCall = bot:GetAbilityByName('furion_force_of_nature')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(NaturesCall, Target)
        return
    end
end

function X.Consider()
    if not NaturesCall:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, NaturesCall:GetCastRange())
    local botTarget = J.GetProperTarget(bot)

    local nInRangeTrees = bot:GetNearbyTrees(nCastRange)

    if nInRangeTrees ~= nil and #nInRangeTrees >= 1
    then
        if J.IsGoingOnSomeone(bot)
        then
            if J.IsValidTarget(botTarget)
            and J.IsInRange(bot, botTarget, 900)
            and not J.IsSuspiciousIllusion(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nInRangeTrees[1])
            end
        end

        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

        if J.IsPushing(bot) or J.IsDefending(bot)
        then
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            then
                return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nInRangeTrees[1])
            end
        end

        if  J.IsFarming(bot)
        and J.GetManaAfter(NaturesCall:GetManaCost()) > 0.35
        then
            if J.IsAttacking(bot)
            then
                local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
                if  nNeutralCreeps ~= nil
                and J.IsValid(nNeutralCreeps[1])
                and ((#nNeutralCreeps >= 3)
                    or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
                then
                    return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nInRangeTrees[1])
                end

                if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
                and J.CanBeAttacked(nEnemyLaneCreeps[1])
                then
                    return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nInRangeTrees[1])
                end
            end
        end

        if J.IsLaning(bot)
        and J.GetManaAfter(NaturesCall:GetManaCost()) > 0.3
        then
            if J.IsAttacking(bot)
            then
                if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 2
                and J.CanBeAttacked(nEnemyLaneCreeps[1])
                then
                    return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nInRangeTrees[1])
                end
            end
        end

        if J.IsDoingRoshan(bot)
        then
            if  J.IsRoshan(botTarget)
            and not botTarget:IsAttackImmune()
            and J.IsInRange(bot, botTarget, bot:GetAttackRange())
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nInRangeTrees[1])
            end
        end

        if J.IsDoingTormentor(bot)
        then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, bot:GetAttackRange())
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nInRangeTrees[1])
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X