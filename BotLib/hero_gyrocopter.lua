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
                "item_swift_blink",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_satanic",
                "item_falcon_blade", "item_monkey_king_bar",
                "item_power_treads", "item_swift_blink",
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
                "item_swift_blink",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_ultimate_scepter",
                "item_magic_wand", "item_black_king_bar",
                "item_falcon_blade", "item_satanic",
                "item_bottle", "item_monkey_king_bar",
                "item_power_treads", "item_swift_blink",
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
                "item_lotus_orb",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
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
                "item_lotus_orb",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    RocketBarrage = bot:GetAbilityByName('gyrocopter_rocket_barrage')
    HomingMissile = bot:GetAbilityByName('gyrocopter_homing_missile')
    FlakCannon    = bot:GetAbilityByName('gyrocopter_flak_cannon')
    CallDown      = bot:GetAbilityByName('gyrocopter_call_down')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    HomingMissileDesire, HomingMissileTarget = X.ConsiderHomingMissile()
    if HomingMissileDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HomingMissile, HomingMissileTarget)
        return
    end

    FlakCannonDesire = X.ConsiderFlakCannon()
    if FlakCannonDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FlakCannon)
        return
    end

    CallDownDesire, CallDownLocation = X.ConsiderCallDown()
    if CallDownDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CallDown, CallDownLocation)
        return
    end

    RocketBarrageDesire = X.ConsiderRocketBarrage()
    if RocketBarrageDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(RocketBarrage)
        return
    end
end

function X.ConsiderRocketBarrage()
    if not J.CanCastAbility(RocketBarrage) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = RocketBarrage:GetSpecialValueInt('radius')
    local nDamage = RocketBarrage:GetSpecialValueInt('rocket_damage')
    local nRocketsPerSecond = RocketBarrage:GetSpecialValueInt('rockets_per_second')
    local nDuration = RocketBarrage:GetSpecialValueInt('barrage_duration')
    local nAbilityLevel = RocketBarrage:GetLevel()
    local nManaCost = RocketBarrage:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {HomingMissile, FlakCannon, CallDown})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {FlakCannon, CallDown})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {RocketBarrage, HomingMissile, FlakCannon, CallDown})
    local fManaThreshold4 = J.GetManaThreshold(bot, nManaCost, {FlakCannon})

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage * nRocketsPerSecond, DAMAGE_TYPE_MAGICAL, nDuration)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and #nEnemyCreeps <= 1
        and fManaAfter > fManaThreshold4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and #nEnemyCreeps <= 1
        and fManaAfter > fManaThreshold2
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nRadius)
			and J.CanCastOnNonMagicImmune(enemy)
			and not enemy:IsDisarmed()
			then
				local nInRangeEnemy = bot:GetNearbyHeroes(nRadius - 50, true, BOT_MODE_NONE)
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				or (#nInRangeEnemy >= 2 and #nEnemyCreeps <= 1)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold1 and bAttacking
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nEnemyCreeps >= 4 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold2 and bAttacking
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nEnemyCreeps >= 4 and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end

        local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
        if #nInRangeEnemy >= 3 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHomingMissile()
    if not J.CanCastAbility(HomingMissile) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, HomingMissile:GetCastRange())
    local nCastPoint = HomingMissile:GetCastPoint()
    local nLaunchDelay = HomingMissile:GetSpecialValueFloat('pre_flight_time')
	local nDamage = HomingMissile:GetSpecialValueInt('hit_damage')
    local nSpeed = HomingMissile:GetSpecialValueInt('speed')
    local nManaCost = HomingMissile:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FlakCannon, CallDown})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {RocketBarrage, FlakCannon, CallDown})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and botTarget ~= enemyHero
        then
            local eta = (GetUnitToLocationDistance(bot, J.GetCorrectLoc(enemyHero, nLaunchDelay)) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold1
        then
            if J.IsEarlyGame() and J.IsCore(bot) then
                local nEnemyTowers = bot:GetNearbyTowers(1600, true)
                if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and (not J.IsInRange(botTarget, nEnemyTowers[1], 900) or nEnemyTowers[1]:GetAttackTarget() ~= nil)) then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
			and J.CanCastOnTargetAdvanced(enemy)
            and bot:WasRecentlyDamagedByHero(enemy, 4.0)
            and not J.IsDisabled(enemy)
			and not enemy:IsDisarmed()
			then
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
                or botHP < 0.4
				then
					return BOT_ACTION_DESIRE_HIGH, enemy
				end
			end
		end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
			and string.find(creep:GetUnitName(), 'ranged')
            and creep:GetHealth() > bot:GetAttackDamage()
            and bot:GetAttackTarget() ~= creep
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
			end
		end
	end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and bot ~= allyHero
        and J.IsRetreating(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        and fManaAfter > 0.5
        and (not J.IsCore(bot) or not J.IsRetreating(bot))
        then
            for _, enemy in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemy)
                and J.CanBeAttacked(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.CanCastOnTargetAdvanced(enemy)
                and J.IsChasingTarget(enemy, allyHero)
                and bot:WasRecentlyDamagedByHero(enemy, 4.0)
                and not J.IsDisabled(enemy)
                and not enemy:IsDisarmed()
                then
                    return BOT_ACTION_DESIRE_HIGH, enemy
                end
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
    local nManaCost = FlakCannon:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FlakCannon, CallDown})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {RocketBarrage, FlakCannon, CallDown})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange() * 2)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius * 0.9)
            if #nInRangeEnemy >= 2 then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        if J.IsValid(botTarget)
        and J.CanBeAttacked(botTarget)
        and botTarget:IsCreep()
        then
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius * 0.9, 0, 0)
            if (nLocationAoE.count >= 4 and #nAllyHeroes <= 3)
            or (nLocationAoE.count >= 6)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        if J.IsValid(botTarget)
        and J.CanBeAttacked(botTarget)
        and botTarget:IsCreep()
        and #nEnemyHeroes == 0 and #nAllyHeroes <= 3
        then
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius * 0.9, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if #nEnemyHeroes >= 3 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1
    and #nEnemyHeroes == 0
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        if J.IsValid(botTarget)
        and J.CanBeAttacked(botTarget)
        and botTarget:IsCreep()
        then
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius * 0.9, 0, 0)
            if nLocationAoE.count >= 3 or (nLocationAoE.count >= 2 and botTarget:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCallDown()
    if not J.CanCastAbility(CallDown) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, CallDown:GetCastRange())
	local nCastPoint = CallDown:GetCastPoint()
	local nRadius = CallDown:GetSpecialValueInt('radius')
    local nStrikeDelay = CallDown:GetSpecialValueInt('strike_delay')
    local nDamage = CallDown:GetSpecialValueInt('damage')
    local nManaCost = CallDown:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

    if not J.IsLateGame() then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not J.IsChasingTarget(bot, enemyHero)
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
            local count = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            if J.IsChasingTarget(bot, botTarget) then
                local vLocation = J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), GetUnitToUnitDistance(bot, botTarget) + 350)
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > 0.3
        and not J.IsLateGame()
        and #nEnemyHeroes == 0
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > 0.3
        and not J.IsLateGame()
        and #nEnemyHeroes == 0
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X