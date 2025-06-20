local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_gyrocopter'
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,3,2,3,6,3,2,2,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_quelling_blade",
            
                "item_falcon_blade",
                "item_power_treads",
                "item_magic_wand",
                "item_lesser_crit",
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_greater_crit",--
                "item_satanic",--
                "item_monkey_king_bar",--
                "item_butterfly",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_aghanims_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_satanic",
                "item_falcon_blade", "item_monkey_king_bar",
            },
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
                }
            },
            ['ability'] = {
                [1] = {2,3,3,2,3,6,3,2,2,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_quelling_blade",
            
                "item_bottle",
                "item_falcon_blade",
                "item_magic_wand",
                "item_power_treads",
                "item_lesser_crit",
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_greater_crit",--
                "item_satanic",--
                "item_monkey_king_bar",--
                "item_butterfly",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_aghanims_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_ultimate_scepter",
                "item_magic_wand", "item_black_king_bar",
                "item_falcon_blade", "item_satanic",
                "item_bottle", "item_monkey_king_bar",
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_ancient_janggo",
                "item_force_staff",
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_lotus_orb",--
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_hurricane_pike",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_octarine_core",
            },
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
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_mekansm",
                "item_force_staff",
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_lotus_orb",--
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_hurricane_pike",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_octarine_core",
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

local RocketBarrage = bot:GetAbilityByName('gyrocopter_rocket_barrage')
local HomingMissile = bot:GetAbilityByName('gyrocopter_homing_missile')
local FlakCannon    = bot:GetAbilityByName('gyrocopter_flak_cannon')
local CallDown      = bot:GetAbilityByName('gyrocopter_call_down')

local RocketBarrageDesire
local HomingMissileDesire, HomingMissileTarget
local FlakCannonDesire
local CallDownDesire, CallDownLocation

local botTarget

function X.SkillsComplement()
    if J.CanNotUseAbility( bot ) then return end

    RocketBarrage = bot:GetAbilityByName('gyrocopter_rocket_barrage')
    HomingMissile = bot:GetAbilityByName('gyrocopter_homing_missile')
    FlakCannon    = bot:GetAbilityByName('gyrocopter_flak_cannon')
    CallDown      = bot:GetAbilityByName('gyrocopter_call_down')

    botTarget = J.GetProperTarget(bot)

    HomingMissileDesire, HomingMissileTarget = X.ConsiderHomingMissile()
    if HomingMissileDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HomingMissile, HomingMissileTarget)
        return
    end

    FlakCannonDesire = X.ConsiderFlakCannon()
    if FlakCannonDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FlakCannon)
        return
    end

    CallDownDesire, CallDownLocation = X.ConsiderCallDown()
    if CallDownDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CallDown, CallDownLocation)
        return
    end

    RocketBarrageDesire = X.ConsiderRocketBarrage()
    if RocketBarrageDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(RocketBarrage)
        return
    end
end

