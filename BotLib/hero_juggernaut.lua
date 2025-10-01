local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_juggernaut'
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
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_maelstrom",
				"item_manta",--
				"item_mjollnir",--
				"item_ultimate_scepter",
				"item_butterfly",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_skadi",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_monkey_king_bar",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_magic_wand", "item_butterfly",
				"item_wraith_band", "item_abyssal_blade",
				"item_phase_boots", "item_monkey_king_bar",
			},
        },
        [2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_bfury",--
				"item_manta",--
				"item_ultimate_scepter",
				"item_butterfly",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_skadi",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_monkey_king_bar",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_butterfly",
				"item_wraith_band", "item_abyssal_blade",
				"item_phase_boots", "item_monkey_king_bar",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_melee_carry' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:GetUnitName() == 'npc_dota_juggernaut_healing_ward'
		then
			Minion.HealingWardThink( hMinionUnit )
		else
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

end

local BladeFury = bot:GetAbilityByName('juggernaut_blade_fury')
local HealingWard = bot:GetAbilityByName('juggernaut_healing_ward')
local BladeDance = bot:GetAbilityByName('juggernaut_blade_dance')
local Swiftslash = bot:GetAbilityByName('juggernaut_swift_slash')
local Omnislash = bot:GetAbilityByName('juggernaut_omni_slash')

local BladeFuryDesire
local HealingWardDesire, HealingWardLocation
local SwiftslashDesire, SwiftslashTarget
local OmnislashDesire, OmnislashTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	BladeFury = bot:GetAbilityByName('juggernaut_blade_fury')
	HealingWard = bot:GetAbilityByName('juggernaut_healing_ward')
	Swiftslash = bot:GetAbilityByName('juggernaut_swift_slash')
	Omnislash = bot:GetAbilityByName('juggernaut_omni_slash')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	SwiftslashDesire, SwiftslashTarget = X.ConsiderSwiftSlash()
	if SwiftslashDesire > 0 then
		bot:Action_UseAbilityOnEntity(Swiftslash, SwiftslashTarget)
		return
	end

	OmnislashDesire, OmnislashTarget = X.ConsiderOmnislash()
	if OmnislashDesire > 0 then
		bot:Action_UseAbilityOnEntity(Omnislash, OmnislashTarget)
		return
	end

	BladeFuryDesire = X.ConsiderBladeFury()
	if BladeFuryDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(BladeFury)
		return
	end

	HealingWardDesire, HealingWardLocation = X.ConsiderHealingWard()
	if HealingWardDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(HealingWard, HealingWardLocation)
		return
	end
end

function X.ConsiderBladeFury()
	if not J.CanCastAbility(BladeFury)
	or bot:HasModifier('modifier_juggernaut_blade_fury')
	or bot:HasModifier('modifier_juggernaut_omnislash')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = BladeFury:GetSpecialValueInt('blade_fury_radius')
	local nDPS = BladeFury:GetSpecialValueInt('blade_fury_damage')
	local nDuration = BladeFury:GetSpecialValueInt('duration')
	local nManaCost = BladeFury:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Swiftslash, Omnislash})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {HealingWard, Swiftslash, Omnislash})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {BladeFury, Swiftslash, Omnislash})

	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

	if #nEnemyHeroesTargetingMe > 0 and J.IsStunProjectileIncoming(bot, 1000) and not bot:IsMagicImmune() then
		if fManaAfter > fManaThreshold1 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and fManaAfter > fManaThreshold1
		then
			if #nInRangeEnemy >= 2
			or (J.CanCastOnNonMagicImmune(botTarget) and not J.IsChasingTarget(bot, botTarget))
			or (J.IsChasingTarget(bot, botTarget) and J.GetHP(botTarget) < 0.5)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 1000)
			and not J.IsSuspiciousIllusion(enemyHero)
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (#nInRangeEnemy >= 2 and botHP < 0.5)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if J.IsNotAttackProjectileIncoming(bot, 700) and not bot:IsMagicImmune() then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local bHasFarmingItem = J.HasItem(bot, 'item_maelstrom') or J.HasItem(bot, 'item_mjollnir') or J.HasItem(bot, 'item_bfury') or J.HasItem(bot, 'item_radiance')

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold3 and not bHasFarmingItem and #nEnemyHeroes <= 1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 4 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold2 and not bHasFarmingItem then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nEnemyHeroes == 0 then
			if #nEnemyCreeps >= 4 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 4 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold2 and not bHasFarmingItem and #nEnemyHeroes <= 1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
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

function X.ConsiderHealingWard()
	if not J.CanCastAbility(HealingWard)
	or bot:HasModifier('modifier_juggernaut_healing_ward_heal')
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, HealingWard:GetCastRange())
	local nRadius = HealingWard:GetSpecialValueInt('healing_ward_aura_radius')
	local nManaCost = HealingWard:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BladeFury, Swiftslash, Omnislash})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Swiftslash, Omnislash})

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)
		if #nInRangeAlly >= 2 and fManaAfter > fManaThreshold1 then
			local count = 0
			for _, allyHero in pairs(nInRangeAlly) do
				if J.IsValidHero(allyHero)
				and J.CanBeAttacked(allyHero)
				and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
				and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not allyHero:HasModifier('modifier_ice_blast')
				then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 900)
		and botHP <= 0.6
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if not J.IsRealInvisible(bot)
	and bot:DistanceFromFountain() > 800
	and botHP < 0.5
	and fManaAfter > fManaThreshold1
	then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSwiftSlash()
	if not J.CanCastAbility(Swiftslash)
	or bot:HasModifier('modifier_juggernaut_blade_fury')
	or bot:HasModifier('modifier_juggernaut_omnislash')
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Swiftslash:GetCastRange())
	local nRadius = 425
	if Omnislash and Omnislash:IsTrained() then
		nRadius = Omnislash:GetSpecialValueInt('omni_slash_radius')
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange * 1.5)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			local nLocationAoE_creeps = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE_creeps.count == 0 then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderOmnislash()
	if not J.CanCastAbility(Omnislash)
	or bot:HasModifier('modifier_juggernaut_blade_fury')
	or bot:HasModifier('modifier_juggernaut_omnislash')
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Omnislash:GetCastRange())
	local nRadius = Omnislash:GetSpecialValueInt('omni_slash_radius')
	local nBonusDamage = Omnislash:GetSpecialValueInt('bonus_damage')
	local nDuration = Omnislash:GetSpecialValueFloat('duration')

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange * 1.5)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		then
			if botTarget:GetUnitName() ~= 'npc_dota_hero_medusa'
			or J.GetMP(botTarget) < 0.4
			then
				local nLocationAoE_creeps = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, nRadius, 0, 0)
				local nInRangeEnemy = botTarget:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
				local nDamage = bot:GetEstimatedDamageToTarget(true, botTarget, nDuration, DAMAGE_TYPE_ALL)

				if nLocationAoE_creeps.count <= 1 and (J.IsInTeamFight(bot, 1200) or ((nDamage / botTarget:GetHealth() >= 0.5) and #nInRangeEnemy <= 1)) then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
