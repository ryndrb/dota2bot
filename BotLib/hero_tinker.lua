local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_tinker'
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
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_circlet",
            
                "item_bottle",
                "item_magic_wand",
                "item_double_null_talisman",
                "item_soul_ring",
                "item_kaya",
                "item_blink",
                "item_kaya_and_sange",--
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_shivas_guard",--
                "item_arcane_blink",--
                "item_aghanims_shard",
                "item_dagon_5",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_wind_waker",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_blink",
                "item_null_talisman", "item_ultimate_scepter",
                "item_null_talisman", "item_black_king_bar",
                "item_bottle", "item_shivas_guard",
                "item_soul_ring", "item_dagon_5",
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
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
                "item_blood_grenade",
                "item_faerie_fire",

                "item_magic_wand",
                "item_tranquil_boots",
                "item_double_null_talisman",
                "item_glimmer_cape",--
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_dagon_5",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_solar_crest",
                "item_null_talisman", "item_ultimate_scepter",
                "item_null_talisman", "item_black_king_bar",
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
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
                "item_blood_grenade",
                "item_faerie_fire",

                "item_magic_wand",
                "item_arcane_boots",
                "item_double_null_talisman",
                "item_glimmer_cape",--
                "item_mekansm",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_dagon_5",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_solar_crest",
                "item_null_talisman", "item_ultimate_scepter",
                "item_null_talisman", "item_black_king_bar",
            },
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

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local Laser                 = bot:GetAbilityByName('tinker_laser')
-- local HeatSeekingMissile    = bot:GetAbilityByName('tinker_heat_seeking_missile')
local MarchOfTheMachines    = bot:GetAbilityByName('tinker_march_of_the_machines')
local DefenseMatrix         = bot:GetAbilityByName('tinker_defense_matrix')
local WarpFlare             = bot:GetAbilityByName('tinker_warp_grenade')
local KeenConveyance        = bot:GetAbilityByName('tinker_keen_teleport')
local Rearm                 = bot:GetAbilityByName('tinker_rearm')

local LaserDesire, LaserTarget
-- local HeatSeekingMissileDesire
local MarchOfTheMachinesDesire, MarchOfTheMachinesLocation
local DefenseMatrixDesire, DefenseMatrixTarget
local WarpFlareDesire, WarpFlareTarget
local KeenConveyanceDesire, KeenConveyanceTargetLocation
local RearmDesire

local keenConveyance = { cast_time = 0, use = false }
local fMarchOfTheMachinesCastTime = 0

local bAttacking = false
local botTarget, botHP, botMP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    botMP = J.GetMP(bot)

    if botMP > 0.8
    or bot:HasModifier('modifier_fountain_invulnerability')
    then
        keenConveyance.use = false
    end

    Laser                 = bot:GetAbilityByName('tinker_laser')
    MarchOfTheMachines    = bot:GetAbilityByName('tinker_march_of_the_machines')
    DefenseMatrix         = bot:GetAbilityByName('tinker_defense_matrix')
    WarpFlare             = bot:GetAbilityByName('tinker_warp_grenade')
    KeenConveyance        = bot:GetAbilityByName('tinker_keen_teleport')
    Rearm                 = bot:GetAbilityByName('tinker_rearm')

    if J.CanNotUseAbility(bot)
    or Rearm ~= nil and Rearm:IsInAbilityPhase()
    or KeenConveyance ~= nil and KeenConveyance:IsInAbilityPhase()
    or bot:HasModifier('modifier_tinker_rearm')
    or bot:HasModifier('modifier_teleporting')
    then
        return
    end

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if  not J.IsGoingOnSomeone(bot)
    and not J.IsDoingRoshan(bot)
    and not J.IsDoingTormentor(bot)
    and not bot:HasModifier('modifier_fountain_aura_buff')
    then
        if not keenConveyance.use then
            if J.IsInLaningPhase() then
                if (Rearm and Rearm:IsTrained() and Rearm:GetManaCost() > bot:GetMana())
                or botHP < 0.3
                then
                    keenConveyance.use = true
                end
            else
                if (botMP < 0.3)
                or (botHP < 0.35 and botMP < 0.5)
                then
                    keenConveyance.use = true
                end
            end
        end
    end

    DefenseMatrixDesire, DefenseMatrixTarget = X.ConsiderDefenseMatrix()
    if DefenseMatrixDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DefenseMatrix, DefenseMatrixTarget)
        return
    end

    LaserDesire, LaserTarget = X.ConsiderLaser()
    if LaserDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Laser, LaserTarget)
        return
    end

    MarchOfTheMachinesDesire, MarchOfTheMachinesLocation = X.ConsiderMarchOfTheMachines()
    if MarchOfTheMachinesDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(MarchOfTheMachines, MarchOfTheMachinesLocation)
        fMarchOfTheMachinesCastTime = DotaTime()
        return
    end

    WarpFlareDesire, WarpFlareTarget = X.ConsiderWarpFlare()
    if WarpFlareDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(WarpFlare, WarpFlareTarget)
        return
    end

    KeenConveyanceDesire, KeenConveyanceTargetLocation, sTargetType = X.ConsiderKeenConveyance()
    if KeenConveyanceDesire > 0 then
        J.SetQueuePtToINT(bot, false)

        if sTargetType == 'unit' then
            bot:ActionQueue_UseAbilityOnEntity(KeenConveyance, KeenConveyanceTargetLocation)
        else
            bot:ActionQueue_UseAbilityOnLocation(KeenConveyance, KeenConveyanceTargetLocation)
        end

        keenConveyance.cast_time = DotaTime()
        return
    end

    RearmDesire = X.ConsiderRearm()
    if RearmDesire > 0 then
        bot:Action_ClearActions(true)
        bot:Action_UseAbility(Rearm)
        return
    end
