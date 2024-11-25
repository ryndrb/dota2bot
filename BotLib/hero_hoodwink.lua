local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sRole   = J.Item.GetRoleItemsBuyList( bot )

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
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
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
                "item_gungir",--
                "item_boots_of_bearing",--
                "item_glimmer_cape",--
                "item_greater_crit",--
                "item_octarine_core",--
                "item_hurricane_pike",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_boots_of_bearing",
                "item_blight_stone", "item_glimmer_cape",
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
                "item_gungir",--
                "item_guardian_greaves",--
                "item_glimmer_cape",--
                "item_greater_crit",--
                "item_octarine_core",--
                "item_hurricane_pike",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_guardian_greaves",
                "item_blight_stone", "item_glimmer_cape",
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

local SharpshooterStartTime = -1

function X.SkillsComplement()
    AcornShot         = bot:GetAbilityByName('hoodwink_acorn_shot')
    Bushwhack         = bot:GetAbilityByName('hoodwink_bushwhack')
    Scurry            = bot:GetAbilityByName('hoodwink_scurry')
    HuntersBoomerang  = bot:GetAbilityByName('hoodwink_hunters_boomerang')
    Decoy             = bot:GetAbilityByName('hoodwink_decoy')
    Sharpshooter      = bot:GetAbilityByName('hoodwink_sharpshooter')
    SharpshooterRelease = bot:GetAbilityByName('hoodwink_sharpshooter_release')

	if J.CanNotUseAbility(bot)
    then
        return
    end

    if not bot:HasModifier('modifier_hoodwink_sharpshooter_windup') then
        bot.sharpshooter_combo = false
        bot.sharpshooter_kill = false
        bot.sharpshooter_engaging = false
        bot.sharpshooter_break = false
        bot.sharpshooter_target = nil
    end

    AcornShotDesire, AcornShotTarget, TargetType = X.ConsiderAcornShot()
    if AcornShotDesire > 0
    then
        if TargetType == 'unit' then
            bot:Action_UseAbilityOnEntity(AcornShot, AcornShotTarget)
            return
        else
            bot:Action_UseAbilityOnLocation(AcornShot, AcornShotTarget)
            return
        end
    end

    BushwhackDesire, BushwhackLocation, ShouldAcorn = X.ConsiderBushwhack()
    if BushwhackDesire > 0
    then
        if ShouldAcorn then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbilityOnLocation(AcornShot, BushwhackLocation)
            bot:ActionQueue_Delay(0.2 + 1.37)
            bot:ActionQueue_UseAbilityOnLocation(Bushwhack, BushwhackLocation)
            return
        else
            bot:Action_UseAbilityOnLocation(Bushwhack, BushwhackLocation)
            return
        end
    end

    SharpshooterReleaseDesire = X.ConsiderSharpshooterRelease()
    if SharpshooterReleaseDesire > 0
    then
        bot:Action_UseAbility(SharpshooterRelease)
        return
    end

    SharpshooterDesire, SharpshooterLocation = X.ConsiderSharpshooter()
    if SharpshooterDesire > 0
    then
        bot:Action_UseAbilityOnLocation(Sharpshooter, SharpshooterLocation)
        SharpshooterStartTime = DotaTime()
        return
    end

    ScurryDesire = X.ConsiderScurry()
    if ScurryDesire > 0
    then
        bot:Action_UseAbility(Scurry)
        return
    end

    HuntersBoomerangDesire, HuntersBoomerangTarget, CastType = X.ConsiderHuntersBoomerang()
    if HuntersBoomerangDesire > 0
    then
        if CastType == 'unit' then
            bot:Action_UseAbilityOnEntity(HuntersBoomerang, HuntersBoomerangTarget)
        else
            bot:Action_UseAbilityOnLocation(HuntersBoomerang, HuntersBoomerangTarget)
        end
        return
    end

    DecoyDesire = X.ConsiderDecoy()
    if DecoyDesire > 0
    then
        bot:Action_UseAbility(Decoy)
        return
    end
end

