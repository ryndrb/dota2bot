local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_lion'
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
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_blood_grenade",
				"item_faerie_fire",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_blink",
				"item_ancient_janggo",
				"item_aghanims_shard",
				"item_aether_lens",
				"item_boots_of_bearing",--
				"item_aeon_disk",--
				"item_ultimate_scepter",
				"item_ethereal_blade",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_arcane_blink",--
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_blood_grenade",
				"item_faerie_fire",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_blink",
				"item_mekansm",
				"item_aghanims_shard",
				"item_aether_lens",
				"item_guardian_greaves",--
				"item_aeon_disk",--
				"item_ultimate_scepter",
				"item_ethereal_blade",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_arcane_blink",--
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
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

local EarthSpike = bot:GetAbilityByName('lion_impale')
local Hex = bot:GetAbilityByName('lion_voodoo')
local ManaDrain = bot:GetAbilityByName('lion_mana_drain')
local FingerOfDeath = bot:GetAbilityByName('lion_finger_of_death')

local EarthSpikeDesire, EarthSpikeLocation
local HexDesire, HexTarget
local ManaDrainDesire, ManaDrainTarget
local FingerOfDeathDesire, FingerOfDeathTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local fEarthSpikeDelay = 0

function X.SkillsComplement()
	bot = GetBot()

	EarthSpike = bot:GetAbilityByName('lion_impale')
	Hex = bot:GetAbilityByName('lion_voodoo')
	ManaDrain = bot:GetAbilityByName('lion_mana_drain')
	FingerOfDeath = bot:GetAbilityByName('lion_finger_of_death')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if ManaDrain and ManaDrain:IsTrained() and ManaDrain:IsChanneling() then
		if J.IsValid(ManaDrainTarget) then
			if ManaDrainTarget:GetTeam() == GetTeam() then
				if (J.GetMP(ManaDrainTarget) >= 0.9)
				or (J.GetMP(bot) < 0.5)
				then
					bot:Action_ClearActions(true)
					return
				end
			else
				if J.GetMP(bot) >= 0.95 then
					bot:Action_ClearActions(true)
					return
				end

				if ManaDrainTarget:HasModifier('modifier_teleporting') then
					if J.CanCastAbility(EarthSpike) or J.CanCastAbility(Hex) then
						bot:Action_ClearActions(true)
						return
					end
				end
			end
		end

		if botHP < 0.3 and J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(1.0) then
			bot:Action_ClearActions(true)
			return
		end

		if botHP < 0.5 then
			local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
			if J.GetTotalEstimatedDamageToTarget(nEnemyHeroesTargetingMe, bot, 5.0) > bot:GetHealth() then
				bot:Action_ClearActions(true)
				return
			end
		end
	end

	if J.CanNotUseAbility(bot) then return end

	if not (ManaDrain and ManaDrain:IsTrained() and ManaDrain:IsChanneling()) then
		ManaDrainDesire, ManaDrainTarget = X.ConsiderManaDrain()
		if ManaDrainDesire > 0 then
			bot:Action_ClearActions(false)
			bot:ActionQueue_UseAbilityOnEntity(ManaDrain, ManaDrainTarget)
			return
		end
	end

	FingerOfDeathDesire, FingerOfDeathTarget = X.ConsiderFingerOfDeath()
	if FingerOfDeathDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		local EtherealBlade = bot:GetItemInSlot(bot:FindItemSlot('item_ethereal_blade'))
		if J.CanCastAbility(EtherealBlade) and (bot:GetMana() > (EtherealBlade:GetManaCost() + FingerOfDeath:GetManaCost() + 100)) then
			local nCastRange = EtherealBlade:GetCastRange()
			local nCastPoint = EtherealBlade:GetCastPoint()
			local nSpeed = EtherealBlade:GetSpecialValueInt('projectile_speed')

			if J.IsInRange(bot, FingerOfDeathTarget, nCastRange) then
				bot:ActionQueue_UseAbilityOnEntity(EtherealBlade, FingerOfDeathTarget)
				bot:ActionQueue_Delay((GetUnitToUnitDistance(bot, FingerOfDeathTarget) / nSpeed) + nCastPoint)
				bot:ActionQueue_UseAbilityOnEntity(FingerOfDeath, FingerOfDeathTarget)
				return
			end
		end

		bot:ActionQueue_UseAbilityOnEntity(FingerOfDeath, FingerOfDeathTarget)
		return
	end

	HexDesire, HexTarget, bAoE = X.ConsiderHex()
	if HexDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		if bAoE then
			bot:ActionQueue_UseAbilityOnLocation(Hex, HexTarget)
			return
		end

		if J.CheckBitfieldFlag(Hex:GetBehavior(), ABILITY_BEHAVIOR_POINT) then
			bot:ActionQueue_UseAbilityOnLocation(Hex, HexTarget:GetLocation())
		else
			bot:ActionQueue_UseAbilityOnEntity(Hex, HexTarget)
		end

		return
	end

	EarthSpikeDesire, EarthSpikeLocation = X.ConsiderEarthSpike()
	if EarthSpikeDesire > 0 then
		if EarthSpikeLocation then
			local nCastPoint = EarthSpike:GetCastPoint()
			local nSpeed = EarthSpike:GetSpecialValueInt('speed')
			fEarthSpikeDelay = (GetUnitToLocationDistance(bot, EarthSpikeLocation) / nSpeed) + nCastPoint
		end

		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(EarthSpike, EarthSpikeLocation)
		return
	end
