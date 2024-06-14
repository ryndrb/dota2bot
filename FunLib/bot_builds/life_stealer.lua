local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,1,3,3,6,3,2,2,2,1,6,1,1,6},
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_branches",
            "item_faerie_fire",
            "item_quelling_blade",
            "item_double_gauntlets",
        
            "item_orb_of_corrosion",
            "item_phase_boots",
            "item_armlet",
            RI.GetAltItem("item_desolator", "item_radiance"),--
            "item_sange_and_yasha",--
            "item_aghanims_shard",
            "item_basher",
            "item_nullifier",--
            "item_abyssal_blade",--
            "item_bloodthorn",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_branches",
            "item_quelling_blade",
            "item_gauntlets",
            "item_orb_of_corrosion",
            "item_armlet",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X