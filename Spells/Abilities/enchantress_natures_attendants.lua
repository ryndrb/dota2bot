local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local NaturesAttendant

function X.Cast()
    bot = GetBot()
    NaturesAttendant = bot:GetAbilityByName('enchantress_natures_attendants')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(NaturesAttendant)
        return
    end
end

function X.Consider()
    if not NaturesAttendant:IsFullyCastable() or J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.GetHP(bot) < 0.65
    and bot:DistanceFromFountain() > 800
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	return BOT_ACTION_DESIRE_NONE
end

return X