function X.ConsiderAcornShot()
    if not J.CanCastAbility(AcornShot)
    then
        return BOT_ACTION_DESIRE_NONE, 0, ''
    end

	local nCastRange = J.GetProperCastRange(false, bot, AcornShot:GetCastRange())
	local nCastPoint = AcornShot:GetCastPoint()
	local nRadius = AcornShot:GetSpecialValueInt('bounce_range')
    local nBounceCount = AcornShot:GetSpecialValueInt('bounce_count')
    local nDamage = AcornShot:GetSpecialValueInt('acorn_shot_damage') + (bot:GetAttackDamage() * 0.75)
    local nSpeed = AcornShot:GetSpecialValueInt('projectile_speed')
    local nAbilityLevel = AcornShot:GetLevel()
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local damage = nDamage
            local nTrees = enemyHero:GetNearbyTrees(nRadius)
            local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
            local nLocationAoE_creeps = bot:FindAoELocation(true, false, enemyHero:GetLocation(), 0, nRadius, 0, 0)
            if #nTrees > 0 or nLocationAoE.count > 0 or nLocationAoE_creeps.count > 0 then
                damage = nDamage * nBounceCount
            end

            if J.CanKillTarget(enemyHero, damage, DAMAGE_TYPE_PHYSICAL) then
                local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                if J.IsInRange(bot, enemyHero, nCastRange) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
                end

                if J.IsInRange(bot, enemyHero, nCastRange + nRadius)
                and not J.IsInRange(bot, enemyHero, nCastRange)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetXUnitsTowardsLocation2(bot:GetLocation(), J.GetCorrectLoc(enemyHero, nDelay), nCastRange), 'loc'
                end
            end
		end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and (J.IsRetreating(allyHero) and J.GetHP(allyHero) < 0.75 and allyHero:WasRecentlyDamagedByAnyHero(3.0))
        and not allyHero:IsIllusion()
        and not J.IsRealInvisible(bot)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            for _, enemy in pairs(nAllyInRangeEnemy) do
                if J.IsValidHero(enemy)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and J.IsChasingTarget(enemy, allyHero)
                and not J.IsDisabled(enemy)
                then
                    local nDelay = (GetUnitToUnitDistance(bot, enemy) / nSpeed) + nCastPoint
                    if J.IsInRange(bot, enemy, nCastRange) then
                        return BOT_ACTION_DESIRE_HIGH, enemy, 'unit'
                    end

                    if J.IsInRange(bot, enemy, nCastRange + nRadius)
                    and not J.IsInRange(bot, enemy, nCastRange)
                    then
                        local target_loc = J.GetXUnitsTowardsLocation2(bot:GetLocation(), J.GetCorrectLoc(enemy, nDelay), nCastRange)
                        local nLocationAoE = bot:FindAoELocation(true, true, target_loc, 0, nRadius, 0, 0)
                        if nLocationAoE.count > 0 then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
                        end
                    end
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nTrees = botTarget:GetNearbyTrees(nRadius)
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            if J.IsInRange(bot, botTarget, nCastRange) then
                if #nTrees > 0 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
                else
                    local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
                    local nLocationAoE_2 = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, nRadius, 0, 0)
                    if nLocationAoE.count >= 2 or nLocationAoE_2.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
                    end
                end
            end

            if J.IsInRange(bot, botTarget, nCastRange + nRadius)
            and not J.IsInRange(bot, botTarget, nCastRange)
            then
                if #nTrees > 0 then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay), 'loc'
                else
                    local target_loc = J.GetXUnitsTowardsLocation2(bot:GetLocation(), J.GetCorrectLoc(botTarget, nDelay), nCastRange)
                    local nLocationAoE = bot:FindAoELocation(true, true, target_loc, 0, nRadius, 0, 0)
                    local nLocationAoE_2 = bot:FindAoELocation(true, false, target_loc, 0, nRadius, 0, 0)
                    if nLocationAoE.count >= 2 or nLocationAoE_2.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
                    end
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot)
	then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.IsChasingTarget(enemy, bot)
            and (bot:WasRecentlyDamagedByAnyHero(3.0) and J.GetHP(bot) < 0.7 or (J.IsMidGame() or J.IsLateGame()))
            and not J.IsSuspiciousIllusion(enemy)
            and not J.IsDisabled(enemy)
            then
                local nLocationAoE = bot:FindAoELocation(true, true, enemy:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count > 0 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
                end
            end
        end
	end

	if  (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot))
    and (J.HasItem(bot, 'item_maelstrom') or J.HasItem(bot, 'item_gungir') or J.HasItem(bot, 'item_mjollnir'))
    and nAbilityLevel >= 3
    and not J.IsThereCoreNearby(800)
	then
		local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)
        if J.IsValid(nEnemyCreeps[1])
        and (#nEnemyCreeps >= 4 or #nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1]) then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
            end
        end
	end

    if J.IsLaning(bot) then
        if J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(900)) then
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
            for _, creep in pairs(nEnemyLaneCreeps) do
                if J.IsValid(creep)
                and string.find(creep:GetUnitName(), 'range')
                and J.CanBeAttacked(creep)
                and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep, 'unit'
                end
            end
        end
    end

    if (J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)) then
        if (J.IsRoshan(botTarget) or J.IsTormentor(bot))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, ''
