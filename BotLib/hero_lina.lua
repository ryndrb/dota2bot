local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local M = require( GetScriptDirectory()..'/FunLib/aba_modifiers' )

if GetBot():GetUnitName() == 'npc_dota_hero_lina'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                [1] = {2,3,3,1,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_mantle",
				"item_faerie_fire",
				
				"item_magic_wand",
				"item_arcane_boots",
				"item_null_talisman",
				"item_falcon_blade",
				"item_maelstrom",
				"item_dragon_lance",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_aghanims_shard",
				"item_hurricane_pike",--
				"item_greater_crit",--
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_greater_crit",
				"item_falcon_blade", "item_satanic",
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
                [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_boots",
				"item_null_talisman",
				"item_kaya",
				"item_travel_boots",
				"item_ultimate_scepter",
				"item_yasha_and_kaya",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_cyclone",
				"item_octarine_core",--
				"item_wind_waker",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_cyclone",
				"item_bottle", "item_octarine_core",
			},
        },
		[2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_mantle",
				"item_faerie_fire",
				
				"item_bottle",
				"item_magic_wand",
				"item_arcane_boots",
				"item_null_talisman",
				"item_falcon_blade",
				"item_maelstrom",
				"item_dragon_lance",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_aghanims_shard",
				"item_hurricane_pike",--
				"item_greater_crit",--
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_dragon_lance",
				"item_null_talisman", "item_black_king_bar",
				"item_bottle", "item_greater_crit",
				"item_falcon_blade", "item_satanic",
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_blood_grenade",
				"item_magic_stick",
				"item_double_branches",
				"item_faerie_fire",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_cyclone",
				"item_ancient_janggo",
				"item_rod_of_atos",
				"item_force_staff",
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_sheepstick",--
				"item_octarine_core",--
				"item_gungir",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
				"item_hurricane_pike",--
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_blood_grenade",
				"item_magic_stick",
				"item_double_branches",
				"item_faerie_fire",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_cyclone",
				"item_mekansm",
				"item_rod_of_atos",
				"item_force_staff",
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_sheepstick",--
				"item_octarine_core",--
				"item_gungir",--
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
				"item_hurricane_pike",--
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

local DragonSlave = bot:GetAbilityByName('lina_dragon_slave')
local LightStrikeArray = bot:GetAbilityByName('lina_light_strike_array')
local FierySoul = bot:GetAbilityByName('lina_fiery_soul')
local FlameCloak = bot:GetAbilityByName('lina_flame_cloak')
local LagunaBlade = bot:GetAbilityByName('lina_laguna_blade')

local DragonSlaveDesire, DragonSlaveLocation
local LightStrikeArrayDesire, LightStrikeArrayLocation
local FlameCloakDesire
local LagunaBladeDesire, LagunaBladeTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	DragonSlave = bot:GetAbilityByName('lina_dragon_slave')
	LightStrikeArray = bot:GetAbilityByName('lina_light_strike_array')
	FlameCloak = bot:GetAbilityByName('lina_flame_cloak')
	LagunaBlade = bot:GetAbilityByName('lina_laguna_blade')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	FlameCloakDesire = X.ConsiderFlameCloak()
	if FlameCloakDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(FlameCloak)
		return
	end

	LagunaBladeDesire, LagunaBladeTarget = X.ConsiderLagunaBlade()
	if LagunaBladeDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		local EtherealBlade = bot:GetItemInSlot(bot:FindItemSlot('item_ethereal_blade'))
		if J.CanCastAbility(EtherealBlade) and (bot:GetMana() > (EtherealBlade:GetManaCost() + LagunaBlade:GetManaCost() + 100)) then
			local nCastRange = EtherealBlade:GetCastRange()
			local nCastPoint = EtherealBlade:GetCastPoint()
			local nSpeed = EtherealBlade:GetSpecialValueInt('projectile_speed')

			if J.IsInRange(bot, LagunaBladeTarget, nCastRange) then
				bot:ActionQueue_UseAbilityOnEntity(EtherealBlade, LagunaBladeTarget)
				bot:ActionQueue_Delay((GetUnitToUnitDistance(bot, LagunaBladeTarget) / nSpeed) + nCastPoint)
				bot:ActionQueue_UseAbilityOnEntity(LagunaBlade, LagunaBladeTarget)
				return
			end
		end

		bot:ActionQueue_UseAbilityOnEntity(LagunaBlade, LagunaBladeTarget)
		return
	end

	DragonSlaveDesire, DragonSlaveLocation = X.ConsiderDragonSlave()
	if DragonSlaveDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(DragonSlave, DragonSlaveLocation)
		return
	end

	LightStrikeArrayDesire, LightStrikeArrayLocation = X.ConsiderLightStrikeArray()
	if LightStrikeArrayDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(LightStrikeArray, LightStrikeArrayLocation)
		return
	end
end

function X.ConsiderDragonSlave()
	if not J.CanCastAbility(DragonSlave) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = DragonSlave:GetCastRange()
	local nCastPoint = DragonSlave:GetCastPoint()
	local nDistance = DragonSlave:GetSpecialValueInt('dragon_slave_distance')
	local nDamage = DragonSlave:GetSpecialValueInt('dragon_slave_damage')
	local nRadius = DragonSlave:GetSpecialValueInt('dragon_slave_width_end')
	local nSpeed = DragonSlave:GetSpecialValueInt('dragon_slave_speed')
	local nManaCost = DragonSlave:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {LightStrikeArray, FlameCloak, LagunaBlade})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {DragonSlave, LightStrikeArray, FlameCloak, LagunaBlade})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
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
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
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
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) and fManaAfter > fManaThreshold1 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange / 2)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			then
				if bot:IsRooted() then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
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

		if not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(600)) then
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

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
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
					if #nInRangeEnemy > 0 then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
					end

					for _, enemyHero in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
						and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
						then
							if X.IsUnitBetweenLocation(creep, bot:GetLocation(), enemyHero:GetLocation(), nRadius) then
								return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
							end
						end
					end

					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, 600, 0, nDamage)
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

