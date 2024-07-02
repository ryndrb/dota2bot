local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local GeomagneticGrip

local nStone

function X.Cast()
    bot = GetBot()
    GeomagneticGrip = bot:GetAbilityByName('earth_spirit_geomagnetic_grip')

    local _, StoneRemnant = J.HasAbility(bot, 'earth_spirit_stone_caller')

    if StoneRemnant ~= nil and StoneRemnant:IsFullyCastable()
    then
        nStone = 1
    else
        nStone = 0
    end

    Desire, Location, CanRemnantGrip = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if CanRemnantGrip
		then
			bot:Action_ClearActions(false)
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, Location)
			bot:ActionQueue_UseAbilityOnLocation(GeomagneticGrip, Location)
			return
		else
            bot:ActionQueue_UseAbilityOnLocation(GeomagneticGrip, Location)
			return
		end
    end
end

function X.Consider()
    if not GeomagneticGrip:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, GeomagneticGrip:GetCastRange())
	local nCastPoint = GeomagneticGrip:GetCastPoint()
	local nDamage = GeomagneticGrip:GetSpecialValueInt('rock_damage')

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not J.IsInRange(bot, enemyHero, bot:GetAttackRange())
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local loc = J.GetCorrectLoc(enemyHero, nCastPoint)

            if X.IsStoneNearTarget(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, loc, false
            elseif nStone >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, loc, true
            end
        end
    end

	if J.IsLaning(bot)
    and J.GetMP(bot) > 0.33
	then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

        for _, creep in pairs(nEnemyLaneCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and J.IsKeyWordUnit('ranged', creep)
            and creep:GetHealth() <= nDamage
            then
                if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
                then
                    if nStone >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), true
                    elseif X.IsStoneNearTarget(creep)
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), false
                    end

                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.IsStoneNearTarget(target)
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIED_OTHER))
	do
		if  u ~= nil
		and u:GetUnitName() == "npc_dota_earth_spirit_stone"
		and GetUnitToLocationDistance(u, target:GetLocation()) < 180
		then
			return true
		end
	end

	return false
end

return X