local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_night_stalker'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb", "item_heavens_halberd", "item_assault"}
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
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_double_gauntlets",
            
                "item_magic_wand",
                "item_double_bracer",
                "item_phase_boots",
                "item_echo_sabre",
                "item_crimson_guard",--
                "item_blink",
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_basher",
                "item_harpoon",--
                "item_abyssal_blade",--
                "item_overwhelming_blink",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_crimson_guard",
                "item_magic_wand", "item_blink",
                "item_bracer", "item_black_king_bar",
                "item_bracer", "item_basher",
            },
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

local Void              = bot:GetAbilityByName('night_stalker_void')
local CripplingFear     = bot:GetAbilityByName('night_stalker_crippling_fear')
local HunterInTheNight  = bot:GetAbilityByName('night_stalker_hunter_in_the_night')
local MidnightFeast     = bot:GetAbilityByName('night_stalker_midnight_feast')
local DarkAscension     = bot:GetAbilityByName('night_stalker_darkness')

local VoidDesire, VoidTarget
local CripplingFearDesire
local MidnightFeastDesire, MidnightFeastTarget
local DarkAscensionDesire

local bAttacking = false
local botTarget, botHP, botMaxMana, botManaRegen
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Void              = bot:GetAbilityByName('night_stalker_void')
    CripplingFear     = bot:GetAbilityByName('night_stalker_crippling_fear')
    MidnightFeast     = bot:GetAbilityByName('night_stalker_midnight_feast')
    DarkAscension     = bot:GetAbilityByName('night_stalker_darkness')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
	botMaxMana = bot:GetMaxMana()
	botManaRegen = bot:GetManaRegen()
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    DarkAscensionDesire = X.ConsiderDarkAscension()
    if DarkAscensionDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(DarkAscension)
        return
    end

    CripplingFearDesire = X.ConsiderCripplingFear()
    if CripplingFearDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(CripplingFear)
        return
    end

    VoidDesire, VoidTarget = X.ConsiderVoid()
    if VoidDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Void, VoidTarget)
        return
    end

    MidnightFeastDesire, MidnightFeastTarget = X.ConsiderMidnightFeast()
    if MidnightFeastDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(MidnightFeast, MidnightFeastTarget)
        return
    end
end

function X.ConsiderVoid()
    if not J.CanCastAbility(Void) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = Void:GetCastRange()
    local fCastPoint = Void:GetCastPoint()
    local nRadius = Void:GetSpecialValueInt('cast_radius')
    local nDamage = Void:GetSpecialValueInt('damage')
    local nDuration = Void:GetSpecialValueFloat('duration_day')
    local timeOfDay = J.CheckTimeOfDay()
    local nManaCost = Void:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {CripplingFear, DarkAscension})

    if timeOfDay == 'night' then
        nDuration = Void:GetSpecialValueFloat('duration_night')
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if enemyHero:IsChanneling() and timeOfDay == 'night' then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

	if J.IsInTeamFight(bot, 1200) then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
                if enemyHeroDamage > hTargetDamage then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
            end
        end

        if hTarget ~= nil then
            return BOT_ACTION_DESIRE_HIGH, hTarget
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
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if nRadius > 0 then
        if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and fManaAfter > 0.5 and #nAllyHeroes <= 2 and bAttacking then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 4) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end

        if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and fManaAfter > 0.5 and bAttacking then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 4) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and fManaAfter > 0.4 and bAttacking then
        if nRadius > 0 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3)
                    or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        else
            local hTarget = J.GetMostHpUnit(nEnemyCreeps)
            if  J.IsValid(hTarget)
            and J.CanBeAttacked(hTarget)
            and hTarget:IsCreep()
            and not J.CanKillTarget(hTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
            and not J.CanKillTarget(hTarget, nDamage, DAMAGE_TYPE_MAGICAL)
            then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
    end

    if J.IsLaning(bot) and J.IsEarlyGame() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint)
            and string.find(creep:GetUnitName(), 'ranged')
			then
                if J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1000) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and fManaAfter > 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and fManaAfter > 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderCripplingFear()
    if not J.CanCastAbility(CripplingFear) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = CripplingFear:GetSpecialValueInt('radius')
    local nManaCost = CripplingFear:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local botMP = J.GetMP(bot)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Void, DarkAscension})

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius + 150)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsSilenced()
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius - 100)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:IsSilenced()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if ((J.IsPushing(bot) and #nAllyHeroes <= 2) or (J.IsDefending(bot) and #nEnemyHeroes <= 1)) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and botMP > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and botMP > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMidnightFeast()
    if not J.CanCastAbility(MidnightFeast)
    or (J.IsRetreating(bot) and J.IsRealInvisible(bot) and #nEnemyHeroes > 0)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = MidnightFeast:GetCastRange()

    local nEnemyCreeps = bot:GetNearbyCreeps(650, true)

    if  J.IsValid(nEnemyCreeps[1])
    and J.CanBeAttacked(nEnemyCreeps[1])
    and J.CanCastOnTargetAdvanced(nEnemyCreeps[1])
    and not nEnemyCreeps[1]:IsAncientCreep()
    and not nEnemyCreeps[1]:IsDominated()
    then
        if botHP < 0.5 or (J.GetMP(bot) < 0.5 and botHP < 0.75) then
            return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDarkAscension()
    if not J.CanCastAbility(DarkAscension) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 600)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 10.0) > botTarget:GetHealth() then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X