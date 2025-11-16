local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_puck'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)
local nBkBSphere = RandomInt(1, 2) == 1 and "item_black_king_bar" or "item_sphere"

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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,2,2,2,3,3,3,6,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_circlet",
                "item_mantle",
            
                "item_bottle",
                "item_magic_wand",
                "item_power_treads",
                "item_null_talisman",
                "item_witch_blade",
                "item_blink",
                "item_cyclone",
                "item_black_king_bar",--
                "item_devastator",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_mjollnir",--
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
                "item_wind_waker",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_cyclone",
                "item_null_talisman", "item_black_king_bar",
                "item_bottle", "item_black_king_bar",
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

local IllusoryOrb   = bot:GetAbilityByName('puck_illusory_orb')
local WaningRift    = bot:GetAbilityByName('puck_waning_rift')
local PhaseShift    = bot:GetAbilityByName('puck_phase_shift')
local EtherealJaunt = bot:GetAbilityByName('puck_ethereal_jaunt')
local DreamCoil     = bot:GetAbilityByName('puck_dream_coil')

local IllusoryOrbDesire, IllusoryOrbLocation
local WaningRiftDesire, WaningRiftLocation
local PhaseShiftDesire
local EtherealJauntDesire
local DreamCoilDesire, DreamCoilLocation

local Blink = nil

local bIsRetreatOrb = false

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) and not (bot:HasModifier('modifier_puck_phase_shift') and (bot:IsInvulnerable() or bot:IsChanneling())) then return end

    IllusoryOrb   = bot:GetAbilityByName('puck_illusory_orb')
    WaningRift    = bot:GetAbilityByName('puck_waning_rift')
    PhaseShift    = bot:GetAbilityByName('puck_phase_shift')
    EtherealJaunt = bot:GetAbilityByName('puck_ethereal_jaunt')
    DreamCoil     = bot:GetAbilityByName('puck_dream_coil')

    Blink = X.GetBlink()

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    EtherealJauntDesire = X.ConsiderEtherealJaunt()
    if EtherealJauntDesire > 0 then
        bIsRetreatOrb = false

        bot:Action_UseAbility(EtherealJaunt)
        return
    end

    IllusoryOrbDesire, IllusoryOrbLocation = X.ConsiderIllusoryOrb()
    if IllusoryOrbDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(IllusoryOrb, IllusoryOrbLocation)
        return
    end

    PhaseShiftDesire = X.ConsiderPhaseShift()
    if PhaseShiftDesire > 0 then
        bot:Action_UseAbility(PhaseShift)
        return
    end

    DreamCoilDesire, DreamCoilLocation = X.ConsiderDreamCoil()
    if DreamCoilDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(DreamCoil, DreamCoilLocation)
        return
    end

    WaningRiftDesire, WaningRiftLocation = X.ConsiderWaningRift()
    if WaningRiftDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(WaningRift, WaningRiftLocation)
        return
    end
end

