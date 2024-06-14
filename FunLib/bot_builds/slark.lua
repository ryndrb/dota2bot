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
        [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
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
            "item_slippers",
            "item_circlet",
        
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
            "item_diffusal_blade",
            "item_yasha",
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_sange_and_yasha",--
            "item_skadi",--
            "item_basher",
            "item_disperser",--
            "item_bloodthorn",--
            "item_abyssal_blade",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
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
            "item_power_treads",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X