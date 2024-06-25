local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Devour

function X.Cast()
    bot = GetBot()
    Devour = bot:GetAbilityByName('doom_bringer_devour')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Devour, Target)
        return
    end
end

function X.Consider()
    if not Devour:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nMaxLevel = Devour:GetSpecialValueInt('creep_level')
    local nCreeps = bot:GetNearbyCreeps(1200, true)

    local talent15left = bot:GetAbilityByName('special_bonus_unique_doom_2')

    if not J.IsRetreating(bot)
    then
        local nEnemyTowers = bot:GetNearbyTowers(1600, true)
        local nCreepTarget = X.GetRangedOrSiegeCreep(nCreeps, nMaxLevel)

        if J.IsValid(nCreepTarget)
        then
            if  J.IsLaning(bot)
            and nEnemyTowers ~= nil
            and (#nEnemyTowers == 0
                or #nEnemyTowers >= 1 and J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToUnitDistance(nCreepTarget, nEnemyTowers[1]) > 700)
            then
                return BOT_ACTION_DESIRE_HIGH, nCreepTarget
            end
        end

        for _, creep in pairs(nCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetLevel() <= nMaxLevel
            and not J.IsRoshan(creep)
            and not J.IsTormentor(creep)
            then
                if  J.IsInLaningPhase()
                and creep:GetTeam() ~= bot:GetTeam()
                and creep:GetTeam() ~= TEAM_NEUTRAL
                and nEnemyTowers ~= nil
                and (#nEnemyTowers == 0
                    or #nEnemyTowers >= 1
                        and J.IsValidBuilding(nEnemyTowers[1])
                        and GetUnitToUnitDistance(creep, nEnemyTowers[1]) > 700)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                nCreepTarget = nil
                if creep:GetTeam() == TEAM_NEUTRAL
                then
                    nCreepTarget = J.GetMostHpUnit(nCreeps)
                end

                if nCreepTarget ~= nil and nCreepTarget:CanBeSeen()
                then
                    if string.find(bot:GetUnitName(), 'doom_bringer')
                    and nCreepTarget:IsAncientCreep()
                    and talent15left:IsTrained()
                    then
                        return BOT_ACTION_DESIRE_HIGH, nCreepTarget
                    end

                    if not nCreepTarget:IsAncientCreep()
                    then
                        return BOT_ACTION_DESIRE_HIGH, nCreepTarget
                    end
                end

                if not creep:IsAncientCreep()
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.GetRangedOrSiegeCreep(nCreeps, lvl)
	for _, creep in pairs(nCreeps)
	do
		if  J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and creep:GetLevel() <= lvl
        and (J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('ranged', creep))
        and not J.IsRoshan(creep)
        and not J.IsTormentor(creep)
		then
			return creep
		end
	end

	return nil
end

return X