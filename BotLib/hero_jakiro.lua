local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_jakiro'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
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
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {3,1,1,3,1,6,1,3,2,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
			
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_double_null_talisman",
				"item_mjollnir",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_hurricane_pike",--
				"item_devastator",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_hurricane_pike",
				"item_null_talisman", "item_devastator",
				"item_bottle", "item_bloodthorn",
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
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_magic_stick",
				"item_faerie_fire",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_force_staff",
				"item_rod_of_atos",
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_gungir",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_hurricane_pike",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_octarine_core",
			},
        },
    },
    ['pos_5'] = {
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
                [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_magic_stick",
				"item_faerie_fire",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_force_staff",
				"item_rod_of_atos",
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_gungir",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_hurricane_pike",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_octarine_core",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local DualBreath = bot:GetAbilityByName('jakiro_dual_breath')
local IcePath = bot:GetAbilityByName('jakiro_ice_path')
local LiquidFire = bot:GetAbilityByName('jakiro_liquid_fire')
local LiquidFrost = bot:GetAbilityByName('jakiro_liquid_frost')
local Macropyre = bot:GetAbilityByName('jakiro_macropyre')

local DualBreathDesire, DualBreathLocation
local IcePathDesire, IcePathLocation
local LiquidFireDesire, LiquidFireTarget
local LiquidFrostDesire, LiquidFrostTarget
local MacropyreDesire, MacropyreLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	DualBreath = bot:GetAbilityByName('jakiro_dual_breath')
	IcePath = bot:GetAbilityByName('jakiro_ice_path')
	LiquidFire = bot:GetAbilityByName('jakiro_liquid_fire')
	LiquidFrost = bot:GetAbilityByName('jakiro_liquid_frost')
	Macropyre = bot:GetAbilityByName('jakiro_macropyre')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	LiquidFrostDesire, LiquidFrostTarget = X.ConsiderLiquidFrost()
	if LiquidFrostDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(LiquidFrost, LiquidFrostTarget)
		return
	end

	IcePathDesire, IcePathLocation = X.ConsiderIcePath()
	if IcePathDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(IcePath, IcePathLocation)
		return
	end

	MacropyreDesire, MacropyreLocation = X.ConsiderMacropyre()
	if MacropyreDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Macropyre, MacropyreLocation)
		return
	end

	DualBreathDesire, DualBreathLocation = X.ConsiderDualBreath()
	if DualBreathDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(DualBreath, DualBreathLocation)
		return
	end

	LiquidFireDesire, LiquidFireTarget = X.ConsiderLiquidFire()
	if LiquidFireDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(LiquidFire, LiquidFireTarget)
		return
	end
end

function X.ConsiderDualBreath()
	if not J.CanCastAbility(DualBreath) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, DualBreath:GetCastRange())
	local nCastPoint = DualBreath:GetCastPoint()
	local nRadius = DualBreath:GetSpecialValueInt('start_radius')
	local nDuration = DualBreath:GetDuration()
	local nSpeed = DualBreath:GetSpecialValueInt('speed')
	local nDamage = DualBreath:GetSpecialValueInt('burn_damage')
	local nManaCost = DualBreath:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IcePath, LiquidFire, LiquidFrost, Macropyre})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {DualBreath, IcePath, LiquidFire, LiquidFrost, Macropyre})

    for _, enemy in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemy)
		and J.CanBeAttacked(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        and J.CanCastOnNonMagicImmune(enemy)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        and not enemy:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
			local eta = nDuration + (GetUnitToUnitDistance(bot, enemy) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
				return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
			end
        end
    end

	if J.IsInTeamFight(bot, 1300) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_LOW, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange( botTarget, bot, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
					and not enemyHero:IsDisarmed()
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), allyHero:GetLocation(), nRadius * 1.5)
                    end
                end
            end
        end
    end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 then
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
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 1000)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderIcePath()
	if not J.CanCastAbility(IcePath) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, IcePath:GetCastRange())
	local nCastPoint = IcePath:GetCastPoint()
	local manaCost = IcePath:GetManaCost()
	local nRadius = IcePath:GetSpecialValueInt('path_radius')
	local nDelay = IcePath:GetSpecialValueFloat('path_delay')
	local nDamage = IcePath:GetSpecialValueInt('damage')
	local nManaCost = IcePath:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {DualBreath, LiquidFire, LiquidFrost, Macropyre})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {DualBreath, IcePath, LiquidFire, LiquidFrost, Macropyre})

	for _, enemy in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemy)
		and J.IsInRange(bot, enemy, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemy)
		then
			if enemy:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemy, 'modifier_teleporting') > nDelay + nCastPoint then
					return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
				end
			elseif enemy:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange * 0.9)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 and not J.IsInTeamFight(bot, 1200) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
			and J.IsRunning(allyHero)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
					and not enemyHero:IsDisarmed()
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end
                end
            end
        end
    end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 and #nAllyHeroes <= 2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 and #nAllyHeroes <= 2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 6)
				or (nLocationAoE.count >= 4 and string.find(creep:GetUnitName(), 'upgraded'))
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLiquidFire()
	if not J.CanCastAbility(LiquidFire) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = bot:GetAttackRange()
	local nRadius = LiquidFire:GetSpecialValueInt('radius')

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0
		for _, enemy in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and J.IsInRange(bot, enemy, nCastRange + 300)
			and not enemy:IsDisarmed()
			then
				local enemyDamage = enemy:GetAttackDamage() * enemy:GetAttackSpeed()
				if enemyDamage > hTargetDamage then
					hTarget = enemy
					hTargetDamage = enemyDamage
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsValidBuilding(botTarget)
	and J.CanBeAttacked(botTarget)
	and J.IsInRange(bot, botTarget, nCastRange + 300)
	and not J.IsRealInvisible(bot)
	then
		if botTarget:GetHealthRegen() == 0 or #J.GetHeroesTargetingUnit(nAllyHeroes, botTarget) >= 3 then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(1600, nCastRange + 300), true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 1000)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLiquidFrost()
	if not J.CanCastAbility(LiquidFrost) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = bot:GetAttackRange()

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
					and not enemyHero:IsDisarmed()
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMacropyre()
	if not J.CanCastAbility(Macropyre) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = Macropyre:GetCastRange()
	local nCastPoint = Macropyre:GetCastPoint()
	local nRadius = Macropyre:GetSpecialValueInt('path_width')
	local nDamage = Macropyre:GetSpecialValueInt('damage')
	local nDuration = Macropyre:GetSpecialValueInt('duration')

	for _, enemy in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemy)
		and J.CanBeAttacked(enemy)
		and J.IsInRange(bot, enemy, nCastRange + 300)
		and J.GetHP(enemy) > 0.4
		and not J.IsSuspiciousIllusion(enemy)
		then
			if enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
			or enemy:HasModifier('modifier_enigma_black_hole_pull')
			or enemy:HasModifier('modifier_legion_commander_duel')
			then
				return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.9)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nEnemyHeroes) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and not J.IsChasingTarget(bot, enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange * 0.85)
		and J.GetHP(botTarget) > 0.3
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.IsDisabled(botTarget)
			or botTarget:GetCurrentMovementSpeed() < 200
			then
				local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
				if #nInRangeAlly <= 1 and #nInRangeEnemy <= 1 then
					if bot:GetEstimatedDamageToTarget(true, botTarget, nDuration, DAMAGE_TYPE_MAGICAL) > botTarget:GetHealth() then
						return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X