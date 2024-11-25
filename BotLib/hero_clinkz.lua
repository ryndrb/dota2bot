local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_clinkz'
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
                [2] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {2,3,2,3,3,6,2,2,1,1,6,1,1,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_power_treads",
				"item_desolator",--
				"item_orchid",
				"item_dragon_lance",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_greater_crit",--
				"item_bloodthorn",--
				"item_hurricane_pike",--
				"item_butterfly",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_greater_crit",
				"item_power_treads", "item_butterfly",
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
				"item_arcane_boots",
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
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_bottle", "item_sheepstick",
				"item_arcane_boots", "item_butterfly",
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
				"item_magic_wand", "item_boots_of_bearing",
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
				"item_magic_wand", "item_boots_of_bearing",
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

local Strafe            = bot:GetAbilityByName('clinkz_strafe')
local TarBomb           = bot:GetAbilityByName('clinkz_tar_bomb')
local DeathPact         = bot:GetAbilityByName('clinkz_death_pact')
local BurningBarrage    = bot:GetAbilityByName('clinkz_burning_barrage')
local BurningArmy       = bot:GetAbilityByName('clinkz_burning_army')
local SkeletonWalk      = bot:GetAbilityByName('clinkz_wind_walk')

local StrafeDesire
local TarBombDesire, TarBombTarget
local DeathPactDesire, DeathPactTarget
local BurningBarrageDesire, BurningBarrageLocation
local BurningArmyDesire, BurningArmyLocation
local SkeletonWalkDesire

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	Strafe            = bot:GetAbilityByName('clinkz_strafe')
	TarBomb           = bot:GetAbilityByName('clinkz_tar_bomb')
	DeathPact         = bot:GetAbilityByName('clinkz_death_pact')
	BurningBarrage    = bot:GetAbilityByName('clinkz_burning_barrage')
	BurningArmy       = bot:GetAbilityByName('clinkz_burning_army')
	SkeletonWalk      = bot:GetAbilityByName('clinkz_wind_walk')

    botTarget = J.GetProperTarget(bot)

    SkeletonWalkDesire = X.ConsiderSkeletonWalk()
    if SkeletonWalkDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SkeletonWalk)
        return
    end

    TarBombDesire, TarBombTarget = X.ConsiderTarBomb()
    if TarBombDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(TarBomb, TarBombTarget)
        return
    end

    BurningBarrageDesire, BurningBarrageLocation = X.ConsiderBurningBarrage()
    if BurningBarrageDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BurningBarrage, BurningBarrageLocation)
        return
    end

    StrafeDesire = X.ConsiderStrafe()
    if StrafeDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Strafe)
        return
    end

    DeathPactDesire, DeathPactTarget = X.ConsiderDeathPact()
    if DeathPactDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DeathPact, DeathPactTarget)
        return
    end

    BurningArmyDesire, BurningArmyLocation = X.ConsiderBurningArmy()
    if BurningArmyDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BurningArmy, BurningArmyLocation)
        return
    end
end

function X.ConsiderStrafe()
    if not J.CanCastAbility(Strafe)
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local nAttackRange = bot:GetAttackRange()

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and not J.IsRunning(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsFarming(bot)
    then
        if J.IsAttacking(bot)
        and J.GetManaAfter(Strafe:GetManaCost()) > 0.25
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
            if  nNeutralCreeps ~= nil
            and J.IsValid(nNeutralCreeps[1])
            and (#nNeutralCreeps >= 3
                or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and J.IsInRange(bot, nEnemyLaneCreeps[1], nAttackRange)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot)
    then
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and J.IsInRange(bot, nEnemyLaneCreeps[1], nAttackRange)
        and J.GetManaAfter(Strafe:GetManaCost()) > 0.25
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTarBomb()
    if not J.CanCastAbility(TarBomb)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nLevel = TarBomb:GetLevel()
    local nCastRange = J.GetProperCastRange(false, bot, TarBomb:GetCastRange())
    local nDamage = 40 + (20 * nLevel - 1)
    local nRadius = 325
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidTarget(enemyHero)
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

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if J.IsAttacking(bot)
            or (J.IsChasingTarget(bot, botTarget) and bot:GetCurrentMovementSpeed() < botTarget:GetCurrentMovementSpeed())
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

	if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.5
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (J.IsChasingTarget(bot, enemyHero) or bot:GetCurrentMovementSpeed() < enemyHero:GetCurrentMovementSpeed())
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 5)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if J.IsPushing(bot)
    then
        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsFarming(bot)
    then
        if J.IsAttacking(bot)
        and J.GetManaAfter(TarBomb:GetManaCost()) > 0.4
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
            if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
            and nNeutralCreeps[1]:GetHealth() >= 600
            then
                return BOT_ACTION_DESIRE_HIGH, nNeutralCreeps[1]
            end

            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 1
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and J.IsInRange(bot, nEnemyLaneCreeps[1], nCastRange)
            and nEnemyLaneCreeps[1]:GetHealth() >= 550
            then
                return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]
            end
        end
    end

    if J.IsLaning(bot)
    then
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.IsInRange(bot, creep, nCastRange)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then
				if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 600
                and J.GetMP(bot) > 0.3
                and J.IsInLaningPhase()
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
    end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.GetHP(botTarget) > 0.2
        and J.IsAttacking(bot)
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and (J.IsChasingTarget(bot, nAllyInRangeEnemy[1]) or bot:GetCurrentMovementSpeed() < nAllyInRangeEnemy[1]:GetCurrentMovementSpeed())
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDeathPact()
    if not J.CanCastAbility(DeathPact)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DeathPact:GetCastRange())
    local nMaxLevel = DeathPact:GetSpecialValueInt('creep_level')
    local nCreeps = bot:GetNearbyCreeps(nCastRange, true)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

    if J.IsInLaningPhase()
    then
        if J.IsLaning(bot)
        then
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

            for _, creep in pairs(nEnemyLaneCreeps)
            do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep)
                and creep:GetLevel() <= nMaxLevel
                then
                    if J.IsValidHero(nEnemyHeroes[1])
                    and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 600
                    and botTarget ~= creep
                    and not bot:HasModifier('modifier_clinkz_death_pact')
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    else
        local creep = X.GetMostHPCreepLevel(nCreeps, nMaxLevel)
        if creep ~= nil and creep:CanBeSeen() and creep:IsAlive()
        and J.CanBeAttacked(creep)
        and not bot:HasModifier('modifier_clinkz_death_pact')
        and not creep:IsAncientCreep()
        then
            return BOT_ACTION_DESIRE_HIGH, creep
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

