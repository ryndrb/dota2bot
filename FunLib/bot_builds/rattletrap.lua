local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local sGlimmerSolarCrest = RandomInt(1, 2) == 1 and "item_glimmer_cape" or "item_solar_crest"

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,2,1,3,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,6},
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
            "item_wind_lace",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_urn_of_shadows",
            "item_force_staff",--
            "item_spirit_vessel",--
            sGlimmerSolarCrest,--
            "item_aghanims_shard",
            "item_boots_of_bearing",-- 
            "item_shivas_guard",--
            "item_heavens_halberd",--
            "item_ultimate_scepter",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_urn_of_shadows",
            "item_force_staff",--
            "item_spirit_vessel",--
            sGlimmerSolarCrest,--
            "item_aghanims_shard",
            "item_guardian_greaves",-- 
            "item_shivas_guard",--
            "item_heavens_halberd",--
            "item_ultimate_scepter",
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