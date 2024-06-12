local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = { },
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
    },
    ['pos_3'] = { },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        },
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

-- ========================================================================================== -

X.AbilityBuild = {
    ['pos_1'] = { },
    ['pos_2'] = {
        [1] = {3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},
    },
    ['pos_3'] = { },
    ['pos_4'] = {
        [1] = {3,1,2,2,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {3,1,2,2,2,6,2,1,1,1,6,3,3,3,6},
    },
}

-- ========================================================================================== -

X.BuyList = {
    ['pos_1'] = { },
    ['pos_2'] = {
        [1] = {
            "item_double_branches",
            "item_tango",
            "item_double_circlet",

            "item_bottle",
            "item_double_null_talisman",
            "item_magic_stick",
            "item_power_treads",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_witch_blade",
            "item_hurricane_pike",--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_devastator",--
            "item_satanic",--
            "item_monkey_king_bar",--
            "item_travel_boots",
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        },
    },
    ['pos_3'] = { },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_double_enchanted_mango",
            "item_faerie_fire",
            "item_blood_grenade",

            "item_tranquil_boots",
            "item_magic_wand",
            "item_force_staff",--
            "item_aghanims_shard",
            "item_veil_of_discord",
            "item_solar_crest",--
            "item_glimmer_cape",--
            "item_boots_of_bearing",--
            "item_shivas_guard",--
            "item_aeon_disk",--
            "item_ultimate_scepter_2",
            "item_moon_shard"
        },
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_double_enchanted_mango",
            "item_faerie_fire",
            "item_blood_grenade",

            "item_arcane_boots",
            "item_magic_wand",
            "item_force_staff",--
            "item_aghanims_shard",
            "item_solar_crest",--
            "item_glimmer_cape",--
            "item_guardian_greaves",--
            "item_sheepstick",--
            "item_aeon_disk",--
            "item_ultimate_scepter_2",
            "item_moon_shard"
        },
    },
}

-- ========================================================================================== -

X.SellList = {
    ['pos_1'] = { },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_null_talisman",
            "item_magic_wand",
            "item_hand_of_midas",
        },
    },
    ['pos_3'] = { },
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