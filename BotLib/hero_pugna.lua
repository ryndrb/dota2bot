local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_pugna'
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_faerie_fire",
				"item_tango",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_aether_lens",
				"item_blink",
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_ultimate_scepter_2",
				"item_octarine_core",--
				"item_travel_boots",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_shivas_guard",
				"item_null_talisman", "item_sheepstick",
				"item_bottle", "item_black_king_bar",
				"item_aether_lens", "item_octarine_core",
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,2,2,2,3,6,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_magic_stick",
				"item_blood_grenade",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_aether_lens",
				"item_ancient_janggo",
				"item_ultimate_scepter",
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_lotus_orb",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_lotus_orb",
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
                [1] = {1,3,1,2,1,6,1,2,2,2,3,6,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_magic_stick",
				"item_blood_grenade",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_aether_lens",
				"item_mekansm",
				"item_ultimate_scepter",
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_lotus_orb",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_lotus_orb",
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
		if J.IsKeyWordUnit( 'pugna_nether_ward', hMinionUnit )
		then
			hNetherWard = hMinionUnit
			return
		end

		Minion.IllusionThink( hMinionUnit )
	end

end

end

local NetherBlast = bot:GetAbilityByName('pugna_nether_blast')
local Decrepify = bot:GetAbilityByName('pugna_decrepify')
local NetherWard = bot:GetAbilityByName('pugna_nether_ward')
local LifeDrain = bot:GetAbilityByName('pugna_life_drain')

local NetherBlastDesire, NetherBlastLocation
local DecrepifyDesire, DecrepifyTarget
local NetherWardDesire, NetherWardLocation
local LifeDrainDesire, LifeDrainTarget

local hNetherWard = nil

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	LifeDrain = bot:GetAbilityByName('pugna_life_drain')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if LifeDrain and LifeDrain:IsTrained() and LifeDrain:IsChanneling() then
		if J.IsValid(LifeDrainTarget) then
			if LifeDrainTarget:GetTeam() == GetTeam() then
				if (J.GetHP(LifeDrainTarget) >= 0.9 and not string.find(LifeDrainTarget:GetUnitName(), 'nether_ward'))
				or botHP < 0.3
				then
					bot:Action_ClearActions(true)
					return
				end
			end
		end
	end

	if J.CanNotUseAbility(bot) and not (LifeDrain and LifeDrain:IsTrained() and LifeDrain:IsChanneling()) then return end

	NetherBlast = bot:GetAbilityByName('pugna_nether_blast')
	Decrepify = bot:GetAbilityByName('pugna_decrepify')
	NetherWard = bot:GetAbilityByName('pugna_nether_ward')

	if not (LifeDrain and LifeDrain:IsTrained() and LifeDrain:IsChanneling()) then
		LifeDrainDesire, LifeDrainTarget = X.ConsiderLifeDrain()
		if LifeDrainDesire > 0 then
			bot:Action_UseAbilityOnEntity(LifeDrain, LifeDrainTarget)
			return
		end
	end

	DecrepifyDesire, DecrepifyTarget = X.ConsiderDecrepify()
	if DecrepifyDesire > 0 then
		bot:Action_UseAbilityOnEntity(Decrepify, DecrepifyTarget)
		return
	end

	NetherBlastDesire, NetherBlastLocation = X.ConsiderNetherBlast()
	if NetherBlastDesire > 0 then
		bot:Action_UseAbilityOnLocation(NetherBlast, NetherBlastLocation)
		return
	end

	NetherWardDesire, NetherWardLocation = X.ConsiderNetherWard()
	if NetherWardDesire > 0 then
		bot:ActionQueue_UseAbilityOnLocation(NetherWard, NetherWardLocation)
		return
	end
end

function X.ConsiderNetherBlast()
	if not J.CanCastAbility(NetherBlast) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, NetherBlast:GetCastRange())
	local nCastPoint = NetherBlast:GetCastPoint()
	local nDelay = NetherBlast:GetSpecialValueInt('delay')
	local nRadius = NetherBlast:GetSpecialValueInt('radius')
	local nDamage = NetherBlast:GetSpecialValueInt('blast_damage')
	local nManaCost = NetherBlast:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Decrepify, NetherWard, LifeDrain})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {NetherBlast, Decrepify, NetherWard, LifeDrain})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 200)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + nDelay) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end

		if fManaAfter > fManaThreshold2 then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
			if nLocationAoE.count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				if J.IsChasingTarget(enemyHero, bot)
				or bot:IsRooted()
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if #nAllyHeroes <= 3 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 3)
					or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
					then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end

		if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
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
            and J.IsInRange(bot, creep, nCastRange)
            and J.CanCastOnNonMagicImmune(creep)
            and J.CanCastOnTargetAdvanced(creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
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
				if nLocationAoE.count >= 2 and (J.IsCore(bot) or not J.IsThereCoreInLocation(nLocationAoE.targetloc, 600)) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
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

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2 then
		local radius = Min(nCastRange + nRadius, 1600)
		local nEnemyTowers = bot:GetNearbyTowers(radius, true)
		local nEnemyBarracks = bot:GetNearbyBarracks(radius, true)
		local hEnemyAcient = GetAncient(GetOpposingTeam())

		local hBuildingList = {
			botTarget,
			nEnemyTowers[1],
			nEnemyBarracks[1],
			hEnemyAcient,
		}

		for _, building in pairs(hBuildingList) do
			if  J.IsValidBuilding(building)
			and J.CanBeAttacked(building)
			and J.IsInRange(bot, building, nCastRange + nRadius)
			and not J.IsKeyWordUnit('DOTA_Outpost', building)
			and not building:HasModifier('modifier_backdoor_protection')
			and not building:HasModifier('modifier_backdoor_protection_in_base')
			and not building:HasModifier('modifier_backdoor_protection_active')
			then
				if (building:GetHealthRegen() == 0)
				or (bot:GetAttackTarget() == building)
				then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), building:GetLocation(), Min(GetUnitToUnitDistance(bot, building), nCastRange))
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDecrepify()
	if not J.CanCastAbility(Decrepify) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = Decrepify:GetCastRange()
	local nCastPoint = Decrepify:GetCastPoint()
	local nDuration = Decrepify:GetSpecialValueFloat('AbilityDuration')
	local nManaCost = Decrepify:GetManaCost()

	if LifeDrain and LifeDrain:IsTrained() and LifeDrain:IsChanneling() then
		if  not bot:HasModifier('modifier_crystal_maiden_freezing_field_slow')
		and not bot:HasModifier('modifier_jakiro_macropyre_burn')
		and not bot:HasModifier('modifier_sand_king_epicenter_slow')
		then
			if (J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.0) > bot:GetHealth())
			or (J.IsInTeamFight(bot, 1200) and bot:WasRecentlyDamagedByAnyHero(2.0))
			then
				if not bot:HasModifier('modifier_item_nullifier_mute') then
					return BOT_ACTION_DESIRE_HIGH, bot
				end
			end

			if J.IsValid(LifeDrainTarget) and J.CanCastAbility(NetherBlast) then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

				if #nInRangeAlly <= 1 and #nInRangeEnemy <= 1 then
					if bot:GetEstimatedDamageToTarget(true, LifeDrainTarget, 5.0, DAMAGE_TYPE_MAGICAL) > LifeDrainTarget:GetHealth() then
						return BOT_ACTION_DESIRE_HIGH, LifeDrainTarget
					end
				end
			end
		end
	end

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 600) then
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

	if J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth() then
		return BOT_ACTION_DESIRE_HIGH, bot
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
            then
				local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
				if #nAllyHeroesTargetingTarget == 0 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				else
					if not bot:HasModifier('modifier_pugna_decrepify') then
						return BOT_ACTION_DESIRE_HIGH, bot
					end
				end
            end
        end
	end

	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 300)
		and allyHero:WasRecentlyDamagedByAnyHero(4.0)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_crystal_maiden_freezing_field_slow')
		and not allyHero:HasModifier('modifier_jakiro_macropyre_burn')
		and not allyHero:HasModifier('modifier_legion_commander_duel')
		and not allyHero:HasModifier('modifier_sand_king_epicenter_slow')
		and not allyHero:HasModifier('modifier_item_nullifier_mute')
		and not allyHero:HasModifier('modifier_pugna_decrepify')
		then
			local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)
			local hAbility = allyHero:GetCurrentActiveAbility()

			if hAbility and #nEnemyHeroesTargetingAlly > 0 then
				local sAbilityName = hAbility:GetName()
				if sAbilityName == 'enigma_black_hole'
				or sAbilityName == 'bane_fiends_grip'
				or sAbilityName == 'snapfire_mortimer_kisses'
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if (allyHero:HasModifier('modifier_bloodseeker_rupture') and J.IsUnitNearby(bot ,nEnemyHeroes, 300, 'npc_dota_hero_razor', true))
			or (allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze') and J.IsUnitNearby(bot ,nEnemyHeroes, 300, 'npc_dota_hero_faceless_void', true))
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) and not J.IsAttacking(allyHero) and bot ~= allyHero then
				for _, enemyHero in pairs(nEnemyHeroes) do
					if  J.IsValidHero(enemyHero)
					and J.IsAttacking(enemyHero)
					and not J.IsSuspiciousIllusion(enemyHero)
					and allyHero:WasRecentlyDamagedByHero(enemyHero, 4.0)
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end
			end
		end
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_pugna_decrepify')
		then
			local enemyAttackTarget = enemyHero:GetAttackTarget()
			local enemyAttackRange = enemyHero:GetAttackRange()

			if enemyHero:HasModifier('modifier_legion_commander_duel')
			or enemyHero:GetCurrentMovementSpeed() >= 1000
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.IsValidHero(enemyAttackTarget) and not J.IsSuspiciousIllusion(enemyAttackTarget) then
				if J.CanKillTarget(enemyAttackTarget, enemyHero:GetAttackDamage() * 5, DAMAGE_TYPE_PHYSICAL) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
				if not (LifeDrain and LifeDrain:IsTrained() and LifeDrain:IsChanneling()) then
					if hNetherWard and J.IsInRange(bot, hNetherWard, nCastRange) and enemyAttackTarget == hNetherWard and J.IsAttacking(enemyHero) then
						return BOT_ACTION_DESIRE_HIGH, hNetherWard
					end
				end
			end

			local nEnemyLaneCreeps = enemyHero:GetNearbyLaneCreeps(1600, false)
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)

			if J.IsInLaningPhase() then
				for _, creep in pairs(nEnemyLaneCreeps) do
					if  J.IsValid(creep)
					and J.CanBeAttacked(creep)
					and J.CanKillTarget(creep, enemyHero:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
					and J.IsEnemyTargetUnit(creep, 800)
					and #nAllyHeroesAttackingTarget <= 1
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderNetherWard()
	if not J.CanCastAbility(NetherWard) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = NetherWard:GetCastRange()
	local nRadius = NetherWard:GetSpecialValueInt('radius')
	local nManaCost = NetherWard:GetManaCost()

	if LifeDrain and LifeDrain:IsTrained() and LifeDrain:IsChanneling() then
		if J.IsValid(LifeDrainTarget)
		and J.CanCastOnNonMagicImmune(LifeDrainTarget)
		and LifeDrainTarget:IsFacingLocation(bot:GetLocation(), 45)
		then
			local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
			if #nEnemyHeroesTargetingMe >= 2 or (LifeDrainTarget:IsCastingAbility() or LifeDrainTarget:IsUsingAbility()) then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			then
				count = count + 1
			end
		end

		if count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(bot, botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.75)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius / 2)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
				if #nEnemyHeroesTargetingMe >= 2 or (enemyHero:IsCastingAbility() or enemyHero:IsUsingAbility()) then
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderLifeDrain()
	if not J.CanCastAbility(LifeDrain) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = LifeDrain:GetCastRange()
	local nCastPoint = LifeDrain:GetCastPoint()
	local nDamage = LifeDrain:GetSpecialValueInt('health_drain')
	local nHealing = LifeDrain:GetSpecialValueInt('ally_healing')
	local nDuration = LifeDrain:GetSpecialValueInt('AbilityChannelTime')
	local bHasShard = LifeDrain:GetSpecialValueInt('shard_damage_pct_from_ward') > 0
	local nManaCost = LifeDrain:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {NetherBlast, Decrepify, NetherWard, LifeDrain})

	if J.IsGoingOnSomeone(bot) then
		if bHasShard then
			local unitList = GetUnitList(UNIT_LIST_ALLIES)
			for _, unit in pairs(unitList) do
				if J.IsValid(unit) and string.find(unit:GetUnitName(), 'nether_ward') and J.IsInRange(bot, unit, nCastRange + 300) then
					local nInRangeEnemy = J.GetEnemiesNearLoc(unit:GetLocation(), nCastRange * 0.85)
					if #nInRangeEnemy >= 2 then
						return BOT_ACTION_DESIRE_HIGH, unit
					end
				end
			end
		end

		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			if not J.IsChasingTarget(bot, botTarget)
			or J.IsDisabled(botTarget)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and botHP < 0.75 then
		local nInRangeAlly_Engage = J.GetSpecialModeAllies(bot, 1200, BOT_MODE_ATTACK)
		local nInRangeAlly_Defend = J.GetSpecialModeAllies(bot, 1200, BOT_MODE_DEFEND_ALLY)
		if #nInRangeAlly_Engage >= 1
		or #nInRangeAlly_Defend >= 1
		or #nEnemyHeroes <= 1
		then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and J.CanCastOnTargetAdvanced(enemyHero)
				then
					if J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.0) > bot:GetHealth() then
						if bHasShard then
							local unitList = GetUnitList(UNIT_LIST_ALLIES)
							for _, unit in pairs(unitList) do
								if J.IsValid(unit) and string.find(unit:GetUnitName(), 'nether_ward') and J.IsInRange(bot, unit, nCastRange) then
									local nInRangeEnemy = J.GetEnemiesNearLoc(unit:GetLocation(), nCastRange * 0.85)
									if #nInRangeEnemy >= 2 then
										return BOT_ACTION_DESIRE_HIGH, unit
									end
								end
							end
						end

						if J.IsChasingTarget(enemyHero, bot)
						or bot:IsRooted()
						or botHP < 0.25
						then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end
				end
			end
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		local nEnemyTowers = bot:GetNearbyTowers(900, true)

		if  #nEnemyTowers == 0
		and not bot:WasRecentlyDamagedByAnyHero(2.0)
		then
			if botHP < 0.5 and fManaAfter > fManaThreshold1 then
				local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)
				local hTarget = nil
				local hTargetHealth = 0
				for _, creep in pairs(nEnemyCreeps) do
					if J.IsValid(creep)
					and J.CanBeAttacked(creep)
					and J.CanCastOnNonMagicImmune(creep)
					and J.CanCastOnTargetAdvanced(creep)
					and not J.IsOtherAllysTarget(creep)
					and creep:GetHealth() >= 500
					then
						if hTargetHealth < creep:GetHealth() then
							hTarget = creep
							hTargetHealth = creep:GetHealth()
						end
					end
				end

				if hTarget then
					return BOT_ACTION_DESIRE_HIGH, hTarget
				end
			end

			if botHP > 0.75 then
				local hAllyTarget = nil
				local hAllyTargetHealth = 0
				for i = 1, 5 do
					local allyHero = GetTeamMember(i)

					if J.IsValidHero(allyHero)
					and bot ~= allyHero
					and J.IsInRange(bot, allyHero, nCastRange * 0.75)
					and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
					and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
					and J.GetHP(allyHero) < 0.65
					then
						local allyHeroHealth = allyHero:GetHealth()
						if allyHeroHealth > hAllyTargetHealth then
							hAllyTarget = allyHero
							hAllyTargetHealth = allyHeroHealth
						end
					end
				end

				if hAllyTarget then
					return BOT_ACTION_DESIRE_HIGH, hAllyTarget
				end
			end
		end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange / 2)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if enemyHero:HasModifier('modifier_pugna_decrepify') then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and botHP < 0.75
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X