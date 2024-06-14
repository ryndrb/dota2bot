local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_crimson_guard"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {2,1,1,3,1,6,1,3,3,3,6,2,2,2,6},
    },
    ['pos_3'] = {
        [1] = {2,1,1,3,1,6,1,3,3,3,6,2,2,2,6},
    },
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
            "item_enchanted_mango",
        
            "item_bottle",
            "item_double_bracer",
            "item_magic_wand",
            "item_boots",
            "item_vladmir",--
            "item_orchid",
            "item_ancient_janggo",
            "item_ultimate_scepter",
            "item_bloodthorn",--
            "item_boots_of_bearing",--
            "item_assault",--
            "item_black_king_bar",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_circlet",
            "item_enchanted_mango",
        
            "item_double_bracer",
            "item_magic_wand",
            "item_boots",
            "item_vladmir",--
            "item_orchid",
            "item_ancient_janggo",
            "item_ultimate_scepter",
            sUtilityItem,--
            "item_boots_of_bearing",--
            "item_assault",--
            "item_black_king_bar",--
            "item_ultimate_scepter_2",
            "item_bloodthorn",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X