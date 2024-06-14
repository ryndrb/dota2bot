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
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_circlet",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_ancient_janggo",
            "item_rod_of_atos",
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_pipe",--
            "item_sheepstick",--
            "item_gungir",--
            "item_wind_waker",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_circlet",
            "item_magic_wand",
            "item_arcane_boots",
            "item_mekansm",
            "item_rod_of_atos",
            "item_guardian_greaves",--
            "item_force_staff",--
            "item_pipe",--
            "item_sheepstick",--
            "item_gungir",--
            "item_wind_waker",--
            "item_aghanims_shard",
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
            "item_circlet",
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
}

return X