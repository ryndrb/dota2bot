local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_shredder'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,3,2,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_kaya",
				"item_blink",
				"item_ultimate_scepter",
				"item_kaya_and_sange",--
				"item_shivas_guard",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_overwhelming_blink",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blink",
				"item_magic_wand", "item_ultimate_scepter",
				"item_null_talisman", "item_shivas_guard",
				"item_bottle", "item_black_king_bar",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,3,2,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
			
				"item_magic_wand",
				"item_bracer",
				"item_arcane_boots",
				"item_soul_ring",
				"item_kaya",
				"item_pipe",--
				"item_kaya_and_sange",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_shivas_guard",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_pipe",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", sUtilityItem,
				"item_soul_ring", "item_shivas_guard",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

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

local WhirlingDeath 	= bot:GetAbilityByName( 'shredder_whirling_death' )
local TimberChain 		= bot:GetAbilityByName( 'shredder_timber_chain' )
local ReactiveArmor     = bot:GetAbilityByName( 'shredder_reactive_armor' )
local Flamethrower 		= bot:GetAbilityByName( 'shredder_flamethrower' )
local TwistedChakram    = bot:GetAbilityByName( 'shredder_twisted_chakram' )
local Chakram 			= bot:GetAbilityByName( 'shredder_chakram' )
local ChakramReturn 	= bot:GetAbilityByName( 'shredder_return_chakram' )

local WhirlingDeathDesire
local TimberChainDesire, TreeLocation
local ReactiveArmorDesire
local ChakramDesire, ChakramLocation
local ChakramReturnDesire
local FlamethrowerDesire
local TwistedChakramDesire, TwistedChakramLocation

local Chakram1Location
local Chakram1ETA = 0
local Chakram1CastTime = 0

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	WhirlingDeath 	= bot:GetAbilityByName( 'shredder_whirling_death' )
	TimberChain 		= bot:GetAbilityByName( 'shredder_timber_chain' )
	ReactiveArmor     = bot:GetAbilityByName( 'shredder_reactive_armor' )
	Flamethrower 		= bot:GetAbilityByName( 'shredder_flamethrower' )
	TwistedChakram    = bot:GetAbilityByName( 'shredder_twisted_chakram' )
	Chakram 			= bot:GetAbilityByName( 'shredder_chakram' )
	ChakramReturn 	= bot:GetAbilityByName( 'shredder_return_chakram' )

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	TwistedChakramDesire, TwistedChakramLocation = X.ConsiderTwistedChakram()
	if TwistedChakramDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(TwistedChakram, TwistedChakramLocation)
		return
	end

	TimberChainDesire, TreeLocation = X.ConsiderTimberChain()
	if TimberChainDesire > 0
	then
		bot:Action_UseAbilityOnLocation(TimberChain, TreeLocation)
		return
	end

	WhirlingDeathDesire = X.ConsiderWhirlingDeath()
	if WhirlingDeathDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(WhirlingDeath)
		return
	end

	ChakramReturnDesire = X.ConsiderChakramReturn()
	if ChakramReturnDesire > 0
	then
		Chakram1Location = bot:GetLocation()
		bot:Action_UseAbility(ChakramReturn)
		return
	end

	ChakramDesire, ChakramLocation, eta = X.ConsiderChakram()
	if ChakramDesire > 0
	then
		Chakram1Location = ChakramLocation
		Chakram1CastTime = DotaTime()
		Chakram1ETA = eta
		bot:Action_UseAbilityOnLocation(Chakram, ChakramLocation)
		return
	end

	ReactiveArmorDesire = X.ConsiderReactiveArmor()
	if ReactiveArmorDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ReactiveArmor)
		return
	end

	FlamethrowerDesire = X.ConsiderFlamethrower()
	if FlamethrowerDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Flamethrower)
		return
	end
end

