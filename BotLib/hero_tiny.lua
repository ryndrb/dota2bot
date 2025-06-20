local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_tiny'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_heavens_halberd", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                [1] = {3,1,3,2,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
				"item_magic_stick",
			
				"item_wraith_band",
				"item_magic_wand",
				"item_power_treads",
				"item_echo_sabre",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_assault",--
				"item_harpoon",--
				"item_satanic",--
				"item_greater_crit",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_assault",
				"item_magic_wand", "item_satanic",
				"item_wraith_band", "item_greater_crit",
			},
        },
    },
    ['pos_2'] = {
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
                [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_quelling_blade",
			
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_blink",
				"item_echo_sabre",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_octarine_core",--
				"item_harpoon",--
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_octarine_core",
				"item_bottle", "item_assault",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_magic_wand",
				"item_double_bracer",
				"item_power_treads",
				"item_blink",
				"item_crimson_guard",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_assault",--
				"item_octarine_core",--
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_assault",
				"item_bracer", "item_octarine_core",
			},
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
                [1] = {3,1,2,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_wind_lace",
			
				"item_boots",
				"item_magic_wand",
				"item_tranquil_boots",
				"item_blink",
				"item_ancient_janggo",
				"item_cyclone",
				"item_boots_of_bearing",--
				"item_lotus_orb",--
				"item_octarine_core",--
				"item_aghanims_shard",
				"item_wind_waker",--
				"item_black_king_bar",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_overwhelming_blink",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,1,2,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_wind_lace",
			
				"item_boots",
				"item_magic_wand",
				"item_arcane_boots",
				"item_blink",
				"item_mekansm",
				"item_cyclone",
				"item_guardian_greaves",--
				"item_lotus_orb",--
				"item_octarine_core",--
				"item_aghanims_shard",
				"item_wind_waker",--
				"item_black_king_bar",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_overwhelming_blink",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
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

end

local Avalanche     = bot:GetAbilityByName("tiny_avalanche")
local Toss          = bot:GetAbilityByName("tiny_toss")
local TreeGrab      = bot:GetAbilityByName("tiny_tree_grab")
local TreeThrow     = bot:GetAbilityByName("tiny_toss_tree")
local TreeVolley    = bot:GetAbilityByName("tiny_tree_channel")
local Grow  	  	= bot:GetAbilityByName("tiny_grow")

local AvalancheDesire, AvalancheLocation
local TossDesire, TossTarget
local TreeGrabDesire, TreeGrabTarget
local TreeThrowDesire, TreeThrowTarget
local TreeVolleyDesire, TreeVolleyTarget

local BlinkTossDesire, BlinkTossTarget

local bHaveTargetTossTalent = false
local nAllyHeroes, nEnemyHeroes
local botTarget, botName, botHP

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	if botName ~= 'npc_dota_hero_tiny' then
		Avalanche     = bot:GetAbilityByName("tiny_avalanche")
		Toss          = bot:GetAbilityByName("tiny_toss")
		TreeGrab      = bot:GetAbilityByName("tiny_tree_grab")
		TreeThrow     = bot:GetAbilityByName("tiny_toss_tree")
		TreeVolley    = bot:GetAbilityByName("tiny_tree_channel")
	else
		local hTossTalent = bot:GetAbilityByName('special_bonus_unique_tiny_5')
		bHaveTargetTossTalent = hTossTalent and hTossTalent:IsTrained()
	end

	nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	botTarget = J.GetProperTarget(bot)
	botName = GetBot():GetUnitName()
	botHP = J.GetHP(bot)

	BlinkTossDesire, BlinkTossTarget = X.ConsiderBlinkToss()
	if BlinkTossDesire > 0 then
		bot:Action_ClearActions(false)
		bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkTossTarget:GetLocation())
		bot:ActionQueue_UseAbilityOnEntity(Toss, BlinkTossTarget)
		return
	end

	TossDesire, TossTarget, bLocation = X.ConsiderToss()
	if TossDesire > 0 then
		if bLocation then
			bot:Action_UseAbilityOnLocation(Toss, TossTarget)
		else
			bot:Action_UseAbilityOnEntity(Toss, TossTarget)
		end
		return
	end

	AvalancheDesire, AvalancheLocation = X.ConsiderAvalanche()
	if AvalancheDesire > 0 then
		bot:Action_UseAbilityOnLocation(Avalanche, AvalancheLocation)
		return
	end

	TreeGrabDesire, TreeGrabTarget = X.ConsiderTreeGrab()
	if TreeGrabDesire > 0 then
		bot:Action_UseAbilityOnTree(TreeGrab, TreeGrabTarget)
		return
	end

	TreeThrowDesire, TreeThrowTarget = X.ConsiderTreeThrow()
	if TreeThrowDesire > 0 then
		bot:Action_UseAbilityOnEntity(TreeThrow, TreeThrowTarget)
		return
	end

	TreeVolleyDesire, TreeVolleyTarget = X.ConsiderTreeVolley()
	if TreeVolleyDesire > 0 then
		bot:Action_UseAbilityOnLocation(TreeVolley, TreeVolleyTarget)
		return
	end
end

function X.ConsiderAvalanche()
    if not J.CanCastAbility(Avalanche) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Avalanche:GetCastRange())
	local nRadius = Avalanche:GetSpecialValueInt('radius')
	local nDamage = Avalanche:GetSpecialValueInt('avalanche_damage')
	local nProjectileSpeed = Avalanche:GetSpecialValueInt('projectile_speed')
	local nManaAfter = J.GetManaAfter(Avalanche:GetManaCost())

	for _, enemyHero in ipairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, GetUnitToUnitDistance(bot, enemyHero) / nProjectileSpeed)
			and J.CanBeAttacked(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if not J.IsInRange(bot, botTarget, nCastRange) then
				if J.IsChasingTarget(bot, botTarget) then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nCastRange)
				end
			else
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemy in ipairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and J.IsInRange(bot, enemy, nCastRange + nRadius)
			and J.CanCastOnNonMagicImmune(enemy)
			then
				if J.IsInRange(bot, enemy, nCastRange) then
					local nInRangeEnemy = J.GetEnemiesNearLoc(enemy:GetLocation(), nRadius)
					if #nInRangeEnemy >= 2 and (bot:WasRecentlyDamagedByAnyHero(2.0) or #nInRangeEnemy >= 3) then
						return BOT_MODE_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
					end

					if J.IsChasingTarget(enemy, bot) and botHP < 0.5 and (bot:WasRecentlyDamagedByAnyHero(2.0) or #nInRangeEnemy >= 2) then
						return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
					end
				else
					if J.IsChasingTarget(enemy, bot) and botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(3.0) then
						return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemy:GetLocation(), nCastRange)
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)

	if J.IsPushing(bot) and nManaAfter > 0.45 and #nAllyHeroes <= 2 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsDefending(bot) and nManaAfter > 0.4 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsFarming(bot) and nManaAfter > 0.4 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 3 or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase()
	and (J.IsCore(bot) or not J.IsThereCoreNearby(1200))
	and nManaAfter > 0.45
	then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.IsInRange(bot, creep, nCastRange)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
				local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)
				if J.IsValidHero(nInRangeEnemy[1]) and J.GetHP(nInRangeEnemy[1]) < 0.5 then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) and nManaAfter > 0.4 then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) and nManaAfter > 0.4 then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsValid(nEnemyCreeps[1])
	and J.CanBeAttacked(nEnemyCreeps[1])
	and not J.IsRunning(nEnemyCreeps[1])
	and nManaAfter > 0.5
	then
		local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, nDamage)
		if nLocationAoE.count >= 4 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderToss()
    if not J.CanCastAbility(Toss) then
		return BOT_ACTION_DESIRE_NONE, nil, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, Toss:GetCastRange())
	local nDamage = Toss:GetSpecialValueInt('toss_damage')
	local nLandingRadius = Toss:GetSpecialValueInt('radius')
	local nGrabRadius = Toss:GetSpecialValueInt('grab_radius')
	local fDuration = Toss:GetSpecialValueFloat('duration')

	local nAllyCreeps = bot:GetNearbyCreeps(nGrabRadius, true)
	local nEnemyCreeps = bot:GetNearbyCreeps(nGrabRadius, true)

	local hClosestAlly = X.GetClosestAlly(nAllyHeroes, nGrabRadius)

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling() and (Avalanche ~= nil and Avalanche:IsTrained() and not Avalanche:IsCooldownReady()) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, false
			end

			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fDuration)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				if J.IsInRange(bot, enemyHero, nGrabRadius) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, false
				end

				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nGrabRadius)
				if (#nAllyCreeps >= 1 or #nEnemyCreeps >= 1) and #nInRangeAlly == 0 then
					if bHaveTargetTossTalent then
						return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, fDuration), true
					else
						return BOT_ACTION_DESIRE_HIGH, enemyHero, false
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		local hTarget__InAllyUltimate = nil
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and (enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				or enemyHero:HasModifier('modifier_enigma_black_hole_pull'))
			then
				hTarget__InAllyUltimate = enemyHero
				break
			end
		end

		if hTarget__InAllyUltimate ~= nil then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if hTarget__InAllyUltimate ~= enemyHero
				and J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and J.IsInRange(bot, enemyHero, nGrabRadius)
				and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
				and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					return BOT_ACTION_DESIRE_HIGH, hTarget__InAllyUltimate, false
				end
			end
		end

		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_legion_commander_duel')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
			local bWeAreStronger = J.WeAreStronger(bot, 1600)
			if #nInRangeAlly >= #nInRangeEnemy or bWeAreStronger then
				if J.IsInRange(bot, botTarget, nGrabRadius) then
					if J.CanCastOnNonMagicImmune(botTarget) then
						return BOT_ACTION_DESIRE_HIGH, botTarget, false
					end
				end

				local nEnemyTowers = botTarget:GetNearbyTowers(1200, false)

				if J.IsValidHero(hClosestAlly)
				and hClosestAlly ~= bot
				and J.GetHP(hClosestAlly) > 0.5
				and J.IsInRange(bot, hClosestAlly, nGrabRadius)
				and not J.IsInRange(bot, botTarget, nCastRange / 2)
				and not J.IsSuspiciousIllusion(hClosestAlly)
				and not J.IsRetreating(hClosestAlly)
				and not hClosestAlly:HasModifier('modifier_necrolyte_reapers_scythe')
				and not hClosestAlly:HasModifier('modifier_legion_commander_duel')
				and #nEnemyTowers == 0
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget, false
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], nGrabRadius)
		and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
		and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local vTossLocation = J.VectorAway(nEnemyHeroes[1]:GetLocation(), bot:GetLocation(), nCastRange)

			local nLocationAoE__AllyHeroes = bot:FindAoELocation(false, true, bot:GetLocation(), 0, nGrabRadius, 0, 0)
			local nLocationAoE__AllyCreeps = bot:FindAoELocation(false, false, bot:GetLocation(), 0, nGrabRadius, 0, 0)
			local nLocationAoE__EnemyCreeps = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nGrabRadius, 0, 0)

			if bHaveTargetTossTalent then
				if (nLocationAoE__AllyHeroes.count == 0 and nLocationAoE__AllyCreeps.count == 0 and nLocationAoE__EnemyCreeps.count == 0) then
					if J.IsChasingTarget(nEnemyHeroes[1], bot) and botHP < 0.6 and bot:WasRecentlyDamagedByAnyHero(3.0) then
						return BOT_ACTION_DESIRE_HIGH, vTossLocation, true
					end
				end
			else
				local hFurthestTossTarget = nil
				local hFurthestTossTargetDistance = math.huge
				local unitList = GetUnitList(UNIT_LIST_ENEMIES)
				for _, unit in ipairs(unitList) do
					if J.IsValid(unit)
					and (unit:IsCreep() or unit:IsHero())
					and unit ~= nEnemyHeroes[1]
					and J.CanCastOnTargetAdvanced(unit)
					and J.IsInRange(bot, unit, nCastRange)
					and not J.IsInRange(bot, unit, nCastRange / 2)
					then
						if GetUnitToLocationDistance(unit, vTossLocation) <= 500 then
							local unitDistance = GetUnitToLocationDistance(unit, J.GetEnemyFountain())
							if unitDistance < hFurthestTossTargetDistance then
								hFurthestTossTarget = unit
								hFurthestTossTargetDistance = unitDistance
							end
						end
					end
				end

				if hFurthestTossTarget then
					return BOT_ACTION_DESIRE_HIGH, hFurthestTossTarget, false
				end
			end
		end

		if bot ~= hClosestAlly
		and J.IsValidHero(hClosestAlly)
		and J.IsInRange(bot, hClosestAlly, nGrabRadius)
		and J.IsRetreating(hClosestAlly)
		and not J.IsSuspiciousIllusion(hClosestAlly)
		and not hClosestAlly:HasModifier('modifier_necrolyte_reapers_scythe')
		and not hClosestAlly:HasModifier('modifier_legion_commander_duel')
		and J.GetHP(hClosestAlly) < 0.5
		then
			local vTossLocation = J.VectorAway(nEnemyHeroes[1]:GetLocation(), bot:GetLocation(), nCastRange)

			if bHaveTargetTossTalent then
				for _, enemy in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemy) and not J.IsSuspiciousIllusion(enemy) and J.IsChasingTarget(enemy, hClosestAlly) then
						return BOT_ACTION_DESIRE_HIGH, vTossLocation, true
					end
				end
			else
				local hFurthestTossTarget = nil
				local hFurthestTossTargetDistance = math.huge
				for _, ally in ipairs(nAllyHeroes) do
					if bot ~= ally
					and hClosestAlly ~= ally
					and J.IsValidHero(ally)
					and J.IsInRange(bot, ally, nCastRange)
					and not J.IsInRange(bot, ally, nCastRange / 2)
					then
						if GetUnitToLocationDistance(ally, vTossLocation) <= 500 then
							local unitDistance = GetUnitToLocationDistance(ally, J.GetTeamFountain())
							if unitDistance < hFurthestTossTargetDistance then
								hFurthestTossTarget = ally
								hFurthestTossTargetDistance = unitDistance
							end
						end
					end
				end

				if hFurthestTossTarget then
					return BOT_ACTION_DESIRE_HIGH, hFurthestTossTarget, false
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil, false
end

