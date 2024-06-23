local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BrainSap

function X.Cast()
    bot = GetBot()
    BrainSap = bot:GetAbilityByName('bane_brain_sap')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if J.CheckBitfieldFlag(BrainSap:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)
        then
            bot:ActionQueue_UseAbilityOnEntity(BrainSap, Target)
        else
            bot:ActionQueue_UseAbilityOnLocation(BrainSap, Target:GetLocation())
        end

        return
    end
end

function X.Consider()
    if not BrainSap:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nSkillLV = BrainSap:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, BrainSap:GetCastRange())
	local nCastPoint = BrainSap:GetCastPoint()
	local nManaCost = BrainSap:GetManaCost()
	local nDamage = BrainSap:GetSpecialValueInt('brain_sap_damage')
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nLostHealth = bot:GetMaxHealth() - bot:GetHealth()
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    if bot:GetUnitName() == 'npc_dota_hero_bane'
    then
        local Talent8 = bot:GetAbilityByName('special_bonus_unique_bane_2')
        if Talent8 ~= nil then nDamage = nDamage + Talent8:GetSpecialValueInt('value') end
    end

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.WillMagicKillTarget(bot, enemyHero, nDamage, nCastPoint)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if bot:GetLevel() <= 7 and J.GetMP(bot) < 0.72 and nLostHealth < nDamage * 0.8
	then
        return BOT_ACTION_DESIRE_NONE
    end

	if J.IsInTeamFight(bot, 1200)
	then
		local nWeakestEnemy = nil
		local nWeakestEnemyHealth = 99999

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyHealth = enemyHero:GetHealth()
				if npcEnemyHealth < nWeakestEnemyHealth
				then
					nWeakestEnemyHealth = npcEnemyHealth
					nWeakestEnemy = enemyHero
				end
			end
		end

		if nWeakestEnemy ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nWeakestEnemy
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 50)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if nSkillLV >= 2 or J.GetMP(bot) > 0.78 or J.GetHP(botTarget) < 0.38
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if  bot:WasRecentlyDamagedByAnyHero(3)
    and bot:GetLevel() >= 10
    and nLostHealth >= nDamage
    and not J.IsRetreating(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:IsFacingLocation(enemyHero:GetLocation(), 45)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsRetreating(bot) and nLostHealth > nDamage
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) or nLostHealth > nDamage * 2)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end

		if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and bot:GetLevel() >= 10
        and nLostHealth > nDamage * 1.5
        and not bot:WasRecentlyDamagedByAnyHero(3)
		then
			local nCreepList = bot:GetNearbyCreeps(1600, true)
			for _, creep in pairs(nCreepList)
			do
				if  J.IsValid(creep)
				and J.IsInRange(bot, creep, nCastRange)
                and J.CanCastOnNonMagicImmune(creep)
                and J.CanBeAttacked(creep)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if  J.IsFarming(bot)
    and J.IsAllowedToSpam(bot, nManaCost)
    and nSkillLV >= 3
	then
		local targetCreep = botTarget

		if  J.IsValid(targetCreep)
        and J.IsInRange(bot, targetCreep, nCastRange + 100)
        and targetCreep:GetTeam() == TEAM_NEUTRAL
        and not J.IsRoshan(targetCreep)
        and (targetCreep:GetMagicResist() < 0.3 or J.GetMP(bot) > 0.8)
        and not J.CanKillTarget(targetCreep, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming( bot ))
    and J.IsAllowedToSpam( bot, nManaCost * 0.32 )
    and nSkillLV >= 3
    and DotaTime() > 8 * 60
    and (J.IsCore(bot) or (not J.IsCore(bot) and nAllyHeroes ~= nil and #nAllyHeroes <= 2))
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local keyWord = "ranged"
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and (J.IsKeyWordUnit(keyWord, creep) or J.GetMP(bot) > 0.6)
            and J.WillKillTarget(creep, nDamage, nDamageType, nCastPoint)
            and J.CanBeAttacked(creep)
            and not J.CanKillTarget( creep, bot:GetAttackDamage() * 1.38, DAMAGE_TYPE_PHYSICAL)
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

    if  J.IsLaning(bot)
    and (J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1000)))
	then
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
            and J.WillKillTarget(creep, nDamage, nDamageType, nCastPoint)
            and not J.CanKillTarget( creep, bot:GetAttackDamage() * 1.38, DAMAGE_TYPE_PHYSICAL)
			then
				if  J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 500
                and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and not J.IsDisabled(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if  (nEnemyHeroes ~= nil and #nEnemyHeroes > 0 or bot:WasRecentlyDamagedByAnyHero(3))
    and (not J.IsRetreating(bot) or #nAllyHeroes ~= nil and #nAllyHeroes >= 2)
    and bot:GetLevel() >= 12
    and nLostHealth > nDamage
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X