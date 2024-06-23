local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SpinnersSnare

function X.Cast()
    bot = GetBot()
    SpinnersSnare = bot:GetAbilityByName('broodmother_sticky_snare')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SpinnersSnare, Location)
        return
    end
end

function X.Consider()
    return BOT_ACTION_DESIRE_NONE, 0
end

return X