end

function X.ConsiderEarthSpike()
	if not J.CanCastAbility(EarthSpike) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = EarthSpike:GetCastRange()
	local nCastPoint = EarthSpike:GetCastPoint()
	local nRadius = EarthSpike:GetSpecialValueInt('width')
	local nDamage = EarthSpike:GetSpecialValueInt('damage')
	local nSpeed = EarthSpike:GetSpecialValueInt('speed')
	local nManaCost = EarthSpike:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Hex, FingerOfDeath})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EarthSpike, Hex, FingerOfDeath})

	local nAllyTowers = bot:GetNearbyTowers(1600, false)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.IsInRange(bot, enemyHero, nCastRange + 350) then
				if enemyHero:HasModifier('modifier_teleporting') then
					if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
						return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
					end
				elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end

			if J.IsInRange(bot, enemyHero, nCastRange) then
				if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end

				if J.IsInLaningPhase() and not J.IsRetreating(bot) then
					if J.IsValidBuilding(nAllyTowers[1]) and J.IsInRange(nAllyTowers[1], enemyHero, 400) then
						if nAllyTowers[1]:GetAttackTarget() == enemyHero then
							return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
						end
					end
				end
			end
        end
    end

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + 300, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
				and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
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
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange - 75)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), allyHero:GetLocation(), nRadius)
                    end
                end
            end
        end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if fManaAfter > fManaThreshold2 and #nAllyHeroes >= #nEnemyHeroes then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius + 50, 0, 0)
			if nLocationAoE.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end

		if not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(600)) and #nEnemyHeroes == 0 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if (nLocationAoE.count >= 3) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end
	end

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
                then
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
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
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
			and (J.IsCore(bot) or not J.IsThereCoreInLocation(creep:GetLocation(), 550))
			and not J.IsOtherAllysTarget(creep)
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					local sCreepName = creep:GetUnitName()
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)

					if string.find(sCreepName, 'ranged') then
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
							return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
						end
					end

					local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)
					if J.IsValidHero(nInRangeEnemy[1]) and J.GetHP(nInRangeEnemy[1]) < 0.4 then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
					end

					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderHex()
	if not J.CanCastAbility(Hex) then
		return BOT_ACTION_DESIRE_NONE, nil, false
	end

	if EarthSpike and EarthSpike:IsTrained() and (EarthSpike:GetCooldown() - EarthSpike:GetCooldownTimeRemaining()) <= fEarthSpikeDelay then
		return BOT_ACTION_DESIRE_NONE, nil, false
	end

	local nCastRange = Hex:GetCastRange()
	local nRadius = Hex:GetSpecialValueInt('radius')
	local bIsAoE = J.CheckBitfieldFlag(Hex:GetBehavior(), ABILITY_BEHAVIOR_POINT)
	local nManaCost = Hex:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EarthSpike, FingerOfDeath})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and (J.CanCastOnTargetAdvanced(enemyHero) or bAoE)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			if enemyHero:IsChanneling() or enemyHero:IsCastingAbility() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, false
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		if bIsAoE then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + 250, nRadius, 0, 0)
			local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
				and not J.IsDisabled(enemyHero)
                then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
			end
		end

		local hTarget = nil
		local hTargetDamge = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and (J.CanCastOnTargetAdvanced(enemyHero) or bAoE)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 3.0, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamge then
					hTarget = enemyHero
					hTargetDamge = enemyHeroDamage
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget, false
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
		and J.CanCastOnNonMagicImmune(botTarget)
		and (J.CanCastOnTargetAdvanced(botTarget) or bAoE)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, false
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and (J.CanCastOnTargetAdvanced(enemyHero) or bAoE)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, false
			end
		end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
					and (J.CanCastOnTargetAdvanced(enemyHero) or bAoE)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero, false
                    end
                end
            end
        end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, false
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil, false
end

