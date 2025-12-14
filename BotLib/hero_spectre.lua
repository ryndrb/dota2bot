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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    SpectralDagger    = bot:GetAbilityByName('spectre_spectral_dagger')
    Dispersion        = bot:GetAbilityByName('spectre_dispersion')
    ShadowStep        = bot:GetAbilityByName('spectre_haunt_single')
    Haunt             = bot:GetAbilityByName('spectre_haunt')
    Reality           = bot:GetAbilityByName('spectre_reality')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
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
        return
    end

    HauntDesire = X.ConsiderHaunt()
    if HauntDesire > 0 then
        bot:Action_UseAbility(Haunt)
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
    if not J.CanCastAbility(SpectralDagger) then
        return BOT_ACTION_DESIRE_NONE, nil, ''
    end

    local nCastRange = SpectralDagger:GetCastRange()
    local nCastPoint = SpectralDagger:GetCastPoint()
    local nRadius = SpectralDagger:GetSpecialValueInt('dagger_radius')
    local nDamage = SpectralDagger:GetSpecialValueInt('damage')
    local nSpeed = SpectralDagger:GetSpecialValueInt('speed')
    local nManaCost = SpectralDagger:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Dispersion, ShadowStep, Haunt})

    if J.IsStuck(bot) then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SpectralDagger, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nCastRange, bot:DistanceFromFountain())))
        return BOT_ACTION_DESIRE_NONE, nil, ''
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'location'
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'location'
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'location'
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanCastOnTargetAdvanced(creep)
			and not J.IsOtherAllysTarget(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage ,DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'ranged') then
                        if J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
                            return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), 'location'
                        end
                    end

                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), 'location'
                    end
                end
			end
		end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), 'location'
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), 'location'
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), 'location'
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

function X.ConsiderDispersion()
    if not J.CanCastAbility(Dispersion) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidTarget(botTarget) and bot:WasRecentlyDamagedByAnyHero(1.0) and #nEnemyHeroesTargetingMe > 0 and botHP < 0.6 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, enemyHero:GetAttackRange() + 150)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and botTarget:GetAttackTarget() == bot
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

local bDontSStepBack = false
local bDontHauntBack = false
function X.ConsiderReality()
    if not J.CanCastAbility(Reality) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    if ShadowStep and ShadowStep:IsTrained() then
        local nDuration = ShadowStep:GetSpecialValueInt('duration')
        local fTimeRemaining = (ShadowStep:GetCooldown() - ShadowStep:GetCooldownTimeRemaining())

        if fTimeRemaining > nDuration and bDontSStepBack then
            bDontSStepBack = false
        end

        if fTimeRemaining < nDuration and not bDontSStepBack then
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
    end

    if Haunt and Haunt:IsTrained() then
        local nDuration = Haunt:GetSpecialValueInt('duration')
        local fTimeRemaining = (Haunt:GetCooldown() - Haunt:GetCooldownTimeRemaining())

        if fTimeRemaining > nDuration and bDontHauntBack then
            bDontHauntBack = false
        end

        if fTimeRemaining < nDuration and not bDontHauntBack then
            for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
                if J.IsValidHero(allyHero)
                and not J.IsInRange(bot, allyHero, 1300)
                and not J.IsSuspiciousIllusion(allyHero)
                and not J.IsMeepoClone(allyHero)
                and J.IsGoingOnSomeone(allyHero)
                and not J.IsRetreating(bot)
                and not J.IsGoingOnSomeone(bot)
                then
                    local allyTarget = J.GetProperTarget(allyHero)
                    if J.IsValidTarget(allyTarget)
                    and J.CanBeAttacked(allyTarget)
                    and not J.IsSuspiciousIllusion(allyTarget)
                    and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
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
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShadowStep()
    if not J.CanCastAbility(ShadowStep)
    or J.IsInLaningPhase()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nDuration = ShadowStep:GetSpecialValueFloat('duration')
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
                local damage = bot:GetEstimatedDamageToTarget(true, enemyHero, nDuration - 1, DAMAGE_TYPE_PHYSICAL)
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
                local nInRangeTowers = enemyHero:GetNearbyTowers(1600, false)
                if #nInRangeEnemy <= 1 and #nInRangeTowers == 0 and damage > enemyHero:GetHealth() then
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

    local vTeamFightLocation = J.GetTeamFightLocation(bot)

    if  vTeamFightLocation ~= nil
    and GetUnitToLocationDistance(bot, vTeamFightLocation) > 1600
    and (bot:GetNetWorth() > 5000 or J.HasItem(bot, 'item_radiance'))
    and not J.IsRetreating(bot)
    and not J.IsGoingOnSomeone(bot)
    then
        local hTarget = nil
        local hTargetDamage = 0
        local nInRangeTeamFightEnemy = J.GetEnemiesNearLoc(vTeamFightLocation, 2000)
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
                if hTargetDamage < enemyHeroDamage and #nInRangeAlly + 1 >= #nInRangeEnemy then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
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

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if  bot ~= allyHero
        and J.IsValidHero(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not allyHero:HasModifier('modifier_enigma_black_hole_pull')
        and not allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local allyTarget = J.GetProperTarget(allyHero)

            if  J.IsGoingOnSomeone(allyHero)
            and not J.IsInRange(bot, allyHero, 1300)
            and not J.IsRetreating(bot)
            and not J.IsGoingOnSomeone(bot)
            and J.IsValidTarget(allyTarget)
            and J.CanBeAttacked(allyTarget)
            and not J.IsSuspiciousIllusion(allyTarget)
            and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(allyTarget:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(allyTarget:GetLocation(), 1200)
                if  #nInRangeAlly + 1 >= #nInRangeEnemy
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