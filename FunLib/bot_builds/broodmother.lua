local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
    },
    ['pos_3'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
        
            "item_double_wraith_band",
            "item_power_treads",
            "item_soul_ring",
            "item_magic_wand",
            "item_bloodthorn",--
            "item_black_king_bar",--
            "item_sheepstick",--
            "item_aghanims_shard",
            "item_nullifier",--
            "item_skadi",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
        
            "item_double_wraith_band",
            "item_power_treads",
            "item_soul_ring",
            "item_magic_wand",
            "item_orchid",
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_assault",--
            "item_aghanims_shard",
            "item_sheepstick",--
            "item_skadi",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_wraith_band",
            "item_soul_ring",
            "item_magic_wand"
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_wraith_band",
            "item_soul_ring",
            "item_magic_wand"
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X