function X.ConsiderTreeGrab()
	if not J.CanCastAbility(TreeGrab)
	or bot:HasModifier('modifier_tiny_tree_grab')
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)

	if  not J.IsRetreating(bot)
	and botHP > 0.15
	and bot:DistanceFromFountain() > 800
	then
		local nTrees = bot:GetNearbyTrees(1200)
		if nTrees ~= nil and #nTrees > 0 then
			local vTreeLocation = GetTreeLocation(nTrees[1])
			if (IsLocationVisible(vTreeLocation) or IsLocationPassable(vTreeLocation))
			and (#nInRangeEnemy == 0 or GetUnitToLocationDistance(bot, vTreeLocation) <= 200)
			then
				return BOT_ACTION_DESIRE_HIGH, nTrees[1]
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTreeThrow()
	if not J.CanCastAbility(TreeThrow)
	or not bot:HasModifier('modifier_tiny_tree_grab')
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, TreeThrow:GetCastRange())
	local fCastPoint = TreeThrow:GetCastPoint()
	local nDamage = bot:GetAttackDamage() + TreeGrab:GetSpecialValueInt('bonus_damage')
	local nProjectileSpeed = TreeThrow:GetSpecialValueInt('speed')
	local nAttackCount = bot:GetModifierStackCount(bot:GetModifierByName('modifier_tiny_tree_grab'))

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL, fCastPoint + (GetUnitToUnitDistance(bot, enemyHero) / nProjectileSpeed))
			and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsChasingTarget(bot, botTarget)
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and nAttackCount <= 1
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
		for _, enemy in ipairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.CanCastOnTargetAdvanced(enemy)
			and J.IsInRange(bot, enemy, nCastRange)
			and not J.IsInRange(bot, enemy, nCastRange / 2)
			and J.IsChasingTarget(enemy, bot)
			then
				if botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(3.0) then
					return BOT_ACTION_DESIRE_HIGH, enemy
				end
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase()
	and (J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1200)))
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, fCastPoint + (GetUnitToUnitDistance(bot, creep) / nProjectileSpeed))
			then
				if (bot:GetAttackTarget() ~= creep and nAttackCount <= 1)
				or (J.IsValidHero(nEnemyHeroes[1]) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) and J.IsInRange(creep, nEnemyHeroes[1], nEnemyHeroes[1]:GetAttackRange() + 300))
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTreeVolley()
	if not J.CanCastAbility(TreeVolley) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, TreeVolley:GetCastRange())
	local fCastPoint = TreeVolley:GetCastPoint()
	local nRadius = TreeVolley:GetSpecialValueInt('tree_grab_radius')
	local nSplashRadius = TreeVolley:GetSpecialValueInt('splash_radius')
	local nProjectileSpeed = TreeVolley:GetSpecialValueInt('speed')

	local nManaAfter = J.GetManaAfter(TreeVolley)
	local nManaThreshold = math.huge
	if Avalanche and Avalanche:IsTrained() and Toss and Toss:IsTrained() then
		nManaThreshold = (Avalanche:GetManaCost() + Toss:GetManaCost() + 150) / bot:GetMaxMana()
	end

	if nManaAfter < nManaThreshold then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		local nTrees = bot:GetNearbyTrees(nRadius)

		if #nTrees >= 3 and #nInRangeAlly >= #nInRangeEnemy then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nSplashRadius, fCastPoint, 0)
			nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
			if #nInRangeEnemy >= 2 then
				local count = 0
				for _, enemy in ipairs(nInRangeEnemy) do
					if J.IsValidHero(enemy) and J.CanBeAttacked(enemy) then
						count = count + 1
					end
				end

				if count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, nCastRange / 2)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
			local nTrees = bot:GetNearbyTrees(nRadius)

			if #nTrees >= 3 and #nInRangeAlly >= #nInRangeEnemy and not (#nInRangeAlly >= #nInRangeEnemy + 2) then
				local fEta = fCastPoint + (GetUnitToUnitDistance(bot, botTarget) / nProjectileSpeed)
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fEta)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBlinkToss()
    if J.CanCastAbility(Toss) and J.CanBlinkDagger(GetBot()) and bot:GetMana() >= Toss:GetManaCost()*2 then
		local nCastRange = 1199

		if J.IsGoingOnSomeone(bot) then
			if  J.IsValidTarget(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and not J.IsInRange(bot, botTarget, 600)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_legion_commander_duel')
			and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
				local bWeAreStronger = J.WeAreStronger(bot, 1600)

				if #nInRangeAlly >= #nInRangeEnemy or bWeAreStronger then
					local allyTarget = nil
					local unitList = GetUnitList(UNIT_LIST_ALLIED_HEROES)
					for _, allyHero in pairs(unitList) do
						if bot ~= allyHero
						and J.IsValidHero(allyHero)
						and J.IsInRange(allyHero, botTarget, nCastRange)
						and J.GetHP(allyHero) > 0.3
						and not J.IsInRange(bot, allyHero, 600)
						and not J.IsRetreating(allyHero)
						and not J.IsSuspiciousIllusion(allyHero)
						then
							allyTarget = allyHero
							break
						end
					end

					if allyTarget ~= nil then
						local nLocationAoE__AllyHeroes = bot:FindAoELocation(false, true, allyTarget:GetLocation(), 0, 275, 0, 0)
						local nLocationAoE__EnemyHeroes = bot:FindAoELocation(true, true, allyTarget:GetLocation(), 0, 275, 0, 0)
						local nLocationAoE__AllyCreeps = bot:FindAoELocation(false, false, allyTarget:GetLocation(), 0, 275, 0, 0)
						local nLocationAoE__EnemyCreeps = bot:FindAoELocation(true, false, allyTarget:GetLocation(), 0, 275, 0, 0)
						if  (nLocationAoE__AllyHeroes.count == 0 and nLocationAoE__EnemyHeroes.count <= 1)
						and (nLocationAoE__AllyCreeps.count == 0 and nLocationAoE__EnemyCreeps.count == 0)
						then
							bot.shouldBlink = true
							return BOT_ACTION_DESIRE_HIGH, allyTarget
						end
					end
				end
			end
		end
    end

	bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE
end

function X.GetClosestAlly(hUnitList, nGrabRadius)
	local closest = nil
	local closestDistance = 0
	for _, ally in ipairs(hUnitList) do
		if J.IsValidHero(ally) and not J.IsSuspiciousIllusion(ally) and ally ~= bot and J.IsInRange(bot, ally, nGrabRadius) then
			local allyDistance = GetUnitToUnitDistance(bot, ally)
			if allyDistance < closestDistance then
				closest = ally
				closestDistance = allyDistance
			end
		end
	end

	return closest
end

return X