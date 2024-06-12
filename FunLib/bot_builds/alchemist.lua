local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        },
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

-- ========================================================================================== -

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
        [2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_2'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
        [2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
        [2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

-- ========================================================================================== -

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_double_gauntlets",

            "item_magic_wand",
            "item_power_treads",
            "item_soul_ring",
            "item_radiance",--
            "item_blink",
            "item_black_king_bar",--
            "item_assault",--
            "item_basher",
            "item_swift_blink",--
            "item_aghanims_shard",
            "item_abyssal_blade",--
            "item_travel_boots",
            "item_moon_shard",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
        },
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_double_gauntlets",

            "item_bottle",
            "item_magic_wand",
            "item_phase_boots",
            "item_soul_ring",
            "item_radiance",--
            "item_blink",
            "item_manta",--
            "item_black_king_bar",--
            "item_basher",
            "item_swift_blink",--
            "item_aghanims_shard",
            "item_travel_boots",
            "item_abyssal_blade",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        },
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",

            "item_bracer",
            "item_boots",
            "item_soul_ring",
            "item_phase_boots",
            "item_magic_wand",
            "item_radiance",--
            "item_blink",
            "item_manta",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            sUtilityItem,--
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

-- ========================================================================================== -

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_magic_wand",
            "item_power_treads",
            "item_soul_ring",
        },
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_quelling_blade",
            "item_magic_wand",
            "item_power_treads",
            "item_soul_ring",
        },
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_soul_ring",
            "item_magic_wand",
        },
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

return X