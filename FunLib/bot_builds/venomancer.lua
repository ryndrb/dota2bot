local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,2,2,3,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_5'] = {
        [1] = {1,2,2,3,2,6,2,3,3,3,6,1,1,1,6},
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
        
            "item_boots",
            "item_magic_wand",
            "item_urn_of_shadows",
            "item_tranquil_boots",
            "item_solar_crest",--
            "item_spirit_vessel",--
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_aghanims_shard",
            sUtilityItem,--
            "item_ultimate_scepter",
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_boots",
            "item_magic_wand",
            "item_urn_of_shadows",
            "item_arcane_boots",
            "item_solar_crest",--
            "item_spirit_vessel",--
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_aghanims_shard",
            sUtilityItem,--
            "item_ultimate_scepter",
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