local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
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
                "item_octarine_core",--
                "item_hurricane_pike",--
                "item_black_king_bar",--
                "item_kaya_and_sange",--
                "item_shivas_guard",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_force_staff",
                "item_null_talisman", "item_octarine_core",
                "item_null_talisman", "item_black_king_bar",
                "item_bottle", "item_shivas_guard",
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
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_enchanted_mango",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_glimmer_cape",--
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_sheepstick",--
                "item_aghanims_shard",
                "item_moon_shard",
                "item_ultimate_scepter_2",
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
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_enchanted_mango",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_glimmer_cape",--
                "item_mekansm",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_sheepstick",--
                "item_aghanims_shard",
                "item_moon_shard",
                "item_ultimate_scepter_2",
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
    if  hMinionUnit
    and hMinionUnit:GetUnitName() ~= 'npc_dota_techies_land_mine'
    then
        Minion.MinionThink(hMinionUnit)
    end
end

end

local StickyBomb        = bot:GetAbilityByName('techies_sticky_bomb')
local ReactiveTazer     = bot:GetAbilityByName('techies_reactive_tazer')
local ReactiveTazerStop = bot:GetAbilityByName('techies_reactive_tazer_stop')
local BlastOff          = bot:GetAbilityByName('techies_suicide')
local MineFieldSign     = bot:GetAbilityByName('techies_minefield_sign')
local ProximityMines    = bot:GetAbilityByName('techies_land_mines')

local StickyBombDesire, StickyBombLocation
local ReactiveTazerDesire, ReactiveTazerTarget
local ReactiveTazerStopDesire
local BlastOffDesire, BlastOffLocation
local MineFieldSignDesire, MineFieldSignLocation
local ProximityMinesDesire, ProximityMinesLocation

local tMineLocations = {}

local proximityMines = { castTime = 0, placementCheckTime = 0 }

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local TechiesMines = {}

