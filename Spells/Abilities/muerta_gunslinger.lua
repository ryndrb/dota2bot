local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Gunslinger

function X.Cast()
    bot = GetBot()
    Gunslinger = bot:GetAbilityByName('muerta_gunslinger')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Gunslinger)
        return
    end
end

function X.Consider()
    if not Gunslinger:IsTrained()
    or not Gunslinger:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if Gunslinger:GetToggleState() == false
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

return X