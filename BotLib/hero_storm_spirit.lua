local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_storm_spirit'
then

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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {1,3,2,1,1,6,1,3,3,3,6,2,2,2,6},
				[2] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",

				"item_null_talisman",
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_orchid",
				"item_witch_blade",
				"item_kaya",
				"item_black_king_bar",--
				"item_kaya_and_sange",--
				"item_devastator",--
				"item_ultimate_scepter",
				"item_bloodthorn",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_kaya",
				"item_bottle", "item_black_king_bar",
				"item_null_talisman", "item_ultimate_scepter",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

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

end

local StaticRemnant 	= bot:GetAbilityByName( "storm_spirit_static_remnant" )
local ElectricVortex 	= bot:GetAbilityByName( "storm_spirit_electric_vortex" )
local Overload 			= bot:GetAbilityByName( "storm_spirit_overload" )
local BallLightning 	= bot:GetAbilityByName( "storm_spirit_ball_lightning" )

local StaticRemnantDesire, StaticRemnantLocation
local ElectricVortexDesire, ElectricVortexTarget
local OverloadDesire
local BallLightningDesire, BallLightningLoc

local BallVortexDesire, BallVortexLocation, eta

local bStaticSlideFacet = false

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	StaticRemnant 	= bot:GetAbilityByName( "storm_spirit_static_remnant" )
	ElectricVortex 	= bot:GetAbilityByName( "storm_spirit_electric_vortex" )
	Overload 			= bot:GetAbilityByName( "storm_spirit_overload" )
	BallLightning 	= bot:GetAbilityByName( "storm_spirit_ball_lightning" )

	BallVortexDesire, BallVortexLocation, eta = X.ConsiderBallVortex()
	if BallVortexDesire > 0
	then
		bot:Action_ClearActions(false)
		bot:ActionQueue_UseAbilityOnLocation(BallLightning, BallVortexLocation)
		bot:ActionQueue_Delay(eta)
		bot:ActionQueue_UseAbility(ElectricVortex)
		return
	end

    BallLightningDesire, BallLightningLoc = X.ConsiderBallLightning()
    if BallLightningDesire > 0
	then
		bot:Action_UseAbilityOnLocation(BallLightning, BallLightningLoc)
		return
	end

	ElectricVortexDesire, ElectricVortexTarget = X.ConsiderElectricVortex()
	if ElectricVortexDesire > 0
	then
		if bot:HasScepter() and string.find(GetBot():GetUnitName(), 'storm_spirit')
		then
			bot:Action_UseAbility(ElectricVortex)
			return
		else
			if J.CanCastAbility(StaticRemnant)
			and StaticRemnant:GetManaCost() + ElectricVortex:GetManaCost() > bot:GetMana() + 150
			then
				J.SetQueuePtToINT(bot, true)
				bot:ActionQueue_UseAbilityOnEntity(ElectricVortex, ElectricVortexTarget)
				bot:ActionQueue_Delay(0.3 + 0.77)
				bot:ActionQueue_UseAbility(StaticRemnant)
				return
			else
				bot:Action_UseAbilityOnEntity(ElectricVortex, ElectricVortexTarget)
				return
			end
		end
	end

	if bStaticSlideFacet then
		StaticRemnantDesire, StaticRemnantLocation = X.ConsiderStaticRemnant__StaticSlide()
	else
		StaticRemnantDesire = X.ConsiderStaticRemnant()
	end
	if StaticRemnantDesire > 0
	then
		J.SetQueuePtToINT(bot, true)
		if bStaticSlideFacet then
			bot:ActionQueue_UseAbilityOnLocation(StaticRemnant, StaticRemnantLocation)
		else
			bot:ActionQueue_UseAbility(StaticRemnant)
		end
		return
	end

	OverloadDesire = X.ConsiderOverload()
	if OverloadDesire > 0
	then
		bot:Action_UseAbility(Overload)
		return
	end
end

