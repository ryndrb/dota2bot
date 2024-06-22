local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {1,2,3,3,3,6,3,2,2,2,6,1,1,1,6},
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {1,2,3,3,3,6,3,2,2,2,6,1,1,1,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",

            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_armlet",
            "item_orchid",
            "item_manta",--
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_heart",--
            "item_aghanims_shard",
            "item_blink",
            "item_travel_boots",
            "item_swift_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",

            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_armlet",
            "item_orchid",
            "item_manta",--
            sUtilityItem,--
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_heart",--
            "item_aghanims_shard",
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
            "item_armlet",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
            "item_armlet",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X