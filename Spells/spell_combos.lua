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

X.Combos['npc_dota_hero_earthshaker'] = function ()
    local EnchantTotem = bot:GetAbilityByName(sAbilityList[2])
    local EchoSlam = bot:GetAbilityByName(sAbilityList[6])

    local function CanDoBlinkSlam()
        if X.CanBlink() and EchoSlam ~= nil and EchoSlam:IsFullyCastable()
        then
            local nManaCost = EchoSlam:GetManaCost()

            if bot:GetMana() >= nManaCost
            then
                bot.shouldBlink = true
                return true
            end
        end

        bot.shouldBlink = false
        return false
    end

    local function ConsiderBlinkSlam()
        if CanDoBlinkSlam()
        then
            local nCastRange = 1199
            local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

            if J.IsGoingOnSomeone(bot)
            then
                local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
                local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)

                if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end
            end
        end

        return BOT_ACTION_DESIRE_NONE, 0
    end

    local function CanDoTotemSlam()
        if  bot:HasScepter()
        and EnchantTotem:IsFullyCastable()
        and EchoSlam:IsFullyCastable()
        then
            local nManaCost = EnchantTotem:GetManaCost() + EchoSlam:GetManaCost()

            if  bot:GetMana() >= nManaCost
            then
                return true
            end
        end

        return false
    end

    -- Blink Slam
    local function ConsiderTotemSlam()
        if CanDoTotemSlam()
        then
            local nETCastRange = EnchantTotem:GetSpecialValueInt('distance_scepter')
            local nETLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')
            local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

            if J.IsInTeamFight(bot, 1200)
            then
                local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nETCastRange, nRadius, nETLeapDuration, 0)
                local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)

                if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end
            end
        end

        return BOT_ACTION_DESIRE_NONE, 0
    end

    BlinkSlamDesire, BlinkSlamLocation = ConsiderBlinkSlam()
    if BlinkSlamDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkSlamLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end

    -- Totem Slam
    TotemSlamDesire, TotemSlamLocation = ConsiderTotemSlam()
    if TotemSlamDesire > 0
    then
        local nLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')

        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(EnchantTotem, TotemSlamLocation)
        bot:ActionQueue_Delay(nLeapDuration + 0.5 + 0.48)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end
end

X.Combos['npc_dota_hero_ember_spirit'] = function ()
    local SearingChains = bot:GetAbilityByName(sAbilityList[1])
    local SleightOfFist = bot:GetAbilityByName(sAbilityList[2])

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local function CanDoSleightChains()
        if SleightOfFist:IsFullyCastable()
        and SearingChains:IsFullyCastable()
        then
            local manaCost = SleightOfFist:GetManaCost() + SearingChains:GetManaCost()

            if  bot:GetMana() >= manaCost
            then
                return true
            end
        end

        return false
    end

    local function ConsiderSleightChains()
        if CanDoSleightChains()
        then
            local nCastRange = J.GetProperCastRange(false, bot, SleightOfFist:GetCastRange())
            local botTarget = J.GetProperTarget(bot)

            if J.IsGoingOnSomeone(bot)
            then
                if  J.IsValidTarget(botTarget)
                and J.CanCastOnMagicImmune(botTarget)
                and not botTarget:IsAttackImmune()
                and J.IsInRange(bot, botTarget, nCastRange)
                and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end

            if J.IsRetreating(bot)
            and not J.IsRealInvisible(bot)
            and bot:GetActiveModeDesire() > 0.7
            and bot:WasRecentlyDamagedByAnyHero(4)
            then
                if J.IsValidHero(nEnemyHeroes[1])
                and J.CanCastOnMagicImmune(nEnemyHeroes[1])
                and J.IsChasingTarget(nEnemyHeroes[1], bot)
                and not J.IsDisabled(nEnemyHeroes[1])
                and not nEnemyHeroes[1]:IsDisarmed()
                then
                    return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
                end
            end
        end

        return BOT_ACTION_DESIRE_NONE, 0
    end

    -- Sleight Chains
    SleightChainsDesire, SCLocation = ConsiderSleightChains()
	if SleightChainsDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SleightOfFist, SCLocation)
        bot:ActionQueue_Delay(0.7)
		bot:ActionQueue_UseAbility(SearingChains)
		return
	end
end

