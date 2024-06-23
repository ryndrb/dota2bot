local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Bloodrage

function X.Cast()
    bot = GetBot()
    Bloodrage = bot:GetAbilityByName('bloodseeker_bloodrage')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Bloodrage, Target)
        return
    end
end

function X.Consider()
    if not Bloodrage:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, Bloodrage:GetCastRange())
	local nDamage = bot:GetAttackDamage()

	local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200) or J.IsPushing(bot) or J.IsDefending(bot)
	then
		if nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
        then
			local highesAD = 0
			local highesADUnit = nil

			for _, allyHero in pairs(nAllyHeroes)
			do
				if J.IsValidHero(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange + 150)
                and allyHero:GetAttackTarget() ~= nil
                and J.CanCastOnNonMagicImmune(allyHero)
                and ( J.GetHP(allyHero) > 0.18 or J.GetHP(allyHero:GetAttackTarget() ) < 0.18 )
                and not allyHero:HasModifier( 'modifier_bloodseeker_bloodrage' )
				then
                    local AllyAD = allyHero:GetAttackDamage()
                    if AllyAD > highesAD
                    then
                        highesAD = AllyAD
                        highesADUnit = allyHero
                    end
				end
			end

			if highesADUnit ~= nil
            then
				return BOT_ACTION_DESIRE_HIGH, highesADUnit
			end

		end

	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
        and not botTarget:IsAttackImmune()
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(botTarget, bot, 600)
        and not bot:HasModifier( 'modifier_bloodseeker_bloodrage' )
		then
            return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	if J.IsValid( botTarget ) and botTarget:GetTeam() == TEAM_NEUTRAL
	and not bot:HasModifier('modifier_bloodseeker_bloodrage')
	then
		local nCreeps = bot:GetNearbyCreeps(1000, true)
		for _, creep in pairs(nCreeps)
		do
			if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
			then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_bloodseeker_bloodrage')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_bloodseeker_bloodrage')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X