function X.ConsiderRocketBarrage()
    if not J.CanCastAbility(RocketBarrage)
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = RocketBarrage:GetSpecialValueInt('radius')
    local nDamage = RocketBarrage:GetSpecialValueInt('value')
    local nRocketsPerSecond = RocketBarrage:GetSpecialValueInt('rockets_per_second')
    local nDuration = 3
    local nAbilityLevel = RocketBarrage:GetLevel()

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nCreeps = bot:GetNearbyCreeps(nRadius, true)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage * nRocketsPerSecond * nDuration, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and nCreeps ~= nil and #nCreeps <= 1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and nCreeps ~= nil and #nCreeps <= 1
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nRadius)
        and not nEnemyHeroes[1]:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  (J.IsFarming(bot) or J.IsPushing(bot))
    and J.GetManaAfter(RocketBarrage:GetManaCost()) > 0.35
    and nAbilityLevel >= 2
    and J.IsAttacking(bot)
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        nCreeps = bot:GetNearbyCreeps(bot:GetAttackRange() + 150, true)
        if  nCreeps ~= nil and #nCreeps >= 2
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nCreeps)) <= nRadius
        and J.CanBeAttacked(nCreeps[1])
        and not J.IsRunning(nCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHomingMissile()
    if not J.CanCastAbility(HomingMissile)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, HomingMissile:GetCastRange())
    local nLaunchDelay = HomingMissile:GetSpecialValueFloat('pre_flight_time')
	local nDamage = HomingMissile:GetAbilityDamage()

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nLaunchDelay)
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
        local strongestEnemy = J.GetStrongestUnit(nCastRange, bot, true, false, 5)

        if  J.IsValidHero(strongestEnemy)
        and J.CanCastOnNonMagicImmune(strongestEnemy)
        and J.CanCastOnTargetAdvanced(strongestEnemy)
        and not J.IsDisabled(strongestEnemy)
        then
            return BOT_ACTION_DESIRE_HIGH, strongestEnemy
        end
	end

	if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if bot:GetLevel() < 6
            and J.IsCore(bot)
            then
                local nEnemyTowers = bot:GetNearbyTowers(1600, true)
                if nEnemyTowers ~= nil
                and (#nEnemyTowers == 0 or J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(botTarget, nEnemyTowers[1], 880))
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
    and bot:GetActiveModeDesire() > 0.6
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.CanCastOnTargetAdvanced(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
		end
	end

    if  J.IsLaning(bot)
    and J.IsInLaningPhase()
    and (J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1600)))
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and creep:GetHealth() > bot:GetAttackDamage()
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
            and J.CanBeAttacked(creep)
            and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nLaunchDelay)
            and bot:GetAttackTarget() ~= creep
			then
				if J.IsValidHero(nEnemyHeroes[1])
				and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

    local nAllyHeroes  = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if  J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderFlakCannon()
    if not J.CanCastAbility(FlakCannon)
    or bot:IsDisarmed()
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = FlakCannon:GetSpecialValueInt('radius')
    local nAbilityLevel = FlakCannon:GetLevel()
    local nInRangeIllusion = J.GetIllusionsNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and (not J.IsSuspiciousIllusion(botTarget) and not botTarget:IsAttackImmune()
            or J.IsSuspiciousIllusion(botTarget) and #nInRangeIllusion >= 2 and not J.IsInTeamFight(bot, 1200))
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  ((J.IsPushing(bot) and nEnemyHeroes ~= nil and #nEnemyHeroes == 0) or J.IsDefending(bot))
    and nAbilityLevel >= 2
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) <= nRadius
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if  J.IsFarming(bot)
    and nAbilityLevel >= 2
    and J.GetManaAfter(FlakCannon:GetManaCost()) > 0.35
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    and J.IsAttacking(bot)
    and not bot:HasModifier('modifier_gyrocopter_rocket_barrage')
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(bot:GetAttackRange() + 150)

        if  nNeutralCreeps ~= nil
        and J.IsValid(nNeutralCreeps[1])
        and (#nNeutralCreeps >= 3
            or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) <= nRadius
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCallDown()
    if not J.CanCastAbility(CallDown)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, CallDown:GetCastRange())
	local nCastPoint = CallDown:GetCastPoint()
	local nRadius = CallDown:GetSpecialValueInt('radius')
    local nStrikeDelay = CallDown:GetSpecialValueInt('strike_delay')
    local nDamage = CallDown:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if DotaTime() < 10 * 60
    then
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
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nStrikeDelay + nCastPoint)
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint + nStrikeDelay, 0)
            nEnemyHeroes = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            if #nEnemyHeroes >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nStrikeDelay + nCastPoint)
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and J.IsModeTurbo() and DotaTime() < 20 * 60 or DotaTime() < 30 * 60
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and J.IsModeTurbo() and DotaTime() < 15 * 60 or DotaTime() < 30 * 60
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X