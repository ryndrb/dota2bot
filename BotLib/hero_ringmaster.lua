local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_ringmaster'
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
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_rod_of_atos",
                "item_aether_lens",
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_octarine_core",--
                "item_gungir",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
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
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_rod_of_atos",
                "item_aether_lens",
                "item_mekansm",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_octarine_core",--
                "item_gungir",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
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

local TameTheBeasts         = bot:GetAbilityByName('ringmaster_tame_the_beasts')
local TameTheBeastsCrack    = bot:GetAbilityByName('ringmaster_tame_the_beasts_crack')
local EscapeAct             = bot:GetAbilityByName('ringmaster_the_box')
local ImpalementArts        = bot:GetAbilityByName('ringmaster_impalement')
local Spotlight             = bot:GetAbilityByName('ringmaster_spotlight')
local WheelOfWonder         = bot:GetAbilityByName('ringmaster_wheel')

-- Souvernirs
local EmptySouvenir         = bot:GetAbilityByName('ringmaster_empty_souvenir')
local FunhouseMirror        = bot:GetAbilityByName('ringmaster_funhouse_mirror')
local StrongmanTonic        = bot:GetAbilityByName('ringmaster_strongman_tonic')
local WhoopeeCushion        = bot:GetAbilityByName('ringmaster_whoopee_cushion')

local CrystalBall           = bot:GetAbilityByName('ringmaster_crystal_ball')
local WeightedPie           = bot:GetAbilityByName("ringmaster_weighted_pie")
local Unicycle              = bot:GetAbilityByName("ringmaster_summon_unicycle")

local TameTheBeastsDesire, TameTheBeastsLocation
local TameTheBeastsCrackDesire
local EscapeActDesire, EscapeActTarget
local ImpalementArtsDesire, ImpalementArtsLocation
local SpotlightDesire, SpotlightLocation
local WheelOfWonderDesire, WheelOfWonderLocation

local FunhouseMirrorDesire
local StrongmanTonicDesire, StrongmanTonicTarget
local WhoopeeCushionDesire

local CrystalBallDesire, CrystalBallLocation
local WeightedPieDesire, WeightedPieTarget
local UnicyleDesire

local fImpaleArtsCastTime = 0

local whip = {
    target = nil,
    to_cancel = false,
    to_kill = false,
    to_engage = false,
    to_retreat = false,
    to_farm = false,
}

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    TameTheBeasts         = bot:GetAbilityByName('ringmaster_tame_the_beasts')
    TameTheBeastsCrack    = bot:GetAbilityByName('ringmaster_tame_the_beasts_crack')
    EscapeAct             = bot:GetAbilityByName('ringmaster_the_box')
    ImpalementArts        = bot:GetAbilityByName('ringmaster_impalement')
    Spotlight             = bot:GetAbilityByName('ringmaster_spotlight')
    WheelOfWonder         = bot:GetAbilityByName('ringmaster_wheel')

    -- Souvernirs
    FunhouseMirror        = bot:GetAbilityByName('ringmaster_funhouse_mirror')
    StrongmanTonic        = bot:GetAbilityByName('ringmaster_strongman_tonic')
    WhoopeeCushion        = bot:GetAbilityByName('ringmaster_whoopee_cushion')

    CrystalBall           = bot:GetAbilityByName('ringmaster_crystal_ball')
    WeightedPie           = bot:GetAbilityByName("ringmaster_weighted_pie")
    Unicycle              = bot:GetAbilityByName("ringmaster_summon_unicycle")

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    WhoopeeCushionDesire = X.ConsiderWhoopeeCushion()
    if WhoopeeCushionDesire > 0 then
        bot:Action_UseAbility(WhoopeeCushion)
        return
    end

    EscapeActDesire, EscapeActTarget = X.ConsiderEscapeAct()
    if EscapeActDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(EscapeAct, EscapeActTarget)
        return
    end

    WheelOfWonderDesire, WheelOfWonderLocation = X.ConsiderWheelOfWonder()
    if WheelOfWonderDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(WheelOfWonder, WheelOfWonderLocation)
        return
    end

    TameTheBeastsCrackDesire = X.ConsiderTameTheBeastsCrack()
    if TameTheBeastsCrackDesire > 0 then
        bot:Action_UseAbility(TameTheBeastsCrack)
        return
    end

    TameTheBeastsDesire, TameTheBeastsLocation = X.ConsiderTameTheBeasts()
    if TameTheBeastsDesire > 0 then
        J.SetQueuePtToINT(bot, true)
        bot:ActionQueue_UseAbilityOnLocation(TameTheBeasts, TameTheBeastsLocation)
        return
    end

    ImpalementArtsDesire, ImpalementArtsLocation = X.ConsiderImpalementArts()
    if ImpalementArtsDesire > 0 then
        fImpaleArtsCastTime = DotaTime()
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(ImpalementArts, ImpalementArtsLocation)
        return
    end

    WeightedPieDesire, WeightedPieTarget = X.ConsiderWeightedPie()
    if WeightedPieDesire > 0 then
        bot:Action_UseAbilityOnEntity(WeightedPie, WeightedPieTarget)
        return
    end

    UnicyleDesire = X.ConsiderUnicycle()
    if UnicyleDesire > 0 then
        bot:Action_UseAbility(Unicycle)
        return
    end

    StrongmanTonicDesire, StrongmanTonicTarget = X.ConsiderStrongmanTonic()
    if StrongmanTonicDesire > 0 then
        bot:Action_UseAbilityOnEntity(StrongmanTonic, StrongmanTonicTarget)
        return
    end

    SpotlightDesire, SpotlightLocation = X.ConsiderSpotlight()
    if SpotlightDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Spotlight, SpotlightLocation)
        return
    end

    FunhouseMirrorDesire = X.ConsiderFunhouseMirror()
    if FunhouseMirrorDesire > 0 then
        bot:Action_UseAbility(FunhouseMirror)
        return
    end

    CrystalBallDesire, CrystalBallLocation = X.ConsiderCrystallBall()
    if CrystalBallDesire > 0 then
        bot:Action_UseAbilityOnLocation(CrystalBall, CrystalBallLocation)
        return
    end
