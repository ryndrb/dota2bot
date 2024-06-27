local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
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
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {2,1,2,1,2,1,2,1,2,3,3,3,3,3,3,3,2,2,1,1,1},
        [2] = {3,1,3,1,3,2,3,1,3,1,3,2,3,2,2,2,2,2,1,1,1},
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
            "item_double_circlet",
        
            "item_bracer",
            "item_urn_of_shadows",
            "item_boots",
            "item_magic_wand",
            "item_spirit_vessel",
            "item_hand_of_midas",
            "item_orchid",
            "item_travel_boots",
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_octarine_core",--
            "item_bloodthorn",--
            "item_ultimate_scepter",
            "item_refresher",--
            "item_ultimate_scepter_2",
            "item_sheepstick",--
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
            "item_circlet",
            "item_bracer",
            "item_magic_wand",
            "item_spirit_vessel",
            "item_hand_of_midas",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X