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

local Reflection    = bot:GetAbilityByName('terrorblade_reflection')
local ConjureImage  = bot:GetAbilityByName('terrorblade_conjure_image')
local Metamorphosis = bot:GetAbilityByName('terrorblade_metamorphosis')
local DemonZeal     = bot:GetAbilityByName('terrorblade_demon_zeal')
local TerrorWave    = bot:GetAbilityByName('terrorblade_terror_wave')
local Sunder        = bot:GetAbilityByName('terrorblade_sunder')

local ReflectionDesire, ReflectionLocation
local ConjureImageDesire
local MetamorphosisDesire
local DemonZealDesire
local TerrorWaveDesire
local SunderDesire, SunderTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

	Reflection    = bot:GetAbilityByName('terrorblade_reflection')
	ConjureImage  = bot:GetAbilityByName('terrorblade_conjure_image')
	Metamorphosis = bot:GetAbilityByName('terrorblade_metamorphosis')
	DemonZeal     = bot:GetAbilityByName('terrorblade_demon_zeal')
	TerrorWave    = bot:GetAbilityByName('terrorblade_terror_wave')
	Sunder        = bot:GetAbilityByName('terrorblade_sunder')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	SunderDesire, SunderTarget = X.ConsiderSunder()
    if SunderDesire > 0 then
		bot:Action_UseAbilityOnEntity(Sunder, SunderTarget)
		return
	end

	ReflectionDesire, ReflectionLocation = X.ConsiderReflection()
	if ReflectionDesire > 0	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Reflection, ReflectionLocation)
		return
	end

	ConjureImageDesire = X.ConsiderConjureImage()
	if ConjureImageDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ConjureImage)
		return
	end

	TerrorWaveDesire = X.ConsiderTerrorWave()
    if TerrorWaveDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(TerrorWave)
		return
	end

	MetamorphosisDesire = X.ConsiderMetamorphosis()
	if MetamorphosisDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Metamorphosis)
		return
	end

    DemonZealDesire = X.ConsiderDemonZeal()
	if DemonZealDesire > 0 then
		bot:Action_UseAbility(DemonZeal)
		return
	end
end

function X.ConsiderReflection()
	if not J.CanCastAbility(Reflection) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Reflection:GetCastRange())
	local nRadius = Reflection:GetSpecialValueInt('range')
	local nManaCost = Reflection:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ConjureImage, Metamorphosis, TerrorWave, Sunder})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if J.IsInLaningPhase() then
				if J.IsChasingTarget(bot, botTarget)
				or J.GetHP(botTarget) < 0.5
				or nLocationAoE.count >= 2
				then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			else
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.IsInRange(bot, enemy, nCastRange)
			and not J.IsDisabled(enemy)
			and not enemy:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemy, 3.0)
			then
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				or (botHP < 0.5)
				then
					return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
				end
			end
		end
	end

	if  not J.IsRealInvisible(bot)
	and not J.IsGoingOnSomeone(bot)
	and fManaAfter > fManaThreshold1
	then
		for _, allyHero in pairs(nAllyHeroes) do
			if  J.IsValidHero(allyHero)
			and bot ~= allyHero
			and J.IsRetreating(allyHero)
			and allyHero:WasRecentlyDamagedByAnyHero(3.0)
			and not J.IsSuspiciousIllusion(allyHero)
			then
				for _, enemy in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemy)
					and J.CanBeAttacked(enemy)
					and J.CanCastOnNonMagicImmune(enemy)
					and J.IsInRange(bot, enemy, nCastRange)
					and J.IsChasingTarget(enemy, bot)
					and not J.IsDisabled(enemy)
					then
						return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderConjureImage()
	if not J.CanCastAbility(ConjureImage) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Max(bot:GetAttackRange(), 600)
	local nManaCost = ConjureImage:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Reflection, Metamorphosis, TerrorWave, Sunder})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Reflection, ConjureImage, Metamorphosis, TerrorWave, Sunder})

	if not bot:IsMagicImmune() then
		if (J.GetAttackProjectileDamageByRange(bot, 600) > bot:GetHealth())
		or (J.IsStunProjectileIncoming(bot, 600))
		or (J.IsUnitTargetProjectileIncoming(bot, 600))
		or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 600))
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and not J.IsDisabled(enemy)
			and (not J.IsSuspiciousIllusion(enemy) or botHP < 0.2)
			then
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				or (botHP < 0.4)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if (J.IsPushing(bot) and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 3)
	or (J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1)
	then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nEnemyCreeps >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end

		if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 300)
		and bAttacking
		then
			if J.GetHP(botTarget) > 0.25 or botTarget == GetAncient(GetOpposingTeam()) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and #nEnemyCreeps >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end

		if #nEnemyHeroes >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 then
		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and botTarget:IsCreep()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fManaAfter > fManaThreshold1
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
	local nManaCost = Metamorphosis:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Reflection, ConjureImage, TerrorWave, Sunder})

	if J.IsInTeamFight(bot, 1200) and botHP > 0.15 then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) and botHP > 0.15 then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.IsCore(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			if J.IsInLaningPhase() and bot:GetLevel() < 6 then
				if J.GetHP(botTarget) < 0.5 and bAttacking and not J.IsChasingTarget(bot, botTarget) then
					return BOT_ACTION_DESIRE_HIGH
				end
			else
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and bot:GetNetWorth() < 17500
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDemonZeal()
    if not J.CanCastAbility(DemonZeal) then
		return BOT_ACTION_DESIRE_NONE
	end

    local nHealthCost = bot:GetHealth() * (DemonZeal:GetSpecialValueFloat('health_cost_pct') / 100)
	local fHealthAfter = J.GetHealthAfter(nHealthCost)

	if J.IsInTeamFight(bot, 1200) and fHealthAfter > 0.4 then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeEnemy >= 2 and bAttacking then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and bAttacking
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 450)
			if (fHealthAfter > 0.4)
			or (fHealthAfter > 0.25 and J.CanCastAbility(Sunder) and #nInRangeEnemy > 0) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsPushing(bot) then
		if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 300)
		and bAttacking
		and fHealthAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot))
	and fHealthAfter > 0.4
	and bAttacking
	then
		local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
		if #nEnemyCreeps >= 5 and #nInRangeAlly <= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fHealthAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fHealthAfter > 0.5
		then
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

	local nRadius = bot:GetAttackRange()
	local nManaCost = TerrorWave:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Reflection, ConjureImage, Metamorphosis, Sunder})

	if Metamorphosis then
		nRadius = nRadius + Metamorphosis:GetSpecialValueInt('bonus_range')
	end

	if J.IsInTeamFight(bot, 1200) and botHP > 0.15 then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) and botHP > 0.15 then
		if J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and bot:GetNetWorth() < 17500
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and bot:GetNetWorth() < 17500
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSunder()
	if not J.CanCastAbility(Sunder) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Sunder:GetCastRange())

	if not J.IsRealInvisible(bot) or J.IsInTeamFight(bot, 1200) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.CanCastOnTargetAdvanced(enemy)
			then
				if J.GetHP(enemy) - botHP >= 0.5 then
					return BOT_ACTION_DESIRE_HIGH, enemy
				end
			end
		end

		for _, ally in pairs(nAllyHeroes) do
			if J.IsValidHero(ally)
			and bot ~= ally
			and J.IsInRange(bot, ally, nCastRange + 300)
			and ally:GetUnitName() == 'npc_dota_hero_terrorblade'
			then
				if J.GetHP(ally) - botHP >= 0.5 then
					return BOT_ACTION_DESIRE_HIGH, ally
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X