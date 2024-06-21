local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local MagneticField

function X.Cast()
    bot = GetBot()
    MagneticField = bot:GetAbilityByName('arc_warden_magnetic_field')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(MagneticField)
        return
    end
end

function X.Consider()
    if not MagneticField:IsFullyCastable()
	or X.IsDoubleCasting()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, MagneticField:GetCastRange())
	local nRadius = MagneticField:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(false, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if  nLocationAoE.count >= 2
		and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) <= bot:GetAttackRange()
		then
			local nInRangeAlly = J.GetAlliesNearLoc(nLocationAoE.targetloc, nRadius)
			if  J.IsValidHero(nInRangeAlly[1])
			and nInRangeAlly[1]:GetAttackTarget() ~= nil
			and GetUnitToUnitDistance(nInRangeAlly[1], nInRangeAlly[1]:GetAttackTarget()) <= nInRangeAlly[1]:GetAttackRange() + 50
			and not nInRangeAlly[1]:HasModifier('modifier_arc_warden_magnetic_field')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		then
			local nInRangeAllyAttack = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_ATTACK)
			for _, allyHero in pairs(nInRangeAllyAttack)
			do
				local allyTarget = allyHero:GetAttackTarget()
				if  J.IsValidHero(allyHero)
				and (J.IsInRange(bot, allyHero, nRadius) and not allyHero:HasModifier('modifier_arc_warden_magnetic_field'))
				and (J.IsValidTarget(allyTarget) and GetUnitToUnitDistance(allyHero, allyTarget) <= allyHero:GetAttackRange())
				and not J.IsSuspiciousIllusion(allyHero)
				and not J.IsSuspiciousIllusion(allyTarget)
				and not allyTarget:HasModifier('modifier_abaddon_borrowed_time')
				then
					local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
					local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

					if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
					and #nInRangeAlly >= #nInRangeEnemy
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if  (J.IsDefending(bot) or J.IsPushing(bot))
	and not bot:HasModifier('modifier_arc_warden_magnetic_field')
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(888, true)
		local nEnemyTowers = bot:GetNearbyTowers(888, true)
		local nEnemyBarracks bot:GetNearbyBarracks(888, true)
		local sEnemyTowers bot:GetNearbyFillers(888, true)

		if J.IsAttacking(bot)
		then
			if (nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3)
			or (nEnemyTowers ~= nil and #nEnemyTowers >= 1)
			or (nEnemyBarracks ~= nil and #nEnemyBarracks >= 1)
			or (sEnemyTowers ~= nil and #sEnemyTowers >= 1)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if  J.IsFarming(bot)
	and J.GetManaAfter(MagneticField:GetManaCost()) > 0.4
	and not bot:HasModifier('modifier_arc_warden_magnetic_field')
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(888, true)

		if J.IsAttacking(bot)
		then
			if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			local nNeutralCreeps = bot:GetNearbyNeutralCreeps(888)
			if  nNeutralCreeps ~= nil
			and (#nNeutralCreeps >= 3 or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if  J.IsDoingRoshan(bot)
	and not bot:HasModifier('modifier_arc_warden_magnetic_field')
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  J.IsDoingTormentor(bot)
	and not bot:HasModifier('modifier_arc_warden_magnetic_field')
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsDoubleCasting()
	if bot.TempestDouble == nil or not bot.TempestDouble:IsAlive()
	then
		return false
	end

	for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
	do
		if J.IsValid(allyHero)
		and allyHero ~= bot
		and allyHero:GetUnitName() == "npc_dota_hero_arc_warden"
		and (allyHero:IsCastingAbility() or allyHero:IsUsingAbility())
		then
			return true
		end
	end

	return false
end

return X