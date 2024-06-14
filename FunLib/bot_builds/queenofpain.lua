local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {3,1,1,2,3,6,3,3,2,2,6,2,1,1,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_bottle",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_witch_blade",
            "item_kaya_and_sange",--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_shivas_guard",--
            "item_aghanims_shard",
            "item_travel_boots",
            "item_devastator",--
            "item_cyclone",
            "item_ultimate_scepter_2",
            "item_wind_waker",--
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
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