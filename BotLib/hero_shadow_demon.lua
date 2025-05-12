local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_shadow_demon'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)
local nGlimmerForce = RandomInt(1, 2) == 1 and "item_glimmer_cape" or "item_force_staff"

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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_glimmer_cape",--
                "item_aether_lens",
                "item_blink",
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_solar_crest",--
                "item_ultimate_scepter",
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_ethereal_blade",--
                "item_arcane_blink",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_solar_crest",
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
                [1] = {1,3,3,2,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_glimmer_cape",--
                "item_aether_lens",
                "item_blink",
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_solar_crest",--
                "item_ultimate_scepter",
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_ethereal_blade",--
                "item_arcane_blink",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_solar_crest",
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

local Disruption            = bot:GetAbilityByName('shadow_demon_disruption')
local Disseminate           = bot:GetAbilityByName('shadow_demon_disseminate')
local ShadowPoison          = bot:GetAbilityByName('shadow_demon_shadow_poison')
local ShadowPoisonRelease   = bot:GetAbilityByName('shadow_demon_shadow_poison_release')
local DemonicCleanse        = bot:GetAbilityByName('shadow_demon_demonic_cleanse')
local DemonicPurge          = bot:GetAbilityByName('shadow_demon_demonic_purge')

local DisruptionDesire, DisruptionTarget
local DisseminateDesire, DisseminateTarget
local ShadowPoisonDesire, ShadowPoisonLocation
local ShadowPoisonReleaseDesire
local DemonicCleanseDesire, DemonicCleanseTarget
local DemonicPurgeDesire, DemonicPurgeTarget

local nAllyHeroes, nEnemyHeroes
local botTarget, botHP

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    if GetBot():GetUnitName() == 'npc_dota_hero_rubick' then
        Disruption            = bot:GetAbilityByName('shadow_demon_disruption')
        Disseminate           = bot:GetAbilityByName('shadow_demon_disseminate')
        ShadowPoison          = bot:GetAbilityByName('shadow_demon_shadow_poison')
        ShadowPoisonRelease   = bot:GetAbilityByName('shadow_demon_shadow_poison_release')
        DemonicCleanse        = bot:GetAbilityByName('shadow_demon_demonic_cleanse')
        DemonicPurge          = bot:GetAbilityByName('shadow_demon_demonic_purge')
    end

    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)

    DisseminateDesire, DisseminateTarget = X.ConsiderDisseminate()
    if DisseminateDesire > 0
    then
        bot:Action_UseAbilityOnEntity(Disseminate, DisseminateTarget)
        return
    end

    DisruptionDesire, DisruptionTarget = X.ConsiderDisruption()
    if DisruptionDesire > 0
    then
        bot:Action_UseAbilityOnEntity(Disruption, DisruptionTarget)
        return
    end

    DemonicCleanseDesire, DemonicCleanseTarget = X.ConsiderDemonicCleanse()
    if DemonicCleanseDesire > 0
    then
        bot:Action_UseAbilityOnEntity(DemonicCleanse, DemonicCleanseTarget)
        return
    end

    DemonicPurgeDesire, DemonicPurgeTarget = X.ConsiderDemonicPurge()
    if DemonicPurgeDesire > 0
    then
        bot:Action_UseAbilityOnEntity(DemonicPurge, DemonicPurgeTarget)
        return
    end

    ShadowPoisonReleaseDesire = X.ConsiderShadowPoisonRelease()
    if ShadowPoisonReleaseDesire > 0
    then
        bot:Action_UseAbility(ShadowPoisonRelease)
        return
    end

    ShadowPoisonDesire, ShadowPoisonLocation = X.ConsiderShadowPoison()
    if ShadowPoisonDesire > 0
    then
        bot:Action_UseAbilityOnLocation(ShadowPoison, ShadowPoisonLocation)
        return
    end
end

