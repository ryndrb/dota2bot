local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_riki'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_wraith_band",
				"item_power_treads",
				"item_bfury",--
				"item_diffusal_blade",
				"item_desolator",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_disperser",--
				"item_abyssal_blade",--
				"item_ultimate_scepter_2",
				"item_butterfly",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_wraith_band", "item_greater_crit",
				"item_power_treads", "item_butterfly"
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_wraith_band",
				"item_power_treads",
				"item_bfury",--
				"item_diffusal_blade",
				"item_desolator",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_disperser",--
				"item_nullifier",--
				"item_ultimate_scepter_2",
				"item_abyssal_blade",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_wraith_band", "item_greater_crit",
				"item_power_treads", "item_abyssal_blade"
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() then X['sBuyList'], X['sSellList'] = { 'PvN_BH' }, {{"item_power_treads", 'item_quelling_blade'}, 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local SmokeScreen = bot:GetAbilityByName('riki_smoke_screen')
local BlinkStrike = bot:GetAbilityByName('riki_blink_strike')
local TricksOfTheTrade = bot:GetAbilityByName('riki_tricks_of_the_trade')
local CloackAndDagger = bot:GetAbilityByName('riki_backstab')

local SmokeScreenDesire, SmokeScreenLocation
local BlinkStrikeDesire, BlinkStrikeTarget
local TricksOfTheTradeDesire, TricksOfTheTradeLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot)
	or (TricksOfTheTrade and TricksOfTheTrade:IsTrained() and TricksOfTheTrade:IsChanneling())
	then
		return
	end

	SmokeScreen = bot:GetAbilityByName('riki_smoke_screen')
	BlinkStrike = bot:GetAbilityByName('riki_blink_strike')
	TricksOfTheTrade = bot:GetAbilityByName('riki_tricks_of_the_trade')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	SmokeScreenDesire, SmokeScreenLocation = X.ConsiderSmokeScreen()
	if SmokeScreenDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SmokeScreen, SmokeScreenLocation)
		return
	end

	BlinkStrikeDesire, BlinkStrikeTarget = X.ConsiderBlinkStrike()
	if BlinkStrikeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(BlinkStrike, BlinkStrikeTarget)
		return
	end

	TricksOfTheTradeDesire, TricksOfTheTradeLocation = X.ConsiderTricksOfTheTrade()
	if TricksOfTheTradeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(TricksOfTheTrade, TricksOfTheTradeLocation)
		return
	end
end

function X.ConsiderSmokeScreen()
	if not J.CanCastAbility(SmokeScreen) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, SmokeScreen:GetCastRange())
	local nRadius = SmokeScreen:GetSpecialValueInt('radius')
	local nManaCost = SmokeScreen:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BlinkStrike, TricksOfTheTrade})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SmokeScreen, BlinkStrike, TricksOfTheTrade})

	if fManaAfter > fManaThreshold1 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and enemyHero:IsChanneling()
			and not enemyHero:HasModifier('modifier_teleporting')
			then
				if J.IsInRange(bot, enemyHero, nCastRange) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				else
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), nCastRange)
				end
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not J.IsDisabled(enemyHero)
				and not enemyHero:IsSilenced()
				then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsSilenced()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and not enemyHero:IsSilenced()
            then
				local bIsChasingMe = J.IsChasingTarget(enemyHero, bot)
                if bIsChasingMe
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.5)
                then
                    if J.IsInRange(bot, enemyHero, nRadius) then
						return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
					else
						if bIsChasingMe then
							return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
						else
							return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
						end
					end
                end
            end
        end
	end

	if fManaAfter > fManaThreshold2 then
		for _, id in pairs( GetTeamPlayers(GetOpposingTeam())) do
			if IsHeroAlive(id) then
				local info = GetHeroLastSeenInfo(id)
				if info ~= nil then
					local dInfo = info[1]
					if dInfo ~= nil and GetUnitToLocationDistance(bot, dInfo.location) <= nRadius and dInfo.time_since_seen <= 5.0 then
						if J.IsDoingRoshan(bot) then
							if J.IsRoshan(botTarget)
							and J.CanBeAttacked(botTarget)
							and J.IsInRange(bot, botTarget, nCastRange)
							and bAttacking
							then
								return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
							end
						end

						if J.IsDoingTormentor(bot) then
							if J.IsTormentor(botTarget)
							and J.IsInRange(bot, botTarget, nCastRange)
							and bAttacking
							then
								return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
							end
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end


