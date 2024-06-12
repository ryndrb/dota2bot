local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
        [2] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {3,1,3,1,3,6,3,1,1,2,6,2,2,2,6},
    },
    ['pos_2'] = {
        [1] = {3,1,1,3,1,6,1,3,3,2,6,2,2,2,6},
        [2] = {3,1,3,1,3,6,3,1,1,2,6,2,2,2,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_slippers",
            "item_circlet",

            "item_wraith_band",
            "item_boots",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_maelstrom",
            "item_gungir",--
            "item_travel_boots",
            "item_manta",--
            "item_sheepstick",--
            "item_bloodthorn",--
            "item_skadi",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_circlet",
            "item_faerie_fire",

            "item_bottle",
            "item_magic_wand",
            "item_spirit_vessel",
            "item_boots",
            "item_hand_of_midas",
            "item_gungir",--
            "item_travel_boots",
            "item_blink",
            "item_octarine_core",--
            "item_ultimate_scepter",
            "item_orchid",
            "item_sheepstick",--
            "item_overwhelming_blink",--
            "item_bloodthorn",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
            "item_aghanims_shard",
        },
        [2] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",

            "item_bottle",
            "item_spirit_vessel",
            "item_magic_wand",
            "item_boots",
            "item_hand_of_midas",
            "item_gungir",--
            "item_travel_boots",
            "item_orchid",
            "item_manta",--
            "item_greater_crit",--
            "item_skadi",--
            "item_bloodthorn",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_wraith_band",
            "item_magic_wand",
            "item_hand_of_midas",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_circlet",
            "item_bottle",
            "item_magic_wand",
            "item_spirit_vessel",
            "item_hand_of_midas",
        },
        [2] = {
            "item_circlet",
            "item_spirit_vessel",
            "item_magic_wand",
            "item_hand_of_midas",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X