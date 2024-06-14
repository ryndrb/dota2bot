local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
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
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
    },
    ['pos_3'] = {
        [1] = {1,3,3,1,3,6,3,2,1,1,6,2,2,2,6},
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
            "item_faerie_fire",
            "item_circlet",
        
            "item_bottle",
            "item_boots",
            "item_ring_of_basilius",
            "item_arcane_boots",
            "item_magic_wand",
            "item_shivas_guard",--
            "item_cyclone",
            "item_eternal_shroud",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_kaya_and_sange",--
            "item_octarine_core",--
            "item_refresher",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_circlet",
        
            "item_boots",
            "item_ring_of_basilius",
            "item_arcane_boots",
            "item_magic_wand",
            "item_shivas_guard",--
            "item_cyclone",
            "item_eternal_shroud",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            sUtilityItem,--
            "item_guardian_greaves",--
            "item_refresher",--
            "item_ultimate_scepter_2",
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
            "item_circlet",
            "item_bottle",
            "item_magic_wand",
            "item_cyclone",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X