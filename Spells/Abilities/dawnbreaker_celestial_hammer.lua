local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CelestialHammer

function X.Cast()
    bot = GetBot()
    CelestialHammer = bot:GetAbilityByName('dawnbreaker_celestial_hammer')

    if bot.IsHammerCastedWhenRetreatingToEnemy == nil then bot.IsHammerCastedWhenRetreatingToEnemy = false end
    if bot.ConvergeHammerLocation == nil then bot.ConvergeHammerLocation = bot:GetLocation() end
    if bot.CelestialHammerTime == nil then bot.CelestialHammerTime = -1 end

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)

        local nSpeed = CelestialHammer:GetSpecialValueInt('projectile_speed')
        bot.ConvergeHammerLocation = Location

        if bot:GetUnitName() == 'npc_dota_hero_dawnbreaker'
        then
            local CelestialHammerCastRangeTalent = bot:GetAbilityByName('special_bonus_unique_dawnbreaker_celestial_hammer_cast_range')
            if CelestialHammerCastRangeTalent:IsTrained()
            then
                nSpeed = nSpeed * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
            end
        end

        bot:ActionQueue_UseAbilityOnLocation(CelestialHammer, Location)
        CelestialHammerTime = DotaTime() + CelestialHammer:GetCastPoint() + (GetUnitToLocationDistance(bot, Location) / nSpeed)
        return
    end
end

function X.Consider()
    if not CelestialHammer:IsFullyCastable()
    or bot:HasModifier('modifier_starbreaker_fire_wreath_caster')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = CelestialHammer:GetSpecialValueInt('range')
	local nCastPoint = CelestialHammer:GetCastPoint()
    local nSpeed = CelestialHammer:GetSpecialValueInt('projectile_speed')
    local nDamage = CelestialHammer:GetSpecialValueInt('hammer_damage')
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

    local nEnemyHeroes = bot:GetNearbyHeroes(math.min(nCastRange, 1600), true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(math.min(nCastRange, 1600), true)

    for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint

            if J.IsRunning(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
            else
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, 300)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            if J.IsRunning(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
		if J.IsValidHero(nEnemyHeroes[1])
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		and not J.IsRealInvisible(bot)
		then
            local nDelay = (GetUnitToUnitDistance(bot, nEnemyHeroes[1]) / nSpeed) + nCastPoint

            if GetUnitToUnitDistance(bot, nEnemyHeroes[1]) > 600
            then
                bot.IsHammerCastedWhenRetreatingToEnemy = true
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nEnemyHeroes[1], nDelay)
            else
                bot.IsHammerCastedWhenRetreatingToEnemy = false
                local loc = J.GetEscapeLoc()
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
            end
		end
	end

    if  J.IsLaning(bot)
    and J.GetManaAfter(CelestialHammer:GetManaCost()) > 0.55
	then

        for _, creep in pairs(nEnemyLaneCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
            and creep:GetHealth() <= nDamage
            and not J.IsRunning(creep)
            then
                if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
                then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X