end

function X.ConsiderBushwhack()
    if not J.CanCastAbility(Bushwhack)
    then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

	local nCastRange = J.GetProperCastRange(false, bot, Bushwhack:GetCastRange())
    local nCastPoint = Bushwhack:GetCastPoint()
    local nDamage = Bushwhack:GetSpecialValueInt('total_damage')
	local nRadius = Bushwhack:GetSpecialValueInt('trap_radius')
    local nSpeed = Bushwhack:GetSpecialValueInt('projectile_speed')
    local nMana = bot:GetMana()
    local botTarget = J.GetProperTarget(bot)

    local bCastCombo = false
    local nManaAfter = 0
    if J.CanCastAbility(AcornShot) then
        if nMana > (AcornShot:GetManaCost() + Bushwhack:GetManaCost()) then
            bCastCombo = true
        end
        nManaAfter = J.GetManaAfter(AcornShot:GetManaCost() + Bushwhack:GetManaCost())
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
		then
            local nTrees = enemyHero:GetNearbyTrees(nRadius)
            if enemyHero:HasModifier('modifier_teleporting') then
                local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count > 0 then
                    if #nTrees > 0 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                    else
                        if bCastCombo then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                        end
                    end
                end
            end

            if not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL) then
                    local nLocationAoE = bot:FindAoELocation(true, true, J.GetCorrectLoc(enemyHero, nDelay), 0, nRadius, 0, 0)
                    if nLocationAoE.count > 0 then
                        if #nTrees > 0 then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                        else
                            if bCastCombo then
                                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                            end
                        end
                    end
                end

                if bCastCombo then
                    local nBounceCount = AcornShot:GetSpecialValueInt('bounce_count')
                    local nDamage_acorn = AcornShot:GetSpecialValueInt('acorn_shot_damage') * (bot:GetAttackDamage() * 0.75)
                    local totalDamage = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL)
                    totalDamage = totalDamage + enemyHero:GetActualIncomingDamage(nDamage_acorn * nBounceCount, DAMAGE_TYPE_PHYSICAL)
                    if totalDamage >= enemyHero:GetHealth() then
                        local nLocationAoE = bot:FindAoELocation(true, true, J.GetCorrectLoc(enemyHero, nDelay), 0, nRadius, 0, 0)
                        if nLocationAoE.count > 0 then
                            if #nTrees > 0 then
                                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                            else
                                if bCastCombo then
                                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                                end
                            end
                        end
                    end
                end
            end
		end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and (J.IsRetreating(allyHero) and J.GetHP(allyHero) < 0.75 and allyHero:WasRecentlyDamagedByAnyHero(3.0))
        and not allyHero:IsIllusion()
        and not J.IsRealInvisible(bot)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            for _, enemy in pairs(nAllyInRangeEnemy) do
                if J.IsValidHero(enemy)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and J.IsChasingTarget(enemy, allyHero)
                and not J.IsDisabled(enemy)
                then
                    local nTrees = nAllyInRangeEnemy[1]:GetNearbyTrees(nRadius)
                    if #nTrees > 0 then
                        local nDelay = (GetUnitToUnitDistance(bot, nAllyInRangeEnemy[1]) / nSpeed) + nCastPoint
                        local nLocationAoE = bot:FindAoELocation(true, true, J.GetCorrectLoc(nAllyInRangeEnemy[1], nDelay), 0, nRadius, 0, 0)
                        if nLocationAoE.count > 0 then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                        end
                    end
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
		then
            local nTrees = botTarget:GetNearbyTrees(nRadius)
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local nLocationAoE = bot:FindAoELocation(true, true, J.GetCorrectLoc(botTarget, nDelay), 0, nRadius, 0, 0)
            if nLocationAoE.count > 0 then
                if #nTrees > 0 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                else
                    if bCastCombo then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                    end
                end
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.IsChasingTarget(enemy, enemy)
            and bot:WasRecentlyDamagedByAnyHero(3.0)
            and not J.IsDisabled(enemy)
            then
                local nTrees = enemy:GetNearbyTrees(nRadius)
                local nLocationAoE = bot:FindAoELocation(true, true, enemy:GetLocation(), 0, nRadius, 0, 0)
                if #nTrees > 0 then
                    if nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                    end
                else
                    if bCastCombo and not J.IsInLaningPhase() then
                        if nLocationAoE.count > 0 then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                        end
                    end
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)

    if J.IsDefending(bot) and not J.IsInLaningPhase() then
        if #nEnemyCreeps >= 4
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[2]:GetLocation(), 0, nRadius, 0, 0)
            local nTrees = nEnemyCreeps[1]:GetNearbyTrees(nRadius)
            if nTrees ~= nil and #nTrees > 0 then
                if nLocationAoE.count >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            else
                if bCastCombo and nManaAfter > 0.4 then
                    if nLocationAoE.count >= 4 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                    end
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if nLocationAoE.count >= 2 and #nInRangeEnemy >= 1 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
        end
    end

    if J.IsFarming(bot) then
        if J.CanBeAttacked(nEnemyCreeps[1])
        and (#nEnemyCreeps >= 3 or #nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[2]:GetLocation(), 0, nRadius, 0, 0)
            local nTrees = nEnemyCreeps[1]:GetNearbyTrees(nRadius)
            if nTrees ~= nil and #nTrees > 0 then
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            else
                if bCastCombo and nManaAfter > 0.35 then
                    if nLocationAoE.count >= 2 then
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

	if J.IsRetreating(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        if  nInRangeAlly ~= nil and nInRangeEnemy
        and ((#nInRangeEnemy > #nInRangeAlly)
            or (J.GetHP(bot) < 0.55 and bot:WasRecentlyDamagedByAnyHero(3.0)))
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if J.GetHP(bot) < 0.65 and bot:WasRecentlyDamagedByTower(2.0) and #nInRangeEnemy > 0
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSharpshooter()
    if not J.CanCastAbility(Sharpshooter)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = Sharpshooter:GetCastRange()
	local nAttackRange = bot:GetAttackRange()
    local nMaxChargeTime = Sharpshooter:GetSpecialValueInt('max_charge_time')
    local nMaxDamage = Sharpshooter:GetSpecialValueInt('max_damage')
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
        for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
            if J.IsValidHero(enemy)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            then
                if J.WillKillTarget(enemy, nMaxDamage, DAMAGE_TYPE_MAGICAL, nMaxChargeTime)
                and not enemy:HasModifier('modifier_abaddon_borrowed_time')
                and not enemy:HasModifier('modifier_dazzle_shallow_grave')
                and not enemy:HasModifier('modifier_oracle_false_promise_timer')
                and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemy:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    bot.sharpshooter_kill = true
                    bot.sharpshooter_target = enemy
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                end

                if (enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
                or enemy:HasModifier('modifier_enigma_black_hole_pull')
                or enemy:HasModifier('modifier_legion_commander_duel')
                )
                and J.GetHP(enemy) > 0.5
                and #nAllyHeroes >= #nEnemyHeroes
                then
                    bot.sharpshooter_combo = true
                    bot.sharpshooter_target = enemy
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                end

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
                    bot.sharpshooter_break = true
                    bot.sharpshooter_target = enemy
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                end
            end
        end

		if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, Min(2000, nCastRange))
        and bot:WasRecentlyDamagedByAnyHero(2.0)
        and not J.IsInRange(bot, botTarget, nAttackRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            bot.sharpshooter_engaging = true
            bot.sharpshooter_target = botTarget
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
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
    local nMinDamage = 110 + ((Sharpshooter:GetLevel() - 1) * 70)
    local nMaxDamage = Sharpshooter:GetSpecialValueInt('max_damage')
    local nSpeed = Sharpshooter:GetSpecialValueInt('arrow_speed')
    local nMaxChargeTime = Sharpshooter:GetSpecialValueInt('max_charge_time')

    local nDamage = RemapValClamped(DotaTime(), SharpshooterStartTime, SharpshooterStartTime + nMaxChargeTime, nMinDamage, nMaxDamage)

    if bot.sharpshooter_kill and J.IsValidHero(bot.sharpshooter_target) then
        if (J.CanKillTarget(bot.sharpshooter_target, nDamage, DAMAGE_TYPE_MAGICAL)
            or (not J.CanKillTarget(bot.sharpshooter_target, nDamage, DAMAGE_TYPE_MAGICAL)
                and DotaTime() >= SharpshooterStartTime + nMaxChargeTime
                )
            )
        and X.IsUnitNearLoc(bot.sharpshooter_target, bot.sharpshooter_target:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if (bot.sharpshooter_combo or bot.sharpshooter_engaging)
    and J.IsValidHero(bot.sharpshooter_target) then
        if X.IsUnitNearLoc(bot.sharpshooter_target, bot.sharpshooter_target:GetLocation(), nRadius)
        and DotaTime() >= SharpshooterStartTime + nMaxChargeTime
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if bot.sharpshooter_break
    and J.IsValidHero(bot.sharpshooter_target) then
        if X.IsUnitNearLoc(bot.sharpshooter_target, bot.sharpshooter_target:GetLocation(), nRadius)
        and DotaTime() > SharpshooterStartTime + nMaxChargeTime + 0.5
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHuntersBoomerang()
    if not J.CanCastAbility(HuntersBoomerang)
    then
        return BOT_ACTION_DESIRE_NONE, 0, ''
    end

    local nCastRange = J.GetProperCastRange(false, bot, HuntersBoomerang:GetCastRange())
    local nDamage = HuntersBoomerang:GetSpecialValueInt('damage')
    local nRadius = HuntersBoomerang:GetSpecialValueInt('radius')
    local nSpeed = HuntersBoomerang:GetSpecialValueInt('speed')
    local nCastPoint = HuntersBoomerang:GetCastPoint()
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_oracle_false_promise_timer')
            and not enemy:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not (#nAllyHeroes >= #nEnemyHeroes + 2)
            then
                return BOT_ACTION_DESIRE_HIGH, enemy, 'unit'
            end
        end

        if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, eta, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            if nLocationAoE.count >= 2 and #nInRangeEnemy >= 1 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, ''
end

function X.ConsiderDecoy()
    if not J.CanCastAbility(Decoy)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if Sharpshooter ~= nil and Sharpshooter:IsTrained() then
        local nCastRange = Decoy:GetCastRange()
        local nMaxDamage = Sharpshooter:GetSpecialValueInt('max_damage')
        local botTarget = J.GetProperTarget(bot)

        if J.IsGoingOnSomeone(bot)
        then
            for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
                if J.IsValidHero(enemy)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and bot:IsFacingLocation(enemy:GetLocation(), 15)
                and not J.IsRunning(enemy)
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
                        or enemy:HasModifier('modifier_legion_commander_duel')
                    )
                    and J.GetHP(enemy) > 0.5
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end

            if  J.IsValidHero(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, Min(2000, nCastRange))
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

function X.IsUnitNearLoc(hUnit, vLoc, nRadius)
	if J.GetLocationToLocationDistance(hUnit:GetLocation(), vLoc) <= nRadius
	then
		return true
	end

	return false
end

return X