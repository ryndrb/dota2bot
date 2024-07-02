local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local StoneRemnant

function X.Cast()
    bot = GetBot()
    StoneRemnant = bot:GetAbilityByName('earth_spirit_stone_caller')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, Location)
        return
    end
end

function X.Consider()
    return BOT_ACTION_DESIRE_NONE
end

return X