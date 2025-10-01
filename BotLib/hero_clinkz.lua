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
                "item_double_circlet",
			
				"item_magic_wand",
				"item_power_treads",
                "item_falcon_blade",
				"item_desolator",--
				"item_orchid",
				"item_dragon_lance",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_bloodthorn",--
				"item_greater_crit",--
                "item_nullifier",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_desolator",
                "item_circlet", "item_orchid",
                "item_circlet", "item_dragon_lance",
				"item_magic_wand", "item_black_king_bar",
                "item_falcon_blade", "item_greater_crit",
                "item_power_treads", "item_nullifier",
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
				"item_quelling_blade",
                "item_double_circlet",
			
				"item_bottle",
				"item_magic_wand",
				"item_arcane_boots",
				"item_desolator",--
				"item_orchid",
				"item_dragon_lance",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_bloodthorn",--
				"item_sheepstick",--
                "item_disperser",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_desolator",
                "item_circlet", "item_orchid",
                "item_circlet", "item_dragon_lance",
				"item_magic_wand", "item_black_king_bar",
				"item_bottle", "item_sheepstick",
                "item_arcane_boots", "item_disperser",
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,3,3,6,1,2,2,1,6,1,1,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_tango",
				"item_blood_grenade",
				"item_blight_stone",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_orchid",
                "item_ancient_janggo",
                "item_rod_of_atos",
				"item_boots_of_bearing",--
				"item_force_staff",
				"item_aghanims_shard",
				"item_bloodthorn",--
				"item_sheepstick",--
                "item_gungir",--
                "item_nullifier",--
				"item_moon_shard",
				"item_hurricane_pike",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
                "item_blight_stone", "item_nullifier",
			},
        },
    },
    ['pos_5'] = {
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
                [1] = {2,3,2,3,3,6,1,2,2,1,6,1,1,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_tango",
				"item_blood_grenade",
				"item_blight_stone",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_orchid",
                "item_mekansm",
                "item_rod_of_atos",
				"item_guardian_greaves",--
				"item_force_staff",
				"item_aghanims_shard",
				"item_bloodthorn",--
				"item_sheepstick",--
                "item_gungir",--
                "item_nullifier",--
				"item_moon_shard",
				"item_hurricane_pike",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
                "item_blight_stone", "item_nullifier",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Strafe            = bot:GetAbilityByName('clinkz_strafe')
	TarBomb           = bot:GetAbilityByName('clinkz_tar_bomb')
	DeathPact         = bot:GetAbilityByName('clinkz_death_pact')
	BurningBarrage    = bot:GetAbilityByName('clinkz_burning_barrage')
	BurningArmy       = bot:GetAbilityByName('clinkz_burning_army')
	SkeletonWalk      = bot:GetAbilityByName('clinkz_wind_walk')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

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
    or bot:IsDisarmed()
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local nAttackRange = bot:GetAttackRange()
    local nManaCost = Strafe:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {TarBomb, BurningBarrage, SkeletonWalk})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost , {Strafe, TarBomb, BurningBarrage, SkeletonWalk})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost , {BurningBarrage})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold3
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(900, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) and bAttacking and fManaAfter > fManaThreshold2 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nEnemyCreeps >= 4 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nEnemyCreeps >= 4 then
            return BOT_ACTION_DESIRE_HIGH
        end

        local nInRangeEnemy = bot:GetNearbyHeroes(Min(nAttackRange, 1600), true, BOT_MODE_NONE)
        if #nInRangeEnemy >= 3 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTarBomb()
    if not J.CanCastAbility(TarBomb) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nCastRange = J.GetProperCastRange(false, bot, TarBomb:GetCastRange())
    local nCastPoint = TarBomb:GetCastPoint()
    local nDamage = TarBomb:GetSpecialValueInt('impact_damage')
    local nRadius = TarBomb:GetSpecialValueInt('radius')
    local nSpeed = TarBomb:GetSpecialValueInt('projectile_speed')
    local nManaCost = TarBomb:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {Strafe, BurningBarrage, SkeletonWalk})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost , {Strafe, TarBomb, BurningBarrage, SkeletonWalk})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost , {BurningBarrage})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidTarget(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold3
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
            if bAttacking
            or #nInRangeEnemy >= 2
            or (J.IsChasingTarget(bot, botTarget) and bot:GetCurrentMovementSpeed() < botTarget:GetCurrentMovementSpeed())
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                or (botHP < 0.5 and fManaAfter > fManaThreshold1)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and bAttacking then
        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if  J.IsValid(botTarget)
    and J.CanBeAttacked(botTarget)
    and J.IsInRange(bot, botTarget, nCastRange)
    and fManaAfter > fManaThreshold1
    and bAttacking
    and #nEnemyHeroes <= 1
    and (J.IsCore(bot) or not J.IsOtherAllysTarget(botTarget))
    and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
    and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL)
    then
        return BOT_ACTION_DESIRE_HIGH, botTarget
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > 0.2 then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.IsInRange(bot, creep, nCastRange)
            and J.CanCastOnNonMagicImmune(creep)
            and J.CanCastOnTargetAdvanced(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'ranged') then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end

                    local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)
                    if #nInRangeEnemy > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
			end
		end
    end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.2
        and fManaAfter > fManaThreshold1
        and bAttacking
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    local bIsCore = J.IsCore(bot)
    if (bIsCore and fManaAfter > fManaThreshold2) or not bIsCore then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    then
                        if J.IsChasingTarget(enemyHero, bot)
                        or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDeathPact()
    if not J.CanCastAbility(DeathPact) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DeathPact:GetCastRange())
    local nMaxLevel = DeathPact:GetSpecialValueInt('creep_level')
    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
    local bRooted = bot:IsRooted()
    local nManaCost = DeathPact:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {TarBomb, BurningBarrage, SkeletonWalk})

    if not bot:HasModifier('modifier_clinkz_death_pact') and fManaAfter > fManaThreshold1 then
        if J.IsInLaningPhase() then
            if J.IsLaning(bot) then
                local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

                local targetCreep = nil
                local targetCreepRange = 0
                for _, creep in pairs(nEnemyLaneCreeps) do
                    if  J.IsValid(creep)
                    and J.CanBeAttacked(creep)
                    and creep:GetLevel() <= nMaxLevel
                    then
                        local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 500)
                        local creepRange = creep:GetAttackRange()
                        if creepRange > targetCreepRange and #nInRangeEnemy <= 1 then
                            targetCreep = creep
                            targetCreepRange = creepRange
                        end
                    end
                end

                if targetCreep ~= nil then
                    if #nEnemyHeroes == 0 or bRooted then
                        return BOT_ACTION_DESIRE_HIGH, targetCreep
                    end
                end
            end
        else
            local creep = X.GetDeathPactCreep(nEnemyCreeps, nMaxLevel)
            if J.IsValid(creep) then
                return BOT_ACTION_DESIRE_HIGH, creep
            end
        end
    end

    if not bRooted and J.IsRetreating(bot) and not J.IsRealInvisible(bot) and J.CanBeAttacked(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 1000)
            and J.IsChasingTarget(enemy, bot)
            and not enemy:IsDisarmed()
            then
                local bIsIllusion = J.IsSuspiciousIllusion(enemy)
                if (bot:WasRecentlyDamagedByAnyHero(3.0) and not bIsIllusion)
                or (J.IsChasingTarget(enemy) and not bIsIllusion)
                or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
                then
                    local creep = X.GetBestRetreatDeathPatchCreep(nEnemyCreeps, J.GetTeamFountain(), 500, 60)
                    if J.IsValid(creep) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end

                    local vLocation = J.VectorAway(bot:GetLocation(), enemy:GetLocation(), nCastRange)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 600)
                    if #nInRangeEnemy == 0 then
                        creep = X.GetBestRetreatDeathPatchCreep(nEnemyCreeps, vLocation, nCastRange / 2, 45)
                        if J.IsValid(creep) then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

