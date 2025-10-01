local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local M = require( GetScriptDirectory()..'/FunLib/aba_modifiers' )

local bMagicBuild = false

if GetBot():GetUnitName() == 'npc_dota_hero_nevermore'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,5,1,5,1,6,1,5,5,4,6,4,4,4,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_magic_stick",
				"item_quelling_blade",
				
				"item_power_treads",
				"item_magic_wand",
				"item_lifesteal",
				"item_dragon_lance",
				"item_black_king_bar",--
				"item_lesser_crit",
				"item_hurricane_pike",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_greater_crit",--
				"item_butterfly",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_lesser_crit",
				"item_magic_wand", "item_butterfly",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,5,1,5,1,6,1,5,5,4,6,4,4,4,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_magic_stick",
				"item_quelling_blade",
				
				"item_bottle",
				"item_power_treads",
				"item_magic_wand",
				"item_lifesteal",
				"item_dragon_lance",
				"item_black_king_bar",--
				"item_lesser_crit",
				"item_hurricane_pike",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_greater_crit",--
				"item_butterfly",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_lesser_crit",
				"item_bottle", "item_butterfly",
			},
        },
		[2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,5,1,5,1,6,1,5,5,4,6,4,4,4,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_magic_stick",
				
				"item_bottle",
				"item_power_treads",
				"item_magic_wand",
				"item_kaya",
				"item_blink",
				"item_black_king_bar",--
				"item_yasha_and_kaya",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_bottle", "item_shivas_guard"
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
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
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
}
local build_idx = RandomInt(1, #HeroBuild[sRole])
local sSelectedBuild = HeroBuild[sRole][build_idx]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

if build_idx == 2 then bMagicBuild = true end

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

end

local ShadowRaze_Q = bot:GetAbilityByName('nevermore_shadowraze1')
local ShadowRaze_W = bot:GetAbilityByName('nevermore_shadowraze2')
local ShadowRaze_E = bot:GetAbilityByName('nevermore_shadowraze3')
local FeastOfSouls = bot:GetAbilityByName('nevermore_frenzy')
local Necromastery = bot:GetAbilityByName('nevermore_necromastery')
local DarkLord = bot:GetAbilityByName('nevermore_dark_lord')
local RequiemOfSouls = bot:GetAbilityByName('nevermore_requiem')

local ShadowRazeQ_Desire
local ShadowRazeW_Desire
local ShadowRazeE_Desire
local FeastOfSoulsDesire
local RequiemOfSoulsDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	ShadowRaze_Q = bot:GetAbilityByName('nevermore_shadowraze1')
	ShadowRaze_W = bot:GetAbilityByName('nevermore_shadowraze2')
	ShadowRaze_E = bot:GetAbilityByName('nevermore_shadowraze3')
	FeastOfSouls = bot:GetAbilityByName('nevermore_frenzy')
	RequiemOfSouls = bot:GetAbilityByName('nevermore_requiem')

	if RequiemOfSouls and RequiemOfSouls:IsInAbilityPhase() then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), bot:GetAttackRange())
		if #nInRangeEnemy == 0 then
			bot:Action_ClearActions(false)
			return
		end
	end

	if J.CanNotUseAbility(bot) then return end

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	RequiemOfSoulsDesire = X.ConsdierRequiemOfSouls()
	if RequiemOfSoulsDesire > 0 then
		bot:Action_UseAbility(RequiemOfSouls)
		return
	end

	if J.CanCastAbility(ShadowRaze_E) then
		ShadowRazeE_Desire = X.ConsiderShadowRaze(ShadowRaze_E)
		if ShadowRazeE_Desire > 0 then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbility(ShadowRaze_E)
			return
		end
	end

	if J.CanCastAbility(ShadowRaze_W) then
		ShadowRazeW_Desire = X.ConsiderShadowRaze(ShadowRaze_W)
		if ShadowRazeW_Desire > 0 then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbility(ShadowRaze_W)
			return
		end
	end

	if J.CanCastAbility(ShadowRaze_Q) then
		ShadowRazeQ_Desire = X.ConsiderShadowRaze(ShadowRaze_Q)
		if ShadowRazeQ_Desire > 0 then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbility(ShadowRaze_Q)
			return
		end
	end

	FeastOfSoulsDesire = X.ConsiderFeastOfSouls()
	if FeastOfSoulsDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(FeastOfSouls)
		return
	end
end