function X.ConsiderManaDrain()
	if not J.CanCastAbility(ManaDrain) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ManaDrain:GetCastRange()
	local nDuration = ManaDrain:GetSpecialValueFloat('duration')
	local nManaDrain = ManaDrain:GetSpecialValueInt('mana_per_second') * nDuration
	local nLostMana = bot:GetMaxMana() - bot:GetMana()

	local nEnemyTowers = bot:GetNearbyTowers(1000, true)

	if not J.IsRetreating(bot) then
		if  #nEnemyHeroes == 0
		and #nEnemyTowers == 0
		and not J.IsRetreating(bot)
		and not bot:WasRecentlyDamagedByAnyHero(2.0)
		then
			if (nLostMana > nManaDrain + bot:GetManaRegen() * nDuration)
			or (nLostMana > 500)
			then
				local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
				for _, creep in pairs(nEnemyCreeps) do
					if J.IsValid(creep)
					and J.CanCastOnNonMagicImmune(creep)
					and J.CanCastOnTargetAdvanced(creep)
					then
						if (creep:GetMana() > nManaDrain * 0.8 or creep:GetMana() > 350) then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end
				end
			end

			if  not bot:WasRecentlyDamagedByAnyHero(5.0)
			and not bot:WasRecentlyDamagedByTower(5.0)
			and not J.IsGoingOnSomeone(bot)
			and J.GetMP(bot) > 0.6
			then
				local hAllyTarget = nil
				local hAllyTargetMana = math.huge
				for i = 1, 5 do
					local allyHero = GetTeamMember(i)

					if J.IsValidHero(allyHero)
					and bot ~= allyHero
					and J.IsInRange(bot, allyHero, nCastRange * 0.75)
					and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
					and allyHero:GetMaxMana() > 0
					and (J.GetMP(allyHero) + ((allyHero:GetManaRegen() * nDuration) / allyHero:GetMaxMana())) < 0.65
					then
						local allyHeroMana = allyHero:GetMana()
						if allyHeroMana < hAllyTargetMana then
							hAllyTarget = allyHero
							hAllyTargetMana = allyHeroMana
						end
					end
				end

				if hAllyTarget then
					return BOT_ACTION_DESIRE_HIGH, hAllyTarget
				end
			end
		end

		if not J.IsGoingOnSomeone(bot) then
			local hTarget = nil
			local hTargetHealth = 0
			local nIllusionCount = 0

			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and enemyHero:GetUnitName() ~= 'npc_dota_hero_chaos_knight'
				and enemyHero:GetUnitName() ~= 'npc_dota_hero_vengefulspirit'
				and J.IsInRange(bot, enemyHero, nCastRange)
				and J.IsSuspiciousIllusion(enemyHero)
				then
					nIllusionCount = nIllusionCount + 1
					if enemyHero:GetHealth() > hTargetHealth then
						hTarget = enemyHero
						hTargetHealth = enemyHero:GetHealth()
					end
				end
			end

			if hTarget and (nIllusionCount >= 2 or J.GetHP(hTarget) >= 0.9) then
				return BOT_ACTION_DESIRE_HIGH, hTarget
			end
		end
	end

	if X.IsOtherAbilityFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	if J.IsInTeamFight(bot, 1200) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and enemyHero:GetMana() > 200
			and J.CanCastOnMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			then
				if bot:IsMagicImmune()
				or not J.IsStunProjectileIncoming(bot, 550)
				then
					if not J.IsChasingTarget(bot, enemyHero)
					or J.IsInRange(bot, enemyHero, nCastRange * 0.4)
					or J.IsDisabled(enemyHero)
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and botTarget:GetMana() > 200
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		then
			if bot:IsMagicImmune()
			or not J.IsStunProjectileIncoming(bot, 550)
			then
				if not J.IsChasingTarget(bot, botTarget)
				or J.IsInRange(bot, botTarget, nCastRange * 0.4)
				or J.IsDisabled(botTarget)
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderFingerOfDeath()
	if not J.CanCastAbility(FingerOfDeath) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = FingerOfDeath:GetCastRange()
	local nCastPoint = FingerOfDeath:GetCastPoint()
	local nRadius = FingerOfDeath:GetSpecialValueInt('splash_radius_scepter')
	local nDelay = FingerOfDeath:GetSpecialValueFloat('damage_delay')
	local nDamage = FingerOfDeath:GetSpecialValueInt('damage')
	local nDamageBonus = FingerOfDeath:GetSpecialValueInt('damage_per_kill')
	local nGracePeriod = FingerOfDeath:GetSpecialValueInt('grace_period')
	local nManaCost = FingerOfDeath:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EarthSpike, Hex, FingerOfDeath})

	nDamage = nDamage + nDamageBonus * J.GetModifierCount(bot, 'modifier_lion_finger_of_death_kill_counter')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay + nCastPoint)
		and not J.IsHaveAegis(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not enemyHero:HasModifier('modifier_item_glimmer_cape_fade')
        then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange + 300)
		if #nInRangeEnemy >= 2 and bot:HasScepter() then
			local hTarget = nil
			local hTargetNearbyAllyCount = 0
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange + 300)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and J.CanCastOnTargetAdvanced(enemyHero)
				and not J.IsHaveAegis(enemyHero)
				then
					local nNearbyAllyCount = 0
					for _, enemyHeroAlly in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHeroAlly)
						and enemyHero ~= enemyHeroAlly
						and J.CanBeAttacked(enemyHeroAlly)
						and J.IsInRange(enemyHero, enemyHeroAlly, nRadius)
						and not enemyHeroAlly:HasModifier('modifier_abaddon_borrowed_time')
						and not enemyHeroAlly:HasModifier('modifier_dazzle_shallow_grave')
						and not enemyHeroAlly:HasModifier('modifier_item_glimmer_cape_fade')
						then
							nNearbyAllyCount = nNearbyAllyCount + 1
						end
					end

					if nNearbyAllyCount > hTargetNearbyAllyCount and J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, nGracePeriod) > enemyHero:GetHealth() then
						hTarget = enemyHero
						hTargetNearbyAllyCount = nNearbyAllyCount
					end
				end
			end

			if hTarget then
				if hTargetNearbyAllyCount >= 3 or (hTargetNearbyAllyCount >= 3 and botHP < 0.4) then
					bot:SetTarget(hTarget)
					return BOT_ACTION_DESIRE_HIGH, hTarget
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsHaveAegis(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		and not botTarget:HasModifier('modifier_item_glimmer_cape_fade')
		and J.GetHP(botTarget) < 0.5
		and not (#nAllyHeroes >= #nEnemyHeroes + 3)
		then
			if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, nGracePeriod) then
				bot:SetTarget(botTarget)
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if bot:HasScepter() then
		local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

		if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 1 and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if (nLocationAoE.count >= 5) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end

		if J.IsDefending(bot) and bAttacking and #nAllyHeroes <= 2 and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if (nLocationAoE.count >= 5)
					or (nLocationAoE.count >= 4 and string.find(creep:GetUnitName(), 'upgraded'))
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end

		if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 1 and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if (nLocationAoE.count >= 5)
					or (nLocationAoE.count >= 3 and creep:IsAncientCreep())
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end

		if J.IsDoingRoshan(bot) then
			if J.IsRoshan(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.GetHP(botTarget) > 0.2
			and #nEnemyHeroes == 0
			and bAttacking
			and fManaAfter > fManaThreshold1 + 0.1
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.IsOtherAbilityFullyCastable()
	return J.CanCastAbility(EarthSpike) or J.CanCastAbility(Hex) or J.CanCastAbility(FingerOfDeath)
end

return X
