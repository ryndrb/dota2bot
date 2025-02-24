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
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_kaya",
				"item_blink",
				"item_ultimate_scepter",
				"item_yasha_and_kaya",--
				"item_shivas_guard",--
				"item_cyclone",
				"item_aghanims_shard",
				"item_overwhelming_blink",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_travel_boots_2",--
				"item_moon_shard"
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_null_talisman", "item_shivas_guard",
				"item_bottle", "item_cyclone",
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
			
				"item_bracer",
				"item_arcane_boots",
				"item_magic_wand",
				"item_kaya",
				"item_pipe",--
				"item_shivas_guard",--
				sUtilityItem,--
				"item_yasha_and_kaya",--
				"item_ultimate_scepter",
				"item_travel_boots",
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard"
			},
            ['sell_list'] = {
				"item_magic_wand", sUtilityItem,
				"item_bracer", "item_ultimate_scepter",
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
local Chakram 			= bot:GetAbilityByName( 'shredder_chakram' )
local ChakramReturn 	= bot:GetAbilityByName( 'shredder_return_chakram' )
-- local Chakram2 			= bot:GetAbilityByName( 'shredder_chakram_2' )
-- local ChakramReturn2 	= bot:GetAbilityByName( 'shredder_return_chakram_2' )
local Flamethrower 		= bot:GetAbilityByName( 'shredder_flamethrower' )
local TwistedChakram    = bot:GetAbilityByName( 'shredder_twisted_chakram' )

local WhirlingDeathDesire
local TimberChainDesire, TreeLocation
local ReactiveArmorDesire
local ChakramDesire, ChakramLocation
local ChakramReturnDesire
-- local Chakram2Desire, Chakram2Loc
-- local ChakramReturn2Desire
local FlamethrowerDesire
local TwistedChakramDesire, TwistedChakramLocation

local eta1 = 0
-- local eta2 = 0

local Chakram1Location
local Chakram1ETA = 0
local Chakram1CastTime = 0

-- local Chakram2Location
-- local Chakram2ETA = 0
-- local Chakram2CastTime = 0

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	WhirlingDeath 	= bot:GetAbilityByName( 'shredder_whirling_death' )
	TimberChain 		= bot:GetAbilityByName( 'shredder_timber_chain' )
	ReactiveArmor     = bot:GetAbilityByName( 'shredder_reactive_armor' )
	Chakram 			= bot:GetAbilityByName( 'shredder_chakram' )
	ChakramReturn 	= bot:GetAbilityByName( 'shredder_return_chakram' )
	Flamethrower 		= bot:GetAbilityByName( 'shredder_flamethrower' )
	TwistedChakram    = bot:GetAbilityByName( 'shredder_twisted_chakram' )

	TwistedChakramDesire, TwistedChakramLocation = X.ConsiderTwistedChakram()
	if TwistedChakramDesire > 0 then
		bot:Action_UseAbilityOnLocation(TwistedChakram, TwistedChakramLocation)
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
        bot:Action_UseAbility(WhirlingDeath)
		return
	end

	ChakramReturnDesire = X.ConsiderChakramReturn()
	if ChakramReturnDesire > 0
	then
		bot:Action_UseAbility(ChakramReturn)
		Chakram1Location = bot:GetLocation()
		return
	end

	-- ChakramReturn2Desire = X.ConsiderChakramReturn2()
	-- if ChakramReturn2Desire > 0
	-- then
	-- 	bot:Action_UseAbility(ChakramReturn2)
	-- 	Chakram2Location = bot:GetLocation()
	-- 	return
	-- end

	ChakramDesire, ChakramLocation, eta1 = X.ConsiderChakram()
	if ChakramDesire > 0
	then
		bot:Action_UseAbilityOnLocation(Chakram, ChakramLocation)
		Chakram1Location = ChakramLocation
		Chakram1CastTime = DotaTime()
		Chakram1ETA = eta1
		return
	end

	-- Chakram2Desire, Chakram2Loc, eta2 = X.ConsiderChakram2()
	-- if Chakram2Desire > 0
	-- then
	-- 	bot:Action_UseAbilityOnLocation(Chakram2, Chakram2Loc)
	-- 	Chakram2Location = Chakram2Loc
	-- 	Chakram2CastTime = DotaTime()
	-- 	Chakram2ETA = eta2
	-- 	return
	-- end

	ReactiveArmorDesire = X.ConsiderReactiveArmor()
	if ReactiveArmorDesire > 0
	then
        bot:Action_UseAbility(ReactiveArmor)
		return
	end

	FlamethrowerDesire = X.ConsiderFlamethrower()
	if FlamethrowerDesire > 0
	then
		bot:Action_UseAbility(Flamethrower)
		return
	end
end

function X.ConsiderWhirlingDeath()
	if not J.CanCastAbility(WhirlingDeath)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = WhirlingDeath:GetSpecialValueInt('whirling_radius')
	local nTreeDamage = WhirlingDeath:GetSpecialValueInt('tree_damage_scale')
	local nDamage = WhirlingDeath:GetSpecialValueInt('whirling_damage')
	local nManaCost = WhirlingDeath:GetManaCost()
	local botManaAfter = J.GetManaAfter(nManaCost)
	local botTarget = J.GetProperTarget(bot)

	local nTrees = bot:GetNearbyTrees(nRadius)
	if #nTrees > 0 then
		nDamage = nDamage + #nTrees * nTreeDamage
	end

	local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(tEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
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
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.IsInEtherealForm(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius - 50)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
		if J.IsValidHero(tEnemyHeroes[1])
		and J.CanCastOnNonMagicImmune(tEnemyHeroes[1])
		and J.IsInRange(bot, tEnemyHeroes[1], nRadius)
		and J.IsChasingTarget(tEnemyHeroes[1], bot)
		and not J.IsSuspiciousIllusion(tEnemyHeroes[1])
		and not tEnemyHeroes[1]:HasModifier('modifier_abaddon_borrowed_time')
		and not tEnemyHeroes[1]:HasModifier('modifier_dazzle_shallow_grave')
		and not tEnemyHeroes[1]:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local tCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
		if #tCreeps >= 3 and botManaAfter > 0.35
		and J.CanBeAttacked(tCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot)
	then
		if J.IsValid(tCreeps[1])
		and (#tCreeps >= 2 or #tCreeps >= 1 and tCreeps[1]:IsAncientCreep())
		and botManaAfter > 0.25 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsLaning(bot)
	then
		local tCanKillList = {}
		local tEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

		for _, creep in pairs(tEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
			then
				if J.IsValidHero(tEnemyHeroes[1])
				and not J.IsSuspiciousIllusion(tEnemyHeroes[1])
				and GetUnitToUnitDistance(creep, tEnemyHeroes[1]) <= 600
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end

			if J.IsValid(creep) and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
			then
				table.insert(tCanKillList, creep)
			end
		end

		if #tCanKillList >= 2
		and botManaAfter > 0.29 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(botTarget) > 0.25
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsDoingTormentor(bot)
    then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(botTarget) > 0.5
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	tEnemyHeroes = bot:GetNearbyHeroes(nRadius - 50, true, BOT_MODE_NONE)
	if #tEnemyHeroes >= 2 then
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

	local nCastRange = J.GetProperCastRange(false, bot, TimberChain:GetCastRange())
	local nCastPoint = TimberChain:GetCastPoint()
	local nDamageRadius = TimberChain:GetSpecialValueInt('radius')
	local nChainRadius = TimberChain:GetSpecialValueInt('chain_radius')
	local nSpeed = TimberChain:GetSpecialValueInt('speed')
	local nDamage = TimberChain:GetSpecialValueInt('damage')
	local nWhirlingDamage = WhirlingDeath:GetSpecialValueInt('whirling_damage')
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			local tInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local tInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
			if J.WeAreStronger(bot, 1200)
			or #tInRangeAlly >= #tInRangeEnemy then
				local nTargetTree = X.GetBestTree(botTarget, nCastRange, nDamageRadius)
				if nTargetTree ~= nil
				then
					if J.CanCastAbility(WhirlingDeath)
					and bot:GetMana() > TimberChain:GetManaCost() + WhirlingDeath:GetManaCost()
					and J.CanKillTarget(botTarget, nDamage + nWhirlingDamage, DAMAGE_TYPE_PURE)
					then
						return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
					else
						return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	then
		local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

		if J.IsValidHero(tEnemyHeroes[1])
		and J.IsInRange(bot, tEnemyHeroes[1], 800)
		and J.IsChasingTarget(tEnemyHeroes[1], bot)
		and bot:WasRecentlyDamagedByAnyHero(4.0) then
			local nTargetTree = X.GetBestRetreatTree(nCastRange, nChainRadius)
			if nTargetTree then
				return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
			end
		end
	end

	if J.IsStuck(bot)
	then
		local nTargetTree = X.GetBestRetreatTree(nCastRange, nChainRadius)
		if nTargetTree then
			return BOT_ACTION_DESIRE_HIGH, GetTreeLocation(nTargetTree)
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderReactiveArmor()
	if not J.CanCastAbility(ReactiveArmor)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 800) then
		if J.GetHP(bot) < 0.75 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 500)
		and (J.IsChasingTarget(botTarget, bot) or botTarget:GetAttackTarget() == bot)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	then
		if (J.GetHP(bot) < 0.51 and bot:WasRecentlyDamagedByAnyHero(2.5))
		or J.GetHP(bot) < 0.25
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
	local nMana = bot:GetMana() / bot:GetMaxMana()
	local nManaAfter = J.GetManaAfter(TwistedChakram:GetManaCost())
	local botTarget = J.GetProperTarget(bot)

	local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(tEnemyHeroes) do
		if J.IsValidHero(enemyHero)
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

	if J.IsGoingOnSomeone(bot)
	then
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
		for _, enemy in pairs(tEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.IsInRange(bot, enemy, 500)
			and J.IsChasingTarget(enemy, bot)
			and not J.IsDisabled(enemy)
			then
				return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
			end
		end
	end

	local tEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
	if (J.IsDefending(bot) or J.IsPushing(bot)) and nManaAfter > 0.3
	then
		if J.IsValid(tEnemyLaneCreeps[1])
		and J.CanBeAttacked(tEnemyLaneCreeps[1])
		and not J.IsRunning(tEnemyLaneCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, tEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsFarming(bot) and nManaAfter > 0.3
	then
		local tCreeps = bot:GetNearbyCreeps(nCastRange, true)
		if J.IsValid(tCreeps[1])
		and J.CanBeAttacked(tCreeps[1])
		and not J.IsRunning(tCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, tCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if (nLocationAoE.count >= 3 or nLocationAoE.count >= 1 and tCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsLaning(bot)
	and nMana > 0.35
	then
		for _, creep in pairs(tEnemyLaneCreeps)
		do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
			and bot:GetAttackTarget() ~= creep
			then
				if J.IsValidHero(tEnemyHeroes[1])
				and not J.IsSuspiciousIllusion(tEnemyHeroes[1])
				and GetUnitToUnitDistance(creep, tEnemyHeroes[1]) <= 600
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderChakram()
	if not J.CanCastAbility(Chakram)
	then
		return BOT_ACTION_DESIRE_NONE, 0, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Chakram:GetCastRange())
	local nCastPoint = Chakram:GetCastPoint()
	local nRadius = Chakram:GetSpecialValueFloat('radius')
	local nSpeed = Chakram:GetSpecialValueFloat('speed')
	local nDamage = Chakram:GetSpecialValueInt('pass_damage')
	local nMana = bot:GetMana() / bot:GetMaxMana()
	local botTarget = J.GetProperTarget(bot)

	local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(tEnemyHeroes)
	do
		if J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta), eta
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta), eta
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
		if J.IsValidHero(tEnemyHeroes[1])
		and J.CanCastOnNonMagicImmune(tEnemyHeroes[1])
		and J.IsInRange(bot, tEnemyHeroes[1], 500)
		and J.IsChasingTarget(tEnemyHeroes[1], bot)
		and not J.IsDisabled(tEnemyHeroes[1])
		then
			local eta = (GetUnitToUnitDistance(bot, tEnemyHeroes[1]) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, tEnemyHeroes[1]:GetLocation(), eta
		end
	end

	local tEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
	if J.IsDefending(bot) or J.IsPushing(bot)
	then
		if J.IsValid(tEnemyLaneCreeps[1])
		and J.CanBeAttacked(tEnemyLaneCreeps[1])
		and not J.IsRunning(tEnemyLaneCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, tEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4
			and nMana > 0.3
			then
				local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, eta
			end
		end
	end

	if J.IsFarming(bot)
	then
		local tCreeps = bot:GetNearbyCreeps(nCastRange, true)
		if J.IsValid(tCreeps[1])
		and J.CanBeAttacked(tCreeps[1])
		and not J.IsRunning(tCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, tCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if (nLocationAoE.count >= 3 or nLocationAoE.count >= 1 and tCreeps[1]:IsAncientCreep())
			and nMana > 0.3
			then
				local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, eta
			end
		end
	end

	if J.IsLaning(bot)
	and nMana > 0.35
	then
		for _, creep in pairs(tEnemyLaneCreeps)
		do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
			and GetUnitToUnitDistance(bot, creep) > bot:GetAttackRange() * 2.5
			then
				if J.IsValidHero(tEnemyHeroes[1])
				and not J.IsSuspiciousIllusion(tEnemyHeroes[1])
				and GetUnitToUnitDistance(creep, tEnemyHeroes[1]) <= 600
				then
					local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), eta
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
	local nMana = bot:GetMana() / bot:GetMaxMana()

	local unitCount = 0
	local nNearbyCreeps = bot:GetNearbyCreeps(nCastRange, true)
	for _, creep in pairs(nNearbyCreeps)
	do
		if J.IsValid(creep) then
			if not J.CanBeAttacked(creep)
			or creep:GetHealth() <= bot:GetAttackDamage() then
				return BOT_ACTION_DESIRE_HIGH
			end

			if GetUnitToLocationDistance(creep, Chakram1Location) <= nRadius
			then
				unitCount = unitCount + 1
			end
		end
	end

	if nMana < 0.15
	or GetUnitToLocationDistance(bot, Chakram1Location) > 1600
	or unitCount == 0
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsRetreating(bot)
	or J.IsGoingOnSomeone(bot)
	then
		unitCount = 0
		local tInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

		for _, enemyHero in pairs(tInRangeEnemy)
		do
			if J.IsValidHero(enemyHero) then
				if GetUnitToLocationDistance(enemyHero, Chakram1Location) <= nRadius
				then
					unitCount = unitCount + 1
				end
			end
		end

		if unitCount == 0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- function X.ConsiderChakram2()
-- 	if not Chakram2:IsFullyCastable()
-- 	or Chakram2:IsHidden()
-- 	then
-- 		return BOT_ACTION_DESIRE_NONE, 0, 0
-- 	end

-- 	local nCastRange = J.GetProperCastRange(false, bot, Chakram2:GetCastRange())
-- 	local nCastPoint = Chakram2:GetCastPoint()
-- 	local nRadius = Chakram2:GetSpecialValueFloat('radius')
-- 	local nSpeed = Chakram2:GetSpecialValueFloat('speed')
-- 	local nManaCost = Chakram2:GetManaCost()
-- 	local nDamage = Chakram2:GetSpecialValueInt('pass_damage') * (1 + bot:GetSpellAmp())
-- 	local nMana = bot:GetMana() / bot:GetMaxMana()
-- 	local botTarget = J.GetProperTarget(bot)

-- 	if J.IsGoingOnSomeone(bot)
-- 	then
-- 		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 100, false, BOT_MODE_NONE)
-- 		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

-- 		if  J.IsValidTarget(botTarget)
-- 		and J.CanCastOnNonMagicImmune(botTarget)
-- 		and J.IsInRange(bot, botTarget, nCastRange)
-- 		and not J.IsSuspiciousIllusion(botTarget)
-- 		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
-- 		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
-- 		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
-- 		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
-- 		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
-- 		and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
-- 		and #nInRangeAlly >= #nInRangeEnemy
-- 		then
-- 			local loc = GetUltLoc(botTarget, nManaCost, nCastRange, nSpeed)

-- 			if loc ~= nil
-- 			then
-- 				local nDelay = (GetUnitToLocationDistance(bot, loc) / nSpeed) + nCastPoint
-- 				return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(nDelay), nDelay
-- 			end
-- 		end
-- 	end

-- 	if J.IsRetreating(bot)
-- 	then
-- 		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 100, false, BOT_MODE_NONE)
-- 		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

-- 		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
-- 		and ((#nInRangeEnemy > #nInRangeAlly)
-- 			or (J.GetHP(bot) and bot:WasRecentlyDamagedByAnyHero(3)))
-- 		and J.IsValidHero(nInRangeEnemy[1])
-- 		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
-- 		and J.IsInRange(bot, nInRangeEnemy[1], 500)
-- 		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
-- 		and not J.IsDisabled(nInRangeEnemy[1])
-- 		then
-- 			local nDelay = (GetUnitToUnitDistance(bot, nInRangeEnemy[1]) / nSpeed) + nCastPoint
-- 			return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]:GetExtrapolatedLocation(nDelay), nDelay
-- 		end
-- 	end

-- 	if J.IsDefending(bot) or J.IsPushing(bot)
-- 	then
-- 		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

-- 		if  nLocationAoE.count >= 4
-- 		and nMana > 0.33
-- 		then
-- 			local e = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
-- 			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, e
-- 		end
-- 	end

-- 	if J.IsFarming(bot)
-- 	then
-- 		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
-- 		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

-- 		if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 3
-- 		and nLocationAoE.count >= 3
-- 		and nMana > 0.45
-- 		then
-- 			local e = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
-- 			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, e
-- 		end
-- 	end

-- 	if J.IsLaning(bot)
-- 	then
-- 		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

-- 		for _, creep in pairs(nEnemyLaneCreeps)
-- 		do
-- 			if  J.IsValid(creep)
-- 			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
-- 			and creep:GetHealth() <= nDamage
-- 			then
-- 				local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

-- 				if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
-- 				and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) <= 600
-- 				then
-- 					local e = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
-- 					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), e
-- 				end
-- 			end
-- 		end
-- 	end

-- 	return BOT_ACTION_DESIRE_NONE, 0, 0
-- end

-- function X.ConsiderChakramReturn2()
-- 	if (Chakram2Location == 0 or Chakram2Location == nil)
-- 	or not ChakramReturn2:IsFullyCastable()
-- 	or ChakramReturn2:IsHidden()
-- 	then
-- 		return BOT_ACTION_DESIRE_NONE
-- 	end

-- 	if DotaTime() < Chakram2CastTime + Chakram2ETA
-- 	or X.IsChakramStillTraveling(2)
-- 	then
-- 		return BOT_ACTION_DESIRE_NONE
-- 	end

-- 	local nCastRange = J.GetProperCastRange(false, bot, Chakram:GetCastRange())
-- 	local nRadius = Chakram:GetSpecialValueFloat('radius')
-- 	local nMana = bot:GetMana() / bot:GetMaxMana()

-- 	local unitCount = 0
-- 	local nNearbyCreeps = bot:GetNearbyCreeps(nCastRange, true)
-- 	for _, c in pairs(nNearbyCreeps)
-- 	do
-- 		if GetUnitToLocationDistance(c, Chakram2Location) <= nRadius
-- 		then
-- 			unitCount = unitCount + 1
-- 		end
-- 	end

-- 	if nMana < 0.15
-- 	or GetUnitToLocationDistance(bot, Chakram2Location) > 1600
-- 	or unitCount == 0
-- 	then
-- 		return BOT_ACTION_DESIRE_MODERATE
-- 	end

-- 	if J.IsRetreating(bot)
-- 	or J.IsGoingOnSomeone(bot)
-- 	then
-- 		local nUnits = 0
-- 		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

-- 		for _, enemyHero in pairs(nInRangeEnemy)
-- 		do
-- 			if GetUnitToLocationDistance(enemyHero, Chakram2Location) <= nRadius
-- 			then
-- 				nUnits = nUnits + 1
-- 			end
-- 		end

-- 		if nUnits == 0
-- 		then
-- 			return BOT_ACTION_DESIRE_MODERATE
-- 		end
-- 	end

-- 	return BOT_ACTION_DESIRE_NONE
-- end

-- function X.ConsiderClosing()
-- 	if not bot:HasModifier('modifier_shredder_chakram_disarm')
-- 	then
-- 		return BOT_ACTION_DESIRE_NONE, 0
-- 	end

-- 	local botTarget = J.GetProperTarget(bot)

-- 	if J.IsGoingOnSomeone(bot)
-- 	then
-- 		local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
-- 		local nInRangeEnemy = bot:GetNearbyHeroes(600, true, BOT_MODE_NONE)

-- 		if  J.IsValidTarget(botTarget)
-- 		and J.CanCastOnNonMagicImmune(botTarget)
-- 		and J.IsInRange(bot, botTarget, 500)
-- 		and not J.IsSuspiciousIllusion(botTarget)
-- 		and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
-- 		and #nInRangeAlly >= #nInRangeEnemy
-- 		then
-- 			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
-- 		end
-- 	end

-- 	return BOT_ACTION_DESIRE_NONE, 0
-- end

function X.ConsiderFlamethrower()
	if not J.CanCastAbility(Flamethrower)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nFrontRange = Flamethrower:GetSpecialValueInt('length')
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nFrontRange)
		and bot:IsFacingLocation(botTarget:GetLocation(), 30)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsPushing(bot) then
		if J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.GetHP(botTarget) > 0.5
		and J.IsInRange(bot, botTarget, nFrontRange)
		and J.IsAttacking(bot) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nFrontRange)
		and J.GetHP(botTarget) > 0.25
		and J.IsAttacking(bot) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- HELPER FUNCS
