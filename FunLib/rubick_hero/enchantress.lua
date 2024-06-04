local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local Impetus
local Enchant
local NaturesAttendant
local Sproink
local LittleFriends
-- local Untouchable

function X.ConsiderStolenSpell(ability)
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    local abilityName = ability:GetName()

    if abilityName == 'enchantress_little_friends'
    then
        LittleFriends = ability
        LittleFriendsDesire, LittleFriendsTarget = X.ConsiderLittleFriends()
        if LittleFriendsDesire > 0
        then
            bot:Action_UseAbilityOnEntity(LittleFriends, LittleFriendsTarget)
            return
        end
    end

    if abilityName == 'enchantress_impetus'
    then
        Impetus = ability
        ImpetusDesire = X.ConsiderImpetus()
        if ImpetusDesire > 0
        then
            return
        end
    end

    if abilityName == 'enchantress_bunny_hop'
    then
        Sproink = ability
        SproinkDesire = X.ConsiderSproink()
        if SproinkDesire > 0
        then
            bot:Action_UseAbility(Sproink)
            return
        end
    end

    if abilityName == 'enchantress_natures_attendants'
    then
        NaturesAttendant = ability
        NaturesAttendantDesire = X.ConsiderNaturesAttendant()
        if NaturesAttendantDesire > 0
        then
            bot:Action_UseAbility(NaturesAttendant)
            return
        end
    end

    if abilityName == 'enchantress_enchant'
    then
        Enchant = ability
        EnchantDesire, EnchantTarget = X.ConsiderEnchant()
        if EnchantDesire > 0
        then
            bot:Action_UseAbilityOnEntity(Enchant, EnchantTarget)
            return
        end
    end
end

function X.ConsiderImpetus()
    if not Impetus:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()
    local nAbilityLevel = Impetus:GetLevel()
    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and #nInRangeAlly >= #nInRangeEnemy
        then
            if not Impetus:GetAutoCastState()
            then
                Impetus:ToggleAutoCast()
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if  J.IsFarming(bot)
    and nAbilityLevel == 4
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nAttackRange)

        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.IsValid(nNeutralCreeps[1])
        then
            if not Impetus:GetAutoCastState()
            then
                Impetus:ToggleAutoCast()
                return BOT_ACTION_DESIRE_HIGH
            else
                if  Impetus:GetAutoCastState()
                and J.GetMP(bot) < 0.25
                then
                    Impetus:ToggleAutoCast()
                    return BOT_ACTION_DESIRE_HIGH
                end

                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            if not Impetus:GetAutoCastState()
            then
                Impetus:ToggleAutoCast()
                return BOT_ACTION_DESIRE_HIGH
            else
                if  Impetus:GetAutoCastState()
                and J.GetMP(bot) < 0.25
                then
                    Impetus:ToggleAutoCast()
                    return BOT_ACTION_DESIRE_HIGH
                end

                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            if not Impetus:GetAutoCastState()
            then
                Impetus:ToggleAutoCast()
                return BOT_ACTION_DESIRE_HIGH
            else
                if  Impetus:GetAutoCastState()
                and J.GetMP(bot) < 0.25
                then
                    Impetus:ToggleAutoCast()
                    return BOT_ACTION_DESIRE_HIGH
                end

                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if Impetus:GetAutoCastState()
    then
        Impetus:ToggleAutoCast()
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEnchant()
    if not Enchant:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = Enchant:GetCastRange()
    local nMaxLevel = Enchant:GetSpecialValueInt('level_req')
    local nDamage = Enchant:GetSpecialValueInt('enchant_damage')
    local nDuration = Enchant:GetSpecialValueFloat('slow_duration')
	local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
    local botTarget = J.GetProperTarget(bot)

    -- local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    -- for _, enemyHero in pairs(nEnemyHeroes)
    -- do
    --     if  J.IsValidHero(enemyHero)
    --     and J.CanCastOnNonMagicImmune(enemyHero)
    --     and J.CanKillTarget(enemyHero, nDamage * nDuration, DAMAGE_TYPE_ALL)
    --     and not J.IsSuspiciousIllusion(enemyHero)
    --     then
    --         return BOT_ACTION_DESIRE_HIGH, enemyHero
    --     end
    -- end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

        if  J.IsRetreating(allyHero)
        and J.IsValidHero(nAllyInRangeEnemy[1])
        and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
        and not J.IsDisabled(nAllyInRangeEnemy[1])
        then
            if J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 100, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere')
        and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and ((#nInRangeAlly >= #nInRangeEnemy) or (#nInRangeEnemy > #nInRangeAlly and J.WeAreStronger(bot, nCastRange + 100)))
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    local nGoodCreep = {
        "npc_dota_neutral_alpha_wolf",
        "npc_dota_neutral_centaur_khan",
        "npc_dota_neutral_polar_furbolg_ursa_warrior",
        "npc_dota_neutral_dark_troll_warlord",
        "npc_dota_neutral_satyr_hellcaller",
        "npc_dota_neutral_enraged_wildkin",
        "npc_dota_neutral_warpine_raider",
    }

    for _, creep in pairs(nNeutralCreeps)
    do
        if  J.IsValid(creep)
        and creep:GetLevel() <= nMaxLevel
        then
            for _, gCreep in pairs(nGoodCreep)
            do
                if creep:GetUnitName() == gCreep
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderNaturesAttendant()
    if not NaturesAttendant:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsRetreating(bot)
    then
        if  J.GetHP(bot) < 0.65
        and bot:DistanceFromFountain() > 800
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSproink()
    if not Sproink:IsTrained()
    or not Sproink:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()

    local nAllyHeroes = bot:GetNearbyHeroes(nAttackRange + 100, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(nAttackRange, true, BOT_MODE_NONE)
    local nImpetusMul = Impetus:GetSpecialValueFloat('value') / 100
    local botTarget = J.GetProperTarget(bot)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanKillTarget(enemyHero, nImpetusMul * GetUnitToUnitDistance(bot, enemyHero), DAMAGE_TYPE_PURE)
        and bot:IsFacingLocation(enemyHero:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot)
    then
        if  nAllyHeroes ~= nil and nEnemyHeroes ~= nil
        and #nEnemyHeroes > #nAllyHeroes
        and J.IsValidHero(nEnemyHeroes[1])
        and bot:IsFacingLocation(nEnemyHeroes[1]:GetLocation(), 30)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLittleFriends()
    if not LittleFriends:IsTrained()
    or not LittleFriends:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = LittleFriends:GetCastRange()
    local nRadius = LittleFriends:GetSpecialValueInt('radius')
    local nDuration = LittleFriends:GetSpecialValueInt('duration')

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.GetHP(enemyHero) < 0.33
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere')
        then
            bot:SetTarget(enemyHero)
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot, 1200)
    then
        local botTarget = J.GetStrongestUnit(nCastRange, bot, true, false, nDuration)
        local nTargetInRangeEnemy = botTarget:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
        local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 150, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

        if  J.IsValidTarget(botTarget)
        and nInRangeAlly ~= nil and nInRangeEnemy
        and #nInRangeAlly >= #nInRangeEnemy
        and #nTargetInRangeEnemy >= 1
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 150, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and #nInRangeEnemy > #nInRangeAlly
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], nCastRange)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
        end
    end

    if J.IsDoingRoshan(bot)
    then
        local botTarget = bot:GetAttackTarget()

        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X