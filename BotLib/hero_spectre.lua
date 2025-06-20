local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_spectre'
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
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
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
                "item_blade_mail",
                "item_radiance",--
                "item_manta",--
                "item_orchid",
                "item_skadi",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_abyssal_blade",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_butterfly",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_manta",
                "item_magic_wand", "item_orchid",
                "item_wraith_band", "item_skadi",
                "item_power_treads", "item_abyssal_blade",
                "item_blade_mail", "item_butterfly",
            },
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

local SpectralDagger    = bot:GetAbilityByName('spectre_spectral_dagger')
local Desolate          = bot:GetAbilityByName('spectre_desolate')
local Dispersion        = bot:GetAbilityByName('spectre_dispersion')
local ShadowStep        = bot:GetAbilityByName('spectre_haunt_single')
local Haunt             = bot:GetAbilityByName('spectre_haunt')
local Reality           = bot:GetAbilityByName('spectre_reality')

local SpectralDaggerDesire, SpectralDaggerTarget, DaggerType
local DispersionDesire
local ShadowStepDesire, ShadowStepTarget
local HauntDesire
local RealityDesire, RealityLocation

local ShadowStepCastTime = -1
local ShadowStepDuration = 0

local HauntCastTime = -1
local HauntDuration = 0

local nAllyHeroes, nEnemyHeroes
local botTarget, botHP
local bAttacking

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    if bot:GetUnitName() == 'npc_dota_hero_rubick' then
        SpectralDagger    = bot:GetAbilityByName('spectre_spectral_dagger')
        Dispersion        = bot:GetAbilityByName('spectre_dispersion')
        ShadowStep        = bot:GetAbilityByName('spectre_haunt_single')
        Haunt             = bot:GetAbilityByName('spectre_haunt')
        Reality           = bot:GetAbilityByName('spectre_reality')
    end

    bAttacking = J.IsAttacking(bot)
    botTarget = J.GetProperTarget(bot)
    botHP = J.GetHP(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    RealityDesire, RealityLocation = X.ConsiderReality()
    if RealityDesire > 0 then
        bot:Action_UseAbilityOnLocation(Reality, RealityLocation)
        return
    end

    ShadowStepDesire, ShadowStepTarget = X.ConsiderShadowStep()
    if ShadowStepDesire > 0 then
        bot:Action_UseAbilityOnEntity(ShadowStep, ShadowStepTarget)
        bot:SetTarget(ShadowStepTarget)
        ShadowStepCastTime = DotaTime()
        return
    end

    HauntDesire = X.ConsiderHaunt()
    if HauntDesire > 0 then
        bot:Action_UseAbility(Haunt)
        HauntCastTime = DotaTime()
        return
    end

    SpectralDaggerDesire, SpectralDaggerTarget, DaggerType = X.ConsiderSpectralDagger()
    if SpectralDaggerDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        if DaggerType == 'unit' then
            bot:ActionQueue_UseAbilityOnEntity(SpectralDagger, SpectralDaggerTarget)
        else
            bot:ActionQueue_UseAbilityOnLocation(SpectralDagger, SpectralDaggerTarget)
        end

        return
    end

    DispersionDesire = X.ConsiderDispersion()
    if DispersionDesire > 0 then
        bot:Action_UseAbility(Dispersion)
        return
    end
end

function X.ConsiderSpectralDagger()
    if not J.CanCastAbility(SpectralDagger)
    then
        return BOT_ACTION_DESIRE_NONE, nil, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, SpectralDagger:GetCastRange())
    local nRadius = SpectralDagger:GetSpecialValueInt('path_radius')
    local nDamage = SpectralDagger:GetSpecialValueInt('damage')
    local nManaAfter = J.GetManaAfter(SpectralDagger:GetManaCost())

    if J.IsStuck(bot) then
        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetEscapeLoc(), nCastRange), 'loc'
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsInLaningPhase() then
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1000)
                if J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, 5.0) > botTarget:GetHealth() * 1.15
                or nManaAfter > 0.5
                or J.GetHP(botTarget) < 0.5
                or (J.IsChasingTarget(bot, botTarget) and nManaAfter > 0.3 and J.GetHP(botTarget) < 0.4)
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
                end
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
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
                if #nEnemyHeroes > #nAllyHeroes or (J.GetHP(bot) < 0.55 and bot:WasRecentlyDamagedByAnyHero(3.0)) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
                end
            end
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

    if (J.IsPushing(bot) or J.IsDefending(bot)) and #nAllyHeroes <= 2 and nManaAfter > 0.45 then
        if J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
            end
        end
    end

    if J.IsDefending(bot) and nManaAfter > 0.55 then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2
        and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) > 600
        and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) < 1100
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsFarming(bot) and nManaAfter > 0.3 and bAttacking then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3
            or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
            end
        end
    end

    if J.IsLaning(bot) then
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
			then
				if J.IsValid(nEnemyHeroes[1])
                and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
                and GetUnitToUnitDistance(nEnemyHeroes[1], creep) < 600
                and J.GetMP(bot) > 0.35
				then
					return BOT_ACTION_DESIRE_HIGH, creep, 'unit'
				end
			end
		end

        if nManaAfter > 0.3 and #nEnemyHeroes > 0 then
            if J.IsValid(nEnemyCreeps[1])
            and J.CanBeAttacked(nEnemyCreeps[1])
            and not J.IsRunning(nEnemyCreeps[1])
            then
                local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
                if nLocationAoE.count >= 3 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), 'loc'
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), 'loc'
        end
    end

    if nManaAfter > 0.5 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
            if nLocationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'loc'
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, nil
end

