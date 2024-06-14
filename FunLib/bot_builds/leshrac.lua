local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_lotus_orb", "item_pipe"}
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
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {3,1,3,1,3,6,3,2,2,2,2,6,1,1,6},
    },
    ['pos_3'] = {
        [1] = {3,2,2,1,2,6,2,1,1,1,6,3,3,3,6},
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
            "item_mantle",
            "item_circlet",
            "item_faerie_fire",
        
            "item_bottle",
            "item_null_talisman",
            "item_arcane_boots",
            "item_magic_wand",
            "item_cyclone",
            "item_kaya_and_sange",--
            "item_eternal_shroud",--
            "item_shivas_guard",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_travel_boots",
            "item_wind_waker",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_enchanted_mango",
        
            "item_null_talisman",
            "item_arcane_boots",
            "item_magic_wand",
            "item_kaya",
            "item_bloodstone",--
            "item_black_king_bar",--
            sUtilityItem,--
            "item_kaya_and_sange",--
            "item_aghanims_shard",
            "item_travel_boots",
            "item_shivas_guard",--
            "item_travel_boots_2",--
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
            "item_bottle",
            "item_null_talisman",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_null_talisman",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X