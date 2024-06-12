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
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,2,1,2,6,2,1,1,3,6,3,3,3,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,1,6,1,1,6},
    },
    ['pos_5'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,1,6,1,1,6},
    },
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
            "item_magic_wand",
            "item_arcane_boots",
            "item_urn_of_shadows",
            "item_phylactery",
            "item_hand_of_midas",
            "item_spirit_vessel",
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_kaya_and_sange",--
            "item_angels_demise",--
            "item_black_king_bar",--
            "item_hurricane_pike",--
            "item_travel_boots",
            "item_octarine_core",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_circlet",
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_aether_lens",--
            "item_solar_crest",--
            "item_glimmer_cape",--
            "item_aghanims_shard",
            "item_boots_of_bearing",--
            "item_ultimate_scepter",
            "item_aeon_disk",--
            "item_refresher",--
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
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_aether_lens",--
            "item_glimmer_cape",--
            "item_aghanims_shard",
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_ultimate_scepter",
            "item_aeon_disk",--
            "item_refresher",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
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
            "item_hand_of_midas",
            "item_spirit_vessel",
        }
    },
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