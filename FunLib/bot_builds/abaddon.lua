local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_crimson_guard", "item_heavens_halberd", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
    },
}

-- ========================================================================================== -

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
    },
    ['pos_2'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
    },
    ['pos_3'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
    },
    ['pos_4'] = {
        [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
    },
}

-- ========================================================================================== -

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_orb_of_venom",
            "item_circlet",

            "item_wraith_band",
            "item_orb_of_corrosion",
            "item_magic_wand",
            "item_power_treads",
            "item_echo_sabre",
            "item_manta",--
            "item_harpoon",--
            "item_black_king_bar",--
            "item_skadi",--
            "item_aghanims_shard",
            "item_bloodthorn",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        },
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_orb_of_venom",
            "item_circlet",

            "item_bottle",
            "item_wraith_band",
            "item_boots",
            "item_magic_wand",
            "item_orb_of_corrosion",
            "item_phase_boots",
            "item_echo_sabre",
            "item_yasha",
            "item_harpoon",--
            "item_manta",--
            "item_ultimate_scepter_2",
            "item_assault",--
            "item_black_king_bar",--
            "item_basher",
            "item_aghanims_shard",
            "item_travel_boots",
            "item_abyssal_blade",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",

            "item_wraith_band",
            "item_orb_of_venom",
            "item_boots",
            "item_magic_wand",
            "item_orb_of_corrosion",
            "item_phase_boots",
            "item_echo_sabre",
            "item_manta",--
            "item_harpoon",--
            "item_blink",
            sUtilityItem,--
            "item_skadi",--
            "item_aghanims_shard",
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },


    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_enchanted_mango",
            "item_double_branches",
            "item_faerie_fire",
            "item_blood_grenade",

            "item_tranquil_boots",
            "item_magic_wand",
            "item_solar_crest",--
            "item_holy_locket",--
            "item_ultimate_scepter",
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_lotus_orb",--
            "item_wind_waker",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard"
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_enchanted_mango",
            "item_double_branches",
            "item_faerie_fire",
            "item_blood_grenade",

            "item_arcane_boots",
            "item_magic_wand",
            "item_solar_crest",--
            "item_holy_locket",--
            "item_ultimate_scepter",
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_lotus_orb",--
            "item_wind_waker",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard"
        }
    },
}

-- ========================================================================================== -

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_wraith_band",
            "item_magic_wand",
            "item_orb_of_corrosion",
        },
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_wraith_band",
            "item_magic_wand",
            "item_orb_of_corrosion",
        },
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_wraith_band",
            "item_magic_wand",
            "item_orb_of_corrosion",
        },
    },
    ['pos_4'] = {
        [1] = {
            "item_magic_wand",
        },
    },
    ['pos_5'] = {
        [1] = {
            "item_magic_wand",
        },
    },
}

return X