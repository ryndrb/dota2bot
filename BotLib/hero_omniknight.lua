local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_omniknight'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_heavens_halberd", "item_lotus_orb"}
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
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {3,1,3,1,3,1,1,3,2,6,6,2,2,2,6},
				[2] = {3,2,3,1,3,6,3,2,2,2,1,1,1,6,6},
				[3] = {3,1,1,3,2,6,1,3,3,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_bottle",
				"item_magic_wand",
				"item_boots",
				"item_double_bracer",
				"item_radiance",--
				"item_phase_boots",
				"item_harpoon",--
				"item_aghanims_shard",
				"item_sange_and_yasha",--
				"item_bloodthorn",--
				"item_nullifier",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_radiance",
				"item_magic_wand", "item_harpoon",
				"item_bracer", "item_sange_and_yasha",
				"item_bracer", "item_bloodthorn",
				"item_bottle", "item_nullifier",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {3,1,3,1,3,1,3,1,6,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_magic_wand",
				"item_double_bracer",
				"item_phase_boots",
				"item_crimson_guard",--
				"item_blink",
				"item_aghanims_shard",
				"item_black_king_bar",--
				sUtilityItem,--
				"item_shivas_guard",--
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blink",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", sUtilityItem,
				"item_bracer", "item_shivas_guard",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_magic_stick",
				"item_double_branches",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_solar_crest",--
				"item_ancient_janggo",
				"item_glimmer_cape",--
				"item_blink",
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_sheepstick",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_octarine_core",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_magic_stick",
				"item_double_branches",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_solar_crest",--
				"item_mekansm",
				"item_glimmer_cape",--
				"item_blink",
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_sheepstick",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_octarine_core",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

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

local Purification = bot:GetAbilityByName('omniknight_purification')
local Repel = bot:GetAbilityByName('omniknight_martyr')
local HammerOfPurity = bot:GetAbilityByName('omniknight_hammer_of_purity')
local GuardianAngel = bot:GetAbilityByName('omniknight_guardian_angel')

local PurificationDesire, PurificationTarget
local RepelDesire, RepelTarget
local HammerOfPurityDesire, HammerOfPurityTarget
local GuardianAngelDesire, GuardianAngelLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Purification = bot:GetAbilityByName('omniknight_purification')
	Repel = bot:GetAbilityByName('omniknight_martyr')
	HammerOfPurity = bot:GetAbilityByName('omniknight_hammer_of_purity')
	GuardianAngel = bot:GetAbilityByName('omniknight_guardian_angel')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	GuardianAngelDesire, GuardianAngelLocation = X.ConsiderGuardianAngel()
	if GuardianAngelDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(GuardianAngel, GuardianAngelLocation)
		return
	end

	PurificationDesire, PurificationTarget = X.ConsiderPurification()
	if PurificationDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Purification, PurificationTarget)
		return
	end

	RepelDesire, RepelTarget = X.ConsiderRepel()
	if RepelDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Repel, RepelTarget)
		return
	end

	HammerOfPurityDesire, HammerOfPurityTarget = X.ConsiderHammerOfPurity()
	if HammerOfPurityDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:Action_UseAbilityOnEntity(HammerOfPurity, HammerOfPurityTarget)
		return
	end
end

