local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local InkExplosion

function X.Cast()
    bot = GetBot()
    InkExplosion = bot:GetAbilityByName('grimstroke_return')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(InkExplosion)
        return
    end
end

function X.Consider()
    if InkExplosion:IsHidden()
    or not InkExplosion:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local InkSwell = bot:GetAbilityByName('grimstroke_spirit_walk')

    local nRadius = InkSwell:GetSpecialValueInt('radius')
    local nDuration = InkSwell:GetSpecialValueInt('buff_duration')

    if DotaTime() < bot.InkSwellCastTime + nDuration
    then
        local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and enemyHero:IsChanneling()
            and not J.IsDisabled(enemyHero)
            and bot:HasModifier('modifier_grimstroke_spirit_walk_buff')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        for i = 1, 5
        do
            local allyHero = GetTeamMember(i)

            if J.IsValidHero(allyHero)
            then
                local nInRangeAllyEnemy = allyHero:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

                for _, allyEnemyHero in pairs(nInRangeAllyEnemy)
                do
                    if  J.IsValidHero(allyEnemyHero)
                    and J.CanCastOnNonMagicImmune(allyEnemyHero)
                    and allyEnemyHero:IsChanneling()
                    and not J.IsDisabled(allyEnemyHero)
                    and allyHero:HasModifier('modifier_grimstroke_spirit_walk_buff')
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X