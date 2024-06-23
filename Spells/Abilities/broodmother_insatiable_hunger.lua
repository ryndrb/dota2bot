local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local InsatiableHunger

function X.Cast()
    bot = GetBot()
    InsatiableHunger = bot:GetAbilityByName('broodmother_insatiable_hunger')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(InsatiableHunger)
        return
    end
end

function X.Consider()
    if not InsatiableHunger:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()
    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange + 150)
        and J.CanBeAttacked(botTarget)
        and J.IsAttacking(bot)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(700, true)

        if  nCreeps ~= nil and #nCreeps > 0
        and J.CanBeAttacked(nCreeps[1])
        and J.GetHP(bot) < 0.4
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X