function X.ConsiderPurification()
	if not J.CanCastAbility(Purification) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Purification:GetCastRange())
	local nRadius = Purification:GetSpecialValueInt('radius')
	local nDamage = Purification:GetSpecialValueInt('heal')
	local nManaCost = Purification:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Repel, GuardianAngel})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Purification, Repel, GuardianAngel})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
		and not enemyHero:IsMagicImmune()
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local hBestTarget = nil
			local hBestTargetHP = 1

			for _, allyHero in pairs(nAllyHeroes) do
				if J.IsValidHero(allyHero)
				and J.IsInRange(bot, allyHero, nCastRange + 150)
				and J.IsInRange(allyHero, enemyHero, nRadius)
				and not J.IsSuspiciousIllusion(allyHero)
				then
					local allyHeroHP = J.GetHP(allyHero)
					if allyHeroHP < hBestTargetHP then
						hBestTarget = allyHero
						hBestTargetHP = allyHeroHP
					end
				end
			end

			if hBestTarget == nil then
				hBestTargetHP = 1
				local nAllyCreeps = bot:GetNearbyCreeps(nCastRange, false)
				for _, creep in pairs(nAllyCreeps) do
					if J.IsValid(creep) and J.IsInRange(creep, enemyHero, nRadius) then
						local creepHP = J.GetHP(creep)
						if creepHP < hBestTargetHP then
							hBestTarget = creep
							hBestTargetHP = creepHP
						end
					end
				end
			end

			if hBestTarget ~= nil then
				return BOT_ACTION_DESIRE_HIGH, hBestTarget
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		local hBestTarget = nil
		local hBestTargetAoECount = 0
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and not J.IsSuspiciousIllusion(allyHero)
			and allyHero:GetMaxHealth() - allyHero:GetHealth() > nDamage + 50
			then
				local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), nRadius)
				if hBestTargetAoECount < #nInRangeEnemy then
					hBestTarget = allyHero
					hBestTargetAoECount = #nInRangeEnemy
				end
			end
		end

		if hBestTarget ~= nil then
			local nInRangeEnemy = J.GetEnemiesNearLoc(hBestTarget:GetLocation(), nRadius)
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and not enemyHero:IsMagicImmune()
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					if fManaAfter > fManaThreshold1 or J.GetHP(hBestTarget) < 0.3 then
						return BOT_ACTION_DESIRE_HIGH, hBestTarget
					end
				end
			end
		end

		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and (bot:GetMaxHealth() - bot:GetHealth() > nDamage or botHP < 0.3)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			if (not botTarget:HasModifier('modifier_abaddon_borrowed_time')
				and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
				and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				and not botTarget:HasModifier('modifier_oracle_false_promise_timer'))
			or (botHP < 0.5 and #J.GetHeroesTargetingUnit(nEnemyHeroes, bot) >= 2)
			then
				if fManaAfter > fManaThreshold1 or botHP < 0.3 then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not enemyHero:IsMagicImmune()
			and not J.IsSuspiciousIllusion(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and bot:GetMaxHealth() - bot:GetHealth() > nDamage
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or botHP < 0.3
				then
					return BOT_ACTION_DESIRE_HIGH, bot
				end
			end
		end

		if fManaAfter > fManaThreshold1 then
			local hBestTarget = nil
			local hBestTargetAoECount = 0
			for _, allyHero in pairs(nAllyHeroes) do
				if J.IsValidHero(allyHero)
				and J.IsInRange(bot, allyHero, nCastRange)
				and J.IsRetreating(allyHero)
				and allyHero:WasRecentlyDamagedByAnyHero(3.0)
				and not J.IsSuspiciousIllusion(allyHero)
				and J.GetHP(allyHero) < 0.5
				and (botHP > 0.5 or not J.IsCore(bot))
				then
					local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), nRadius)
					if hBestTargetAoECount < #nInRangeEnemy then
						hBestTarget = allyHero
						hBestTargetAoECount = #nInRangeEnemy
					end
				end
			end

			if hBestTarget ~= nil then
				local nInRangeEnemy = J.GetEnemiesNearLoc(hBestTarget:GetLocation(), nRadius)
				for _, enemyHero in pairs(nInRangeEnemy) do
					if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
					and not enemyHero:IsMagicImmune()
					and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
					and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
					then
						return BOT_ACTION_DESIRE_HIGH, hBestTarget
					end
				end
			end
		end
	end

	for i = 1, 5 do
		local member = GetTeamMember(i)
		if J.IsValidHero(member)
		and J.CanBeAttacked(member)
		and J.IsInRange(bot, member, nCastRange)
		and not member:HasModifier('modifier_necrolyte_reapers_scythe')
		and not member:HasModifier('modifier_fountain_aura_buff')
		then
			if fManaAfter > fManaThreshold1 and (J.GetHP(member) < 0.15 or (J.GetHP(member) < 0.3 and member:WasRecentlyDamagedByAnyHero(3.0))) then
				return BOT_ACTION_DESIRE_HIGH, member
			end

			if fManaAfter > fManaThreshold2 + 0.1 and J.GetHP(member) < 0.5 then
				return BOT_ACTION_DESIRE_HIGH, member
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		if fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(1000)) then
			local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
			if nLocationAoE.count >= 3 or (nLocationAoE.count >= 2 and #nInRangeEnemy > 0) then
				return BOT_ACTION_DESIRE_HIGH, bot
			end

			local nAllyCreeps = bot:GetNearbyCreeps(nCastRange + 300, false)
			for _, creep in pairs(nAllyCreeps) do
				if J.IsValid(creep) then
					nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)
					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if nLocationAoE.count >= 3 or (nLocationAoE.count >= 2 and #nInRangeEnemy > 0) then
						return BOT_ACTION_DESIRE_HIGH, bot
					end
				end
			end
		end

		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and not J.IsSuspiciousIllusion(allyHero)
			and J.GetHP(allyHero) < 0.5
			then
				for _, enemyHero in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
					and J.IsInRange(bot, enemyHero, nRadius - 50)
					and not J.IsSuspiciousIllusion(enemyHero)
					and not enemyHero:IsMagicImmune()
					and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
					and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
					then
						if fManaAfter > fManaThreshold2 then
							return BOT_ACTION_DESIRE_HIGH, allyHero
						end
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot)
	and fManaAfter > fManaThreshold2
	and #nAllyHeroes <= 3
	and bAttacking
	then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 4 or ((#nEnemyCreeps >= 3 and fManaAfter > 0.65) or (#nEnemyCreeps >= 3 and fManaAfter > fManaThreshold1)) then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end

		local nAllyCreeps = bot:GetNearbyCreeps(nCastRange, false)
		for _, creep in pairs(nAllyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local nLocationAoE1 = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				local nLocationAoE2 = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
				if nLocationAoE1.count >= 4 or ((nLocationAoE1.count >= 3 and fManaAfter > 0.65) or (nLocationAoE2.count >= 3 and fManaAfter > fManaThreshold1)) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and botHP < 0.9 then
		nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 4 or ((#nEnemyCreeps >= 3 and fManaAfter > 0.65) or (nLocationAoE.count >= 3 and fManaAfter > fManaThreshold1)) then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end

		local nAllyCreeps = bot:GetNearbyCreeps(nCastRange, false)
		for _, creep in pairs(nAllyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local nLocationAoE1 = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				local nLocationAoE2 = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
				if nLocationAoE1.count >= 4 or ((nLocationAoE1.count >= 3 and fManaAfter > 0.65) or (nLocationAoE2.count >= 3 and fManaAfter > fManaThreshold1)) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end

		nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, nDamage)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking and botHP < 0.85 then
		nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and fManaAfter > fManaThreshold1
		then
			for _, allyHero in pairs(nAllyHeroes) do
				if J.IsValidHero(allyHero)
				and J.CanBeAttacked(allyHero)
				and J.GetHP(allyHero) < 0.5
				and not J.IsSuspiciousIllusion(allyHero)
				and J.IsRoshan(allyHero:GetAttackTarget())
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and fManaAfter > fManaThreshold1
		then
			for _, allyHero in pairs(nAllyHeroes) do
				if J.IsValidHero(allyHero)
				and J.GetHP(allyHero) < 0.5
				and not J.IsSuspiciousIllusion(allyHero)
				and J.IsTormentor(allyHero:GetAttackTarget())
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderRepel()
	if not J.CanCastAbility(Repel) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Repel:GetCastRange())
	local nDuration = Repel:GetSpecialValueInt('duration')
	local nHealHealth = Repel:GetSpecialValueInt('hp_regen') * nDuration
	local nManaCost = Repel:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Purification, GuardianAngel})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Purification, Repel, GuardianAngel})

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 300)
		and not allyHero:IsMagicImmune()
		and not allyHero:HasModifier('modifier_omniknight_repel')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nEnemyHeroesAttackingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)

			if J.IsGoingOnSomeone(allyHero) then
				local allyHeroTarget = J.GetProperTarget(allyHero)

				if J.IsValidHero(allyHeroTarget)
				and J.IsInRange(allyHero, allyHeroTarget, allyHeroTarget:GetAttackRange() + 150)
				and allyHeroTarget:IsFacingLocation(allyHeroTarget:GetLocation(), 45)
				and (allyHero:WasRecentlyDamagedByAnyHero(3.0) or #nEnemyHeroesAttackingAlly > 0)
				then
					if fManaAfter > fManaThreshold1 then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end
			end

			if J.IsRetreating(allyHero)
			and not J.IsRealInvisible(allyHero)
			and not J.IsRealInvisible(bot)
			and not allyHero:HasModifier('modifier_fountain_aura_buff')
			and allyHero:GetMaxHealth() - allyHero:GetHealth() >= nHealHealth
			and allyHero:WasRecentlyDamagedByAnyHero(3.0)
			then
				if #nEnemyHeroes > 0 or fManaAfter > fManaThreshold1 then
					return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
				end
			end

			if (J.IsCore(allyHero) or fManaAfter > fManaThreshold1)
			and allyHero:GetLevel() >= 6
			and allyHero:GetMaxHealth() - allyHero:GetHealth() >= nHealHealth
			then
				local allyHeroTarget = allyHero:GetAttackTarget()
				if J.IsValidHero(allyHeroTarget) and not J.IsSuspiciousIllusion(allyHeroTarget) and #nEnemyHeroesAttackingAlly >= 1 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if J.IsDisabled(allyHero)
			and allyHero:WasRecentlyDamagedByAnyHero(3.0)
			and #nEnemyHeroesAttackingAlly >= 1
			and (fManaAfter > fManaThreshold2 or J.IsInTeamFight(bot, 1200))
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.GetHP(allyHero) < 0.5
			and ((allyHero:WasRecentlyDamagedByAnyHero(5.0) and #nEnemyHeroesAttackingAlly > 0) or J.GetHP(allyHero) < 0.25)
			and not allyHero:HasModifier('modifier_fountain_aura_buff')
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderHammerOfPurity()
	if not J.CanCastAbility(HammerOfPurity) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, HammerOfPurity:GetCastRange())
	local nCastPoint = HammerOfPurity:GetCastPoint()
	local nBaseDamage = HammerOfPurity:GetSpecialValueInt('base_damage')
	local fDamageFactor = 1.55 + (HammerOfPurity:GetLevel() - 1) * 0.15
	local nDamage = nBaseDamage + (bot:GetAttackDamage() * fDamageFactor)
	local nManaCost = HammerOfPurity:GetManaCost()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed()) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE, eta) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsDefending(bot) and bAttacking then
		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange * 2)
		and string.find(botTarget:GetUnitName(), 'siege')
		and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PURE)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if (J.IsPushing(bot) or J.IsFarming(bot)) and bAttacking then
		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange * 2)
		and botTarget:IsCreep()
		and not J.IsOtherAllysTarget(botTarget)
		and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PURE)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange * 2, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and string.find(creep:GetUnitName(), 'range')
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / bot:GetCurrentMovementSpeed()) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PURE, eta) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnTargetAdvanced(botTarget)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGuardianAngel()
	if not J.CanCastAbility(GuardianAngel) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, GuardianAngel:GetCastRange())
	local nRadius = GuardianAngel:GetSpecialValueInt( 'radius' )

	for i = 1, 5 do
		local allyHero = GetTeamMember(i)
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and (bot:HasScepter() or J.IsInRange(bot, allyHero, nCastRange + 300))
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.IsInTeamFight(allyHero, 1600) then
				local nInRangeAlly = J.GetAlliesNearLoc(allyHero:GetLocation(), nRadius)
				local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)
				if #nInRangeEnemy >= 2 and (#nInRangeEnemy >= #nInRangeAlly or #nInRangeEnemy >= 3) then
					local count = 0
					for _, aAllyHero in pairs(nInRangeAlly) do
						if J.IsValidHero(aAllyHero)
						and J.CanBeAttacked(aAllyHero)
						and aAllyHero:WasRecentlyDamagedByAnyHero(5.0)
						and not aAllyHero:HasModifier('modifier_necrolyte_reapers_scythe')
						then
							count = count + 1
							if J.GetHP(aAllyHero) < 0.4 then
								count = count + 1
							end
						end
					end

					if count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
					end
				end
			end

			if J.IsRetreating(allyHero)
			and not J.IsRealInvisible(allyHero)
			and allyHero:WasRecentlyDamagedByAnyHero(5.0)
			then
				local nInRangeAlly_Attack = allyHero:GetNearbyHeroes(nRadius, false, BOT_MODE_ATTACK)
				local nInRangeAlly_Retreat = allyHero:GetNearbyHeroes(nRadius, false, BOT_MODE_RETREAT)
				local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)
				local nEnemyHeroesTargetingAllyHero = J.GetHeroesTargetingUnit(nInRangeEnemy, allyHero)
				if (#nInRangeAlly_Attack >= 2 or (#nInRangeAlly_Attack >= 1 and #nInRangeAlly_Retreat >= 2)) and #nEnemyHeroesTargetingAllyHero > 0 then
					return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and botTarget:IsFacingLocation(bot:GetLocation(), 60)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:IsDisarmed()
		and botTarget:GetAttackTarget() == bot
		and botHP < (#nEnemyHeroes >= 3 and 0.65 or 0.45)
		and bot:WasRecentlyDamagedByAnyHero(3.0)
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X