local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local IonShell

function X.Cast()
    bot = GetBot()
    IonShell = bot:GetAbilityByName('dark_seer_ion_shell')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(IonShell, Target)
        return
    end
end

function X.Consider()
	if not IonShell:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, IonShell:GetCastRange())
    local nRadius = IonShell:GetSpecialValueInt('radius')
    local nAbilityLevel = IonShell:GetLevel()

    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(1600, false)
    local nEnemyTowers = bot:GetNearbyTowers(700, true)

    if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local maxTargetCount = 1

        if nAllyHeroes ~= nil and #nAllyHeroes >= 1
        then
            for _, allyHero in pairs(nAllyHeroes)
            do
                if  J.IsValidHero(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange)
                and not allyHero:IsIllusion()
                and not allyHero:HasModifier('modifier_dark_seer_ion_shell')
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nAllyCount = 0
                    local nAllyEnemyHeroes = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                    local nAllyEnemyCreeps = allyHero:GetNearbyCreeps(1200, true)

                    for _, allyEnemyHero in pairs(nAllyEnemyHeroes)
                    do
                        if J.IsValidHero(allyEnemyHero)
                        and allyEnemyHero:GetAttackTarget() == allyHero
                        and not J.IsSuspiciousIllusion(allyEnemyHero)
                        and allyHero:GetAttackRange() <= 326
                        then
                            nAllyCount = nAllyCount + 1
                        end
                    end

                    for _, creep in pairs(nAllyEnemyCreeps)
                    do
                        if J.IsValid(creep)
                        and creep:GetAttackTarget() == allyHero
                        and creep:GetAttackRange() <= 326
                        then
                            nAllyCount = nAllyCount + 1
                        end
                    end

                    if nAllyCount > maxTargetCount
                    then
                        maxTargetCount = nAllyCount
                        target = allyHero
                    end
                end
            end
        else
            if  J.IsValidTarget(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and not J.IsSuspiciousIllusion(botTarget)
            and not bot:HasModifier('modifier_dark_seer_ion_shell')
            then
                target = bot
            end
        end

        if target ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, target
        end
	end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > 0.75
    and bot:WasRecentlyDamagedByAnyHero(3.5)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
        if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and nAllyLaneCreeps ~= nil and #nAllyLaneCreeps >= 1
        then
            local targetCreep = nil
            local targetDis = 0

            for _, creep in pairs(nAllyLaneCreeps)
            do
                if  J.IsValid(creep)
                and J.IsInRange(bot, creep, nCastRange)
                and J.GetHP(creep) > 0.75
                and creep:DistanceFromFountain() > targetDis
                and creep:GetAttackRange() <= 326
                and not creep:HasModifier('modifier_dark_seer_ion_shell')
                then
                    targetCreep = creep
                    targetDis = creep:DistanceFromFountain()
                end
            end

            if targetCreep ~= nil
            then
                return BOT_ACTION_DESIRE_HIGH, targetCreep
            end
        end
	end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(600, true)

        if  J.IsValid(botTarget)
        and botTarget:IsCreep()
        and nCreeps ~= nil and #nCreeps >= 2
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsLaning(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and nEnemyTowers ~= nil and #nEnemyTowers == 0
        and nAbilityLevel >= 2
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X