local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local DeathPact

function X.Cast()
    bot = GetBot()
    DeathPact = bot:GetAbilityByName('clinkz_death_pact')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DeathPact, Target)
        return
    end
end

function X.Consider()
    if not DeathPact:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DeathPact:GetCastRange())
    local nMaxLevel = DeathPact:GetSpecialValueInt('creep_level')
    local nCreeps = bot:GetNearbyCreeps(nCastRange, true)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

    local botTarget = J.GetProperTarget(bot)

    if J.IsInLaningPhase()
    then
        if J.IsLaning(bot)
        then
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

            for _, creep in pairs(nEnemyLaneCreeps)
            do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep)
                and creep:GetLevel() <= nMaxLevel
                then
                    if J.IsValidHero(nEnemyHeroes[1])
                    and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 600
                    and botTarget ~= creep
                    and not bot:HasModifier('modifier_clinkz_death_pact')
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    else
        local creep = X.GetMostHPCreepLevel(nCreeps, nMaxLevel)
        if creep ~= nil and creep:CanBeSeen() and creep:IsAlive()
        and J.CanBeAttacked(creep)
        and not bot:HasModifier('modifier_clinkz_death_pact')
        and not creep:IsAncientCreep()
        then
            return BOT_ACTION_DESIRE_HIGH, creep
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.GetMostHPCreepLevel(creeList, level)
	local mostHpCreep = nil
	local maxHP = 0

	for _, creep in pairs(creeList)
	do
        if J.IsValid(creep)
        then
            local uHp = creep:GetHealth()
            local lvl = creep:GetLevel()

            if uHp > maxHP
            and lvl <= level
            and not J.IsKeyWordUnit("flagbearer", creep)
            then
                mostHpCreep = creep
                maxHP = uHp
            end
        end
	end

	return mostHpCreep
end

return X