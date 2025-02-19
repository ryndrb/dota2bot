local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_arc_warden'
then

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
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
				[1] = {3,1,3,1,3,6,3,1,1,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_slippers",
				"item_circlet",
	
				"item_wraith_band",
				"item_boots",
				"item_magic_wand",
				"item_hand_of_midas",
				"item_mjollnir",--
				"item_travel_boots",
				"item_manta",--
				"item_greater_crit",--
				"item_skadi",--
				"item_bloodthorn",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_lesser_crit",
				"item_wraith_band", "item_skadi",
				"item_hand_of_midas", "item_orchid",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {3,1,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_faerie_fire",
	
				"item_bottle",
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_boots",
				"item_hand_of_midas",
				"item_mjollnir",--
				"item_travel_boots",
				"item_blink",
				"item_octarine_core",--
				"item_ultimate_scepter",
				"item_bloodthorn",--
				"item_overwhelming_blink",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_mjollnir",
				"item_magic_wand", "item_blink",
				"item_bottle", "item_octarine_core",
				"item_urn_of_shadows", "item_ultimate_scepter",
				"item_hand_of_midas", "item_orchid",
			},
        },
		[2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
				[1] = {3,1,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
	
				"item_bottle",
				"item_magic_wand",
				"item_boots",
				"item_hand_of_midas",
				"item_mjollnir",--
				"item_travel_boots",
				"item_orchid",
				"item_manta",--
				"item_greater_crit",--
				"item_skadi",--
				"item_bloodthorn",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_manta",
				"item_bottle", "item_greater_crit",
				"item_hand_of_midas", "item_skadi",
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

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list


if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_ranged_carry' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local Flux 			= bot:GetAbilityByName('arc_warden_flux')
local MagneticField = bot:GetAbilityByName('arc_warden_magnetic_field')
local SparkWraith 	= bot:GetAbilityByName('arc_warden_spark_wraith')
local TempestDouble = bot:GetAbilityByName('arc_warden_tempest_double')

local FluxDesire, FluxTarget
local MagneticFieldDesire
local SparkWraithDesire, SparkWraithLocation
local TempestDoubleDesire, TempestDoubleLocation

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	Flux 			= bot:GetAbilityByName('arc_warden_flux')
	MagneticField 	= bot:GetAbilityByName('arc_warden_magnetic_field')
	SparkWraith 	= bot:GetAbilityByName('arc_warden_spark_wraith')
	TempestDouble 	= bot:GetAbilityByName('arc_warden_tempest_double')

	botTarget = J.GetProperTarget(bot)

	TempestDoubleDesire, TempestDoubleLocation = X.ConsiderTempestDouble()
	if TempestDoubleDesire > 0
	then
		bot:Action_UseAbilityOnLocation(TempestDouble, TempestDoubleLocation)
		return
	end

	MagneticFieldDesire = X.ConsiderMagneticField()
	if MagneticFieldDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(MagneticField)
		return
	end

	FluxDesire, FluxTarget = X.ConsiderFlux()
	if FluxDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Flux, FluxTarget)
		return
	end

	SparkWraithDesire, SparkWraithLocation = X.ConsiderSparkWraith()
	if SparkWraithDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SparkWraith, SparkWraithLocation)
		return
	end
end

