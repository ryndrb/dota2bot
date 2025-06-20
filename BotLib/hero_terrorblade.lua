local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_terrorblade'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,3,2,2,2,6,2,3,3,3,6,1,1,1,6},
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
				"item_falcon_blade",
				"item_manta",--
				"item_dragon_lance",
				"item_skadi",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_hurricane_pike",--
				"item_greater_crit",--
				"item_moon_shard",
				"item_butterfly",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_dragon_lance",
				"item_magic_wand", "item_skadi",
				"item_wraith_band", "item_black_king_bar",
				"item_falcon_blade", "item_greater_crit",
				"item_power_treads", "item_butterfly",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local Reflection    = bot:GetAbilityByName( "terrorblade_reflection" )
local ConjureImage  = bot:GetAbilityByName( "terrorblade_conjure_image" )
local Metamorphosis = bot:GetAbilityByName( "terrorblade_metamorphosis" )
local DemonZeal     = bot:GetAbilityByName( "terrorblade_demon_zeal" )
local TerrorWave    = bot:GetAbilityByName( "terrorblade_terror_wave" )
local Sunder        = bot:GetAbilityByName( "terrorblade_sunder" )

local ReflectionDesire, ReflectionLocation
local ConjureImageDesire
local MetamorphosisDesire
local DemonZealDesire
local TerrorWaveDesire
local SunderDesire, SunderTarget

function X.SkillsComplement()

    if J.CanNotUseAbility(bot) then return end

	Reflection    = bot:GetAbilityByName( "terrorblade_reflection" )
	ConjureImage  = bot:GetAbilityByName( "terrorblade_conjure_image" )
	Metamorphosis = bot:GetAbilityByName( "terrorblade_metamorphosis" )
	DemonZeal     = bot:GetAbilityByName( "terrorblade_demon_zeal" )
	TerrorWave    = bot:GetAbilityByName( "terrorblade_terror_wave" )
	Sunder        = bot:GetAbilityByName( "terrorblade_sunder" )

	SunderDesire, SunderTarget = X.ConsiderSunder()
    if SunderDesire > 0
	then
		bot:Action_UseAbilityOnEntity(Sunder, SunderTarget)
		return
	end

	ReflectionDesire, ReflectionLocation = X.ConsiderReflection()
	if ReflectionDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Reflection, ReflectionLocation)
		return
	end

	ConjureImageDesire = X.ConsiderConjureImage()
	if ConjureImageDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ConjureImage)
		return
	end

	TerrorWaveDesire = X.ConsiderTerrorWave()
    if TerrorWaveDesire > 0
	then
		bot:Action_UseAbility(TerrorWave)
		return
	end

	MetamorphosisDesire = X.ConsiderMetamorphosis()
	if MetamorphosisDesire > 0
	then
        bot:Action_UseAbility(Metamorphosis)
		return
	end

    DemonZealDesire = X.ConsiderDemonZeal()
	if DemonZealDesire > 0
	then
		bot:Action_UseAbility(DemonZeal)
		return
	end
end

