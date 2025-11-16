local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local M = require( GetScriptDirectory()..'/FunLib/aba_modifiers' )

if GetBot():GetUnitName() == 'npc_dota_hero_invoker'
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,1,2,1,2,3,3,3,3,3,3,3,2,2,1,1,1},
                [2] = {3,1,3,1,3,2,3,1,3,1,3,2,3,2,2,2,2,2,1,1,1},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_circlet",
                "item_mantle",
                "item_faerie_fire",
            
                "item_bottle",
                "item_magic_wand",
                "item_boots",
                "item_null_talisman",
                "item_hand_of_midas",
                "item_orchid",
                "item_travel_boots",
                "item_black_king_bar",--
                "item_sheepstick",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_shivas_guard",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_sheepstick",
                "item_bottle", "item_ultimate_scepter",
                "item_hand_of_midas", "item_shivas_guard",
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
                [1] = {2,1,2,1,2,1,2,1,2,3,3,3,3,3,3,3,2,2,1,1,1},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_circlet",
                "item_mantle",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_null_talisman",
                "item_force_staff",
                "item_ancient_janggo",
                "item_black_king_bar",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_octarine_core",--
                "item_lotus_orb",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_octarine_core",
                "item_null_talisman", "item_lotus_orb",
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
                [1] = {2,1,2,1,2,1,2,1,2,3,3,3,3,3,3,3,2,2,1,1,1},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_circlet",
                "item_mantle",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_null_talisman",
                "item_force_staff",
                "item_mekansm",
                "item_black_king_bar",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_octarine_core",--
                "item_lotus_orb",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_octarine_core",
                "item_null_talisman", "item_lotus_orb",
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

local Quas      = bot:GetAbilityByName('invoker_quas')
local Wex       = bot:GetAbilityByName('invoker_wex')
local Exort     = bot:GetAbilityByName('invoker_exort')
local Invoke    = bot:GetAbilityByName('invoker_invoke')

local ColdSnap          = bot:GetAbilityByName('invoker_cold_snap')
local GhostWalk         = bot:GetAbilityByName('invoker_ghost_walk')
local Tornado           = bot:GetAbilityByName('invoker_tornado')
local EMP               = bot:GetAbilityByName('invoker_emp')
local Alacrity          = bot:GetAbilityByName('invoker_alacrity')
local ChaosMeteor       = bot:GetAbilityByName('invoker_chaos_meteor')
local Sunstrike         = bot:GetAbilityByName('invoker_sun_strike')
local ForgeSpirit       = bot:GetAbilityByName('invoker_forge_spirit')
local IceWall           = bot:GetAbilityByName('invoker_ice_wall')
local DeafeningBlast    = bot:GetAbilityByName('invoker_deafening_blast')

local ColdSnapDesire, ColdSnapTarget
local GhostWalkDesire
local TornadoDesire, TornadoLocation
local EMPDesire, EMPLocation
local AlacrityDesire, AlacrityTarget
local ChaosMeteorDesire, ChaosMeteorLocation
local SunstrikeDesire, SunstrikeLocation
local ForgeSpiritDesire
local IceWallDesire, IceWallLocation
local DeafeningBlastDesire, DeafeningBlastLocation

local nAllyHeroes, nEnemyHeroes
local botTarget
local botName, botHP, botMP
local bAttacking

local vRoshanLocation = nil
local vTormentorLocation = nil

