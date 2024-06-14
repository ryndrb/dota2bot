local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,2,3,1,6,1,1,2,2,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {1,2,2,3,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_4'] = {
        [1] = {1,2,2,3,1,6,1,1,2,2,3,6,3,3,6},
    },
    ['pos_5'] = {
        [1] = {1,2,2,3,1,6,1,1,2,2,3,6,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
        
            "item_bracer",
            "item_bottle",
            "item_boots",
            "item_magic_wand",
            "item_eternal_shroud",--
            "item_blink",
            "item_ultimate_scepter",
            "item_travel_boots",
            "item_bloodstone",--
            "item_black_king_bar",--
            "item_kaya_and_sange",--
            "item_ultimate_scepter_2",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_magic_stick",
            "item_ring_of_protection",
        
            "item_helm_of_iron_will",
            "item_boots",
            "item_magic_wand",
            "item_phase_boots",
            "item_veil_of_discord",
            "item_eternal_shroud",--
            "item_ultimate_scepter",
            "item_blink",
            "item_shivas_guard",--
            sUtilityItem,--
            "item_black_king_bar",--
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_flask",
            "item_enchanted_mango",
            "item_wind_lace",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_blink",
            "item_aether_lens",--
            "item_force_staff",
            "item_boots_of_bearing",--
            "item_pipe",--
            "item_lotus_orb",--
            "item_overwhelming_blink",--
            "item_wind_waker",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_flask",
            "item_enchanted_mango",
            "item_wind_lace",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_blink",
            "item_aether_lens",--
            "item_guardian_greaves",--
            "item_force_staff",
            "item_pipe",--
            "item_lotus_orb",--
            "item_overwhelming_blink",--
            "item_wind_waker",--
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
            "item_bracer",
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_ring_of_protection",
            "item_magic_wand",
        }
    },
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