function X.ConsiderShadowRaze(shadowRaze)
	if not J.CanCastAbility(shadowRaze) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = shadowRaze:GetSpecialValueInt('shadowraze_range')
	local nCastPoint = shadowRaze:GetCastPoint()
	local nDamage = shadowRaze:GetSpecialValueInt('shadowraze_damage')
	local nStackBonusDamage = shadowRaze:GetSpecialValueInt('stack_bonus_damage')
	local nRadius = shadowRaze:GetSpecialValueInt('shadowraze_radius')
	local nManaCost = shadowRaze:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowRaze_Q, FeastOfSouls, RequiemOfSouls})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ShadowRaze_Q, ShadowRaze_W, ShadowRaze_E, FeastOfSouls, RequiemOfSouls})

	local vCastLocation = J.GetFaceTowardDistanceLocation(bot, nCastRange)

	for _, enemy in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemy)
		and J.CanBeAttacked(enemy)
		and J.IsInRange(bot, enemy, nCastRange + nRadius)
		and J.CanCastOnNonMagicImmune(enemy)
		and not enemy:HasModifier('modifier_abaddon_borrowed_time')
		and not enemy:HasModifier('modifier_dazzle_shallow_grave')
		and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemy:HasModifier('modifier_oracle_false_promise_timer')
		and X.CanKillUnit(enemy, nDamage, nStackBonusDamage, nCastPoint)
		then
			if GetUnitToLocationDistance(enemy, vCastLocation) <= nRadius then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if GetUnitToLocationDistance(botTarget, vCastLocation) <= nRadius then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + nRadius, 1600), true)

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if J.GetDistance(vCastLocation, nLocationAoE.targetloc) <= nRadius then
					if (nLocationAoE.count >= 4)
					or (nLocationAoE.count >= 3 and fManaAfter > fManaThreshold2)
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if J.GetDistance(vCastLocation, nLocationAoE.targetloc) <= nRadius then
					if (nLocationAoE.count >= 4)
					or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + nRadius, nRadius, 0, 0)
		if J.GetDistance(vCastLocation, nLocationAoE.targetloc) <= nRadius then
			if (nLocationAoE.count >= 3) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if J.GetDistance(vCastLocation, nLocationAoE.targetloc) <= nRadius then
					if (nLocationAoE.count >= 3)
					or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
					or (nLocationAoE.count >= 1 and creep:IsAncientCreep() and J.GetHP(creep) > 0.5 and fManaAfter > fManaThreshold2)
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold2 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and GetUnitToLocationDistance(creep, vCastLocation) <= nRadius
			then
				local sCreepName = creep:GetUnitName()
				if X.CanKillUnit(creep, nDamage, nStackBonusDamage, nCastPoint) then
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 650, 0, 0)
					if (string.find(sCreepName, 'ranged') and nLocationAoE.count > 0)
					or (J.IsUnitTargetedByTower(creep, false))
					then
						return BOT_ACTION_DESIRE_HIGH
					end

					nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count > 0 then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
		local nCanKillCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and GetUnitToLocationDistance(creep, vCastLocation) <= nRadius
			and X.CanKillUnit(creep, nDamage, nStackBonusDamage, nCastPoint)
			then
				nCanKillCount = nCanKillCount + 1
			end
		end

		if (nCanKillCount >= 3)
		or (nCanKillCount >= 2 and #nEnemyHeroes > 0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
		and not J.IsRunning(botTarget)
		and J.CanBeAttacked(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			if GetUnitToLocationDistance(botTarget, vCastLocation) <= nRadius then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFeastOfSouls()
	if not J.CanCastAbility(FeastOfSouls)
	or (bMagicBuild and J.CanCastAbility(RequiemOfSouls))
	or bot:IsDisarmed()
	or bot:GetAttackDamage() < 0
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nAttackRange = bot:GetAttackRange()
	local nSoulCount = bot:GetModifierStackCount(bot:GetModifierByName('modifier_nevermore_necromastery'))
	local nManaCost = FeastOfSouls:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowRaze_Q, ShadowRaze_W, ShadowRaze_E, RequiemOfSouls})
	local bFeast = false

	if bMagicBuild then
		bFeast = (nSoulCount - 5) >= 18
	else
		bFeast = (nSoulCount - 5) >= 13
	end

	if nSoulCount < 5 or not bFeast or fManaAfter < fManaThreshold1 then return BOT_ACTION_DESIRE_NONE end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange + 300)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsPushing(bot) then
		if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.GetHP(botTarget) > 0.3
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

    if J.IsFarming(bot) and bAttacking then
		local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 3)
			or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
		and J.CanBeAttacked(botTarget)
		and J.GetHP(botTarget) > 0.5
        and J.IsInRange(bot, botTarget, nAttackRange)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsdierRequiemOfSouls()
	if not J.CanCastAbility(RequiemOfSouls) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = RequiemOfSouls:GetSpecialValueInt('requiem_radius')
	local nCastPoint = RequiemOfSouls:GetCastPoint()
	local nSoulCount = J.GetModifierCount(bot, 'modifier_nevermore_necromastery')
	local nDamage = RequiemOfSouls:GetSpecialValueInt('#AbilityDamage')

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 600)
		or J.IsUnitTargetProjectileIncoming(bot, 600)
		or J.IsNotAttackProjectileIncoming(bot, 1000)
		then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and J.IsInRange(bot, enemy, 400)
			and J.GetHP(enemy) > 0.3
			and J.CanCastOnNonMagicImmune(enemy)
			and not string.find(enemy:GetUnitName(), 'medusa')
			and not enemy:HasModifier('modifier_abaddon_borrowed_time')
			and not enemy:HasModifier('modifier_dazzle_shallow_grave')
			and not enemy:HasModifier('modifier_enigma_black_hole_pull')
			and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemy:HasModifier('modifier_oracle_false_promise_timer')
			and nSoulCount >= 15
			then
				for i = 0, enemy:NumModifiers() do
					local sModifierName = enemy:GetModifierName(i)
					if sModifierName then
						local fRemainingDuration = enemy:GetModifierRemainingDuration(i)
						if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
							if fRemainingDuration >= nCastPoint then
								return BOT_ACTION_DESIRE_HIGH
							end
						elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
							if fRemainingDuration < nCastPoint and fRemainingDuration >= nCastPoint / 2 then
								return BOT_ACTION_DESIRE_HIGH
							end
						elseif M['hexed'] and M['hexed'][sModifierName] then
							if fRemainingDuration >= nCastPoint then
								return BOT_ACTION_DESIRE_HIGH
							end
						elseif M['rooted'] and M['rooted'][sModifierName] then
							if fRemainingDuration >= nCastPoint then
								return BOT_ACTION_DESIRE_HIGH
							end
						elseif M['stunned'] and M['stunned'][sModifierName] then
							if fRemainingDuration >= nCastPoint then
								return BOT_ACTION_DESIRE_HIGH
							end
						end
					end
				end
			end
		end
	end

	local nRadius_ = bot:GetAttackRange() + 100
	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

	if J.IsInTeamFight(bot, 1200) and nSoulCount >= 15 then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius_)
		local nNonMagicImmuneEnemyCount = 0
		for _, enemyHero in pairs(nInRangeEnemy) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			then
				nNonMagicImmuneEnemyCount = nNonMagicImmuneEnemyCount + 1
			end
		end

		if nNonMagicImmuneEnemyCount >= 2 then
			if (botHP > 0.4 and #nEnemyHeroesTargetingMe <= 1)
			or (bot:IsMagicImmune())
			or (not J.CanBeAttacked(bot))
			or (bot:HasModifier('modifier_dazzle_shallow_grave'))
			or (bot:HasModifier('modifier_oracle_false_promise_timer'))
			then
				if not J.IsStunProjectileIncoming(bot, 800) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius_)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not string.find(botTarget:GetUnitName(), 'medusa')
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and nSoulCount >= 10
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
				if (#nEnemyHeroesTargetingMe <= 2)
				or (botHP > 0.4 and #nEnemyHeroesTargetingMe <= 1)
				or (bot:IsMagicImmune())
				or (not J.CanBeAttacked(bot))
				or (bot:HasModifier('modifier_dazzle_shallow_grave'))
				or (bot:HasModifier('modifier_oracle_false_promise_timer'))
				then
					if #nInRangeEnemy <= 1 then
						if bot:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL) > (botTarget:GetHealth() + botTarget:GetHealthRegen()) then
							return BOT_ACTION_DESIRE_HIGH
						end
					else
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.CanKillUnit(hUnit, nDamage, nBonusDamage, nCastPoint)
	local nStack = 0
	for i = 0, hUnit:NumModifiers() do
		if hUnit:GetModifierName(i) == 'modifier_nevermore_shadowraze_debuff' then
			nStack = hUnit:GetModifierStackCount(i)
			break
		end
	end

	local nRealDamage = nDamage + nStack * nBonusDamage

	return J.WillKillTarget(hUnit, nRealDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
end

return X