end

function X.ConsiderLaser()
    if not J.CanCastAbility(Laser) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Laser:GetCastRange())
    local nCastPoint = Laser:GetCastPoint()
    local nDamage = Laser:GetSpecialValueInt('laser_damage')
    local nRadius = Max(Laser:GetSpecialValueInt('radius_explosion'), 1)
    local nManaCost = Laser:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {MarchOfTheMachines, DefenseMatrix, WarpFlare, KeenConveyance, Rearm})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Laser, MarchOfTheMachines, DefenseMatrix, WarpFlare, KeenConveyance, Rearm})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE, nCastPoint)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetDamage = 0

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsMeepoClone(enemyHero)
            then
                local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
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

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 4.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep)) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep)) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep)) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsLaning(bot) and fManaAfter > fManaThreshold1 and J.IsInLaningPhase() then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.IsInRange(bot, creep, nCastRange + 150)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
            and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
                local sCreepName = creep:GetUnitName()
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                if string.find(sCreepName, 'ranged') then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 and #nEnemyHeroes > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep
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
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

-- function X.ConsiderHeatSeekingMissile()
--     if not HeatSeekingMissile:IsFullyCastable()
--     then
--         return BOT_ACTION_DESIRE_NONE
--     end

--     local nRadius = HeatSeekingMissile:GetSpecialValueInt('radius')
-- 	local nDamage = HeatSeekingMissile:GetSpecialValueInt('damage')

--     local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
--     for _, enemyHero in pairs(nEnemyHeroes)
--     do
--         if  J.IsValidHero(enemyHero)
--         and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
--         and not J.IsSuspiciousIllusion(enemyHero)
--         and not enemyHero:IsMagicImmune()
--         and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
--         and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
--         and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--         and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
--         and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
--         then
--             return BOT_ACTION_DESIRE_HIGH
--         end
--     end

-- 	if  J.IsGoingOnSomeone(bot)
--     and (not CanDoCombo1()
--         and not CanDoCombo2()
--         and not CanDoCombo3()
--         and not CanDoCombo4()
--         and not CanDoCombo5())
-- 	then
-- 		if  J.IsValidTarget(botTarget)
--         and J.IsInRange(bot, botTarget, nRadius)
-- 		then
--             local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
--             local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

--             if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--             and #nInRangeAlly >= #nInRangeEnemy
--             then
--                 if #nInRangeEnemy == 0
--                 then
--                     if  not botTarget:IsMagicImmune()
--                     and not J.IsSuspiciousIllusion(botTarget)
--                     and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
--                     and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
--                     and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--                     and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
--                     then
--                         return BOT_ACTION_DESIRE_HIGH
--                     end
--                 else
--                     return BOT_ACTION_DESIRE_HIGH
--                 end
--             end
-- 		end
-- 	end

