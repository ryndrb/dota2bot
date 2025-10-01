local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_medusa'
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
                [1] = {2,3,2,1,2,1,2,1,1,6,3,3,3,6,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_magic_stick",
				"item_double_mantle",

				"item_magic_wand",
				"item_double_null_talisman",
				"item_power_treads",
				"item_manta",--
				"item_butterfly",--
				"item_greater_crit",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_skadi",--
				"item_moon_shard",
				"item_disperser",--
				"item_ultimate_scepter_2",
				"item_bloodthorn",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_greater_crit",
				"item_null_talisman", "item_ultimate_scepter",
				"item_null_talisman", "item_skadi",
				"item_power_treads", "item_bloodthorn",
			},
        },
        [2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,1,2,1,1,6,3,3,3,6,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_magic_stick",
				"item_double_mantle",

				"item_magic_wand",
				"item_double_null_talisman",
				"item_power_treads",
				"item_maelstrom",
				"item_manta",--
				"item_mjollnir",--
				"item_devastator",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_bloodthorn",--
				"item_skadi",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_disperser",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_devastator",
				"item_null_talisman", "item_ultimate_scepter",
				"item_null_talisman", "item_bloodthorn",
				"item_power_treads", "item_disperser",
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
                [1] = {2,3,2,1,2,1,2,1,1,6,3,3,3,6,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_magic_stick",
				"item_double_mantle",

				"item_magic_wand",
				"item_double_null_talisman",
				"item_power_treads",
				"item_manta",--
				"item_butterfly",--
				"item_greater_crit",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_skadi",--
				"item_moon_shard",
				"item_disperser",--
				"item_ultimate_scepter_2",
				"item_bloodthorn",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_greater_crit",
				"item_null_talisman", "item_ultimate_scepter",
				"item_null_talisman", "item_skadi",
				"item_power_treads", "item_bloodthorn",
			},
        },
        [2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,1,2,1,1,6,3,3,3,6,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_magic_stick",
				"item_double_mantle",

				"item_magic_wand",
				"item_double_null_talisman",
				"item_power_treads",
				"item_maelstrom",
				"item_manta",--
				"item_mjollnir",--
				"item_devastator",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_bloodthorn",--
				"item_skadi",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_disperser",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_devastator",
				"item_null_talisman", "item_ultimate_scepter",
				"item_null_talisman", "item_bloodthorn",
				"item_power_treads", "item_disperser",
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

local SplitShot = bot:GetAbilityByName('medusa_split_shot')
local MysticSnake = bot:GetAbilityByName('medusa_mystic_snake')
-- local abilityE = bot:GetAbilityByName('medusa_mana_shield')
-- local abilityAS = bot:GetAbilityByName('medusa_cold_blooded')
local GorgonGrasp = bot:GetAbilityByName('medusa_gorgon_grasp')
local StoneGaze = bot:GetAbilityByName('medusa_stone_gaze')
local abilityM = nil

local SplitShotDesire
local MysticSnakeDesire, MysticSnakeTarget
local GorgonGraspDesire, GorgonGraspLocation
local StoneGazeDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	SplitShot = bot:GetAbilityByName('medusa_split_shot')
	MysticSnake = bot:GetAbilityByName('medusa_mystic_snake')
	GorgonGrasp = bot:GetAbilityByName('medusa_gorgon_grasp')
	StoneGaze = bot:GetAbilityByName('medusa_stone_gaze')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	MysticSnakeDesire, MysticSnakeTarget = X.ConsiderMysticSnake()
	if MysticSnakeDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbilityOnEntity(MysticSnake, MysticSnakeTarget)
		return
	end

	StoneGazeDesire = X.ConsiderStoneGaze()
	if StoneGazeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(StoneGaze)
		return
	end

	GorgonGraspDesire, GorgonGraspLocation = X.ConsiderGorgonGrasp()
	if GorgonGraspDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(GorgonGrasp, GorgonGraspLocation)
		return
	end

	SplitShotDesire = X.ConsiderSplitShot()
	if SplitShotDesire > 0 then
		bot:Action_UseAbility(SplitShot)
		return
	end
end

function X.ConsiderSplitShot()
	if not J.CanCastAbility(SplitShot) or bot:IsDisarmed() then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = bot:GetAttackRange() + 150
	local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	local nEnemyCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
	local bIsToggled = SplitShot:GetToggleState()

	if J.IsGoingOnSomeone(bot) then
		if #nInRangeEnemy >= 2 then
			return (not bIsToggled and BOT_ACTION_DESIRE_HIGH) or BOT_ACTION_DESIRE_NONE
		end
	end

	if J.IsPushing(bot) then
		if J.IsValid(botTarget) then
			if J.IsValidBuilding(botTarget) then
				return (bIsToggled and BOT_ACTION_DESIRE_HIGH) or BOT_ACTION_DESIRE_NONE
			end

			if botTarget:IsCreep() and #nEnemyCreeps >= 2 then
				return (not bIsToggled and BOT_ACTION_DESIRE_HIGH) or BOT_ACTION_DESIRE_NONE
			end
		end
	end

	if J.IsDefending(bot) then
		if J.IsValid(botTarget) then
			if (botTarget:IsCreep() and #nEnemyCreeps >= 2)
			or (#nInRangeEnemy >= 2)
			then
				return (not bIsToggled and BOT_ACTION_DESIRE_HIGH) or BOT_ACTION_DESIRE_NONE
			end
		end
	end

	if J.IsFarming(bot) then
		if J.IsValid(botTarget) then
			if (botTarget:IsCreep() and #nEnemyCreeps >= 2) then
				return (not bIsToggled and BOT_ACTION_DESIRE_HIGH) or BOT_ACTION_DESIRE_NONE
			end
		end
	end

	if J.IsValid(botTarget) then
		local nLocationAoE_heroes = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nCastRange, 0, 0)
		local nLocationAoE_creeps = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nCastRange, 0, 0)
		if (nLocationAoE_heroes.count + nLocationAoE_creeps.count) >= 2 then
			return (not bIsToggled and BOT_ACTION_DESIRE_HIGH) or BOT_ACTION_DESIRE_NONE
		end
	end

	if bIsToggled then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMysticSnake()
	if not J.CanCastAbility(MysticSnake) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, MysticSnake:GetCastRange())
	local nCastPoint = MysticSnake:GetCastPoint()
	local nRadius = MysticSnake:GetSpecialValueInt('radius')
	local nDamage = MysticSnake:GetSpecialValueInt('snake_damage')
	local nSpeed = MysticSnake:GetSpecialValueInt('initial_speed')
	local fManaSteal = MysticSnake:GetSpecialValueInt('snake_mana_steal') / 100
	local nManaCost = MysticSnake:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {GorgonGrasp, StoneGaze})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {MysticSnake, GorgonGrasp, StoneGaze})

	local fMissingMP = (1 - (bot:GetMana() / bot:GetMaxMana()))

	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) and fMissingMP >= fManaSteal then
		local hTarget = nil
		local hTargetScore = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			then
				local enemyHeroScore = enemyHero:GetMaxMana() * (1 - J.GetHP(enemyHero))
				if enemyHeroScore > hTargetScore then
					hTarget = enemyHero
					hTargetScore = enemyHeroScore
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fMissingMP >= fManaSteal
		and fManaAfter >= fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
				local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (J.GetMP(bot) < 0.5)
				or (#nInRangeEnemy >= 2 and fMissingMP >= fManaSteal)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
            end
        end
    end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and J.CanCastOnTargetAdvanced(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 4 and fMissingMP > fManaSteal)
				or (nLocationAoE.count >= 6)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and J.CanCastOnTargetAdvanced(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 4 and fMissingMP > fManaSteal)
				or (nLocationAoE.count >= 6)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			then
				local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count >= 3 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and J.CanCastOnTargetAdvanced(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 3 and fMissingMP > fManaSteal)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep() and fMissingMP > fManaSteal)
				or (nLocationAoE.count >= 4)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and J.CanCastOnTargetAdvanced(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
				if (nLocationAoE.count >= 5) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGorgonGrasp()
	if not J.CanCastAbility(GorgonGrasp) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, GorgonGrasp:GetCastRange())
	local nCastPoint = GorgonGrasp:GetCastPoint()
	local nRadius = GorgonGrasp:GetSpecialValueInt('radius')
	local nRadiusGrow = GorgonGrasp:GetSpecialValueInt('radius_grow')
	local nDelay = GorgonGrasp:GetSpecialValueInt('delay')
	local nDuration = GorgonGrasp:GetSpecialValueInt('duration')
	local nManaCost = GorgonGrasp:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {MysticSnake, StoneGaze})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {MysticSnake, GorgonGrasp, StoneGaze})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(bot, 'modifier_teleporting') > nDelay + nCastPoint then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if not J.IsChasingTarget(bot, botTarget)
			or J.IsInRange(bot, botTarget, nCastRange * 0.75)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and fManaAfter > fManaThreshold1
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
				end
			end
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
		for _, allyHero in pairs(nAllyHeroes) do
			if  J.IsValidHero(allyHero)
			and bot ~= allyHero
			and J.IsRetreating(allyHero)
			and allyHero:WasRecentlyDamagedByAnyHero(3.0)
			and not J.IsSuspiciousIllusion(allyHero)
			then
				for _, enemyHero in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
					and J.IsInRange(bot, enemyHero, nCastRange)
					and J.CanCastOnNonMagicImmune(enemyHero)
					and J.IsChasingTarget(enemyHero, allyHero)
					and not J.IsDisabled(enemyHero)
					and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
					then
						return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay + nCastPoint)
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderStoneGaze()
	if not J.CanCastAbility(StoneGaze) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = StoneGaze:GetSpecialValueInt('radius')
	local nAttackRange = bot:GetAttackRange()

	local bSomeoneFacingMe = false
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nAttackRange + 150)
	for _, enemyHero in pairs(nInRangeEnemy) do
		if J.IsValid(enemyHero) and enemyHero:IsFacingLocation(bot:GetLocation(), 20) then
			bSomeoneFacingMe = true
			break
		end
	end

	if not bSomeoneFacingMe then return BOT_ACTION_DESIRE_NONE, 0 end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and enemyHero:IsFacingLocation(bot:GetLocation(), 20)
			and botHP < 0.55
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and botTarget:IsFacingLocation(bot:GetLocation(), 45)
		and botHP < 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and enemyHero:IsFacingLocation(bot:GetLocation(), 45)
			then
				count = count + 1
				if count >= 2 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
