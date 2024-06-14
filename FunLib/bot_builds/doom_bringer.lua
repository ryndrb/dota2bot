local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
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
        [1] = {1,2,1,2,1,6,2,2,1,3,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
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
            "item_magic_stick",
        
            "item_bottle",
            "item_helm_of_iron_will",
            "item_boots",
            "item_magic_wand",
            "item_phase_boots",
            "item_shivas_guard",--
            "item_blink",
            "item_black_king_bar",--
            "item_octarine_core",--
            "item_travel_boots",
            "item_aghanims_shard",
            "item_overwhelming_blink",--
            "item_refresher",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_magic_stick",
            "item_enchanted_mango",
        
            "item_helm_of_iron_will",
            "item_boots",
            "item_magic_wand",
            "item_phase_boots",
            "item_shivas_guard",--
            "item_blink",
            "item_black_king_bar",--
            "item_octarine_core",--
            sUtilityItem,--
            "item_aghanims_shard",
            "item_overwhelming_blink",--
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
            "item_quelling_blade",
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X