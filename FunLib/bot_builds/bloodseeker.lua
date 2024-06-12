local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {
        [1] = {
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
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {3,2,3,1,3,6,1,1,1,3,6,2,2,2,6},
    },
    ['pos_2'] = {
        [1] = {3,2,3,1,3,6,1,1,1,3,6,2,2,2,6},
    },
    ['pos_3'] = {
        {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_slippers",
            "item_circlet",
        
            "item_wraith_band",
            "item_phase_boots",
            "item_maelstrom",
            "item_magic_wand",
            "item_black_king_bar",--
            "item_mjollnir",--
            "item_basher",
            "item_aghanims_shard",
            "item_butterfly",--
            "item_abyssal_blade",--
            "item_skadi",--
            "item_monkey_king_bar",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_slippers",
            "item_circlet",
        
            "item_wraith_band",
            "item_bottle",
            "item_phase_boots",
            "item_maelstrom",
            "item_magic_wand",
            "item_black_king_bar",--
            "item_mjollnir",--
            "item_basher",
            "item_aghanims_shard",
            "item_butterfly",--
            "item_sheepstick",--
            "item_travel_boots",
            "item_abyssal_blade",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_double_wraith_band",
            "item_boots",
            "item_magic_wand",
            "item_phase_boots",
            "item_maelstrom",
            "item_black_king_bar",--
            "item_gungir",--
            "item_heavens_halberd",--
            sUtilityItem,--
            "item_basher",
            "item_travel_boots",
            "item_abyssal_blade",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_wraith_band",
            "item_phase_boots",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_quelling_blade",
            "item_wraith_band",
            "item_phase_boots",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_wraith_band",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X