local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_windrunner'
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
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,1,6,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_double_null_talisman",
                "item_power_treads",
                "item_maelstrom",
                "item_black_king_bar",--
                "item_lesser_crit",
                "item_mjollnir",--
                "item_greater_crit",--
                "item_aghanims_shard",
                "item_satanic",--
                "item_bloodthorn",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_lesser_crit",
                "item_magic_wand", "item_greater_crit",
                "item_null_talisman", "item_satanic",
                "item_null_talisman", "item_bloodthorn",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,1,6,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_circlet",
            
                "item_bottle",
                "item_magic_wand",
                "item_double_null_talisman",
                "item_power_treads",
                "item_maelstrom",
                "item_black_king_bar",--
                "item_lesser_crit",
                "item_mjollnir",--
                "item_greater_crit",--
                "item_aghanims_shard",
                "item_satanic",--
                "item_bloodthorn",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_satanic",
                "item_null_talisman", "item_bloodthorn",
                "item_bottle", "item_bloodthorn",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_double_bracer",
                "item_power_treads",
                "item_maelstrom",
                "item_black_king_bar",--
                "item_orchid",
                "item_aghanims_shard",
                "item_nullifier",--
                "item_ultimate_scepter",
                "item_mjollnir",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_bloodthorn",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_orchid",
                "item_bracer", "item_nullifier",
                "item_bracer", "item_sheepstick",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {3,1,1,2,2,6,2,2,1,1,3,3,3,6,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_ancient_janggo",
                "item_orchid",
                "item_aghanims_shard",
                "item_force_staff",
                "item_boots_of_bearing",--
                "item_sphere",--
                "item_sheepstick",--
                "item_bloodthorn",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {3,1,1,2,2,6,2,2,1,1,3,3,3,6,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_mekansm",
                "item_orchid",
                "item_aghanims_shard",
                "item_force_staff",
                "item_guardian_greaves",--
                "item_sphere",--
                "item_sheepstick",--
                "item_bloodthorn",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
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

local ShackleShot   = bot:GetAbilityByName('windrunner_shackleshot')
local Powershot     = bot:GetAbilityByName('windrunner_powershot')
local Windrun       = bot:GetAbilityByName('windrunner_windrun')
local GaleForce     = bot:GetAbilityByName('windrunner_gale_force')
local FocusFire     = bot:GetAbilityByName('windrunner_focusfire')

local ShackleShotDesire, ShackleShotTarget
local PowershotDesire, PowershotLocation
local WindrunDesire
local GaleForceDesire, GaleForceLocation
local FocusFireDesire, FocusFireTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    ShackleShot   = bot:GetAbilityByName('windrunner_shackleshot')
    Powershot     = bot:GetAbilityByName('windrunner_powershot')
    Windrun       = bot:GetAbilityByName('windrunner_windrun')
    GaleForce     = bot:GetAbilityByName('windrunner_gale_force')
    FocusFire     = bot:GetAbilityByName('windrunner_focusfire')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    ShackleShotDesire, ShackleShotTarget = X.ConsiderShackleShot()
    if ShackleShotDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ShackleShot, ShackleShotTarget)
        return
    end

    FocusFireDesire, FocusFireTarget = X.ConsiderFocusFire()
    if FocusFireDesire > 0 then
        bot:Action_UseAbilityOnEntity(FocusFire, FocusFireTarget)
        return
    end

    PowershotDesire, PowershotLocation = X.ConsiderPowershot()
    if PowershotDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Powershot, PowershotLocation)
        return
    end

    WindrunDesire = X.ConsiderWindrun()
    if WindrunDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Windrun)
        return
    end

    GaleForceDesire, GaleForceLocation = X.ConsiderGaleForce()
    if GaleForceDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(GaleForce, GaleForceLocation)
        return
    end
end