end

function X.ConsiderTameTheBeasts()
    if not J.CanCastAbility(TameTheBeasts) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, TameTheBeasts:GetCastRange())
    local nDelay = TameTheBeasts:GetSpecialValueFloat('crack_duration')
    local nOuterRadius = TameTheBeasts:GetSpecialValueInt('start_width')
    local nInnerRadius = TameTheBeasts:GetSpecialValueInt('end_width')
    local nMinDamage = TameTheBeasts:GetSpecialValueInt('damage_min')
    local nMaxDamage = TameTheBeasts:GetSpecialValueInt('damage_max')
    local nDuration = TameTheBeasts:GetSpecialValueInt('AbilityChannelTime')
    local nManaCost = TameTheBeasts:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EscapeAct, ImpalementArts, Spotlight, WheelOfWonder})

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.CanBeAttacked(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        and J.CanCastOnNonMagicImmune(enemy)
        then
            if J.GetModifierTime(enemy, 'modifier_teleporting') > nDelay then
                whip.to_cancel = true
                return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
            end

            if J.WillKillTarget(enemy, nMaxDamage, DAMAGE_TYPE_MAGICAL, nDuration + nDelay)
            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_oracle_false_promise_timer')
            then
                whip.target = enemy
                whip.to_kill = true
                return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and not J.IsInRange(bot, enemy, nCastRange / 2)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsDisabled(enemy)
            and bot:WasRecentlyDamagedByHero(enemy, 3.0)
            then
                whip.to_retreat = true
                return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyLaneCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nInnerRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and #nEnemyHeroes == 0 then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nInnerRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'ranged'))
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nInnerRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
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
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTameTheBeastsCrack()
    if not J.CanCastAbility(TameTheBeastsCrack) then
        whip.target = nil
        whip.to_kill = false
        whip.to_cancel = false
        whip.to_retreat = false
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nChannelTime = TameTheBeasts:GetSpecialValueInt('AbilityChannelTime')
    local nCastRange = J.GetProperCastRange(bot, false, TameTheBeasts:GetCastRange())
    local nCastPoint = TameTheBeasts:GetCastPoint()
    local nOuterRadius = TameTheBeasts:GetSpecialValueInt('start_width')
    local nInnerRadius = TameTheBeasts:GetSpecialValueInt('end_width')
    local nMinDamage = TameTheBeasts:GetSpecialValueInt('damage_min')
    local nMaxDamage = TameTheBeasts:GetSpecialValueInt('damage_max')
    local nManaCost = TameTheBeasts:GetManaCost()

    local nDamage = RemapValClamped(TameTheBeasts:GetCooldown() - TameTheBeasts:GetCooldownTimeRemaining(), 0, 1, nMinDamage, nMaxDamage)

    if TameTheBeastsLocation then
        local nLocationAoE = bot:FindAoELocation(true, true, TameTheBeastsLocation, 0, nOuterRadius, 0, 0)
        if nLocationAoE.count == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end

        nLocationAoE = bot:FindAoELocation(true, false, TameTheBeastsLocation, 0, nOuterRadius, 0, 0)
        if nLocationAoE.count == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if whip.to_kill then
        if J.IsValid(whip.target) then
            if J.CanKillTarget(whip.target, nDamage, DAMAGE_TYPE_MAGICAL) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if whip.to_cancel
    or whip.to_retreat
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEscapeAct()
    if not J.CanCastAbility(EscapeAct) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, EscapeAct:GetCastRange())
    local nRadius = EscapeAct:GetSpecialValueFloat('leash_radius')
    local nDuration = EscapeAct:GetSpecialValueFloat('invis_duration')
    local nManaCost = TameTheBeasts:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TameTheBeasts, ImpalementArts, Spotlight, WheelOfWonder})

    for _, ally in pairs(nAllyHeroes) do
        if J.IsValidHero(ally)
        and J.CanBeAttacked(ally)
        and J.IsInRange(bot, ally, nCastRange + 300)
        and not J.IsRealInvisible(ally)
        and not ally:IsIllusion()
        and not ally:HasModifier('modifier_abaddon_borrowed_time')
        and not ally:HasModifier('modifier_dazzle_shallow_grave')
        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
        and not ally:HasModifier('modifier_teleporting')
        and not ally:HasModifier('modifier_fountain_aura_buff')
        then
            local allyHP = J.GetHP(ally)
            local allyTarget = J.GetProperTarget(ally)

            if (ally:HasModifier('modifier_legion_commander_duel') and allyHP < 0.25)
            or (ally:HasModifier('modifier_enigma_black_hole_pull'))
            or (ally:HasModifier('modifier_faceless_void_chronosphere_freeze'))
            then
                return BOT_ACTION_DESIRE_HIGH, ally
            end

            local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, ally)

            if allyHP < 0.5 and J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, ally, 5.0) > ally:GetHealth() then
                return BOT_ACTION_DESIRE_HIGH, ally
            end

            if J.IsRoshan(allyTarget) or J.IsTormentor(allyTarget) then
                if allyHP < 0.15 then
                    return BOT_ACTION_DESIRE_HIGH, ally
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderImpalementArts()
    if not J.CanCastAbility(ImpalementArts) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, ImpalementArts:GetCastRange())
    local nCastPoint = ImpalementArts:GetCastPoint()
    local nRadius = ImpalementArts:GetSpecialValueInt('dagger_width')
    local nRestoreTime = ImpalementArts:GetSpecialValueInt('AbilityChargeRestoreTime')
    local nImpactDamage = ImpalementArts:GetSpecialValueInt('damage_impact')
    local nBleedPct = ImpalementArts:GetSpecialValueFloat('bleed_health_pct') / 100
    local nDuration = ImpalementArts:GetSpecialValueInt('bleed_duration')
    local nSpeed = ImpalementArts:GetSpecialValueInt('dagger_speed')
    local nManaCost = ImpalementArts:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TameTheBeasts, EscapeAct, ImpalementArts, Spotlight, WheelOfWonder})

    if DotaTime() < fImpaleArtsCastTime + ((ImpalementArts:GetCastRange() / nSpeed) + nCastPoint) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.CanBeAttacked(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        and J.CanCastOnNonMagicImmune(enemy)
        and not enemy:HasModifier('modifier_ringmaster_impalement_bleed')
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        then
            local eta = (GetUnitToUnitDistance(bot, enemy) / nSpeed) + nCastPoint
            local targetLoc = J.GetCorrectLoc(enemy, eta)

            if J.WillKillTarget(enemy, nImpactDamage, DAMAGE_TYPE_MAGICAL, eta)
            or J.WillKillTarget(enemy, nImpactDamage + (enemy:GetMaxHealth() * nBleedPct * nDuration), DAMAGE_TYPE_MAGICAL, eta + nDuration)
            then
                if not X.IsUnitBetweenMeAndLocation(bot, enemy, targetLoc, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, targetLoc
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_ringmaster_impalement_bleed')
        then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local targetLoc = J.GetCorrectLoc(botTarget, eta)
            if not X.IsUnitBetweenMeAndLocation(bot, botTarget, targetLoc, nRadius) then
                return BOT_ACTION_DESIRE_HIGH, targetLoc
            end
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, 800)
            and J.CanCastOnNonMagicImmune(enemy)
            and bot:WasRecentlyDamagedByHero(enemy, 3.0)
            and not enemy:HasModifier('modifier_ringmaster_impalement_bleed')
            and not X.IsUnitBetweenMeAndLocation(bot, enemy, enemy:GetLocation(), nRadius)
            then
                return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 + 0.15 then
        if DotaTime() > fImpaleArtsCastTime + nRestoreTime then
            for _, enemy in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemy)
                and J.CanBeAttacked(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and J.CanCastOnNonMagicImmune(enemy)
                and not enemy:HasModifier('modifier_ringmaster_impalement_bleed')
                and not enemy:HasModifier('modifier_abaddon_borrowed_time')
                and not enemy:HasModifier('modifier_dazzle_shallow_grave')
                and not enemy:HasModifier('modifier_oracle_false_promise_timer')
                then
                    local eta = (GetUnitToUnitDistance(bot, enemy) / nSpeed) + nCastPoint
                    local targetLoc = J.GetCorrectLoc(enemy, eta)
                    if not X.IsUnitBetweenMeAndLocation(bot, enemy, targetLoc, nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, targetLoc
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.25
        and not botTarget:HasModifier('modifier_ringmaster_impalement_bleed')
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSpotlight()
    if not J.CanCastAbility(Spotlight) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Spotlight:GetCastRange())
    local nCastPoint = Spotlight:GetCastPoint()
    local nRadius = Spotlight:GetSpecialValueInt('radius')
    local nDuration = Spotlight:GetSpecialValueInt('duration')
    local nManaCost = Spotlight:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TameTheBeasts, EscapeAct, ImpalementArts, WheelOfWonder})

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(false, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeAlly = J.GetAlliesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeAlly >= 2 and fManaAfter > fManaThreshold1 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    for _, ally in pairs(nAllyHeroes) do
        if J.IsValidHero(ally)
        and J.CanBeAttacked(ally)
        and J.IsInRange(bot, ally, nCastRange)
        and not J.IsRealInvisible(ally)
        and not ally:IsIllusion()
        and not ally:HasModifier('modifier_abaddon_borrowed_time')
        and not ally:HasModifier('modifier_dazzle_shallow_grave')
        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
        and not ally:HasModifier('modifier_fountain_aura_buff')
        then
            local allyHP = J.GetHP(ally)

            if (ally:HasModifier('modifier_legion_commander_duel'))
            or (ally:HasModifier('modifier_enigma_black_hole_pull'))
            or (ally:HasModifier('modifier_faceless_void_chronosphere_freeze'))
            then
                return BOT_ACTION_DESIRE_HIGH, ally:GetLocation()
            end

            if ally:WasRecentlyDamagedByAnyHero(2.0) then
                if J.IsDisabled(ally)
                or allyHP < 0.25
                then
                    return BOT_ACTION_DESIRE_HIGH, ally:GetLocation()
                end
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderWheelOfWonder()
    if not J.CanCastAbility(WheelOfWonder) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, WheelOfWonder:GetCastRange())
    local nCastPoint = WheelOfWonder:GetCastPoint()
    local nRadius = WheelOfWonder:GetSpecialValueInt('mesmerize_radius')
    local nSpeed = WheelOfWonder:GetSpecialValueInt('projectile_speed')

    if J.IsInTeamFight(bot, 1600) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

