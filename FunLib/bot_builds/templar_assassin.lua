local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,1,1,1,6,1,2,2,2,3,6,3,3,6},
    },
    ['pos_2'] = {
        [1] = {2,3,1,1,1,6,1,2,2,2,3,6,3,3,6},
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
            "item_circlet",
            "item_quelling_blade",
        
            "item_power_treads",
            "item_null_talisman",
            "item_magic_wand",
            "item_dragon_lance",
            "item_desolator",--
            "item_blink",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_greater_crit",--
            "item_hurricane_pike",--
            "item_swift_blink",--
            "item_sheepstick",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_circlet",
            "item_quelling_blade",
        
            "item-bottle",
            "item_power_treads",
            "item_null_talisman",
            "item_magic_wand",
            "item_dragon_lance",
            "item_desolator",--
            "item_blink",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_greater_crit",--
            "item_hurricane_pike",--
            "item_swift_blink",--
            "item_sheepstick",--
            "item_moon_shard",
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
            "item_quelling_blade",
            "item_power_treads",
            "item_null_talisman",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item-bottle",
            "item_power_treads",
            "item_null_talisman",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X