function X.SkillsComplement()
    bot = GetBot()

    -- if placing mine in invalid location; seem to trigger
    if  bot:GetCurrentActionType() == BOT_ACTION_TYPE_USE_ABILITY
    and bot:GetAnimActivity() == ACTIVITY_IDLE
    and ProximityMines
    and ProximityMines:IsTrained()
    then
        bot:Action_ClearActions(true)
		return
	end

	if J.CanNotUseAbility(bot) then return end

    X.UpdateMineLocations()

    StickyBomb        = bot:GetAbilityByName('techies_sticky_bomb')
    ReactiveTazer     = bot:GetAbilityByName('techies_reactive_tazer')
    ReactiveTazerStop = bot:GetAbilityByName('techies_reactive_tazer_stop')
    BlastOff          = bot:GetAbilityByName('techies_suicide')
    MineFieldSign     = bot:GetAbilityByName('techies_minefield_sign')
    ProximityMines    = bot:GetAbilityByName('techies_land_mines')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    StickyBombDesire, StickyBombLocation = X.ConsiderStickyBomb()
    if StickyBombDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StickyBomb, StickyBombLocation)
        return
    end

    ReactiveTazerStopDesire = X.ConsiderReactiveTazerStop()
    if ReactiveTazerStopDesire > 0 then
        bot:Action_UseAbility(ReactiveTazer)
        return
    end

    ReactiveTazerDesire, ReactiveTazerTarget = X.ConsiderReactiveTazer()
    if ReactiveTazerDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        if ReactiveTazerTarget then
            bot:ActionQueue_UseAbilityOnEntity(ReactiveTazer, ReactiveTazerTarget)
            return
        else
            bot:ActionQueue_UseAbility(ReactiveTazer)
            return
        end
    end

    BlastOffDesire, BlastOffLocation = X.ConsiderBlastOff()
    if BlastOffDesire > 0 then
        if J.IsGoingOnSomeone(bot) then
            if J.CanCastAbility(ReactiveTazer) and bot:GetMana() > (ReactiveTazer:GetManaCost() + BlastOff:GetManaCost() + 100) then
                bot:Action_ClearActions(true)
                if J.CheckBitfieldFlag(ReactiveTazer:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET) then
                    bot:ActionQueue_UseAbilityOnEntity(ReactiveTazer, ReactiveTazerTarget)
                else
                    bot:ActionQueue_UseAbility(ReactiveTazer)
                end

                bot:ActionQueue_UseAbilityOnLocation(BlastOff, BlastOffLocation)
                return
            end
        end
        bot:Action_UseAbilityOnLocation(BlastOff, BlastOffLocation)
        return
    end

    if ProximityMines ~= nil and ProximityMines:IsTrained() then
        X.UpdateTechiesMines()
    end

    ProximityMinesDesire, ProximityMinesLocation = X.ConsiderProximityMines()
    if ProximityMinesDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(ProximityMines, ProximityMinesLocation)
        proximityMines.castTime = DotaTime()
        return
    end

    MineFieldSignDesire, MineFieldSignLocation = X.ConsiderMineFieldSign()
    if MineFieldSignDesire > 0 then
        bot:Action_UseAbilityOnLocation(MineFieldSign, MineFieldSignLocation)
        return
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
    local nManaCost = StickyBomb:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ReactiveTazer, BlastOff, ProximityMines})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = J.GetETAWithAcceleration(GetUnitToUnitDistance(bot, enemyHero), nSpeed, nAcceleration)
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
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
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
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), bot:GetLocation(), nRadius)
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
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
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and not J.IsOtherAllysTarget(creep)
            and not J.IsUnitTargetedByTower(creep, false)
			then
                local eta = J.GetETAWithAcceleration(GetUnitToUnitDistance(bot, creep), nSpeed, nAcceleration)
                if J.WillKillTarget(creep, nDamage ,DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'ranged') then
                        if J.IsEnemyTargetUnit(creep, 1200) then
                            return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                        end
                    end

                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 1000)
                    if nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end

                    nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
			end
		end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not J.IsOtherAllysTarget(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage - 1)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
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

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderReactiveTazer()
    if not J.CanCastAbility(ReactiveTazer) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = ReactiveTazer:GetCastRange()
    local nRadius = ReactiveTazer:GetSpecialValueInt('stun_radius')
    local bHasShard = J.CheckBitfieldFlag(ReactiveTazer:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)

    if  J.IsGoingOnSomeone(bot)	then
        if bHasShard then
            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange)
                and not J.IsSuspiciousIllusion(allyHero)
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local allyTarget = J.GetProperTarget(allyHero)
                    if  J.IsValidHero(allyTarget)
                    and J.CanBeAttacked(allyTarget)
                    and J.IsInRange(allyHero, allyTarget, nRadius)
                    and J.CanCastOnNonMagicImmune(allyTarget)
                    and not J.IsDisabled(allyTarget)
                    and not allyTarget:IsDisarmed()
                    and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not allyTarget:HasModifier('modifier_techies_reactive_tazer_disarmed')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        else
            if  J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and J.CanCastOnNonMagicImmune(botTarget)
            and not J.IsDisabled(botTarget)
            and not botTarget:IsDisarmed()
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and not botTarget:HasModifier('modifier_techies_reactive_tazer_disarmed')
            then
                return BOT_ACTION_DESIRE_HIGH, nil
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if bHasShard then
            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and J.IsRetreating(allyHero)
                and not J.IsRealInvisible(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange)
                and not J.IsSuspiciousIllusion(allyHero)
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    for _, enemyHero in pairs(nEnemyHeroes) do
                        if  J.IsValidHero(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and J.IsInRange(allyHero, enemyHero, nRadius)
                        and J.CanCastOnNonMagicImmune(enemyHero)
                        and not J.IsDisabled(enemyHero)
                        and not enemyHero:IsDisarmed()
                        and not enemyHero:HasModifier('modifier_techies_reactive_tazer_disarmed')
                        and allyHero:WasRecentlyDamagedByHero(enemyHero, 4.0)
                        then
                            return BOT_ACTION_DESIRE_HIGH, allyHero
                        end
                    end
                end
            end
        else
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nRadius)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
                and not enemyHero:HasModifier('modifier_techies_reactive_tazer_disarmed')
                and bot:WasRecentlyDamagedByHero(enemyHero, 4.0)
                then
                    return BOT_ACTION_DESIRE_HIGH, nil
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderReactiveTazerStop()
    if not J.CanCastAbility(ReactiveTazerStop)
    or ReactiveTazer == nil
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ReactiveTazer:GetSpecialValueInt('stun_radius')
    local bHasShard = J.CheckBitfieldFlag(ReactiveTazer:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)

    if  J.IsGoingOnSomeone(bot)	then
        if bHasShard then
            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and allyHero:HasModifier('modifier_techies_reactive_tazer')
                then
                    local allyTarget = J.GetProperTarget(allyHero)
                    if  J.IsValidHero(allyTarget)
                    and J.CanBeAttacked(allyTarget)
                    and J.IsInRange(allyHero, allyTarget, nRadius)
                    and J.CanCastOnNonMagicImmune(allyTarget)
                    and not J.IsDisabled(allyTarget)
                    and not allyTarget:IsDisarmed()
                    and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not allyTarget:HasModifier('modifier_techies_reactive_tazer_disarmed')
                    and J.IsAttacking(allyTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        else
            if  J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and J.CanCastOnNonMagicImmune(botTarget)
            and not J.IsDisabled(botTarget)
            and not botTarget:IsDisarmed()
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and not botTarget:HasModifier('modifier_techies_reactive_tazer_disarmed')
            and J.IsAttacking(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if bHasShard then
            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and J.IsRetreating(allyHero)
                and not J.IsRealInvisible(allyHero)
                and allyHero:HasModifier('modifier_techies_reactive_tazer')
                then
                    for _, enemyHero in pairs(nEnemyHeroes) do
                        if  J.IsValidHero(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and J.IsInRange(allyHero, enemyHero, nRadius)
                        and J.CanCastOnNonMagicImmune(enemyHero)
                        and not J.IsDisabled(enemyHero)
                        and not enemyHero:IsDisarmed()
                        and not enemyHero:HasModifier('modifier_techies_reactive_tazer_disarmed')
                        and allyHero:WasRecentlyDamagedByHero(enemyHero, 4.0)
                        and J.IsAttacking(enemyHero)
                        then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    end
                end
            end
        else
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nRadius)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
                and not enemyHero:HasModifier('modifier_techies_reactive_tazer_disarmed')
                and bot:WasRecentlyDamagedByHero(enemyHero, 4.0)
                and J.IsAttacking(enemyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
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
    local nDamage = BlastOff:GetSpecialValueInt('damage')
    local nCurrentHPDamagePct = BlastOff:GetSpecialValueInt('hp_cost')
    local nLeapDuration = BlastOff:GetSpecialValueFloat('duration')
    local fHealthAfter = J.GetHealthAfter(bot:GetHealth() * (nCurrentHPDamagePct / 100))
    local nManaCost = BlastOff:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StickyBomb, ReactiveTazer, ProximityMines})

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 1200) then
            return BOT_ACTION_DESIRE_NONE
        end
    end

	if J.GetAttackProjectileDamageByRange(bot, 900) > bot:GetHealth() then
		return BOT_ACTION_DESIRE_NONE
	end

    if J.IsStuck(bot) then
        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nCastRange, bot:DistanceFromFountain()))
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not J.IsRetreating(bot)
        then
            local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
            if #nInRangeAlly >= #nInRangeEnemy and enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 1200
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fHealthAfter > 0.2
		then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

            if #nInRangeAlly >= #nInRangeEnemy then
                if J.IsDisabled(botTarget) or botTarget:GetCurrentMovementSpeed() <= 250 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1000)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if (bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
                or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nCastRange, bot:DistanceFromFountain()))
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 and fHealthAfter > 0.55 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and fHealthAfter > 0.4 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and fHealthAfter > 0.4 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMineFieldSign()
    if ProximityMines ~= nil and not ProximityMines:IsTrained()
    or not J.CanCastAbility(MineFieldSign)
    or #TechiesMines < 3
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = MineFieldSign:GetSpecialValueInt('aura_radius')

    if bot:HasScepter() then
        local nRadius_Scepter = MineFieldSign:GetSpecialValueInt('trigger_radius')
        if J.IsInTeamFight(bot, 1200) then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius_Scepter)
            if #nInRangeEnemy > 0 then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end
        end
    end

    if  #nEnemyHeroes == 0
    and not bot:WasRecentlyDamagedByAnyHero(3.0)
    and not J.IsRealInvisible(bot)
    then
        for _, location in pairs(tMineLocations) do
            if GetUnitToLocationDistance(bot, location) <= 1600 then
                local stepSize = nRadius / 2
                for dx = -nRadius, nRadius, stepSize do
                    for dy = -nRadius, nRadius, stepSize do
                        local vLocation = Vector(location.x + dx, location.y + dy, location.z)
                        if IsLocationPassable(vLocation) and IsLocationVisible(vLocation) then
                            local nMineList = X.GetTechiesMinesInLoc(vLocation, nRadius)
                            if #nMineList >= 3 then
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

