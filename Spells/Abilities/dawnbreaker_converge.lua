local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Converge

function X.Cast()
    bot = GetBot()
    Converge = bot:GetAbilityByName('dawnbreaker_converge')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Converge)
        return
    end
end

function X.Consider()
    if Converge:IsHidden()
    or not Converge:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = 700 + ((Converge:GetLevel() - 1) * 200)
    local nSpeed = 1500
    local botTarget = J.GetProperTarget(bot)

    if bot:GetUnitName() == 'npc_dota_hero_dawnbreaker'
    then
        local CelestialHammerCastRangeTalent = bot:GetAbilityByName('special_bonus_unique_dawnbreaker_celestial_hammer_cast_range')
        if CelestialHammerCastRangeTalent:IsTrained()
        then
            nCastRange = nCastRange * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
            nSpeed = nSpeed * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if  J.IsGoingOnSomeone(bot)
    and bot.ConvergeHammerLocation ~= nil
    then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and not J.IsInRange(bot, botTarget, 300)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            if GetUnitToLocationDistance(botTarget, bot.ConvergeHammerLocation) < GetUnitToLocationDistance(bot, bot.ConvergeHammerLocation)
            and DotaTime() >= bot.CelestialHammerTime
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
    end

    if  J.IsRetreating(bot)
    and bot.IsHammerCastedWhenRetreatingToEnemy == false
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3)
    then
		if J.IsValidHero(nEnemyHeroes[1])
		then
            local loc = J.GetEscapeLoc()
            if  bot:IsFacingLocation(loc, 30)
            and DotaTime() >= bot.CelestialHammerTime
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X