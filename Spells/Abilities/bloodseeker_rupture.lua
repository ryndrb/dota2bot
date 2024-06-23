local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Rupture

function X.Cast()
    bot = GetBot()
    Rupture = bot:GetAbilityByName('bloodseeker_rupture')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Rupture, Target)
        return
    end
end

function X.Consider()
    if not Rupture:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Rupture:GetCastRange())

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local botTarget = J.GetProperTarget(bot)

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.75 and bot:WasRecentlyDamagedByHero(enemyHero, 2.5))
            and J.IsInRange(bot, enemyHero, nCastRange + 150)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
        -- mobile heroes
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and not J.IsDisabled(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and X.IsMobileHero(enemyHero:GetUnitName())
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and not J.IsDisabled(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsCore(enemyHero)
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and not J.IsDisabled( botTarget )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange + 150 )
        and not botTarget:HasModifier( 'modifier_bloodseeker_rupture' )
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local allies = botTarget:GetNearbyHeroes( 1200, true, BOT_MODE_NONE )
			if ( allies ~= nil and #allies >= 2 )
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.IsMobileHero(hName)
    local Hero = {
        ['npc_dota_hero_earth_spirit'] = true,
        ['npc_dota_hero_night_stalker'] = true,
        ['npc_dota_hero_slardar'] = true,
        ['npc_dota_hero_spirit_breaker'] = true,
        ['npc_dota_hero_shredder'] = true,
        ['npc_dota_hero_ember_spirit'] = true,
        ['npc_dota_hero_morphling'] = true,
        ['npc_dota_hero_razor'] = true,
        ['npc_dota_hero_slark'] = true,
        ['npc_dota_hero_weaver'] = true,
        ['npc_dota_hero_storm_spirit'] = true,
        ['npc_dota_hero_batrider'] = true,
        ['npc_dota_hero_magnataur'] = true,
        ['npc_dota_hero_mirana'] = true,
        ['npc_dota_hero_pangolier'] = true,
        ['npc_dota_hero_windrunner'] = true,
    }

    if Hero[hName] == nil then return false end
    return Hero[hName]
end

return X