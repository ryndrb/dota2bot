local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
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
        [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_4'] = {
        [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_bottle",
            "item_bracer",
            "item_boots",
            "item_soul_ring",
            "item_phase_boots",
            "item_magic_wand",
            "item_blade_mail",
            "item_echo_sabre",
            "item_aghanims_shard",
            "item_desolator",--
            "item_black_king_bar",--
            "item_assault",--
            "item_harpoon",--
            "item_basher",
            "item_greater_crit",--
            "item_abyssal_blade",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_bracer",
            "item_boots",
            "item_soul_ring",
            "item_phase_boots",
            "item_magic_wand",
            "item_blade_mail",
            "item_echo_sabre",
            "item_aghanims_shard",
            "item_desolator",--
            "item_black_king_bar",--
            nUtility,--
            "item_assault",--
            "item_harpoon",--
            "item_abyssal_blade",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_branches",
            "item_double_enchanted_mango",
            "item_faerie_fire",
            "item_blood_grenade",
        
            "item_boots",
            "item_magic_stick",
            "item_tranquil_boots",
            "item_magic_wand",
            "item_pavise",
            "item_solar_crest",--
            "item_ultimate_scepter",
            "item_holy_locket",--
            nUtility,--
            "item_boots_of_bearing",--
            "item_assault",--
            "item_shivas_guard",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_branches",
            "item_double_enchanted_mango",
            "item_faerie_fire",
            "item_blood_grenade",
        
            "item_boots",
            "item_magic_stick",
            "item_arcane_boots",
            "item_magic_wand",
            "item_pavise",
            "item_guardian_greaves",--
            "item_solar_crest",--
            "item_ultimate_scepter",
            "item_holy_locket",--
            sUtilityItem,--
            "item_assault",--
            "item_shivas_guard",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bottle",
            "item_bracer",
            "item_phase_boots",
            "item_soul_ring",
            "item_magic_wand",
            "item_blade_mail",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_phase_boots",
            "item_soul_ring",
            "item_magic_wand",
            "item_blade_mail",
        }
    },
    ['pos_4'] = {
        [1] = {}
    },
    ['pos_5'] = {
        [1] = {}
    },
}

return X