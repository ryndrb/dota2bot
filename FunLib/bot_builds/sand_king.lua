local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {1,3,2,2,2,6,2,1,1,1,6,3,3,3,6},
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
            "item_circlet",
            "item_circlet",
            "item_quelling_blade",
        
            "item_bracer",
            "item_boots",
            "item_veil_of_discord",
            "item_magic_wand",
            "item_blink",
            "item_cyclone",
            "item_shivas_guard",--
            "item_travel_boots",
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_black_king_bar",--
            sUtilityItem,--
            "item_overwhelming_blink",--
            "item_ultimate_scepter_2",
            "item_wind_waker",--
            "item_travel_boots_2",--
            "item_moon_shard",
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
            "item_circlet",
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X