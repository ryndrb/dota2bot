local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_templar_assassin'
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
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,1,1,6,1,2,2,2,3,6,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_power_treads",
				"item_null_talisman",
				"item_desolator",--
				"item_dragon_lance",
				"item_blink",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_greater_crit",--
				"item_hurricane_pike",--
				"item_swift_blink",--
				"item_moon_shard",
				"item_sheepstick",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blink",
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_greater_crit",
				"item_power_treads", "item_sheepstick",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,1,1,6,1,2,2,2,3,6,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_quelling_blade",
			
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_null_talisman",
				"item_desolator",--
				"item_dragon_lance",
				"item_blink",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_greater_crit",--
				"item_hurricane_pike",--
				"item_swift_blink",--
				"item_moon_shard",
				"item_sheepstick",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_dragon_lance",
				"item_magic_wand", "item_blink",
				"item_null_talisman", "item_black_king_bar",
				"item_bottle", "item_greater_crit",
				"item_power_treads", "item_sheepstick",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_TA' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	if Minion.IsValidUnit(hMinionUnit) then
		if hMinionUnit:GetUnitName() ~= 'npc_dota_templar_assassin_psionic_trap' then
			Minion.IllusionThink(hMinionUnit)
			return
		else
			local Trap = hMinionUnit:GetAbilityByName('templar_assassin_self_trap')
			local nRadius = 400
			local nInRangeAlly = J.GetAlliesNearLoc(hMinionUnit:GetLocation(), 800)
			local nInRangeEnemy = J.GetEnemiesNearLoc(hMinionUnit:GetLocation(), nRadius - 50)
			local nEnemyLaneCreeps = hMinionUnit:GetNearbyLaneCreeps(nRadius - 50, true)
			local nEnemyHeroes = hMinionUnit:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			local distance = GetUnitToUnitDistance(bot, hMinionUnit)

			if not bot:IsAlive() then distance = 99999 end

			if Trap and Trap:IsFullyCastable() then
				if  (#nInRangeEnemy >= 1)
				and (distance < 1200 or #nInRangeAlly >= 1 or X.IsEnemyRegenning(nInRangeEnemy))
				then
					hMinionUnit:Action_UseAbility(Trap)
					return
				end

				if J.IsValidHero(nInRangeEnemy[1]) and nInRangeEnemy[1]:GetAttackTarget() == hMinionUnit then
					hMinionUnit:Action_UseAbility(Trap)
					return
				end

				if #nEnemyLaneCreeps >= 4 and #nInRangeAlly == 0 then
					for _, creep in pairs(nEnemyLaneCreeps) do
						if  J.IsValid(creep)
						and J.CanBeAttacked(creep)
						and J.CanCastOnNonMagicImmune(creep)
						and not string.find(creep:GetUnitName(), 'ranged')
						then
							hMinionUnit:Action_UseAbility(Trap)
							return
						end
					end
				end

				local incomingProjectiles = hMinionUnit:GetIncomingTrackingProjectiles()
				for _, p in pairs(incomingProjectiles) do
					if  p and p.is_attack
					and GetUnitToLocationDistance(hMinionUnit, p.location) < nRadius
					then
						hMinionUnit:Action_UseAbility(Trap)
						return
					end
				end
			end
		end
	end
end

end

local Refraction = bot:GetAbilityByName('templar_assassin_refraction')
local Meld = bot:GetAbilityByName('templar_assassin_meld')
local PsiBlades = bot:GetAbilityByName('templar_assassin_psi_blades')
local Trap = bot:GetAbilityByName('templar_assassin_trap')
local PsionicProjection = bot:GetAbilityByName('templar_assassin_trap_teleport')
local PsionicTrap = bot:GetAbilityByName('templar_assassin_psionic_trap')

local RefractionDesire
local MeldDesire
local PsionicProjectionDesire, PsionicProjectionLocation
local PsionicTrapDesire, PsionicTrapLocation

local tRuneLocations = {}
local tCampLocations = {}
local tTraps = {}
local tRunes = {
	RUNE_BOUNTY_1,
	RUNE_BOUNTY_2,
	RUNE_POWERUP_1,
	RUNE_POWERUP_2
}

local trapLocationCheckTime = 0

local bAttacking = false
local botTarget, botHP, botAttackRange
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot)
	or bot:HasModifier('modifier_templar_assassin_meld')
	then
		return
	end

	Refraction = bot:GetAbilityByName('templar_assassin_refraction')
	Meld = bot:GetAbilityByName('templar_assassin_meld')
	Trap = bot:GetAbilityByName('templar_assassin_trap')
	PsionicProjection = bot:GetAbilityByName('templar_assassin_trap_teleport')
	PsionicTrap = bot:GetAbilityByName('templar_assassin_psionic_trap')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
	botAttackRange =  bot:GetAttackRange()
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	PsionicTrapDesire, PsionicTrapLocation = X.ConsiderPsionicTrap()
	if PsionicTrapDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(PsionicTrap, PsionicTrapLocation)
		return
	end

	RefractionDesire = X.ConsiderRefraction()
	if RefractionDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Refraction)
		return
	end

	MeldDesire = X.ConsiderMeld()
	if MeldDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Meld)
		return
	end

	PsionicProjectionDesire, PsionicProjectionLocation = X.ConsiderPsionicProjection()
	if PsionicProjectionDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(PsionicProjection, PsionicProjectionLocation)
	end