function X.ConsiderIllusoryOrb()
    if not J.CanCastAbility(IllusoryOrb)
    or bot:HasModifier('modifier_puck_phase_shift')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    bIsRetreatOrb = false

    local botAttackRange = bot:GetAttackRange()
	local nCastRange = J.GetProperCastRange(false, bot, IllusoryOrb:GetCastRange())
    local nCastPoint = IllusoryOrb:GetCastPoint()
	local nRadius = IllusoryOrb:GetSpecialValueInt('radius')
    local nDamage = IllusoryOrb:GetSpecialValueInt('damage')
    local nSpeed = IllusoryOrb:GetSpecialValueInt('orb_speed')
    local nManaCost = IllusoryOrb:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WaningRift, DreamCoil})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {IllusoryOrb, WaningRift, DreamCoil})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, 800)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                local dist = GetUnitToLocationDistance(bot, J.GetCorrectLoc(enemyHero, eta))
                local vLocation = J.VectorTowards(bot:GetLocation(), J.GetCorrectLoc(enemyHero, eta), Min(dist, nCastRange))
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), vLocation, Min(dist, nCastRange))
                end
            end
        end
    end

	if J.IsStuck(bot) and not bot:IsRooted() then
        bIsRetreatOrb = true
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if J.CanCastOnNonMagicImmune(botTarget)
            or J.IsChasingTarget(bot, botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), Min(GetUnitToLocationDistance(bot, botTarget:GetLocation()), nCastRange))
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bot:IsRooted() then
        if bot:WasRecentlyDamagedByAnyHero(3.0) then
            bIsRetreatOrb = true
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(GetUnitToLocationDistance(bot, J.GetTeamFountain()), nCastRange))
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange, 1600), true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, Min(GetUnitToLocationDistance(bot, nLocationAoE.targetloc), nCastRange))
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, Min(GetUnitToLocationDistance(bot, nLocationAoE.targetloc), nCastRange))
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500 and fManaAfter > fManaThreshold2)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, Min(GetUnitToLocationDistance(bot, nLocationAoE.targetloc), nCastRange))
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			then
                local sCreepName = creep:GetUnitName()
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                    if string.find(sCreepName, 'ranged') then
                        if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), creep:GetLocation(), Min(GetUnitToLocationDistance(bot, creep:GetLocation()), nCastRange))
                        end
                    end

                    nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
                    if fManaAfter > fManaThreshold2 and nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), creep:GetLocation(), Min(GetUnitToLocationDistance(bot, creep:GetLocation()), nCastRange))
                    end

                    nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 2 and #nEnemyHeroes > 0 then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nLocationAoE.targetloc, Min(GetUnitToLocationDistance(bot, nLocationAoE.targetloc), nCastRange))
                    end
                end
			end
		end
	end

    if J.IsGoingToRune(bot) then
        if bot.rune and bot.rune.location and #nAllyHeroes >= #nEnemyHeroes then
            local dist = GetUnitToLocationDistance(bot, bot.rune.location)
            if dist < nCastRange and dist > 600 then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), bot.rune.location, Min(GetUnitToLocationDistance(bot, bot.rune.location), nCastRange))
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), Min(GetUnitToLocationDistance(bot, botTarget:GetLocation()), nCastRange))
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), Min(GetUnitToLocationDistance(bot, botTarget:GetLocation()), nCastRange))
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEtherealJaunt()
    if not J.CanCastAbility(EtherealJaunt)
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local botAttackRange = bot:GetAttackRange()

    local nDuration = 1
    if PhaseShift and PhaseShift:IsTrained() then
        nDuration = PhaseShift:GetSpecialValueFloat('duration')
    end

    if bIsRetreatOrb then
		local nProjectiles = GetLinearProjectiles()
		for _, p in pairs(nProjectiles) do
            if  p
            and p.ability:GetName() == 'puck_illusory_orb'
            and p.caster == bot
            and J.GetDistance(p.location, J.GetEnemyFountain()) > 1000
            and not J.IsLocationInChrono(p.location)
            then
                if GetUnitToLocationDistance(bot, p.location) > 600
                -- or J.CanCastAbilitySoon(Blink, nDuration)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    else
        local nProjectiles = GetLinearProjectiles()
        for _, p in pairs(nProjectiles) do
            if  p
            and p.ability:GetName() == 'puck_illusory_orb'
            and p.caster == bot
            and J.GetDistance(p.location, J.GetEnemyFountain()) > 1000
            and not J.IsLocationInChrono(p.location)
            then
                local nInRangeAlly_Orb = J.GetAlliesNearLoc(p.location, 1200)
                local nInRangeEnemy_Orb = J.GetEnemiesNearLoc(p.location, 1200)

                if J.IsGoingOnSomeone(bot) then
                    if J.IsValidTarget(botTarget)
                    and not J.IsSuspiciousIllusion(botTarget)
                    and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
                        local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

                        if #nInRangeAlly >= #nInRangeEnemy then
                            local nEnemyTowers = botTarget:GetNearbyTowers(900, false)
                            local distBotToBotTarget = GetUnitToUnitDistance(bot, botTarget)
                            local distOrbToBot = GetUnitToLocationDistance(bot, p.location)
                            local distOrbToBotTarget = GetUnitToLocationDistance(botTarget, p.location)

                            if #nInRangeAlly_Orb >= #nInRangeEnemy_Orb then
                                if #nEnemyTowers == 0
                                or J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, 3.0)
                                then
                                    if J.IsChasingTarget(bot, botTarget) then
                                        if (distOrbToBotTarget <= botAttackRange * 0.6)
                                        or (distOrbToBot > botAttackRange + 150)
                                        then
                                            return BOT_ACTION_DESIRE_HIGH
                                        end
                                    else
                                        if distBotToBotTarget < distOrbToBot then
                                            return BOT_ACTION_DESIRE_HIGH
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                if J.IsFarming(bot) then
                    if bot.farm and bot.farm.location and J.IsRunning(bot) then
                        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, 350, 0, 0)
                        if nLocationAoE.count == 0 and J.GetDistance(bot.farm.location, p.location) <= 400 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    end
                end

                if J.IsGoingToRune(bot) then
                    if bot.rune and bot.rune.location and #nInRangeAlly_Orb >= #nInRangeEnemy_Orb then
                        local dist = J.GetDistance(p.location, bot.rune.location)
                        if dist <= 300 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderWaningRift()
    if not J.CanCastAbility(WaningRift)
    or bot:IsRooted()
    or bot:HasModifier('modifier_puck_phase_shift')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = WaningRift:GetSpecialValueInt('max_distance')
    local nCastPoint = WaningRift:GetCastPoint()
	local nRadius = WaningRift:GetSpecialValueInt('radius')
    local nDamage = WaningRift:GetSpecialValueInt('damage')
    local nManaCost = WaningRift:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IllusoryOrb, DreamCoil})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {IllusoryOrb, WaningRift, DreamCoil})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {DreamCoil})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange * 2)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed()) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

    if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold3 then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange * 2, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:IsSilenced()
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsGoingOnSomeone(bot) and fManaAfter > fManaThreshold3 then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not X.IsThereOrbTraveling() then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsDisabled(enemyHero)
            and J.IsRunning(bot)
            then
                if J.IsChasingTarget(enemyHero, bot) or (#nEnemyHeroes > #nAllyHeroes) then
                    return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500 and fManaAfter > fManaThreshold2)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and not J.CanCastAbilitySoon(IllusoryOrb, 3.0) then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			then
                local sCreepName = creep:GetUnitName()
                local eta = (GetUnitToUnitDistance(bot, creep) / bot:GetCurrentMovementSpeed()) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_NONE, creep:GetLocation()
                    end

                    nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 3 and #nEnemyHeroes > 0 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPhaseShift()
    if not J.CanCastAbility(PhaseShift) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nDuration = PhaseShift:GetSpecialValueFloat('duration')

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 600)
        or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 600))
        or (J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth())
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if bIsRetreatOrb then
        return BOT_ACTION_DESIRE_HIGH
    end

    if bot:HasScepter() and (J.HasItem(bot, 'item_maelstrom') or J.HasItem(bot, 'item_mjollnir')) and #nEnemyHeroes > 0 then
        if DreamCoil and DreamCoil:IsTrained() then
            local coilDuration = DreamCoil:GetSpecialValueFloat('coil_duration')
            if DreamCoil:GetCooldown() - DreamCoil:GetCooldownTimeRemaining() < coilDuration then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsProjectileIncoming(bot, 300) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if not J.CanCastAbility(Blink) and J.CanCastAbilitySoon(Blink, nDuration) and bot:WasRecentlyDamagedByAnyHero(5.0) then
            return BOT_ACTION_DESIRE_HIGH
        end

        if J.IsProjectileIncoming(bot, 300) then
            return BOT_ACTION_DESIRE_HIGH
        end

		local nProjectiles = GetLinearProjectiles()
		for _, p in pairs(nProjectiles) do
			if p and p.ability:GetName() == 'puck_illusory_orb' and p.caster == bot then
                local distOrbBot = GetUnitToLocationDistance(bpt, p.location)
				if GetUnitToLocationDistance(bot, J.GetTeamFountain()) > J.GetDistance(p.location, J.GetTeamFountain()) and distOrbBot > 600 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

    if J.IsInLaningPhase() or botHP < 0.5 then
        if bot:WasRecentlyDamagedByTower(1.0) and #nAllyHeroes >= #nEnemyHeroes then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDreamCoil()
    if not J.CanCastAbility(DreamCoil)
    or bot:HasModifier('modifier_puck_phase_shift')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, DreamCoil:GetCastRange())
	local nRadius = DreamCoil:GetSpecialValueInt('coil_radius')
    local nDuration = DreamCoil:GetSpecialValueFloat('coil_duration')

    if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
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
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.GetHP(enemyHero) > 0.25
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                if J.IsCore(enemyHero) then
                    if enemyHero:HasModifier('modifier_teleporting') then
                        if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, nDuration) > enemyHero:GetHealth() then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                        end
                    end
                end

                local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                if enemyHeroDamage > hTargetDamage then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
            end
        end

        if hTarget then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

            if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nInRangeAlly, hTarget)
                if #nAllyHeroesTargetingTarget <= 1 then
                    if bot:GetEstimatedDamageToTarget(true, hTarget, nDuration, DAMAGE_TYPE_ALL) > hTarget:GetHealth() * 1.25 then
                        return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                end
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) and #nAllyHeroes <= 2 then
        local nAllyTowers = bot:GetNearbyTowers(900, false)
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            and bot:DistanceFromFountain() > 4200
            and #nAllyTowers == 0
            then
                if #nEnemyHeroes > #nAllyHeroes or botHP < 0.3 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsThereOrbTraveling()
    local nProjectiles = GetLinearProjectiles()
    for _, p in pairs(nProjectiles) do
        if p and p.ability:GetName() == 'puck_illusory_orb' and p.caster == bot then
            return true
        end
    end

    return false
end

function X.GetBlink()
    for i = 1, 5 do
        local hItem = bot:GetItemInSlot(i)
        if hItem then
            local sItemName = hItem:GetName()
            if string.find(sItemName, 'blink') then
                return hItem
            end
        end
    end

    return nil
end

return X