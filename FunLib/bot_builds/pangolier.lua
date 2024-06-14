local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_lotus_orb", "item_crimson_guard", "item_pipe", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
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
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {2,1,2,1,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {2,1,3,2,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_faerie_fire",
        
            "item_bottle",
            "item_magic_wand",
            "item_arcane_boots",
            "item_diffusal_blade",
            "item_mage_slayer",--
            "item_blink",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_basher",
            "item_disperser",--
            "item_octarine_core",--
            "item_abyssal_blade",--
            "item_ultimate_scepter_2",
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_tango",
            "item_double_branches",
        
            "item_bracer",
            "item_arcane_boots",
            "item_magic_wand",
            "item_diffusal_blade",
            "item_blink",
            sUtilityItem,--
            "item_mage_slayer",--
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_octarine_core",--
            "item_disperser",--
            "item_ultimate_scepter_2",
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X