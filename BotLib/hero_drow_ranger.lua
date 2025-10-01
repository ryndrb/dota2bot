local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_drow_ranger'
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,3,6,3,3,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_magic_stick",
                "item_slippers",
			
				"item_power_treads",
				"item_wraith_band",
				"item_magic_wand",
                "item_falcon_blade",
				"item_dragon_lance",
                "item_manta",--
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_ultimate_scepter",
				"item_greater_crit",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_wraith_band", "item_ultimate_scepter",
                "item_falcon_blade", "item_greater_crit",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,3,6,3,3,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_magic_stick",
                "item_slippers",
			
				"item_power_treads",
				"item_wraith_band",
				"item_magic_wand",
                "item_falcon_blade",
				"item_dragon_lance",
                "item_manta",--
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_ultimate_scepter",
				"item_greater_crit",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_wraith_band", "item_ultimate_scepter",
                "item_falcon_blade", "item_greater_crit",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_ranged_carry' }, {} end

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

local FrostArrows = bot:GetAbilityByName('drow_ranger_frost_arrows')
local Gust = bot:GetAbilityByName('drow_ranger_wave_of_silence')
local Multishot = bot:GetAbilityByName('drow_ranger_multishot')
local Glacier 	= bot:GetAbilityByName( 'drow_ranger_glacier' )
local Markmanship = bot:GetAbilityByName('drow_ranger_marksmanship')

local FrostArrowsDesire, FrostArrowsTarget
local GustDesire, GustLocation
local MultishotDesire, MultishotLocation
local GlacierDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	GustDesire, GustLocation = X.ConsiderGust()
	if GustDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Gust , GustLocation)
		return
	end

	GlacierDesire = X.ConsiderGlacier()
	if GlacierDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Glacier)
		return
	end

	MultishotDesire, MultishotLocation = X.ConsiderMultishot()
	if MultishotDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Multishot , MultishotLocation)
		return
	end

	FrostArrowsDesire, FrostArrowsTarget = X.ConsiderFrostArrows()
	if FrostArrowsDesire > 0 then
		bot:Action_ClearActions(false)
		bot:Action_UseAbilityOnEntity(FrostArrows , FrostArrowsTarget)
		return
	end
end

function X.ConsiderFrostArrows()
    if not J.CanCastAbility(FrostArrows)
    or bot:IsDisarmed()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = FrostArrows:GetCastRange()
    local nCastPoint = FrostArrows:GetCastPoint()
    local nBonusDamage = FrostArrows:GetSpecialValueInt('bonus_damage')
    local nManaCost = FrostArrows:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Gust, Multishot, Glacier})

    for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.WillKillTarget(enemyHero, bot:GetAttackDamage() + nBonusDamage, DAMAGE_TYPE_PHYSICAL, nCastPoint)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:IsMagicImmune()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1 + 0.1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, nCastRange / 2)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and not enemyHero:HasModifier('modifier_drow_ranger_frost_arrows_slow')
			and enemyHero:GetAttackTarget() == bot
			then
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange / 2)
				if #nInRangeEnemy == 0 or #nAllyHeroes > #nEnemyHeroes then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

    if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) then
		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and not J.IsRoshan(botTarget)
		and not J.IsTormentor(botTarget)
		and not botTarget:IsBuilding()
		and not botTarget:HasModifier('modifier_drow_ranger_frost_arrows_slow')
		and fManaAfter > fManaThreshold1 + 0.1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
            and J.WillKillTarget(creep, bot:GetAttackDamage() + nBonusDamage, DAMAGE_TYPE_PHYSICAL, nCastPoint)
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
                return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGust()
    if not J.CanCastAbility(Gust) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = J.GetProperCastRange(false, bot, Gust:GetCastRange())
	local nCastPoint = Gust:GetCastPoint()
	local nRadius = Gust:GetSpecialValueInt('wave_width')
	local nManaCost = Gust:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Gust, Multishot, Glacier})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Multishot, Glacier})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 150)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        and not enemyHero:HasModifier('modifier_teleporting')
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsSilenced()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange - 100, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 and fManaAfter > fManaThreshold2 and (botHP < 0.65 or #nEnemyHeroes > #nAllyHeroes) then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderMultishot()
    if not J.CanCastAbility(Multishot) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = Multishot:GetSpecialValueFloat('arrow_range_multiplier') * bot:GetAttackRange()
	local nCastPoint = Multishot:GetCastPoint()
	local nArrowPerWave = Multishot:GetSpecialValueInt('arrow_count_per_wave')
	local nArrowWidth = Multishot:GetSpecialValueInt('arrow_width')
	local nRadius = nArrowPerWave * nArrowWidth
	local nDuration = Multishot:GetSpecialValueFloat('AbilityChannelTime')
	local nSpeed = Multishot:GetSpecialValueInt('arrow_speed')
	local nManaCost = Multishot:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Gust, Glacier})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Gust, Multishot, Glacier})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Gust})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 0.8)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		then
			if not J.IsChasingTarget(bot, botTarget) then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end

			local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 2 and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) <= bot:GetAttackRange() then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(bot:GetAttackRange(), 1600), true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold2 and bAttacking and #nAllyHeroes <= 3 and #nEnemyHeroes <= 1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and bAttacking and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold3 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderGlacier()
    if not J.CanCastAbility(Glacier) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaCost = Glacier:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Gust, Multishot})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			if (J.CanCastAbility(Multishot) and bot:GetMana() > (Multishot:GetManaCost() + Glacier:GetManaCost() + 80))
			or (J.IsInTeamFight(bot, 1200) and not J.IsRunning(bot))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1000)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsInRange(bot, enemyHero, 350)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and bot:IsFacingLocation(J.GetTeamFountain(), 45)
            then
                if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X