local bCanCataclysm = false
local bCanIceFloe = true

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Quas      = bot:GetAbilityByName('invoker_quas')
    Wex       = bot:GetAbilityByName('invoker_wex')
    Exort     = bot:GetAbilityByName('invoker_exort')
    Invoke    = bot:GetAbilityByName('invoker_invoke')

    ColdSnap          = bot:GetAbilityByName('invoker_cold_snap')
    GhostWalk         = bot:GetAbilityByName('invoker_ghost_walk')
    Tornado           = bot:GetAbilityByName('invoker_tornado')
    EMP               = bot:GetAbilityByName('invoker_emp')
    Alacrity          = bot:GetAbilityByName('invoker_alacrity')
    ChaosMeteor       = bot:GetAbilityByName('invoker_chaos_meteor')
    Sunstrike         = bot:GetAbilityByName('invoker_sun_strike')
    ForgeSpirit       = bot:GetAbilityByName('invoker_forge_spirit')
    IceWall           = bot:GetAbilityByName('invoker_ice_wall')
    DeafeningBlast    = bot:GetAbilityByName('invoker_deafening_blast')

    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    botTarget = J.GetProperTarget(bot)
    botName = bot:GetUnitName()
    botHP = J.GetHP(bot)
    botMP = J.GetMP(bot)
    bAttacking = J.IsAttacking(bot)

    vRoshanLocation = J.GetCurrentRoshanLocation()
    vTormentorLocation = J.GetTormentorLocation(GetTeam())

    ConsiderFirstSpell()

    GhostWalkDesire = X.ConsiderGhostWalk()
    if GhostWalkDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(GhostWalk)
        then
            InvokeSpell(Quas, Quas, Wex)
        end

        bot:ActionQueue_UseAbility(GhostWalk)
        return
    end

    ColdSnapDesire, ColdSnapTarget = X.ConsiderColdSnap()
    if ColdSnapDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if not IsAbilityActive(ColdSnap)
        then
            InvokeSpell(Quas, Quas, Quas)
        end

        bot:ActionQueue_UseAbilityOnEntity(ColdSnap, ColdSnapTarget)
        return
    end

    TornadoDesire, TornadoLocation = X.ConsiderTornado()
    if TornadoDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(Tornado)
        then
            InvokeSpell(Wex, Wex, Quas)
        end

        bot:ActionQueue_UseAbilityOnLocation(Tornado, TornadoLocation)
        return
    end

    EMPDesire, EMPLocation = X.ConsiderEMP()
    if EMPDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(EMP)
        then
            InvokeSpell(Wex, Wex, Wex)
        end

        bot:ActionQueue_UseAbilityOnLocation(EMP, EMPLocation)
        return
    end

    ChaosMeteorDesire, ChaosMeteorLocation = X.ConsiderChaosMeteor()
    if ChaosMeteorDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if not IsAbilityActive(ChaosMeteor)
        then
            InvokeSpell(Exort, Exort, Wex)
        end

        bot:ActionQueue_UseAbilityOnLocation(ChaosMeteor, ChaosMeteorLocation)
        return
    end

    SunstrikeDesire, SunstrikeLocation = X.ConsiderSunstrike()
    if SunstrikeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if not IsAbilityActive(Sunstrike)
        then
            InvokeSpell(Exort, Exort, Exort)
        end

        if bot:HasScepter() and bCanCataclysm
        then
            bot:ActionQueue_UseAbilityOnEntity(Sunstrike, bot)
        else
            bot:ActionQueue_UseAbilityOnLocation(Sunstrike, SunstrikeLocation)
        end
        return
    end

    AlacrityDesire, AlacrityTarget = X.ConsiderAlacrity()
    if AlacrityDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(Alacrity)
        then
            InvokeSpell(Wex, Wex, Exort)
        end

        bot:ActionQueue_UseAbilityOnEntity(Alacrity, AlacrityTarget)
        return
    end

    DeafeningBlastDesire, DeafeningBlastLocation = X.ConsiderDeafeningBlast()
    if DeafeningBlastDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if not IsAbilityActive(DeafeningBlast)
        then
            InvokeSpell(Quas, Wex, Exort)
        end

        bot:ActionQueue_UseAbilityOnLocation(DeafeningBlast, DeafeningBlastLocation)
        return
    end

    IceWallDesire, IceWallLocation = X.ConsiderIceWall()
    if IceWallDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(IceWall)
        then
            InvokeSpell(Quas, Quas, Exort)
        end

        if bot:HasScepter() and bCanIceFloe then
            bot:ActionQueue_UseAbilityOnLocation(IceWall, IceWallLocation)
        else
            bot:ActionQueue_UseAbility(IceWall)
        end
        return
    end

    ForgeSpiritDesire = X.ConsiderForgeSpirit()
    if ForgeSpiritDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(ForgeSpirit)
        then
            InvokeSpell(Exort, Exort, Quas)
        end

        bot:ActionQueue_UseAbility(ForgeSpirit)
        return
    end

    if string.find(botName, 'invoker') then
        if J.CanCastAbility(Invoke) then
            if not J.IsEarlyGame() and J.IsPushing(bot) and #nAllyHeroes >= 2 then
                if J.CanCastAbility(Quas) and J.CanCastAbility(Wex) then
                    if not IsAbilityActive(Tornado) and X.CanCastAbility(Tornado) then
                        bot:Action_ClearActions(false)
                        InvokeSpell(Wex, Wex, Quas)
                        return
                    end
                    if not IsAbilityActive(EMP) and X.CanCastAbility(EMP) then
                        bot:Action_ClearActions(false)
                        InvokeSpell(Wex, Wex, Wex)
                        return
                    end
                end
            else
                if J.IsRetreating(bot) and #nEnemyHeroes == 0 then
                    if J.CanCastAbility(Quas) and J.CanCastAbility(Wex) then
                        if not IsAbilityActive(GhostWalk) and X.CanCastAbility(GhostWalk) then
                            bot:Action_ClearActions(false)
                            InvokeSpell(Quas, Quas, Wex)
                            return
                        end
                    end
                end

                if J.IsInLaningPhase() then
                    if J.CanCastAbility(Exort) then
                        if not IsAbilityActive(Sunstrike) and X.CanCastAbility(Sunstrike) then
                            bot:Action_ClearActions(false)
                            InvokeSpell(Exort, Exort, Exort)
                            return
                        end
                    end
                end
            end
        end
    end
