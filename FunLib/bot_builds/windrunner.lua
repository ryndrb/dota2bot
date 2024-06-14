local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_heavens_halberd", "item_nullifier"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
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
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
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
    ['pos_1'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,1,6,1,1,6},
    },
    ['pos_2'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,1,6,1,1,6},
    },
    ['pos_3'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_4'] = {
        [1] = {3,1,1,2,2,6,2,2,1,1,3,3,3,6,6},
    },
    ['pos_5'] = {
        [1] = {3,1,1,2,2,6,2,2,1,1,3,3,3,6,6},
    },
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_double_circlet",
        
            "item_double_bracer",
            "item_power_treads",
            "item_magic_wand",
            "item_maelstrom",
            "item_dragon_lance",
            "item_black_king_bar",--
            "item_gungir",--
            "item_greater_crit",--
            "item_ultimate_scepter",
            "item_hurricane_pike",--
            "item_travel_boots",
            "item_monkey_king_bar",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_double_circlet",
        
            "item_bottle",
            "item_double_bracer",
            "item_power_treads",
            "item_magic_wand",
            "item_maelstrom",
            "item_dragon_lance",
            "item_black_king_bar",--
            "item_gungir",--
            "item_greater_crit",--
            "item_ultimate_scepter",
            "item_sheepstick",--
            "item_travel_boots",
            "item_monkey_king_bar",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_double_circlet",
        
            "item_magic_wand",
            "item_double_bracer",
            "item_power_treads",
            "item_maelstrom",
            "item_black_king_bar",--
            "item_ultimate_scepter",
            sUtilityItem,--
            "item_gungir",--
            "item_sheepstick",--
            "item_travel_boots",
            "item_ultimate_scepter_2",
            "item_monkey_king_bar",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_faerie_fire",
            "item_double_enchanted_mango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_solar_crest",--
            "item_blink",
            "item_aghanims_shard",
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_lotus_orb",--
            "item_gungir",--
            "item_swift_blink",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_faerie_fire",
            "item_double_enchanted_mango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_solar_crest",--
            "item_blink",
            "item_aghanims_shard",
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_lotus_orb",--
            "item_gungir",--
            "item_swift_blink",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_bracer",
            "item_magic_wand",
            "item_dragon_lance",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_bracer",
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