function X.ConsiderWhirlingDeath()
	if not J.CanCastAbility(WhirlingDeath) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = WhirlingDeath:GetSpecialValueInt('whirling_radius')
	local nTreeDamage = WhirlingDeath:GetSpecialValueInt('tree_damage_scale')
	local nDamage = WhirlingDeath:GetSpecialValueInt('whirling_damage')
	local nManaCost = WhirlingDeath:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TimberChain, ReactiveArmor, Flamethrower, Chakram})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {TimberChain, Chakram})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {TimberChain})
	local fManaThreshold4 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, Flamethrower, Chakram})

	local nTrees = bot:GetNearbyTrees(nRadius)
	if #nTrees > 0 then
		nDamage = nDamage + #nTrees * nTreeDamage
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(bot, enemyHero, nRadius - 50)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius - 50)
		and J.IsInEtherealForm(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		and fManaAfter > fManaThreshold3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius - 50)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	and fManaAfter > fManaThreshold3
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius - 50)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and fManaAfter > fManaThreshold4 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and botTarget:IsCreep()
		and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PURE)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PURE)
		and fManaAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold4 and bAttacking and #nEnemyHeroes <= 1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 4 then
			return BOT_ACTION_DESIRE_HIGH
		end

		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and botTarget:IsCreep()
		and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PURE)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PURE)
		and fManaAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 2 or nEnemyCreeps[1]:IsAncientCreep() then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and botTarget:IsCreep()
		and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PURE)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PURE)
		and fManaAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.IsInRange(bot, creep, nRadius - 50)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
			and fManaAfter > fManaThreshold3
			then
				if J.IsKeyWordUnit('ranged', creep) then
					local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
						return BOT_ACTION_DESIRE_HIGH
					end
				end

				if  J.IsValidHero(nEnemyHeroes[1])
				and J.CanBeAttacked(nEnemyHeroes[1])
				and J.IsInRange(bot, nEnemyHeroes[1], nRadius - 50)
				and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
				and nEnemyHeroes[1]:GetPrimaryAttribute() == ATTRIBUTE_STRENGTH
				and fManaAfter > fManaThreshold3
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, nDamage)
		if nLocationAoE.count >= 2 and fManaAfter > fManaThreshold3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(botTarget) > 0.25
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

	local nInRangeEnemy = bot:GetNearbyHeroes(nRadius - 50, true, BOT_MODE_NONE)
	if #nInRangeEnemy >= 2 and fManaAfter > fManaThreshold2 then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTimberChain()
	if not J.CanCastAbility(TimberChain)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = TimberChain:GetCastRange()
	local nCastPoint = TimberChain:GetCastPoint()
	local nDamageRadius = TimberChain:GetSpecialValueInt('radius')
	local nChainRadius = TimberChain:GetSpecialValueInt('chain_radius')
	local nManaCost = TimberChain:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, Chakram})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, ReactiveArmor})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, ReactiveArmor, Flamethrower, TwistedChakram, Chakram})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 800
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and fManaAfter > fManaThreshold2
		then
			if J.IsInRange(bot, botTarget, nCastRange) then
				local nTargetTree = X.GetBestEngageTree(botTarget, nCastRange, nDamageRadius, nChainRadius, 600, 60)
				if nTargetTree then
					return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
				end
			else
				if J.IsInRange(bot, botTarget, nCastRange + 500) then
					local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, botTarget:GetLocation(), 600, 45)
					if nTargetTree then
						return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
		local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, J.GetTeamFountain(), 600, 60)

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					if nTargetTree then
						return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
					end
				end
			end
		end

		if  #nEnemyHeroes == 0
		and bot:IsFacingLocation(J.GetTeamFountain(), 45)
		and J.IsRunning(bot)
		and (fManaAfter > fManaThreshold2 or botHP < 0.2)
		and nTargetTree
		then
			return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
		end

		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		if not J.IsInLaningPhase() and (fManaAfter > fManaThreshold2 or botHP < 0.2) then
			if #nEnemyHeroes >= #nInRangeAlly + 2 and nTargetTree then
				local vTreeLocation = GetTreeLocation(nTargetTree)
				if bot:IsFacingLocation(vTreeLocation, 45) then
					return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
				end
			end
		end
	end

	if J.IsStuck(bot) then
		local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, J.GetTeamFountain(), 300, 60)
		if nTargetTree then
			return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > 0.8 and DotaTime() > 0 then
		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and #nEnemyHeroes <= 1 then
			local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, vLaneFrontLocation, 600, 45)
			if nTargetTree then
				local vTreeLocation = GetTreeLocation(nTargetTree)
				if bot:IsFacingLocation(vTreeLocation, 45) then
					return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
				end
			end
		end
	end

	if J.IsPushing(bot) and fManaAfter > fManaThreshold3 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > 3.5 then
			local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, vLaneFrontLocation, 600, 30)
			if nTargetTree then
				local vTreeLocation = GetTreeLocation(nTargetTree)
				if bot:IsFacingLocation(vTreeLocation, 45) then
					return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
				end
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold3 and #nEnemyHeroes <= 1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > 3.5 then
			local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, vLaneFrontLocation, 600, 30)
			if nTargetTree then
				local vTreeLocation = GetTreeLocation(nTargetTree)
				if bot:IsFacingLocation(vTreeLocation, 45) then
					return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
				end
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold3 and #nEnemyHeroes == 0 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, bot.farm.location, 600, 30)
			if nTargetTree and J.IsRunning(bot) and distance > 600 then
				return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
			end
		end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold3 then
		if bot.rune and bot.rune.location then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, bot.rune.location, 600, 30)
			if nTargetTree and J.IsRunning(bot) and distance > 600 then
				return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold1
		then
			local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, vRoshanLocation, 600, 30)
			if nTargetTree then
				local vTreeLocation = GetTreeLocation(nTargetTree)
				if bot:IsFacingLocation(vTreeLocation, 45) then
					return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
				end
			end
		end
	end

	if J.IsDoingTormentor(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold1
		then
			local nTargetTree = X.GetBestTreeTowardsLocation(nCastRange, nChainRadius, vTormentorLocation, 600, 30)
			if nTargetTree then
				local vTreeLocation = GetTreeLocation(nTargetTree)
				if bot:IsFacingLocation(vTreeLocation, 45) then
					return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderReactiveArmor()
	if not J.CanCastAbility(ReactiveArmor) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

	if J.IsInTeamFight(bot, 800) then
		if bot:WasRecentlyDamagedByAnyHero(2.0) and (#nEnemyHeroesTargetingMe >= 2 or botHP < 0.65) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			if bot:WasRecentlyDamagedByAnyHero(2.0) and (#nEnemyHeroesTargetingMe >= 2 or botHP < 0.65) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bot:HasModifier('modifier_fountain_aura_buff') then
		if (botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(3.0))
		or (botHP < 0.25)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and botTarget:GetAttackTarget() == bot
		and botHP < 0.15
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and botHP < 0.25
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFlamethrower()
	if not J.CanCastAbility(Flamethrower) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nFrontRange = Flamethrower:GetSpecialValueInt('length')
	local nManaCost = Flamethrower:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, Chakram})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nFrontRange)
		and bot:IsFacingLocation(botTarget:GetLocation(), 45)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsPushing(bot) then
		if J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.GetHP(botTarget) > 0.5
		and J.IsInRange(bot, botTarget, nFrontRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nFrontRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.GetHP(botTarget) > 0.25
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nFrontRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTwistedChakram()
	if not J.CanCastAbility(TwistedChakram) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, TwistedChakram:GetCastRange())
	local nCastPoint = TwistedChakram:GetCastPoint()
	local nDamage = TwistedChakram:GetSpecialValueInt('damage')
	local nRadius = TwistedChakram:GetSpecialValueInt('radius')
	local nSpeed = TwistedChakram:GetSpecialValueFloat('speed')
	local nManaCost = TwistedChakram:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, ReactiveArmor, Chakram})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, ReactiveArmor, TwistedChakram, Chakram})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
		and not enemyHero:HasModifier('modifier_ursa_enrage')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
		and not botTarget:HasModifier('modifier_ursa_enrage')
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	and not J.CanCastAbility(TimberChain)
	then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.IsInRange(bot, enemy, nCastRange)
			and not J.IsDisabled(enemy)
			and not enemy:IsDisarmed()
			then
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count == 1 and creep:IsAncientCreep() and not J.CanKillTarget(creep, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL))
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.GetHP(botTarget) > 0.25
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderChakram()
	if not J.CanCastAbility(Chakram) then
		return BOT_ACTION_DESIRE_NONE, 0, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Chakram:GetCastRange())
	local nCastPoint = Chakram:GetCastPoint()
	local nRadius = Chakram:GetSpecialValueFloat('radius')
	local nSpeed = Chakram:GetSpecialValueFloat('speed')
	local nDamage = Chakram:GetSpecialValueInt('pass_damage')
	local nDPS = Chakram:GetSpecialValueInt('damage_per_second')
	local nManaCost = Chakram:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, ReactiveArmor})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, ReactiveArmor, Chakram})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold1
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			local vLocation = J.GetCorrectLoc(enemyHero, eta)
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE) and GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
				return BOT_ACTION_DESIRE_HIGH, vLocation, eta
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			local vLocation = J.GetCorrectLoc(botTarget, eta)
			if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
				return BOT_ACTION_DESIRE_HIGH, vLocation, eta
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	and not J.CanCastAbility(TimberChain)
	and not J.CanCastAbility(ReactiveArmor)
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 600)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), eta
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold2 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
					local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, eta
                end
            end
        end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
					local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, eta
                end
            end
        end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count == 1 and creep:IsAncientCreep() and not J.CanKillTarget(creep, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL))
				then
					local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, eta
                end
            end
        end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage + nDPS * 2)
                if (nLocationAoE.count >= 3) then
					local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, eta
                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0, 0
