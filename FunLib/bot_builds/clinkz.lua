local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {
            {2,3,2,3,3,6,2,2,1,1,6,1,1,3,6},
        }
    },
    ['pos_2'] = {
        [1] = {
            {2,3,2,3,3,6,2,2,1,1,1,6,1,3,6},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {2,3,2,3,3,6,1,2,2,1,6,1,1,3,6},
    },
    ['pos_5'] = {
        [1] = {2,3,2,3,3,6,1,2,2,1,6,1,1,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_magic_wand",
            "item_falcon_blade",
            "item_power_treads",
            "item_desolator",--
            "item_orchid",
            "item_dragon_lance",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_hurricane_pike",--
            "item_greater_crit",--
            "item_butterfly",--
            "item_moon_shard",
            "item_ultimate_scepter",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_magic_stick",
        
            "item_bottle",
            "item_magic_wand",
            "item_power_treads",
            "item_desolator",--
            "item_orchid",
            "item_dragon_lance",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_hurricane_pike",--
            "item_sheepstick",--
            "item_butterfly",--
            "item_moon_shard",
            "item_ultimate_scepter",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_branches",
            "item_double_tango",
            "item_blood_grenade",
            "item_blight_stone",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_orchid",
            "item_desolator",--
            "item_force_staff",
            "item_boots_of_bearing",--
            "item_bloodthorn",--
            "item_sheepstick",--
            "item_hurricane_pike",--
            "item_greater_crit",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_branches",
            "item_double_tango",
            "item_blood_grenade",
            "item_blight_stone",
        
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_orchid",
            "item_desolator",--
            "item_force_staff",
            "item_guardian_greaves",--
            "item_bloodthorn",--
            "item_sheepstick",--
            "item_hurricane_pike",--
            "item_greater_crit",--
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
            "item_magic_wand",
            "item_falcon_blade",
            "item_power_treads",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_magic_wand",
            "item_power_treads",
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