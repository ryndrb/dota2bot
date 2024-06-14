local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_heavens_halberd", "item_crimson_guard", "item_pipe", "item_nullifier"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local sBlinkUpgrade = RandomInt(1, 2) == 1 and "item_swift_blink" or "item_overwhelming_blink"

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
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
    ['pos_1'] = {
        [1] = {3,1,3,2,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_2'] = {
        [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_4'] = {
        [1] = {3,1,2,1,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {3,1,2,1,1,6,1,2,2,2,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_quelling_blade",
            "item_slippers",
            "item_circlet",
            "item_double_branches",
        
            "item_wraith_band",
            "item_magic_wand",
            "item_power_treads",
            "item_echo_sabre",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_harpoon",--
            "item_greater_crit",--
            "item_sange_and_yasha",--
            "item_satanic",--
            "item_moon_shard",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_quelling_blade",
        
            "item_bottle",
            "item_power_treads",
            "item_magic_wand",
            "item_blink",
            "item_echo_sabre",
            "item_phylactery",
            "item_black_king_bar",--
            "item_angels_demise",--
            "item_aghanims_shard",
            "item_assault",--
            "item_travel_boots",
            "item_moon_shard",
            "item_monkey_king_bar",--
            sBlinkUpgrade,--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_slippers",
            "item_circlet",
            "item_quelling_blade",
        
            "item_wraith_band",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_echo_sabre",
            "item_blink",
            "item_phylactery",
            sUtilityItem,--
            "item_black_king_bar",--
            "item_angels_demise",--
            "item_aghanims_shard",
            "item_assault",--
            "item_travel_boots",
            sBlinkUpgrade,--
            "item_moon_shard",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_boots",
            "item_ring_of_basilius",
            "item_blink",
            "item_tranquil_boots",
            "item_magic_wand",
            "item_cyclone",
            "item_force_staff",--
            "item_phylactery",
            "item_boots_of_bearing",--
            "item_wind_waker",--
            "item_angels_demise",--
            "item_octarine_core",--
            "item_overwhelming_blink",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_boots",
            "item_ring_of_basilius",
            "item_blink",
            "item_arcane_boots",
            "item_magic_wand",
            "item_cyclone",
            "item_force_staff",--
            "item_phylactery",
            "item_guardian_greaves",--
            "item_wind_waker",--
            "item_angels_demise",--
            "item_octarine_core",--
            "item_overwhelming_blink",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_wraith_band",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bottle",
            "item_magic_wand",
            "item_echo_sabre",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_wraith_band",
            "item_magic_wand",
            "item_echo_sabre",
        }
    },
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