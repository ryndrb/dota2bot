local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
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
        [1] = {2,3,2,3,1,6,1,1,1,2,2,3,6,3,6},
    },
    ['pos_2'] = {
        [1] = {2,3,2,3,1,6,1,1,1,2,2,3,6,3,6},
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
        
            "item_double_wraith_band",
            "item_power_treads",
            "item_magic_wand",
            "item_dragon_lance",
            "item_maelstrom",
            "item_hurricane_pike",--
            "item_mjollnir",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_lesser_crit",
            "item_satanic",--
            "item_greater_crit",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_bottle",
            "item_double_wraith_band",
            "item_power_treads",
            "item_magic_wand",
            "item_dragon_lance",
            "item_maelstrom",
            "item_hurricane_pike",--
            "item_mjollnir",--
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_lesser_crit",
            "item_satanic",--
            "item_greater_crit",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
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
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_wraith_band",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X