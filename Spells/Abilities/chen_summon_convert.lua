local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SummonConvert

function X.Cast()
    bot = GetBot()
    SummonConvert = bot:GetAbilityByName('chen_summon_convert')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SummonConvert)
        return
    end
end

function X.Consider()
    if not SummonConvert:IsFullyCastable()
    or X.IsThereChenCreepAlive()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 900)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  (J.IsFarming(bot) or J.IsPushing(bot) or J.IsDefending(bot) or J.IsLaning(bot))
    and J.IsAttacking(bot)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
		then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.IsThereChenCreepAlive()
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES))
    do
        if  string.find(unit:GetUnitName(), 'neutral')
        and unit:HasModifier('modifier_chen_holy_persuasion')
        then
            return true
        end
    end

    return false
end

return X