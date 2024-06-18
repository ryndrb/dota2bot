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
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
    },
    ['pos_5'] = {
        [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_faerie_fire",
            "item_mantle",
            "item_circlet",
            "item_double_branches",
            "item_tango",
        
            "item_null_talisman",
            "item_travel_boots",
            "item_magic_wand",
            "item_spirit_vessel",
            "item_black_king_bar",--
            "item_octarine_core",--
            "item_ethereal_blade",--
            "item_sheepstick",--
            "item_ultimate_scepter",
            "item_dagon_2",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_dagon_5",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_faerie_fire",
            "item_clarity",
            "item_blood_grenade",
        
            "item_boots",
            "item_urn_of_shadows",
            "item_tranquil_boots",
            "item_solar_crest",--
            "item_spirit_vessel",--
            "item_glimmer_cape",--
            "item_boots_of_bearing",--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_faerie_fire",
            "item_clarity",
            "item_blood_grenade",
        
            "item_boots",
            "item_urn_of_shadows",
            "item_arcane_boots",
            "item_solar_crest",--
            "item_glimmer_cape",--
            "item_spirit_vessel",--
            "item_guardian_greaves",--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_null_talisman",
            "item_magic_wand",
            "item_spirit_vessel",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {}
    },
    ['pos_5'] = {
        [1] = {}
    },
}

return X