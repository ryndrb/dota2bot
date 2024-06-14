local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

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
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_2'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
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
            "item_slippers",
            "item_circlet",
        
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
            "item_diffusal_blade",
            "item_manta",--
            "item_ultimate_scepter",
            "item_greater_crit",--
            "item_basher",
            "item_sphere",--
            "item_disperser",--
            "item_abyssal_blade",--
            "item_ultimate_scepter_2",
            "item_monkey_king_bar",--
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_slippers",
            "item_circlet",
        
            "item_bottle",
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
            "item_diffusal_blade",
            "item_manta",--
            "item_ultimate_scepter",
            "item_greater_crit",--
            "item_basher",
            "item_sphere",--
            "item_disperser",--
            "item_nullifier",--
            "item_ultimate_scepter_2",
            "item_abyssal_blade",--
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
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_quelling_blade",
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X