-- 	if J.IsRetreating(bot)
-- 	then
--         local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
--         for _, enemyHero in pairs(nInRangeEnemy)
--         do
--             if  J.IsValidHero(enemyHero)
--             and J.IsChasingTarget(enemyHero, bot)
--             and not enemyHero:IsMagicImmune()
--             and not J.IsSuspiciousIllusion(enemyHero)
--             then
--                 local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                 local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                 and ((#nTargetInRangeAlly > #nInRangeAlly)
--                     or bot:WasRecentlyDamagedByAnyHero(1.5))
--                 then
--                     return BOT_ACTION_DESIRE_HIGH
--                 end
--             end
--         end
-- 	end

--     if J.IsPushing(bot) or J.IsDefending(bot)
--     then
--         local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
--         if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
--         then
--             return BOT_ACTION_DESIRE_HIGH
--         end
--     end

--     if J.IsLaning(bot)
--     then
--         local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
--         if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
--         and J.IsInLaningPhase(bot)
--         then
--             local nAllyTowers = bot:GetNearbyTowers(1600, false)
--             if  nAllyTowers ~= nil and #nAllyTowers >= 1
--             and J.IsValidBuilding(nAllyTowers[1])
--             and J.IsValidHero(nInRangeEnemy[1])
--             and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
--             and J.GetManaAfter(HeatSeekingMissile:GetManaCost()) > 0.4
--             and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
--             and not nInRangeEnemy[1]:IsMagicImmune()
--             and not nInRangeEnemy[1]:HasModifier('modifier_abaddon_borrowed_time')
--             and not nInRangeEnemy[1]:HasModifier('modifier_dazzle_shallow_grave')
--             and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not nInRangeEnemy[1]:HasModifier('modifier_templar_assassin_refraction_absorb')
--             and not nInRangeEnemy[1]:HasModifier('modifier_item_blade_mail_reflect')
--             and not nInRangeEnemy[1]:HasModifier('modifier_item_sphere_target')
--             and GetUnitToUnitDistance(nInRangeEnemy[1], nAllyTowers[1]) < 680
--             and nAllyTowers[1]:GetAttackTarget() == nInRangeEnemy[1]
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
--             end
--         end
--     end

--     return BOT_ACTION_DESIRE_NONE
-- end

function X.ConsiderMarchOfTheMachines()
    if not J.CanCastAbility(MarchOfTheMachines) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, MarchOfTheMachines:GetCastRange())
    local nCastPoint = MarchOfTheMachines:GetCastPoint()
    local nRadius = MarchOfTheMachines:GetSpecialValueInt('radius')
    local nDuration = MarchOfTheMachines:GetSpecialValueFloat('duration')
    local nDamage = MarchOfTheMachines:GetSpecialValueInt('damage')
    local nManaCost = MarchOfTheMachines:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Laser, DefenseMatrix, WarpFlare, KeenConveyance, Rearm})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Laser, MarchOfTheMachines, DefenseMatrix, WarpFlare, KeenConveyance, Rearm})

	if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), 10)
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nRadius + 300, 1600), true)

    if DotaTime() > fMarchOfTheMachinesCastTime + nDuration / 2 then
        if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3)
                    or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, 10)
                    end
                end
            end
        end

        if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3)
                    or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, 10)
                    end
                end
            end

            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius, nRadius, 0, 0)
            if nLocationAoE.count >= 3 and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) > nRadius / 2 then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, 10)
            end
        end

        if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3)
                    or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                    or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, 10)
                    end
                end
            end
        end

        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and bAttacking
            and fManaAfter > fManaThreshold2
            then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), 10)
            end
        end

        if J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and bAttacking
            and fManaAfter > fManaThreshold2
            then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), 10)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDefenseMatrix()
    if not J.CanCastAbility(DefenseMatrix) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DefenseMatrix:GetCastRange())
    local nManaCost = DefenseMatrix:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Laser, MarchOfTheMachines, WarpFlare, KeenConveyance, Rearm})

	if J.IsGoingOnSomeone(bot) then
        if not bot:HasModifier('modifier_tinker_defense_matrix')
        and not bot:HasModifier('modifier_item_nullifier_mute')
        and bot:WasRecentlyDamagedByAnyHero(4.0)
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if bot:WasRecentlyDamagedByAnyHero(2.0)
        and not bot:HasModifier('modifier_tinker_defense_matrix')
        and not bot:HasModifier('modifier_item_nullifier_mute')
        and (J.IsRunning(bot) or bot:IsRooted())
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange + 200)
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_tinker_defense_matrix')
        and not allyHero:HasModifier('modifier_item_nullifier_mute')
        then
            local allyHP = J.GetHP(allyHero)

            if J.IsDisabled(allyHero)
            or allyHero:HasModifier('modifier_legion_commander_duel')
            or (allyHero:WasRecentlyDamagedByCreep(2.0) and allyHP < 0.2)
            or (allyHero:WasRecentlyDamagedByTower(2.0) and allyHP < 0.2)
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if  not allyHero:HasModifier('modifier_abaddon_aphotic_shield')
            and not allyHero:HasModifier('modifier_item_solar_crest_armor_addition')
            then
                local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)

                if J.IsGoingOnSomeone(allyHero) then
                    if allyHero:WasRecentlyDamagedByAnyHero(3.0) and allyHP < 0.75 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end

                if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                    if bot:WasRecentlyDamagedByAnyHero(2.0) and J.IsRunning(allyHero) and #nEnemyHeroesTargetingAlly > 0 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end

                if fManaAfter > fManaThreshold1 then
                    if (J.IsPushing(bot) and (bot:WasRecentlyDamagedByAnyHero(5.0) or botHP < 0.5))
                    or (J.IsDefending(bot) and #nEnemyHeroes > 0)
                    or (allyHero:WasRecentlyDamagedByAnyHero(3.0) and allyHP < 0.75)
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end

            if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
                if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
                and J.IsInRange(bot, botTarget, 1200)
                and bAttacking
                then
                    if allyHP < 0.4 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWarpFlare()
    if not J.CanCastAbility(WarpFlare) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, WarpFlare:GetCastRange())

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or enemyHero:HasModifier('modifier_legion_commander_duel')
            or enemyHero:IsChanneling()
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderKeenConveyance()
    if not J.CanCastAbility(KeenConveyance)
    or (keenConveyance.use and bot:HasModifier('modifier_fountain_aura_buff'))
    then
        return BOT_ACTION_DESIRE_NONE, nil, ''
    end

    local nAbilityLevel = KeenConveyance:GetLevel()
    local nChannelTime = KeenConveyance:GetSpecialValueInt('channel_time_tooltip')
    local botMovementSpeed = bot:GetCurrentMovementSpeed()
    local nManaCost = KeenConveyance:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Laser, MarchOfTheMachines, DefenseMatrix, WarpFlare, Rearm})

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 800) then
            return BOT_ACTION_DESIRE_NONE, 0, ''
        end
    end

    if (J.IsInTeamFight(bot, 1200) and not J.IsRetreating(bot))
    or (bot:GetHealth() < J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, nChannelTime + 1))
    then
        return BOT_ACTION_DESIRE_NONE, 0, ''
    end

    if  keenConveyance.use
    and GetUnitToLocationDistance(bot, J.GetTeamFountain()) > 3200
    then
        return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain(), 'loc'
    end

    local vTeamFightLocation = J.GetTeamFightLocation(bot)
    if  vTeamFightLocation
    and fManaAfter > fManaThreshold1
    and not J.IsRetreating(bot)
    and not J.IsInLaningPhase()
    and not bot:WasRecentlyDamagedByAnyHero(4.0)
    then
        local nInRangeAlly = J.GetAlliesNearLoc(vTeamFightLocation, 1200)

        if (GetUnitToLocationDistance(bot, vTeamFightLocation) / botMovementSpeed) > nChannelTime + 1 then
            if nAbilityLevel <= 2 then
                local vLocationTP = J.GetNearbyLocationToTp(vTeamFightLocation)
                if J.GetDistance(vTeamFightLocation, vLocationTP) < 1600 then
                    return BOT_ACTION_DESIRE_HIGH, vLocationTP, 'loc'
                end
            else
                for _, allyHero in pairs(nInRangeAlly) do
                    if J.IsValidHero(allyHero) and allyHero ~= bot then
                        return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit'
                    end
                end
            end
        end
    end

    if DotaTime() < keenConveyance.cast_time + 7.0 then
        return BOT_ACTION_DESIRE_NONE, 0, ''
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() then
        local vLocationTP, bShouldTP = X.GetLaningTPLocation(botMovementSpeed * nChannelTime * 2, bot:GetLocation())
        if bShouldTP then
            return BOT_ACTION_DESIRE_HIGH, vLocationTP, 'loc'
        end
    end

    if J.IsDoingRoshan(bot) and nAbilityLevel >= 3 then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        local nInRangeAlly = J.GetAlliesNearLoc(vRoshanLocation, 1600)
        if GetUnitToLocationDistance(bot, vRoshanLocation) > 3200 then
            return BOT_ACTION_DESIRE_HIGH, nInRangeAlly[1], 'unit'
        end
    end

    if J.IsDoingTormentor(bot) and nAbilityLevel >= 3 then
        local vTormentorLocation = J.GetTormentorLocation(GetTeam())
        local nInRangeAlly = J.GetAlliesNearLoc(vTormentorLocation, 1600)
        if GetUnitToLocationDistance(bot, vTormentorLocation) > 3200 then
            return BOT_ACTION_DESIRE_HIGH, nInRangeAlly[1], 'unit'
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

