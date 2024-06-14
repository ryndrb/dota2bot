local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
    },
    ['pos_3'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
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
            "item_faerie_fire",
            "item_double_circlet",
        
            "item_null_talisman",
            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_travel_boots",
            "item_radiance",--
            "item_eternal_shroud",--
            "item_aghanims_shard",
            "item_heart",--
            "item_ultimate_scepter",
            "item_kaya_and_sange",--
            "item_shivas_guard",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_double_circlet",
        
            "item_null_talisman",
            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_radiance",--
            sUtilityItem,--
            "item_travel_boots",
            "item_aghanims_shard",
            "item_heart",--
            "item_ultimate_scepter",
            "item_shivas_guard",--
            "item_cyclone",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_wind_waker",--
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
            "item_null_talisman",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_null_talisman",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X