local Push = require( GetScriptDirectory()..'/FunLib/aba_push')

function GetDesire()
    return Push.GetPushDesire(GetBot(), LANE_MID)
end

function OnStart()
    local bot = GetBot()
    bot:ActionImmediate_Chat("Pushing Bottom", false)
end

function Think()
    Push.PushThink(GetBot(), LANE_MID)
end