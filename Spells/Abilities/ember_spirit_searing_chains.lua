local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SearingChains

function X.Cast()
    bot = GetBot()
    SearingChains = bot:GetAbilityByName('ember_spirit_searing_chains')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SearingChains)
        return
    end
end

function X.Consider()
    if not SearingChains:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = SearingChains:GetSpecialValueInt('radius')
	local nDamage = SearingChains:GetSpecialValueInt('damage_per_second')
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local botTarget = J.GetProperTarget(bot)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and not J.IsDisabled(enemyHero)
		then
			if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget )
        and not botTarget:IsAttackImmune()
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
			then
				if enemyHero:HasModifier('modifier_item_glimmer_cape')
				or enemyHero:HasModifier('modifier_invisible')
				or enemyHero:HasModifier('modifier_item_shadow_amulet_fade')
				then
					if  not enemyHero:HasModifier('modifier_item_dustofappearance')
					and not enemyHero:HasModifier('modifier_slardar_amplify_damage')
					and not enemyHero:HasModifier('modifier_bloodseeker_thirst_vision')
					and not enemyHero:HasModifier('modifier_sniper_assassinate')
					and not enemyHero:HasModifier('modifier_bounty_hunter_track')
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsDisarmed()
        and bot:WasRecentlyDamagedByAnyHero(3.5)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and not J.IsDisabled(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(bot) > 0.2
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X