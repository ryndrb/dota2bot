local X = {}
local bot
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

---------------------
-- Visage's Familiars
---------------------
local StoneForm
local IsAttackingSomethingNotHero = false
function X.FamiliarThink(hero, hMinionUnit)
	if J.CanNotUseAbility(hMinionUnit) then return end

	bot = hero
	StoneForm = hMinionUnit:GetAbilityByName('visage_summon_familiars_stone_form')

	Desire = ConsiderStoneForm(hMinionUnit, StoneForm)
	if Desire > 0
	then
		hMinionUnit:Action_UseAbility(StoneForm)
		return
	end

	RetreatDesire, RetreatLocation = ConsiderFamiliarRetreat(hMinionUnit)
	if RetreatDesire > 0
	then
		hMinionUnit:Action_MoveToLocation(RetreatLocation)
		return
	end

	AttackDesire, AttackTarget = ConsiderFamiliarAttack(hMinionUnit)
	if AttackDesire > 0
	then
		hMinionUnit:Action_AttackUnit(AttackTarget, false)
		return
	end

	MoveDesire, MoveLocation = ConsiderFamiliarMove(hMinionUnit)
	if MoveDesire > 0
	then
		hMinionUnit:Action_MoveToLocation(MoveLocation)
		return
	end
end

function ConsiderStoneForm(hMinionUnit, ability)
	if not ability:IsFullyCastable()
	or hMinionUnit:HasModifier('modifier_visage_summon_familiars_stone_form_buff')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = ability:GetSpecialValueInt('stun_radius')

	if J.IsRetreating(bot)
	then
		local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			then
				local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
				local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

				if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
				and ((#nTargetInRangeAlly > #nInRangeAlly)
					or bot:WasRecentlyDamagedByAnyHero(2.5))
				then
					local nFamiliarInRangeEnemy = hMinionUnit:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
					if nFamiliarInRangeEnemy ~= nil and #nFamiliarInRangeEnemy >= 1
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if J.GetHP(hMinionUnit) < 0.49
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	local nEnemyHeroes = hMinionUnit:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and enemyHero:IsChanneling()
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local attackTarget = hMinionUnit:GetAttackTarget()
	if  J.IsValidHero(attackTarget)
	and not J.IsSuspiciousIllusion(attackTarget)
	and not J.IsDisabled(attackTarget)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function ConsiderFamiliarRetreat(hMinionUnit)
	if hMinionUnit:HasModifier('modifier_visage_summon_familiars_stone_form_buff')
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if not bot:IsAlive()
	then
		return BOT_ACTION_DESIRE_HIGH, J.GetEscapeLoc()
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderFamiliarAttack(hMinionUnit)
	if hMinionUnit:HasModifier('modifier_visage_summon_familiars_stone_form_buff')
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local botTarget = J.GetProperTarget(bot)

	if J.IsValidHero(botTarget)
	or J.IsValidBuilding(botTarget)
	then
		IsAttackingSomethingNotHero = false
		return BOT_ACTION_DESIRE_HIGH, botTarget
	end

	local nUnits = bot:GetNearbyCreeps(700, true)
	for _, creep in pairs(nUnits)
	do
		if  J.IsValid(creep)
		and J.CanBeAttacked(creep)
		and GetUnitToUnitDistance(bot, hMinionUnit) < 1600
		then
			IsAttackingSomethingNotHero = true
			return BOT_ACTION_DESIRE_HIGH, creep
		end
	end

	nUnits = bot:GetNearbyTowers(700, true)
	for _, tower in pairs(nUnits)
	do
		if  J.IsValidBuilding(tower)
		and J.CanBeAttacked(tower)
		and tower:GetAttackTarget() ~= hMinionUnit
		and not hMinionUnit:WasRecentlyDamagedByTower(1)
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(tower:GetLocation(), 700)

			if  nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			and GetUnitToUnitDistance(bot, hMinionUnit) < 1600
			then
				IsAttackingSomethingNotHero = true
				return BOT_ACTION_DESIRE_HIGH, tower
			end
		end
	end

	IsAttackingSomethingNotHero = false

	return BOT_ACTION_DESIRE_NONE, 0
end

function ConsiderFamiliarMove(hMinionUnit)
	if hMinionUnit:HasModifier('modifier_visage_summon_familiars_stone_form_buff')
	or not bot:IsAlive()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nEnemyHeroes = hMinionUnit:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and enemyHero:IsChanneling()
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			local nInRangeEnemy = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if  GetUnitToUnitDistance(hMinionUnit, bot) > hMinionUnit:GetAttackRange()
	and not IsAttackingSomethingNotHero
	then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation() + RandomVector(hMinionUnit:GetAttackRange())
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X