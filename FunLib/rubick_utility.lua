local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local botTarget
local StolenAbility

local Blink

function X.ConsiderStolenSpell(ability)
    bot = GetBot()
    botTarget = J.GetProperTarget(bot)
    StolenAbility = ability
    local abilityName = StolenAbility:GetName()

    if abilityName == 'bane_nightmare'
    then
        Desire, Target = X.ConsiderNightmare()
        if Desire > 0
        then
            bot:Action_UseAbilityOnEntity(StolenAbility, Target)
            return
        end
    end

    if abilityName == 'bane_fiends_grip'
    then
        Desire, Target = ConsiderFiendsGrip()
        if Desire > 0
        then
            bot:Action_UseAbilityOnEntity(StolenAbility, Target)
            return
        end
    end

    if abilityName == 'batrider_flaming_lasso'
    then
        Desire, Target = X.ConsiderBlinkLasso()
        if Desire > 0
        then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbilityOnLocation(Blink, Target:GetLocation())
            bot:ActionQueue_Delay(0.1)
            bot:Action_UseAbilityOnEntity(StolenAbility, Target)
            return
        end

        Desire, Target = X.ConsiderFlamingLasso()
        if Desire > 0
        then
            bot:Action_UseAbilityOnEntity(StolenAbility, Target)
            return
        end
    end

    if abilityName == 'beastmaster_primal_roar'
    then
        Desire, Target = X.ConsiderBlinkRoar()
        if Desire > 0
        then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbilityOnLocation(Blink, Target:GetLocation())
            bot:ActionQueue_Delay(0.1)
            bot:Action_UseAbilityOnEntity(StolenAbility, Target)
            return
        end

        Desire, Target = X.ConsiderPrimalRoar()
        if Desire > 0
        then
            bot:Action_UseAbilityOnEntity(StolenAbility, Target)
            return
        end
    end

    if abilityName == 'centaur_hoof_stomp'
    then
        Desire, Target = X.ConsiderHoofStomp()
        if Desire > 0
        then
            bot:Action_UseAbility(StolenAbility)
            return
        end
    end

    -- more...
end

