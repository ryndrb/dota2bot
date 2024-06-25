local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Strafe

function X.Cast()
    bot = GetBot()
    Strafe = bot:GetAbilityByName('clinkz_strafe')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Strafe)
        return
    end
end

function X.Consider()
    if not Strafe:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local nAttackRange = bot:GetAttackRange()
    local botTarget = J.GetProperTarget(bot)

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and not J.IsRunning(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsFarming(bot)
    then
        if J.IsAttacking(bot)
        and J.GetManaAfter(Strafe:GetManaCost()) > 0.25
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
            if  nNeutralCreeps ~= nil
            and J.IsValid(nNeutralCreeps[1])
            and (#nNeutralCreeps >= 3
                or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and J.IsInRange(bot, nEnemyLaneCreeps[1], nAttackRange)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot)
    then
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and J.IsInRange(bot, nEnemyLaneCreeps[1], nAttackRange)
        and J.GetManaAfter(Strafe:GetManaCost()) > 0.25
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X