function X.ConsiderProximityMines()
    if not J.CanCastAbility(ProximityMines) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, ProximityMines:GetCastRange())
    local nRadius = ProximityMines:GetSpecialValueInt('radius')
    local nDamage = ProximityMines:GetSpecialValueInt('damage')
    local nMinRadius = ProximityMines:GetSpecialValueInt('placement_radius')
    local nDelay = ProximityMines:GetSpecialValueInt('activation_delay')
    local nRestoreTime = ProximityMines:GetSpecialValueInt('AbilityChargeRestoreTime')
    local nManaCost = ProximityMines:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StickyBomb, ReactiveTazer, BlastOff})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay)
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
            if not X.IsOtherMinesClose(enemyHero:GetLocation(), nMinRadius) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
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

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and (DotaTime() > proximityMines.castTime + nRestoreTime) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            and J.CanKillTarget(enemyHero, nDamage * 1.5, DAMAGE_TYPE_MAGICAL)
            then
                local vLocation = (bot:GetLocation() + enemyHero:GetLocation()) / 2
                if not X.IsOtherMinesClose(vLocation, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 and (DotaTime() > proximityMines.castTime + nRestoreTime) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    if not X.IsOtherMinesClose(nLocationAoE.targetloc, nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and (DotaTime() > proximityMines.castTime + nRestoreTime) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5)
                or (nLocationAoE.count >= 4 and creep:GetHealth() >= 700)
                then
                    if not X.IsOtherMinesClose(nLocationAoE.targetloc, nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and (DotaTime() > proximityMines.castTime + nRestoreTime * 0.667) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    if not X.IsOtherMinesClose(nLocationAoE.targetloc, nRadius) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
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

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 then
        if (DotaTime() > proximityMines.castTime + nRestoreTime) then
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
            if nLocationAoE.count >= 5 and not X.IsOtherMinesClose(nLocationAoE.targetloc, nRadius) then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StickyBomb, ReactiveTazer, BlastOff, ProximityMines})

    if  DotaTime() > proximityMines.placementCheckTime + 1.47
    and #nEnemyHeroes == 0
    and not bot:WasRecentlyDamagedByAnyHero(3.0)
    and not J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and not J.IsRoshanCloseToChangingSides()
    and fManaAfter > fManaThreshold1
    then
        local radius = (J.IsCore(bot) and 2000) or 4000
        for _, location in pairs(tMineLocations) do
            if GetUnitToLocationDistance(bot, location) <= radius then
                local stepSize = nMinRadius
                for dx = -nMinRadius, nMinRadius, stepSize do
                    for dy = -nMinRadius, nMinRadius, stepSize do
                        local vLocation = Vector(location.x + dx, location.y + dy, location.z)
                        if  IsLocationPassable(vLocation)
                        and not X.IsOtherMinesClose(vLocation, nMinRadius)
                        and not X.IsLocationNearBuilding(vLocation, 700)
                        and not X.IsLocationInsideNeutralCamp(vLocation, 700)
                        and not J.IsLocationWithinLane(vLocation, 700, LANE_TOP)
                        and not J.IsLocationWithinLane(vLocation, 700, LANE_MID)
                        and not J.IsLocationWithinLane(vLocation, 700, LANE_BOT)
                        then
                            local nMineList = X.GetTechiesMinesInLoc(vLocation, nMinRadius)
                            if #nMineList < 3 then
                                return BOT_ACTION_DESIRE_HIGH, vLocation
                            end
                        end
                    end
                end
            end
        end

        proximityMines.placementCheckTime = DotaTime()
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.UpdateTechiesMines()
    TechiesMines = {}
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
        if unit and unit:GetUnitName() == 'npc_dota_techies_land_mine' then
            table.insert(TechiesMines, unit)
        end
    end