end

function X.ConsiderColdSnap()
    if not X.CanCastAbility(ColdSnap) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = ColdSnap:GetCastRange()

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and enemyHero:IsChanneling()
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingRoshan(bot) and botMP > 0.65 then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGhostWalk()
    if not X.CanCastAbility(GhostWalk) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsRealInvisible(bot) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nManaCost = GhostWalk:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

	if	bot:DistanceFromFountain() > 600
    and J.CanBeAttacked(bot)
	then
		if bot:IsSilenced()
        or bot:IsRooted()
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        if not bot:IsMagicImmune() then
            if (J.IsStunProjectileIncoming(bot, 500))
            or (J.IsUnitTargetProjectileIncoming(bot, 500))
            or (J.IsWillBeCastUnitTargetSpell(bot, 500) and not bot:HasModifier('modifier_sniper_assassinate') and bot:WasRecentlyDamagedByAnyHero(2.0))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

        if J.IsRetreating(bot) then
            if J.IsValidHero(nInRangeEnemy[1]) then
                if (bot:WasRecentlyDamagedByAnyHero(2.0) and J.IsChasingTarget(nInRangeEnemy[1], bot))
                or ((botHP < 0.5 or #nInRangeEnemy > #nInRangeAlly) and nInRangeEnemy[1]:GetAttackTarget() == bot)
                or (#nInRangeEnemy > #nInRangeAlly and (botHP < 0.5 + (0.1 * #nInRangeEnemy)))
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) and fManaAfter > 0.5 then
        if GetUnitToLocationDistance(bot, vRoshanLocation) > 3200 and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) and fManaAfter > 0.5 then
        if GetUnitToLocationDistance(bot, vTormentorLocation) > 3200 and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTornado()
    if not X.CanCastAbility(Tornado)
    or (EMP and (EMP:GetCooldown() - EMP:GetCooldownTimeRemaining()) <= 0.05 + 2.9)
    or (ChaosMeteor and (ChaosMeteor:GetCooldown() - ChaosMeteor:GetCooldownTimeRemaining()) <= 0.05 + 1.3)
    or (Sunstrike and (Sunstrike:GetCooldown() - Sunstrike:GetCooldownTimeRemaining()) <= 0.05 + 1.7)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = Tornado:GetCastRange()
    local nCastPoint = Tornado:GetCastPoint()
	local nRadius = Tornado:GetSpecialValueInt('area_of_effect')
	local nSpeed = Tornado:GetSpecialValueInt('travel_speed')
    local nBaseDamage = Tornado:GetSpecialValueInt('base_damage')
    local nDamage = Tornado:GetSpecialValueInt('wex_damage') + nBaseDamage
    local nManaCost = Tornado:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

    if string.find(botName, 'invoker') then
        nDamage = Tornado:GetSpecialValueInt('wex_damage') + (Wex:GetLevel() - 1) * 45 + nBaseDamage
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nDelay then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            elseif enemyHero:IsChanneling() and fManaAfter > 0.3 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay)
            and J.CanBeAttacked(enemyHero)
            and not J.IsInRange(bot, enemyHero, 700)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 550)
                if #nInRangeAlly == 0 or #J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero) <= 1 then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
                end
            end

            if J.IsChasingTarget(enemyHero, bot) and not J.IsInTeamFight(bot, 1200) then
                if enemyHero:HasModifier('modifier_monkey_king_quadruple_tap_bonuses')
                or bot:HasModifier('modifier_ursa_fury_swipes_damage_increase')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_invoker_tornado')
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
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() * 0.8)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_invoker_tornado')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not (#nAllyHeroes >= #nEnemyHeroes + 2)
		then
            if (J.IsChasingTarget(bot, botTarget) and #J.GetAlliesNearLoc(botTarget:GetLocation(), 500) <= 1) then
                local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
            end
		end

        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsChasingTarget(bot, enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_invoker_tornado')
            then
                if enemyHero:HasModifier('modifier_ursa_enrage')
                or enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                or enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
                or enemyHero:HasModifier('modifier_muerta_pierce_the_veil_buff')
                then
                    local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
                end
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_invoker_tornado')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                if (bot:IsRooted() and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0))
                or (botHP < 0.75)
                or (#nEnemyHeroes > #nAllyHeroes)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > 0.5 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(2.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_invoker_tornado')
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), allyHero:GetLocation(), nRadius * 2)
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > 0.55 then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_invoker_tornado')
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 600)
                    if #nInRangeAlly <= 1 then
                        count = count + 1
                    end
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

        if nLocationAoE.count >= 4 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if #nEnemyHeroes == 0 and fManaAfter > 0.4 and #nAllyHeroes <= 1 and not bot:HasModifier('modifier_invoker_alacrity') then
        local nEnemyCreeps = bot:GetNearbyCreeps(1000, true)
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and J.CanCastOnTargetAdvanced(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEMP()
    if not X.CanCastAbility(EMP) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, EMP:GetCastRange())
    local nCastPoint = EMP:GetCastPoint()
	local nRadius = EMP:GetSpecialValueInt('area_of_effect')
    local nDelay = EMP:GetSpecialValueFloat('delay')

	if J.IsInTeamFight(bot, 1300) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_invoker_tornado')
                and enemyHero:GetMana() > 0
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
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and botTarget:GetMana() > 0
		then
            for i = 0, botTarget:NumModifiers() do
                local sModifierName = botTarget:GetModifierName(i)
                if sModifierName then
                    local fRemainingDuration = botTarget:GetModifierRemainingDuration(i)
                    if M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                        if fRemainingDuration < nDelay and fRemainingDuration > nDelay / 2 then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    elseif sModifierName and M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                        if fRemainingDuration > nDelay then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    elseif sModifierName and M['hexed'] and M['hexed'][sModifierName] then
                        if fRemainingDuration > nDelay then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    elseif sModifierName and M['rooted'] and M['rooted'][sModifierName] then
                        if fRemainingDuration > nDelay then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    elseif sModifierName and M['stunned'] and M['stunned'][sModifierName] then
                        if fRemainingDuration > nDelay then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    end
                end
            end

            if (not J.IsChasingTarget(bot, botTarget) or botTarget:GetCurrentMovementSpeed() <= 200) then
                if J.GetMP(botTarget) > 0.5 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not enemyHero:HasModifier('modifier_invoker_tornado')
            and enemyHero:GetMana() > 0
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 800)
                if J.IsChasingTarget(enemyHero, bot)
                and ((J.GetMP(enemyHero) > 0.4 and #nInRangeEnemy <= 1)
                    or #nInRangeEnemy >= 2)
                then
                    if math.abs(nDelay - (GetUnitToUnitDistance(bot, enemyHero) / enemyHero:GetCurrentMovementSpeed()) + nCastPoint) <= 0.5 then
                        return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
                    end
                end

                if not J.IsChasingTarget(enemyHero, bot)
                and ((J.GetMP(enemyHero) > 0.4 and #nInRangeEnemy <= 1) or #nInRangeEnemy >= 2)
                and botHP < 0.65 and bot:WasRecentlyDamagedByAnyHero(3.0)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end

                if bot:IsRooted() and J.IsInRange(bot, enemyHero, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAlacrity()
    if not X.CanCastAbility(Alacrity) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Alacrity:GetCastRange())
    local nManaCost = Alacrity:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

    local hAlacrityTarget = nil
	local nAlacrityTargetDamage = 0
	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not J.IsRetreating(allyHero)
        and not allyHero:IsIllusion()
        and not J.IsDisabled(allyHero)
        and not J.IsWithoutTarget(allyHero)
        and not allyHero:HasModifier('modifier_invoker_alacrity')
		then
            local allyHeroDamage = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
            if allyHeroDamage > nAlacrityTargetDamage then
                hAlacrityTarget = allyHero
                nAlacrityTargetDamage = allyHeroDamage
            end
		end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            if hAlacrityTarget ~= nil then
                if hAlacrityTarget == bot and J.IsInRange(bot, botTarget, 800) then
                    return BOT_ACTION_DESIRE_HIGH, hAlacrityTarget
                end

                if hAlacrityTarget ~= bot and J.IsCore(hAlacrityTarget) and J.IsInRange(hAlacrityTarget, botTarget, 800) then
                    return BOT_ACTION_DESIRE_HIGH, hAlacrityTarget
                end
            end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(bot:GetAttackRange() + 300, 1600), true)

	if (J.IsPushing(bot) or J.IsDefending(bot)) then
		if #nEnemyCreeps >= 4
        and J.CanBeAttacked(nEnemyCreeps[1])
        and bAttacking
        and fManaAfter > 0.4
        and #nAllyHeroes <= 2
        and not bot:HasModifier('modifier_invoker_alacrity')
        then
			return BOT_ACTION_DESIRE_HIGH, bot
		end

        if hAlacrityTarget then
            local hAttackTarget = hAlacrityTarget:GetAttackTarget()

            if J.IsValidBuilding(hAttackTarget)
            and J.CanBeAttacked(hAttackTarget)
            and bAttacking
            and fManaAfter > 0.5
            and not hAttackTarget:HasModifier('modifier_invoker_alacrity')
            then
                return BOT_ACTION_DESIRE_HIGH, hAlacrityTarget
            end
        end
	end

    if J.IsFarming(bot) and bAttacking and fManaAfter > 0.35 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() > 1000)
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if hAlacrityTarget then
        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, 800)
            and J.IsAttacking(hAlacrityTarget)
            and fManaAfter > 0.4
            then
                return BOT_ACTION_DESIRE_HIGH, hAlacrityTarget
            end
        end

        if  J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, 800)
            and J.IsAttacking(hAlacrityTarget)
            and fManaAfter > 0.4
            then
                return BOT_ACTION_DESIRE_HIGH, hAlacrityTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderChaosMeteor()
    if not X.CanCastAbility(ChaosMeteor) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, ChaosMeteor:GetCastRange())
    local nCastPoint = ChaosMeteor:GetCastPoint()
    local nRadius = ChaosMeteor:GetSpecialValueInt('area_of_effect')
    local nLandTime = ChaosMeteor:GetSpecialValueFloat('land_time')
    local nTravelSpeed = ChaosMeteor:GetSpecialValueFloat('travel_speed')
    local nDamage = ChaosMeteor:GetSpecialValueInt('main_damage')
    local nBurnDPS = ChaosMeteor:GetSpecialValueInt('burn_dps')

    if string.find(botName, 'invoker') then
        nDamage = ChaosMeteor:GetSpecialValueInt('main_damage') + (Exort:GetLevel() - 1) * 45
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsRunning(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    for i = 0, enemyHero:NumModifiers() do
                        local sModifierName = enemyHero:GetModifierName(i)
                        if sModifierName then
                            local fRemainingDuration = enemyHero:GetModifierRemainingDuration(i)
                            if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                                if fRemainingDuration > nLandTime then
                                    count = count + 1
                                end
                            elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                                if fRemainingDuration < nLandTime and fRemainingDuration > nLandTime/2 then
                                    count = count + 1
                                end
                            elseif M['hexed'] and M['hexed'][sModifierName] then
                                if fRemainingDuration > nLandTime then
                                    count = count + 1
                                end
                            elseif M['rooted'] and M['rooted'][sModifierName] then
                                if fRemainingDuration > nLandTime then
                                    count = count + 1
                                end
                            elseif M['stunned'] and M['stunned'][sModifierName] then
                                if fRemainingDuration > nLandTime then
                                    count = count + 1
                                end
                            end
                        end
                    end

                    if enemyHero:GetCurrentMovementSpeed() <= 200 and not enemyHero:IsHexed()
                    or enemyHero:HasModifier('modifier_legion_commander_duel')
                    then
                        count = count + 1
                    end
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.15
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

            if #nInRangeEnemy <= 1 and not J.IsCore(botTarget) and J.IsLateGame() then
                return BOT_ACTION_DESIRE_NONE, 0
            end

            if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                for i = 0, botTarget:NumModifiers() do
                    local sModifierName = botTarget:GetModifierName(i)
                    if sModifierName then
                        local fRemainingDuration = botTarget:GetModifierRemainingDuration(i)
                        if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                            if fRemainingDuration > nLandTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                            if fRemainingDuration < nLandTime and fRemainingDuration > nLandTime/2 then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['hexed'] and M['hexed'][sModifierName] then
                            if fRemainingDuration > nLandTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['rooted'] and M['rooted'][sModifierName] then
                            if fRemainingDuration > nLandTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        elseif M['stunned'] and M['stunned'][sModifierName] then
                            if fRemainingDuration > nLandTime then
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        end
                    end
                end

                if (not J.IsChasingTarget(bot, botTarget) and not J.IsChasingTarget(botTarget, bot))
                or (J.IsChasingTarget(bot, botTarget) and botTarget:GetCurrentMovementSpeed() <= 200)
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    if J.IsDoingRoshan(bot) and botMP > 0.6 then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.4
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)

    if botMP > 0.55 then
        for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage + nBurnDPS*2.5)
                if nLocationAoE.count >= 5 then
                    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, 1200)
                    if #nInRangeAlly <= 2 and #nInRangeEnemy <= 1 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSunstrike()
    if not X.CanCastAbility(Sunstrike) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastPoint = Sunstrike:GetCastPoint()
    local nDelay = Sunstrike:GetSpecialValueFloat('delay')
    local nRadius = Sunstrike:GetSpecialValueFloat('area_of_effect')
    local nDamage = Sunstrike:GetSpecialValueInt('damage')

    if string.find(botName, 'invoker') then
        nDamage = Sunstrike:GetSpecialValueInt('damage') + (Exort:GetLevel() - 1) * 50
    end

    if bot:HasScepter() and bCanCataclysm then
        local nTeamFightLocation = J.GetTeamFightLocation(bot)
        local nNotMovingEnemyCount = 0
        if nTeamFightLocation ~= nil then
            local nInRangeEnemy = J.GetEnemiesNearLoc(nTeamFightLocation, 3200)
			for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsRunning(enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    for i = 0, enemyHero:NumModifiers() do
                        local sModifierName = enemyHero:GetModifierName(i)
                        if sModifierName then
                            local fRemainingDuration = enemyHero:GetModifierRemainingDuration(i)
                            if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                                if fRemainingDuration < nDelay and fRemainingDuration > nDelay/2 then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['hexed'] and M['hexed'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['rooted'] and M['rooted'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['stunned'] and M['stunned'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            end
                        end
                    end

                    if enemyHero:GetCurrentMovementSpeed() <= 200 and not enemyHero:IsHexed()
                    or enemyHero:HasModifier('modifier_invoker_deafening_blast_knockback')
                    then
                        nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                    end
                end
			end

			if nNotMovingEnemyCount >= 2 then
				return BOT_ACTION_DESIRE_HIGH, 0
			end
		end

        nNotMovingEnemyCount = 0
        local unitList = GetUnitList(UNIT_LIST_ENEMY_HEROES)
		for _, enemyHero in pairs(unitList) do
			if  J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
			then
                if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE, nDelay) then
                    for i = 0, enemyHero:NumModifiers() do
                        local sModifierName = enemyHero:GetModifierName(i)
                        if sModifierName then
                            local fRemainingDuration = enemyHero:GetModifierRemainingDuration(i)
                            if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                                if fRemainingDuration < nDelay and fRemainingDuration > nDelay/2 then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['hexed'] and M['hexed'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['rooted'] and M['rooted'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            elseif M['stunned'] and M['stunned'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                                end
                            end
                        end
                    end
                end
			end
		end

        if nNotMovingEnemyCount >= 3 then
            return BOT_ACTION_DESIRE_HIGH, 0
        end
	else
        local unitList = GetUnitList(UNIT_LIST_ENEMY_HEROES)
		for _, enemyHero in pairs(unitList) do
			if  J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
			then
                local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)

                if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE, nDelay) then
                    for i = 0, enemyHero:NumModifiers() do
                        local sModifierName = enemyHero:GetModifierName(i)
                        if sModifierName then
                            local fRemainingDuration = enemyHero:GetModifierRemainingDuration(i)
                            if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                                if fRemainingDuration < nDelay and fRemainingDuration > nDelay/2 then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['hexed'] and M['hexed'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['rooted'] and M['rooted'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['stunned'] and M['stunned'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            end
                        end
                    end

                    if enemyHero:HasModifier('modifier_winter_wyvern_cold_embrace') then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end

                    if not J.IsRunning(enemyHero) or enemyHero:GetCurrentMovementSpeed() <= 200 then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
                    end
                end

                if #nAllyHeroesTargetingTarget >= 1 and J.GetHP(enemyHero) < 0.5 then
                    for i = 0, enemyHero:NumModifiers() do
                        local sModifierName = enemyHero:GetModifierName(i)
                        if sModifierName then
                            local fRemainingDuration = enemyHero:GetModifierRemainingDuration(i)
                            if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                                if fRemainingDuration < nDelay and fRemainingDuration > nDelay/2 then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['hexed'] and M['hexed'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['rooted'] and M['rooted'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            elseif M['stunned'] and M['stunned'][sModifierName] then
                                if fRemainingDuration > nDelay then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                                end
                            end
                        end
                    end
                end

                if #nAllyHeroesTargetingTarget >= 2 and enemyHero:HasModifier('modifier_winter_wyvern_cold_embrace') then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
			end
		end

        for i = 1, 5 do
            local member = GetTeamMember(i)
            if J.IsValidHero(member) and J.IsGoingOnSomeone(member) then
                local hTarget = member:GetAttackTarget()
                if J.IsValidHero(hTarget)
                and not J.IsSuspiciousIllusion(hTarget)
                and not hTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not hTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not hTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                and not hTarget:HasModifier('modifier_oracle_false_promise_timer')
                and not hTarget:HasModifier('modifier_item_aeon_disk_buff')
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(hTarget:GetLocation(), 1200)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(hTarget:GetLocation(), 1200)
                    if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                        for j = 0, hTarget:NumModifiers() do
                            local sModifierName = hTarget:GetModifierName(j)
                            if sModifierName then
                                local fRemainingDuration = hTarget:GetModifierRemainingDuration(i)
                                if M['stunned_unique'] and M['stunned_unique'][sModifierName] then
                                    if fRemainingDuration > nDelay then
                                        return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                                    end
                                elseif M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName] then
                                    if fRemainingDuration < nDelay and fRemainingDuration > nDelay/2 then
                                        return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                                    end
                                elseif M['hexed'] and M['hexed'][sModifierName] then
                                    if fRemainingDuration > nDelay then
                                        return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                                    end
                                elseif M['rooted'] and M['rooted'][sModifierName] then
                                    if fRemainingDuration > nDelay then
                                        return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                                    end
                                elseif M['stunned'] and M['stunned'][sModifierName] then
                                    if fRemainingDuration > nDelay then
                                        return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                                    end
                                end
                            end
                        end
                    end

                    if not J.IsChasingTarget(member, hTarget) and not J.IsRunning(hTarget) and J.GetHP(hTarget) < 0.5 then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(hTarget, nDelay)
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderForgeSpirit()
    if not X.CanCastAbility(ForgeSpirit) then
        return BOT_ACTION_DESIRE_NONE
    end

	local botAttackrange = bot:GetAttackRange()
    local nManaCost = ForgeSpirit:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackrange + 300)
        and J.GetHP(botTarget) > 0.4
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

            if not (#nAllyHeroes >= #nEnemyHeroes + 1) and bAttacking then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > 0.5 and #nAllyHeroes <= 3 and #nEnemyHeroes <= 1 and not bot:HasModifier('modifier_invoker_alacrity') then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > 0.5 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > 0.4 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 2)
            or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep())
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackrange + 300)
        and J.GetHP(botTarget) > 0.4
        and bAttacking
        and fManaAfter > 0.4
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackrange + 300)
        and bAttacking
        and fManaAfter > 0.3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderIceWall()
    if not X.CanCastAbility(IceWall) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nSpawnDistance = IceWall:GetSpecialValueInt('wall_place_distance')
    local nManaCost = IceWall:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

    if bot:HasScepter() and bCanIceFloe then
        local nCastRange = 600
        local nRadius = 150

        if J.IsInTeamFight(bot, 1200) then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            if #nInRangeEnemy >= 2 then
                local count = 0
                for _, enemyHero in ipairs(nInRangeEnemy) do
                    if J.IsValidHero(enemyHero)
                    and not J.CanCastOnNonMagicImmune(enemyHero)
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
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
            and not J.IsChasingTarget(bot, botTarget)
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if not (#nAllyHeroes >= #nEnemyHeroes + 2) and fManaAfter > 0.4 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
        end

        if J.IsRetreating(bot)
        and not J.IsRealInvisible(bot)
        and not J.IsInTeamFight(bot, 1200)
        then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsInRange(bot, enemyHero, 1200)
                and not J.IsInRange(bot, enemyHero, 500)
                and J.IsChasingTarget(enemyHero, bot)
                then
                    return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
                end
            end
        end
    else
        if J.IsInTeamFight(bot, 1200) then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nSpawnDistance, nSpawnDistance, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nSpawnDistance)
            if bot:IsFacingLocation(nLocationAoE.targetloc, 30) and #nInRangeEnemy >= 2 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidTarget(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, nSpawnDistance)
            and bot:IsFacingLocation(botTarget:GetLocation(), 15)
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if not (#nAllyHeroes >= #nEnemyHeroes + 2) and fManaAfter > 0.4 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end

        if J.IsRetreating(bot)
        and not J.IsRealInvisible(bot)
        and not J.IsInTeamFight(bot, 1200)
        then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsInRange(bot, enemyHero, 600)
                and J.IsChasingTarget(enemyHero, bot)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDeafeningBlast()
    if not X.CanCastAbility(DeafeningBlast) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, DeafeningBlast:GetCastRange())
    local nCastPoint = DeafeningBlast:GetCastPoint()
    local nDamage = DeafeningBlast:GetSpecialValueInt('damage')
	local nRadius = DeafeningBlast:GetSpecialValueInt('radius_end')
    local nSpeed = DeafeningBlast:GetSpecialValueInt('travel_speed')

    if string.find(botName, 'invoker')
    then
        nDamage = DeafeningBlast:GetSpecialValueInt('damage') + (Exort:GetLevel() - 1) * 40
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsChasingTarget(bot, enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_invoker_tornado')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
		then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
		end
    end

    if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_invoker_tornado')
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
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
        and not botTarget:HasModifier('modifier_invoker_tornado')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if #nEnemyHeroes > #nAllyHeroes and (botMP > 0.5 or J.GetHP(botTarget) < 0.3) then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_invoker_tornado')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                if J.IsChasingTarget(enemyHero, bot) or bot:IsRooted() then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderFirstSpell()
    if bot:GetLevel() == 1
    then
        if Quas:IsTrained()
            and not IsAbilityActive(ColdSnap)
        then
            InvokeSpell(Quas, Quas, Quas)
        elseif Wex:IsTrained()
            and not IsAbilityActive(EMP)
        then
            InvokeSpell(Wex, Wex, Wex)
        elseif Exort:IsTrained()
            and not IsAbilityActive(Sunstrike)
        then
            InvokeSpell(Exort, Exort, Exort)
        end

        return
    end
end

function InvokeSpell(Orb1, Orb2, Orb3)
    bot:ActionQueue_UseAbility(Orb1)
    bot:ActionQueue_UseAbility(Orb2)
    bot:ActionQueue_UseAbility(Orb3)
    bot:ActionQueue_UseAbility(Invoke)
end

function DoOrbInstances(Orb1, Orb2, Orb3)
    bot:ActionPush_UseAbility(Orb1)
    bot:ActionPush_UseAbility(Orb2)
    bot:ActionPush_UseAbility(Orb3)
end

function IsAbilityActive(ability)
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        return true
    end

    if ability:IsHidden()
    or not ability:IsTrained()
    then
        return false
    end

    return true
end

function X.CanCastAbility(hAbility)
    if botName ~= 'npc_dota_hero_invoker' then
        return J.CanCastAbility(hAbility)
    end

    local abilities = {
        [ColdSnap] =        { req = { Quas } },
        [GhostWalk] =       { req = { Quas, Wex } },
        [Tornado] =         { req = { Quas, Wex } },
        [EMP] =             { req = { Wex } },
        [Alacrity] =        { req = { Wex, Exort } },
        [ChaosMeteor] =     { req = { Wex, Exort } },
        [Sunstrike] =       { req = { Exort } },
        [ForgeSpirit] =     { req = { Quas, Exort } },
        [IceWall] =         { req = { Quas, Exort } },
        [DeafeningBlast] =  { req = { Quas, Wex, Exort } },
    }

    if abilities[hAbility] and abilities[hAbility].req then
        for _, orb in pairs(abilities[hAbility].req) do
            if not J.CanCastAbility(orb) then
                return false
            end
        end
    end

	if hAbility == nil
	or hAbility:IsNull()
	or hAbility:GetName() == ''
	or hAbility:IsPassive()
    or not hAbility:IsTrained()
	or not hAbility:IsFullyCastable()
    or not hAbility:IsActivated()
	then
		return false
	end

    if not IsAbilityActive(hAbility) and not J.CanCastAbility(Invoke) then
        return false
    end

	return true
end

return X