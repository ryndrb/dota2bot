local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,3,3,6,2,2,1,1,6,1,1,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_falcon_blade",
				"item_power_treads",
				"item_desolator",--
				"item_orchid",
				"item_dragon_lance",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_hurricane_pike",--
				"item_greater_crit",--
				"item_butterfly",--
				"item_moon_shard",
				"item_ultimate_scepter",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_magic_wand",
				"item_falcon_blade",
				"item_power_treads",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,3,3,6,2,2,1,1,1,6,1,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
			
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_desolator",--
				"item_orchid",
				"item_dragon_lance",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_hurricane_pike",--
				"item_sheepstick",--
				"item_butterfly",--
				"item_moon_shard",
				"item_ultimate_scepter",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,3,3,6,1,2,2,1,6,1,1,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_double_tango",
				"item_blood_grenade",
				"item_blight_stone",
			
				"item_boots",
				"item_magic_wand",
				"item_tranquil_boots",
				"item_orchid",
				"item_desolator",--
				"item_force_staff",
				"item_boots_of_bearing",--
				"item_bloodthorn",--
				"item_sheepstick",--
				"item_hurricane_pike",--
				"item_greater_crit",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,3,3,6,1,2,2,1,6,1,1,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_double_tango",
				"item_blood_grenade",
				"item_blight_stone",
			
				"item_boots",
				"item_magic_wand",
				"item_arcane_boots",
				"item_orchid",
				"item_desolator",--
				"item_force_staff",
				"item_guardian_greaves",--
				"item_bloodthorn",--
				"item_sheepstick",--
				"item_hurricane_pike",--
				"item_greater_crit",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

return X