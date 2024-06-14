local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {1,3,1,3,1,6,1,3,3,2,2,6,2,2,6},
    },
    ['pos_2'] = {
        [1] = {1,3,1,3,1,6,1,3,3,2,2,6,2,2,6},
    },
    ['pos_3'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_circlet",
        
            "item_double_bracer",
            "item_power_treads",
            "item_magic_wand",
            "item_ring_of_basilius",
            "item_echo_sabre",
            "item_manta",--
            "item_aghanims_shard",
            "item_harpoon",--
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_skadi",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_circlet",
        
            "item_bottle",
            "item_double_bracer",
            "item_power_treads",
            "item_magic_wand",
            "item_ring_of_basilius",
            "item_echo_sabre",
            "item_manta",--
            "item_aghanims_shard",
            "item_harpoon",--
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_travel_boots",
            "item_skadi",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_magic_stick",
            "item_quelling_blade",
        
            "item_magic_wand",
            "item_helm_of_the_dominator",
            "item_ring_of_basilius",
            "item_helm_of_the_overlord",--
            "item_vladmir",--
            "item_ancient_janggo",
            "item_aghanims_shard",
            "item_assault",--
            sUtilityItem,--
            "item_travel_boots",
            "item_sheepstick",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_bracer",
            "item_magic_wand",
            "item_ring_of_basilius",            
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_bracer",
            "item_magic_wand",
            "item_ring_of_basilius",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_magic_wand",
            "item_ancient_janggo",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X