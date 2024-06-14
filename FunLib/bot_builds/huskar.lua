local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
        [2] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
        [2] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,3,2,2,3,6,3,3,2,2,1,6,1,1,6},
        [2] = {2,3,2,3,3,2,3,6,2,1,1,1,1,6,6},
    },
    ['pos_3'] = {
        [1] = {1,3,2,2,3,6,3,3,2,2,1,6,1,1,6},
        [2] = {2,3,2,3,3,2,3,6,2,1,1,1,1,6,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_faerie_fire",
            "item_double_gauntlets",
        
            "item_bottle",
            "item_boots",
            "item_armlet",
            "item_black_king_bar",--
            "item_sange",
            "item_ultimate_scepter",
            "item_heavens_halberd",--
            "item_travel_boots",
            "item_satanic",--
            "item_aghanims_shard",
            "item_assault",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_sheepstick",--
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_faerie_fire",
            "item_double_gauntlets",
        
            "item_bracer",
            "item_armlet",
            "item_heavens_halberd",--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            sUtilityItem,--
            "item_satanic",--
            "item_travel_boots",
            "item_nullifier",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_gauntlets",
            "item_armlet",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_gauntlets",
            "item_armlet",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X