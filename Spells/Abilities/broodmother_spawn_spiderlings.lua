local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SpawnSpiderlings

function X.Cast()
    bot = GetBot()
    SpawnSpiderlings = bot:GetAbilityByName('broodmother_spawn_spiderlings')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SpawnSpiderlings, Target)
        return
    end
end

function X.Consider()
    if not SpawnSpiderlings:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, SpawnSpiderlings:GetCastRange())
	local nDamage = SpawnSpiderlings:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    local nCreeps = bot:GetNearbyCreeps(nCastRange, true)
    for _, creep in pairs(nCreeps)
    do
        if  J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsRetreating(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, creep
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X