function X.AreThereTreesInBetween(hSourceLocation, hTargetLocation, nCastRange, nRadius)
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))
	for _, tree in pairs(nTrees)
	do
		if tree
		and hSourceLocation ~= GetTreeLocation(tree)
		and hTargetLocation ~= GetTreeLocation(tree) then
			local tResult = PointToLineDistance(hSourceLocation, hTargetLocation, GetTreeLocation(tree))
			if tResult and tResult.within and tResult.distance <= nRadius then
				return true
			end
		end
	end

	return false
end

function X.GetBestRetreatTree(nCastRange, nRadius)
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))

	local bestRetreatTree = nil
	local bestRetreatTreeDist = 0
	local bestRetreatTreeFountainDist = 100000

	local vTeamFountain = J.GetTeamFountain()
	local botLoc = bot:GetLocation()

	local vToFountain = (vTeamFountain - botLoc):Normalized()

	for i = #nTrees, 1, -1
	do
		if nTrees[i] then
			local vTreeLoc = GetTreeLocation(nTrees[i])
			if not X.AreThereTreesInBetween(botLoc, vTreeLoc, nCastRange, nRadius) then
				local currDist1 = GetUnitToLocationDistance(bot, vTreeLoc)
				local currDist2 = J.GetDistance(vTeamFountain, vTreeLoc)
				local vToTree = (vTreeLoc - botLoc):Normalized()
				local dot = X.GetDotProduct(vToTree, vToFountain)
				if dot > 0
				and currDist1 > bestRetreatTreeDist
				and currDist2 < bestRetreatTreeFountainDist then
					bestRetreatTreeDist = currDist1
					bestRetreatTreeFountainDist = currDist2
					bestRetreatTree = nTrees[i]
				end
			end
		end
	end

	if bestRetreatTree ~= nil and bestRetreatTreeDist > 300
	then
		return bestRetreatTree
	end

	return bestRetreatTree
