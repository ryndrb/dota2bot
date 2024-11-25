local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

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
				
				"item_magic_wand",
				"item_power_treads",
				"item_lifesteal",
				"item_dragon_lance",
				"item_lesser_crit",
				"item_black_king_bar",--
				"item_butterfly",--
				"item_greater_crit",--
				"item_hurricane_pike",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
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
				
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_lifesteal",
				"item_dragon_lance",
				"item_lesser_crit",
				"item_black_king_bar",--
				"item_butterfly",--
				"item_greater_crit",--
				"item_hurricane_pike",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
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
				
				"item_bottle",
				"item_power_treads",
				"item_wind_lace",
				"item_magic_wand",
				"item_kaya",
				"item_blink",
				"item_cyclone",
				"item_black_king_bar",--
				"item_yasha_and_kaya",--
				"item_ultimate_scepter",
				"item_travel_boots",
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_bottle",
				"item_magic_wand",
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

local botMP, botHP, botTarget, botLevel

function X.SkillsComplement()
	ShadowRaze_Q = bot:GetAbilityByName('nevermore_shadowraze1')
	ShadowRaze_W = bot:GetAbilityByName('nevermore_shadowraze2')
	ShadowRaze_E = bot:GetAbilityByName('nevermore_shadowraze3')
	FeastOfSouls = bot:GetAbilityByName('nevermore_frenzy')
	RequiemOfSouls = bot:GetAbilityByName('nevermore_requiem')

	if J.CanNotUseAbility( bot ) then return end

	botTarget = J.GetProperTarget(bot)
	botHP = J.GetHP(bot)
	botMP = J.GetMP(bot)
	botLevel = bot:GetLevel()

	X.ConsiderUltCombo()

	RequiemOfSoulsDesire = X.ConsdierRequiemOfSouls()
	if RequiemOfSoulsDesire > 0 then
		bot:Action_UseAbility(RequiemOfSouls)
		return
	end

	if J.CanCastAbility(ShadowRaze_E) then
		ShadowRazeE_Desire = X.ConsiderShadownRaze(ShadowRaze_E)
		if ShadowRazeE_Desire > 0 then
			J.SetQueuePtToINT(bot, true)
			bot:ActionQueue_UseAbility(ShadowRaze_E)
			return
		end
	end

	if J.CanCastAbility(ShadowRaze_W) then
		ShadowRazeW_Desire = X.ConsiderShadownRaze(ShadowRaze_W)
		if ShadowRazeW_Desire > 0 then
			J.SetQueuePtToINT(bot, true)
			bot:ActionQueue_UseAbility(ShadowRaze_W)
			return
		end
	end

	if J.CanCastAbility(ShadowRaze_Q) then
		ShadowRazeQ_Desire = X.ConsiderShadownRaze(ShadowRaze_Q)
		if ShadowRazeQ_Desire > 0 then
			J.SetQueuePtToINT(bot, true)
			bot:ActionQueue_UseAbility(ShadowRaze_Q)
			return
		end
	end

	FeastOfSoulsDesire = X.ConsiderFeastOfSouls()
	if FeastOfSoulsDesire > 0
	then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbility(FeastOfSouls)
		return
	end
end

