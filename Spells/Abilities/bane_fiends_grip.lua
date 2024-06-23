local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FiendsGrip

function X.Cast()
    bot = GetBot()
    FiendsGrip = bot:GetAbilityByName('bane_fiends_grip')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(FiendsGrip, Target)
        return
    end
end

function X.Consider()
    if not FiendsGrip:IsFullyCastable()
	then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local _, BrainSap = J.HasAbility(bot, 'bane_brain_sap')
	local nCastRange = J.GetProperCastRange(false, bot, FiendsGrip:GetCastRange())
	local nDamage = FiendsGrip:GetSpecialValueInt( 'fiend_grip_damage' ) * 6
	local nDamageType = DAMAGE_TYPE_PURE
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local botTarget = J.GetProperTarget(bot)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValid(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.IsInRange(bot, enemyHero, nCastRange + 75)
            and J.CanKillTarget(enemyHero, nDamage, nDamageType)
			and not J.IsHaveAegis(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

		end
	end

    if BrainSap ~= nil and BrainSap:IsFullyCastable() and bot:GetMana() > FiendsGrip:GetManaCost() + BrainSap:GetManaCost() then return BOT_ACTION_DESIRE_NONE, nil end

	if J.IsInTeamFight(bot, 1200)
	then
		local npcStrongestEnemy = nil
		local nStrongestPower = 0

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not J.IsHaveAegis(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyPower = enemyHero:GetEstimatedDamageToTarget(true, bot, 6.0, DAMAGE_TYPE_ALL)
				if npcEnemyPower > nStrongestPower
				then
					nStrongestPower = npcEnemyPower
					npcStrongestEnemy = enemyHero
				end
			end
		end

		if  npcStrongestEnemy ~= nil
        and J.IsInRange(bot, npcStrongestEnemy, nCastRange + 150)
		then
			return BOT_ACTION_DESIRE_HIGH, npcStrongestEnemy
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(botTarget, bot, nCastRange + 75)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not J.IsHaveAegis(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end


	return BOT_ACTION_DESIRE_NONE, nil
end

return X