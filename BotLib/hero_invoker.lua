local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

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
                "item_double_circlet",
            
                "item_bracer",
                "item_urn_of_shadows",
                "item_boots",
                "item_magic_wand",
                "item_spirit_vessel",
                "item_hand_of_midas",
                "item_orchid",
                "item_travel_boots",
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_octarine_core",--
                "item_bloodthorn",--
                "item_ultimate_scepter",
                "item_refresher",--
                "item_ultimate_scepter_2",
                "item_sheepstick",--
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet",
                "item_bracer",
                "item_magic_wand",
                "item_spirit_vessel",
                "item_hand_of_midas",
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
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
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
local IceWallDesire
local DeafeningBlastDesire, DeafeningBlastLocation

local ColdSnapCooldownTime          = 18
local GhostWalkCooldownTime         = 32
local TornadoCooldownTime           = 27
local EMPCooldownTime               = 27
local AlacrityCooldownTime          = 15
local ChaosMeteorCooldownTime       = 50
local SunstrikeCooldownTime         = 23
local ForgeSpiritCooldownTime       = 27
local IceWallCooldownTime           = 23
local DeafeningBlastCooldownTime    = 36

local ColdSnapCastedTime          = -100
local GhostWalkCastedTime         = -100
local TornadoCastedTime           = -100
local EMPCastedTime               = -100
local AlacrityCastedTime          = -100
local ChaosMeteorCastedTime       = -100
local SunstrikeCastedTime         = -100
local ForgeSpiritCastedTime       = -100
local IceWallCastedTime           = -100
local DeafeningBlastCastedTime    = -100

local EMPDelay
local TornadoLiftTime

local ComboDesire, ComboLocation

local botTarget
local botName

function X.SkillsComplement()
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

    botTarget = J.GetProperTarget(bot)
    botName = bot:GetUnitName()

    if EMP ~= nil
    then
        EMPDelay = EMP:GetSpecialValueFloat('delay')
    end

    if Tornado ~= nil
    then
        TornadoLiftTime = Tornado:GetSpecialValueFloat('lift_duration')
    end

    CheckForCooldownReductions()

    ConsiderFirstSpell()

    ComboDesire, ComboLocation = X.ConsiderCombo()
    if ComboDesire > 0
    then
        local shouldDelay = false
        local nInvokeDelay = 7 - (Quas:GetLevel() + Wex:GetLevel() + Exort:GetLevel()) * 0.3
        bot:Action_ClearActions(false)

        if not IsAbilityActive(Tornado)
        then
            InvokeSpell(Wex, Wex, Quas)
            bot:ActionQueue_UseAbilityOnLocation(Tornado, ComboLocation)
            shouldDelay = true
        else
            bot:ActionQueue_UseAbilityOnLocation(Tornado, ComboLocation)
            shouldDelay = false
        end

        TornadoCastedTime = DotaTime()

        if not IsAbilityActive(EMP)
        then
            if shouldDelay
            then
                bot:ActionQueue_Delay(nInvokeDelay)
            end

            InvokeSpell(Wex, Wex, Wex)
            bot:ActionQueue_Delay(0.05 + TornadoCastedTime + TornadoLiftTime - EMPDelay)
            bot:ActionQueue_UseAbilityOnLocation(EMP, ComboLocation)
            shouldDelay = true
        else
            bot:ActionQueue_Delay(0.05 + TornadoCastedTime + TornadoLiftTime - EMPDelay)
            bot:ActionQueue_UseAbilityOnLocation(EMP, ComboLocation)
            shouldDelay = false
        end

        EMPCastedTime = DotaTime()
        bot:ActionQueue_Delay(0.05)

        if not IsAbilityActive(ChaosMeteor)
        then
            if shouldDelay
            then
                bot:ActionQueue_Delay(nInvokeDelay)
            end

            InvokeSpell(Exort, Exort, Wex)
        end

        bot:ActionQueue_UseAbilityOnLocation(ChaosMeteor, ComboLocation)
        ChaosMeteorCastedTime = DotaTime()

        return
    end

    GhostWalkDesire = X.ConsiderGhostWalk()
    if GhostWalkDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(GhostWalk)
        then
            InvokeSpell(Quas, Quas, Wex)
        end

        bot:ActionQueue_UseAbility(GhostWalk)
        GhostWalkCastedTime = DotaTime()
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
        TornadoCastedTime = DotaTime()
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
        EMPCastedTime = DotaTime()
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
        ChaosMeteorCastedTime = DotaTime()
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
        ColdSnapCastedTime = DotaTime()
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
        AlacrityCastedTime = DotaTime()
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

        if bot:HasScepter()
        then
            bot:ActionQueue_UseAbilityOnEntity(Sunstrike, bot)
        else
            bot:ActionQueue_UseAbilityOnLocation(Sunstrike, SunstrikeLocation)
        end

        SunstrikeCastedTime = DotaTime()
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
        DeafeningBlastCastedTime = DotaTime()
        return
    end

    IceWallDesire = X.ConsiderIceWall()
    if IceWallDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if not IsAbilityActive(IceWall)
        then
            InvokeSpell(Quas, Quas, Exort)
        end

        bot:ActionQueue_UseAbility(IceWall)
        IceWallCastedTime = DotaTime()
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
        ForgeSpiritCastedTime = DotaTime()
        return
    end
