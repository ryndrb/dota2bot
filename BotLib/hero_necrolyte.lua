local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_necrolyte'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb"}
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
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_boots",
				"item_double_null_talisman",
				"item_radiance",--
				"item_travel_boots",
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_heart",--
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_octarine_core",
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_heart",
				"item_null_talisman", "item_shivas_guard",
				"item_null_talisman", "item_wind_waker",
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
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_boots",
				"item_null_talisman",
				"item_bracer",
				"item_radiance",--
				sUtilityItem,--
				"item_travel_boots",
				"item_aghanims_shard",
				"item_heart",--
				"item_ultimate_scepter",
				"item_shivas_guard",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_heart",
				"item_bracer", "item_ultimate_scepter",
				"item_null_talisman", "item_shivas_guard",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_magic_stick",
				"item_circlet",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_glimmer_cape",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_lotus_orb",--
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_shivas_guard",
				"item_magic_wand", "item_sheepstick",
				"item_blade_mail", "item_wind_waker",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_magic_stick",
				"item_circlet",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_glimmer_cape",--
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_lotus_orb",--
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_shivas_guard",
				"item_magic_wand", "item_sheepstick",
				"item_blade_mail", "item_wind_waker",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_priest' }, {} end

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

local DeathPulse = bot:GetAbilityByName('necrolyte_death_pulse')
local GhostShroud = bot:GetAbilityByName('necrolyte_ghost_shroud')
local HeartstopperAura = bot:GetAbilityByName('necrolyte_heartstopper_aura')
local DeathSeeker = bot:GetAbilityByName('necrolyte_death_seeker')
local RepearsSythe = bot:GetAbilityByName('necrolyte_reapers_scythe')

local DeathPulseDesire
local GhostShroudDesire
local DeathSeekerDesire, DeathSeekerTarget
local RepearsSytheDesire, RepearsSytheTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	DeathPulse = bot:GetAbilityByName('necrolyte_death_pulse')
	GhostShroud = bot:GetAbilityByName('necrolyte_ghost_shroud')
	DeathSeeker = bot:GetAbilityByName('necrolyte_death_seeker')
	RepearsSythe = bot:GetAbilityByName('necrolyte_reapers_scythe')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	RepearsSytheDesire, RepearsSytheTarget = X.ConsiderRepearsSythe()
	if RepearsSytheDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(RepearsSythe, RepearsSytheTarget)
		return
	end

	GhostShroudDesire = X.ConsiderGhostShroud()
	if GhostShroudDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(GhostShroud)
		return
	end

	DeathSeekerDesire, DeathSeekerTarget, De = X.ConsiderDeathSeeker()
	if DeathSeekerDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(DeathSeeker, DeathSeekerTarget)
		return
	end

	DeathPulseDesire = X.ConsiderDeathPulse()
	if DeathPulseDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(DeathPulse)
		return
	end
end

