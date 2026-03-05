local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_bristleback'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb", "item_nullifier", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
				[2] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_sange_and_yasha",--
				"item_basher",
				"item_satanic",--
				"item_abyssal_blade",--
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_sange_and_yasha",
				"item_magic_wand", "item_basher",
				"item_magic_wand", "item_abyssal_blade",
				"item_bracer", "item_satanic",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
				[2] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bottle",
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_sange_and_yasha",--
				"item_assault",--
				"item_satanic",--
				"item_basher",
				"item_ultimate_scepter_2",
				"item_abyssal_blade",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_sange_and_yasha",
				"item_bracer", "item_assault",
				"item_bottle", "item_satanic",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_bracer",
				"item_arcane_boots",
				"item_blade_mail",
				"item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_aghanims_shard",
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", sUtilityItem,
				"item_bracer", "item_assault",
				"item_blade_mail", "item_travel_boots_2",
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

local ViscousNasalGoo = bot:GetAbilityByName('bristleback_viscous_nasal_goo')
local QuillSpray = bot:GetAbilityByName('bristleback_quill_spray')
local Bristleback = bot:GetAbilityByName('bristleback_bristleback')
local Hairball = bot:GetAbilityByName('bristleback_hairball')
local Warpath = bot:GetAbilityByName('bristleback_warpath')

local ViscousNasalGooDesire, ViscousNasalGooTarget
local QuillSprayDesire
local HairballDesire, HairballTarget
local BristlebackDesire, BristlebackLocation
local WarpathDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	ViscousNasalGoo = bot:GetAbilityByName('bristleback_viscous_nasal_goo')
	QuillSpray = bot:GetAbilityByName('bristleback_quill_spray')
	Bristleback = bot:GetAbilityByName('bristleback_bristleback')
	Hairball = bot:GetAbilityByName('bristleback_hairball')
	Warpath = bot:GetAbilityByName('bristleback_warpath')

	bAttacking = J.IsAttacking(bot)
	botHP = J.GetHP(bot)
	botTarget = J.GetProperTarget(bot)
	nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	HairballDesire, HairballTarget = X.ConsiderHairball()
	if HairballDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbilityOnLocation(Hairball, HairballTarget)
		return
	end

	BristlebackDesire, BristlebackLocation = X.ConsiderBristleback()
	if BristlebackDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Bristleback, BristlebackLocation)
		return
	end

	ViscousNasalGooDesire, ViscousNasalGooTarget = X.ConsiderViscousNasalGoo()
    if ViscousNasalGooDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ViscousNasalGoo, ViscousNasalGooTarget)
        return
    end

	WarpathDesire = X.ConsiderWarpath()
	if WarpathDesire > 0 then
		bot:Action_UseAbility(Warpath)
		return
	end

	QuillSprayDesire = X.ConsiderQuillSpray()
	if QuillSprayDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbility(QuillSpray)
		return
	end
end

function X.ConsiderViscousNasalGoo()
	if not J.CanCastAbility(ViscousNasalGoo) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ViscousNasalGoo:GetCastRange()
	local nManaCost = ViscousNasalGoo:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Bristleback, Hairball})

	if J.IsInTeamFight(bot, 1200) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and fManaAfter > fManaThreshold1
			then
				local nStacks = J.GetModifierCount(enemyHero, 'modifier_bristleback_viscous_nasal_goo')
				if nStacks <= 2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				local nStacks = J.GetModifierCount(enemyHero, 'modifier_bristleback_viscous_nasal_goo')
				if nStacks <= 2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderQuillSpray()
	if not J.CanCastAbility(QuillSpray) then
		return BOT_ACTION_DESIRE_NONE
	end

	if QuillSpray:GetAutoCastState() == true then
		QuillSpray:ToggleAutoCast()
	end

	local nRadius = QuillSpray:GetSpecialValueInt('radius')
	local nManaCost = QuillSpray:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ViscousNasalGoo, QuillSpray, Bristleback, Hairball})

	local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200) then
		if J.IsValidHero(nInRangeEnemy[1]) and fManaAfter > fManaThreshold1 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and fManaAfter > fManaThreshold1
		then
			if J.IsInRange(bot, botTarget, nRadius) then
				if not J.IsSuspiciousIllusion(botTarget)
				or #nInRangeEnemy >= 3
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end

			if J.IsInRange(bot, botTarget, 1200) and not J.IsInRange(bot, botTarget, nRadius) and fManaAfter > 0.75 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				if not J.IsSuspiciousIllusion(enemyHero) or #nInRangeEnemy >= 2 then
					local nStacks = J.GetModifierCount(enemyHero, 'modifier_bristleback_viscous_nasal_goo')
					if nStacks >= 3
					or enemyHero:HasModifier('modifier_bristleback_quill_spray')
					or bot:IsRooted()
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) and bAttacking then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) and bAttacking then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not J.IsInLaningPhase() and bot:DistanceFromFountain() > 2400 then
		if fManaAfter > 0.8
		or bot:GetManaRegen() >= nManaCost
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBristleback()
	if not J.CanCastAbility(Bristleback) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = 350
	local nManaCost = Bristleback:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ViscousNasalGoo, Hairball})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if not J.IsMoving(botTarget)
			or J.IsDisabled(botTarget)
			or botTarget:GetCurrentMovementSpeed() <= 250
			or (nLocationAoE.count >= 3 and not J.IsInTeamFight(bot, 800))
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 + 0.1 and bAttacking and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end

				if creep:GetHealth() >= 1000 then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
            end
        end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 + 0.1 and bAttacking and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end

				if creep:GetHealth() >= 1000 then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
            end
        end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius * 2)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius * 2)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderHairball()
	if not J.CanCastAbility(Hairball) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = Hairball:GetCastRange()
    local nRadius = Hairball:GetSpecialValueInt('radius')
	local nManaCost = Hairball:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Bristleback})

    if J.IsInTeamFight(bot, 1400) then
        local vLocation = J.GetAoeEnemyHeroLocation(bot, nCastRange, nRadius, 2)
        if vLocation ~= nil and fManaAfter > fManaThreshold1 then
            return BOT_ACTION_DESIRE_HIGH, vLocation
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in ipairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			then
				return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), bot:GetLocation(), Min(GetUnitToUnitDistance(bot, enemyHero), nRadius))
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderWarpath()
	if not J.CanCastAbility(Warpath) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nInRangeAlly = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

	if J.IsInTeamFight(bot, 1200) then
		if #nInRangeEnemy > #nInRangeAlly or (botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(4.0)) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero) and J.IsInRange(bot, enemyHero, 500) and J.IsChasingTarget(enemyHero, bot) then
				if (J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 8.0) > bot:GetHealth() * 1.15)
				or (#nEnemyHeroes > #nAllyHeroes and botHP < 0.4)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X