function X.ConsiderStaticRemnant()
	if not J.CanCastAbility(StaticRemnant)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = StaticRemnant:GetSpecialValueInt('static_remnant_radius')
	local nAbilityLevel = StaticRemnant:GetLevel()
	local nManaAfter = J.GetManaAfter(StaticRemnant:GetManaCost())
	local nDamage = StaticRemnant:GetSpecialValueInt('static_remnant_damage')
	local nAttackRange = bot:GetAttackRange()
	local botTarget = J.GetProperTarget(bot)

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not J.IsChasingTarget(bot, enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local bChasingTarget = J.IsChasingTarget(bot, botTarget)
			if (not bChasingTarget and J.IsInRange(bot, botTarget, nRadius))
			or (bChasingTarget and J.IsInRange(bot, botTarget, nAttackRange / 2))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			then
				local nInRangeEnemy = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)
				if not J.IsSuspiciousIllusion(enemyHero) or #nInRangeEnemy >= 2 then
					local bTargetChasing = J.IsChasingTarget(enemyHero, bot)
					if (bTargetChasing and #nAllyHeroes < #nEnemyHeroes and J.GetHP(bot) < 0.75) or (J.GetHP(bot) < 0.5 and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)) then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
	if  J.IsFarming(bot)
	and nAbilityLevel >= 2
	and nManaAfter > 0.25
	and J.IsAttacking(bot)
	then
		if J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 2 or (#nEnemyCreeps == 1 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot)) and nManaAfter > 0.25 then
		if J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 2 or (#nEnemyCreeps == 1 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if nManaAfter > 0.35 then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
		if J.IsInLaningPhase() then
			if nLocationAoE.count >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		else
			if nLocationAoE.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderStaticRemnant__StaticSlide()
	if not J.CanCastAbility(StaticRemnant)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = 800
	local nRadius = StaticRemnant:GetSpecialValueInt('static_remnant_radius')
	local nAbilityLevel = StaticRemnant:GetLevel()
	local nManaAfter = J.GetManaAfter(StaticRemnant:GetManaCost())
	local nDamage = StaticRemnant:GetSpecialValueInt('static_remnant_damage')
	local nAttackRange = bot:GetAttackRange()
	local botTarget = J.GetProperTarget(bot)

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_oracle_false_promise')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local bChasingTarget = J.IsChasingTarget(bot, enemyHero)
			if not bChasingTarget or (bChasingTarget and J.IsInRange(bot, enemyHero, nAttackRange)) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local bChasingTarget = J.IsChasingTarget(bot, botTarget)
			if not bChasingTarget or (bChasingTarget and J.IsInRange(bot, botTarget, nAttackRange)) then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				local bTargetChasing = J.IsChasingTarget(enemyHero, bot)
				if (bTargetChasing and #nAllyHeroes < #nEnemyHeroes and J.GetHP(bot) < 0.75) or (J.GetHP(bot) < 0.5 and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)
	if  J.IsFarming(bot)
	and nAbilityLevel >= 2
	and nManaAfter > 0.25
	and J.IsAttacking(bot)
	then
		if J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 2 or (nLocationAoE.count == 1 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot)) and nManaAfter > 0.25 then
		if J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
	if J.IsInLaningPhase() then
		if nLocationAoE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	else
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderElectricVortex()
	if not J.CanCastAbility(ElectricVortex)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, ElectricVortex:GetCastRange())
	local hasScepter = bot:HasScepter()
	local nRadius = hasScepter and 475 or 0
	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and (hasScepter or J.CanCastOnTargetAdvanced(enemyHero))
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if  J.IsInTeamFight(bot, 1200)
	and bot:HasScepter()
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

		if #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, nil
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and (hasScepter or J.CanCastOnTargetAdvanced(botTarget))
		and not J.IsDisabled(botTarget)
		then
			if hasScepter
			then
				if J.IsInRange(bot, botTarget, nRadius)
				then
					return BOT_ACTION_DESIRE_HIGH, nil
				end
			else
				if J.IsInRange(bot, botTarget, nCastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderOverload()
	if not J.CanCastAbility(Overload)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nActivationRadius = 750

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nActivationRadius, false, BOT_MODE_NONE)

		if #nInRangeAlly >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBallLightning()
	if not J.CanCastAbility(BallLightning)
	or BallLightning ~= nil and BallLightning:IsInAbilityPhase()
	or bot:IsRooted()
	or bot:HasModifier("modifier_storm_spirit_ball_lightning")
	or bot:HasModifier('modifier_bloodseeker_rupture')
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastPoint = BallLightning:GetCastPoint()
	local nMana = bot:GetMana() / bot:GetMaxMana()
	local nSpeed = BallLightning:GetSpecialValueInt('ball_lightning_move_speed')
	local botTarget = J.GetProperTarget(bot)
	local botAttackRange = bot:GetAttackRange()
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsStuck(bot)
	or J.IsStunProjectileIncoming(bot, botAttackRange)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, 600)
	end

	if  J.IsGoingOnSomeone(bot)
	and nMana > 0.15
	then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 1000)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanBeAttacked(botTarget)
		and GetUnitToUnitDistance(bot, botTarget) > botAttackRange - 150
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and J.WeAreStronger(bot, 1400)
		then
			local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], 600)
		and (J.IsChasingTarget(nEnemyHeroes[1], bot) or J.GetHP(bot) < 0.5 or not J.WeAreStronger(bot, 1200))
		and bot:WasRecentlyDamagedByAnyHero(5)
		then
			local loc = J.GetTeamFountain()
			local dist = 1400 * (1 - J.GetHP(bot))

			if dist < 700 then dist = 700 end

			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, dist)
		end
	end

	-- if  J.IsFarming(bot)
	-- and J.IsAttacking(bot)
	-- and nMana > 0.7
	-- then
	-- 	local nCreeps = bot:GetNearbyCreeps(900, true)

	-- 	if J.CanBeAttacked(nCreeps[1])
	-- 	and not J.IsRunning(nCreeps[1])
	-- 	and (#nCreeps >= 2 or #nCreeps == 1 and nCreeps[1]:IsAncientCreep())
	-- 	and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nCreeps)) > 300
	-- 	then
	-- 		return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nCreeps)
	-- 	end
	-- end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBallVortex()
	if X.CanDoBallVortex()
	then
		local nRadius = 475
		local nCastPoint = BallLightning:GetCastPoint()
		local nSpeed = BallLightning:GetSpecialValueInt('ball_lightning_move_speed')

		local nTeamFightLocation = J.GetTeamFightLocation(bot)

		if  J.IsInTeamFight(bot, 1200)
		and nTeamFightLocation ~= nil
		and GetUnitToLocationDistance(bot, nTeamFightLocation) <= 1200
		then
			local nDelay = (GetUnitToLocationDistance(bot, nTeamFightLocation) / nSpeed) + nCastPoint
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1200, nRadius, nDelay, 0)
			local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

			if #nInRangeEnemy >= 2
			and not J.IsLocationInChrono(nLocationAoE.targetloc)
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, nDelay
			end
		end
    end

	return BOT_ACTION_DESIRE_NONE, 0, 0
