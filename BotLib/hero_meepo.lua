local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_meepo'
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
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                -- [1] = {2,3,1,6,2,2,2,3,3,6,3,1,1,1,6},
                [1] = {2,3,6,1,2,2,2,3,3,6,3,1,1,1,6,6}, -- +1 Divide We Stand
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",
            
                "item_magic_wand",
                "item_power_treads",
                "item_wraith_band",
                "item_diffusal_blade",
                "item_blink",
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_disperser",--
                "item_skadi",--
                "item_abyssal_blade",--
                "item_bloodthorn",--
                "item_ultimate_scepter_2",
                "item_swift_blink",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_ultimate_scepter",
                "item_magic_wand", "item_skadi",
                "item_wraith_band", "item_abyssal_blade",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                -- [1] = {2,3,1,6,2,2,2,3,3,6,3,1,1,1,6},
                [1] = {2,3,6,1,2,2,2,3,3,6,3,1,1,1,6,6}, -- +1 Divide We Stand
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",
            
                "item_magic_wand",
                "item_power_treads",--
                "item_wraith_band",
                "item_diffusal_blade",
                "item_blink",
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_skadi",--
                "item_sheepstick",--
                "item_disperser",--
                "item_bloodthorn",--
                "item_ultimate_scepter_2",
                "item_swift_blink",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_ultimate_scepter",
                "item_magic_wand", "item_skadi",
                "item_wraith_band", "item_sheepstick",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local EarthBind         = bot:GetAbilityByName('meepo_earthbind')
local Poof              = bot:GetAbilityByName('meepo_poof')
-- local Ransack           = bot:GetAbilityByName('meepo_ransack')
local Dig               = bot:GetAbilityByName('meepo_petrify')
local MegaMeepo         = bot:GetAbilityByName('meepo_megameepo')
local MegaMeepoFling    = bot:GetAbilityByName('meepo_megameepo_fling')
-- local DivideWeStand     = bot:GetAbilityByName('meepo_divided_we_stand')

local EarthBindDesire, EarthBindLocation
local PoofDesire, PoofTarget
local DigDesire
local MegaMeepoDesire
local MegaMeepoFlingDesire, MegaMeepoFlingFlingTarget

local Meepos = {}

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    EarthBind         = bot:GetAbilityByName('meepo_earthbind')
    Poof              = bot:GetAbilityByName('meepo_poof')
    Dig               = bot:GetAbilityByName('meepo_petrify')
    MegaMeepo         = bot:GetAbilityByName('meepo_megameepo')
    MegaMeepoFling    = bot:GetAbilityByName('meepo_megameepo_fling')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    Meepos = J.GetMeepos()

    PoofDesire, PoofTarget = X.ConsiderPoof()
    if PoofDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Poof, PoofTarget)
        return
    end

    DigDesire = X.ConsiderDig()
    if DigDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Dig)
        return
    end

    MegaMeepoDesire = X.ConsiderMegaMeepo()
    if MegaMeepoDesire > 0 then
        bot:Action_UseAbility(MegaMeepo)
        return
    end

    EarthBindDesire, EarthBindLocation = X.ConsiderEarthBind()
    if EarthBindDesire > 0 then
        local nCastPoint = EarthBind:GetCastPoint()
        local nSpeed = EarthBind:GetSpecialValueInt('speed')
        bot.earth_bind = { cast_time = DotaTime() + ((GetUnitToLocationDistance(bot, EarthBindLocation) / nSpeed) + nCastPoint) , location = EarthBindLocation}

        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(EarthBind, EarthBindLocation)
        return
    end

    MegaMeepoFlingDesire, MegaMeepoFlingFlingTarget = X.ConsiderMegaMeepoFling()
    if MegaMeepoFlingDesire > 0 then
        bot:Action_UseAbilityOnEntity(MegaMeepoFling, MegaMeepoFlingFlingTarget)
        return
    end