function X.ConsiderShadownRaze(hAbility)
	if not J.CanCastAbility(hAbility) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = hAbility:GetSpecialValueInt('shadowraze_range')
	local nCastPoint = hAbility:GetCastPoint()
	local nDamage = hAbility:GetSpecialValueInt('shadowraze_damage')
	local nStackBonusDamage = hAbility:GetSpecialValueInt('stack_bonus_damage')
	local nRadius = hAbility:GetSpecialValueInt('shadowraze_radius')
	local nManaCost = hAbility:GetManaCost()
	local nCastLocation = J.GetFaceTowardDistanceLocation(bot, nCastRange)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemy in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemy)
		and J.IsInRange(bot, enemy, nCastRange + nRadius)
		and J.CanCastOnNonMagicImmune(enemy)
		and not enemy:HasModifier('modifier_abaddon_borrowed_time')
		and not enemy:HasModifier('modifier_dazzle_shallow_grave')
		and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemy:HasModifier('modifier_oracle_false_promise_timer')
		and X.IsUnitCanBeKill(enemy, nDamage, nStackBonusDamage, nCastPoint)
		and X.IsUnitNearLoc(enemy, nCastLocation, nRadius, 0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and X.IsUnitNearLoc(botTarget, nCastLocation, nRadius, 0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(Min(nCastRange + nRadius * 1.5, 1600), true)
		local nCanHurtCount = 0
		local nCanKillCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and X.IsUnitNearLoc(creep, nCastLocation, nRadius, 0)
			then
				nCanHurtCount = nCanHurtCount + 1
				if X.IsUnitCanBeKill(creep, nDamage, nStackBonusDamage, nCastPoint) then
					nCanKillCount = nCanKillCount + 1
					if J.IsLaning(bot) then
						if string.find(creep:GetUnitName(), 'ranged')
						and not J.IsInRange(bot, creep, bot:GetAttackRange())
						and #nEnemyHeroes > 0
						then
							return BOT_ACTION_DESIRE_HIGH
						end
					end
				end
			end
		end

		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if not J.IsInLaningPhase() and #nInRangeEnemy <= 1 then
			if (nCanHurtCount >= 4 and botMP > 0.6)
			or (nCanHurtCount >= 3 and not J.IsLaning(bot) and botMP > 0.8)
			or (nCanHurtCount >= 2 and nCanHurtCount == #nEnemyLaneCreeps)
			or (nCanHurtCount >= 2 and botMP > 0.8 and botLevel > 10 and #nEnemyCreeps >= 2)
			or (nCanHurtCount >= 2 and botLevel > 24 and J.GetManaAfter(nManaCost) > 0.4)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if botLevel <= 10 then
			if nCanKillCount >= 2 and (nCanHurtCount == #nEnemyLaneCreeps or botMP > 0.8) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if nCanKillCount >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
		and X.IsUnitNearLoc(botTarget, nCastLocation, nRadius, 0)
		and not J.IsRunning(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFeastOfSouls()
	if not J.CanCastAbility(FeastOfSouls)
	or (bMagicBuild and J.CanCastAbility(RequiemOfSouls))
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nAttackRange = bot:GetAttackRange()
	local nSoulCount = bot:GetModifierStackCount(bot:GetModifierByName('modifier_nevermore_necromastery'))
	local nManaAfter = J.GetManaAfter(FeastOfSouls:GetManaCost())
	local bFeast = false

	if bMagicBuild then
		bFeast = (nSoulCount - 5) >= 18
	else
		bFeast = (nSoulCount - 5) >= 13
	end

	if nSoulCount < 5 or not bFeast then return BOT_ACTION_DESIRE_NONE end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange + 300)
		and J.CanBeAttacked(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsFarming(bot) and nManaAfter > 0.4
    then
        if J.IsAttacking(bot)
        then
            local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)
            if J.IsValid(nEnemyCreeps[1])
			and (#nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()))
			and J.CanBeAttacked(nEnemyCreeps[1])
            then
				return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsPushing(bot)
    then
		if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
		and J.CanBeAttacked(botTarget)
		and J.GetHP(botTarget) > 0.5
        and J.IsInRange(bot, botTarget, nAttackRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsdierRequiemOfSouls()
	if not J.CanCastAbility(RequiemOfSouls)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = RequiemOfSouls:GetSpecialValueInt('requiem_radius')
	local nCastPoint = RequiemOfSouls:GetCastPoint()
	local nSoulCount = J.GetModifierCount(bot, 'modifier_nevermore_necromastery')
	local nDamage = RequiemOfSouls:GetSpecialValueInt('#AbilityDamage')

	local nDelay = 2.5 - nCastPoint
	if J.HasItem(bot, 'item_yasha_and_kaya') then
		nDelay = nDelay * 0.75
		if FeastOfSouls ~= nil and FeastOfSouls:IsTrained() then
			local talent_25_right = FeastOfSouls:GetSpecialValueInt('cast_speed_pct')
			nDelay = nDelay * (1 - ((talent_25_right - 100) / 100))
		end
	end

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	for _, enemy in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemy)
		and J.IsInRange(bot, enemy, 400)
		and ((enemy:HasModifier('modifier_eul_cyclone') and J.GetModifierTime(enemy, 'modifier_eul_cyclone') < nDelay)
			or (enemy:HasModifier('modifier_brewmaster_storm_cyclone') and J.GetModifierTime(enemy, 'modifier_brewmaster_storm_cyclone') < nDelay))
		and enemy:GetHealth() > 800
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
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInTeamFight(bot, 1200) and nSoulCount >= 15 then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius * 0.6, nDelay, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.6)

		local nNonMagicImmuneEnemyCount = 0
		for _, enemy in pairs(nInRangeEnemy) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			then
				nNonMagicImmuneEnemyCount = nNonMagicImmuneEnemyCount + 1
				if (enemy:HasModifier('modifier_enigma_black_hole_pull')
					or enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
					or enemy:HasModifier('modifier_legion_commander_duel'))
				and J.IsCore(enemy)
				and J.GetHP(enemy) > 0.4
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if #nInRangeEnemy >= 2 and nNonMagicImmuneEnemyCount >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not string.find(botTarget:GetUnitName(), 'medusa')
		and not J.IsDisabled(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.6)
		and not J.IsChasingTarget(bot, botTarget)
		and botTarget:GetHealth() > 800
		and botHP > 0.35
		and nSoulCount >= 10
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- gets disabled a lot; not reliable since does not really communicate with teammates
function X.ConsiderUltCombo()
	if not J.CanCastAbility(RequiemOfSouls) then
		return
	end

	local EulsScepter = J.GetItem('item_cyclone')
	if EulsScepter == nil then
		EulsScepter = J.GetItem('item_wind_waker')
	end
	local bBlink = J.CanBlinkDagger(bot)
	local bBKB = J.CanBlackKingBar(bot)
	local bEuls = J.CanCastAbility(EulsScepter)

	local nBlinkRange = 1200
	local nEulsRange = 550
	local nRadius = RequiemOfSouls:GetSpecialValueInt('requiem_radius')
	local nCastPoint = RequiemOfSouls:GetCastPoint()
	local nSoulCount = J.GetModifierCount(bot, 'modifier_nevermore_necromastery')
	local nDamage = RequiemOfSouls:GetSpecialValueInt('#AbilityDamage')

	local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
	local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

	local nDelay = 2.5 - nCastPoint
	if J.HasItem(bot, 'item_yasha_and_kaya') then
		nDelay = nDelay * 0.75
		if FeastOfSouls ~= nil and FeastOfSouls:IsTrained() then
			local talent_25_right = FeastOfSouls:GetSpecialValueInt('cast_speed_pct')
			nDelay = nDelay * (1 - ((talent_25_right - 100) / 100))
		end
	end

	if bBKB and bBlink and bEuls and nSoulCount >= 17
	and bot:GetMana() > (bot.BlackKingBar:GetManaCost() + EulsScepter:GetManaCost() + RequiemOfSouls:GetManaCost())
	then
		if J.IsInTeamFight(bot, 1200) then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nBlinkRange)
			local hTarget = nil
			local hTargetDamage = 0

			for _, enemy in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemy)
				and J.GetHP(enemy) > 0.5
				and J.CanCastOnNonMagicImmune(enemy)
				and J.CanCastOnTargetAdvanced(enemy)
				and not string.find(enemy:GetUnitName(), 'medusa')
				and not enemy:HasModifier('modifier_abaddon_borrowed_time')
				and not enemy:HasModifier('modifier_dazzle_shallow_grave')
				and not enemy:HasModifier('modifier_enigma_black_hole_pull')
				and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					local enemyDamage = enemy:GetEstimatedDamageToTarget(false, bot, 8.0, DAMAGE_TYPE_ALL)
					if enemyDamage > hTargetDamage then
						hTarget = enemy
						hTargetDamage = enemyDamage
					end
				end
			end

			if hTarget ~= nil then
				bot:Action_UseAbility(bot.BlackKingBar)
				bot:ActionQueue_UseAbilityOnLocation(bot.Blink, hTarget:GetLocation())
				bot:ActionQueue_Delay(0.1)
				bot:ActionQueue_UseAbilityOnEntity(EulsScepter, hTarget)
				bot:ActionQueue_Delay(nDelay)
				bot:ActionQueue_UseAbility(RequiemOfSouls)
				return
			end
		end
	end

	-- TODO: check if can be stunned
	if bBlink and bEuls and nSoulCount >= 10
	and bot:GetMana() > (EulsScepter:GetManaCost() + RequiemOfSouls:GetManaCost())
	then
		if J.IsGoingOnSomeone(bot)
		and math.abs(#nAllyHeroes - #nEnemyHeroes) <= 1
		and #nAllyHeroes <= 2
		then
			for _, enemy in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemy)
				and J.GetHP(enemy) > 0.3
				and J.CanCastOnNonMagicImmune(enemy)
				and J.CanCastOnTargetAdvanced(enemy)
				and not string.find(enemy:GetUnitName(), 'medusa')
				and not enemy:HasModifier('modifier_abaddon_borrowed_time')
				and not enemy:HasModifier('modifier_dazzle_shallow_grave')
				and not enemy:HasModifier('modifier_enigma_black_hole_pull')
				and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemy:HasModifier('modifier_legion_commander_duel')
				and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemy:HasModifier('modifier_oracle_false_promise_timer')
				then
					local fDamage = bot:GetEstimatedDamageToTarget(true, enemy, 8.0, DAMAGE_TYPE_ALL)
					if J.CanKillTarget(enemy, fDamage, DAMAGE_TYPE_ALL) then
						bot:Action_UseAbilityOnLocation(bot.Blink, enemy:GetLocation())
						bot:ActionQueue_Delay(0.1)
						bot:ActionQueue_UseAbilityOnEntity(EulsScepter, enemy)
						bot:ActionQueue_Delay(nDelay)
						bot:ActionQueue_UseAbility(RequiemOfSouls)
						return
					end
				end
			end
		end
	end
end

function X.IsUnitNearLoc(nUnit, vLoc, nRadius, nDelay)
	if J.GetLocationToLocationDistance(J.GetCorrectLoc(nUnit, nDelay), vLoc) <= nRadius
	then
		return true
	end

	return false
end


function X.IsUnitCanBeKill( nUnit, nDamage, nBonus, nCastPoint )

	local nDamageType = DAMAGE_TYPE_MAGICAL

	local nStack = 0
	local nUnitModifier = nUnit:NumModifiers()

	if nUnitModifier >= 1
	then
		for i = 0, nUnitModifier
		do
			if nUnit:GetModifierName( i ) == "modifier_nevermore_shadowraze_debuff"
			then
				nStack = nUnit:GetModifierStackCount( i )
				break
			end
		end
	end

	local nRealDamage = nDamage + nStack * nBonus


	return J.WillKillTarget( nUnit, nRealDamage, nDamageType, nCastPoint )

end


return X
