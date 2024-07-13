local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe", "item_heavens_halberd"}
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
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_quelling_blade",
				"item_tango",
				"item_faerie_fire",
			
				"item_bottle",
				"item_phase_boots",
				"item_ultimate_scepter",
				"item_magic_wand",
				"item_angels_demise",--
				"item_cyclone",
				"item_octarine_core",--
				"item_black_king_bar",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_travel_boots",--
				"item_bloodthorn",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_magic_wand",
				"item_bottle",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
			
				"item_boots",
				"item_magic_wand",
				sUtilityItem,--
				"item_guardian_greaves",--
				"item_ultimate_scepter",
				"item_sphere",--
				"item_assault",--
				"item_heart",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_magic_wand",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_orb_of_venom",
			
				"item_boots",
				"item_magic_wand",
				"item_tranquil_boots",
				"item_ancient_janggo",
				"item_solar_crest",--
				"item_force_staff",--
				"item_boots_of_bearing",--
				"item_heavens_halberd",--
				"item_sheepstick",--
				"item_angels_demise",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_orb_of_venom",
				"item_magic_wand",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_orb_of_venom",
			
				"item_boots",
				"item_magic_wand",
				"item_arcane_boots",
				"item_ancient_janggo",
				"item_solar_crest",--
				"item_force_staff",--
				"item_guardian_greaves",--
				"item_heavens_halberd",--
				"item_sheepstick",--
				"item_angels_demise",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_orb_of_venom",
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

if J.Role.IsPvNMode() then X['sBuyList'], X['sSellList'] = { 'PvN_BH' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

return X