function X.ConsiderRearm()
    if not J.CanCastAbility(Rearm) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nChannelTime = Rearm:GetSpecialValueFloat('AbilityChannelTime')
    local nManaCost = Rearm:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Laser, MarchOfTheMachines, DefenseMatrix, WarpFlare, KeenConveyance})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {KeenConveyance})

    local trainedQ  = X.IsTrained(Laser)
    local trainedW  = X.IsTrained(MarchOfTheMachines)
    local trainedE  = X.IsTrained(DefenseMatrix)
    local trainedTP = X.IsTrained(KeenConveyance)

    if J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, nChannelTime + 2) > bot:GetHealth() then
        return BOT_ACTION_DESIRE_NONE
    end

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 800) then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
    if (keenConveyance.use and fManaAfter > fManaThreshold2 and #nInRangeEnemy == 0)
    or (bot:HasModifier('modifier_fountain_aura_buff'))
    then
        if not J.CanCastAbilitySoon(KeenConveyance, nChannelTime + 1) and trainedTP then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    local vTeamFightLocation = J.GetTeamFightLocation(bot)
    if vTeamFightLocation and fManaAfter > 0.75 and not J.IsInLaningPhase() then
        if not J.CanCastAbilitySoon(KeenConveyance, nChannelTime * 2) and trainedTP then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)

    if  not J.CanCastAbilitySoon(Laser, nChannelTime) and trainedQ
    and not J.CanCastAbilitySoon(MarchOfTheMachines, nChannelTime) and trainedW
    then
        if fManaAfter > fManaThreshold1 then
            if (#nEnemyHeroes > 0)
            or (J.IsPushing(bot) and #nEnemyCreeps > 0)
            or (J.IsDefending(bot) and #nEnemyCreeps > 0)
            or (J.IsFarming(bot) and #nEnemyCreeps > 0)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if fManaAfter > 0.8 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if fManaAfter > fManaThreshold1 then
            if not J.CanCastAbilitySoon(DefenseMatrix, nChannelTime) and trainedE then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            if  not J.CanCastAbilitySoon(Laser, nChannelTime) and trainedQ
            and not J.CanCastAbilitySoon(DefenseMatrix, nChannelTime) and trainedE
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            if  not J.CanCastAbilitySoon(Laser, nChannelTime) and trainedQ
            and not J.CanCastAbilitySoon(DefenseMatrix, nChannelTime) and trainedE
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.GetLaningTPLocation(nMinTPDistance, botLocation)
	local nLane = bot:GetAssignedLane()
	local bShouldTP = false

	local tAmountAlongLane = GetAmountAlongLane(nLane, botLocation)
	local fLaneFrontAmount = GetLaneFrontAmount(GetTeam(), nLane, false)
	if tAmountAlongLane.distance > nMinTPDistance
	or tAmountAlongLane.amount < fLaneFrontAmount / 5
	then
		bShouldTP = true
	end

	return GetLaneFrontLocation(GetTeam(), nLane, -650), bShouldTP
end

function X.IsTrained(hAbility)
    return hAbility and hAbility:IsTrained()
end

return X