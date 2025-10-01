local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sRole   = J.Item.GetRoleItemsBuyList( bot )
local M = require( GetScriptDirectory()..'/FunLib/aba_modifiers' )

if GetBot():GetUnitName() == 'npc_dota_hero_hoodwink'
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
                [1] = {1,2,1,3,1,7,1,2,2,2,7,3,3,3,7},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_slippers",
                "item_circlet",
            
                "item_bottle",
                "item_magic_wand",
                "item_wraith_band",
                "item_power_treads",
                "item_maelstrom",
                "item_force_staff",
                "item_black_king_bar",--
                "item_lesser_crit",
                "item_aghanims_shard",
                "item_hurricane_pike",--
                "item_mjollnir",--
                "item_greater_crit",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_force_staff",
                "item_magic_wand", "item_black_king_bar",
                "item_wraith_band", "item_lesser_crit",
                "item_bottle", "item_bloodthorn",
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
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,7,1,2,2,2,7,3,3,3,7},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_blight_stone",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_rod_of_atos",
                "item_force_staff",
                "item_ancient_janggo",
                "item_gungir",--
                "item_aghanims_shard",
                "item_boots_of_bearing",--
                "item_sheepstick",--
                "item_greater_crit",--
                "item_octarine_core",--
                "item_moon_shard",
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_blight_stone", "item_greater_crit",
                "item_magic_wand", "item_octarine_core",
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
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,7,1,2,2,2,7,3,3,3,7},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_blight_stone",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_rod_of_atos",
                "item_force_staff",
                "item_mekansm",
                "item_gungir",--
                "item_aghanims_shard",
                "item_guardian_greaves",--
                "item_sheepstick",--
                "item_greater_crit",--
                "item_octarine_core",--
                "item_moon_shard",
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_blight_stone", "item_greater_crit",
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

local AcornShot         = bot:GetAbilityByName('hoodwink_acorn_shot')
local Bushwhack         = bot:GetAbilityByName('hoodwink_bushwhack')
local Scurry            = bot:GetAbilityByName('hoodwink_scurry')
local HuntersBoomerang  = bot:GetAbilityByName('hoodwink_hunters_boomerang')
local Decoy             = bot:GetAbilityByName('hoodwink_decoy')
local Sharpshooter      = bot:GetAbilityByName('hoodwink_sharpshooter')
local SharpshooterRelease = bot:GetAbilityByName('hoodwink_sharpshooter_release')

local AcornShotDesire, AcornShotTarget
local BushwhackDesire, BushwhackLocation
local ScurryDesire
local HuntersBoomerangDesire, HuntersBoomerangTarget
local DecoyDesire
local SharpshooterDesire, SharpshooterLocation
local SharpshooterReleaseDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

bot.hoodwink_sharpshooter = { cast_time = math.huge, target = nil, kill = false, engaging = false, break_ = false  }