end

function X.GetBestTree(hTarget, nCastRange, nRadius)
	local bestTree = nil
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))
	local botLoc = bot:GetLocation()
	local hTargetLoc = hTarget:GetLocation()

	local vToTarget = (hTargetLoc - botLoc):Normalized()

	for _, tree in pairs(nTrees)
	do
		if tree then
			local vTreeLoc = GetTreeLocation(tree)
			local vToTree = (vTreeLoc - botLoc):Normalized()
			local dot = X.GetDotProduct(vToTree, vToTarget)

			if J.IsInRange(bot, hTarget, nRadius - 25)
			and dot >= 0.5 then
				return tree
			end

			local tResult = PointToLineDistance(bot:GetLocation(), vTreeLoc, hTarget:GetLocation())
			if not X.AreThereTreesInBetween(botLoc, hTargetLoc, nCastRange, nRadius)
			and dot > 0
			then
				if J.IsChasingTarget(bot, hTarget) then
					if tResult and tResult.within and tResult.distance <= nRadius * 2 then
						bestTree = tree
						break
					end
				else
					if tResult and tResult.within and tResult.distance <= nRadius then
						bestTree = tree
						break
					end
				end
			end
		end
	end

	return bestTree
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

function X.GetDotProduct(A, B)
	return A.x * B.x + A.y * B.y + A.z * B.z
end

return X