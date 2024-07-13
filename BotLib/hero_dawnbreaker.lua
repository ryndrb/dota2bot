local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bottle",
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_echo_sabre",
				"item_aghanims_shard",
				"item_desolator",--
				"item_black_king_bar",--
				"item_assault",--
				"item_harpoon",--
				"item_basher",
				"item_greater_crit",--
				"item_abyssal_blade",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bottle",
				"item_bracer",
				"item_phase_boots",
				"item_soul_ring",
				"item_magic_wand",
				"item_blade_mail",
			},
        },
    },
    ['pos_3'] = {
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
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_echo_sabre",
				"item_aghanims_shard",
				"item_desolator",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_assault",--
				"item_harpoon",--
				"item_abyssal_blade",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_phase_boots",
				"item_soul_ring",
				"item_magic_wand",
				"item_blade_mail",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_double_enchanted_mango",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_stick",
				"item_tranquil_boots",
				"item_magic_wand",
				"item_pavise",
				"item_solar_crest",--
				"item_ultimate_scepter",
				"item_holy_locket",--
				sUtilityItem,--
				"item_boots_of_bearing",--
				"item_assault",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_double_enchanted_mango",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_stick",
				"item_arcane_boots",
				"item_magic_wand",
				"item_pavise",
				"item_guardian_greaves",--
				"item_solar_crest",--
				"item_ultimate_scepter",
				"item_holy_locket",--
				sUtilityItem,--
				"item_assault",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {},
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

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

return X