end

-- was tedious to update with map updates
function X.UpdateMineLocations()
    tMineLocations = {}

    if not J.IsPushing(bot) then
        local tRunes = {
            -- RUNE_BOUNTY_1,
            -- RUNE_BOUNTY_2,
            RUNE_POWERUP_1,
            RUNE_POWERUP_2
        }

        for i, rune in pairs(tRunes) do
            tMineLocations[i] = GetRuneSpawnLocation(rune)
        end
    end

    local vTormentorLocation = J.GetTormentorLocation(GetTeam())
    local botLocation = bot:GetLocation()

    if GetUnitToLocationDistance(bot, vTormentorLocation) > 1600 and not J.IsStuck(bot) then
        local function alive(tower)
            return GetTower(GetTeam(), tower) ~= nil
        end

        local minDistance = 1600

        if (alive(TOWER_TOP_3) and not alive(TOWER_TOP_2))
        or (alive(TOWER_MID_3) and not alive(TOWER_MID_2))
        or (alive(TOWER_BOT_3) and not alive(TOWER_BOT_2))
        then
            minDistance = 3400
        elseif (alive(TOWER_TOP_2) and not alive(TOWER_TOP_1))
            or (alive(TOWER_MID_2) and not alive(TOWER_MID_1))
            or (alive(TOWER_BOT_2) and not alive(TOWER_BOT_1))
            then
            minDistance = 5400
        elseif alive(TOWER_TOP_1)
            or alive(TOWER_MID_1)
            or alive(TOWER_BOT_1)
            then
            minDistance = 7400
        end

        if bot:DistanceFromFountain() > minDistance then
            table.insert(tMineLocations, botLocation)
        end
    end
