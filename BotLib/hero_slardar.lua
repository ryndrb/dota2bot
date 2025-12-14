local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_slardar'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_nullifier", "item_lotus_orb"}
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
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,3,3,3,1,6,1,1,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
				"item_circlet",
				"item_gauntlets",
			
				"item_bottle",
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_blink",
				"item_echo_sabre",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_harpoon",--
				"item_assault",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_echo_sabre",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_ultimate_scepter",
				"item_bottle", "item_assault",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
				"item_circlet",
				"item_gauntlets",
			
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_blink",
				"item_crimson_guard",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_ultimate_scepter",
				sUtilityItem,--
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_ultimate_scepter",
				"item_magic_wand", "item_ultimate_scepter",
				"item_bracer", sUtilityItem,
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

local GuardianSprint = bot:GetAbilityByName('slardar_sprint')
local SlithereenCrush = bot:GetAbilityByName('slardar_slithereen_crush')
local BashOfTheDeep = bot:GetAbilityByName('slardar_bash')
local CorrosiveHaze = bot:GetAbilityByName('slardar_amplify_damage')

local GuardianSprintDesire
local SlithereenCrushDesire
local CorrosiveHazeDesire, CorrosiveHazeTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	GuardianSprint = bot:GetAbilityByName('slardar_sprint')
	SlithereenCrush = bot:GetAbilityByName('slardar_slithereen_crush')
	CorrosiveHaze = bot:GetAbilityByName('slardar_amplify_damage')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	CorrosiveHazeDesire, CorrosiveHazeTarget = X.ConsiderCorrosiveHaze()
	if CorrosiveHazeDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(CorrosiveHaze, CorrosiveHazeTarget)
		return
	end

	SlithereenCrushDesire = X.ConsiderSlithereenCrush()
	if SlithereenCrushDesire > 0
	then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbility(SlithereenCrush)
		return
	end

	GuardianSprintDesire = X.ConsiderGuardianSprint()
	if GuardianSprintDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(GuardianSprint)
		return
	end
end

function X.ConsiderGuardianSprint()
	if not J.CanCastAbility(GuardianSprint) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaCost = GuardianSprint:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SlithereenCrush, CorrosiveHaze})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {GuardianSprint, SlithereenCrush, CorrosiveHaze})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 1600)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsInRange(bot, botTarget, 200)
		and J.IsRunning(bot)
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating( bot ) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) then
		if #nEnemyHeroes > 0 and J.IsRunning(bot) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
		and fManaAfter > fManaThreshold2 + 0.15
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
		and fManaAfter > fManaThreshold2 + 0.15
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSlithereenCrush()
	if not J.CanCastAbility(SlithereenCrush) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = SlithereenCrush:GetCastPoint()
	local nRadius = SlithereenCrush:GetSpecialValueInt('crush_radius')
	local nDamage = SlithereenCrush:GetSpecialValueInt('crush_damage')
	local nManaCost = SlithereenCrush:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SlithereenCrush, CorrosiveHaze})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {GuardianSprint, SlithereenCrush, CorrosiveHaze})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH
			end

			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius - 75)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				count = count + 1
			end
		end

		if count >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius - 75)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if enemyHero:GetAttackTarget() == bot or #nEnemyHeroes > #nAllyHeroes then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold2 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 4 or (#nEnemyCreeps >= 3 and fManaAfter > 0.65) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 4 or (#nEnemyCreeps >= 3 and fManaAfter > 0.65) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if fManaAfter > fManaThreshold2 and (#nEnemyHeroes == 0 or not J.IsRealInvisible(bot)) then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end

		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and botTarget:IsCreep()
		and not J.CanKillTarget(botTarget, nDamage * 1.5, DAMAGE_TYPE_PHYSICAL)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and bAttacking
		and fManaAfter > fManaThreshold2 + 0.15
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCorrosiveHaze()
	if not J.CanCastAbility(CorrosiveHaze) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, CorrosiveHaze:GetCastRange())
	local nManaCost = CorrosiveHaze:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {GuardianSprint, SlithereenCrush, CorrosiveHaze})

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetScore = 100000

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_slardar_amplify_damage')
			then
				local enemyHeroScore = math.sqrt(Max(enemyHero:GetArmor(), 0)) * (1 - J.GetHP(enemyHero))
				if (enemyHeroScore < hTargetScore) then
					hTargetScore = enemyHeroScore
					hTarget = enemyHero
				end
			end
		end

		if hTarget ~= nil then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_slardar_amplify_damage')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0)
	and #nAllyHeroes >= 2
	and fManaAfter > fManaThreshold1
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if enemyHero:GetAttackTarget() == bot or #nEnemyHeroes > #nAllyHeroes then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier( 'modifier_slardar_amplify_damage' )
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and not J.IsOtherAllysTarget(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
	    end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier( 'modifier_slardar_amplify_damage' )
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.15
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier( 'modifier_slardar_amplify_damage' )
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.15
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X