end

function X.ConsiderChakramReturn()
	if (Chakram1Location == 0 or Chakram1Location == nil)
	or not J.CanCastAbility(ChakramReturn)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if DotaTime() < Chakram1CastTime + Chakram1ETA
	or X.IsChakramStillTraveling(1)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = J.GetProperCastRange(false, bot, Chakram:GetCastRange())
	local nRadius = Chakram:GetSpecialValueFloat('radius')
	local nManaCost = Chakram:GetManaCost()
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WhirlingDeath, TimberChain, ReactiveArmor})
	local botMP = J.GetMP(bot)

	local unitCount = 0
	local nNearbyCreeps = bot:GetNearbyCreeps(nCastRange, true)
	for _, creep in pairs(nNearbyCreeps) do
		if J.IsValid(creep) then
			if not J.CanBeAttacked(creep)
			or creep:GetHealth() <= bot:GetAttackDamage()
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if GetUnitToLocationDistance(creep, Chakram1Location) <= nRadius then
				unitCount = unitCount + 1
			end
		end
	end

	if botMP < fManaThreshold1 * 2
	or GetUnitToLocationDistance(bot, Chakram1Location) > 1600
	or unitCount == 0
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsRetreating(bot)
	or J.IsGoingOnSomeone(bot)
	then
		unitCount = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero) then
				if GetUnitToLocationDistance(enemyHero, Chakram1Location) <= nRadius then
					unitCount = unitCount + 1
				end
			end
		end
	end

	if unitCount == 0 then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.GetBestTreeTowardsLocation(nCastRange, nRadius, vLocation, nMBotDistanceFromTree, nConeAngle)
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))
	local bestTree = nil
	local bestTreeDistance = 0

	local botLocation = bot:GetLocation()
	local targetDir = (vLocation - botLocation):Normalized()

	for i = #nTrees, 1, -1 do
		if nTrees[i] then
			local vTreeLocation = GetTreeLocation(nTrees[i])
			local treeDir = (vTreeLocation - botLocation):Normalized()
			local dot = J.DotProduct(targetDir, treeDir)
			local nAngle = J.GetAngleFromDotProduct(dot)
			local nBotTreeDistance = GetUnitToLocationDistance(bot, vTreeLocation)

			if nAngle <= nConeAngle and nBotTreeDistance > nMBotDistanceFromTree then
				local nBotTargetDistance = GetUnitToLocationDistance(bot, vLocation)
				local nTreeTargetDistance = J.GetDistance(vTreeLocation, vLocation)
				if nTreeTargetDistance < nBotTargetDistance and nBotTreeDistance > bestTreeDistance then
					if not X.AreThereTreesInBetween(botLocation, vTreeLocation, nTrees[i], nCastRange, nRadius) then
						bestTree = nTrees[i]
						bestTreeDistance = nBotTreeDistance
					end
				end
			end
		end
	end

	return bestTree
