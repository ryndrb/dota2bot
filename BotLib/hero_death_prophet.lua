local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_death_prophet'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_lotus_orb", "item_heavens_halberd"}
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_spirit_vessel",--
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_kaya_and_sange",--
				"item_shivas_guard",--
				"item_aghanims_shard",
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_kaya_and_sange",
				"item_bottle", "item_shivas_guard",
				"item_spirit_vessel", "item_wind_waker",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,1,3,6,3,2,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_magic_stick",
			
				"item_null_talisman",
				"item_magic_wand",
				"item_arcane_boots",
				"item_spirit_vessel",
				"item_pipe",--
				"item_shivas_guard",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				sUtilityItem,--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", sUtilityItem,
				"item_spirit_vessel", "item_sheepstick",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_ring_of_protection",
			
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_tranquil_boots",
				"item_glimmer_cape",--
				"item_spirit_vessel",
				"item_ultimate_scepter",
				"item_boots_of_bearing",--
				"item_sheepstick",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_shivas_guard",
				"item_spirit_vessel", "item_wind_waker",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_ring_of_protection",
			
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_arcane_boots",
				"item_glimmer_cape",--
				"item_spirit_vessel",
				"item_ultimate_scepter",
				"item_guardian_greaves",--
				"item_sheepstick",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_shivas_guard",
				"item_spirit_vessel", "item_wind_waker",
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

X['bDeafaultAbility'] = true
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		local sUnitName = hMinionUnit:GetUnitName()
		if sUnitName ~= "npc_dota_death_prophet_torment"
			and sUnitName ~= "dota_death_prophet_exorcism_spirit"
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

end

local CryptSwarm = bot:GetAbilityByName('death_prophet_carrion_swarm')
local Silence = bot:GetAbilityByName('death_prophet_silence')
local SpiritSiphon = bot:GetAbilityByName('death_prophet_spirit_siphon')
local Exorcism = bot:GetAbilityByName('death_prophet_exorcism')

local CryptSwarmDesire, CryptSwarmLocation
local SilenceDesire, SilenceLocation
local SpiritSiphonDesire, SpiritSiphonTarget
local ExorcismDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot)then return end

	CryptSwarm = bot:GetAbilityByName('death_prophet_carrion_swarm')
	Silence = bot:GetAbilityByName('death_prophet_silence')
	SpiritSiphon = bot:GetAbilityByName('death_prophet_spirit_siphon')
	Exorcism = bot:GetAbilityByName('death_prophet_exorcism')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	SilenceDesire, SilenceLocation = X.ConsiderSilence()
	if SilenceDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Silence, SilenceLocation)
		return
	end

	ExorcismDesire = X.ConsiderExorcism()
	if ExorcismDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Exorcism)
		return
	end

	SpiritSiphonDesire, SpiritSiphonTarget = X.ConsiderSpiritSiphon()
	if SpiritSiphonDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(SpiritSiphon, SpiritSiphonTarget)
		return
	end

	CryptSwarmDesire, CryptSwarmLocation = X.ConsiderCryptSwarm()
	if CryptSwarmDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(CryptSwarm, CryptSwarmLocation)
		return
	end
end

function X.ConsiderCryptSwarm()
	if not J.CanCastAbility(CryptSwarm) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, CryptSwarm:GetCastRange())
	local nCastPoint = CryptSwarm:GetCastPoint()
	local nDamage = CryptSwarm:GetSpecialValueInt('damage')
	local nRadiusStart = CryptSwarm:GetSpecialValueInt('start_radius')
	local nRadiusEnd = CryptSwarm:GetSpecialValueInt('end_radius')
	local nSpeed = CryptSwarm:GetSpecialValueInt('speed')
	local nManaCost = CryptSwarm:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Silence, SpiritSiphon, Exorcism})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {CryptSwarm, Silence, SpiritSiphon, Exorcism})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, 400)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and bot:IsFacingLocation(enemyHero:GetLocation(), 30)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadiusEnd, 0, 0)
                if (nLocationAoE.count >= 2)
				or (nLocationAoE.count >= 1 and creep:GetHealth() > nDamage + bot:GetAttackDamage())
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadiusEnd, 0, 0)
                if (nLocationAoE.count >= 2)
				or (nLocationAoE.count >= 1 and creep:GetHealth() > nDamage + bot:GetAttackDamage())
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadiusEnd, 0, 0)
		if nLocationAoE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadiusEnd, 0, 0)
                if (nLocationAoE.count >= 2)
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
			and not J.IsOtherAllysTarget(creep)
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					local sCreepName = creep:GetUnitName()
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)

					if string.find(sCreepName, 'ranged') then
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1000) then
							return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
						end
					end

					local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadiusEnd)
					if #nInRangeEnemy > 0 then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
					end

					for _, enemyHero in pairs(nEnemyHeroes) do
						if  J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
						and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
						then
							if X.IsUnitBetweenLocation(creep, bot:GetLocation(), enemyHero:GetLocation(), nRadiusEnd) then
								return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
							end
						end
					end

					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadiusEnd, 0, nDamage)
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

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSilence()
	if not J.CanCastAbility(Silence) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Silence:GetCastRange())
	local nCastPoint = Silence:GetCastPoint()
	local nRadius = Silence:GetSpecialValueInt('radius')
	local nSpeed = Silence:GetSpecialValueInt('projectile_speed')
	local nManaCost = Silence:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Exorcism})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius - enemyHero:GetBoundingRadius())
        and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_teleporting')
		and enemyHero:IsChanneling()
		and fManaAfter > fManaThreshold1
        then
			local distance =  GetUnitToUnitDistance(bot, enemyHero)
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), Min(distance, nCastRange))
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_death_prophet_silence')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:IsSilenced()
		and fManaAfter > fManaThreshold1
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSpiritSiphon()
	if not J.CanCastAbility(SpiritSiphon) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, SpiritSiphon:GetCastRange())

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_death_prophet_spirit_siphon_slow')
		then
			if bot:GetCurrentMovementSpeed() >= botTarget:GetCurrentMovementSpeed()
			or J.IsDisabled(botTarget)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_death_prophet_spirit_siphon_slow')
			then
				if bot:GetCurrentMovementSpeed() >= botTarget:GetCurrentMovementSpeed()
				or J.IsDisabled(enemyHero)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_death_prophet_spirit_siphon_slow')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				if enemyHero:GetCurrentMovementSpeed() >= bot:GetCurrentMovementSpeed()
				or bot:IsRooted()
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderExorcism()
	if not J.CanCastAbility(Exorcism)
	or bot:HasModifier( 'modifier_death_prophet_exorcism' )
    then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Exorcism:GetSpecialValueInt('radius')

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
        then
			if  J.IsInRange(bot, botTarget, nRadius)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.IsInTeamFight(bot, 1200) and J.IsInRange(bot, botTarget, 1200) then
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
				if #nInRangeEnemy >= 2 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
        end
    end

    local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(800, false)
    if J.IsPushing(bot) and bAttacking then
        if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not botTarget:HasModifier('modifier_backdoor_protection')
		and #nAllyLaneCreeps >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.IsUnitBetweenLocation(hUnit, vStart, vEnd, nRadius)
	if J.IsValid(hUnit) then
		local tResult = PointToLineDistance(vStart, vEnd, hUnit:GetLocation())
		if tResult and tResult.within and tResult.distance <= nRadius then
			return true
		end
	end

	return false
end

return X