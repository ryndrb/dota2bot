local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_sniper'
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
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_power_treads",
				"item_double_wraith_band",
				"item_maelstrom",
				"item_hurricane_pike",--
				"item_mjollnir",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_lesser_crit",
				"item_satanic",--
				"item_greater_crit",--
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_wraith_band", "item_lesser_crit",
				"item_wraith_band", "item_satanic",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_power_treads",
				"item_double_wraith_band",
				"item_maelstrom",
				"item_hurricane_pike",--
				"item_mjollnir",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_lesser_crit",
				"item_satanic",--
				"item_greater_crit",--
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_wraith_band", "item_lesser_crit",
				"item_wraith_band", "item_satanic",
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

local Shrapnel = bot:GetAbilityByName('sniper_shrapnel')
local Headshot = bot:GetAbilityByName('sniper_headshot')
local TakeAim = bot:GetAbilityByName('sniper_take_aim')
local ConcussiveGrenade = bot:GetAbilityByName('sniper_concussive_grenade')
local Assassinate = bot:GetAbilityByName('sniper_assassinate')

local ShrapnelDesire, ShrapnelLocation
local TakeAimDesire
local ConcussiveGrenadeDesire, ConcussiveGrenadeLocation
local AssassinateDesire, AssassinateTarget

local bAttacking = false
local botTarget, botHP, botAttackRange
local nAllyHeroes, nEnemyHeroes

local sniperShrapnel = { cast_time = DotaTime(), location = nil }

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Shrapnel = bot:GetAbilityByName('sniper_shrapnel')
	TakeAim = bot:GetAbilityByName('sniper_take_aim')
	ConcussiveGrenade = bot:GetAbilityByName('sniper_concussive_grenade')
	Assassinate = bot:GetAbilityByName('sniper_assassinate')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
	botAttackRange =  bot:GetAttackRange()
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	AssassinateDesire, AssassinateTarget = X.ConsiderAssassinate()
	if AssassinateDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Assassinate, AssassinateTarget)
		return
	end

	TakeAimDesire = X.ConsiderTakeAim()
	if TakeAimDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(TakeAim)
		return
	end

	ShrapnelDesire, ShrapnelLocation = X.ConsiderShrapnel()
	if ShrapnelDesire > 0 then
		sniperShrapnel.cast_time = DotaTime()
		sniperShrapnel.location = ShrapnelLocation
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Shrapnel, ShrapnelLocation)
		return
	end

	ConcussiveGrenadeDesire, ConcussiveGrenadeLocation = X.ConsiderConcussiveGrenade()
	if ConcussiveGrenadeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(ConcussiveGrenade, ConcussiveGrenadeLocation)
		return
	end
end