function X.ConsiderShackleShot()
    if not J.CanCastAbility(ShackleShot)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, ShackleShot:GetCastRange())
    local nRadius = ShackleShot:GetSpecialValueInt('shackle_distance')
    local nAngle = ShackleShot:GetSpecialValueInt('shackle_angle')
    local nStunDuration = ShackleShot:GetSpecialValueFloat('stun_duration')
    local nManaCost = ShackleShot:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Powershot, Windrun, GaleForce, FocusFire})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and enemyHero:IsChanneling()
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemy in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.CanCastOnTargetAdvanced(enemy)
            and not J.IsDisabled(enemy)
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local enemyAttackDamge = enemy:GetAttackDamage() * enemy:GetAttackSpeed()
                local target = X.GetShackleTarget(bot, enemy, nRadius, nAngle)

                if enemyAttackDamge > hTargetDamage and target then
                    if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemy, 5.0) > enemy:GetHealth() then
                        hTarget = enemy
                        hTargetDamage = enemyAttackDamge
                    end
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
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
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                local target = X.GetShackleTarget(bot, enemyHero, nRadius, nAngle)
                if target ~= nil then
                    return BOT_ACTION_DESIRE_HIGH, target
                end
            end
        end
	end

    if fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not allyHero:IsIllusion()
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsInRange(allyHero, enemyHero, 800)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        local target = X.GetShackleTarget(bot, enemyHero, nRadius, nAngle)
                        if target ~= nil then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPowershot()
    if not J.CanCastAbility(Powershot) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local botAttackRange = bot:GetAttackRange()
	local nCastRange = Powershot:GetCastRange()
    local nCastPoint = Powershot:GetCastPoint()
	local nRadius = Powershot:GetSpecialValueInt('arrow_width')
	local nSpeed = Powershot:GetSpecialValueInt('arrow_speed')
    local nDamage = Powershot:GetSpecialValueInt('powershot_damage')
    local nManaCost = Powershot:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShackleShot, Windrun, GaleForce, FocusFire})

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 600) then
			return BOT_ACTION_DESIRE_NONE
		end
	end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsInRange(bot, enemyHero, botAttackRange - 100)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, botAttackRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and fManaAfter > fManaThreshold1
        then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 700)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and creep:GetHealth() > bot:GetAttackDamage()
            and not J.IsRunning(creep)
            and not J.IsOtherAllysTarget(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage ,DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'ranged') then
                        if J.IsEnemyTargetUnit(creep, 1200) then
                            return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                        end
                    end

                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
			end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderWindrun()
    if not J.CanCastAbility(Windrun)
    or bot:HasModifier('modifier_windrunner_windrun')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nDuration = Windrun:GetSpecialValueInt('duration')
    local nManaCost = Windrun:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShackleShot, Powershot, GaleForce, FocusFire})

    local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    if bot:HasModifier('modifier_windrunner_focusfire') and bot:WasRecentlyDamagedByAnyHero(1.0) then
        return BOT_ACTION_DESIRE_HIGH
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
		then
            if  J.IsChasingTarget(bot, botTarget)
            and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
            and botTarget:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed() + 10
            and #nEnemyHeroesTargetingMe == 0
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            if bot:WasRecentlyDamagedByAnyHero(2.0) and #nEnemyHeroesTargetingMe > 0 then
                if (botHP < 0.4)
                or (J.GetTotalEstimatedDamageToTarget(nEnemyHeroesTargetingMe, bot, nDuration + 1) > bot:GetHealth())
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroesTargetingMe > 0 then
        if bot:WasRecentlyDamagedByAnyHero(2.0) and botHP < 0.75 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
        if bot:WasRecentlyDamagedByCreep(2.0) and botHP < 0.2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if bot:WasRecentlyDamagedByAnyHero(2.0) and botHP < 0.4 and fManaAfter > fManaThreshold1 + 0.15 and J.IsRunning(bot) then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and bAttacking
        and botTarget:GetAttackTarget() == bot
        then
            if botHP < 0.5 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        then
            if botHP < 0.5 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderGaleForce()
    if not J.CanCastAbility(GaleForce) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, GaleForce:GetCastRange())
    local nCastPoint = GaleForce:GetCastPoint()
    local nRadius = GaleForce:GetSpecialValueInt('radius')

    if J.IsGoingOnSomeone(bot) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_teleporting')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsChasingTarget(enemyHero, bot)
                and not J.IsDisabled(enemyHero)
                then
                    if (bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
                    or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes)
                    then
                        return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFocusFire()
    if not J.CanCastAbility(FocusFire) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = bot:GetAttackRange()
	local nDamageReduction = 1 + (FocusFire:GetSpecialValueInt('focusfire_damage_reduction') / 100)
    local nDuration = FocusFire:GetDuration()
	local nDamage = bot:GetAttackDamage()
    local nLevel = FocusFire:GetLevel()

	if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetScore = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidTarget(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange - 150)
            and not J.IsInEtherealForm(enemyHero)
            and enemyHero:GetHealth() > nDamage * 3
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
            and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
            then
                local enemyHeroScore = enemyHero:GetActualIncomingDamage((nDamage * nDuration) * nDamageReduction, DAMAGE_TYPE_PHYSICAL) / enemyHero:GetHealth()
                if enemyHeroScore > hTargetScore then
                    hTarget = enemyHero
                    hTargetScore = enemyHeroScore
                end
            end
        end

        if hTarget then
            bot:SetTarget(hTarget)
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.25
        and bAttacking
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        and #nEnemyHeroes == 0
        then
            if nLevel >= 3 or J.IsEarlyGame() then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.3
        and bAttacking
        and #nEnemyHeroes == 0
        then
            if nLevel >= 3 or J.IsEarlyGame() then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.GetShackleCreepTarget(hSource, hTarget, nRadius, nMaxAngle)
	local nEnemyCreeps = hTarget:GetNearbyCreeps(nRadius, false)
	for _, creep in pairs(nEnemyCreeps) do
        if J.IsValid(creep) and creep ~= hTarget then
            local angle = X.GetAngleWithThreeVectors(hSource:GetLocation(), creep:GetLocation(), hTarget:GetLocation())

            if angle <= nMaxAngle then
                return creep
            end
        end
	end

	return nil
