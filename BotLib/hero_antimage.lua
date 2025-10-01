local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_antimage'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_crimson_guard"}
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
				},
            },
            ['ability'] = {
				[1] = {1,2,1,3,2,6,2,2,1,1,6,3,3,3,6},
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
				"item_manta",--
				"item_butterfly",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_skadi",--
				"item_moon_shard",
				"item_monkey_king_bar",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_wraith_band", "item_abyssal_blade",
				"item_magic_wand", "item_skadi",
				"item_power_treads", "item_monkey_king_bar",
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
				},
				[2] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {1,2,1,3,2,6,2,2,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_orb_of_frost",
				"item_double_branches",
				"item_quelling_blade",
	
				"item_magic_wand",
				"item_orb_of_corrosion",
				"item_power_treads",
				"item_diffusal_blade",
				"item_crimson_guard",--
				"item_nullifier",--
				"item_abyssal_blade",--
				"item_aghanims_shard",
				"item_disperser",--
				"item_heart",--
				"item_moon_shard",
				"item_assault",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_nullifier",
				"item_magic_wand", "item_abyssal_blade",
				"item_orb_of_corrosion", "item_heart",
				"item_power_treads", "item_assault",
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


if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

end

-- local ManaBreak 		= bot:GetAbilityByName('antimage_mana_break')
local Blink 			= bot:GetAbilityByName('antimage_blink')
local CounterSpell 		= bot:GetAbilityByName('antimage_counterspell')
local CounterSpellAlly 	= bot:GetAbilityByName('antimage_counterspell_ally')
-- local BlinkFragment		= bot:GetAbilityByName('antimage_mana_overload')
local ManaVoid 			= bot:GetAbilityByName('antimage_mana_void')

local BlinkDesire, BlinkLocation
local CounterSpellDesire
local CounterSpellAllyDesire, CounterSpellAllyTarget
-- local BlinkFragmentDesire, BlinkFragmentLocation
local ManaVoidDesire, ManaVoidTarget

local BlinkVoidDesire, BlinkVoidTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Blink 				= bot:GetAbilityByName('antimage_blink')
	CounterSpell 		= bot:GetAbilityByName('antimage_counterspell')
	CounterSpellAlly 	= bot:GetAbilityByName('antimage_counterspell_ally')
	ManaVoid 			= bot:GetAbilityByName('antimage_mana_void')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	BlinkVoidDesire, BlinkVoidTarget = X.ConsiderBlinkVoid()
	if BlinkVoidDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Blink, BlinkVoidTarget:GetLocation())
		bot:ActionQueue_UseAbilityOnEntity(ManaVoid, BlinkVoidTarget)
		return
	end

	CounterSpellDesire = X.ConsiderCounterSpell()
	if CounterSpellDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(CounterSpell)
		return
	end

	BlinkDesire, BlinkLocation = X.ConsiderBlink()
	if BlinkDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Blink, BlinkLocation)
		return
	end

	ManaVoidDesire, ManaVoidTarget = X.ConsiderManaVoid()
	if ManaVoidDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ManaVoid, ManaVoidTarget)
		return
	end

	CounterSpellAllyDesire, CounterSpellAllyTarget = X.ConsiderCounterSpellAlly()
	if CounterSpellAllyDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(CounterSpellAlly, CounterSpellAllyTarget)
		return
	end
end

