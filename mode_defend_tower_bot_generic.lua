local Defend = require( GetScriptDirectory()..'/FunLib/aba_defend')

function GetDesire()
    GetBot().DefendLaneDesire[LANE_BOT] = Defend.GetDefendDesire(GetBot(), LANE_BOT)
    return GetBot().DefendLaneDesire[LANE_BOT]
end

function Think()
    Defend.DefendThink(GetBot(), LANE_BOT)
end