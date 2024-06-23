local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ManaVoid

function X.Cast()
	bot = GetBot()
	ManaVoid = bot:GetAbilityByName('antimage_mana_void')

	Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ManaVoid, Target)
		return
    end
end

function X.Consider()
    if not ManaVoid:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = ManaVoid:GetCastRange()
	local nRadius = ManaVoid:GetSpecialValueInt('mana_void_aoe_radius')
	local nDamagaPerHealth = ManaVoid:GetSpecialValueFloat('mana_void_damage_per_mana')
    local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nCastTarget = nil
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange + 300, true, BOT_MODE_NONE)
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if J.IsValidHero(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsHaveAegis(enemyHero)
			and not enemyHero:HasModifier('modifier_arc_warden_tempest_double')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				local nDamage = nDamagaPerHealth * (enemyHero:GetMaxMana() - enemyHero:GetMana())
				if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
				then
					if J.IsCore(enemyHero)
					then
						nCastTarget = enemyHero
						break
					else
						nCastTarget = enemyHero
					end
				end
			end
		end

		if nCastTarget ~= nil
		then
			bot:SetTarget(nCastTarget)
			return BOT_ACTION_DESIRE_HIGH, nCastTarget
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsHaveAegis(botTarget)
		and not botTarget:HasModifier('modifier_arc_warden_tempest_double')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			local nDamage = nDamagaPerHealth * (botTarget:GetMaxMana() - botTarget:GetMana())
			if J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X