function X.ConsiderDispersion()
    if not J.CanCastAbility(Dispersion)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidTarget(botTarget) and bot:WasRecentlyDamagedByAnyHero(1.0) then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)

            if #nInRangeEnemy >= 2
            or (#nInRangeEnemy >= 1 and botHP < 0.3)
            or (#nInRangeEnemy > #nInRangeAlly and botHP < 0.3)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            then
                if #nEnemyHeroes > #nAllyHeroes or (J.GetHP(bot) < 0.4 and bot:WasRecentlyDamagedByAnyHero(3.0)) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and J.IsAttacking(bot)
        and botTarget:GetAttackTarget() == bot
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

local bDontSStepBack = false
local bDontHauntBack = false
function X.ConsiderReality()
    if not J.CanCastAbility(Reality)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    HauntDuration = Haunt:GetSpecialValueFloat('duration')
    ShadowStepDuration = ShadowStep:GetSpecialValueFloat('duration')

    if bDontSStepBack then
        ShadowStepCastTime = 0
        bDontSStepBack = false
    end

    if DotaTime() < ShadowStepCastTime + ShadowStepDuration then
        if J.IsValidTarget(ShadowStepTarget) and X.IsThereHauntIllusion(ShadowStepTarget:GetLocation(), 700) then
            return BOT_ACTION_DESIRE_HIGH, ShadowStepTarget:GetLocation()
        end

        if (#nEnemyHeroes == 0)
        or (#nEnemyHeroes >= 2 and #nEnemyHeroes > #nAllyHeroes and bot:WasRecentlyDamagedByAnyHero(2.5) and botHP < 0.75)
        then
            local targetIllu = nil
            local targetIlluDist = 100000
            for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
                if bot ~= allyHero
                and J.IsValidHero(allyHero)
                and allyHero:GetUnitName() == 'npc_dota_hero_spectre'
                and allyHero:IsIllusion()
                then
                    local allyHeroDist = GetUnitToLocationDistance(allyHero, J.GetTeamFountain())
                    if allyHeroDist < targetIlluDist then
                        targetIlluDist = allyHeroDist
                        targetIllu = allyHero
                    end
                end
            end

            if targetIllu ~= nil then
                bDontSStepBack = true
                return BOT_ACTION_DESIRE_HIGH, targetIllu:GetLocation()
            end
        end
    end

    if bDontHauntBack then
        HauntCastTime = 0
        bDontHauntBack = false
    end

    if DotaTime() < HauntCastTime + HauntDuration then
        for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
            if J.IsValidHero(allyHero)
            and not J.IsInRange(bot, allyHero, 1300)
            and not J.IsSuspiciousIllusion(allyHero)
            and not J.IsMeepoClone(allyHero)
            and J.IsGoingOnSomeone(allyHero)
            and not J.IsRetreating(bot)
            and not J.IsGoingOnSomeone(bot)
            then
                local allyTarget = allyHero:GetAttackTarget()
                if J.IsValidTarget(allyTarget)
                and J.CanBeAttacked(allyTarget)
                and not J.IsSuspiciousIllusion(allyTarget)
                and not J.IsLocationInChrono(allyTarget:GetLocation())
                and not J.IsLocationInBlackHole(allyTarget:GetLocation())
                and X.IsThereHauntIllusion(allyTarget:GetLocation(), 500)
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(allyTarget:GetLocation(), 1200)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(allyTarget:GetLocation(), 1200)

                    if #nInRangeAlly + 1 >= #nInRangeEnemy
                    and (not (#nInRangeAlly + 1 >= 2 and #nInRangeEnemy <= 1) or J.IsInTeamFight(allyHero, 1200))
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyTarget:GetLocation()
                    end
                end
            end
        end

        if (#nEnemyHeroes == 0)
        or (#nEnemyHeroes >= 2 and #nEnemyHeroes > #nAllyHeroes and bot:WasRecentlyDamagedByAnyHero(2.5) and botHP < 0.75)
        then
            local targetIllu = nil
            local targetIlluDist = 100000
            for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
                if bot ~= allyHero
                and J.IsValidHero(allyHero)
                and allyHero:GetUnitName() == 'npc_dota_hero_spectre'
                and allyHero:IsIllusion()
                then
                    local allyHeroDist = GetUnitToLocationDistance(allyHero, J.GetTeamFountain())
                    if allyHeroDist < targetIlluDist then
                        targetIlluDist = allyHeroDist
                        targetIllu = allyHero
                    end
                end
            end

            if targetIllu ~= nil then
                bDontHauntBack = true
                return BOT_ACTION_DESIRE_HIGH, targetIllu:GetLocation()
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShadowStep()
    if not J.CanCastAbility(ShadowStep)
    or J.IsInLaningPhase()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    ShadowStepDuration = ShadowStep:GetSpecialValueFloat('duration')
    local nTeamFightLocation = J.GetTeamFightLocation(bot)
    local botActiveMode = bot:GetActiveMode()

    if not J.IsGoingOnSomeone(bot)
    and not J.IsRetreating(bot)
    and not J.IsDefending(bot)
    and not J.IsDoingRoshan(bot)
    and not J.IsDoingTormentor(bot)
    and botActiveMode ~= BOT_MODE_DEFEND_ALLY
    then
        for _, enemyHero in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.GetHP(enemyHero) < 0.3
            and not J.IsInRange(bot, enemyHero, 1600)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsMeepoClone(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1600)
                local nInRangeTowers = enemyHero:GetNearbyTowers(1600, false)
                if #nInRangeEnemy <= 1 and #nInRangeTowers == 0 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and not J.IsInRange(bot, enemyHero, 600)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
                local nInRangeTowers = enemyHero:GetNearbyTowers(1600, false)
                if #nInRangeAlly + 1 >= #nInRangeEnemy and (#nInRangeTowers <= 1 or botHP > 0.65)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if  nTeamFightLocation ~= nil
    and GetUnitToLocationDistance(bot, nTeamFightLocation) > 1600
    and (bot:GetNetWorth() > 5000 or J.HasItem(bot, 'item_radiance'))
    and not J.IsRetreating(bot)
    and not J.IsGoingOnSomeone(bot)
    then
        local hTarget = nil
        local hTargetDamage = 99999
        local nInRangeTeamFightEnemy = J.GetEnemiesNearLoc(nTeamFightLocation, 2000)
        for _, enemyHero in pairs(nInRangeTeamFightEnemy) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
                local enemyHeroDamage = enemyHero:GetActualIncomingDamage(1000, DAMAGE_TYPE_PHYSICAL)
                if hTargetDamage > enemyHeroDamage and #nInRangeAlly + 1 >= #nInRangeEnemy then
                    hTargetDamage = enemyHeroDamage
                    hTarget = enemyHero
                end
            end
        end

        if hTarget ~= nil then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderHaunt()
    if not J.CanCastAbility(Haunt)
    or J.CanCastAbility(ShadowStep)
    or J.IsInLaningPhase()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    HauntDuration = Haunt:GetSpecialValueFloat('duration')

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if bot ~= allyHero
        and J.IsValidHero(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not allyHero:HasModifier('modifier_enigma_black_hole_pull')
        and not allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local allyTarget = allyHero:GetAttackTarget()

            if  J.IsGoingOnSomeone(allyHero)
            and not J.IsInRange(bot, allyHero, 1300)
            and not J.IsRetreating(bot)
            and not J.IsGoingOnSomeone(bot)
            and J.IsValidTarget(allyTarget)
            and J.CanBeAttacked(allyTarget)
            and not J.IsSuspiciousIllusion(allyTarget)
            and not J.IsLocationInChrono(allyTarget:GetLocation())
            and not J.IsLocationInBlackHole(allyTarget:GetLocation())
            then
                local nInRangeAlly = J.GetAlliesNearLoc(allyTarget:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(allyTarget:GetLocation(), 1200)
                if #nInRangeAlly + 1 >= #nInRangeEnemy
                and (not (#nInRangeAlly + 1 >= 2 and #nInRangeEnemy <= 1) or J.IsInTeamFight(allyHero, 1200))
                then
                    bot:SetTarget(allyTarget)
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.IsThereHauntIllusion(vLocation, nRadius)
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
        if J.IsValidHero(unit)
        and GetUnitToLocationDistance(unit, vLocation) <= nRadius
        and unit:GetUnitName() == 'npc_dota_hero_spectre'
        and unit:IsIllusion()
        then
            return true
        end
    end

    return false
end

return X