function X.ConsiderBlinkStrike()
	if not J.CanCastAbility(BlinkStrike)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, BlinkStrike:GetCastRange())
	local nManaCost = BlinkStrike:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SmokeScreen, TricksOfTheTrade})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SmokeScreen, BlinkStrike, TricksOfTheTrade})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 600
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		then
			if (not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 200))
			or (not J.IsInRange(bot, botTarget, bot:GetAttackRange()) and J.GetHP(botTarget) < 0.25)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		local nAllyCreeps = bot:GetNearbyCreeps(nCastRange, false)
		local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

		local nAllyUnits = J.CombineTwoTable(nAllyHeroes, nAllyCreeps)
		local nAllUnits = J.CombineTwoTable(nAllyUnits, nEnemyCreeps)

		local targetUnit = nil
		local targetUnitDistance = math.huge
		for _, unit in pairs(nAllUnits) do
			if J.IsValid(unit)
			and J.IsInRange(bot, unit, nCastRange)
			and not J.IsInRange(bot, unit, nCastRange / 2)
			and J.CanCastOnTargetAdvanced(unit)
			and J.GetDistanceFromAllyFountain( unit ) < targetUnitDistance
			then
				local unitDistance = GetUnitToLocationDistance(bot, J.GetTeamFountain())
				if unitDistance < targetUnitDistance then
					targetUnit = unit
					targetUnitDistance = unitDistance
				end
			end
		end

		if targetUnit then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.IsInRange(bot, enemyHero, 1200)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not J.IsDisabled(enemyHero)
				and not enemyHero:IsDisarmed()
				then
					if J.IsChasingTarget(enemyHero, bot)
					or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
					or (botHP < 0.5)
					then
						return BOT_ACTION_DESIRE_HIGH, targetUnit
					end
				end
			end
		end
	end

	if (J.IsPushing(bot) and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 and not J.IsEarlyGame())
	or (J.IsDefending(bot) and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 and not J.IsEarlyGame())
	then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and botTarget:IsCreep()
		and not J.IsInRange(bot, botTarget, nCastRange / 2)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end

		local nLane = LANE_MID
		if bot:GetActiveMode() == (J.IsPushing(bot) and BOT_MODE_PUSH_TOWER_TOP) or BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == (J.IsPushing(bot) and BOT_MODE_PUSH_TOWER_BOT) or BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > 3.5 then
			local bestTarget = X.GetBestBlinkTargetTowardsLocation(nCastRange, vLaneFrontLocation, nCastRange / 2, 45, false)
			if bestTarget then
				if bot:IsFacingLocation(bestTarget:GetLocation(), 45) then
					return BOT_ACTION_DESIRE_HIGH, bestTarget
				end
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and botTarget:IsCreep()
		and not J.IsInRange(bot, botTarget, nCastRange / 2)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTricksOfTheTrade()
	if not J.CanCastAbility(TricksOfTheTrade)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, TricksOfTheTrade:GetCastRange())
	local nRadius = TricksOfTheTrade:GetSpecialValueInt('radius')
	local fDamageReduction = TricksOfTheTrade:GetSpecialValueInt('damage_pct') / 100
	local nManaCost = TricksOfTheTrade:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BlinkStrike, SmokeScreen})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SmokeScreen, BlinkStrike, TricksOfTheTrade})

	if (J.IsNotAttackProjectileIncoming(bot, 1000))
	or (J.GetAttackProjectileDamageByRange(bot, 1600) > bot:GetHealth())
	then
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nCastRange)
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
				then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.5)
				then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nCastRange)
				end
			end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
	local bHasFarmingItem = J.HasItem(bot, 'item_maelstrom') or J.HasItem(bot, 'item_mjollnir') or J.HasItem(bot, 'item_bfury') or J.HasItem(bot, 'item_radiance')

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4 and not bHasFarmingItem)
				or (nLocationAoE.count >= 5)
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4 and not bHasFarmingItem)
				or (nLocationAoE.count >= 4 and string.find(creep:GetUnitName(), 'upgraded'))
				or (nLocationAoE.count >= 5)
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3 and not bHasFarmingItem)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep() and fManaAfter > 0.5 and not J.CanKillTarget(creep, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL))
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	local nEnemyTowers = bot:GetNearbyTowers(1000, true)

    if  J.IsLaning(bot) and J.IsInLaningPhase()
    and fManaAfter > fManaThreshold1
    and bAttacking
	and #nEnemyTowers == 0
    and #nEnemyHeroes == 0
	and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end

				nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, bot:GetAttackDamage() * fDamageReduction)
				if (nLocationAoE.count >= 2 and #nEnemyHeroes > 0) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
            end
        end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.GetBestBlinkTargetTowardsLocation(nCastRange, vTargetLocation, nMinDistance, nConeAngle, bIncludeEnemy)
    local bestTarget = nil
    local bestTargetDistance = 0

    local botLocation = bot:GetLocation()
    local targetDir = (vTargetLocation - botLocation):Normalized()

	local unitList = (not bIncludeEnemy and GetUnitList(UNIT_LIST_ALLIES)) or GetUnitList(UNIT_LIST_ALL)
	for _, unit in pairs(unitList) do
		if J.IsValid(unit)
		and unit ~= bot
		and J.IsInRange(bot, unit, nCastRange)
		and not J.IsInRange(bot, unit, nMinDistance)
		and (unit:IsHero() or unit:IsCreep())
		then
			local vUnitLocation = unit:GetLocation()
			local unitDir = (vUnitLocation - botLocation):Normalized()
			local dot = J.DotProduct(targetDir, unitDir)
			local nAngle = J.GetAngleFromDotProduct(dot)
			local nBotUnitDistance = GetUnitToUnitDistance(bot, unit)

			if nAngle <= nConeAngle then
				local nBotTargetDistance = GetUnitToLocationDistance(bot, vTargetLocation)
				local nUnitTargetDistance = GetUnitToLocationDistance(unit, vTargetLocation)
				if nUnitTargetDistance < nBotTargetDistance and nBotUnitDistance > bestTargetDistance then
					bestTarget = unit
					bestTargetDistance = nBotUnitDistance
				end
			end
		end
	end

	return bestTarget
end

return X
