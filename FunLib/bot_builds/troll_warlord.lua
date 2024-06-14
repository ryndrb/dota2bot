local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
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
        [1] = {2,1,4,2,2,6,2,1,1,1,6,4,4,4,6},
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
            "item_quelling_blade",
        
            "item_wraith_band",
            "item_phase_boots",
            "item_magic_wand",
            "item_bfury",--
            "item_yasha",
            "item_black_king_bar",--
            "item_sange_and_yasha",--
            "item_aghanims_shard",
            "item_satanic",--
            "item_abyssal_blade",--
            "item_travel_boots_2",--
            "item_moon_shard",
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
            "item_wraith_band",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X