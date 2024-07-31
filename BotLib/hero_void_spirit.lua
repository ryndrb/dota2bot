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
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,1,3,2,3,6,3,1,1,1,2,6,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_gauntlets",
			
				"item_bottle",
				"item_bracer",
				"item_boots",
				"item_magic_wand",
				"item_power_treads",
				"item_manta",--
				"item_ultimate_scepter",
				"item_lesser_crit",
				"item_black_king_bar",--
				"item_travel_boots",
				"item_greater_crit",--
				"item_bloodthorn",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_bottle",
				"item_bracer",
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

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

local AetherRemnant = bot:GetAbilityByName( "void_spirit_aether_remnant" )
local Dissimilate   = bot:GetAbilityByName( "void_spirit_dissimilate" )
local ResonantPulse = bot:GetAbilityByName( "void_spirit_resonant_pulse" )
local AstralStep    = bot:GetAbilityByName( "void_spirit_astral_step" )

local AetherRemnantDesire, AetherRemnantLocation
local DissimilateDesire
local ResonantPulseDesire
local AstralStepDesire, AstralStepLocation

local RemnantCastTime = -100

local botTarget, nAllyHeroes, nEnemyHeroes
local astralCastTimeDelta = 0

function X.SkillsComplement()
    if J.CanNotUseAbility(bot)
	then
		return
	end

	botTarget = J.GetProperTarget(bot)
	nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	AstralStepDesire, AstralStepLocation = X.ConsiderAstralStep()
    if AstralStepDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(AstralStep, AstralStepLocation)
        RemnantCastTime = DotaTime()
		return
    end

	AetherRemnantDesire, AetherRemnantLocation = X.ConsiderAetherRemnant()
    if AetherRemnantDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(AetherRemnant, AetherRemnantLocation)
		return
    end

	DissimilateDesire = X.ConsiderDissimilate()
    if DissimilateDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Dissimilate)
		return
    end

	ResonantPulseDesire = X.ConsiderResonantPulse()
    if ResonantPulseDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ResonantPulse)
		ResonantPulseCastTime = DotaTime()
		return
    end
end