function X.ConsiderNightmare()
    if not StolenAbility:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, StolenAbility:GetCastRange())

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange + 150, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and enemyHero:IsChanneling()
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_legion_commander_duel')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local target = nil
		local dmg = 0
		local nEnemyCount = 0

        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
			then
				nEnemyCount = nEnemyCount + 1
				if  J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					local npcEnemyPower = enemyHero:GetEstimatedDamageToTarget( true, bot, 6.0, DAMAGE_TYPE_ALL )
					if npcEnemyPower > dmg
					then
						dmg = npcEnemyPower
						target = enemyHero
					end
				end
			end
		end

		if target ~= nil and nEnemyCount >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, target
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
		then
            local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
			for _, enemyHero in pairs(nInRangeEnemy)
			do
				if  J.IsValid(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and enemyHero:GetPlayerID() ~= botTarget:GetPlayerID()
                and not enemyHero:IsDisarmed()
                and not J.IsDisabled(enemyHero)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if  J.IsInRange(bot, botTarget, nCastRange)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.CanCastOnTargetAdvanced(botTarget)
            and J.IsChasingTarget(bot, botTarget)
            and not J.IsDisabled(botTarget)
            and not J.IsSuspiciousIllusion(botTarget)
            and not botTarget:HasModifier('modifier_legion_commander_duel')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

				if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
                and #nInRangeAlly >= #nInRangeEnemy
                and not (#nInRangeAlly >= #nInRangeEnemy + 2)
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.7
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and (#nTargetInRangeAlly > #nInRangeAlly
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderFiendsGrip()
    if not StolenAbility:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, StolenAbility:GetCastRange())
	local nDamage = StolenAbility:GetSpecialValueInt('fiend_grip_damage') * 6

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange + 150, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local target = nil
		local dmg = 0

        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange + 150, true, BOT_MODE_NONE)
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local currDmg = enemyHero:GetEstimatedDamageToTarget(true, bot, 6.0, DAMAGE_TYPE_ALL)
				if currDmg > dmg
				then
					dmg = currDmg
					target = enemyHero
				end
			end
		end

		if target ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, target
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsAttackImmune()
        and not botTarget:IsInvulnerable()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderFlamingLasso()
    if not StolenAbility:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = J.GetProperCastRange(false, bot, StolenAbility:GetCastRange())

    if  J.IsGoingOnSomeone(bot)
    and not X.CanDoBlinkLasso()
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidTarget(enemyHero)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsTaunted(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and #nInRangeAlly >= #nTargetInRangeAlly
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlinkLasso()
    if X.CanDoBlinkLasso()
    then
        local nDuration = StolenAbility:GetSpecialValueInt('duration')

        if J.IsGoingOnSomeone(bot)
        then
            local dmg = 0
            local target = nil
            local nInRangeEnemy = bot:GetNearbyHeroes(1199, true, BOT_MODE_NONE)

            for _, enemyHero in pairs(nInRangeEnemy)
            do
                if  J.IsValidTarget(enemyHero)
                and J.CanCastOnMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsTaunted(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local currDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)

                    if dmg < currDmg
                    then
                        dmg = currDmg
                        target = enemyHero
                    end
                end
            end

            if target ~= nil
            then
                local nInRangeAlly = target:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = target:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and #nInRangeAlly >= #nTargetInRangeAlly
                then
                    bot.shouldBlink = true
                    return BOT_ACTION_DESIRE_HIGH, target
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE, nil
end

function X.CanDoBlinkLasso()
    if  StolenAbility:IsFullyCastable()
    and X.HasBlink()
    then
        local nManaCost = StolenAbility:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

function X.ConsiderPrimalRoar()
    if not StolenAbility:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, StolenAbility:GetCastRange())
    local nDuration = StolenAbility:GetSpecialValueInt('duration')
    local nDamage = StolenAbility:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        then
            if J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and J.IsChasingTarget(bot, enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if  J.IsGoingOnSomeone(bot)
    and not X.CanDoBlinkRoar()
	then
        local dmg = 0
        local target = nil
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange + 300)

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidTarget(enemyHero)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.GetHP(enemyHero) > 0.5
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_batrider_flaming_lasso')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local currDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)

                if dmg < currDmg
                then
                    dmg = currDmg
                    target = enemyHero
                end
            end
        end

        if target ~= nil
        then
            local nInRangeAlly = target:GetNearbyHeroes(1199, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = target:GetNearbyHeroes(1199, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and #nInRangeAlly >= #nTargetInRangeAlly
            then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlinkRoar()
    if X.CanDoBlinkRoar()
    then
        local nDuration = StolenAbility:GetSpecialValueInt('duration')

        if J.IsGoingOnSomeone(bot)
        then
            local dmg = 0
            local target = nil
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1199)

            for _, enemyHero in pairs(nInRangeEnemy)
            do
                if  J.IsValidTarget(enemyHero)
                and J.CanCastOnMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and J.GetHP(enemyHero) > 0.5
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_batrider_flaming_lasso')
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local currDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)

                    if dmg < currDmg
                    then
                        dmg = currDmg
                        target = enemyHero
                    end
                end
            end

            if target ~= nil
            then
                local nInRangeAlly = target:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = target:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and #nInRangeAlly >= #nTargetInRangeAlly
                then
                    return BOT_ACTION_DESIRE_HIGH, target
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE, nil
end

function X.CanDoBlinkRoar()
    if  StolenAbility:IsFullyCastable()
    and X.HasBlink()
    then
        local nManaCost = StolenAbility:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

function X.ConsiderHoofStomp()
    if not StolenAbility:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE end

	local nRadius = StolenAbility:GetSpecialValueInt('radius')
	local nDamage = StolenAbility:GetSpecialValueInt('stomp_damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 100)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or (bot:WasRecentlyDamagedByAnyHero(1.5)))
            then
		        return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        and not J.IsDisabled(botTarget)
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







































function X.HasBlink()
    local blink = nil

    for i = 0, 5
    do
		local item = bot:GetItemInSlot(i)

		if  item ~= nil
        and (item:GetName() == "item_blink" or item:GetName() == "item_overwhelming_blink" or item:GetName() == "item_arcane_blink" or item:GetName() == "item_swift_blink")
        then
			blink = item
			break
		end
	end

    if  blink ~= nil
    and blink:IsFullyCastable()
	then
        Blink = blink
        return true
	end

    return false
end

return X