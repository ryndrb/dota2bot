local Push = require( GetScriptDirectory()..'/FunLib/aba_push')

function GetDesire()
    GetBot().PushLaneDesire[LANE_TOP] = Push.GetPushDesire(GetBot(), LANE_TOP)
    return GetBot().PushLaneDesire[LANE_TOP]
end

function Think()
    Push.PushThink(GetBot(), LANE_TOP)
end