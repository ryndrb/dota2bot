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
					['t15'] = {0, 10},
					['t10'] = {0, 10},
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
	
				"item_magic_wand",
				"item_boots",
				"item_wraith_band",
				"item_hand_of_midas",
				"item_maelstrom",
				"item_travel_boots",
				"item_mjollnir",--
				"item_manta",--
				"item_skadi",--
				"item_greater_crit",--
				"item_bloodthorn",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_skadi",
				"item_wraith_band", "item_greater_crit",
				"item_hand_of_midas", "item_bloodthorn",
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
				"item_double_circlet",
				"item_faerie_fire",
	
				"item_bottle",
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_boots",
				"item_hand_of_midas",
				"item_spirit_vessel",
				"item_mjollnir",--
				"item_travel_boots",
				"item_blink",
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_overwhelming_blink",--
				"item_bloodthorn",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_circlet", "item_mjollnir",
				"item_magic_wand", "item_blink",
				"item_bottle", "item_ultimate_scepter",
				"item_hand_of_midas", "item_sheepstick",
				"item_spirit_vessel", "item_bloodthorn",
			},
        },
		[2] = {
            ['talent'] = {
                [1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
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
	
				"item_magic_wand",
				"item_boots",
				"item_wraith_band",
				"item_hand_of_midas",
				"item_maelstrom",
				"item_travel_boots",
				"item_mjollnir",--
				"item_manta",--
				"item_skadi",--
				"item_greater_crit",--
				"item_bloodthorn",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_skadi",
				"item_wraith_band", "item_greater_crit",
				"item_hand_of_midas", "item_bloodthorn",
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
local MagneticFieldDesire, MagneticFieldLocation
local SparkWraithDesire, SparkWraithLocation
local TempestDoubleDesire, TempestDoubleLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	Flux 			= bot:GetAbilityByName('arc_warden_flux')
	MagneticField 	= bot:GetAbilityByName('arc_warden_magnetic_field')
	SparkWraith 	= bot:GetAbilityByName('arc_warden_spark_wraith')
	TempestDouble 	= bot:GetAbilityByName('arc_warden_tempest_double')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	TempestDoubleDesire, TempestDoubleLocation = X.ConsiderTempestDouble()
	if TempestDoubleDesire > 0 then
		bot:Action_UseAbilityOnLocation(TempestDouble, TempestDoubleLocation)
		return
	end

	MagneticFieldDesire, MagneticFieldLocation = X.ConsiderMagneticField()
	if MagneticFieldDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:Action_UseAbilityOnLocation(MagneticField, MagneticFieldLocation)
		return
	end

	FluxDesire, FluxTarget = X.ConsiderFlux()
	if FluxDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Flux, FluxTarget)
		return
	end

	SparkWraithDesire, SparkWraithLocation = X.ConsiderSparkWraith()
	if SparkWraithDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SparkWraith, SparkWraithLocation)
		return
	end
end

function X.ConsiderFlux()
	if not J.CanCastAbility(Flux) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Flux:GetCastRange())
	local nCastPoint = Flux:GetCastPoint()
	local nDPS = Flux:GetSpecialValueInt('damage_per_second')
	local nDuration = Flux:GetSpecialValueInt('duration')
	local nDamage = nDPS * nDuration
	local nManaCost = Flux:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Flux, MagneticField, SparkWraith})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDuration + nCastPoint)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0

		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_arc_warden_flux')
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderMagneticField()
	if not J.CanCastAbility(MagneticField)
	or X.IsDoubleCasting()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, MagneticField:GetCastRange())
	local nRadius = MagneticField:GetSpecialValueInt('radius')
	local nManaCost = MagneticField:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Flux, MagneticField, SparkWraith})

	local botAttackRange = bot:GetAttackRange()

	local hAncient = GetAncient(GetTeam())

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		and enemyHero:GetAttackTarget() == hAncient
		and J.IsInRange(bot, hAncient, nCastRange)
		then
			return BOT_ACTION_DESIRE_HIGH, hAncient:GetLocation()
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			for _, allyHero in pairs(nAllyHeroes) do
				if  J.IsValidHero(allyHero)
				and J.CanBeAttacked(allyHero)
				and J.IsInRange(bot, allyHero, nCastRange)
				and J.IsGoingOnSomeone(allyHero)
				and not J.IsSuspiciousIllusion(allyHero)
				and not X.IsUnderMagneticField(allyHero)
				then
					local allyTarget = allyHero:GetAttackTarget()
					if J.IsValidHero(allyTarget)
					and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange())
					and not J.IsChasingTarget(allyHero, allyTarget)
					and not J.IsSuspiciousIllusion(allyTarget)
					then
						if bot == allyHero or allyHero:WasRecentlyDamagedByAnyHero(2.0) then
							return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
						end
					end
				end
			end
		end
	end

	if not X.IsUnderMagneticField(bot) then
		local botLocation = bot:GetLocation()

		if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if  J.IsValidHero(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and not J.IsInRange(bot, enemyHero, nRadius)
				and not J.IsDisabled(enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				then
					if bot:IsRooted()
					or bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
					or J.IsStunProjectileIncoming(bot, 600)
					then
						return BOT_ACTION_DESIRE_HIGH, botLocation
					end
				end
			end
		end

		local nEnemyCreeps = bot:GetNearbyCreeps(Min(botAttackRange + 150, 1600), true)

		if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nAllyHeroes <= 2 then
				if #nEnemyCreeps >= 4 then
					return BOT_ACTION_DESIRE_HIGH, botLocation
				end
			end

			if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) and J.GetHP(botTarget) > 0.25 then
				if not J.IsInRange(bot, botTarget, nRadius) then
					return BOT_ACTION_DESIRE_HIGH, botLocation
				end
			end
		end

		if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nAllyHeroes <= 3 then
				if #nEnemyCreeps >= 3 then
					return BOT_ACTION_DESIRE_HIGH, botLocation
				end
			end
		end

		if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
				if (#nEnemyCreeps >= 3)
				or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
				then
					return BOT_ACTION_DESIRE_HIGH, botLocation
				end
			end
		end

		if J.IsDoingRoshan(bot) then
			if J.IsRoshan(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, botAttackRange)
			and bAttacking
			and fManaAfter > fManaThreshold1
			then
				return BOT_ACTION_DESIRE_HIGH, botLocation
			end
		end

		if J.IsDoingTormentor(bot) then
			if J.IsTormentor(botTarget)
			and J.IsInRange(bot, botTarget, botAttackRange)
			and bAttacking
			and fManaAfter > fManaThreshold1
			then
				return BOT_ACTION_DESIRE_HIGH, botLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSparkWraith()
	if not J.CanCastAbility(SparkWraith) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, SparkWraith:GetCastRange())
	local nCastPoint = SparkWraith:GetCastPoint()
	local nRadius = SparkWraith:GetSpecialValueInt('radius')
	local nDamage = SparkWraith:GetSpecialValueInt('spark_damage')
	local nDelay = SparkWraith:GetSpecialValueFloat('base_activation_delay')
	local nLevel = SparkWraith:GetLevel()
	local nManaCost = MagneticField:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Flux, MagneticField})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Flux, MagneticField, SparkWraith})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nLocationAoE = bot:FindAoELocation(true, false, enemyHero:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count <= 1 then
				if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay + nCastPoint) then
					return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
				end

				if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold2 then
					if enemyHero:HasModifier('modifier_arc_warden_flux') then
						return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
		then
			local nLocationAoE = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count <= 1 then
				local vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), nRadius / 2)
				if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bot:HasModifier('modifier_silencer_curse_of_the_silent') then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			then
				local vLocation = J.VectorTowards(enemyHero:GetLocation(), bot:GetLocation(), nRadius)
				if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				else
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end
		end
	end

	if not bot:HasModifier('modifier_silencer_curse_of_the_silent') then
		if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsEarlyGame() and fManaAfter > fManaThreshold2 + 0.1 and nLevel >= 3 then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nDelay, 0)
			local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
			if #nInRangeEnemy >= 2 or nLocationAoE.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end

		local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange, 1600), true)
		local bHasFarmingItem = J.HasItem(bot, 'item_mjollnir')

		if (J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.15 and #nAllyHeroes <= 2 and not bHasFarmingItem)
		or (J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and not bHasFarmingItem)
		or (J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and not bHasFarmingItem)
		then
			local hTargetCreep = nil
			local hTargetCreepHealth = 0
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep)
				and J.CanBeAttacked(creep)
				and J.CanCastOnNonMagicImmune(creep)
				and not J.IsRunning(creep)
				and not J.CanKillTarget(creep, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL)
				and not J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
				and not J.IsOtherAllysTarget(creep)
				then
					local creepHealth = creep:GetHealth()
					if creepHealth > hTargetCreepHealth then
						hTargetCreep = creep
						hTargetCreepHealth = creepHealth
					end
				end
			end

			if hTargetCreep then
				return BOT_ACTION_DESIRE_HIGH, hTargetCreep:GetLocation()
			end
		end

		if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
			for _, creep in pairs(nEnemyCreeps) do
				if  J.IsValid(creep)
				and J.CanBeAttacked(creep)
				and not J.IsRunning(creep)
				and not J.IsOtherAllysTarget(creep)
				then
					if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nDelay + nCastPoint) then
						local sCreepName = creep:GetUnitName()
						local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
						local nLocationAoE_creeps = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)

						if string.find(sCreepName, 'ranged') and nLocationAoE_creeps.count <= 1 then
							if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 800) then
								return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
							end
						end
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTempestDouble()
	X.UpdateDoubleStatus()

	if not J.CanCastAbility(TempestDouble) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, TempestDouble:GetCastRange())

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 1200
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			then
				local enemyHeroDamage = bot:GetEstimatedDamageToTarget(true, enemyHero, 5.0, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if #nInRangeAlly >= #nInRangeEnemy then
				local distance = GetUnitToUnitDistance(bot, hTarget)
				return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), hTarget:GetLocation(), Min(distance, nCastRange))
			else
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + bot:GetAttackRange())
		and not J.IsSuspiciousIllusion(botTarget)
		then
			if botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			or botTarget:HasModifier('modifier_enigma_black_hole_pull')
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end

			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if #nInRangeAlly >= #nInRangeEnemy then
				local distance = GetUnitToUnitDistance(bot, botTarget)
				return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), Min(distance, nCastRange))
			else
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) and bAttacking then
		local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 2 then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end

		if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) and J.GetHP(botTarget) > 0.3 then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	local Midas = J.GetComboItem(bot, 'item_hand_of_midas')
	if J.CanCastAbilitySoon(Midas, 3.0) and bot.TempestDouble == nil and not bot:WasRecentlyDamagedByAnyHero(5.0) then
		local nCreeps = bot:GetNearbyCreeps(1600, true)
		if #nCreeps >= 2 then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.GetHP(botTarget) > 0.5
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsDoubleCasting()
	if J.IsValidHero(bot.TempestDouble) then
		if bot.TempestDouble:IsCastingAbility() or bot.TempestDouble:IsUsingAbility() then
			return true
		end
	end

	return false
end

function X.UpdateDoubleStatus()
	if bot.TempestDouble == nil and bot:GetLevel() >= 6 then
		for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
			if  allyHero ~= nil
			and allyHero:IsAlive()
			and allyHero:HasModifier('modifier_arc_warden_tempest_double')
			then
				bot.TempestDouble = allyHero
			end
		end
	end
end

function X.IsUnderMagneticField(hUnit)
	return hUnit:HasModifier('modifier_arc_warden_magnetic_field_attack_range')
		or hUnit:HasModifier('modifier_arc_warden_magnetic_field_attack_speed')
end

return X