function X.ConsiderDeathPulse()
	if not J.CanCastAbility(DeathPulse) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = DeathPulse:GetSpecialValueInt('area_of_effect')
	local nDamage = DeathPulse:GetSpecialValueInt('#AbilityDamage')
	local nHealPoints = DeathPulse:GetSpecialValueInt('heal')
	local nSpeed = DeathPulse:GetSpecialValueInt('projectile_speed')
	local botMP = J.GetMP(bot)
	local nManaCost = DeathPulse:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {GhostShroud, RepearsSythe})

	local nInRangeAlly = bot:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
	local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nInRangeEnemy) do
		if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and fManaAfter > fManaThreshold1
		then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed)
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
    end

	if J.IsInTeamFight(bot, 1200) then
		local nLowHealthAllyNearby = 0
		for _, allyHero in pairs(nInRangeAlly) do
			if  J.IsValidHero(allyHero)
			and not allyHero:IsIllusion()
			and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not allyHero:HasModifier('modifier_ice_blast')
			then
				if J.GetHP(allyHero) < 0.5 then
					nLowHealthAllyNearby = nLowHealthAllyNearby + 1
				end
			end
		end

		if #nInRangeEnemy >= 2 or nLowHealthAllyNearby >= 1 then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if (J.IsRetreating(bot) or botHP < 0.25) and not J.IsRealInvisible(bot) then
		if (botHP < 0.9 and bot:WasRecentlyDamagedByAnyHero(2.0) and #nInRangeEnemy > 0)
		or (botHP < 0.75 and bot:DistanceFromFountain() < 400 )
		or (botHP < 0.25)
		or (botHP < botMP)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nCreepCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and (creep:GetMaxHealth() - creep:GetHealth()) >= nHealPoints then
				nCreepCount = nCreepCount + 1
			end
		end

		if nCreepCount >= 3 and #nEnemyHeroes <= 1 then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 2)
			or (#nEnemyCreeps >= 1 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded'))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 2)
			or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep())
			or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 500)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep)) then
				local sCreepName = creep:GetUnitName()
				if J.CanKillTarget(creep, nDamage + 2, DAMAGE_TYPE_MAGICAL) then
					if string.find(sCreepName, 'ranged') then
						return BOT_ACTION_DESIRE_HIGH
					end

					if #nInRangeEnemy > 0 or J.IsUnitTargetedByTower(creep, false) then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if not J.IsRetreating(bot) then
		if fManaAfter > fManaThreshold1 then
			local nCanHurtCount = 0
			local nCanKillCount = 0
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					nCanHurtCount = nCanHurtCount + 1
					if J.CanKillTarget(creep, nDamage + 2, DAMAGE_TYPE_MAGICAL) then
						nCanKillCount = nCanKillCount + 1
					end
				end
			end

			local bCanQ = J.IsCore(bot) or not J.IsThereCoreNearby(600)

			if ( nCanKillCount >= 2 and bCanQ )
			or ( nCanKillCount >= 1 and botMP > 0.9 and bCanQ )
			or ( nCanHurtCount >= 3 and not J.IsLaning(bot) )
			or ( nCanHurtCount >= 3 and nCanKillCount >= 1 and bCanQ )
			or ( nCanHurtCount >= 3 and #nEnemyCreeps >= 3 and not J.IsInLaningPhase() )
			or ( nCanHurtCount >= 2 and nCanKillCount >= 1 and not J.IsInLaningPhase() and #nEnemyCreeps == 2 )
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if #nInRangeAlly >= 2 and fManaAfter > fManaThreshold1 then
		local nAllyCount = 0
		for _, allyHero in pairs(nInRangeAlly) do
			if  J.IsValidHero(allyHero)
			and not allyHero:IsIllusion()
			and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not allyHero:HasModifier('modifier_ice_blast')
			and allyHero:GetMaxHealth() - allyHero:GetHealth() > 220
			then
				local allyHP = J.GetHP(allyHero)
				nAllyCount = nAllyCount + 1

				if (allyHP < 0.15)
				or (nAllyCount >= 2 and allyHP < 0.4)
				or (nAllyCount >= 3)
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
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderGhostShroud()
	if not J.CanCastAbility(GhostShroud) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = GhostShroud:GetSpecialValueInt('slow_aoe')
	local nSadistStacks = J.GetModifierCount(bot, 'modifier_necrolyte_sadist_counter')

	if (nSadistStacks >= 8 or bot:GetHealthRegen() > 99)
	and botHP < 0.5
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsRetreating(bot) then
		local nInRangeEnemy = bot:GetNearbyHeroes(nRadius * 1.5, true, BOT_MODE_NONE)
		if (bot:WasRecentlyDamagedByAnyHero(2.0) and #nInRangeEnemy > 0)
		or (botHP < 0.15)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.GetAttackProjectileDamageByRange(bot, 1600) > bot:GetHealth() then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDeathSeeker()
	if not J.CanCastAbility(DeathSeeker) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = DeathSeeker:GetCastRange()
	local nRadius = 500
	local nManaCost = DeathSeeker:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {DeathPulse, GhostShroud, RepearsSythe})

	local nDamage = 100
	if DeathPulse and DeathPulse:IsTrained() then
		nDamage = DeathPulse:GetSpecialValueInt('#AbilityDamage')
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1000)
			local nInRangeEnemy = J.GetAlliesNearLoc(bot:GetLocation(), 1000)
			if (#nInRangeAlly >= #nInRangeEnemy)
			or (math.abs(#nInRangeAlly - #nInRangeEnemy) <= 1 and botHP > 0.55)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	local hTarget = {
		hero 	= { ally = { unit = nil, distance = math.huge }, enemy = { unit = nil, distance = math.huge } },
		creep 	= { ally = { unit = nil, distance = math.huge }, enemy = { unit = nil, distance = math.huge } },
	}

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALL)) do
		if  J.IsValid(unit)
		and bot ~= unit
		and J.IsInRange(bot, unit, nCastRange)
		and J.CanCastOnTargetAdvanced(unit)
		and (unit:IsHero() or unit:IsCreep())
		then
			local distanceUnitToMe = GetUnitToUnitDistance(bot, unit)
			local distanceUnitToFoutain = GetUnitToLocationDistance(unit, J.GetTeamFountain())

			local bAlly = GetTeam() == unit:GetTeam()

			if distanceUnitToFoutain < hTarget.hero.ally.distance and distanceUnitToMe > nCastRange / 2 then
				if unit:IsHero() then
					if bAlly then
						hTarget.hero.ally.unit = unit
						hTarget.hero.ally.distance = distanceUnitToFoutain
					else
						hTarget.hero.enemy.unit = unit
						hTarget.hero.enemy.distance = distanceUnitToFoutain
					end
				end
				if unit:IsCreep() then
					if bAlly then
						hTarget.creep.ally.unit = unit
						hTarget.creep.ally.distance = distanceUnitToFoutain
					else
						hTarget.creep.enemy.unit = unit
						hTarget.creep.enemy.distance = distanceUnitToFoutain
					end
				end
			end
		end
	end

	local target = hTarget.hero.ally.unit or hTarget.creep.ally.unit or hTarget.creep.enemy.unit

	if J.IsStuck(bot) and #nEnemyHeroes == 0 then
		if target then
			return BOT_ACTION_DESIRE_HIGH, target
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if bot:WasRecentlyDamagedByAnyHero(1.0) and #nEnemyHeroes > 0 then
			if target then
				return BOT_ACTION_DESIRE_HIGH, target
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
		if not J.IsInLaningPhase() and (J.IsCore(bot) or not J.IsThereCoreNearby(600)) and #nEnemyHeroes == 0 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if (nLocationAoE.count >= 5) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
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
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderRepearsSythe()
	if not J.CanCastAbility(RepearsSythe) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = RepearsSythe:GetCastRange()
	local nCastPoint = RepearsSythe:GetCastPoint()
	local nDamagePerHealth = RepearsSythe:GetSpecialValueFloat('damage_per_health')

	local hTarget = nil
	local hTargetDamage = 0
	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 400)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not J.IsHaveAegis(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not enemyHero:HasModifier('modifier_arc_warden_tempest_double')
		and not enemyHero:HasModifier('modifier_item_glimmer_cape_fade')
		and enemyHero:GetUnitName() ~= 'npc_dota_hero_medusa'
		then
			local damage = (enemyHero:GetMaxHealth() - enemyHero:GetHealth()) * nDamagePerHealth
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed()) + nCastPoint
			if J.WillKillTarget(enemyHero, damage, DAMAGE_TYPE_MAGICAL, eta) then
				local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end
	end

	if hTarget then
		if J.IsRetreating(bot) then
			if J.IsInRange(bot, hTarget, nCastRange) then
				return BOT_ACTION_DESIRE_HIGH, hTarget
			end
		else
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X
