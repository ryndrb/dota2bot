local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BattleHunger

function X.Cast()
    bot = GetBot()
    BattleHunger = bot:GetAbilityByName('axe_battle_hunger')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(BattleHunger, Target)
        return
    end
end

function X.Consider()
    if not BattleHunger:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nSkillLV = BattleHunger:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, BattleHunger:GetCastRange())
	local nManaCost = BattleHunger:GetManaCost()

	local nDuration = BattleHunger:GetSpecialValueInt('duration')
	local nDamage = BattleHunger:GetSpecialValueInt('damage_per_second') * nDuration

	local nInRangeEnemyList = J.GetAroundEnemyHeroList(nCastRange)
	local nInBonusEnemyList = J.GetAroundEnemyHeroList(nCastRange + 200)
    local botTarget = J.GetProperTarget(bot)

	for _, enemyHero in pairs(nInRangeEnemyList)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillMagicKillTarget(bot, enemyHero, nDamage , nDuration)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_axe_battle_hunger_self')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local npcWeakestEnemy = nil
		local npcWeakestEnemyHealth = 100000

		for _, enemyHero in pairs(nInBonusEnemyList)
		do
			if  J.IsValid(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyHealth = enemyHero:GetHealth()
				if npcEnemyHealth < npcWeakestEnemyHealth
				then
					npcWeakestEnemyHealth = npcEnemyHealth
					npcWeakestEnemy = enemyHero
				end
			end
		end

		if npcWeakestEnemy ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, npcWeakestEnemy
		end
	end

	if J.IsRetreating(bot)
	then
		for _, enemyHero in pairs(nInRangeEnemyList)
		do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if  J.IsFarming(bot)
    and nSkillLV >= 2
    and J.IsAllowedToSpam(bot, nManaCost * 0.25)
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange + 150)
		local nTargetCreep = J.GetMostHpUnit(nNeutralCreeps)

		if  J.IsValid(nTargetCreep)
        and not J.IsRoshan(nTargetCreep)
        and not J.IsTormentor(nTargetCreep)
        and not nTargetCreep:HasModifier( 'modifier_axe_battle_hunger_self' )
        and not J.CanKillTarget(nTargetCreep, bot:GetAttackDamage() * 2.88, DAMAGE_TYPE_PHYSICAL)
        and (nTargetCreep:GetMagicResist() < 0.3 )
		then
			return BOT_ACTION_DESIRE_HIGH, nTargetCreep
	    end
	end

    if J.IsLaning(bot) and nManaCost > 0.5
	then
		for _, enemyHero in pairs(nInRangeEnemyList)
		do
			if  J.IsValid(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and enemyHero:GetAttackTarget() == nil
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_axe_battle_hunger_self')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_axe_battle_hunger_self')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X