--Aghanim's Shard
function X.ConsiderBurningBarrage()
    if not J.CanCastAbility(BurningBarrage) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = BurningBarrage:GetSpecialValueInt('range')
    local nRadius = BurningBarrage:GetSpecialValueInt('projectile_width')
    local nManaCost = BurningBarrage:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {BurningBarrage, SkeletonWalk})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost , {SkeletonWalk})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange - 125)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold2
		then
            if not J.IsChasingTarget(bot, botTarget)
            or botTarget:IsStunned()
            or botTarget:IsHexed()
            or botTarget:IsRooted()
            or botTarget:IsNightmared()
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and bAttacking and #nAllyHeroes <= 3 and #nEnemyHeroes <= 1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and bAttacking and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

--Aghanim's Scepter
function X.ConsiderBurningArmy()
	if not J.CanCastAbility(BurningArmy) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BurningArmy:GetCastRange())
    local nSpawnRange = BurningArmy:GetSpecialValueInt('range')
    local nManaCost = BurningArmy:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {Strafe, BurningBarrage, SkeletonWalk})

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nSpawnRange, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nSpawnRange / 2)

		if #nInRangeEnemy >= 2 and not J.IsLocationInChrono(nLocationAoE.targetloc) and fManaAfter > fManaThreshold1 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

    if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + bot:GetAttackRange())
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if not J.IsInRange(bot, botTarget, nCastRange) then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
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

    local nManaCost = SkeletonWalk:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Strafe, TarBomb, BurningBarrage})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Strafe, TarBomb, BurningBarrage, SkeletonWalk})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and GetUnitToUnitDistance(bot, botTarget) > 1600
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if J.IsValidHero(nEnemyHeroes[1]) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) then
            if (bot:WasRecentlyDamagedByAnyHero(2.0) and J.IsChasingTarget(nEnemyHeroes[1], bot))
            or ((botHP < 0.5 or #nEnemyHeroes > #nAllyHeroes) and nEnemyHeroes[1]:GetAttackTarget() == bot)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsPushing(bot) and fManaAfter > fManaThreshold2 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 and not bAttacking then
            return BOT_ACTION_DESIRE_HIGH
		end

        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange() - 150)
        and botTarget:HasModifier('modifier_clinkz_tar_bomb_slow')
        and fManaAfter > 0.5
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot) and not bAttacking and fManaAfter > fManaThreshold2 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 then
            return BOT_ACTION_DESIRE_HIGH
		end
    end

    if J.IsFarming(bot) and not bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			if J.IsRunning(bot) and distance > bot:GetAttackRange() * 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

    if J.IsLaning(bot) and not J.IsInLaningPhase() and fManaAfter > 0.8 and #nEnemyHeroes == 0 then
        local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
        if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, vRoshanLocation) > 3200 and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        local vTormentorLocation = J.GetTormentorLocation(GetTeam())
        if GetUnitToLocationDistance(bot, vTormentorLocation) > 3200 and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.GetDeathPactCreep(hCreepList, nLevel)
	local hTarget = nil
	local hTargetHealth = 0
	for _, creep in pairs(hCreepList) do
        if  J.IsValid(creep)
        and not J.IsRoshan(creep)
        and not J.IsTormentor(creep)
        and J.CanBeAttacked(creep)
        and J.CanCastOnTargetAdvanced(creep)
        and not creep:IsAncientCreep()
        and not J.IsKeyWordUnit('flagbearer', creep)
        then
            local creepHealth = creep:GetHealth()
            local creepLevel = creep:GetLevel()
            local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 500)
            if creepHealth > hTargetHealth and creepLevel <= nLevel and #nInRangeEnemy <= 1 then
                hTarget = creep
                hTargetHealth = creepHealth
            end
        end
	end

	return hTarget
