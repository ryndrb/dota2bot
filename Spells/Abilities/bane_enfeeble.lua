local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Enfeeble

function X.Cast()
    bot = GetBot()
    Enfeeble = bot:GetAbilityByName('bane_enfeeble')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Enfeeble, Target)
        return
    end
end

function X.Consider()
    if not Enfeeble:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nSkillLV = Enfeeble:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, Enfeeble:GetCastRange())
	local nInRangeEnemy = J.GetAroundEnemyHeroList(nCastRange)
    local botTarget = J.GetProperTarget(bot)

    if J.IsInTeamFight(bot, 1200)
    then
        local nTarget = J.GetHighestRightClickDamageHero(nInRangeEnemy)
        if J.IsValidHero(nTarget)
        and J.CanCastOnNonMagicImmune(nTarget)
        and J.CanCastOnTargetAdvanced(nTarget)
        and not nTarget:HasModifier('modifier_bane_enfeeble')
        and not nTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, nTarget
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 50)
        and not botTarget:HasModifier('modifier_bane_enfeeble')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if nSkillLV >= 2 or J.GetMP(bot) > 0.5
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end

		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_bane_enfeeble')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X