function X.ConsiderLightStrikeArray()
	if not J.CanCastAbility(LightStrikeArray) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = LightStrikeArray:GetCastRange()
	local nCastPoint = LightStrikeArray:GetCastPoint()
	local nRadius 	 = LightStrikeArray:GetSpecialValueInt('light_strike_array_aoe')
	local nDelay = LightStrikeArray:GetSpecialValueFloat('light_strike_array_delay_time') + nCastPoint
	local nDamage = LightStrikeArray:GetSpecialValueInt('light_strike_array_damage')
	local nManaCost = LightStrikeArray:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {DragonSlave, FlameCloak, LagunaBlade})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {DragonSlave, LightStrikeArray, FlameCloak, LagunaBlade})

	local nAllyTowers = bot:GetNearbyTowers(1600, false)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nDelay then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            and not enemyHero:HasModifier('modifier_ursa_enrage')
            then
                if J.IsDisabled(enemyHero) or enemyHero:GetCurrentMovementSpeed() < 250 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end

				if enemyHero:GetMovementDirectionStability() >= 0.95 then
					return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
				end
            end

			if J.IsInLaningPhase() and not J.IsRetreating(bot) then
				if J.IsValidBuilding(nAllyTowers[1]) and J.IsInRange(nAllyTowers[1], enemyHero, 400) then
					if nAllyTowers[1]:GetAttackTarget() == enemyHero then
						return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
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
                and not J.IsChasingTarget(bot, enemyHero)
                then
                    for i = 0, enemyHero:NumModifiers() do
                        local sModifierName = enemyHero:GetModifierName(i)
                        if sModifierName then
                            local fRemainingDuration = enemyHero:GetModifierRemainingDuration(i)
                            if M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName]
                            or M['stunned_unique'] and M['stunned_unique'][sModifierName]
                            or M['hexed'] and M['hexed'][sModifierName]
                            or M['rooted'] and M['rooted'][sModifierName]
                            or M['stunned'] and M['stunned'][sModifierName]
                            then
                                if (fRemainingDuration < nDelay and fRemainingDuration > nCastPoint)
								or (fRemainingDuration > nDelay and fRemainingDuration < nDelay + 1)
								then
                                    count = count + 1
                                end
                            end
                        end
                    end

					if enemyHero:GetCurrentMovementSpeed() < 250
					or enemyHero:GetMovementDirectionStability() >= 0.95
					then
						count = count + 1
					end
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
        and not J.IsChasingTarget(bot, botTarget)
        then
            for i = 0, botTarget:NumModifiers() do
                local sModifierName = botTarget:GetModifierName(i)
                if sModifierName then
                    local fRemainingDuration = botTarget:GetModifierRemainingDuration(i)
                    if M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName]
                    or M['stunned_unique'] and M['stunned_unique'][sModifierName]
                    or M['hexed'] and M['hexed'][sModifierName]
                    or M['rooted'] and M['rooted'][sModifierName]
                    or M['stunned'] and M['stunned'][sModifierName]
                    then
                        if (fRemainingDuration < nDelay and fRemainingDuration > nCastPoint)
						or (fRemainingDuration > nDelay and fRemainingDuration < nDelay + 1)
						then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    end
                end
            end

            if botTarget:GetCurrentMovementSpeed() < 250 then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
				if bot:WasRecentlyDamagedByAnyHero(2.0)
				or J.IsChasingTarget(enemyHero, bot)
				or bot:IsRooted()
				then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), bot:GetLocation(), nRadius)
				end
            end
        end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if fManaAfter > fManaThreshold2 and #nAllyHeroes >= #nEnemyHeroes then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
			if nLocationAoE.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end

		if not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(600)) then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
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
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
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

function X.ConsiderFlameCloak()
	if not J.CanCastAbility(FlameCloak) then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			if J.IsInTeamFight(bot, 1200) then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.CanBeAttacked(botTarget)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
			and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
			and not botTarget:HasModifier('modifier_ursa_enrage')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if bot:WasRecentlyDamagedByAnyHero(2.0) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLagunaBlade()
	if not J.CanCastAbility(LagunaBlade) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = LagunaBlade:GetCastRange()
	local nCastPoint = LagunaBlade:GetCastPoint()
	local nDamage = LagunaBlade:GetSpecialValueInt('damage')
	local nDelay = LagunaBlade:GetSpecialValueFloat('damage_delay')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay + nCastPoint)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_item_glimmer_cape_fade')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetScore = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_item_glimmer_cape_fade')
			then
				local enemyHeroScore = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL) / enemyHero:GetHealth()
				if enemyHeroScore > hTargetScore then
					return BOT_ACTION_DESIRE_HIGH, hTarget
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_item_glimmer_cape_fade')
        then
			if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 5.0) > botTarget:GetHealth() then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
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
