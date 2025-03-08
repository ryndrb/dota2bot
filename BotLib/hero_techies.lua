local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local TU = dofile( GetScriptDirectory()..'/FunLib/techies_utility' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_techies'
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
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {3,1,1,3,2,6,1,1,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_circlet",

                "item_bottle",
                "item_magic_wand",
                "item_double_null_talisman",
                "item_arcane_boots",
                "item_kaya",
                "item_force_staff",
                "item_yasha_and_kaya",--
                "item_octarine_core",--
                "item_black_king_bar",--
                "item_hurricane_pike",--
                "item_wind_waker",--
                "item_travel_boots_2",--
                "item_aghanims_shard",
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_force_staff",
                "item_bottle", "item_octarine_core",
                "item_null_talisman", "item_black_king_bar",
                "item_null_talisman", "item_wind_waker",
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
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
            
                "item_boots",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_glimmer_cape",--
                "item_boots_of_bearing",--
                "item_solar_crest",--
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_sheepstick",--
                "item_aghanims_shard",
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_circlet", "item_solar_crest",
                "item_magic_wand", "item_lotus_orb",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
            
                "item_boots",
                "item_magic_wand",
                "item_arcane_boots",
                "item_glimmer_cape",--
                "item_guardian_greaves",--
                "item_solar_crest",--
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_sheepstick",--
                "item_aghanims_shard",
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_circlet", "item_solar_crest",
                "item_magic_wand", "item_lotus_orb",
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

local StickyBomb        = bot:GetAbilityByName('techies_sticky_bomb')
local ReactiveTazer     = bot:GetAbilityByName('techies_reactive_tazer')
local ReactiveTazerStop = bot:GetAbilityByName('techies_reactive_tazer_stop')
local BlastOff          = bot:GetAbilityByName('techies_suicide')
local MineFieldSign     = bot:GetAbilityByName('techies_minefield_sign')
local ProximityMines    = bot:GetAbilityByName('techies_land_mines')

local StickyBombDesire, StickyBombLocation
local ReactiveTazerDesire
-- local ReactiveTazerStopDesire
local BlastOffDesire, BlastOffLocation
local MineFieldSignDesire, MineFieldSignLocation
local ProximityMinesDesire, ProximityMinesLocation

local MineCooldownTime = 0

local ComboDesire, ComboLocation

local nAllyHeroes, nEnemyHeroes
local botTarget

local TechiesMines = {}

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if bot:GetUnitName() == 'npc_dota_hero_rubick' then
        StickyBomb        = bot:GetAbilityByName('techies_sticky_bomb')
        ReactiveTazer     = bot:GetAbilityByName('techies_reactive_tazer')
        ReactiveTazerStop = bot:GetAbilityByName('techies_reactive_tazer_stop')
        BlastOff          = bot:GetAbilityByName('techies_suicide')
        MineFieldSign     = bot:GetAbilityByName('techies_minefield_sign')
        ProximityMines    = bot:GetAbilityByName('techies_land_mines')
    end

    botTarget = J.GetProperTarget(bot)

    ComboDesire, ComboLocation, Flag = X.ConsiderCombo()
    if ComboDesire > 0
    then
        bot:Action_ClearActions(false)
        local nCastPoint = BlastOff:GetCastPoint()
        local nLeapDuration = BlastOff:GetSpecialValueInt('stun_radius')

        if Flag == 1
        then
            if J.CheckBitfieldFlag(ReactiveTazer:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)
            then
                bot:ActionQueue_UseAbilityOnEntity(ReactiveTazer, bot)
            else
                bot:ActionQueue_UseAbility(ReactiveTazer)
            end

            bot:ActionQueue_Delay(0.6)
            bot:ActionQueue_UseAbilityOnLocation(BlastOff, ComboLocation)
            bot:ActionQueue_Delay(nCastPoint + nLeapDuration)
            if not ReactiveTazerStop:IsHidden()
            then
                bot:ActionQueue_UseAbility(ReactiveTazerStop)
            end
        end

        return
    end

    StickyBombDesire, StickyBombLocation = X.ConsiderStickyBomb()
    if StickyBombDesire > 0
    then
        bot:Action_UseAbilityOnLocation(StickyBomb, StickyBombLocation)
        return
    end

    ReactiveTazerDesire = X.ConsiderReactiveTazer()
    if ReactiveTazerDesire > 0
    then
        if J.CheckBitfieldFlag(ReactiveTazer:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)
        then
            bot:Action_UseAbilityOnEntity(ReactiveTazer, bot)
        else
            bot:Action_UseAbility(ReactiveTazer)
        end

        return
    end

    BlastOffDesire, BlastOffLocation = X.ConsiderBlastOff()
    if BlastOffDesire > 0
    then
        bot:Action_UseAbilityOnLocation(BlastOff, BlastOffLocation)
        return
    end

    ProximityMinesDesire, ProximityMinesLocation = X.ConsiderProximityMines()
    if ProximityMinesDesire > 0
    then
        bot:Action_UseAbilityOnLocation(ProximityMines, ProximityMinesLocation)
        MineCooldownTime = DotaTime()
        return
    end

    MineFieldSignDesire, MineFieldSignLocation = X.ConsiderMineFieldSign()
    if MineFieldSignDesire > 0
    then
        bot:Action_UseAbilityOnLocation(MineFieldSign, MineFieldSignLocation)
        return
    end

    if ProximityMines ~= nil and ProximityMines:IsTrained() then
        X.UpdateTechiesMines()
    end
end

function X.ConsiderStickyBomb()
    if not J.CanCastAbility(StickyBomb) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = J.GetProperCastRange(false, bot, StickyBomb:GetCastRange())
    local nRadius = StickyBomb:GetSpecialValueInt('radius')
    local nDamage = StickyBomb:GetSpecialValueInt('damage')
    local nSpeed = StickyBomb:GetSpecialValueInt('speed')
    local nAcceleration = StickyBomb:GetSpecialValueInt('acceleration')
    local nAbilityLevel = StickyBomb:GetLevel()
    local nManaAfter = J.GetManaAfter(StickyBomb:GetManaCost())

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = J.GetETAWithAcceleration(GetUnitToUnitDistance(bot, enemyHero), nSpeed, nAcceleration)
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
        end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and not allyHero:IsIllusion()
        then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.IsInRange(allyHero, enemyHero, 600)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsChasingTarget(enemyHero, allyHero)
                and not J.IsDisabled(enemyHero)
                then
                    local eta = J.GetETAWithAcceleration(GetUnitToUnitDistance(bot, enemyHero), nSpeed, nAcceleration)
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsChasingTarget(bot, botTarget) or bot:WasRecentlyDamagedByAnyHero(2.0) then
                local eta = J.GetETAWithAcceleration(GetUnitToUnitDistance(bot, botTarget), nSpeed, nAcceleration)
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                if #nEnemyHeroes > #nAllyHeroes or bot:WasRecentlyDamagedByAnyHero(3.0) then
                    return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
                end
            end
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    if  (J.IsPushing(bot) or J.IsDefending(bot))
    and nAbilityLevel >= 3
    and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200))
    and nManaAfter > 0.3
	then
        if J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

    if J.IsFarming(bot) and nManaAfter > 0.3 then
        local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsLaning(bot) then
        if J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and nManaAfter > 0.22
        and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200))
        then
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage - 1)
            if nLocationAoE.count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

        if nManaAfter > 0.45 then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsSuspiciousIllusion(enemyHero)
                then
                    local nAllyTowers = bot:GetNearbyTowers(1600, false)
                    if J.IsValidBuilding(nAllyTowers[1])
                    and J.IsInRange(nAllyTowers[1], enemyHero, 650)
                    and nAllyTowers[1]:GetAttackTarget() == enemyHero
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
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
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if nManaAfter > 0.3
    and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200))
    then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage - 1)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderReactiveTazer()
    if not J.CanCastAbility(ReactiveTazer) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ReactiveTazer:GetSpecialValueInt('stun_radius')

    if  J.IsGoingOnSomeone(bot)	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlastOff()
    if not J.CanCastAbility(BlastOff)
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BlastOff:GetCastRange())
	local nCastPoint = BlastOff:GetCastPoint()
    local nRadius = BlastOff:GetSpecialValueInt('radius')
    local nLeapDuration = BlastOff:GetSpecialValueFloat('duration')

    if J.IsStuck(bot) then
        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
            if #nInRangeAlly >= #nInRangeEnemy and enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
		then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

            if #nInRangeAlly >= #nInRangeEnemy then
                local flag = false
                local eta = nCastPoint + nLeapDuration
                local nEnemyTowers = bot:GetNearbyTowers(1600, true)

                if J.IsChasingTarget(bot, botTarget) then
                    if J.IsInLaningPhase() then
                        if J.IsValidBuilding(nEnemyTowers[1]) and J.IsInRange(nEnemyTowers[1], botTarget, 650) then
                            flag = true
                        end
                    end

                    if not flag then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
                    end
                else
                    if J.IsInLaningPhase() then
                        if J.IsValidBuilding(nEnemyTowers[1]) and J.IsInRange(nEnemyTowers[1], botTarget, 650) then
                            flag = true
                        end
                    end

                    if not flag then
                        local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
                        if nLocationAoE.count >= 1 then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                        end
                    end
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                if #nEnemyHeroes > #nAllyHeroes or bot:WasRecentlyDamagedByHero(enemyHero, 3.0) then
                    if J.GetHP(bot) < 0.17 and (bot:GetHealth() < J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.5)) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMineFieldSign()
    if ProximityMines ~= nil and not ProximityMines:IsTrained()
    or not J.CanCastAbility(MineFieldSign)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = MineFieldSign:GetSpecialValueInt('aura_radius')
    local nSpots = TU.GetAvailableSpot()
    MineLocation, MineLocationDistance = TU.GetClosestSpot(bot, nSpots)

    if  MineLocation ~= nil
    and GetUnitToLocationDistance(bot, MineLocation) <= 1600
    and not X.IsEnemyCloserToWardLocation(MineLocation, MineLocationDistance)
    then
        for _ = 1, 50 do
            local vLocation = J.GetRandomLocationWithinDist(MineLocation, 0, nRadius * 3 + 100)
            if IsLocationPassable(vLocation) then
                local hTechiesMines = X.GetTechiesMinesInLoc(vLocation, nRadius)
                if #hTechiesMines >= 3 then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderProximityMines()
    if not J.CanCastAbility(ProximityMines)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, ProximityMines:GetCastRange())
    local nDamage = ProximityMines:GetSpecialValueInt('damage')
    local nManaCost = ProximityMines:GetManaCost()
    local nManaAfter = J.GetManaAfter(nManaCost)
    local nRadius = 350

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.CanKillTarget(enemyHero, nDamage * 0.75, DAMAGE_TYPE_MAGICAL)
        and not J.IsChasingTarget(bot, enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
        and not enemyHero:HasModifier('modifier_ursa_enrage')
        then
            if not X.IsOtherMinesClose(enemyHero:GetLocation(), nRadius) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_ursa_enrage')
		then
            if not X.IsOtherMinesClose(botTarget:GetLocation(), nRadius) then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                local vLocation = (bot:GetLocation() + enemyHero:GetLocation()) / 2
                if (#nEnemyHeroes > #nAllyHeroes or bot:WasRecentlyDamagedByHero(enemyHero, 3.0))
                and J.CanKillTarget(enemyHero, nDamage * 1.5, DAMAGE_TYPE_MAGICAL)
                and not X.IsOtherMinesClose(vLocation, nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
	end

	if J.IsPushing(bot) then
		local nEnemyTowers = bot:GetNearbyTowers(1600, true)
		if J.IsValidBuilding(nEnemyTowers[1])
        and J.CanBeAttacked(nEnemyTowers[1])
        and J.GetHP(nEnemyTowers[1]) > 0.2
        and #nEnemyHeroes == 0
        then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
            local vLocation = nEnemyTowers[1]:GetLocation() + RandomVector(500)
            if not X.IsOtherMinesClose(vLocation, nRadius) and #nInRangeAlly >= 2 then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
		end
	end

    if J.IsFarming(bot) and nManaAfter > 0.4 then
        local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 or (nLocationAoE.count >= 3 and nEnemyCreeps[1]:IsAncientCreep()) then
                if not X.IsOtherMinesClose(nLocationAoE.targetloc, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsAttacking(bot) then
        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, 500)
            and not X.IsOtherMinesClose(botTarget:GetLocation(), nRadius)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end

        if J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, nCastRange)
            and not X.IsOtherMinesClose(botTarget:GetLocation(), nRadius)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    if J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1000)) then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
        if nLocationAoE.count >= 5 and not X.IsOtherMinesClose(nLocationAoE.targetloc, nRadius) then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    -- General Mines
    if  X.IsSuitableToPlaceMine()
    and DotaTime() > MineCooldownTime + 1.2
    and nManaAfter >= 0.2
    then
		local nSpots = TU.GetAvailableSpot()
		MineLocation, MineLocationDistance = TU.GetClosestSpot(bot, nSpots)
        local nDistance = J.IsCore(bot) and 2200 or 4000

		if  MineLocation ~= nil
        and GetUnitToLocationDistance(bot, MineLocation) <= nDistance
		and not X.IsEnemyCloserToWardLocation(MineLocation, MineLocationDistance)
		then
            for _ = 1, 100 do
                local vLocation = J.GetRandomLocationWithinDist(MineLocation, 0, nRadius * 3 + 100)
                if IsLocationPassable(vLocation) and not X.IsOtherMinesClose(vLocation, nRadius) then
                    local nMineList = X.GetTechiesMinesInLoc(vLocation, nRadius * 3 + 100)
                    if #nMineList < 3 then
                        return BOT_ACTION_DESIRE_HIGH, vLocation
                    end
                end
            end
		end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsSuitableToPlaceMine()
	local nMode = bot:GetActiveMode()
    local nTeamFightLocation = J.GetTeamFightLocation(bot)

	if (J.IsRetreating(bot) and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH)
    or (nMode == BOT_MODE_RUNE and DotaTime() > 0)
    or (nMode == BOT_MODE_DEFEND_ALLY)
    or (J.IsGoingOnSomeone(bot) and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH)
    or (J.IsPushing(bot) and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH)
    or (J.IsCore(bot) and J.IsFarming(bot))
	or J.IsDefending(bot)
    or J.IsDoingRoshan(bot)
    or J.IsDoingTormentor(bot)
    or (nTeamFightLocation ~= nil and J.GetDistance(nTeamFightLocation, bot:GetLocation()) < 3500)
	or (nEnemyHeroes ~= nil and #nEnemyHeroes >= 1 and X.IsIBecameTheTarget(nEnemyHeroes))
	or bot:WasRecentlyDamagedByAnyHero(5.0)
	then
		return false
	end

	return true
end

function X.IsIBecameTheTarget(hUnitList)
	for _, unit in pairs(hUnitList)
	do
		if J.IsValid(unit)
        and unit:GetAttackTarget() == bot
		then
			return true
		end
	end

	return false
end

function X.IsEnemyCloserToWardLocation(vLocation, nRadius)
	for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		local info = GetHeroLastSeenInfo(id)
		if info ~= nil then
			local dInfo = info[1]
			if  dInfo ~= nil
			and dInfo.time_since_seen < 5
			and J.GetDistance(dInfo.location, vLocation) <  nRadius
			then
				return true
			end
		end
	end

	return false
end

-- Combos
function X.ConsiderCombo()
    local ComboFlag = 0

    if CanDoCombo1()
    then
        ComboFlag = 1
    end

    if ComboFlag > 0
    then
        local nCastRange = J.GetProperCastRange(false, bot, BlastOff:GetCastRange())
        local nCastPoint = BlastOff:GetCastPoint()
        local nRadius = BlastOff:GetSpecialValueInt('radius')
        local nLeapDuration = BlastOff:GetSpecialValueFloat('duration')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if #nInRangeEnemy >= 2
            and (J.IsValidHero(nInRangeEnemy[1]) and not nInRangeEnemy[1]:IsMagicImmune()
                or J.IsValidHero(nInRangeEnemy[2]) and not nInRangeEnemy[2]:IsMagicImmune())
            and not J.IsEnemyChronosphereInLocation(nLocationAoE.targetloc)
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, ComboFlag
            end
        end

        if J.IsGoingOnSomeone(bot)
        then
            if  J.IsValidTarget(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, nCastRange)
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and not botTarget:HasModifier('modifier_eul_cyclone')
            and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

                if #nInRangeAlly >= #nInRangeEnemy then
                    local eta = nCastPoint + nLeapDuration
                    if J.IsChasingTarget(bot, botTarget) then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta), ComboFlag
                    else
                        local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
                        if nLocationAoE.count >= 1 then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, ComboFlag
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, 0
end

