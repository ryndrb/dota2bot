local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
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
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,3,2,3,6,3,2,2,1,6,1,1,1,6},
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_quelling_blade",
            "item_enchanted_mango",
            "item_double_branches",
        
            "item_magic_wand",
            "item_falcon_blade",
            "item_power_treads",
            "item_lesser_crit",
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_satanic",--
            "item_greater_crit",--
            "item_skadi",--
            "item_butterfly",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_boots",
            "item_ring_of_basilius",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_aghanims_shard",
            "item_glimmer_cape",--
            "item_boots_of_bearing",--
            "item_force_staff",--
            "item_lotus_orb",--
            "item_octarine_core",--
            "item_shivas_guard",--
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
            "item_ring_of_basilius",
            "item_magic_wand",
            "item_arcane_boots",
            "item_aghanims_shard",
            "item_glimmer_cape",--
            "item_guardian_greaves",--
            "item_force_staff",--
            "item_lotus_orb",--
            "item_octarine_core",--
            "item_shivas_guard",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_magic_wand",
            "item_falcon_blade",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_ring_of_basilius",
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