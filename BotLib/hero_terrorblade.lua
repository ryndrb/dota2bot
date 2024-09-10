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
				
				"item_wraith_band",
				"item_power_treads",
				"item_magic_wand",
				"item_manta",--
				"item_dragon_lance",
				"item_skadi",--
				"item_black_king_bar",--
				"item_butterfly",--
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_hurricane_pike",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_wraith_band",
				"item_power_treads",
				"item_magic_wand",
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
    if (SunderDesire > 0)
	then
		bot:Action_UseAbilityOnEntity(Sunder, SunderTarget)
		return
	end

	ReflectionDesire, ReflectionLocation = X.ConsiderReflection()
	if (ReflectionDesire > 0)
	then
		bot:Action_UseAbilityOnLocation(Reflection, ReflectionLocation)
		return
	end

	ConjureImageDesire = X.ConsiderConjureImage()
	if (ConjureImageDesire > 0)
	then
		bot:Action_UseAbility(ConjureImage)
		return
	end

	TerrorWaveDesire = X.ConsiderTerrorWave()
    if (TerrorWaveDesire > 0)
	then
		bot:Action_UseAbility(TerrorWave)
		return
	end

	MetamorphosisDesire = X.ConsiderMetamorphosis()
	if (MetamorphosisDesire > 0)
	then
        bot:Action_UseAbility(Metamorphosis)
		return
	end

    DemonZealDesire = X.ConsiderDemonZeal()
	if (DemonZealDesire > 0)
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

	local nRadius = Reflection:GetSpecialValueInt('range')
	local nCastRange = Reflection:GetCastRange()
	local nCastPoint = Reflection:GetCastPoint()
	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

		if nLocationAoE.count >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 200, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsSuspiciousIllusion(botTarget)
		and nInRangeAlly ~= nil and nInRangeEnemy
		and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 200, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and ((#nInRangeEnemy > #nInRangeAlly)
			or (J.GetHP(bot) < 0.6 and bot:WasRecentlyDamagedByAnyHero(2)))
		and J.IsValidHero(nInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		and not J.IsDisabled(nInRangeEnemy[1])
		then
			return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]:GetLocation()
		end
	end

	local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
	for _, allyHero in pairs(nAllyHeroes)
	do
		local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  (J.IsRetreating(allyHero)
			and J.GetHP(allyHero) < 0.6
			and allyHero:WasRecentlyDamagedByAnyHero(2.5))
		and J.IsValidHero(nAllyInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
		and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
		and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
		and not J.IsDisabled(nAllyInRangeEnemy[1])
		then
			return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderConjureImage()
	if not J.CanCastAbility(ConjureImage)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nMana = bot:GetMana() / bot:GetMaxMana()
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(600, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 50)
		and not J.IsInEtherealForm(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(600, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and ((#nInRangeEnemy > #nInRangeAlly)
			or (J.GetHP(bot) < 0.5 and bot:WasRecentlyDamagedByAnyHero(2)))
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsDefending(bot) or J.IsPushing(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(700, true)
		local nEnemyTowers = bot:GetNearbyTowers(700, true)

		if ((nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3)
			or (nEnemyTowers ~= nil and #nEnemyTowers >= 1))
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsFarming(bot)
	and nMana > 0.4
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
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
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

	if J.IsInTeamFight(bot, 1200)
	then
		local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(nRadius + 150, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.IsCore(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsInEtherealForm(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and nInRangeAlly ~= nil and nInRangeEnemy
		and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and DotaTime() < 30 * 60
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSunder()
	if not J.CanCastAbility(Sunder)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = Sunder:GetCastRange()

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	local nSunderTarget = J.GetMostHPPercent(nEnemyHeroes, true)

	if  J.GetHP(bot) < 0.35
	and nSunderTarget ~= nil
	and not J.IsSuspiciousIllusion(nSunderTarget)
	then
		return BOT_ACTION_DESIRE_HIGH, nSunderTarget
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDemonZeal()
    if not J.CanCastAbility(DemonZeal)
	then
		return BOT_ACTION_DESIRE_NONE
	end

    local nHealthCost = bot:GetHealth() * DemonZeal:GetSpecialValueFloat('value')
    local nRadius = bot:GetAttackRange() + Metamorphosis:GetSpecialValueInt('bonus_range')
	local botTarget = J.GetProperTarget(bot)

	if  (((bot:GetHealth() - nHealthCost) / bot:GetMaxHealth()) > 0.5)
	and bot:HasModifier('modifier_terrorblade_metamorphosis_transform')
	then
		if J.IsInTeamFight(bot, 1200)
		then
			local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

			if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsGoingOnSomeone(bot)
		then
			local nInRangeAlly = bot:GetNearbyHeroes(nRadius + 150, false, BOT_MODE_NONE)
			local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

			if  J.IsValidTarget(botTarget)
			and J.IsInRange(bot, botTarget, nRadius)
			and J.IsCore(botTarget)
			and not J.IsSuspiciousIllusion(botTarget)
			and not J.IsInEtherealForm(botTarget)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			and nInRangeAlly ~= nil and nInRangeEnemy
			and #nInRangeAlly >= #nInRangeEnemy
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTerrorWave()
	if not J.CanCastAbility(TerrorWave)
	or bot:HasModifier('modifier_terrorblade_metamorphosis_transform')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = bot:GetAttackRange() + Metamorphosis:GetSpecialValueInt('bonus_range')
	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(nRadius + 150, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.IsCore(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsInEtherealForm(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and nInRangeAlly ~= nil and nInRangeEnemy
		and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and DotaTime() < 30 * 60
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X