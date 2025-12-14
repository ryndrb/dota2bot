local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_slark'
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
                [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_slippers",
				"item_circlet",
			
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
				"item_diffusal_blade",
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_basher",
				"item_satanic",--
				"item_disperser",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_abyssal_blade",--
				"item_moon_shard",
				"item_skadi",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_magic_wand", "item_basher",
				"item_wraith_band", "item_satanic",
				"item_power_treads", "item_skadi",
			},
        },
    },
    ['pos_2'] = {
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
    ['pos_3'] = {
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
                [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_slippers",
				"item_circlet",
			
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
				"item_diffusal_blade",
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_nullifier",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_disperser",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_satanic",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_wraith_band", "item_nullifier",
				"item_magic_wand", "item_abyssal_blade",
				"item_power_treads", "item_satanic",
			},
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_melee_carry' }, {"item_power_treads", 'item_quelling_blade'} end

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

local DarkPact = bot:GetAbilityByName('slark_dark_pact')
local Pounce = bot:GetAbilityByName('slark_pounce')
local EssenceShift = bot:GetAbilityByName('slark_essence_shift')
local DepthShroud = bot:GetAbilityByName('slark_depth_shroud')
local ShadowDance = bot:GetAbilityByName('slark_shadow_dance')

local DarkPactDesire
local PounceDesire
local DepthShroudDesire, DepthShroudLocation
local ShadowDanceDesire

local ffLastPounceTime = 0

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	DarkPact = bot:GetAbilityByName('slark_dark_pact')
	Pounce = bot:GetAbilityByName('slark_pounce')
	DepthShroud = bot:GetAbilityByName('slark_depth_shroud')
	ShadowDance = bot:GetAbilityByName('slark_shadow_dance')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	DarkPactDesire = X.ConsiderDarkPact()
	if DarkPactDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(DarkPact)
		return
	end

	PounceDesire = X.ConsiderPounce()
	if PounceDesire > 0 then
		ffLastPounceTime = DotaTime()
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Pounce)
		return
	end

	DepthShroudDesire, DepthShroudLocation = X.ConsiderDepthShroud()
	if DepthShroudDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(DepthShroud, DepthShroudLocation)
		return
	end

	ShadowDanceDesire = X.ConsiderShadowDance()
	if ShadowDanceDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ShadowDance)
		return
	end
end

