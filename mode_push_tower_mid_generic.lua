local Push = require( GetScriptDirectory()..'/FunLib/aba_push')

function GetDesire()
    GetBot().PushLaneDesire[LANE_MID] = Push.GetPushDesire(GetBot(), LANE_MID)
    return GetBot().PushLaneDesire[LANE_MID]
end

function Think()
    Push.PushThink(GetBot(), LANE_MID)
end