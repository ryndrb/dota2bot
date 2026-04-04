local Defend = require( GetScriptDirectory()..'/FunLib/aba_defend')

function GetDesire()
    GetBot().DefendLaneDesire[LANE_TOP] = Defend.GetDefendDesire(GetBot(), LANE_TOP)
    return GetBot().DefendLaneDesire[LANE_TOP]
end

function Think()
    Defend.DefendThink(GetBot(), LANE_TOP)
end