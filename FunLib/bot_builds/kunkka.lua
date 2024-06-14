local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
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
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {2,1,2,3,2,6,2,3,3,3,1,6,1,1,6},
    },
    ['pos_3'] = {
        [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
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
            "item_gauntlets",
            "item_circlet",
        
            "item_bottle",
            "item_bracer",
            "item_phase_boots",
            "item_magic_wand",
            "item_blade_mail",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_shivas_guard",--
            "item_octarine_core",--
            "item_travel_boots",
            "item_heart",--
            "item_refresher",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_moon_shard"
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_double_gauntlets",
        
            "item_double_bracer",
            "item_phase_boots",
            "item_magic_wand",
            "item_blade_mail",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_shivas_guard",--
            "item_refresher",--
            "item_sheepstick",--
            "item_travel_boots",
            "item_heart",--
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
            "item_quelling_blade",
            "item_bottle",
            "item_bracer",
            "item_magic_wand",
            "item_blade_mail",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
            "item_blade_mail",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X