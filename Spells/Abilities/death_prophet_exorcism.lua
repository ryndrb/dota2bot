local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Exorcism

function X.Cast()
    bot = GetBot()
    Exorcism = bot:GetAbilityByName('death_prophet_exorcism')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Exorcism)
        return
    end
end

function X.Consider()
    if not Exorcism:IsFullyCastable() or bot:HasModifier( 'modifier_death_prophet_exorcism' )
    then return 0 end

    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if J.IsGoingOnSomeone( bot )
    then
        if J.IsValidHero( botTarget )
        and ( J.IsInRange( bot, botTarget, 700 )
            or ( #nEnemyHeroes >= 3 and J.IsInRange( bot, botTarget, 1200 ) ) )
        and J.CanCastOnMagicImmune( botTarget )
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    local nAllyCreepList = bot:GetNearbyLaneCreeps( 1000, false )
    if J.IsPushing( bot ) and nAllyCreepList ~= nil and #nAllyCreepList >= 1
    then
        if J.IsValidBuilding( botTarget )
        and J.IsInRange( bot, botTarget, 800 )
        and not botTarget:HasModifier( 'modifier_fountain_glyph' )
        and not botTarget:HasModifier( 'modifier_backdoor_protection' )
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X