end

function X.ConsiderColdSnap()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(ColdSnap)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if not Quas:IsTrained()
        or (not ColdSnap:IsFullyCastable()
            or (not IsAbilityActive(ColdSnap)
                and DotaTime() < ColdSnapCastedTime + ColdSnapCooldownTime))
        or not IsAbilityActive(ColdSnap) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE, nil
        end
    end

	local nCastRange = J.GetProperCastRange(false, bot, ColdSnap:GetCastRange())

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and enemyHero:IsChanneling()
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		then
            bot:SetTarget(botTarget)
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.CanCastOnTargetAdvanced(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and (J.IsChasingTarget(nEnemyHeroes[1], bot) or J.GetHP(bot) < 0.64)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
		then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGhostWalk()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(GhostWalk)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if (not Quas:IsTrained() and not Wex:IsTrained())
        or (not GhostWalk:IsFullyCastable()
            or (not IsAbilityActive(GhostWalk)
                and DotaTime() < GhostWalkCastedTime + GhostWalkCooldownTime))
        or J.IsRealInvisible(bot)
        or not IsAbilityActive(GhostWalk) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    local RoshanLocation = J.GetCurrentRoshanLocation()
    local TormentorLocation = J.GetTormentorLocation(GetTeam())

	if	bot:DistanceFromFountain() > 600
    and not bot:IsInvulnerable()
    and not bot:IsMagicImmune()
	then
		if bot:IsSilenced()
        or bot:IsRooted()
        or J.IsStunProjectileIncoming(bot, 500)
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if J.IsRetreating(bot)
        and bot:GetActiveModeDesire() > 0.75
        then
            if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            then
                if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
                and #nInRangeEnemy > 1
                and (#nInRangeEnemy > #nInRangeAlly or bot:WasRecentlyDamagedByAnyHero(4) and J.GetHP(bot) < 0.55)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end

                if  #nInRangeEnemy >= 1
                and J.GetHP(bot) < 0.5 + (0.1 * #nInRangeEnemy)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end

        if DotaTime() > 12 * 60
        then
            if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeEnemy > 1
            and (#nInRangeEnemy > #nInRangeAlly or bot:WasRecentlyDamagedByAnyHero(4) and J.GetHP(bot) < 0.55)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if GetUnitToLocationDistance(bot, RoshanLocation) > 3200
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if GetUnitToLocationDistance(bot, TormentorLocation) > 3200
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTornado()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(Tornado)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if (not Quas:IsTrained() and not Wex:IsTrained())
        or (not Tornado:IsFullyCastable()
            or (not IsAbilityActive(Tornado)
                and DotaTime() < TornadoCastedTime + TornadoCooldownTime))
        or not IsAbilityActive(Tornado) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE, 0
        end
    end

	local nCastRange = J.GetProperCastRange(false, bot, Tornado:GetCastRange())
    local nCastPoint = Tornado:GetCastPoint()
	local nRadius = Tornado:GetSpecialValueInt('area_of_effect')
	local nSpeed = Tornado:GetSpecialValueInt('travel_speed')
    local nBaseDamage = Tornado:GetSpecialValueInt('base_damage')
    local nDamage = Tornado:GetSpecialValueInt('wex_damage') + nBaseDamage

    if string.find(botName, 'invoker')
    then
        nDamage = Tornado:GetSpecialValueInt('wex_damage') + (Wex:GetLevel() - 1) * 45 + nBaseDamage
    end

    local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:IsChanneling() and J.GetHP(enemyHero) > 0.15
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not J.IsInRange(bot, enemyHero, bot:GetAttackRange())
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                if J.IsRunning(enemyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    if  J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsValidHero(nInRangeEnemy[2])
        and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nInRangeEnemy[2]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
        and not nInRangeEnemy[2]:HasModifier('modifier_enigma_black_hole_pull')
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_invoker_tornado')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not (#nAllyHeroes >= #nEnemyHeroes + 2)
		then
            if not J.IsRunning(botTarget)
            then
                if J.IsInLaningPhase() and #nEnemyHeroes <= 1
                then
                    if botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            else
                local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint

                if J.IsInLaningPhase() and #nEnemyHeroes <= 1
                then
                    if botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
                end
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
    and (bot:GetActiveModeDesire() > 0.7 or J.GetHP(bot) < 0.5)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_brewmaster_storm_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_enigma_black_hole_pull')
        and not nEnemyHeroes[1]:HasModifier('modifier_eul_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nEnemyHeroes[1]:HasModifier('modifier_invoker_tornado')
        and not nEnemyHeroes[1]:HasModifier('modifier_legion_commander_duel')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
		end
	end

    if J.IsDefending(bot)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nDelay = (GetUnitToUnitDistance(bot, nAllyInRangeEnemy[1]) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], nDelay)
            end
        end
    end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
    local tCreepsToKill = {}
    for _, creep in pairs(nEnemyLaneCreeps)
    do
        if J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and not J.IsRunning(creep)
        and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
        then
            table.insert(tCreepsToKill, creep)
        end
    end

    if #tCreepsToKill >= 4 and #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
    and not J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(tCreepsToKill)
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEMP()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(EMP)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if not Wex:IsTrained()
        or (not EMP:IsFullyCastable()
            or (not IsAbilityActive(EMP)
                and DotaTime() < EMPCastedTime + EMPCooldownTime))
        or not IsAbilityActive(EMP) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE, 0
        end
    end

	local nCastRange = J.GetProperCastRange(false, bot, EMP:GetCastRange())
    local nCastPoint = EMP:GetCastPoint()
	local nRadius = EMP:GetSpecialValueInt('area_of_effect')
    local nDelay = EMP:GetSpecialValueFloat('delay')

	if J.IsInTeamFight(bot, 1300)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nDelay + nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if botTarget:HasModifier('modifier_invoker_tornado')
            then
                if DotaTime() > TornadoCastedTime + TornadoLiftTime - EMPDelay
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                else
                    return BOT_ACTION_DESIRE_NONE, 0
                end
            end

            if J.IsInLaningPhase() and bot:GetLevel() < 6
            then
                if J.GetMP(botTarget) > 0.5
                then
                    if not J.IsRunning(botTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay + nCastPoint)
                    end
                end
            else
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                else
                    if not J.IsRunning(botTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay + nCastPoint)
                    end
                end
            end
		end
	end

    local nEnemyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and not nEnemyHeroes[1]:HasModifier('modifier_brewmaster_storm_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_eul_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_legion_commander_duel')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(nEnemyHeroes[1]:GetLocation(), nRadius)
            if #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                if nEnemyHeroes[1]:HasModifier('modifier_invoker_tornado')
                then
                    if DotaTime() > TornadoCastedTime + TornadoLiftTime - EMPDelay
                    then
                        return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_NONE, 0
                    end
                else
                    if J.IsChasingTarget(nEnemyHeroes[1], bot)
                    then
                        return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
                    end
                end
            end
		end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and bot:GetLevel() < 6
    then
        if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetManaAfter(EMP:GetManaCost()) > 0.65
        and J.GetMP(botTarget) > 0.5
        then
            if J.IsRunning(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 1)
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAlacrity()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(Alacrity)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if (not Wex:IsTrained() and not Exort:IsTrained())
        or (not Alacrity:IsFullyCastable()
            or (not IsAbilityActive(Alacrity)
                and DotaTime() < AlacrityCastedTime + AlacrityCooldownTime))
        or not IsAbilityActive(Alacrity) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE, nil
        end
    end

	local nCastRange = J.GetProperCastRange(false, bot, Alacrity:GetCastRange())

    local suitableTarget = nil
	local nMaxDamage = 0
    local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
	for _, allyHero in pairs(nAllyHeroes)
	do
		if  J.IsValidHero(allyHero)
        and not allyHero:IsIllusion()
        and not J.IsDisabled(allyHero)
        and not J.IsWithoutTarget(allyHero)
        and not allyHero:HasModifier('modifier_invoker_alacrity')
        and allyHero:GetAttackDamage() > nMaxDamage
		then
			suitableTarget = allyHero
			nMaxDamage = allyHero:GetAttackDamage()
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_invoker_tornado')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            if suitableTarget ~= nil
            then
                if  suitableTarget == bot
                and J.IsInRange(bot, botTarget, 1600)
                then
                    return BOT_ACTION_DESIRE_HIGH, suitableTarget
                end

                if  suitableTarget ~= bot
                and J.IsInRange(suitableTarget, botTarget, 1200)
                then
                    return BOT_ACTION_DESIRE_HIGH, suitableTarget
                end
            end
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot))
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(888, true)
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.IsAttacking(bot)
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
			return BOT_ACTION_DESIRE_HIGH, bot
		end

		local nEnemyTowers = bot:GetNearbyTowers(888, true)

		if  nEnemyTowers ~= nil and #nEnemyTowers >= 1
        and J.IsValidHero(suitableTarget)
        then
            local nAttackTarget = suitableTarget:GetAttackTarget()

            if  suitableTarget == bot
            and J.IsValidBuilding(nAttackTarget)
            and J.CanBeAttacked(nAttackTarget)
            and J.IsAttacking(suitableTarget)
            and not bot:HasModifier('modifier_invoker_alacrity')
            then
                return BOT_ACTION_DESIRE_HIGH, suitableTarget
            end

            if  suitableTarget ~= bot
            and J.IsValidBuilding(nAttackTarget)
            and J.CanBeAttacked(nAttackTarget)
            and J.IsAttacking(suitableTarget)
            and J.IsInRange(suitableTarget, nEnemyTowers[1], 1000)
            then
                return BOT_ACTION_DESIRE_HIGH, suitableTarget
            end
		end
	end

    if  J.IsFarming(bot)
    then
        if J.IsAttacking(bot)
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
            if  nNeutralCreeps ~= nil
            and J.IsValid(nNeutralCreeps[1])
            and (#nNeutralCreeps >= 2
                or (#nNeutralCreeps >= 1 and nNeutralCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end

            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

	if  J.IsDoingRoshan(bot)
    and suitableTarget ~= nil
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 700)
        and J.IsAttacking(suitableTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, suitableTarget
		end
	end

    if  J.IsDoingTormentor(bot)
    and suitableTarget ~= nil
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 700)
        and J.IsAttacking(suitableTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, suitableTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderChaosMeteor()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(ChaosMeteor)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if (not Wex:IsTrained() and not Exort:IsTrained())
        or (not ChaosMeteor:IsFullyCastable()
            or (not IsAbilityActive(ChaosMeteor)
                and DotaTime() < ChaosMeteorCastedTime + ChaosMeteorCooldownTime))
        or not IsAbilityActive(ChaosMeteor) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE, 0
        end
    end

	local nCastRange = J.GetProperCastRange(false, bot, ChaosMeteor:GetCastRange())
    local nCastPoint = ChaosMeteor:GetCastPoint()
    local nRadius = ChaosMeteor:GetSpecialValueInt('area_of_effect')
    local nLandTime = ChaosMeteor:GetSpecialValueFloat('land_time')
    local nDamage = ChaosMeteor:GetSpecialValueInt('main_damage')

    if string.find(botName, 'invoker')
    then
        nDamage = ChaosMeteor:GetSpecialValueInt('main_damage') + (Exort:GetLevel() - 1) * 45
    end

    if J.IsInTeamFight(bot, 1200)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nLandTime + nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if #nInRangeEnemy >= 2
        and J.IsValidHero(nInRangeEnemy[1])
        and not J.IsRunning(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.15
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
            local nEnemyHeroes = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1600)
            if #nEnemyHeroes <= 1 and not J.IsCore(botTarget)
            then
                return BOT_ACTION_DESIRE_NONE, 0
            end

            if botTarget:HasModifier('modifier_invoker_tornado')
            then
                if DotaTime() > TornadoCastedTime + TornadoLiftTime - nLandTime
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                else
                    return BOT_ACTION_DESIRE_NONE, 0
                end
            end

            if J.IsRunning(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nLandTime + nCastPoint)
            else
                if J.IsDisabled(botTarget)
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.25
        and J.IsAttacking(bot)
        and J.GetMP(bot) > 0.5
        and bot:GetLevel() < 0.18
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
    local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    local tCreepsToKill = {}
    for _, creep in pairs(nEnemyLaneCreeps)
    do
        if J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and not J.IsRunning(creep)
        and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
        then
            table.insert(tCreepsToKill, creep)
        end
    end

    if #tCreepsToKill >= 4 and #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
    and not J.IsRunning(tCreepsToKill[1])
    and not J.IsRealInvisible(bot)
    and bot:GetLevel() >= 15
    and J.GetManaAfter(ChaosMeteor:GetManaCost()) > 0.65
    then
        return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(tCreepsToKill)
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSunstrike()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(Sunstrike)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if not Exort:IsTrained()
        or (not Sunstrike:IsFullyCastable()
            or (not IsAbilityActive(Sunstrike)
                and DotaTime() < SunstrikeCastedTime + SunstrikeCooldownTime))
        or not IsAbilityActive(Sunstrike) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE, 0
        end
    end

    local nDelay = Sunstrike:GetSpecialValueFloat('delay')
    local nRadius = Sunstrike:GetSpecialValueFloat('area_of_effect')
    local nCastPoint = Sunstrike:GetCastPoint()
    local nDamage = Sunstrike:GetSpecialValueInt('damage')

    if string.find(botName, 'invoker')
    then
        nDamage = Sunstrike:GetSpecialValueInt('damage') + (Exort:GetLevel() - 1) * 50
    end

    if bot:HasScepter()
    then
        if J.IsInTeamFight(bot, 1200)
		then
			local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
			local nNotMovingEnemyCount = 0

			for _, enemyHero in pairs(nInRangeEnemy)
            do
				if  J.IsValidHero(enemyHero)
				and J.CanCastOnMagicImmune(enemyHero)
                and not J.IsRunning(enemyHero)
				and (enemyHero:IsStunned()
					or enemyHero:IsRooted()
                    or enemyHero:IsHexed()
                    or enemyHero:IsNightmared()
                    or enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                    or enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    or J.IsTaunted(enemyHero)
                    )
				then
					nNotMovingEnemyCount = nNotMovingEnemyCount + 1
				end

                if J.IsValidHero(enemyHero)
                and enemyHero:HasModifier('modifier_invoker_tornado')
                then
                    if DotaTime() > TornadoCastedTime + TornadoLiftTime - nDelay
                    then
                        nNotMovingEnemyCount = nNotMovingEnemyCount + 1
                    end
                end
			end

			if nNotMovingEnemyCount >= 2
            then
				return BOT_ACTION_DESIRE_HIGH, 0
			end
		end
	else
		local nEnemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES)
		for _, enemyHero in pairs(nEnemyHeroes)
        do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnMagicImmune(enemyHero)
			and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_brewmaster_storm_cyclone')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_eul_cyclone')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
			then
                if enemyHero:IsStunned()
                or enemyHero:IsRooted()
                or enemyHero:IsHexed()
                or enemyHero:IsNightmared()
                or enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                or enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                or J.IsTaunted(enemyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end

                if J.IsRunning(enemyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay + nCastPoint)
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end

                if J.IsValidHero(enemyHero)
                and enemyHero:HasModifier('modifier_invoker_tornado')
                then
                    if DotaTime() > TornadoCastedTime + TornadoLiftTime - nDelay
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end
                end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderForgeSpirit()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(ForgeSpirit)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if (not Quas:IsTrained() and not Exort:IsTrained())
        or (not ForgeSpirit:IsFullyCastable()
            or (not IsAbilityActive(ForgeSpirit)
                and DotaTime() < ForgeSpiritCastedTime + ForgeSpiritCooldownTime))
        or not IsAbilityActive(ForgeSpirit) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE
        end
    end

	local nAttackRange = bot:GetAttackRange()
    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and not botTarget:IsAttackImmune()
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsInRange(bot, botTarget, bot:GetAttackRange() - 200)
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            if J.IsInLaningPhase()
            then
                if botTarget:GetHealth() <= J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            else
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	if  (J.IsPushing(bot) or J.IsDefending(bot))
    and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
    and not bot:HasModifier('modifier_invoker_alacrity')
    and J.GetManaAfter(ForgeSpirit:GetManaCost()) > 0.5
	then
        if J.IsAttacking(bot)
        then
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            local nEnemyTowers = bot:GetNearbyTowers(1200, true)
            if nEnemyTowers ~= nil and #nEnemyTowers >= 1
            and J.CanBeAttacked(nEnemyTowers[1])
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsFarming(bot)
    and J.GetManaAfter(ForgeSpirit:GetManaCost()) > 0.42
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nAttackRange + 75)

        if  nNeutralCreeps ~= nil
        and J.IsValid(nNeutralCreeps[1])
        and (#nNeutralCreeps >= 3
            or (#nNeutralCreeps >= 1 and nNeutralCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and J.GetHP(botTarget) > 0.25
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderIceWall()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(IceWall)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if (not Quas:IsTrained() and not Exort:IsTrained())
        or (not IceWall:IsFullyCastable()
            or (not IsAbilityActive(IceWall)
                and DotaTime() < IceWallCastedTime + IceWallCooldownTime))
        or not IsAbilityActive(IceWall) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    local nSpawnDistance = IceWall:GetSpecialValueInt('wall_place_distance')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nSpawnDistance)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 600)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_brewmaster_storm_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_eul_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_invoker_tornado')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDeafeningBlast()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        if not J.CanCastAbility(DeafeningBlast)
        then
            return BOT_ACTION_DESIRE_NONE
        end
    else
        if (not Quas:IsTrained() and not Wex:IsTrained() and not Exort:IsTrained())
        or (not DeafeningBlast:IsFullyCastable()
            or (not IsAbilityActive(DeafeningBlast)
                and DotaTime() < DeafeningBlastCastedTime + DeafeningBlastCooldownTime))
        or not IsAbilityActive(DeafeningBlast) and not Invoke:IsFullyCastable()
        then
            return BOT_ACTION_DESIRE_NONE, 0
        end
    end

	local nCastRange = J.GetProperCastRange(false, bot, DeafeningBlast:GetCastRange())
    local nCastPoint = DeafeningBlast:GetCastPoint()
    local nDamage = DeafeningBlast:GetSpecialValueInt('damage')
	local nRadius = DeafeningBlast:GetSpecialValueInt('radius_end')

    if string.find(botName, 'invoker')
    then
        nDamage = DeafeningBlast:GetSpecialValueInt('damage') + (Exort:GetLevel() - 1) * 40
    end

    if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and J.IsValidHero(nInRangeEnemy[1])
        and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nInRangeEnemy[1]:HasModifier('modifier_invoker_tornado')
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

    local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_invoker_tornado')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not (#nAllyHeroes >= #nEnemyHeroes + 2)
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsDisarmed()
        and not nEnemyHeroes[1]:HasModifier('modifier_brewmaster_storm_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_enigma_black_hole_pull')
        and not nEnemyHeroes[1]:HasModifier('modifier_eul_cyclone')
        and not nEnemyHeroes[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nEnemyHeroes[1]:HasModifier('modifier_invoker_tornado')
        and not nEnemyHeroes[1]:HasModifier('modifier_legion_commander_duel')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
		end
	end

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_brewmaster_storm_cyclone')
        and not enemyHero:HasModifier('modifier_eul_cyclone')
        and not enemyHero:HasModifier('modifier_invoker_tornado')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
		then
            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderCombo()
    if GetBot():GetUnitName() == 'npc_dota_hero_invoker'
    and X.CanDoCombo()
    then
        local nCastRange = J.GetProperCastRange(false, bot, ChaosMeteor:GetCastRange())
        local nRadius = EMP:GetSpecialValueInt('area_of_effect')

        if  J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(J.GetCenterOfUnits(nInRangeEnemy))
            and not J.IsLocationInBlackHole(J.GetCenterOfUnits(nInRangeEnemy))
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanDoCombo()
    if  Quas:IsTrained()
    and Wex:IsTrained()
    and Exort:IsTrained()
    and Invoke:IsFullyCastable()
    and (Tornado:IsFullyCastable()
        or (not IsAbilityActive(Tornado)
            and DotaTime() > TornadoCastedTime + TornadoCooldownTime))
    and (EMP:IsFullyCastable()
        or (not IsAbilityActive(EMP)
            and DotaTime() > EMPCastedTime + EMPCooldownTime))
    and (not IsAbilityActive(ChaosMeteor)
        and DotaTime() > ChaosMeteorCastedTime + ChaosMeteorCooldownTime)
    then
        local nManaCost = Tornado:GetManaCost()
                        + EMP:GetManaCost()
                        + ChaosMeteor:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

--
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

local flag1 = false
function CheckForCooldownReductions()
    if  J.HasItem(bot, 'item_octarine_core')
    and flag1 == false
    then
        ColdSnapCooldownTime        = ColdSnapCooldownTime * 0.75
        GhostWalkCooldownTime       = GhostWalkCooldownTime * 0.75
        TornadoCooldownTime         = TornadoCooldownTime * 0.75
        EMPCooldownTime             = EMPCooldownTime * 0.75
        AlacrityCooldownTime        = AlacrityCooldownTime * 0.75
        ChaosMeteorCooldownTime     = ChaosMeteorCooldownTime * 0.75
        SunstrikeCooldownTime       = SunstrikeCooldownTime * 0.75
        ForgeSpiritCooldownTime     = ForgeSpiritCooldownTime * 0.75
        IceWallCooldownTime         = IceWallCooldownTime * 0.75
        DeafeningBlastCooldownTime  = DeafeningBlastCooldownTime * 0.75
        flag1 = true
    end

    if not J.HasItem(bot, 'item_octarine_core')
    then
        ColdSnapCooldownTime          = 18
        GhostWalkCooldownTime         = 32
        TornadoCooldownTime           = 27
        EMPCooldownTime               = 27
        AlacrityCooldownTime          = 15
        ChaosMeteorCooldownTime       = 50
        SunstrikeCooldownTime         = 23
        ForgeSpiritCooldownTime       = 27
        IceWallCooldownTime           = 23
        DeafeningBlastCooldownTime    = 36
        flag1 = false
    end
end

return X