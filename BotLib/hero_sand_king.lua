local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_sand_king'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_crimson_guard"}
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
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_blink",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_shivas_guard",
				"item_bottle", "item_octarine_core",
			},
        },
    },
    ['pos_3'] = {
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
				[1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_circlet",
				"item_quelling_blade",
				"item_double_branches",
			
				"item_magic_wand",
				"item_bracer",
				"item_null_talisman",
				"item_arcane_boots",
				"item_blink",
				"item_pipe",--
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_pipe",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_ultimate_scepter",
				"item_null_talisman", "item_shivas_guard",
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

X['bDeafaultAbility'] = true
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local Burrowstrike = bot:GetAbilityByName('sandking_burrowstrike')
local SandStorm = bot:GetAbilityByName('sandking_sand_storm')
local Stinger  = bot:GetAbilityByName('sandking_scorpion_strike')
local Epicenter = bot:GetAbilityByName('sandking_epicenter')

local BurrowstrikeDesire, BurrowstrikeLocation
local SandStormDesire
local StingerDesire, StingerLocation
local EpicenterDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

    if Epicenter and Epicenter:IsTrained() and Epicenter:IsInAbilityPhase() then
        local nRadius = Epicenter:GetSpecialValueInt('epicenter_radius_base')
		local Blink = J.IsItemAvailable('item_blink') or J.IsItemAvailable('item_overwhelming_blink') or J.IsItemAvailable('item_swift_blink') or J.IsItemAvailable('item_arcane_blink')

		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius + 250)
        if #nInRangeEnemy == 0 then
			if (not J.IsInTeamFight(bot, 1200))
			or (Blink and not J.CanCastAbility(Blink))
			then
				bot:Action_ClearActions(true)
				return
			end
        end

		nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200 + nRadius)
		if #nInRangeEnemy == 0 then
			if (J.CanCastAbility(Blink)) then
				bot:Action_ClearActions(true)
				return
			end
		end
    end

	if J.CanNotUseAbility(bot) then return end

	Burrowstrike = bot:GetAbilityByName('sandking_burrowstrike')
	SandStorm = bot:GetAbilityByName('sandking_sand_storm')
	Stinger  = bot:GetAbilityByName('sandking_scorpion_strike')
	Epicenter = bot:GetAbilityByName('sandking_epicenter')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	BurrowstrikeDesire, BurrowstrikeLocation = X.ConsiderBurrowstrike()
	if BurrowstrikeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Burrowstrike, BurrowstrikeLocation)
		return
	end

	SandStormDesire = X.ConsiderSandstorm()
	if SandStormDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(SandStorm)
		return
	end

	EpicenterDesire = X.ConsiderEpicenter()
	if EpicenterDesire > 0 then
		if J.IsInTeamFight(bot, 1200) then
			local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
			if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (Epicenter:GetManaCost() + BlackKingBar:GetManaCost() + 100)) then
				bot:Action_ClearActions(true)
				bot:ActionQueue_UseAbility(BlackKingBar)
				bot:ActionQueue_Delay(0.1)
				bot:ActionQueue_UseAbility(Epicenter)
				return
			end
		end

		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Epicenter)
		return
	end

	StingerDesire, StingerLocation = X.ConsiderStinger()
	if StingerDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Stinger, StingerLocation)
		return
	end
end