function X.ConsiderDisruption()
    if not J.CanCastAbility(Disruption) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Disruption:GetCastRange())
    local nDuration = Disruption:GetSpecialValueFloat('disruption_duration')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and (enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero))
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and J.CanBeAttacked(allyHero)
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_obsidian_destroyer_astral_imprisonment_prison')
        then
            if allyHero:HasModifier('modifier_enigma_black_hole_pull')
            or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_legion_commander_duel')
            or allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(2)
            then
                local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
                for _, enemyHero in pairs(nAllyInRangeEnemy) do
                    if J.IsValidHero(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (botHP < 0.8 and bot:WasRecentlyDamagedByAnyHero(3.0))
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local hTarget = nil
        local hTargetPower = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_shadow_demon_purge_slow')
            then
                local enemyHeroPower = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                enemyHeroPower = enemyHeroPower + enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed() * 5.0 * 0.5
                if enemyHeroPower > hTargetPower then
                    hTarget = enemyHero
                    hTargetPower = enemyHeroPower
                end
            end
        end

        if hTarget then
            local nInRangeAlly = J.GetAlliesNearLoc(hTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(hTarget:GetLocation(), 1200)
            if not (#nInRangeAlly >= #nInRangeEnemy + 1) then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
	end

    if  J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_shadow_demon_purge_slow')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            if #nInRangeAlly >= #nInRangeEnemy
            and not (#nInRangeAlly >= #nInRangeEnemy + 1)
            and (J.IsChasingTarget(bot, botTarget)
                or #nInRangeEnemy >= 2
                or J.GetHP(botTarget) > 0.75)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            if botHP < 0.25 then
                return BOT_ACTION_DESIRE_HIGH, bot
            end

            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and not allyHero:IsIllusion()
                and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                and not allyHero:HasModifier('modifier_obsidian_destroyer_astral_imprisonment_prison')
                and not allyHero:HasModifier('modifier_item_crimson_guard_extra')
                and not allyHero:HasModifier('modifier_teleporting')
                and J.GetHP(allyHero) < 0.3
                and (botTarget:GetAttackTarget() == allyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            if botHP < 0.25 and not bot:HasModifier('modifier_item_crimson_guard_extra') then
                return BOT_ACTION_DESIRE_HIGH, bot
            end

            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and not allyHero:IsIllusion()
                and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                and not allyHero:HasModifier('modifier_obsidian_destroyer_astral_imprisonment_prison')
                and not allyHero:HasModifier('modifier_item_crimson_guard_extra')
                and not allyHero:HasModifier('modifier_teleporting')
                and J.GetHP(allyHero) < 0.3
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDisseminate()
    if not J.CanCastAbility(Disseminate)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Disseminate:GetCastRange())
	local nRadius = Disseminate:GetSpecialValueInt('radius')

	if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local hTarget = nil
                local hTargetAttackingCount = 0
                for _, allyHero in pairs(nAllyHeroes) do
                    if J.IsValidHero(allyHero)
                    and not allyHero:IsIllusion()
                    and not J.IsRetreating(allyHero)
                    then
                        if allyHero:GetAttackTarget() == enemyHero then
                            hTarget = enemyHero
                            hTargetAttackingCount = hTargetAttackingCount + 1
                        end
                    end
                end

                if hTarget and hTargetAttackingCount > 1 then
                    return BOT_ACTION_DESIRE_HIGH, hTarget
                end
            end
        end

        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
            if #nInRangeEnemy >= 2 or (#nInRangeEnemy <= 1 and J.GetHP(botTarget) < 0.3) then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) and botHP > 0.25 then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and enemyHero:GetAttackTarget() == bot
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                if #nInRangeEnemy >= 2 or (#nInRangeEnemy <= 1 and J.GetHP(enemyHero) < 0.3) then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShadowPoison()
    if not J.CanCastAbility(ShadowPoison) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, ShadowPoison:GetCastRange())
	local nCastPoint = ShadowPoison:GetCastPoint()
    local nRadius = ShadowPoison:GetSpecialValueInt('radius')
    local nSpeed = ShadowPoison:GetSpecialValueInt('speed')
    local nManaAfter = J.GetManaAfter(ShadowPoison:GetManaCost())

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_graves')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and (nManaAfter > (150 / bot:GetMaxMana()))
		then
            local fDelay = (nCastPoint + GetUnitToUnitDistance(bot, botTarget) / nSpeed)
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fDelay)
		end
	end

	if J.IsDefending(bot) then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
        if J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and nManaAfter > 0.35
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 and (nManaAfter > (150 / bot:GetMaxMana())) then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsLaning(bot) and nManaAfter > 0.3 then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local enemyHeroDamage = bot:GetEstimatedDamageToTarget(true, enemyHero, 3.0, DAMAGE_TYPE_ALL)
                if enemyHeroDamage > hTargetDamage then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
            end
        end

        if hTarget then
            local fDelay = (nCastPoint + GetUnitToUnitDistance(bot, hTarget) / nSpeed)
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(hTarget, fDelay)
        end
	end

    if J.IsDoingRoshan(bot) and nManaAfter > 0.5 then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) and nManaAfter > 0.5 then
        if  J.IsTormentor(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShadowPoisonRelease()
    if not J.CanCastAbility(ShadowPoisonRelease) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nStackDamage = ShadowPoison:GetSpecialValueInt('stack_damage')
    local nStacksBonusDamage = ShadowPoison:GetSpecialValueInt('bonus_stack_damage')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:HasModifier('modifier_shadow_demon_shadow_poison')
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nDamage = 0
            local nStacks = enemyHero:GetModifierStackCount(enemyHero:GetModifierByName('modifier_shadow_demon_shadow_poison'))
            if nStacks >= 1 and nStacks <= 5 then
                nDamage = nStackDamage * (2 ^ (nStacks - 1))
            elseif nStacks >= 6 then
                nDamage = (16 * nStackDamage) + (nStacksBonusDamage * (nStacks - 5))
            end

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL) then
                return BOT_ACTION_DESIRE_HIGH
            end

            if J.GetHP(enemyHero) < 0.5 and nStacks >= 5 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsValidHero(botTarget)
    and J.CanBeAttacked(botTarget)
    and J.CanCastOnNonMagicImmune(botTarget)
    and J.GetHP(botTarget) < 0.5
    and botTarget:HasModifier('modifier_shadow_demon_shadow_poison')
    and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
    and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
    and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
    then
        local nStacks = botTarget:GetModifierStackCount(botTarget:GetModifierByName('modifier_shadow_demon_shadow_poison'))
        if nStacks >= 5 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    local nCreepKillCount = 0
    local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
    for _, creep in pairs(nEnemyCreeps) do
        if J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and creep:HasModifier('modifier_shadow_demon_shadow_poison')
        then
            local nDamage = 0
            local nStacks = creep:GetModifierStackCount(creep:GetModifierByName('modifier_shadow_demon_shadow_poison'))
            if nStacks >= 1 and nStacks <= 5 then
                nDamage = nStackDamage * (2 ^ (nStacks - 1))
            elseif nStacks >= 6 then
                nDamage = (16 * nStackDamage) + (nStacksBonusDamage * (nStacks - 5))
            end

            if J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL) then
                nCreepKillCount = nCreepKillCount + 1
            end
        end
    end

    if nCreepKillCount >= 3 then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDemonicCleanse()
    if not J.CanCastAbility(DemonicCleanse) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DemonicCleanse:GetCastRange())

    if J.IsInTeamFight(bot, 1200) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and J.IsCore(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 800)
                if #nInRangeEnemy >= 2 or J.IsDisabled(allyHero) then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end

        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if J.IsDisabled(allyHero) then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 800)
                if J.IsChasingTarget(enemyHero, bot)
                and (#nInRangeEnemy >= 2
                    or (botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(3.0)))
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDemonicPurge()
    if not J.CanCastAbility(DemonicPurge) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DemonicPurge:GetCastRange())

    if J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidTarget(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_shadow_demon_purge_slow')
            and bot:HasScepter()
            then
                local sEnemyHeroName = enemyHero:GetUnitName()
                if sEnemyHeroName == 'npc_dota_hero_bristleback'
                or sEnemyHeroName == 'npc_dota_hero_huskar'
                or sEnemyHeroName == 'npc_dota_hero_tidehunter'
                or sEnemyHeroName == 'npc_dota_hero_dragon_knight'
                or sEnemyHeroName == 'npc_dota_hero_shredder'
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 800)
                    if #nInRangeAlly >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end

        local hTarget = nil
        local hTargetPower = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_shadow_demon_purge_slow')
            then
                local enemyHeroPower = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                enemyHeroPower = enemyHeroPower + enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed() * 5.0 * 0.5
                if enemyHeroPower > hTargetPower then
                    hTarget = enemyHero
                    hTargetPower = enemyHeroPower
                end
            end
        end

        if hTarget then
            local nInRangeAlly = J.GetAlliesNearLoc(hTarget:GetLocation(), 800)
            if #nInRangeAlly >= 2 then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
	end

    if  J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_shadow_demon_purge_slow')
        then
            local bStronger = J.WeAreStronger(bot, 1200)
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            if not (#nInRangeAlly >= #nInRangeEnemy + 1 and bStronger) and #nInRangeEnemy >= 2 then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X