function X.ConsiderDarkPact()
	if not J.CanCastAbility(DarkPact) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = DarkPact:GetSpecialValueInt( 'radius' )
	local nDelay = DarkPact:GetSpecialValueFloat('delay')
	local nDamage = DarkPact:GetSpecialValueFloat('total_damage')
	local nManaCost = DarkPact:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Pounce, DepthShroud, ShadowDance})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {DarkPact, Pounce, DepthShroud, ShadowDance})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Pounce, ShadowDance})

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroes > 0 then
		if bot:IsDisarmed()
		or bot:IsRooted()
		or bot:IsBlind()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold3 then
		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				if GetUnitToLocationDistance(bot, J.GetCorrectLoc(enemyHero, nDelay)) <= nRadius then
					count = count + 1
				end
			end
		end

		if count >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				local bIsFaster = bot:GetCurrentMovementSpeed() > enemyHero:GetCurrentMovementSpeed() + 10
				if (J.IsChasingTarget(enemyHero, bot) and not bIsFaster)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot and not bIsFaster)
				or bot:IsRooted()
				or botHP < 0.55
				or bot:GetCurrentMovementSpeed() < 200
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold2 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 4)
			or (#nEnemyCreeps >= 3 and not J.IsLateGame() and #nAllyHeroes <= 2)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and bAttacking and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 4)
			or (#nEnemyCreeps >= 3 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded'))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 4 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 3)
			or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPounce()
	if not J.CanCastAbility(Pounce)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nDistance = Pounce:GetSpecialValueInt('pounce_distance')
	local nCastPoint = Pounce:GetCastPoint()
	local nRestoreTime = Pounce:GetSpecialValueInt('charge_restore_time')
	local nManaCost = Pounce:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {DarkPact, DepthShroud, ShadowDance})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {DarkPact, Pounce, DepthShroud, ShadowDance})

	local vLocation = J.GetFaceTowardDistanceLocation(bot, nDistance)

	if J.IsStuck(bot) then
		if IsLocationPassable(vLocation) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nDistance - 100)
		and J.CanCastOnNonMagicImmune(botTarget)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 650
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_slark_pounce_leash')
		and bot:IsFacingLocation(botTarget:GetLocation(), 10)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if botHP < 0.55 or J.IsRunning(bot) then
					if bot:IsFacingLocation(J.GetTeamFountain(), 30) then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

    if J.IsPushing(bot) and fManaAfter > fManaThreshold2 and not bAttacking and #nEnemyHeroes == 0 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if  GetUnitToLocationDistance(bot, vLaneFrontLocation) > 1600
		and GetUnitToLocationDistance(bot, J.GetTeamFountain()) < J.GetDistance(vLaneFrontLocation, J.GetTeamFountain())
		and DotaTime() > ffLastPounceTime + nRestoreTime
		then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and not bAttacking and #nEnemyHeroes == 0 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if  GetUnitToLocationDistance(bot, vLaneFrontLocation) > 1600
		and GetUnitToLocationDistance(bot, J.GetTeamFountain()) < J.GetDistance(vLaneFrontLocation, J.GetTeamFountain())
		and DotaTime() > ffLastPounceTime + nRestoreTime
		then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold2 then
		if bot.farm and bot.farm.location and DotaTime() > ffLastPounceTime + nRestoreTime then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			if J.IsRunning(bot) and bot:IsFacingLocation(bot.farm.location, 45) and distance > nDistance then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold2 then
		if bot.rune and bot.rune.location and DotaTime() > ffLastPounceTime + nRestoreTime then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			if J.IsRunning(bot) and bot:IsFacingLocation(bot.rune.location, 30) and distance > nDistance then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, vRoshanLocation) > 2000 and #nEnemyHeroes == 0 and DotaTime() > ffLastPounceTime + nRestoreTime then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
        end
    end

    if J.IsDoingTormentor(bot) then
        local vTormentorLocation = J.GetTormentorLocation(GetTeam())
        if GetUnitToLocationDistance(bot, vTormentorLocation) > 2000 and #nEnemyHeroes == 0 and DotaTime() > ffLastPounceTime + nRestoreTime then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDepthShroud()
	if not J.CanCastAbility(DepthShroud) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = DepthShroud:GetCastRange()
	local nRadius = DepthShroud:GetSpecialValueInt('radius')
	local nManaCost = DepthShroud:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Pounce, ShadowDance})

	if fManaAfter > fManaThreshold1 then
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and J.GetHP(allyHero) < 0.5
			and not J.IsSuspiciousIllusion(allyHero)
			and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_slark_depth_shroud')
			and not allyHero:HasModifier('modifier_slark_shadow_dance')
			and allyHero:WasRecentlyDamagedByAnyHero(2.0)
			then
				if J.IsDisabled(allyHero)
				or not J.IsRunning(allyHero)
				or J.IsAttacking(allyHero)
				or J.IsStunProjectileIncoming(allyHero, 550)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderShadowDance()
	if not J.CanCastAbility(ShadowDance) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaCost = ShadowDance:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {DarkPact, Pounce})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 650)
		and botHP < 0.75
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
			if #nInRangeEnemy >= 2 or botHP < 0.5 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsSuspiciousIllusion(enemyHero)
			then
				if (J.IsChasingTarget(enemyHero, bot))
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or botHP < 0.6
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if botHP < 0.6 and J.IsStunProjectileIncoming(bot, 800) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if bot:DistanceFromFountain() > 4000 and botHP < 0.25 and fManaAfter > fManaThreshold1 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