X.Combos['npc_dota_hero_enigma'] = function ()
    local MidnightPulse = bot:GetAbilityByName(sAbilityList[3])
    local BlackHole = bot:GetAbilityByName(sAbilityList[6])

    local function CanDoBlinkPulseHole()
        if  BlackHole:IsFullyCastable()
        and MidnightPulse:IsFullyCastable()
        and X.CanBlink()
        then
            local nManaCost = BlackHole:GetManaCost() + MidnightPulse:GetManaCost()
    
            if bot:GetMana() >= nManaCost
            then
                return true
            end
        end
    
        return false
    end

    local function ConsiderBlinkPulseHole()
        if CanDoBlinkPulseHole()
        then
            local nRadius = BlackHole:GetSpecialValueInt('radius')
    
            if J.IsInTeamFight(bot, 1200)
            then
                local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1199, nRadius, 0, 0)
                local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
    
                if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        return BOT_ACTION_DESIRE_NONE, 0
    end

    local function CanDoBlinkHole()
        if  BlackHole:IsFullyCastable()
        and X.CanBlink()
        then
            local nManaCost = BlackHole:GetManaCost()

            if bot:GetMana() >= nManaCost
            then
                return true
            end
        end

        return false
    end

    local function ConsiderBlinkHole()
        if CanDoBlinkHole()
        then
            local nRadius = BlackHole:GetSpecialValueInt('radius')

            if J.IsInTeamFight(bot, 1200)
            then
                local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1199, nRadius, 0, 0)
                local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

                if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        return BOT_ACTION_DESIRE_NONE, 0
    end

    -- Blink Pulse Hole
    BlinkPulseHoleDesire, BlinkPulseHoleLocation = ConsiderBlinkPulseHole()
    if BlinkPulseHoleDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if  X.CanBKB()
        and not bot:IsMagicImmune()
        then
            bot:ActionQueue_UseAbility(BlackKingBar)
            bot:ActionQueue_Delay(0.1)
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkPulseHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, BlinkPulseHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlinkPulseHoleLocation)
        return
    end

    -- Blink Hole
    BlinkHoleDesire, BlinkHoleLocation = ConsiderBlinkHole()
    if BlinkHoleDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if  X.CanBKB()
        and not bot:IsMagicImmune()
        then
            bot:ActionQueue_UseAbility(BlackKingBar)
            bot:ActionQueue_Delay(0.1)
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlinkHoleLocation)
        return
    end
end

X.Combos['npc_dota_hero_furion'] = function ()
    local Sprout = bot:GetAbilityByName(sAbilityList[1])
    local NaturesCall = bot:GetAbilityByName(sAbilityList[3])

    local function CanDoSproutCall()
        if  Sprout:IsFullyCastable()
        and NaturesCall:IsFullyCastable()
        then
            local nManaCost = Sprout:GetManaCost() + NaturesCall:GetManaCost()

            if bot:GetMana() >= nManaCost
            then
                return true
            end
        end

        return false
    end

    local function ConsiderSproutCall()
        if CanDoSproutCall()
        then
            local nCastRange = J.GetProperCastRange(false, bot, Sprout:GetCastRange())
            local botTarget = J.GetProperTarget(bot)

            local nInRangeTrees = bot:GetNearbyTrees(nCastRange)
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

            if nInRangeTrees ~= nil and #nInRangeTrees >= 1
            then
                if J.IsPushing(bot) or J.IsDefending(bot)
                then
                    if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
                    and J.CanBeAttacked(nEnemyLaneCreeps[1])
                    then
                        return BOT_ACTION_DESIRE_HIGH, bot, bot:GetLocation()
                    end
                end

                if  J.IsFarming(bot)
                and J.GetMP(bot) > 0.5
                then
                    if J.IsAttacking(bot)
                    then
                        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
                        if  nNeutralCreeps ~= nil
                        and J.IsValid(nNeutralCreeps[1])
                        and ((#nNeutralCreeps >= 3)
                            or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
                        then
                            return BOT_ACTION_DESIRE_HIGH, bot, bot:GetLocation()
                        end

                        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
                        and J.CanBeAttacked(nEnemyLaneCreeps[1])
                        then
                            return BOT_ACTION_DESIRE_HIGH, bot, bot:GetLocation()
                        end
                    end
                end

                if J.IsLaning(bot)
                and J.GetMP(bot) > 0.5
                then
                    if J.IsAttacking(bot)
                    then
                        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 2
                        and J.CanBeAttacked(nEnemyLaneCreeps[1])
                        then
                            return BOT_ACTION_DESIRE_HIGH, bot, bot:GetLocation()
                        end
                    end
                end

                if J.IsDoingRoshan(bot)
                then
                    if  J.IsRoshan(botTarget)
                    and not botTarget:IsAttackImmune()
                    and J.IsInRange(bot, botTarget, bot:GetAttackRange())
                    and J.IsAttacking(bot)
                    then
                        return BOT_ACTION_DESIRE_HIGH, bot, bot:GetLocation()
                    end
                end

                if J.IsDoingTormentor(bot)
                then
                    if  J.IsTormentor(botTarget)
                    and J.IsInRange(bot, botTarget, bot:GetAttackRange())
                    and J.IsAttacking(bot)
                    then
                        return BOT_ACTION_DESIRE_HIGH, bot, bot:GetLocation()
                    end
                end
            end
        end

        return BOT_ACTION_DESIRE_NONE, nil, 0
    end

    SproutCallDesire, SproutCallTarget, SproutCallLocation = ConsiderSproutCall()
    if SproutCallDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Sprout, SproutCallTarget)
        bot:ActionQueue_Delay(0.35 + 0.44)
        bot:ActionQueue_UseAbilityOnLocation(NaturesCall, SproutCallLocation)
        return
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