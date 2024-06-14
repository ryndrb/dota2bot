local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

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
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {1,4,4,2,4,2,2,2,6,1,1,1,4,6,6},
    },
    ['pos_2'] = {
        [1] = {4,1,4,2,4,1,4,1,1,6,2,2,2,6,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_orb_of_venom",
        
            "item_boots",
            "item_orb_of_corrosion",
            "item_magic_wand",
            "item_power_treads",
            "item_echo_sabre",
            "item_desolator",--
            "item_black_king_bar",--
            "item_harpoon",--
            "item_basher",
            "item_skadi",--
            "item_travel_boots",
            "item_abyssal_blade",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_orb_of_venom",
        
            "item_bottle",
            "item_power_treads",
            "item_magic_wand",
            "item_orb_of_corrosion",
            "item_echo_sabre",
            "item_desolator",--
            "item_black_king_bar",--
            "item_harpoon",--
            "item_basher",
            "item_skadi",--
            "item_travel_boots",
            "item_abyssal_blade",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_orb_of_corrosion",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_orb_of_corrosion",
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X