-- Souvenirs

function X.ConsiderFunhouseMirror()
    if not J.CanCastAbility(FunhouseMirror)
    or J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 350)
        or J.IsUnitTargetProjectileIncoming(bot, 350)
        or J.IsWillBeCastUnitTargetSpell(bot, 300)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 300)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderStrongmanTonic()
    if not J.CanCastAbility(StrongmanTonic) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, StrongmanTonic:GetCastRange())

    for _, ally in pairs(nAllyHeroes) do
        if J.IsValidHero(ally)
        and J.CanBeAttacked(ally)
        and J.IsInRange(bot, ally, nCastRange)
        and not ally:IsIllusion()
        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local allyHP = J.GetHP(ally)
            local allyTarget = ally:GetAttackTarget()

            if (allyHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(3.0))
            or (allyHP < 0.3 and bot:WasRecentlyDamagedByCreep(3.0))
            or (allyHP < 0.3 and bot:WasRecentlyDamagedByTower(3.0))
            then
                return BOT_ACTION_DESIRE_HIGH, ally
            end

            if J.IsRoshan(allyTarget) or J.IsTormentor(allyTarget) then
                if J.IsInRange(ally, allyTarget, 800) and allyHP < 0.3 then
                    return BOT_ACTION_DESIRE_HIGH, ally
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWhoopeeCushion()
    if not J.CanCastAbility(WhoopeeCushion) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nLeapDistance = WhoopeeCushion:GetSpecialValueInt('leap_distance')
    local nFartRadius = WhoopeeCushion:GetSpecialValueInt('fart_cloud_radius')

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nFartRadius)
        and J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nFartRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            and bot:IsFacingLocation(J.GetTeamFountain(), 25)
			and not J.IsDisabled(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCrystallBall()
    if not J.CanCastAbility(CrystalBall)
    or not J.IsHumanPlayerInTeam()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    if not J.IsEarlyGame() and J.IsRoshanAlive() then
        local nMissingEnemyCount = 0
        for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
            if IsHeroAlive(id) then
                local info = GetHeroLastSeenInfo(id)
                if info ~= nil then
                    local dInfo = info[1]
                    if dInfo ~= nil and dInfo.time_since_seen > 10 then
                        nMissingEnemyCount = nMissingEnemyCount + 1
                    end
                end
            end
        end

        local vRoshanLocation = J.GetCurrentRoshanLocation()
        local nAllyInLocation = J.GetAlliesNearLoc(vRoshanLocation, 2500)

        if nMissingEnemyCount >= 4 and not IsLocationVisible(vRoshanLocation) and #nAllyInLocation == 0 then
            return BOT_ACTION_DESIRE_HIGH, vRoshanLocation
        end
    else
        -- Roll the others
        if J.IsGoingOnSomeone(bot) then
            if J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, 800)
            and not J.IsChasingTarget(botTarget)
            and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end

        if J.IsGoingToRune(bot) then
            if bot.rune and bot.rune.location and GetUnitToLocationDistance(bot, bot.rune.location) > bot:GetCurrentVisionRange() then
                local nAllyInLocation = J.GetAlliesNearLoc(bot.rune.location, bot:GetCurrentVisionRange())
                if #nAllyInLocation == 0 and not IsLocationVisible(bot.rune.location) then
                    return BOT_ACTION_DESIRE_HIGH, bot.rune.location
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderWeightedPie()
    if not J.CanCastAbility(WeightedPie) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, WeightedPie:GetCastRange())

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsInRange(bot, botTarget, 300)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderUnicycle()
    if not J.CanCastAbility(Unicycle)
    or bot:HasModifier('modifier_bloodseeker_rupture')
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:IsFacingLocation(J.GetTeamFountain(), 45) and bot:WasRecentlyDamagedByAnyHero(2.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and J.IsChasingTarget(enemyHero, bot)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.IsUnitBetweenMeAndLocation(hSource, hTarget, vLocation, nRadius)
	local vStart = hSource:GetLocation()
	local vEnd = vLocation

	for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES)) do
		if  J.IsValid(unit)
        and (unit:IsHero() or unit:IsCreep())
		and hSource ~= unit
		and hTarget ~= unit
		then
			local tResult = PointToLineDistance(vStart, vEnd, unit:GetLocation())
			if tResult ~= nil and tResult.within and tResult.distance <= nRadius then return true end
		end
	end

	return false
end

return X