function CanDoCombo1()
    if  J.CanCastAbility(ReactiveTazer)
    and J.CanCastAbility(BlastOff)
    then
        local nManaCost = ReactiveTazer:GetManaCost()
                        + BlastOff:GetManaCost()

        if  bot:GetMana() >= nManaCost
        and J.GetHP(bot) > 0.35
        then
            return true
        end
    end

    return false
end

function X.UpdateTechiesMines()
    TechiesMines = {}
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
        if unit and unit:GetUnitName() == 'npc_dota_techies_land_mine' then
            table.insert(TechiesMines, unit)
        end
    end
end

function X.GetTechiesMinesInLoc(vLocation, nRadius)
	local nMinesList = {}
	for i = #TechiesMines, 1, -1 do
        local mine = TechiesMines[i]
        if not J.IsValid(mine) then
            table.remove(TechiesMines, i)
        elseif GetUnitToLocationDistance(mine, vLocation) <= nRadius then
            table.insert(nMinesList, mine)
        end
	end

	return nMinesList
end

function X.IsOtherMinesClose(vLocation, nRadius)
	for i = #TechiesMines, 1, -1 do
        local mine = TechiesMines[i]
        if not J.IsValid(mine) then
            table.remove(TechiesMines, i)
        elseif TU.IsMines(mine) and GetUnitToLocationDistance(mine, vLocation) <= nRadius then
            return true
        end
	end

	return false
end

return X