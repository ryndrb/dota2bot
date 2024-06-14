local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {1,3,1,2,3,6,3,3,1,1,6,2,2,2,6},
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_slippers",
            "item_circlet",
        
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
            "item_dragon_lance",
            "item_manta",
            "item_ultimate_scepter",
            "item_hurricane_pike",--
            "item_black_king_bar",--
            "item_butterfly",--
            "item_aghanims_shard",
            "item_greater_crit",--
            "item_satanic",--
            "item_ultimate_scepter_2",
            "item_travel_boots",
            "item_moon_shard",
            "item_travel_boots_2",--
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_wraith_band",
            "item_magic_wand",
            "item_manta",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X