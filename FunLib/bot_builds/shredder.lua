local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
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
        [1] = {1,3,2,2,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {1,3,2,2,2,6,2,1,1,1,6,3,3,3,6},
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
            "item_circlet",
            "item_mantle",
        
            "item_bottle",
            "item_null_talisman",
            "item_magic_wand",
            "item_arcane_boots",
            "item_blink",
            "item_kaya_and_sange",--
            "item_eternal_shroud",--
            "item_shivas_guard",--
            "item_aghanims_shard",
            "item_cyclone",
            "item_travel_boots",
            "item_wind_waker",--
            "item_arcane_blink",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard"
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_circlet",
            "item_gauntlets",
        
            "item_magic_wand",
            "item_bracer",
            "item_helm_of_iron_will",
            "item_ring_of_basilius",
            "item_arcane_boots",
            "item_veil_of_discord",
            "item_blink",
            "item_eternal_shroud",--
            "item_kaya_and_sange",--
            "item_shivas_guard",--
            sUtilityItem,--
            "item_travel_boots",
            "item_arcane_blink",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard"
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
            "item_magic_wand",
            "item_bracer",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X