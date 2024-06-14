local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {1,4,1,4,1,4,1,4,6,5,6,5,5,5,6},
    },
    ['pos_2'] = {
        [1] = {1,4,1,4,1,4,1,4,6,5,6,5,5,5,6},
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
            "item_double_enchanted_mango",
        
            "item_power_treads",
            "item_magic_wand",
            "item_dragon_lance",
            "item_black_king_bar",--
            "item_hurricane_pike",--
            "item_butterfly",--
            "item_aghanims_shard",
            "item_greater_crit",--
            "item_satanic",--
            "item_travel_boots",
            "item_moon_shard",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_double_enchanted_mango",
            
            "item_bottle",
            "item_power_treads",
            "item_magic_wand",
            "item_dragon_lance",
            "item_black_king_bar",--
            "item_hurricane_pike",--
            "item_butterfly",--
            "item_aghanims_shard",
            "item_greater_crit",--
            "item_satanic",--
            "item_travel_boots",
            "item_moon_shard",
            "item_travel_boots_2",--
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
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X