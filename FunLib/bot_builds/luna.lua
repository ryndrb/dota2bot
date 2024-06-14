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
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {1,3,3,2,3,2,3,2,2,1,1,1,6,6,6},
        [2] = {3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},
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
            "item_quelling_blade",
        
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
            "item_mask_of_madness",
            "item_manta",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_angels_demise",--
            "item_satanic",--
            "item_butterfly",--
            "item_travel_boots",
            "item_moon_shard",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
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
            "item_quelling_blade",
            "item_wraith_band",
            "item_magic_wand",
            "item_mask_of_madness",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X