function X.ConsiderReflection()
	if not J.CanCastAbility(Reflection)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Reflection:GetCastRange())
	local nRadius = Reflection:GetSpecialValueInt('range')
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 1 then
				if J.IsInLaningPhase() then
					if J.IsChasingTarget(bot, botTarget)
					or J.GetHP(botTarget) < 0.5
					or nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				else
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		for _, enemy in pairs(tEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and not J.IsDisabled(enemy)
			and bot:WasRecentlyDamagedByAnyHero(3.0) then
				if J.IsChasingTarget(enemy, bot) then
					return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
				else
					local nLocationAoE = bot:FindAoELocation(true, true, enemy:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count >= 1 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            if  J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
				local nLocationAoE = bot:FindAoELocation(true, true, nAllyInRangeEnemy[1]:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count >= 1 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderConjureImage()
	if not J.CanCastAbility(ConjureImage)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nMana = J.GetMP(bot)
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		and J.CanBeAttacked(botTarget)
		and not J.IsInEtherealForm(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		local tAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
		local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		for _, enemy in pairs(tEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and not J.IsDisabled(enemy)
			and bot:WasRecentlyDamagedByAnyHero(3.0) then
				if J.IsChasingTarget(enemy, bot) or #tEnemyHeroes > #tAllyHeroes and J.GetHP(bot) < 0.6 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsDefending(bot) or J.IsPushing(bot) or (J.IsLaning(bot) and nMana > 0.35)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(700, true)

		if #nEnemyLaneCreeps >= 3
		and J.IsValid(nEnemyLaneCreeps[1])
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and J.IsAttacking(bot) then
			return BOT_ACTION_DESIRE_HIGH
		end

		if (J.IsValidBuilding(botTarget) or (botTarget == GetAncient(GetOpposingTeam())))
		and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 300)
		and J.CanBeAttacked(botTarget)
		and J.IsAttacking(bot) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsFarming(bot)
	and nMana > 0.25
	then
		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and botTarget:IsCreep()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMetamorphosis()
	if not J.CanCastAbility(Metamorphosis)
	or bot:HasModifier('modifier_terrorblade_metamorphosis')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = bot:GetAttackRange() + Metamorphosis:GetSpecialValueInt('bonus_range')
	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200) and J.GetHP(bot) > 0.15
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) and J.GetHP(bot) > 0.15
	then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanBeAttacked(botTarget)
		and J.IsCore(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsInEtherealForm(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			if J.IsInLaningPhase() and bot:GetLevel() < 6 then
				if J.GetHP(botTarget) < 0.5 and J.IsAttacking(bot) then
					return BOT_ACTION_DESIRE_HIGH
				end
			else
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.IsAttacking(bot)
		and DotaTime() < J.IsModeTurbo() and 16 * 60 or 25 * 60
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSunder()
	if not J.CanCastAbility(Sunder)
	or (J.GetHP(bot) > 0.35
		and bot:HasModifier('modifier_item_satanic_unholy')
		and J.IsAttacking(bot)
		and not J.IsRetreating(bot)
	)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Sunder:GetCastRange())

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemy in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemy)
		and J.CanCastOnNonMagicImmune(enemy)
		and J.CanCastOnTargetAdvanced(enemy)
		then
			if J.GetHP(enemy) - J.GetHP(bot) >= 0.4 then
				return BOT_ACTION_DESIRE_HIGH, enemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDemonZeal()
    if not J.CanCastAbility(DemonZeal)
	then
		return BOT_ACTION_DESIRE_NONE
	end

    local nHealthCost = bot:GetHealth() * (DemonZeal:GetSpecialValueFloat('health_cost_pct') / 100)
	local botTarget = J.GetProperTarget(bot)

	if J.GetHealthAfter(nHealthCost) > 0.5
	and (bot:HasModifier('modifier_terrorblade_metamorphosis')
		or bot:HasModifier('modifier_terrorblade_metamorphosis_transform'))
	then
		if J.IsInTeamFight(bot, 1200)
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if #nInRangeEnemy >= 2 and J.IsAttacking(bot) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsGoingOnSomeone(bot)
		then
			if  J.IsValidTarget(botTarget)
			and J.IsInRange(bot, botTarget, 800)
			and J.IsAttacking(bot)
			and J.CanBeAttacked(botTarget)
			and not J.IsSuspiciousIllusion(botTarget)
			and not J.IsInEtherealForm(botTarget)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
			and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsPushing(bot) then
		if (J.IsValidBuilding(botTarget) or (botTarget == GetAncient(GetOpposingTeam())))
		and J.CanBeAttacked(botTarget)
		and J.IsAttacking(bot)
		and J.GetHealthAfter(nHealthCost) > 0.65 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsAttacking(bot)
		and J.GetHP(botTarget) > 0.5
		and J.GetHealthAfter(nHealthCost) > 0.5 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTerrorWave()
	if not J.CanCastAbility(TerrorWave)
	or bot:HasModifier('modifier_terrorblade_metamorphosis_transform')
	or bot:HasModifier('modifier_terrorblade_metamorphosis')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = bot:GetAttackRange() + Metamorphosis:GetSpecialValueInt('bonus_range')
	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200) and J.GetHP(bot) > 0.15
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) and J.GetHP(bot) > 0.15
	then
		if J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanBeAttacked(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsInEtherealForm(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and J.IsAttacking(bot)
		and DotaTime() < J.IsModeTurbo() and 16 * 60 or 25 * 60
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X