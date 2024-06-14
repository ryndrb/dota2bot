local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

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
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {3,1,1,3,1,6,1,3,3,2,6,2,2,2,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
    },
    ['pos_5'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_circlet",
        
            "item_bottle",
            "item_magic_wand",
            "item_arcane_boots",
            "item_ultimate_scepter",
            "item_octarine_core",--
            "item_manta",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_kaya_and_sange",--
            "item_travel_boots",
            "item_wind_waker",--
            "item_travel_boots_2",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_aghanims_shard",
            "item_glimmer_cape",--
            "item_aether_lens",--
            "item_solar_crest",--
            "item_boots_of_bearing",--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_moon_shard"
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_aghanims_shard",
            "item_glimmer_cape",--
            "item_aether_lens",--
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_moon_shard"
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_circlet",
            "item_bottle",
            "item_magic_wand",
        }
    },
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