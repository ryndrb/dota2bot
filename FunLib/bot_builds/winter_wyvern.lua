local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_heavens_halberd", "item_pipe", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
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
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
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
            "item_double_circlet",
        
            "item_bottle",
            "item_bracer",
            "item_wraith_band",
            "item_magic_wand",
            "item_boots",
            "item_mage_slayer",--
            "item_witch_blade",
            "item_ultimate_scepter",
            "item_bloodthorn",--
            "item_devastator",--
            "item_travel_boots",
            "item_kaya_and_sange",--
            "item_hurricane_pike",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_circlet",
        
            "item_bracer",
            "item_wraith_band",
            "item_magic_wand",
            "item_boots",
            "item_mage_slayer",--
            "item_witch_blade",
            sUtilityItem,--
            "item_ultimate_scepter",
            "item_bloodthorn",--
            "item_devastator",--
            "item_travel_boots",
            "item_kaya_and_sange",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_circlet",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_blink",
            "item_force_staff",
            "item_aether_lens",--
            "item_boots_of_bearing",--
            "item_shivas_guard",--
            "item_aghanims_shard",
            "item_refresher",--
            "item_arcane_blink",--
            "item_hurricane_pike",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
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
            "item_blink",
            "item_force_staff",
            "item_aether_lens",--
            "item_guardian_greaves",--
            "item_shivas_guard",--
            "item_aghanims_shard",
            "item_refresher",--
            "item_arcane_blink",--
            "item_hurricane_pike",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_bracer",
            "item_wraith_band",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_bracer",
            "item_wraith_band",
            "item_magic_wand",
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