local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')

local X = {}
local bot

local bBotAlive = false

function X.Think(ownerBot, hMinionUnit)
	if J.CanNotUseAbility(hMinionUnit) then return end

	bot = ownerBot
	bBotAlive = bot:IsAlive()
	local StoneForm = hMinionUnit:GetAbilityByName('visage_summon_familiars_stone_form')
	local botTarget = J.GetProperTarget(bot)

	if hMinionUnit.fNextMovementTime == nil then hMinionUnit.fNextMovementTime = -math.huge end

	-- they can't cast; likely due to alt-cast
	-- hMinionUnit.cast_desire = X.ConsiderStoneForm(hMinionUnit, StoneForm)
	-- if hMinionUnit.cast_desire > 0 then
	-- 	hMinionUnit:Action_UseAbility(StoneForm)
	-- 	return
	-- end

	if hMinionUnit:HasModifier('modifier_visage_summon_familiars_stone_form_buff') then return end

	local nEnemyTowers = hMinionUnit:GetNearbyTowers(1600, true)
	if J.IsValidBuilding(nEnemyTowers[1]) and J.IsInRange(hMinionUnit, nEnemyTowers[1], 800) then
		if nEnemyTowers[1]:GetAttackTarget() == hMinionUnit then
			hMinionUnit:Action_MoveToLocation(J.VectorAway(hMinionUnit:GetLocation(), nEnemyTowers[1]:GetLocation(), 800))
			return
		end
	end

	if bBotAlive and J.IsValid(botTarget) and not bot:IsChanneling() and J.IsInRange(bot, botTarget, 1200) then
		hMinionUnit:Action_AttackUnit(botTarget, true)
		return
	else
		if DotaTime() >= hMinionUnit.fNextMovementTime then
			if not bBotAlive then
				hMinionUnit:Action_MoveToLocation(J.GetTeamFountain() + RandomVector(300))
				hMinionUnit.fNextMovementTime = DotaTime() + RandomFloat(0.2, 0.5)
				return
			else
				-- right, left, back for the familiars

				local heroLocation = bot:GetLocation()
				local tempRadians = bot:GetFacing() * math.pi / 180
				local rightVector = Vector(math.sin(tempRadians), -math.cos(tempRadians), 0)
				local backVector = Vector(-math.sin(tempRadians), -math.cos(tempRadians), 0)

				local offsetLocations = {
					heroLocation - 150 * rightVector,
					heroLocation + 150 * rightVector,
					heroLocation + 150 * backVector,
				}

				local familiars = {}
				local unitList = GetUnitList(UNIT_LIST_ALLIES)
				for _, unit in pairs(unitList) do
					if J.IsValid(unit) and string.find(unit:GetUnitName(), 'npc_dota_visage_familiar') then
						table.insert(familiars, tonumber(string.match(tostring(unit), "0x%x+")))
					end
				end

				table.sort(familiars, function (a, b)
					return tonumber(a) < tonumber(b)
				end)

				for i = 1, #familiars do
					if tonumber(string.match(tostring(hMinionUnit), "0x%x+")) == familiars[i] then
						hMinionUnit:Action_MoveToLocation(offsetLocations[i])
						hMinionUnit.fNextMovementTime = DotaTime() + RandomFloat(0.2, 0.5)
						return
					end
				end
			end
		end
	end
end

function X.ConsiderStoneForm(hMinionUnit, hAbility)
	if not J.CanCastAbility(hAbility)
	or hMinionUnit:HasModifier('modifier_visage_summon_familiars_stone_form_buff')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = hAbility:GetSpecialValueInt('stun_radius')
    local nFamiliarInRangeEnemy = hMinionUnit:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

	if bBotAlive and J.IsRetreating(bot) then
		for _, enemyHero in pairs(nFamiliarInRangeEnemy) do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_eul_cyclone')
			and not enemyHero:HasModifier('modifier_invoker_tornado')
			and not enemyHero:HasModifier('modifier_brewmaster_storm_cyclone')
			and not enemyHero:HasModifier('modifier_wind_waker')
			and not U.CantMove(enemyHero)
			then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
				if J.IsChasingTarget(enemyHero, bot) or (#nInRangeEnemy > #nInRangeAlly and enemyHero:GetAttackTarget() == bot) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	for _, enemyHero in pairs(nFamiliarInRangeEnemy) do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and enemyHero:IsChanneling()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nInRangeAlly = J.GetAlliesNearLoc(hMinionUnit:GetLocation(), 1200)
	local nInRangeEnemy = J.GetEnemiesNearLoc(hMinionUnit:GetLocation(), 1200)

	local hAttackTarget = hMinionUnit:GetAttackTarget()
	if J.IsValidHero(hAttackTarget)
	and not J.IsSuspiciousIllusion(hAttackTarget)
	and not J.IsDisabled(hAttackTarget)
	then
		if #nInRangeAlly >= #nInRangeEnemy then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.GetHP(hMinionUnit) < 0.35 then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

return X