function X.ConsiderShrapnel()
	if not J.CanCastAbility(Shrapnel) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = Shrapnel:GetCastRange()
	local nCastPoint = Shrapnel:GetCastPoint()
	local nRadius = Shrapnel:GetSpecialValueInt('radius')
	local nDamage = Shrapnel:GetSpecialValueInt('shrapnel_damage')
	local nDamageDelay = Shrapnel:GetSpecialValueInt('damage_delay')
	local nDuration = Shrapnel:GetSpecialValueInt('duration')
	local nManaCost = Shrapnel:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TakeAim, ConcussiveGrenade, Assassinate})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Shrapnel, TakeAim, ConcussiveGrenade, Assassinate})

	if DotaTime() < sniperShrapnel.cast_time + nDamageDelay + nCastPoint then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidTarget(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, (nDuration / 2))
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not X.IsShrapnelCastedHere(enemyHero:GetLocation(), nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and fManaAfter > fManaThreshold2
		then
			local vLocation = J.GetCorrectLoc(botTarget, nDamageDelay + nCastPoint)
			if GetUnitToLocationDistance(bot, vLocation) <= nCastRange
			and not X.IsShrapnelCastedHere(vLocation, nRadius)
			then
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, 1000)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_sniper_shrapnel_slow')
            then
				local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if J.CanCastOnNonMagicImmune(enemyHero) or nLocationAoE.count >= 2 then
					if (J.IsChasingTarget(enemyHero, bot))
					or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
					or (botHP < 0.5)
					or bot:IsRooted()
					then
						local vLocation = J.VectorTowards(enemyHero:GetLocation(), bot:GetLocation(), nRadius)
						if not X.IsShrapnelCastedHere(vLocation, nRadius) then
							return BOT_ACTION_DESIRE_HIGH, vLocation
						end
					end
				end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
	local bHasFarmingItem = J.HasItem(bot, 'item_mjollnir')

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and not creep:HasModifier('modifier_sniper_shrapnel_slow')
			then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4 and not bHasFarmingItem)
				or (nLocationAoE.count >= 5)
				then
					if not X.IsShrapnelCastedHere(nLocationAoE.targetloc, nRadius) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and not creep:HasModifier('modifier_sniper_shrapnel_slow')
			then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
				then
					if not X.IsShrapnelCastedHere(nLocationAoE.targetloc, nRadius) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and not creep:HasModifier('modifier_sniper_shrapnel_slow')
			then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3 and not bHasFarmingItem)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep() and not J.CanKillTarget(creep, bot:GetAttackDamage() * 5, DAMAGE_TYPE_PHYSICAL))
                then
					if not X.IsShrapnelCastedHere(nLocationAoE.targetloc, nRadius) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
                end
            end
        end
    end

    if  J.IsLaning(bot) and J.IsInLaningPhase()
	and bot:GetLevel() >= 6
    and fManaAfter > fManaThreshold1
    and bAttacking
	and #nEnemyHeroes == 0
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and not creep:HasModifier('modifier_sniper_shrapnel_slow')
			then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage * nDuration / 2)
		if (nLocationAoE.count >= 6) then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_sniper_shrapnel_slow')
		and not X.IsShrapnelCastedHere(botTarget:GetLocation(), nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange)
		and not botTarget:HasModifier('modifier_sniper_shrapnel_slow')
		and not X.IsShrapnelCastedHere(botTarget:GetLocation(), nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTakeAim()
	if not J.CanCastAbility(TakeAim)
	or bot:IsDisarmed()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nAttackRangeBonus = TakeAim:GetSpecialValueInt('active_attack_range_bonus')
	local nManaCost = TakeAim:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Shrapnel, ConcussiveGrenade, Assassinate})

	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 550)

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange)
		and not J.IsChasingTarget(bot, botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and fManaAfter > fManaThreshold1
		and (#nInRangeEnemy == 0 or not bot:WasRecentlyDamagedByAnyHero(5.0))
		then
			if (GetHeightLevel(bot:GetLocation()) > GetHeightLevel(botTarget:GetLocation()))
			or (J.IsInRange(bot, botTarget, botAttackRange - 150) and bAttacking)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderConcussiveGrenade()
	if not J.CanCastAbility(ConcussiveGrenade) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = ConcussiveGrenade:GetCastRange()
	local nDamage = ConcussiveGrenade:GetSpecialValueInt('damage')
	local nRadius = ConcussiveGrenade:GetSpecialValueInt('radius')
	local nManaCost = ConcussiveGrenade:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Shrapnel, TakeAim, Assassinate})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		then
			local vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), nRadius / 2)
			if J.IsChasingTarget(bot, botTarget) then
				if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			else
				if J.IsInRange(bot, botTarget, nRadius) then
					return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + botTarget:GetLocation()) / 2
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if (J.IsChasingTarget(enemyHero, bot))
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or botHP < 0.55
				then
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end
		end
	end

	if J.IsInTeamFight( bot, 1400 ) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		local count = 0

		for _, enemyHero in pairs(nInRangeEnemy) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			then
				count = count + 1
			end
		end

		if count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAssassinate()
	if not J.CanCastAbility(Assassinate) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = Assassinate:GetCastRange()
	local nCastPoint = Assassinate:GetCastPoint()
	local nDamage = Assassinate:GetSpecialValueInt('damage')
	local nSpeed = Assassinate:GetSpecialValueInt('projectile_speed')

	if not J.IsRetreating(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
				if enemyHero:HasModifier('modifier_teleporting') then
					if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end

				if (not J.IsInRange(bot, enemyHero, botAttackRange))
				or (bot:IsDisarmed())
				then
					if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
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
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
			if (not J.IsInRange(bot, botTarget, botAttackRange))
			or (bot:IsDisarmed())
			then
				if  J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, nCastPoint + 1) < bot:GetHealth()
				and (J.GetHP(botTarget) < 0.5 or #nAllyHeroesAttackingTarget >= 4)
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.IsShrapnelCastedHere(vLocation, nRadius)
	if sniperShrapnel.location then
		if J.GetDistance(vLocation, sniperShrapnel.location) <= nRadius + nRadius / 2 then
			return true
		end
	end

	return false
end

return X
