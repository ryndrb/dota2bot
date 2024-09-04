local Defend = require( GetScriptDirectory()..'/FunLib/aba_defend')

function GetDesire()
    GetBot().DefendLaneDesire[LANE_MID] = Defend.GetDefendDesire(GetBot(), LANE_MID)
    return GetBot().DefendLaneDesire[LANE_MID]
end

-- function Think()
--     Defend.DefendThink(GetBot(), LANE_MID)
-- end