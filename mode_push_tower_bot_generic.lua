local Push = require( GetScriptDirectory()..'/FunLib/aba_push')

function GetDesire()
    GetBot().PushLaneDesire[LANE_BOT] = Push.GetPushDesire(GetBot(), LANE_BOT)
    return GetBot().PushLaneDesire[LANE_BOT]
end

function Think()
    Push.PushThink(GetBot(), LANE_BOT)
end