function X.ConsiderBlink()
	if not J.CanCastAbility(Blink)
	or bot:IsRooted()
	or bot:HasModifier('modifier_bloodseeker_rupture')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = Blink:GetSpecialValueInt('AbilityCastRange')
	local nCastRangeMin = Blink:GetSpecialValueInt('min_blink_range')
	local nCastPoint = Blink:GetCastPoint()
	local nManaCost = Blink:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ManaVoid})
	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nCastRange)
	end

	if  not bot:IsMagicImmune()
	and not J.CanCastAbility(CounterSpell)
	and (  J.IsStunProjectileIncoming(bot, 600)
		or J.IsUnitTargetProjectileIncoming(bot, 400)
		or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 400)))
	then
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 1600)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 600
		and not J.IsInRange(bot, botTarget, nCastRangeMin)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
		then
			local vLocation = botTarget:GetLocation()
			if J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, 500) then
				vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), 300)
			end

			if J.IsInLaningPhase() then
				if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and nEnemyTowers[1] ~= bot) then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			else
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if not bot:HasModifier('modifier_fountain_aura_buff') then
			return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nCastRange)
		end
	end

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 + 0.2 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nCastRange then
			if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nCastRange then
			if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 + 0.1 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			local vLocation = J.VectorTowards(bot:GetLocation(), bot.farm.location, Min(nCastRange, distance))
			if J.IsRunning(bot) and distance > nCastRange / 2 and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and DotaTime() > 0 and fManaAfter > 0.8 then
		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and #nEnemyHeroes <= 1 and #nEnemyTowers == 0 then
			if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold1 + 0.1 then
		if bot.rune and bot.rune.location then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			local vLocation = J.VectorTowards(bot:GetLocation(), bot.rune.location, Min(nCastRange, distance))
			if J.IsRunning(bot) and distance > nCastRange / 2 and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold1 + 0.1
		then
			if bot:IsFacingLocation(vRoshanLocation, 45) and IsLocationPassable(vRoshanLocation) then
				return BOT_ACTION_DESIRE_HIGH, vRoshanLocation
			end
		end
	end

	if J.IsDoingTormentor(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold1 + 0.1
		then
			if bot:IsFacingLocation(vTormentorLocation, 45) and IsLocationPassable(vTormentorLocation) then
				return BOT_ACTION_DESIRE_HIGH, vTormentorLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCounterSpell()
	if not J.CanCastAbility(CounterSpell)
	or bot:HasModifier('modifier_item_sphere_target')
	or bot:IsMagicImmune()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 1400))
	or (J.IsUnitTargetProjectileIncoming(bot, 400))
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCounterSpellAlly()
	if not J.CanCastAbility(CounterSpellAlly) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = CounterSpellAlly:GetCastRange()

	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
		and bot ~= allyHero
		and J.IsInRange(bot, allyHero, nCastRange)
		and allyHero:IsMagicImmune()
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_item_sphere_target')
		then
			if (not allyHero:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(allyHero, 1400))
			or (J.IsUnitTargetProjectileIncoming(allyHero, 400))
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderManaVoid()
	if not J.CanCastAbility(ManaVoid) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = ManaVoid:GetCastRange()
	local nCastPoint = ManaVoid:GetCastPoint()
	local nRadius = ManaVoid:GetSpecialValueInt('mana_void_aoe_radius')
	local fDamageFactor = ManaVoid:GetSpecialValueFloat('mana_void_damage_per_mana')

	if J.IsInTeamFight(bot, 1200) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsHaveAegis(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and enemyHero:GetUnitName() ~= 'npc_dota_hero_huskar'
			then
				local enemyHeroManaRegen = enemyHero:GetManaRegen()
				local nDamage = fDamageFactor * (enemyHero:GetMaxMana() - (enemyHero:GetMana() + enemyHeroManaRegen * nCastPoint))
				if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
					if J.IsCore(enemyHero) then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					else
						local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
						if #nInRangeEnemy >= 2 then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsHaveAegis(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and botTarget:GetUnitName() ~= 'npc_dota_hero_huskar'
		then
			local botTargetManaRegen = botTarget:GetManaRegen()
			local nDamage = fDamageFactor * (botTarget:GetMaxMana() - (botTarget:GetMana() + botTargetManaRegen * nCastPoint))
			if J.WillKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsHaveAegis(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and enemyHero:GetUnitName() ~= 'npc_dota_hero_huskar'
		then
			local enemyHeroManaRegen = enemyHero:GetManaRegen()
			local nDamage = fDamageFactor * (enemyHero:GetMaxMana() - (enemyHero:GetMana() + enemyHeroManaRegen * nCastPoint))
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)

			if  not J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and #nAllyHeroesAttackingTarget >= 3 or (#nAllyHeroesAttackingTarget >= 2 and J.GetHP(enemyHero) < 0.2)
			and not J.HasItem(bot, 'item_basher')
			and not J.HasItem(bot, 'item_abyssal_blade')
			then
				local fModifierTime = J.GetModifierTime(enemyHero, 'modifier_teleporting')
				if fModifierTime > nCastPoint then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlinkVoid()
	if J.CanCastAbility(Blink) and J.CanCastAbility(ManaVoid) and bot:GetMana() > (Blink:GetManaCost() + ManaVoid:GetManaCost() + 75) then
		local nCastRange_ManaVoid = ManaVoid:GetCastRange()
		local nCastRange_Blink = Blink:GetCastRange()
		local nCastPoint = ManaVoid:GetCastPoint() + Blink:GetCastPoint()
		local fDamageFactor = ManaVoid:GetSpecialValueFloat('mana_void_damage_per_mana')

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange_Blink)
			and not J.IsInRange(bot, enemyHero, nCastRange_ManaVoid)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and GetUnitToLocationDistance(bot, J.GetEnemyFountain()) > 600
			and not J.IsHaveAegis(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and enemyHero:GetUnitName() ~= 'npc_dota_hero_huskar'
			then
				local enemyHeroManaRegen = enemyHero:GetManaRegen()
				local nDamage = fDamageFactor * (enemyHero:GetMaxMana() - (enemyHero:GetMana() + enemyHeroManaRegen * nCastPoint))
				if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X