end

function X.ConsiderEarthBind()
    if not J.CanCastAbility(EarthBind) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, EarthBind:GetCastRange())
    local nCastPoint = EarthBind:GetCastPoint()
	local nRadius = EarthBind:GetSpecialValueInt('radius')
	local nSpeed = EarthBind:GetSpecialValueInt('speed')
    local nDuration = EarthBind:GetSpecialValueInt('duration')
    local nManaCost = EarthBind:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Poof, Dig})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EarthBind, Poof, Dig})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        then
            if enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
                if #Meepos <= 1 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                else
                    if not DidMeepoCloneThrewEarthBind(enemyHero:GetLocation(), nCastPoint, nSpeed, nDuration, nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end
                end
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 and fManaAfter > fManaThreshold1 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidTarget(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_meepo_earthbind')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                if not DidMeepoCloneThrewEarthBind(nLocationAoE.targetloc, nCastPoint, nSpeed, nDuration, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_meepo_earthbind')
        then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local vLocation = J.GetCorrectLoc(botTarget, eta)
            if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                if not J.IsChasingTarget(bot, botTarget) or J.IsInRange(bot, botTarget, nCastRange * 0.75) then
                    if not DidMeepoCloneThrewEarthBind(vLocation, nCastPoint, nSpeed, nDuration, nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, vLocation
                    end
                end
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_meepo_earthbind')
            then
                local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                or (nLocationAoE.count >= 2)
                then
                    if not DidMeepoCloneThrewEarthBind(enemyHero:GetLocation(), nCastPoint, nSpeed, nDuration, nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end
                end
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2 then
        for _, meepo in pairs(Meepos) do
            if J.IsValidHero(meepo)
            and bot ~= meepo
            and J.IsRetreating(meepo)
            and meepo:WasRecentlyDamagedByAnyHero(3.0)
            and not J.IsRealInvisible(meepo)
            and not meepo:HasModifier('modifier_meepo_petrify')
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and not enemyHero:HasModifier('modifier_meepo_earthbind')
                    then
                        if J.IsChasingTarget(enemyHero, meepo)
                        or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == meepo)
                        then
                            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                            local vLocation = J.GetCorrectLoc(enemyHero, eta)
                            if not DidMeepoCloneThrewEarthBind(vLocation, nCastPoint, nSpeed, nDuration, nRadius) then
                                return BOT_ACTION_DESIRE_HIGH, vLocation
                            end
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPoof()
    if not J.CanCastAbility(Poof) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastPoint = Poof:GetCastPoint()
    local nRadius = Poof:GetSpecialValueInt('radius')
	local nDamage = Poof:GetSpecialValueInt('poof_damage')
    local nManaCost = Poof:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EarthBind, Dig})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EarthBind, Poof, Dig})

    local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    for _, meepo in pairs(Meepos) do
        local meepoTarget = J.GetProperTarget(meepo)

        local nInRangeAlly = meepo:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = meepo:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if bot ~= meepo then
            if J.IsGoingOnSomeone(meepo) then
                if  J.IsValidTarget(meepoTarget)
                and J.IsInRange(meepo, meepoTarget, 800)
                and not J.IsRetreating(bot)
                and GetUnitToUnitDistance(bot, meepo) > 1600
                then
                    return BOT_ACTION_DESIRE_HIGH, meepo
                end
            end

            if J.IsRetreating(bot) then
                if botHP < 0.5
                and meepo:DistanceFromFountain() < 800
                and not J.IsStunProjectileIncoming(bot, 500)
                then
                    return BOT_ACTION_DESIRE_HIGH, meepo
                end
            end

            if J.IsPushing(bot) and J.IsPushing(meepo) and fManaAfter > fManaThreshold2 and not bot:WasRecentlyDamagedByAnyHero(5.0) then
                local nLane = LANE_MID
                if meepo:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
                if meepo:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

                local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
                if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 and GetUnitToLocationDistance(meepo, vLaneFrontLocation) < 800 then
                    return BOT_ACTION_DESIRE_HIGH, meepo
                end
            end

            if (J.IsDefending(bot) or J.IsLateGame()) and J.IsDefending(meepo) and fManaAfter > fManaThreshold1 and not bot:WasRecentlyDamagedByAnyHero(5.0) then
                local nLane = LANE_MID
                if meepo:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
                if meepo:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

                local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
                if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 and GetUnitToLocationDistance(meepo, vLaneFrontLocation) < 800 then
                    return BOT_ACTION_DESIRE_HIGH, meepo
                end
            end

            if  J.IsLaning(bot)
            and J.IsLaning(meepo)
            and J.IsInLaningPhase()
            and fManaAfter > fManaThreshold2
            then
                local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
                if  GetUnitToLocationDistance(bot, vLaneFrontLocation) > 1600
                and GetUnitToLocationDistance(meepo, vLaneFrontLocation) < 700
                then
                    return BOT_ACTION_DESIRE_HIGH, meepo
                end
            end
        end

        if J.IsDoingRoshan(bot) then
            if bot ~= meepo and J.IsDoingRoshan(meepo) then
                if  J.IsRoshan(meepoTarget)
                and J.CanBeAttacked(meepoTarget)
                and J.IsInRange(meepo, meepoTarget, 800)
                and #nInRangeEnemy == 0
                and fManaAfter > fManaThreshold1
                then
                    if GetUnitToLocationDistance(bot, J.GetCurrentRoshanLocation()) > 2000 then
                        return BOT_ACTION_DESIRE_HIGH, meepo
                    end
                end
            end

            if J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and bAttacking
            and fManaAfter > fManaThreshold2
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end

        if J.IsDoingTormentor(bot) then
            if bot ~= meepo and J.IsDoingTormentor(meepo) then
                if  J.IsTormentor(meepoTarget)
                and J.IsInRange(meepo, meepoTarget, 800)
                and #nInRangeEnemy == 0
                and fManaAfter > fManaThreshold1
                then
                    if GetUnitToLocationDistance(bot, J.GetTormentorLocation(GetTeam())) > 2000 then
                        return BOT_ACTION_DESIRE_HIGH, meepo
                    end
                end
            end

            if J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and bAttacking
            and fManaAfter > fManaThreshold2
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end

        if botHP > 0.5 and not J.IsRetreating(bot) and #nEnemyHeroesTargetingMe <= 1 then
            if J.IsRetreating(meepo) and not J.IsRealInvisible(meepo) then
                if (#nInRangeAlly >= #nInRangeEnemy)
                or (#Meepos >= #nInRangeEnemy)
                then
                    for _, enemyHero in pairs(nEnemyHeroes) do
                        if J.IsValidHero(enemyHero)
                        and J.IsInRange(meepo, enemyHero, 800)
                        and not J.IsSuspiciousIllusion(enemyHero)
                        and not J.IsDisabled(enemyHero)
                        and not enemyHero:IsDisarmed()
                        and GetUnitToUnitDistance(bot, meepo) > 800
                        then
                            if J.IsChasingTarget(enemyHero, meepo)
                            or ((#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == meepo) and not (#nEnemyHeroes >= #nAllyHeroes + 2))
                            then
                                return BOT_ACTION_DESIRE_HIGH, meepo
                            end
                        end
                    end
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if not J.IsChasingTarget(bot, botTarget)
            or botTarget:GetCurrentMovementSpeed() <= 200
            or J.IsDisabled(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and enemyHero:GetAttackTarget() == bot
            and J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 3.0) < enemyHero:GetHealth()
            then
                local meepoTarget = nil
                local meepoTargetDistance = 0
                for _, meepo in pairs(Meepos) do
                    if J.IsValid(meepo) and bot ~= meepo and not meepo:WasRecentlyDamagedByAnyHero(2.0) and not meepo:IsChanneling() then
                        local nInRangeEnemy = meepo:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

                        local meepoDistance = GetUnitToUnitDistance(bot, meepo)
                        if  meepoDistance > meepoTargetDistance
                        and ((GetUnitToLocationDistance(bot, J.GetTeamFountain()) > GetUnitToLocationDistance(meepo, J.GetTeamFountain())) or #nInRangeEnemy == 0)
                        then
                            meepoTarget = meepo
                            meepoTargetDistance = meepoDistance
                        end
                    end
                end

                if meepoTarget then
                    return BOT_ACTION_DESIRE_HIGH, meepoTarget
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 2 or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold2 then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, bot
        end

        nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.CanKillTarget(creep, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL) then
                if string.find(creep:GetUnitName(), 'ranged') or #nEnemyCreeps >= 2 then
                    if nLocationAoE.count > 0 or (J.IsUnitTargetedByTower(creep, false) and J.GetHP(creep) > 0.4) then
                        return BOT_ACTION_DESIRE_HIGH, bot
                    end
                end
            end
        end

        if fManaAfter > 0.5 then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nRadius * 0.8)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                and J.GetHP(enemyHero) < 0.5
                then
                    if not J.IsChasingTarget(enemyHero, bot)
                    or botTarget:GetCurrentMovementSpeed() <= 200
                    or J.IsDisabled(botTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH, bot
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDig()
    if not J.CanCastAbility(Dig)
    or bot:IsInvulnerable()
    or bot:HasModifier('modifier_meepo_petrify')
    or (bot:HasModifier('modifier_oracle_false_promise_timer') and not J.IsRetreating(bot))
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
    or bot:HasModifier('modifier_ice_blast')
    then
        local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
        if #nEnemyHeroesTargetingMe > 0 then
            return BOT_ACTION_DESIRE_HIGH
        else
            return BOT_ACTION_DESIRE_NONE
        end
    end

    if botHP < 0.5 then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMegaMeepo()
    if not J.CanCastAbility(MegaMeepo)
    or bot:HasModifier('modifier_meepo_petrify')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = MegaMeepo:GetSpecialValueInt('radius')

    if J.IsGoingOnSomeone(bot) then
        local count = 0
        for _, meepo in pairs(Meepos) do
            if  J.IsValid(meepo)
            and J.IsMeepoClone(meepo)
            and J.IsInRange(bot, meepo, nRadius)
            and not meepo:HasModifier('modifier_meepo_petrify')
            then
                count = count + 1
            end
        end

        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)

        if count >= 2 and #nInRangeEnemy > 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMegaMeepoFling()
    if not J.CanCastAbility(MegaMeepoFling) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, MegaMeepoFling:GetCastRange())

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 800
        and J.IsChasingTarget(bot, botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 200)
        and not J.IsMeepoClone(bot)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 800)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 800)
            if #nInRangeAlly + 1 >= #nInRangeEnemy then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
    if J.IsValid(nEnemyCreeps[1]) and J.CanCastOnTargetAdvanced(nEnemyCreeps[1]) and #nEnemyHeroes == 0 then
        return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]
    end

    return BOT_ACTION_DESIRE_NONE
end

function DidMeepoCloneThrewEarthBind(vLocation, nCastPoint, nSpeed, nDuration, nRadius)
    for _, meepo in pairs(Meepos) do
        if J.IsValid(meepo) and bot ~= meepo then
            local eta = nDuration + (GetUnitToLocationDistance(meepo, vLocation) / nSpeed) + nCastPoint
            if meepo.earth_bind and DotaTime() < meepo.earth_bind.cast_time + eta then
                if J.GetDistance(meepo.earth_bind.location, vLocation) <= nRadius + nRadius / 2 then
                    return true
                end
            end
        end
    end

    return false
end

return X