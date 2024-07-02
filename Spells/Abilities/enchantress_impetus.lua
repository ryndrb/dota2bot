local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Impetus

function X.Cast()
    bot = GetBot()
    Impetus = bot:GetAbilityByName('enchantress_impetus')

    X.Consider()
end

function X.Consider()
    if not Impetus:IsFullyCastable()
    then
        if Impetus:ToggleAutoCast() == true
        then
            return Impetus:ToggleAutoCast()
        end

        return
    end

    local nAttackRange = bot:GetAttackRange()
    local nAbilityLevel = Impetus:GetLevel()
    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:IsAttackImmune()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                return
            end
        end
    end

    if J.IsFarming(bot)
    and nAbilityLevel == 4
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nAttackRange)

        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.CanBeAttacked(nNeutralCreeps[1])
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                if Impetus:GetAutoCastState() == true and J.GetMP(bot) < 0.35
                then
                    return Impetus:ToggleAutoCast()
                end

                return
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and not botTarget:IsAttackImmune()
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                if Impetus:GetAutoCastState() == true and J.GetMP(bot) < 0.25
                then
                    return Impetus:ToggleAutoCast()
                end

                return
            end
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                if Impetus:GetAutoCastState() == true and J.GetMP(bot) < 0.25
                then
                    return Impetus:ToggleAutoCast()
                end

                return
            end
        end
    end

    if Impetus:GetAutoCastState() == true
    then
        return Impetus:ToggleAutoCast()
    end
end

return X