end

function X.GetBestRetreatDeathPatchCreep(nEnemyCreeps, vLocation, nMBotDistanceFromCreep, nConeAngle)
    local bestRetreatCreep = nil
	local bestRetreatCreepDist = 0

	local botLocation = bot:GetLocation()
    local targetDir = (vLocation - botLocation):Normalized()

    for i = #nEnemyCreeps, 1, -1 do
		if  J.IsValid(nEnemyCreeps[i])
        and J.CanBeAttacked(nEnemyCreeps[i])
        and J.CanCastOnTargetAdvanced(nEnemyCreeps[i])
        and not nEnemyCreeps[i]:IsAncientCreep()
        then
			local vCreepLocation = nEnemyCreeps[i]:GetLocation()
            local creeDir = (vCreepLocation - botLocation):Normalized()
            local dot = J.DotProduct(targetDir, creeDir)
            local nAngle = J.GetAngleFromDotProduct(dot)
            local nBotCreepDistance = GetUnitToUnitDistance(bot, nEnemyCreeps[i])

            if nAngle <= nConeAngle and nBotCreepDistance > nMBotDistanceFromCreep then
                local nBotTargetDistance = GetUnitToLocationDistance(bot, vLocation)
                local nCreepTargetDistance = GetUnitToLocationDistance(nEnemyCreeps[i], vLocation)
                if nCreepTargetDistance < nBotTargetDistance and nBotCreepDistance > bestRetreatCreepDist then
                    bestRetreatCreep = nEnemyCreeps[i]
                    bestRetreatCreepDist = nBotCreepDistance
                end
            end
		end
	end

	return bestRetreatCreep
end

return X