local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_4'] = {
        [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_double_branches",
            "item_quelling_blade",
            "item_tango",
            "item_faerie_fire",
        
            "item_bottle",
            "item_phase_boots",
            "item_ultimate_scepter",
            "item_magic_wand",
            "item_angels_demise",--
            "item_cyclone",
            "item_octarine_core",--
            "item_black_king_bar",--
            "item_ultimate_scepter_2",
            "item_wind_waker",--
            "item_travel_boots",--
            "item_bloodthorn",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_quelling_blade",
            "item_double_branches",
        
            "item_boots",
            "item_magic_wand",
            sUtilityItem,--
            "item_guardian_greaves",--
            "item_ultimate_scepter",
            "item_sphere",--
            "item_assault",--
            "item_heart",--
            "item_ultimate_scepter_2",
            "item_sheepstick",--
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_orb_of_venom",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_ancient_janggo",
            "item_solar_crest",--
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_heavens_halberd",--
            "item_sheepstick",--
            "item_angels_demise",--
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
            "item_orb_of_venom",
        
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_ancient_janggo",
            "item_solar_crest",--
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_heavens_halberd",--
            "item_sheepstick",--
            "item_angels_demise",--
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
            "item_quelling_blade",
            "item_magic_wand",
            "item_bottle",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_orb_of_venom",
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_orb_of_venom",
            "item_magic_wand",
        }
    },
}

return X