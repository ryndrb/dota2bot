local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
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
        [1] = {3,1,3,2,3,6,3,1,1,1,2,6,2,2,6},
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
            "item_circlet",
            "item_gauntlets",
        
            "item_bottle",
            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_echo_sabre",
            "item_ultimate_scepter",
            "item_manta",--
            "item_black_king_bar",--
            "item_travel_boots",
            "item_greater_crit",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_bloodthorn",--
            "item_moon_shard",
            "item_aghanims_shard",
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
            "item_bracer",
            "item_echo_sabre",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X