function X.SkillsComplement()
    bot = GetBot()

	if  J.CanNotUseAbility(bot)
    and not bot:HasModifier('modifier_hoodwink_sharpshooter_windup')
    then
        return
    end

    AcornShot         = bot:GetAbilityByName('hoodwink_acorn_shot')
    Bushwhack         = bot:GetAbilityByName('hoodwink_bushwhack')
    Scurry            = bot:GetAbilityByName('hoodwink_scurry')
    HuntersBoomerang  = bot:GetAbilityByName('hoodwink_hunters_boomerang')
    Decoy             = bot:GetAbilityByName('hoodwink_decoy')
    Sharpshooter      = bot:GetAbilityByName('hoodwink_sharpshooter')
    SharpshooterRelease = bot:GetAbilityByName('hoodwink_sharpshooter_release')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if not bot:HasModifier('modifier_hoodwink_sharpshooter_windup') then
        bot.hoodwink_sharpshooter = { cast_time = math.huge, target = nil, kill = false, engaging = false, break_ = false  }
    end

    BushwhackDesire, BushwhackLocation, bShouldAcorn = X.ConsiderBushwhack()
    if BushwhackDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        if bShouldAcorn then
            bot:ActionQueue_UseAbilityOnLocation(AcornShot, BushwhackLocation)
            bot:ActionQueue_Delay(0.1)
            bot:ActionQueue_UseAbilityOnLocation(Bushwhack, BushwhackLocation)
            return
        else
            bot:ActionQueue_UseAbilityOnLocation(Bushwhack, BushwhackLocation)
            return
        end
    end

    AcornShotDesire, AcornShotTarget, bUnitTarget = X.ConsiderAcornShot()
    if AcornShotDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        if bUnitTarget then
            bot:ActionQueue_UseAbilityOnEntity(AcornShot, AcornShotTarget)
            return
        else
            bot:ActionQueue_UseAbilityOnLocation(AcornShot, AcornShotTarget)
            return
        end
    end

    SharpshooterReleaseDesire = X.ConsiderSharpshooterRelease()
    if SharpshooterReleaseDesire > 0 then
        bot:Action_UseAbility(SharpshooterRelease)
        return
    end

    SharpshooterDesire, SharpshooterLocation = X.ConsiderSharpshooter()
    if SharpshooterDesire > 0 then
        bot.hoodwink_sharpshooter.cast_time = DotaTime()
        bot:Action_UseAbilityOnLocation(Sharpshooter, SharpshooterLocation)
        return
    end

    ScurryDesire = X.ConsiderScurry()
    if ScurryDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Scurry)
        return
    end

    HuntersBoomerangDesire, HuntersBoomerangTarget = X.ConsiderHuntersBoomerang()
    if HuntersBoomerangDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HuntersBoomerang, HuntersBoomerangTarget)
        return
    end

    DecoyDesire = X.ConsiderDecoy()
    if DecoyDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Decoy)
        return
    end
end

