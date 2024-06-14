local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
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
        [1] = {1,2,1,3,1,6,2,2,2,1,6,3,3,3,6},
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
            "item_blight_stone",
        
            "item_orb_of_corrosion",
            "item_magic_wand",
            "item_power_treads",
            "item_bfury",--
            "item_black_king_bar",--
            "item_desolator",--
            "item_aghanims_shard",
            "item_basher",
            "item_satanic",--
            "item_monkey_king_bar",--
            "item_abyssal_blade",--
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
            'item_magic_wand',
            "item_orb_of_corrosion",
            "item_power_treads",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X