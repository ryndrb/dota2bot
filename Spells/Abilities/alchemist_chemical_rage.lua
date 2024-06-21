local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ChemicalRage

function X.Cast()
	bot = GetBot()
	ChemicalRage = bot:GetAbilityByName('alchemist_chemical_rage')

	Desire = X.Consider()
	if Desire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ChemicalRage)
		return
	end
end

function X.Consider()
    if not ChemicalRage:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nRealInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 700)
		if nRealInRangeEnemy ~= nil and #nRealInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nTargetInRangeAlly = botTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and #nInRangeAlly >= #nTargetInRangeAlly
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and J.IsValidHero(nInRangeEnemy[1])
		and J.IsRunning(nInRangeEnemy[1])
        and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		and not J.IsDisabled(nInRangeEnemy[1])
		and not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
		and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(800, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or (J.GetHP(bot) < 0.35 and bot:WasRecentlyDamagedByAnyHero(1.5)))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	if J.IsFarming(bot)
	then
		if  J.IsAttacking(bot)
		and J.IsValid(botTarget)
		and botTarget:IsCreep()
		and J.GetHP(bot) < 0.3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		and (J.IsModeTurbo() and DotaTime() < 15 * 60 or DotaTime() < 30 * 60)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
		and (J.IsModeTurbo() and DotaTime() < 16 * 60 or DotaTime() < 32 * 60)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X