end

function X.CanDoBallVortex()
	if  J.CanCastAbility(ElectricVortex)
	and J.CanCastAbility(BallLightning)
	and string.find(GetBot():GetUnitName(), 'storm_spirit')
	and bot:HasScepter()
	and not bot:HasModifier('modifier_bloodseeker_rupture')
    then
		if J.IsInTeamFight(bot, 1200)
		then
			local nMana = bot:GetMaxMana()
			local nActivationManaCost = BallLightning:GetSpecialValueInt('ball_lightning_initial_mana_base')
			local nActivationInitManaPercentage = BallLightning:GetSpecialValueFloat('ball_lightning_initial_mana_percentage') / 100

			local nTeamFightLocation = J.GetTeamFightLocation(bot)

			if  nTeamFightLocation ~= nil
			and GetUnitToLocationDistance(bot, nTeamFightLocation) <= 1200
			then
				local totalDist = GetUnitToLocationDistance(bot, nTeamFightLocation)

				local nBofLCost = nActivationManaCost
								+ nActivationInitManaPercentage * nMana
								+ ((10 + 0.0065 * nMana) * (totalDist / 100))

				local nManaCost = nBofLCost + ElectricVortex:GetManaCost()

				if  bot:GetMana() >= nManaCost
				then
					return true
				end
			end
		end
    end

	return false
end

return X