function X.ConsiderAcornShot()
    if not J.CanCastAbility(AcornShot) then
        return BOT_ACTION_DESIRE_NONE, 0, true
    end

	local nCastRange = J.GetProperCastRange(false, bot, AcornShot:GetCastRange())
	local nCastPoint = AcornShot:GetCastPoint()
	local nRadius = AcornShot:GetSpecialValueInt('bounce_range')
    local nBounceCount = AcornShot:GetSpecialValueInt('bounce_count')
    local nBaseDamagePct = AcornShot:GetSpecialValueInt('base_damage_pct')
    local nDamage = AcornShot:GetSpecialValueInt('acorn_shot_damage') + (bot:GetAttackDamage() * (nBaseDamagePct / 100))
    local nSpeed = AcornShot:GetSpecialValueInt('projectile_speed')
    local nAbilityLevel = AcornShot:GetLevel()
    local nManaCost = AcornShot:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Bushwhack, Scurry, Sharpshooter})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {AcornShot, Bushwhack, Scurry, Sharpshooter})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Sharpshooter})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsInEtherealForm(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            local damage = nDamage
            local nTrees = enemyHero:GetNearbyTrees(nRadius)
            local nLocationAoE_heroes = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, nDelay, 0)
            local nLocationAoE_creeps = bot:FindAoELocation(true, false, enemyHero:GetLocation(), 0, nRadius, nDelay, 0)
            local bCanBounce = #nTrees > 0 or nLocationAoE_heroes.count > 0 or nLocationAoE_creeps.count > 0

            if bCanBounce then
                damage = nDamage * 2
            end

            if J.WillKillTarget(enemyHero, damage, DAMAGE_TYPE_PHYSICAL, nDelay) then
                if J.IsInRange(bot, enemyHero, nCastRange) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero, true
                else
                    local vLocation = J.GetCorrectLoc(enemyHero, nDelay)
                    local nDistance = GetUnitToLocationDistance(bot, vLocation)
                    if nDistance <= nCastRange + nRadius and nDistance > nCastRange then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetCorrectLoc(enemyHero, nDelay), nCastRange), false
                    end
                end
            end
		end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and bot ~= allyHero
        and J.IsRetreating(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsRealInvisible(bot)
        and not J.IsRetreating(bot)
        then
            for _, enemy in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemy)
                and J.CanBeAttacked(enemy)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and J.IsChasingTarget(enemy, allyHero)
                and not J.IsInEtherealForm(enemy)
                and not J.IsDisabled(enemy)
                and not enemy:IsDisarmed()
                then
                    local nDelay = (GetUnitToUnitDistance(bot, enemy) / nSpeed) + nCastPoint
                    local nLocationAoE = bot:FindAoELocation(true, true, enemy:GetLocation(), 0, nRadius, nDelay, 0)
                    if nLocationAoE.count >= 2 or enemy:IsChanneling() or enemy:IsUsingAbility() or enemy:IsCastingAbility() then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                    else
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), false
                    end
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
        and not J.IsInEtherealForm(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold3
		then
            local nTrees = botTarget:GetNearbyTrees(nRadius)
            if J.IsInRange(bot, botTarget, nCastRange) then
                if #nTrees > 0 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget, true
                else
                    local nLocationAoE_heroes = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
                    local nLocationAoE_creeps = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, nRadius, 0, 0)
                    if nLocationAoE_heroes.count >= 2 or nLocationAoE_creeps.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), false
                    end
                end
            end

            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local vLocation = J.GetCorrectLoc(botTarget, nDelay)
            local nDistance = GetUnitToLocationDistance(bot, vLocation)
            if J.IsChasingTarget(bot, botTarget) and nDistance <= nCastRange + nRadius and nDistance > nCastRange then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), vLocation, nCastRange), false
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsDisabled(enemy)
            and not enemy:IsDisarmed()
            then
                if J.IsChasingTarget(enemy, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
                then
                    local nTrees = enemy:GetNearbyTrees(nRadius)
                    if #nTrees > 0 then
                        return BOT_ACTION_DESIRE_HIGH, enemy, true
                    else
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), false
                    end
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes <= 1
    and nAbilityLevel >= 2
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
    then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) and #nEnemyHeroes <= 1 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if (nLocationAoE.count >= 4) then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1
    and nAbilityLevel >= 2
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
    then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not J.IsOtherAllysTarget(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase(bot) and fManaAfter > fManaThreshold1
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
    then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and string.find(creep:GetUnitName(), 'range')
            then
                local nDelay = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, nDelay)
                or J.IsUnitTargetedByTower(creep, false)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep, true
                end
            end
        end
    end

    if (J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)) then
        if (J.IsRoshan(botTarget) or J.IsTormentor(bot))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, true
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderBushwhack()
    if not J.CanCastAbility(Bushwhack) then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

	local nCastRange = J.GetProperCastRange(false, bot, Bushwhack:GetCastRange())
    local nCastPoint = Bushwhack:GetCastPoint()
    local nDamage = Bushwhack:GetSpecialValueInt('total_damage')
	local nRadius = Bushwhack:GetSpecialValueInt('trap_radius')
    local nSpeed = Bushwhack:GetSpecialValueInt('projectile_speed')
    local nManaCost = Bushwhack:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AcornShot, Scurry, Sharpshooter})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {AcornShot, Bushwhack, Scurry, Sharpshooter})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Sharpshooter})

    local combo = { canCast = false, neededMana = 0 }
    if J.CanCastAbility(AcornShot) then
        local comboMana = AcornShot:GetManaCost() + Bushwhack:GetManaCost() + 75
        if bot:GetMana() > comboMana then
            combo.canCast = true
            combo.neededMana = comboMana
        end
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
		then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            local vLocation = J.GetCorrectLoc(enemyHero, nDelay)
            local nTrees = enemyHero:GetNearbyTrees(nRadius)
            if enemyHero:HasModifier('modifier_teleporting') then
                local fModifierTime = J.GetModifierTime(enemyHero, 'modifier_teleporting')
                if fModifierTime > nDelay then
                    if #nTrees > 0 then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), false
                    else
                        if combo.canCast and J.GetManaAfter(combo.neededMana) > fManaThreshold3 then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), true
                        end
                    end
                end
            end

            if  not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay) then
                    if #nTrees > 0 then
                        return BOT_ACTION_DESIRE_HIGH, vLocation, false
                    end
                end

                if  GetUnitToLocationDistance(bot, vLocation) <= nCastRange
                and combo.canCast and J.GetManaAfter(combo.neededMana) > fManaThreshold3
                then
                    local nBaseDamagePct = AcornShot:GetSpecialValueInt('base_damage_pct')
                    local nDamage_Acorn = AcornShot:GetSpecialValueInt('acorn_shot_damage') + (bot:GetAttackDamage() * (nBaseDamagePct / 100))
                    local totalDamage = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL)
                    totalDamage = totalDamage + enemyHero:GetActualIncomingDamage(nDamage_Acorn * 2, DAMAGE_TYPE_PHYSICAL)
                    if J.WillKillTarget(enemyHero, totalDamage, DAMAGE_TYPE_ALL, nDelay) then
                        return BOT_ACTION_DESIRE_HIGH, vLocation, true
                    end
                end
            end
		end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
		then
            local nTrees = botTarget:GetNearbyTrees(nRadius)
            if #nTrees > 0 then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), false
            else
                if combo.canCast and J.GetManaAfter(combo.neededMana) > fManaThreshold3 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), true
                end
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and bot:WasRecentlyDamagedByHero(enemy, 4.0)
            and not J.IsDisabled(enemy)
            then
                if J.IsChasingTarget(enemy, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
                then
                    local nTrees = enemy:GetNearbyTrees(nRadius)
                    if #nTrees > 0 then
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), false
                    else
                        if combo.canCast and J.GetManaAfter(combo.neededMana) > fManaThreshold3 then
                            return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), true
                        end
                    end
                end
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold3 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not J.IsRealInvisible(bot)
            then
                for _, enemy in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemy)
                    and J.CanBeAttacked(enemy)
                    and J.CanCastOnNonMagicImmune(enemy)
                    and J.IsInRange(bot, enemy, nCastRange)
                    and J.IsChasingTarget(enemy, allyHero)
                    and not J.IsDisabled(enemy)
                    then
                        local nTrees = enemy:GetNearbyTrees(nRadius)
                        if #nTrees > 0 then
                            return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), false
                        end
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and bAttacking and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    if X.IsThereTreeInLocation(creep:GetLocation(), nRadius) and fManaAfter > fManaThreshold1 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                    end

                    if combo.canCast and J.GetManaAfter(combo.neededMana) > fManaThreshold3 and #nAllyHeroes <= 3 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold3 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    if X.IsThereTreeInLocation(creep:GetLocation(), nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                    end

                    if combo.canCast then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                    end
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 4 and combo.canCast then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold3 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    if X.IsThereTreeInLocation(creep:GetLocation(), nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                    end

                    if combo.canCast and J.GetManaAfter(combo.neededMana) > fManaThreshold3 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderScurry()
    if not J.CanCastAbility(Scurry)
    or bot:HasModifier('modifier_hoodwink_scurry_active')
    or J.IsRealInvisible(bot)
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nManaCost = Scurry:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

	if J.IsRetreating(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 1200)
            and not J.IsSuspiciousIllusion(enemy)
            and not J.IsDisabled(enemy)
            and not enemy:IsDisarmed()
            then
                if (J.IsChasingTarget(enemy, bot) and bot:WasRecentlyDamagedByAnyHero(4.0))
                or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
                or (botHP < 0.5 and enemy:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDecoy()
    if not J.CanCastAbility(Decoy) then
        return BOT_ACTION_DESIRE_NONE
    end

    if Sharpshooter ~= nil and Sharpshooter:IsTrained() then
        local nCastRange = Decoy:GetCastRange()
        local nMaxDamage = Sharpshooter:GetSpecialValueInt('max_damage')

        if J.IsGoingOnSomeone(bot) then
            for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
                if J.IsValidHero(enemy)
                and J.CanBeAttacked(enemy)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and bot:IsFacingLocation(enemy:GetLocation(), 30)
                and not J.IsChasingTarget(bot, enemy)
                then
                    local enemyName = enemy:GetUnitName()
                    if enemyName == 'npc_dota_hero_bristleback'
                    or enemyName == 'npc_dota_hero_dragon_knight'
                    or enemyName == 'npc_dota_hero_pudge'
                    or enemyName == 'npc_dota_hero_huskar'
                    or enemyName == 'npc_dota_hero_tidehunter'
                    or enemyName == 'npc_dota_hero_shredder'
                    or enemyName == 'npc_dota_hero_abyssal_underlord'
                    or enemyName == 'npc_dota_hero_monkey_king'
                    or enemyName == 'npc_dota_hero_ursa'
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end

                    if J.WillKillTarget(enemy, nMaxDamage * 0.6, DAMAGE_TYPE_MAGICAL, 5)
                    and not enemy:HasModifier('modifier_abaddon_borrowed_time')
                    and not enemy:HasModifier('modifier_dazzle_shallow_grave')
                    and not enemy:HasModifier('modifier_oracle_false_promise_timer')
                    and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not enemy:HasModifier('modifier_templar_assassin_refraction_absorb')
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end

                    if (enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        or enemy:HasModifier('modifier_enigma_black_hole_pull')
                        or enemy:HasModifier('modifier_legion_commander_duel'))
                    and J.GetHP(enemy) > 0.5
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end

            if  J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, Min(1600, nCastRange))
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
            and bot:IsFacingLocation(botTarget:GetLocation(), 30)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHuntersBoomerang()
    if not J.CanCastAbility(HuntersBoomerang) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, HuntersBoomerang:GetCastRange())
    local nCastPoint = HuntersBoomerang:GetCastPoint()
    local nDamage = HuntersBoomerang:GetSpecialValueInt('damage')
    local nRadius = HuntersBoomerang:GetSpecialValueInt('radius')
    local nSpeed = HuntersBoomerang:GetSpecialValueInt('speed')
    local nManaCost = HuntersBoomerang:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AcornShot, Bushwhack, Sharpshooter})

    for _, enemy in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemy)
        and J.CanBeAttacked(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        and J.CanCastOnNonMagicImmune(enemy)
        and J.CanCastOnTargetAdvanced(enemy)
        and J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        and not enemy:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not J.IsRetreating(bot)
        and fManaAfter > fManaThreshold1
        then
            local eta = (GetUnitToUnitDistance(bot, enemy) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and fManaAfter > fManaThreshold1
        then
            local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            if J.IsChasingTarget(bot, botTarget) or #nAllyHeroesTargetingTarget >= 2 then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSharpshooter()
    if not J.CanCastAbility(Sharpshooter) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = Sharpshooter:GetCastRange()
	local nAttackRange = bot:GetAttackRange()
    local nMaxChargeTime = Sharpshooter:GetSpecialValueInt('max_charge_time')
    local nMaxDamage = Sharpshooter:GetSpecialValueInt('max_damage')
    local nSpeed = Sharpshooter:GetSpecialValueInt('arrow_speed')

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
            and not enemy:HasModifier('modifier_oracle_false_promise_timer')
            then
                local eta = (GetUnitToUnitDistance(bot, enemy) / nSpeed)
                if (Bushwhack and Bushwhack:IsTrained()) then
                    local nStunDuration = Bushwhack:GetSpecialValueFloat('debuff_duration')
                    if J.GetModifierTime(enemy, 'modifier_hoodwink_bushwhack_trap') > (eta + nStunDuration / 2) then
                        bot.hoodwink_sharpshooter.target = enemy
                        bot.hoodwink_sharpshooter.engaging = true
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                    end
                end

                if J.WillKillTarget(enemy, nMaxDamage, DAMAGE_TYPE_MAGICAL, nMaxChargeTime + eta)
                and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemy:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    bot.hoodwink_sharpshooter.target = enemy
                    bot.hoodwink_sharpshooter.kill = true
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                end

                if (   J.GetModifierTime(enemy, 'modifier_bane_fiends_grip') >= nMaxChargeTime
                    or J.GetModifierTime(enemy, 'modifier_faceless_void_chronosphere_freeze') >= nMaxChargeTime
                    or J.GetModifierTime(enemy, 'modifier_enigma_black_hole_pull') >= nMaxChargeTime
                    or J.GetModifierTime(enemy, 'modifier_legion_commander_duel') >= nMaxChargeTime
                )
                and J.GetHP(enemy) > 0.5
                and #nAllyHeroes >= #nEnemyHeroes
                then
                    bot.hoodwink_sharpshooter.target = enemy
                    bot.hoodwink_sharpshooter.engaging = true
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            then
                local sEnemyName = enemy:GetUnitName()
                local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemy)
                if #nAllyHeroesTargetingTarget >= 2 or J.GetHP(enemy) <= 0.2 then
                    if sEnemyName == 'npc_dota_hero_bristleback'
                    or sEnemyName == 'npc_dota_hero_dragon_knight'
                    or sEnemyName == 'npc_dota_hero_pudge'
                    or sEnemyName == 'npc_dota_hero_huskar'
                    or sEnemyName == 'npc_dota_hero_tidehunter'
                    or sEnemyName == 'npc_dota_hero_shredder'
                    or sEnemyName == 'npc_dota_hero_abyssal_underlord'
                    or sEnemyName == 'npc_dota_hero_monkey_king'
                    or sEnemyName == 'npc_dota_hero_ursa'
                    then
                        bot.hoodwink_sharpshooter.target = enemy
                        bot.hoodwink_sharpshooter.break_ = true
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                    end
                end
            end
        end

		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, Min(1600, nCastRange))
        and not J.IsInRange(bot, botTarget, nAttackRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            if J.GetHP(botTarget) < 0.2 or #nAllyHeroesTargetingTarget >= 2 then
                bot.hoodwink_sharpshooter.target = botTarget
                bot.hoodwink_sharpshooter.engaging = true

                for i = 0, botTarget:NumModifiers() do
                    local sModifierName = botTarget:GetModifierName(i)
                    if sModifierName then
                        local fRemainingDuration = botTarget:GetModifierRemainingDuration(i)
                        if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                            if fRemainingDuration > nMaxChargeTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                            if fRemainingDuration > nMaxChargeTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['hexed'] and M['hexed'][sModifierName] then
                            if fRemainingDuration > nMaxChargeTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['rooted'] and M['rooted'][sModifierName] then
                            if fRemainingDuration > nMaxChargeTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['stunned'] and M['stunned'][sModifierName] then
                            if fRemainingDuration > nMaxChargeTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        end
                    end
                end

                if botTarget:GetCurrentMovementSpeed() <= 200 and not botTarget:IsHexed()
                or J.GetModifierTime(botTarget, 'modifier_legion_commander_duel') > nMaxChargeTime
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSharpshooterRelease()
    if not J.CanCastAbility(SharpshooterRelease) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = Sharpshooter:GetCastRange()
    local nRadius = Sharpshooter:GetSpecialValueInt('arrow_width')
    local nArrowRange = Sharpshooter:GetSpecialValueInt('arrow_range')
    local nMaxDebuffDuration = Sharpshooter:GetSpecialValueInt('max_slow_debuff_duration')
    local nMaxDamage = Sharpshooter:GetSpecialValueInt('max_damage')
    local nMinDamage = (nMaxDebuffDuration > 0 and (nMaxDamage / nMaxDebuffDuration)) or 0
    local nSpeed = Sharpshooter:GetSpecialValueInt('arrow_speed')
    local nMaxChargeTime = Sharpshooter:GetSpecialValueInt('max_charge_time')

    local vFacingLocation = J.GetFaceTowardDistanceLocation(bot, nArrowRange)

    -- draw green line
    DebugDrawLine(bot:GetLocation(), vFacingLocation, 0, 255, 0)

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nArrowRange)
    if #nInRangeEnemy == 0 then
        local count = 0
        local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
        for _, creep in pairs(nEnemyCreeps) do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not creep:IsMagicImmune()
            then
                local tResult = PointToLineDistance(bot:GetLocation(), vFacingLocation, creep:GetLocation())
                if tResult and tResult.within and tResult.distance <= nRadius then
                    count = count + 1
                end
            end
        end

        if count >= 5 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsValidHero(bot.hoodwink_sharpshooter.target) then
        local eta = (GetUnitToUnitDistance(bot, bot.hoodwink_sharpshooter.target) / nSpeed)
        local nDamage = RemapValClamped(DotaTime(), bot.hoodwink_sharpshooter.cast_time, bot.hoodwink_sharpshooter.cast_time + nMaxChargeTime + eta, nMinDamage, nMaxDamage)

        if X.IsUnitInBetweenLocations(bot.hoodwink_sharpshooter.target, bot:GetLocation(), vFacingLocation, nRadius) then
            if  J.GetModifierTime(bot.hoodwink_sharpshooter.target, 'modifier_teleporting') > eta
            and J.GetModifierTime(bot.hoodwink_sharpshooter.target, 'modifier_teleporting') < eta + 0.5
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            if bot.hoodwink_sharpshooter.kill then
                if J.CanKillTarget(bot.hoodwink_sharpshooter.target, nDamage, DAMAGE_TYPE_MAGICAL) then
                    return BOT_ACTION_DESIRE_HIGH
                else
                    if DotaTime() >= bot.hoodwink_sharpshooter.cast_time + nMaxChargeTime then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end

            if bot.hoodwink_sharpshooter.engaging then
                if DotaTime() >= bot.hoodwink_sharpshooter.cast_time + nMaxChargeTime then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end

            if bot.hoodwink_sharpshooter.break_ then
                if DotaTime() >= bot.hoodwink_sharpshooter.cast_time + nMaxChargeTime + eta then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end

            if  not J.IsInRange(bot, bot.hoodwink_sharpshooter.target, nArrowRange)
            and not bot.hoodwink_sharpshooter.target:IsFacingLocation(bot:GetLocation(), 90)
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            for i = 0, bot.hoodwink_sharpshooter.target:NumModifiers() do
                local sModifierName = bot.hoodwink_sharpshooter.target:GetModifierName(i)
                if sModifierName then
                    local fRemainingDuration = bot.hoodwink_sharpshooter.target:GetModifierRemainingDuration(i)
                    if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                        if fRemainingDuration > eta and fRemainingDuration < eta + 0.5 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                        if fRemainingDuration > eta and fRemainingDuration < eta + 0.5 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    elseif M['hexed'] and M['hexed'][sModifierName] then
                        if fRemainingDuration > eta and fRemainingDuration < eta + 0.5 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    elseif M['rooted'] and M['rooted'][sModifierName] then
                        if fRemainingDuration > eta and fRemainingDuration < eta + 0.5 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    elseif M['stunned'] and M['stunned'][sModifierName] then
                        if fRemainingDuration > eta and fRemainingDuration < eta + 0.5 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    end
                end
            end

            if  J.GetModifierTime(bot.hoodwink_sharpshooter.target, 'modifier_legion_commander_duel') > eta
            and J.GetModifierTime(bot.hoodwink_sharpshooter.target, 'modifier_legion_commander_duel') < eta + 0.5
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    else
        for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            then
                local eta = (GetUnitToUnitDistance(bot, enemy) / nSpeed)
                if X.IsUnitInBetweenLocations(enemy, bot:GetLocation(), J.GetFaceTowardDistanceLocation(bot, nArrowRange), nRadius) then
                    if  J.GetModifierTime(enemy, 'modifier_teleporting') > eta
                    and J.GetModifierTime(enemy, 'modifier_teleporting') < eta + 0.5
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end

                    if DotaTime() >= bot.hoodwink_sharpshooter.cast_time + nMaxChargeTime then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.IsUnitInBetweenLocations(hUnit, vLocation1, vLocation2, nRadius)
	local tResult = PointToLineDistance(vLocation1, vLocation2, hUnit:GetLocation())
    if tResult and tResult.within and tResult.distance <= nRadius then
        return true
    end

	return false
end

function X.IsThereTreeInLocation(vLocation, nRadius)
    local nTrees = bot:GetNearbyTrees(1600)
    for _, tree in pairs(nTrees) do
        if tree then
            local vTreeLocation = GetTreeLocation(tree)
            if J.GetDistance(vLocation, vTreeLocation) <= nRadius then
                return true
            end
        end
    end

    return false
end

return X