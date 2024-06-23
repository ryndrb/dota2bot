local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Jinada

function X.Cast()
    bot = GetBot()
    Jinada = bot:GetAbilityByName('bounty_hunter_jinada')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Jinada, Target)
        return
    end
end

function X.Consider()
    return BOT_ACTION_DESIRE_NONE, nil
end

return X