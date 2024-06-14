local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_heavens_halberd", "item_lotus_orb", "item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_4'] = {
        [1] = {1,2,1,3,2,6,2,2,3,3,6,3,1,1,6},
    },
    ['pos_5'] = {
        [1] = {1,2,1,3,2,6,2,2,3,3,6,3,1,1,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_quelling_blade",
        
            "item_bottle",
            "item_boots",
            "item_magic_wand",
            "item_urn_of_shadows",
            "item_spirit_vessel",
            "item_blade_mail",
            "item_heart",--
            "item_black_king_bar",--
            "item_travel_boots",
            "item_shivas_guard",--
            "item_octarine_core",--
            "item_travel_boots_2",--
            "item_sheepstick",--
        
            "item_aghanims_shard",
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_quelling_blade",
        
            "item_bracer",
            "item_magic_wand",
            "item_boots",
            "item_veil_of_discord",
            "item_blade_mail",
            "item_heart",--
            sUtilityItem,--
            "item_black_king_bar",--
            "item_travel_boots",
            "item_shivas_guard",--
            "item_octarine_core",--
            "item_travel_boots_2",--
            "item_wind_waker",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_circlet",
        
            "item_urn_of_shadows",
            "item_boots",
            "item_magic_wand",
            "item_spirit_vessel",--
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_black_king_bar",--
            "item_lotus_orb",--
            "item_shivas_guard",--
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
            "item_circlet",
        
            "item_urn_of_shadows",
            "item_boots",
            "item_magic_wand",
            "item_spirit_vessel",--
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_black_king_bar",--
            "item_lotus_orb",--
            "item_shivas_guard",--
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
            "item_bottle",
            "item_magic_wand",
            "item_spirit_vessel",
            "item_blade_mail",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
            "item_blade_mail",
        }
    },
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