function X.ConsiderAetherRemnant()
    if not AetherRemnant:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = AetherRemnant:GetSpecialValueInt('radius')
	local nActivationDelay = AetherRemnant:GetSpecialValueFloat('activation_delay')
	local nDamage = AetherRemnant:GetSpecialValueInt('impact_damage')
	local nCastRange = J.GetProperCastRange(false, bot, AetherRemnant:GetCastRange())
	local nSpeed = AetherRemnant:GetSpecialValueInt('projectile_speed')

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidTarget(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nActivationDelay
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
			end
		end
	end

	if  J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, nRadius)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nActivationDelay

			if J.IsInLaningPhase()
			then
				local totalDmg = bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
				if (totalDmg - botTarget:GetHealth()) / botTarget:GetMaxHealth() >= 0.4
				or bot:GetActiveModeDesire() > 0.9
				then
					return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
				end
			else
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3)
	then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], nRadius)
		and J.IsChasingTarget(nEnemyHeroes[1], bot)
		and not J.IsDisabled(nEnemyHeroes[1])
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if bot:GetLevel() > 10
	then
		for _, allyHero in pairs(nAllyHeroes)
		do
			if J.IsValidHero(allyHero)
			and J.IsRetreating(allyHero)
			and allyHero:WasRecentlyDamagedByAnyHero(3)
			and not J.IsRealInvisible(bot)
			and not J.IsRealInvisible(allyHero)
			and not allyHero:IsIllusion()
			then
				local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

				if J.IsValidHero(nAllyInRangeEnemy[1])
				and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
				and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
				and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
				and not J.IsDisabled(nAllyInRangeEnemy[1])
				and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
				and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					local eta = (GetUnitToUnitDistance(bot, nAllyInRangeEnemy[1]) / nSpeed) + nActivationDelay
					return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], eta)
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDissimilate()
    if not Dissimilate:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Dissimilate:GetSpecialValueInt('first_ring_distance_offset')

    if (J.IsStunProjectileIncoming(bot, 350) or J.IsUnitTargetProjectileIncoming(bot, 400))
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if not bot:HasModifier('modifier_sniper_assassinate') and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 400)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 50)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3)
	and bot:GetActiveModeDesire() > 0.82
	then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], nRadius * 0.8)
		and J.IsChasingTarget(nEnemyHeroes[1], bot)
		and (not J.IsSuspiciousIllusion(nEnemyHeroes[1]) or J.GetHP(bot) < 0.2)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderResonantPulse()
    if not ResonantPulse:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = ResonantPulse:GetSpecialValueInt('radius')
	local nDamage = ResonantPulse:GetSpecialValueInt('damage')
	local nManaCost = ResonantPulse:GetManaCost()
	local nMana = J.GetMP(bot)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidTarget(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if bot:HasModifier('modifier_void_spirit_resonant_pulse_physical_buff')
	or bot:HasModifier('modifier_void_spirit_resonant_pulse_ring')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3)
	then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], nRadius)
		and (J.IsChasingTarget(nEnemyHeroes[1], bot) or #nEnemyHeroes > #nAllyHeroes)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local tCreeps = bot:GetNearbyCreeps(nRadius, true)

	if (J.IsPushing(bot) or J.IsDefending(bot))
	and (#nAllyHeroes == 0 or J.IsValidHero(nAllyHeroes[1]) and not J.IsInRange(bot, nAllyHeroes[1], 600))
	and J.GetManaAfter(nManaCost) > 0.48
	then
		if #tCreeps >= 4
		and J.CanBeAttacked(tCreeps[1])
		and #nEnemyHeroes == 0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot)
	and J.GetManaAfter(nManaCost) > 0.35
	then
		if #tCreeps >= 4 and J.CanBeAttacked(tCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  J.IsLaning(bot)
	and nMana > 0.33
	then
		for _, creep in pairs(tCreeps)
		do
			if  J.IsValid(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
			and creep:GetHealth() <= nDamage
			and not J.IsInRange(bot, creep, bot:GetAttackRange() + 200)
			and not J.IsAttacking(bot)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.GetHP(botTarget) > 0.2
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local canKillAmount = X.GetCanKillAmount(tCreeps, nDamage, nRadius)
	if canKillAmount >= 4
	and (J.IsValidHero(nEnemyHeroes[1]) and J.IsInRange(bot, nEnemyHeroes[1], 800) or canKillAmount >= 5)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderAstralStep()
	if not AstralStep:IsFullyCastable()
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nMaxTravelDist = AstralStep:GetSpecialValueInt('max_travel_distance')
	local nMinTravelDist = AstralStep:GetSpecialValueInt('min_travel_distance')
	local nCastPoint = AstralStep:GetCastPoint()
	local nDamage = AstralStep:GetSpecialValueInt('pop_damage')

	if DotaTime() < RemnantCastTime + astralCastTimeDelta
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		astralCastTimeDelta = 5
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nMaxTravelDist)
	end

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidTarget(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and J.WeAreStronger(bot, 1600)
		then
			astralCastTimeDelta = 1.5
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nMaxTravelDist)
		and not J.IsInRange(bot, botTarget, nMinTravelDist)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and J.WeAreStronger(bot, 1200)
		then
			if bot:GetCurrentMovementSpeed() >= botTarget:GetCurrentMovementSpeed() + 30
			then
				return BOT_ACTION_DESIRE_NONE, 0
			else
				astralCastTimeDelta = 1
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint)
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3.5)
	and bot:GetActiveModeDesire() > 0.77
	then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], 880)
		and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		then
			astralCastTimeDelta = 2.5
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nMaxTravelDist)
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.GetCanKillAmount(tUnitList, nDamage, nRadius)
	local count = 0

	for _, unit in pairs(tUnitList)
	do
		if J.IsValid(unit)
		and J.CanBeAttacked(unit)
		and unit:GetHealth() <= nDamage
		and J.IsInRange(bot, unit, nRadius)
		then
			count = count + 1
		end
	end

	return count
end

return X