function X.ConsiderBurrowstrike()
	if not J.CanCastAbility(Burrowstrike) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = Burrowstrike:GetCastRange()
	local nCastPoint = Burrowstrike:GetCastPoint()
	local nRadius = Burrowstrike:GetSpecialValueInt('burrow_width')
	local nDamage = Burrowstrike:GetSpecialValueInt('#AbilityDamage')
	local nSpeed = Burrowstrike:GetSpecialValueInt('burrow_speed')
	local nManaCost = Burrowstrike:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SandStorm, Stinger, Epicenter})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
        end
    end

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                then
					count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				for _, enemyHero__ in pairs(nEnemyHeroes) do
					if  J.IsValidHero(enemyHero__)
					and enemyHero ~= enemyHero__
					and J.CanBeAttacked(enemyHero__)
					and J.CanCastOnNonMagicImmune(enemyHero__)
					and not J.IsDisabled(enemyHero__)
					then
						local tResult = PointToLineDistance(bot:GetLocation(), enemyHero:GetLocation(), enemyHero__:GetLocation())
						if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
							return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
						end
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold1
        then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if  J.IsValidHero(enemyHero)
				and enemyHero ~= botTarget
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not J.IsDisabled(enemyHero)
				then
					local tResult = PointToLineDistance(bot:GetLocation(), botTarget:GetLocation(), enemyHero:GetLocation())
					if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
						return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
					end
				end
			end

            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			then
                if (bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
                or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nCastRange, bot:DistanceFromFountain()))
                end
			end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not J.IsRunning(creep)
			and not J.IsOtherAllysTarget(creep)
			then
                local sCreepName = creep:GetUnitName()
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)

                if string.find(sCreepName, 'ranged') then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
                end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 and fManaAfter > fManaThreshold1 + 0.1 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.05
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.05
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSandstorm()
	if not J.CanCastAbility(SandStorm) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = SandStorm:GetSpecialValueInt('sand_storm_radius')
	local nManaCost = SandStorm:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Burrowstrike, Stinger, Epicenter})

	if (J.IsNotAttackProjectileIncoming(bot, 400))
	or (J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth())
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsInTeamFight(bot, 1200) then
		if J.IsStunProjectileIncoming(bot, 800) then
			return BOT_ACTION_DESIRE_HIGH
		end

		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius * 0.8)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius * 0.8)
		and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 4.0)
			then
				if (J.IsInRange(bot, enemyHero, nRadius))
				or (#nEnemyHeroes > #nAllyHeroes)
				or (#nEnemyHeroes > #nAllyHeroes)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5 and #nAllyHeroes <= 1)
				or (nLocationAoE.count >= 6 and #nAllyHeroes >= 2)
				then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange( botTarget, bot, nRadius )
        and J.IsAttacking(bot)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderStinger()
	if not J.CanCastAbility(Stinger) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Stinger:GetCastRange())
	local nRadius = Stinger:GetSpecialValueInt('radius')
	local nBonusDamage = Stinger:GetSpecialValueInt('attack_damage')
	local nDamage = bot:GetAttackDamage() + nBonusDamage
	local nManaCost = Stinger:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Burrowstrike, SandStorm, Epicenter})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not J.IsRunning(creep)
			and not J.IsOtherAllysTarget(creep)
			then
                local sCreepName = creep:GetUnitName()
                if string.find(sCreepName, 'ranged') then
                    if J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
                end

				local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count > 0 then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and bAttacking
		and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and bAttacking
		and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEpicenter()
	if not J.CanCastAbility(Epicenter) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = Epicenter:GetCastPoint()
	local nDuration = Epicenter:GetSpecialValueInt('AbilityDuration')
	local nBaseRadius = Epicenter:GetSpecialValueInt('epicenter_radius_base')
	local nPulses = Epicenter:GetSpecialValueInt('epicenter_pulses')
	local nRadiusIncrement = Epicenter:GetSpecialValueInt('epicenter_radius_increment')
	local nRadius = nBaseRadius + nPulses * nRadiusIncrement

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 600)
        or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 600))
        then
            return BOT_ACTION_DESIRE_NONE
        end
    end

	if J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth() then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsInTeamFight( bot, 1600 ) then
		local count = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
				if not J.IsChasingTarget(bot, enemyHero)
				or J.IsDisabled(enemyHero)
				or enemyHero:GetCurrentMovementSpeed() <= 280
				then
					count = count + 1
				end
            end
        end

        if count >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.IsCore(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 900)
			local nInRangeEnemy = J.GetAlliesNearLoc(bot:GetLocation(), 900)
			if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
				if J.IsDisabled(botTarget)
				or botTarget:GetCurrentMovementSpeed() <= 280
				then
					local targetHealth = botTarget:GetHealth() + (botTarget:GetHealthRegen() * (nDuration + nCastPoint))
					local damage1 = J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, nDuration + nCastPoint)
					local damage2 = bot:GetEstimatedDamageToTarget(true, botTarget, nDuration + nCastPoint, DAMAGE_TYPE_ALL)
					if (damage1 > targetHealth and damage2 < targetHealth)
					or (damage2 > targetHealth and J.IsDisabled(botTarget))
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X

