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
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
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
    ['pos_2'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,3,1,2,1,6,1,2,2,2,3,6,3,3,6},
    },
    ['pos_5'] = {
        [1] = {1,3,1,2,1,6,1,2,2,2,3,6,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_double_branches",
            "item_faerie_fire",
            "item_tango",
        
            "item_bottle",
            "item_arcane_boots",
            "item_magic_wand",
            "item_aether_lens",
            "item_dagon_2",
            "item_octarine_core",--
            "item_black_king_bar",--
            "item_dagon_5",--
            "item_kaya_and_sange",--
            "item_travel_boots",
            "item_ethereal_blade",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
        
            "item_boots",
            "item_tranquil_boots",
            "item_magic_wand",
            "item_glimmer_cape",--
            "item_aether_lens",--
            "item_aghanims_shard",
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_cyclone",
            "item_lotus_orb",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
        
            "item_boots",
            "item_arcane_boots",
            "item_magic_wand",
            "item_glimmer_cape",--
            "item_aether_lens",--
            "item_aghanims_shard",
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_cyclone",
            "item_lotus_orb",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
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