end

function X.GetTechiesMinesInLoc(vLocation, nRadius)
	local nMinesList = {}
	for i = #TechiesMines, 1, -1 do
        local mine = TechiesMines[i]
        if J.IsValid(mine) and GetUnitToLocationDistance(mine, vLocation) <= nRadius then
            table.insert(nMinesList, mine)
        end
	end

	return nMinesList
end

function X.IsOtherMinesClose(vLocation, nRadius)
	for i = #TechiesMines, 1, -1 do
        local mine = TechiesMines[i]
        if J.IsValid(mine) and GetUnitToLocationDistance(mine, vLocation) <= nRadius then
            return true
        end
	end

	return false
end

function X.IsLocationInsideNeutralCamp(vLocation, nRadius)
    local camps = GetNeutralSpawners()
    for _, camp in pairs(camps) do
        if camp and J.GetDistance(camp.location, vLocation) <= nRadius then
            return true
        end
    end

    return false
end

function X.IsLocationNearBuilding(vLocation, nRadius)
    local unitList = GetUnitList(UNIT_LIST_ALL)
    for _, unit in pairs(unitList) do
        if J.IsValidBuilding(unit) and GetUnitToLocationDistance(unit, vLocation) <= nRadius then
            return true
        end
    end

    return false
end

return X