end

function X.GetShackleHeroTarget(hSource, hTarget, nRadius, nMaxAngle)
	local nInRangeEnemy = hTarget:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
	for _, enemyHero in pairs(nInRangeEnemy) do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero ~= hTarget
        then
            local angle = X.GetAngleWithThreeVectors(hSource:GetLocation(), enemyHero:GetLocation(), hTarget:GetLocation())

            if angle <= nMaxAngle then
                return enemyHero
            end
        end
	end

	return nil
end

function X.CanShackleToCreep(hSource, hTarget, nRadius, nMaxAngle)
	local nEnemyCreeps = hTarget:GetNearbyCreeps(nRadius, false)
	for _, creep in pairs(nEnemyCreeps) do
        if J.IsValid(creep) and creep ~= hTarget then
            local angle = X.GetAngleWithThreeVectors(hSource:GetLocation(), hTarget:GetLocation(), creep:GetLocation())
            if angle <= nMaxAngle then
                return true
            end
        end
	end

	return false
end

function X.CanShackleToHero(hSource, hTarget, nRadius, nMaxAngle)
	local nInRangeEnemy = J.GetEnemiesNearLoc(hTarget:GetLocation(), nRadius)

    -- real
	for _, enemyHero in pairs(nInRangeEnemy) do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero ~= hTarget
        then
            local angle = X.GetAngleWithThreeVectors(hSource:GetLocation(), hTarget:GetLocation(), enemyHero:GetLocation())
            if angle <= nMaxAngle then
                return true
            end
        end
	end

    -- include illusions
    nInRangeEnemy = hTarget:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
    for _, enemyHero in pairs(nInRangeEnemy) do
        if J.IsValidHero(enemyHero)
        and enemyHero ~= hTarget
        then
            local angle = X.GetAngleWithThreeVectors(hSource:GetLocation(), hTarget:GetLocation(), enemyHero:GetLocation())
            if angle <= nMaxAngle then
                return true
            end
        end
	end

	return false
end

function X.CanShackleToTree(hSource, hTarget, nRadius, nMaxAngle)
	local nTrees = hTarget:GetNearbyTrees(nRadius)
	for _, tree in pairs(nTrees) do
        if tree then
            local angle = X.GetAngleWithThreeVectors(hSource:GetLocation(), hTarget:GetLocation(), GetTreeLocation(tree))
            if angle <= nMaxAngle then
                return true
            end
        end
	end

	return false
end

function X.GetShackleTarget(hSource, hTarget, nRadius, nMaxAngle)
	local sTarget = nil

    if X.CanShackleToHero(hSource, hTarget, nRadius, nMaxAngle)
    or X.CanShackleToTree(hSource, hTarget, nRadius, nMaxAngle)
    or X.CanShackleToCreep(hSource, hTarget, nRadius, nMaxAngle)
    then
        sTarget = hTarget
    else
        sTarget = X.GetShackleCreepTarget(hSource, hTarget, nRadius, nMaxAngle)

		if sTarget == nil then
			sTarget = X.GetShackleHeroTarget(hSource, hTarget, nRadius, nMaxAngle)
		end
    end

	return sTarget
end

function X.GetAngleWithThreeVectors(A, B, C)
    local CA = Vector(C.x - A.x, C.y - A.y, C.z - A.z)
    local CB = Vector(C.x - B.x, C.y - B.y, C.z - B.z)

    local magCA = math.sqrt(CA.x^2 + CA.y^2 + CA.z^2)
    local magCB = math.sqrt(CB.x^2 + CB.y^2 + CB.z^2)

    local dot = CA.x * CB.x + CA.y * CB.y + CA.z * CB.z

    return (math.acos(dot / (magCA * magCB))) * (180 / math.pi)
end

return X