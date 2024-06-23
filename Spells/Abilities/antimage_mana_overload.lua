local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BlinkFragment

function X.Cast()
	bot = GetBot()
	BlinkFragment = bot:GetAbilityByName('antimage_mana_overload')

	Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BlinkFragment, Location)
		return
    end
end

function X.Consider()
    if not bot:HasScepter()
	or not BlinkFragment:IsTrained()
	or not BlinkFragment:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, BlinkFragment:GetCastRange())
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local hp = 99999
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidTarget(enemyHero)
			and J.CanCastOnMagicImmune(enemyHero)
			and not J.IsInRange(bot, enemyHero, nCastRange / 2)
			and not enemyHero:IsAttackImmune()
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if hp < enemyHero:GetHealth()
				then
					hp = enemyHero:GetHealth()
					target = enemyHero
				end
			end
		end

		if target ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
        do
			if  J.IsValidHero(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X