end

function X.ConsiderRefraction()
	if not J.CanCastAbility(Refraction)
	or bot:HasModifier('modifier_templar_assassin_refraction_absorb')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nBonusDamage = Refraction:GetSpecialValueInt('bonus_damage')
	local nDamage = bot:GetAttackDamage() + nBonusDamage
	local nManaCost = Refraction:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Meld, PsionicProjection, PsionicTrap})

	if not J.IsRealInvisible(bot) then
		if botHP < 0.8 then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and bot:WasRecentlyDamagedByHero(enemyHero, 1.0)
				and enemyHero:GetAttackTarget() == bot
				and not J.IsSuspiciousIllusion(enemyHero)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if botHP < 0.15  then
			if bot:WasRecentlyDamagedByAnyHero(4.0)
			or bot:WasRecentlyDamagedByCreep(2.0)
			or bot:WasRecentlyDamagedByTower(2.0)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsNotAttackProjectileIncoming(bot, 1600)
		or J.GetAttackProjectileDamageByRange(bot, 1600) >= 110
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if (bot:HasModifier('modifier_rune_regen'))
		or (bot:HasModifier('modifier_fountain_aura_buff') and fManaAfter > 0.8)
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if not J.IsEarlyGame() and fManaAfter > fManaThreshold1 then
			local nInRangeEnemy = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)
			local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
			local nEnemyTowers = bot:GetNearbyTowers(1600, true)

			if #nInRangeEnemy > 0
			or #nEnemyLaneCreeps > 1
			or #nEnemyTowers > 0
			or (J.IsInEnemyArea(bot) and fManaAfter > 0.8)
			then
				return  BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 2000)
		then
			if #nEnemyHeroes >= 2 or not J.IsSuspiciousIllusion(botTarget) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsDisabled(enemyHero)
			and enemyHero:GetAttackTarget() == bot
			then
				if bot:WasRecentlyDamagedByAnyHero(2.0) or botHP < 0.25 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) and fManaAfter > fManaThreshold1 then
		local mostHealthCreep = J.GetMostHpUnit(nEnemyCreeps)
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and J.IsValid(mostHealthCreep) then
			if (#nEnemyCreeps >= 4 and #nEnemyHeroes > 0)
			or (#nEnemyCreeps >= 5)
			or (botHP < 0.2)
			or (not J.CanKillTarget(mostHealthCreep, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 then
		local mostHealthCreep = J.GetMostHpUnit(nEnemyCreeps)
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and J.IsValid(mostHealthCreep) then
			if (#nEnemyCreeps >= 4 and #nEnemyHeroes > 0)
			or (#nEnemyCreeps >= 3)
			or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			or (botHP < 0.2)
			or (not J.CanKillTarget(mostHealthCreep, nDamage * 4, DAMAGE_TYPE_PHYSICAL))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(800, true)
		if #nEnemyLaneCreeps >= 4 then
			for _, creep in pairs(nEnemyLaneCreeps) do
				if J.IsValid(creep)
				and J.CanBeAttacked(creep)
				and J.IsInRange(bot, creep, botAttackRange + 300)
				and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PHYSICAL)
		and not J.CanKillTarget(botTarget, nDamage - nBonusDamage, DAMAGE_TYPE_PHYSICAL)
		and botTarget:IsCreep()
		then
			local sTargetName = botTarget:GetUnitName()
			if string.find(sTargetName, 'ranged')
			or string.find(sTargetName, 'siege')
			or string.find(sTargetName, 'flagbearer')
			then
				local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, 600, 0, 0)
				if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(botTarget, false) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and J.GetHP(botTarget) > 0.3
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange + 150)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMeld()
	if not J.CanCastAbility(Meld)
	or J.IsRunning(bot)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nBonusDamage = Meld:GetSpecialValueInt('bonus_damage')
	local nDamage = bot:GetAttackDamage() + nBonusDamage
	local nManaCost = Meld:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Refraction, PsionicProjection, PsionicTrap})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Refraction, Meld, PsionicProjection, PsionicTrap})

	if not J.IsRealInvisible(bot) then
		local nIncomingProjectileDamage = J.GetAttackProjectileDamageByRange(bot, 1600)
		if (nIncomingProjectileDamage > bot:GetHealth() * 0.4)
		or (bot:IsDisarmed() and not J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(4.0))
		or (bot:IsRooted())
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + botTarget:GetBoundingRadius())
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			if not J.IsChasingTarget(bot, botTarget) or J.IsInRange(bot, botTarget, botAttackRange / 2) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if  (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot))
	and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0
	then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + botTarget:GetBoundingRadius())
		and not botTarget:IsBuilding()
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
		and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + botTarget:GetBoundingRadius())
		and botTarget:IsCreep()
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
		and J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PHYSICAL)
		then
			local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, 600, 0, 0)
			if (string.find(botTarget:GetUnitName(), 'ranged') and nLocationAoE.count > 0)
			or J.IsUnitTargetedByTower(botTarget, false)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + botTarget:GetBoundingRadius())
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_LOW
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange + botTarget:GetBoundingRadius())
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not J.IsEarlyGame() and bAttacking and fManaAfter > fManaThreshold2 then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + botTarget:GetBoundingRadius())
		and not botTarget:IsBuilding()
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3.5, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTrap()
	if not J.CanCastAbility(Trap)
	or PsionicTrap == nil
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = PsionicTrap:GetSpecialValueInt('trap_radius')

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPsionicProjection()
	if not J.CanCastAbility(PsionicProjection) then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nManaCost = PsionicProjection:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Refraction, Meld})

	tTraps = {}
	local unitList = GetUnitList(UNIT_LIST_ALLIES)
	for _, unit in pairs(unitList) do
		if J.IsValid(unit) and unit:GetUnitName() == 'npc_dota_templar_assassin_psionic_trap' then
			table.insert(tTraps, unit)
		end
	end

	local vTeamFightLocation = J.GetTeamFightLocation(bot)
	if  vTeamFightLocation
	and GetUnitToLocationDistance(bot, vTeamFightLocation) > 2000
	and bot:GetNetWorth() >= 15000
	and botHP > 0.75
	and not J.IsRetreating(bot)
	then
		local trap = X.GetClosestTrapToLocation(vTeamFightLocation)
		if trap and GetUnitToLocationDistance(trap, vTeamFightLocation) <= 1200 then
			return BOT_ACTION_DESIRE_HIGH, trap
		end
	end

	if J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsDisabled(enemyHero)
			and enemyHero:GetAttackTarget() == bot
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.5 and (J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 3.0) > bot:GetHealth() * 1.15 or not bot:WasRecentlyDamagedByAnyHero(2.0)))
				then
					local trap = X.GetClosestTrapToLocation(J.GetTeamFountain())
					if trap then
						local nInRangeEnemy = J.GetEnemiesNearLoc(trap:GetLocation(), 1600)
						if #nInRangeEnemy == 0 then
							return BOT_ACTION_DESIRE_HIGH, trap
						end
					end
				end
			end
		end
	end

	if not bot:WasRecentlyDamagedByAnyHero(5.0) then
		if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 then
			local nLane = LANE_MID
			if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
			if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

			local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 then
				local trap = X.GetClosestTrapToLocation(vLaneFrontLocation)
				if trap and GetUnitToLocationDistance(trap, vLaneFrontLocation) <= 1600 then
					return BOT_ACTION_DESIRE_HIGH, trap
				end
			end
		end

		if J.IsDefending(bot) and not bAttacking then
			local nLane = LANE_MID
			if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
			if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

			local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 then
				local trap = X.GetClosestTrapToLocation(vLaneFrontLocation)
				if trap and GetUnitToLocationDistance(trap, vLaneFrontLocation) <= 1600 then
					return BOT_ACTION_DESIRE_HIGH, trap
				end
			end
		end

		if J.IsDoingRoshan(bot) then
			local vRoshanLocation = J.GetCurrentRoshanLocation()
			if GetUnitToLocationDistance(bot, vRoshanLocation) > 3200 then
				local trap = X.GetClosestTrapToLocation(vRoshanLocation)
				if trap and GetUnitToLocationDistance(trap, vRoshanLocation) <= 1600 then
					return BOT_ACTION_DESIRE_HIGH, trap
				end
			end
		end

		if J.IsDoingTormentor(bot) then
			local vTormentorLocation = J.GetTormentorLocation(GetTeam())
			if GetUnitToLocationDistance(bot, vTormentorLocation) > 3200 then
				local trap = X.GetClosestTrapToLocation(vTormentorLocation)
				if trap and GetUnitToLocationDistance(trap, vTormentorLocation) <= 1600 then
					return BOT_ACTION_DESIRE_HIGH, trap
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderPsionicTrap()
	if not J.CanCastAbility(PsionicTrap) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if #tRuneLocations == 0 then
		for i, rune in pairs(tRunes) do
			tRuneLocations[i] = GetRuneSpawnLocation(rune)
		end
	end

	if #tCampLocations == 0 then
		local camps = GetNeutralSpawners()
		for i, camp in pairs(camps) do
			if  camp.team == GetTeam()
			and camp.type ~= 'small'
			and camp.type ~= 'medium'
			then
				tCampLocations[i] = camp
			end
		end
	end

	local nCastRange = PsionicTrap:GetCastRange()
	local nCastPoint = PsionicTrap:GetCastPoint()
	local nRadius = PsionicTrap:GetSpecialValueInt('trap_radius')
	local nManaCost = PsionicTrap:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {RefractionDesire, Meld, PsionicProjection, PsionicTrap})

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for i = 1, 5 do
			local member = GetTeamMember(i)
			if J.IsValidHero(member)
			and J.IsGoingOnSomeone(member)
			then
				local memberTarget = J.GetProperTarget(member)
				if J.IsValidHero(memberTarget)
				and J.CanBeAttacked(memberTarget)
				and J.IsRunning(memberTarget)
				and J.IsInRange(bot, memberTarget, nCastRange)
				and not J.IsInRange(bot, memberTarget, bot:GetAttackRange())
				and GetUnitToLocationDistance(memberTarget, J.GetEnemyFountain()) > 800
				and J.CanCastOnNonMagicImmune(memberTarget)
				then
					local vLocation = J.GetCorrectLoc(memberTarget, nCastPoint)
					if  GetUnitToLocationDistance(bot, vLocation) <= nCastRange
					and not X.IsThereTrapInLocation(vLocation, nRadius)
					then
						return BOT_ACTION_DESIRE_HIGH, vLocation
					end
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			and not J.IsInRange(bot, enemyHero, enemyHero:GetAttackRange() + 200)
			and not X.IsThereTrapInLocation(enemyHero:GetLocation(), nRadius)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if  DotaTime() > trapLocationCheckTime + 1.0
	and #nEnemyHeroes == 0
	and not bot:WasRecentlyDamagedByAnyHero(3.0)
	and not J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and fManaAfter > 0.4
	then
		for _, location in pairs(tRuneLocations) do
			if GetUnitToLocationDistance(bot, location) < nCastRange then
				if not IsLocationVisible(location) and not X.IsThereTrapInLocation(location, nRadius) then
					return BOT_ACTION_DESIRE_HIGH, location
				end
			end
		end

		if not J.IsEarlyGame() then
			for _, camp in pairs(tCampLocations) do
				if  GetUnitToLocationDistance(bot, camp.location) < nCastRange
				and not X.IsThereTrapInLocation(camp.location, nRadius)
				and not IsLocationVisible(camp.location)
				then
					return BOT_ACTION_DESIRE_HIGH, camp.location
				end
			end
		end

		local vLocation = bot:GetLocation() + RandomVector(nCastRange)
		if IsLocationPassable(vLocation) and not X.IsThereTrapInLocation(vLocation, nCastRange + nCastRange / 2) then
			return BOT_ACTION_DESIRE_HIGH, vLocation
		end

		trapLocationCheckTime = DotaTime()
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsThereTrapInLocation(vLocation, nRadius)
	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if  J.IsValid(unit)
		and unit:GetUnitName() == 'npc_dota_templar_assassin_psionic_trap'
		and GetUnitToLocationDistance(unit, vLocation) <= nRadius
		then
			return true
		end
	end

	return false
end

function X.GetClosestTrapToLocation(vLocation)
	local bestTrap = nil
	local bestTrapDistance = math.huge

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if J.IsValid(unit) and unit:GetUnitName() == 'npc_dota_templar_assassin_psionic_trap' then
			local dist = GetUnitToLocationDistance(unit, vLocation)
			if dist < bestTrapDistance then
				bestTrap = unit
				bestTrapDistance = dist
			end
		end
	end

	return bestTrap
end

function X.IsEnemyRegenning(hEnemyHeroList)
	for _, enemy in pairs(hEnemyHeroList) do
		if  J.IsValidHero(enemy)
		and J.IsSuspiciousIllusion(enemy)
		and (  enemy:HasModifier('modifier_clarity_potion')
			or enemy:HasModifier('modifier_bottle_regeneration')
			or enemy:HasModifier('modifier_rune_regen')
			or enemy:HasModifier('modifier_item_urn_heal')
			or enemy:HasModifier('modifier_item_spirit_vessel_heal'))
		then
			return true
		end
	end

	return false
end

return X