function X.ConsiderFlux()
	if not J.CanCastAbility(Flux) then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, Flux:GetCastRange())
	local nDot = Flux:GetSpecialValueInt('damage_per_second')
	local nDuration = Flux:GetSpecialValueInt('duration')
	local nDamage = nDot * nDuration

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 150)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local dmg = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
				if dmg > nMostDangerousDamage
				then
					nMostDangerousDamage = dmg
					npcMostDangerousEnemy = enemyHero
				end
			end
		end

		if npcMostDangerousEnemy ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 75)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and (bot:GetActiveModeDesire() > 0.7 and bot:WasRecentlyDamagedByHero(enemyHero, 1.5))
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and not J.IsDisabled(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and not J.IsDisabled(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMagneticField()
	if not J.CanCastAbility(MagneticField)
	or X.IsDoubleCasting()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, MagneticField:GetCastRange())
	local nRadius = MagneticField:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(false, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if  nLocationAoE.count >= 2
		and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) <= bot:GetAttackRange()
		then
			local nInRangeAlly = J.GetAlliesNearLoc(nLocationAoE.targetloc, nRadius)
			if  J.IsValidHero(nInRangeAlly[1])
			and J.IsValidTarget(nInRangeAlly[1]:GetAttackTarget())
			and GetUnitToUnitDistance(nInRangeAlly[1], nInRangeAlly[1]:GetAttackTarget()) <= nInRangeAlly[1]:GetAttackRange() + 50
			and not nInRangeAlly[1]:HasModifier('modifier_arc_warden_magnetic_field_attack_speed')
			and not nInRangeAlly[1]:HasModifier('modifier_arc_warden_magnetic_field_attack_range')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		then
			local nInRangeAllyAttack = bot:GetNearbyHeroes(nRadius, false, BOT_MODE_ATTACK)
			for _, allyHero in pairs(nInRangeAllyAttack)
			do
				local allyTarget = allyHero:GetAttackTarget()
				if  J.IsValidHero(allyHero)
				and (J.IsInRange(bot, allyHero, nRadius) and not allyHero:HasModifier('modifier_arc_warden_magnetic_field_attack_speed') and not allyHero:HasModifier('modifier_arc_warden_magnetic_field_attack_range'))
				and (J.IsValidTarget(allyTarget) and GetUnitToUnitDistance(allyHero, allyTarget) <= allyHero:GetAttackRange())
				and not J.IsSuspiciousIllusion(allyHero)
				and not J.IsSuspiciousIllusion(allyTarget)
				and not allyTarget:HasModifier('modifier_abaddon_borrowed_time')
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if  (J.IsDefending(bot) or J.IsPushing(bot))
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_speed')
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_range')
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(888, true)
		local nEnemyTowers = bot:GetNearbyTowers(888, true)
		local nEnemyBarracks bot:GetNearbyBarracks(888, true)
		local sEnemyTowers bot:GetNearbyFillers(888, true)

		if J.IsAttacking(bot)
		then
			if (nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3 and J.CanBeAttacked(nEnemyLaneCreeps[1]))
			or (nEnemyTowers ~= nil and #nEnemyTowers >= 1 and J.CanBeAttacked(nEnemyTowers[1]))
			or (nEnemyBarracks ~= nil and #nEnemyBarracks >= 1 and J.CanBeAttacked(nEnemyBarracks[1]))
			or (sEnemyTowers ~= nil and #sEnemyTowers >= 1 and J.CanBeAttacked(sEnemyTowers[1]))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if  J.IsFarming(bot)
	and J.GetManaAfter(MagneticField:GetManaCost()) > 0.4
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_speed')
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_range')
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(888, true)
		if J.IsAttacking(bot)
		then
			if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
			and J.CanBeAttacked(nEnemyLaneCreeps[1])
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			local nNeutralCreeps = bot:GetNearbyNeutralCreeps(888)
			if  nNeutralCreeps ~= nil
			and (#nNeutralCreeps >= 3 or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if  J.IsDoingRoshan(bot)
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_speed')
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_range')
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  J.IsDoingTormentor(bot)
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_speed')
	and not bot:HasModifier('modifier_arc_warden_magnetic_field_attack_range')
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSparkWraith()
	if not J.CanCastAbility(SparkWraith) then return BOT_ACTION_DESIRE_NONE, 0 end

	local nCastRange = J.GetProperCastRange(false, bot, SparkWraith:GetCastRange())
	local nRadius = SparkWraith:GetSpecialValueInt('radius')
	local nDamage = SparkWraith:GetSpecialValueInt('spark_damage')
	local nCastPoint = SparkWraith:GetCastPoint()
	local nDelay = SparkWraith:GetSpecialValueInt('activation_delay') + nCastPoint

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetExtrapolatedLocation(nDelay)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
			if J.IsRunning(botTarget)
			then
				return BOT_ACTION_DESIRE_MODERATE, botTarget:GetExtrapolatedLocation(nDelay)
			else
				return BOT_ACTION_DESIRE_MODERATE, botTarget:GetLocation()
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1400, nRadius, 2, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
		and J.GetManaAfter(SparkWraith:GetManaCost()) > 0.68
		and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
		then
			local nCreep = J.GetVulnerableUnitNearLoc( bot, false, true, 1600, nRadius, nLocationAoE.targetloc )
			if nCreep == nil
			or bot:HasModifier('modifier_arc_warden_tempest_double')
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if  J.IsRetreating(bot)
	and bot:GetActiveModeDesire() > BOT_ACTION_DESIRE_HIGH
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 800)
			and bot:WasRecentlyDamagedByHero(enemyHero, 1)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsFarming(bot)
	or J.IsPushing(bot)
	or J.IsDefending(bot)
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 2
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and not J.IsRunning(nEnemyLaneCreeps[1])
		and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
		then
			if bot:HasModifier('modifier_arc_warden_tempest_double')
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end

			if J.GetMP(bot) > 0.62
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end
		end
	end

	if  J.IsLaning(bot)
	and J.IsInLaningPhase()
    and bot:GetLevel() < 7
	then
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
			and creep:GetHealth() <= nDamage
			and botTarget ~= creep
			and not J.IsRunning(creep)
			then
				return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
			end
		end
	end

	if  SparkWraith:GetLevel() >= 3
	and J.GetManaAfter(SparkWraith:GetManaCost()) > 0.66
	and not J.IsLaning(bot)
	then
		local nLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), 1400, nRadius, 2, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

	if  bot:GetLevel() >= 10
	and ((J.GetManaAfter(SparkWraith:GetManaCost()) > 0.65)
		or bot:HasModifier('modifier_arc_warden_tempest_double'))
	and DotaTime() > 8 * 60
	then
		local nEnemysHerosCanSeen = GetUnitList(UNIT_LIST_ENEMY_HEROES)
		local nTargetHero = nil
		local nTargetHeroHealth = 99999
		for _, enemyHero in pairs( nEnemysHerosCanSeen )
		do
			if  J.IsValidHero(enemyHero)
			and GetUnitToUnitDistance(bot, enemyHero) <= nCastRange
			and enemyHero:GetHealth() < nTargetHeroHealth
			then
				nTargetHero = enemyHero
				nTargetHeroHealth = enemyHero:GetHealth()
			end
		end

		if nTargetHero ~= nil
		then
			for i = 0, 350, 50
			do
				local nCastLocation = J.GetLocationTowardDistanceLocation(nTargetHero, J.GetEnemyFountain(), 350 - i)
				if GetUnitToLocationDistance(bot, nCastLocation) <= nCastRange
				then
					return BOT_ACTION_DESIRE_HIGH, nCastLocation
				end
			end
		end

		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
		then
			local targetCreep = nEnemyLaneCreeps[#nEnemyLaneCreeps]
			if  J.IsValid(targetCreep)
			and J.CanBeAttacked(targetCreep)
			and not J.IsRunning(targetCreep)
			then
				local nCastLocation = J.GetFaceTowardDistanceLocation(targetCreep, 375)
				return BOT_ACTION_DESIRE_HIGH, nCastLocation
			end
		end

		local nEnemyLaneFront = J.GetNearestLaneFrontLocation(bot:GetLocation(), true, nRadius / 2)

		if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0 and nEnemyLaneFront ~= nil
		and GetUnitToLocationDistance(bot, nEnemyLaneFront) <= nCastRange + nRadius
		and GetUnitToLocationDistance(bot, nEnemyLaneFront) >= 800
		then
			local nCastLocation = J.GetLocationTowardDistanceLocation( bot, nEnemyLaneFront, nCastRange )
			if GetUnitToLocationDistance(bot, nEnemyLaneFront) < nCastRange
			then
				nCastLocation = nEnemyLaneFront
			end

			return BOT_ACTION_DESIRE_HIGH, nCastLocation
		end
	end

	local nCastLocation = J.GetLocationTowardDistanceLocation(bot, J.GetEnemyFountain(), nCastRange)
	if bot:HasModifier('modifier_arc_warden_tempest_double')
	or (J.GetMP(bot) > 0.92 and bot:GetLevel() > 11 and not IsLocationVisible(nCastLocation))
	or (J.GetMP(bot) > 0.38 and J.GetDistanceFromEnemyFountain(bot) < 4300)
	then
		if  IsLocationPassable(nCastLocation)
		and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
		then
			return BOT_ACTION_DESIRE_HIGH, nCastLocation
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.GetHP(botTarget) > 0.2
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.GetHP(botTarget) > 0.2
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTempestDouble()
	X.UpdateDoubleStatus()

	if not J.CanCastAbility(TempestDouble)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, TempestDouble:GetCastRange())

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsDefending(bot) or J.IsPushing(bot) or J.IsFarming(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps( 800, true )
		local nEnemyTowers = bot:GetNearbyTowers( 800, true )
		local nCreeps = bot:GetNearbyCreeps( 800, true )

		if J.IsAttacking(bot)
		then
			if (nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 2 and J.CanBeAttacked(nEnemyLaneCreeps[1]))
			or (nEnemyTowers ~= nil and #nEnemyTowers >= 1 and J.CanBeAttacked(nEnemyTowers[1]))
			or (nCreeps ~= nil and #nCreeps >= 2 and J.CanBeAttacked(nCreeps[1]))
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local target = nil
		local hp = 0
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			then
				local currHP = enemyHero:GetHealth()
				if hp < currHP
				then
					hp = currHP
					target = enemyHero
				end
			end
		end

		if target ~= nil
		then
			if J.IsRunning(target)
			then
				if not J.IsInRange(bot, target, nCastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, target:GetLocation(), nCastRange)
				else
					return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
				end
			else
				if not J.IsInRange(bot, target, nCastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, bot:GetLocation(), nCastRange)
				else
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 1600)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			or botTarget:HasModifier('modifier_enigma_black_hole_pull')
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end

			if J.IsInRange(bot, botTarget, bot:GetAttackRange())
			then
				if J.IsRunning(botTarget)
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				else
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end

			if not J.IsInRange(bot, botTarget, bot:GetAttackRange())
			then
				return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
			end
		end
	end

	local Midas = J.GetComboItem(bot, 'item_hand_of_midas')
	if  Midas ~= nil
	and X.IsDoubleMidasCooldown()
	and bot:DistanceFromFountain() > 600
	then
		local nCreeps = bot:GetNearbyCreeps(1600, true)
		if #nCreeps >= 1
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.GetHP(botTarget) > 0.5
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsDoubleCasting()
	if bot.TempestDouble == nil or not bot.TempestDouble:IsAlive()
	then
		return false
	end

	for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
	do
		if J.IsValid(allyHero)
		and allyHero ~= bot
		and allyHero:GetUnitName() == "npc_dota_hero_arc_warden"
		and (allyHero:IsCastingAbility() or allyHero:IsUsingAbility())
		then
			return true
		end
	end

	return false
end

function X.IsDoubleMidasCooldown()
	if bot.TempestDouble == nil then X.UpdateDoubleStatus() end

	if bot.TempestDouble ~= nil
	then
		local Midas = J.GetComboItem(bot.TempestDouble, 'item_hand_of_midas')
		if  Midas ~= nil
		and (Midas:IsFullyCastable() or Midas:GetCooldownTimeRemaining() <= 3)
		then
			return true
		end
	end

	return false
end

function X.UpdateDoubleStatus()
	if  bot.TempestDouble == nil
	and bot:GetLevel() >= 6
	then
		for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
		do
			if  allyHero ~= nil
			and allyHero:IsAlive()
			and allyHero:HasModifier('modifier_arc_warden_tempest_double')
			then
				bot.TempestDouble = allyHero
			end
		end
	end
end

return X