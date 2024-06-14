local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
    },
    ['pos_5'] = {
        [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_enchanted_mango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_aghanims_shard",
            "item_glimmer_cape",--
            "item_solar_crest",--
            "item_ultimate_scepter",
            "item_boots_of_bearing",--
            "item_cyclone",
            "item_refresher",--
            "item_black_king_bar",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_enchanted_mango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_aghanims_shard",
            "item_glimmer_cape",--
            "item_force_staff",--
            "item_ultimate_scepter",
            "item_guardian_greaves",--
            "item_cyclone",
            "item_refresher",--
            "item_black_king_bar",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_magic_wand",
        }
    },
}

return X