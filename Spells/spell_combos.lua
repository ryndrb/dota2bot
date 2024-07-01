local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local X = {}

local bot, sAbilityList

function X.SpellCombos()
    bot = GetBot()
    sAbilityList = J.Skill.GetAbilityList(bot)

    if bot:IsAlive() and string.find(bot:GetUnitName(), 'crystal_maiden') and bot:IsChanneling() and not bot:IsInvisible()
    then
        -- none
    else
        if J.CanNotUseAbility(bot) then return end
    end

    if bot.Blink == nil then bot.Blink = nil end
    if bot.BKB == nil then bot.BKB = nil end
    if bot.shouldBlink == nil then bot.shouldBlink = false end

    if X.Combos[bot:GetUnitName()] ~= nil
    then
        X.Combos[bot:GetUnitName()]()
    end

    return BOT_ACTION_DESIRE_NONE
end

X.Combos = {}

X.Combos['npc_dota_hero_antimage'] = function ()
    local Blink = GetBot():GetAbilityByName(sAbilityList[1])
    local ManaVoid = GetBot():GetAbilityByName(sAbilityList[6])

    if not Blink:IsFullyCastable() or not ManaVoid:IsFullyCastable()
	then
		return
	end

	if Blink:GetManaCost() + ManaVoid:GetManaCost() > bot:GetMana()
	then
		return
	end

    -- Blink Void
	local nCastRange = Blink:GetSpecialValueInt('AbilityCastRange')
	local nDamagaPerHealth = ManaVoid:GetSpecialValueFloat('mana_void_damage_per_mana')
	local nCastTarget = nil

	local nMaxRange = ManaVoid:GetCastRange() + nCastRange

	local nEnemysHerosCanSeen = GetUnitList(UNIT_LIST_ENEMY_HEROES)
	for _, enemyHero in pairs(nEnemysHerosCanSeen)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nMaxRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_arc_warden_tempest_double')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local nDamage = nDamagaPerHealth * (enemyHero:GetMaxMana() - enemyHero:GetMana())
            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            then
                nCastTarget = enemyHero
            end
		end
	end

	if nCastTarget ~= nil
	then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Blink, nCastTarget:GetLocation())
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnEntity(ManaVoid, nCastTarget)
        return
	end
end

X.Combos['npc_dota_hero_batrider'] = function ()
    local Firefly = bot:GetAbilityByName(sAbilityList[3])
    local FlamingLasso = bot:GetAbilityByName(sAbilityList[6])

    -- Blink Lasso
    if FlamingLasso:IsFullyCastable() and X.CanBlink() and bot:GetMana() >= FlamingLasso:GetManaCost()
    then
        local nDuration = FlamingLasso:GetSpecialValueInt('duration')

        if J.IsGoingOnSomeone(bot)
        then
            local strongestTarget = J.GetStrongestUnit(1199, bot, true, false, nDuration)

            if strongestTarget == nil
            then
                strongestTarget = J.GetStrongestUnit(1199, bot, true, true, nDuration)
            end

            if  J.IsValidTarget(strongestTarget)
            and J.CanCastOnMagicImmune(strongestTarget)
            and J.CanCastOnTargetAdvanced(strongestTarget)
            and J.IsInRange(bot, strongestTarget, 1199)
            and not J.IsDisabled(strongestTarget)
            and not J.IsHaveAegis(strongestTarget)
            and not strongestTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not strongestTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not strongestTarget:HasModifier('modifier_legion_commander_duel')
            and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                J.SetQueuePtToINT(bot, false)

                if Firefly ~= nil
                and Firefly:IsFullyCastable()
                and J.GetManaAfter(Firefly:GetManaCost()) * bot:GetMana() > FlamingLasso:GetManaCost()
                then
                    bot:ActionQueue_UseAbility(Firefly)
                end

                if X.CanBKB()
                then
                    bot:ActionQueue_UseAbility(bot.BKB)
                    bot:ActionQueue_Delay(0.1)
                end

                bot:ActionQueue_UseAbilityOnLocation(bot.Blink, strongestTarget:GetLocation())
                bot:ActionQueue_Delay(0.1)
                bot:ActionQueue_UseAbilityOnEntity(FlamingLasso, strongestTarget)
                return
            end
        end
    end

    bot.shouldBlink = false
end