--Aghanim's Shard
function X.ConsiderBurningBarrage()
    if not J.CanCastAbility(BurningBarrage)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, BurningBarrage:GetCastRange())

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange - 125)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if not J.IsRunning(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 0.5)
            end
		end
	end

    if J.IsFarming(bot)
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.IsAttacking(bot)
        and J.GetManaAfter(BurningBarrage:GetManaCost()) > 0.38
        then
            if J.IsBigCamp(nNeutralCreeps)
            or nNeutralCreeps[1]:IsAncientCreep()
            then
                if #nNeutralCreeps >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
                end
            else
                if #nNeutralCreeps >= 3
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
                end
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)
    then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

--Aghanim's Scepter
function X.ConsiderBurningArmy()
	if not J.CanCastAbility(BurningArmy)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BurningArmy:GetCastRange())
    local nSpawnRange = 900

    local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + (nSpawnRange / 2), nSpawnRange, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nSpawnRange)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            if GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nInRangeEnemy)) > nCastRange
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nSpawnRange)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                if GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nInRangeEnemy)) > nCastRange
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end
            else
                if GetUnitToUnitDistance(bot, botTarget) > nCastRange
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSkeletonWalk()
    if not J.CanCastAbility(SkeletonWalk)
    or bot:HasModifier('modifier_clinkz_wind_walk')
    or J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local RoshanLocation = J.GetCurrentRoshanLocation()
    local TormentorLocation = J.GetTormentorLocation(GetTeam())
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if  J.IsGoingOnSomeone(bot)
    and bot:GetActiveModeDesire() > 0.65
	then
		if  J.IsValidTarget(botTarget)
        and GetUnitToUnitDistance(bot, botTarget) > 1600
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.5
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and (bot:WasRecentlyDamagedByAnyHero(4) or J.GetHP(bot) < 0.5 or not J.WeAreStronger(bot, 1600))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsPushing(bot)
    then
        if bot.laneToPush ~= nil
        then
            if  GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0)) > 3200
            and bot:GetActiveModeDesire() > 0.65
            then
                return  BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot)
    then
        if bot.laneToDefend ~= nil
        then
            if  GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0)) > 3200
            and bot:GetActiveModeDesire() > 0.65
            then
                return  BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot)
    then
        if bot.farmLocation ~= nil
        then
            if GetUnitToLocationDistance(bot, bot.farmLocation) > 3200
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsLaning(bot)
	then
		if  J.GetManaAfter(SkeletonWalk:GetManaCost()) > 0.8
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and J.IsInLaningPhase()
		and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > 1600
			then
                return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if GetUnitToLocationDistance(bot, RoshanLocation) > 4000
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if GetUnitToLocationDistance(bot, TormentorLocation) > 4000
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Helper Funcs
function X.GetMostHPCreepLevel(creeList, level)
	local mostHpCreep = nil
	local maxHP = 0

	for _, creep in pairs(creeList)
	do
        if J.IsValid(creep)
        then
            local uHp = creep:GetHealth()
            local lvl = creep:GetLevel()

            if uHp > maxHP
            and lvl <= level
            and not J.IsKeyWordUnit("flagbearer", creep)
            then
                mostHpCreep = creep
                maxHP = uHp
            end
        end
	end

	return mostHpCreep
end

return X