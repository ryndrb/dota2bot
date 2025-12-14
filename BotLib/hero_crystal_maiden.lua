local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_crystal_maiden'
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_arcane_boots",
				"item_null_talisman",
				"item_kaya",
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_kaya_and_sange",--
				"item_aghanims_shard",
				"item_octarine_core",--
				"item_sheepstick",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_null_talisman", "item_octarine_core",
				"item_bottle", "item_sheepstick",
			},
        },
        [2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
				"item_mantle",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_null_talisman",
				"item_maelstrom",
				"item_dragon_lance",
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_mjollnir",--
				"item_devastator",--
				"item_orchid",
				"item_ultimate_scepter_2",
				"item_bloodthorn",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_null_talisman", "item_devastator",
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
                [1] = {1,2,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_enchanted_mango",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_glimmer_cape",--
				"item_ancient_janggo",
				"item_solar_crest",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_force_staff",
				"item_black_king_bar",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
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
                [1] = {1,2,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_enchanted_mango",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_glimmer_cape",--
				"item_mekansm",
				"item_solar_crest",--
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_force_staff",
				"item_black_king_bar",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
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

X['bDeafaultAbility'] = true
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local CrystalNova = bot:GetAbilityByName('crystal_maiden_crystal_nova')
local Frostbite = bot:GetAbilityByName('crystal_maiden_frostbite')
local ArcaneAura = bot:GetAbilityByName('crystal_maiden_brilliance_aura')
local CrystalClone = bot:GetAbilityByName('crystal_maiden_crystal_clone')
local FreezingField = bot:GetAbilityByName('crystal_maiden_freezing_field')

local CrystalNovaDesire, CrystalNovaLocation
local FrostbiteDesire, FrostbiteTarget
local CrystalCloneDesire, CrystalCloneLocation
local FreezingFieldDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	CrystalNova = bot:GetAbilityByName('crystal_maiden_crystal_nova')
	Frostbite = bot:GetAbilityByName('crystal_maiden_frostbite')
	ArcaneAura = bot:GetAbilityByName('crystal_maiden_brilliance_aura')
	CrystalClone = bot:GetAbilityByName('crystal_maiden_crystal_clone')
	FreezingField = bot:GetAbilityByName('crystal_maiden_freezing_field')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	CrystalCloneDesire, CrystalCloneLocation = X.ConsiderCrystalClone()
	if CrystalCloneDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(CrystalClone, CrystalCloneLocation)
		return
	end

	CrystalNovaDesire, CrystalNovaLocation = X.ConsiderCrystalNova()
	if CrystalNovaDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(CrystalNova, CrystalNovaLocation)
		return
	end

	FrostbiteDesire, FrostbiteTarget = X.ConsiderFrostbite()
	if FrostbiteDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Frostbite, FrostbiteTarget)
		return
	end

	FreezingFieldDesire = X.ConsiderFreezingField()
	if FreezingFieldDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		if J.CanCastAbility(ArcaneAura) and bot:GetMana() > ArcaneAura:GetManaCost() * 1.65 then
			bot:ActionQueue_UseAbility(ArcaneAura)
		end

		J.SetQueueToInvisible(bot)
		bot:ActionQueue_UseAbility(FreezingField)
		return
	end
end

function X.ConsiderCrystalNova()
    if not J.CanCastAbility(CrystalNova) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, CrystalNova:GetCastRange())
	local nRadius = CrystalNova:GetSpecialValueInt('radius')
	local nDamage = CrystalNova:GetSpecialValueInt('nova_damage')
	local nManaCost = CrystalNova:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Frostbite, CrystalClone, FreezingField})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {CrystalNova, Frostbite, CrystalClone, FreezingField})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {FreezingField})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
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
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and fManaAfter > fManaThreshold3
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end

		if fManaAfter > fManaThreshold3 then
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
            and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and bot:WasRecentlyDamagedByAnyHero(1.0))
				or bot:IsRooted()
				or botHP < 0.5
				then
					local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					else
						return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 2 then
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

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 then
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

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				or (nLocationAoE.count >= 1 and creep:IsAncientCreep() and fManaAfter > 0.75)
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

	if #nEnemyHeroes == 0 and not J.IsRetreating(bot) then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
		if  nLocationAoE.count >= 2
		and fManaAfter > fManaThreshold3
		and (J.IsCore(bot) or not J.IsThereCoreInLocation(nLocationAoE.targetloc, 550))
		then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end

		if fManaAfter > fManaThreshold1 then
			for _, creep in pairs(nEnemyCreeps) do
				if  J.IsValid(creep)
				and J.CanBeAttacked(creep)
				and creep:HasModifier('modifier_crystal_maiden_frostbite')
				and creep:GetMaxHealth() >= 550
				and not J.IsOtherAllysTarget(creep)
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFrostbite()
    if not J.CanCastAbility(Frostbite) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Frostbite:GetCastRange())
	local nCastPoint = Frostbite:GetCastPoint()
    local nDPS = Frostbite:GetSpecialValueInt('damage_per_second')
    local nDuration = Frostbite:GetSpecialValueFloat('duration')
	local nDamage = (nDPS * nDuration)
	local nManaCost = Frostbite:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Frostbite, CrystalClone, FreezingField})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {CrystalNova, Frostbite, CrystalClone, FreezingField})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {FreezingField})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + nDuration)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetScore = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				local enemyScore = (enemyHero:GetEstimatedDamageToTarget(false, bot, 3.0, DAMAGE_TYPE_ALL)) * 0.35
								 + (enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed() * nDuration) * 0.65
				if enemyScore > hTargetScore
				then
					hTarget = enemyHero
					hTargetScore = enemyScore
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and not J.IsDisabled(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if  not J.IsInLaningPhase()
	and not J.IsRealInvisible(bot)
	and not J.IsGoingOnSomeone(bot)
	then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnNonMagicImmune(creep)
			and J.CanCastOnTargetAdvanced(creep)
			then
				local sCreepName = creep:GetUnitName()
				if  fManaAfter > fManaThreshold3
				and #nEnemyHeroes == 0
				and (J.IsCore(bot) or not J.IsThereCoreInLocation(bot:GetLocation(), 650))
				then
					if  not J.IsOtherAllysTarget(creep)
					and not J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end

				if fManaAfter > fManaThreshold2 then
					if not J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL) then
						if creep:IsDominated()
						or string.find(sCreepName, 'warlock_golem')
						or creep:HasModifier('modifier_chen_holy_persuasion')
						then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderCrystalClone()
	if not J.CanCastAbility(CrystalClone)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nSlideDistance = CrystalClone:GetSpecialValueInt('hop_distance')
	local nManaCost = CrystalNova:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FreezingField})

	local vLocation = J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nSlideDistance)

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, vLocation
	end

	if not bot:IsMagicImmune() and fManaAfter > fManaThreshold1 then
		if (J.IsStunProjectileIncoming(bot, 350))
		or (J.IsUnitTargetProjectileIncoming(bot, 350))
		or (J.IsWillBeCastUnitTargetSpell(bot, 350) and not bot:HasModifier('modifier_sniper_assassinate'))
		then
			return BOT_ACTION_DESIRE_HIGH, vLocation
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nSlideDistance)
		and J.CanCastOnNonMagicImmune(botTarget)
		and fManaAfter > fManaThreshold1
		then
			if J.IsInRange(bot, botTarget, nSlideDistance) then
				return BOT_ACTION_DESIRE_HIGH, vLocation
			else
				if  J.IsChasingTarget(bot, botTarget)
				and J.IsInRange(bot, botTarget, bot:GetAttackTarget() + nSlideDistance)
				and not J.IsInRange(bot, botTarget, bot:GetAttackTarget())
				and bot:GetCurrentMovementSpeed() > botTarget:GetCurrentMovementSpeed()
				then
					if bot:GetCurrentMovementSpeed() > botTarget:GetCurrentMovementSpeed()
					or J.IsDisabled(botTarget)
					or botTarget:IsRooted()
					then
						return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nSlideDistance)
					end
				end
			end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsDisabled(enemyHero)
			and enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			then
				if botHP < 0.5 or bot:WasRecentlyDamagedByAnyHero(2.0) then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFreezingField()
    if not J.CanCastAbility(FreezingField)
    or bot:DistanceFromFountain() < 300
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = FreezingField:GetSpecialValueInt('radius')

	if J.IsInTeamFight(bot, 1200) then
		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not J.IsChasingTarget(bot, enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			then
				count = count + 1
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
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and botTarget:GetHealth() > 400
        then
			if J.IsDisabled(botTarget)
			or J.IsInRange(bot, botTarget, 300)
			or botTarget:GetCurrentMovementSpeed() < 200
			then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
				if  J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 5.0) > botTarget:GetHealth()
				and #nInRangeAlly <= 2
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
        end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and enemyHero:GetHealth() > 400
			then
				if enemyHero:HasModifier('modifier_enigma_black_hole_pull')
				or enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				or enemyHero:HasModifier('modifier_legion_commander_duel')
				or J.GetModifierTime(enemyHero, 'modifier_stunned') > 3.5
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X