X.Combos['npc_dota_hero_beastmaster'] = function ()
    local PrimalRoar = bot:GetAbilityByName(sAbilityList[6])

    -- Blink Roar
    if PrimalRoar:IsFullyCastable() and X.CanBlink() and bot:GetMana() >= PrimalRoar:GetManaCost()
    then
        local nDuration = PrimalRoar:GetSpecialValueInt('duration')

        if J.IsInTeamFight(bot, 1600)
        then
            local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
            local strongestTarget = J.GetStrongestUnit(1199, bot, true, false, nDuration)

            if strongestTarget == nil
            then
                strongestTarget = J.GetStrongestUnit(1199, bot, true, true, nDuration)
            end

            if  J.IsValidTarget(strongestTarget)
            and J.CanCastOnNonMagicImmune(strongestTarget)
            and J.CanCastOnTargetAdvanced(strongestTarget)
            and J.IsInRange(bot, strongestTarget, 1199)
            and J.GetHP(strongestTarget) > 0.5
            and not J.IsDisabled(strongestTarget)
            and not J.IsHaveAegis(strongestTarget)
            and not strongestTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not strongestTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not strongestTarget:HasModifier('modifier_legion_commander_duel')
            and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if nInRangeAlly ~= nil and J.IsValidHero(nInRangeAlly[1]) and nInRangeAlly[1] ~= bot and not nInRangeAlly[1]:IsIllusion()
                then
                    bot.shouldBlink = true

                    J.SetQueuePtToINT(bot, false)

                    if X.CanBKB()
                    then
                        bot:ActionQueue_UseAbility(bot.BKB)
                        bot:ActionQueue_Delay(0.1)
                    end

                    bot:ActionQueue_UseAbilityOnLocation(bot.Blink, strongestTarget:GetLocation())
                    bot:ActionQueue_Delay(0.1)
                    bot:ActionQueue_UseAbilityOnEntity(PrimalRoar, strongestTarget)
                    return
                end
            end
        end
    end

    bot.shouldBlink = false
end

local amuletTime = 0
X.Combos['npc_dota_hero_crystal_maiden'] = function ()
    if bot:IsAlive()
		and bot:IsChanneling()
		and not bot:IsInvisible()
	then
		local nEnemyTowers = bot:GetNearbyTowers( 880, true )

		if nEnemyTowers[1] ~= nil then return end

		local amulet = J.IsItemAvailable( 'item_shadow_amulet' )
		if amulet~=nil and amulet:IsFullyCastable() and amuletTime < DotaTime()- 10
		then
			amuletTime = DotaTime()
			bot:Action_UseAbilityOnEntity( amulet, bot )
			return
		end

		if not bot:HasModifier( 'modifier_teleporting' )
		then
			local glimer = J.IsItemAvailable( 'item_glimmer_cape' )
			if glimer ~= nil and glimer:IsFullyCastable()
			then
				bot:Action_UseAbilityOnEntity( glimer, bot )
				return
			end

			local invissword = J.IsItemAvailable( 'item_invis_sword' )
			if invissword ~= nil and invissword:IsFullyCastable()
			then
				bot:Action_UseAbility( invissword )
				return
			end

			local silveredge = J.IsItemAvailable( 'item_silver_edge' )
			if silveredge ~= nil and silveredge:IsFullyCastable()
			then
				bot:Action_UseAbility( silveredge )
				return
			end
		end
	end
end

X.Combos['npc_dota_hero_dark_seer'] = function ()
    local Vacuum = bot:GetAbilityByName(sAbilityList[1])
    local WallOfReplica = bot:GetAbilityByName(sAbilityList[6])

    -- Blink Vaccum Wall
    if Vacuum:IsFullyCastable() and WallOfReplica:IsFullyCastable() and X.CanBlink() and bot:GetMana() >= Vacuum:GetManaCost() + WallOfReplica:GetManaCost()
    then
        local nWallOfReplicaCastPoint = WallOfReplica:GetCastPoint() + 0.73
        local nVacuumCastRange = J.GetProperCastRange(false, bot, Vacuum:GetCastRange())
        local nVacuumRadius = Vacuum:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1600)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nVacuumCastRange, nVacuumRadius, nWallOfReplicaCastPoint, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nVacuumRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                local vLoc = J.GetCenterOfUnits(nInRangeEnemy)

                J.SetQueuePtToINT(bot, false)
                bot:ActionQueue_UseAbilityOnLocation(bot.Blink, vLoc)
                bot:ActionQueue_Delay(0.1)
                bot:ActionQueue_UseAbilityOnLocation(Vacuum, vLoc)
                bot:ActionQueue_Delay(0.8)
                bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, vLoc)
                return
            end
        end
    end
end

X.Combos['npc_dota_hero_disruptor'] = function ()
    local KineticField = bot:GetAbilityByName(sAbilityList[3])
    local StaticStorm = bot:GetAbilityByName(sAbilityList[6])

    -- Kinetic Storm
    if KineticField:IsFullyCastable() and StaticStorm:IsFullyCastable() and bot:GetMana() >= KineticField:GetManaCost() + StaticStorm:GetManaCost()
    then
	    local nCastRange = J.GetProperCastRange(false, bot, KineticField:GetCastRange())
        local nRadius = KineticField:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius - 75)

            if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
            then
                local vLoc = J.GetCenterOfUnits(nInRangeEnemy)

                J.SetQueuePtToINT(bot, false)
                bot:ActionQueue_UseAbilityOnLocation(StaticStorm, vLoc)
                bot:ActionQueue_Delay(0.05)
                bot:ActionQueue_UseAbilityOnLocation(KineticField, vLoc)
                return
            end
        end
    end
end

function X.CanBlink()
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

    if blink ~= nil and blink:IsFullyCastable()
	then
        bot.Blink = blink
        return true
	end

    return false
end

function X.CanBKB()
    local bkb = nil

    for i = 0, 5
    do
		local item = bot:GetItemInSlot(i)

		if item ~= nil and item:GetName() == "item_black_king_bar"
        then
			bkb = item
			break
		end
	end

    if bkb ~= nil and bkb:IsFullyCastable()
	then
        bot.BKB = bkb
        return true
	end

    return false
end

return X