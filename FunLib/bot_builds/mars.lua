local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_double_bracer",
            "item_boots",
            "item_magic_wand",
            "item_phase_boots",
            "item_soul_ring",
            "item_blink",
            "item_cyclone",
            "item_black_king_bar",--
            "item_aghanims_shard",
            sUtilityItem,--
            "item_octarine_core",--
            "item_wind_waker",--
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2"
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
            "item_soul_ring",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X