end

function X.GetBestEngageTree(hTarget, nCastRange, nDamageRadius, nChainRadius, nMaxTreeDistanceFromTarget, nConeAngle)
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))
	local botLocation = bot:GetLocation()
	local targetLocation = hTarget:GetLocation()
	local targetDir = (targetLocation - botLocation):Normalized()

	local bestTree = nil
	local bestTreeDistance = math.huge

	for _, tree in pairs(nTrees) do
		if tree then
			local vTreeLocation = GetTreeLocation(tree)
			local treeDir = (vTreeLocation - botLocation):Normalized()
			local dot = J.DotProduct(targetDir, treeDir)
			local nAngle = J.GetAngleFromDotProduct(dot)

			if nAngle <= nConeAngle then
				local botTreeDistance = GetUnitToLocationDistance(bot, vTreeLocation)
				local botTargetDistance = GetUnitToUnitDistance(bot, hTarget)

				if botTreeDistance > botTargetDistance then
					if not X.AreThereTreesInBetween(botLocation, targetLocation, tree, nCastRange, nChainRadius) then
						local treeTargetDistance = GetUnitToLocationDistance(hTarget, vTreeLocation)

						if botTargetDistance <= nDamageRadius and treeTargetDistance < 500 then
							return tree
						end

						if treeTargetDistance < bestTreeDistance and treeTargetDistance < nMaxTreeDistanceFromTarget then
							bestTree = tree
							bestTreeDistance = treeTargetDistance
						end
					end
				end
			end
		end
	end

	if bestTree then
		local nRadius = nDamageRadius
		local tResult = PointToLineDistance(botLocation, GetTreeLocation(bestTree), targetLocation)
		if J.CanCastAbility(WhirlingDeath) and bot:GetMana() > (TimberChain:GetManaCost() + WhirlingDeath:GetManaCost() + 100) then
			nRadius = WhirlingDeath:GetSpecialValueInt('whirling_radius')
		end

		if (tResult and tResult.within and tResult.distance <= nRadius) then
			return bestTree
		end
	end

	return nil
end

function X.AreThereTreesInBetween(vStartLocation, vEndLocation, nTree, nCastRange, nRadius)
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))
	for _, tree in pairs(nTrees) do
		if tree and tree ~= nTree then
			local vTreeLocation = GetTreeLocation(tree)
			if vStartLocation ~= vTreeLocation and vEndLocation ~= vTreeLocation then
				local tResult = PointToLineDistance(vStartLocation, vEndLocation, vTreeLocation)
				if tResult and tResult.within and tResult.distance <= nRadius then
					return true
				end
			end
		end
	end

	return false
end

function X.IsChakramStillTraveling(cType)
	local proj = GetLinearProjectiles()
	for _, p in pairs(proj)
	do
		if  p ~= nil
		and ((cType == 1 and p.ability:GetName() == 'shredder_chakram')
			or (cType == 2 and p.ability:GetName() == 'shredder_chakram_2'))
		then
			return true
		end
	end

	return false
end

return X