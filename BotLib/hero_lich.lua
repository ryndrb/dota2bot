local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_lich'
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,2,2,2,6,3,3,3,6},
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
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_solar_crest",--
				"item_refresher",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_hurricane_pike",--
				"item_moon_shard"
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,2,2,2,6,3,3,3,6},
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
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_solar_crest",--
				"item_refresher",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_hurricane_pike",--
				"item_moon_shard"
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_priest' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = true
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
		and hMinionUnit:GetUnitName() ~= 'npc_dota_lich_ice_spire'
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local FrostBlast = bot:GetAbilityByName('lich_frost_nova')
local FrostShield = bot:GetAbilityByName('lich_frost_shield')
local SinisterGaze = bot:GetAbilityByName('lich_sinister_gaze')
local IceSpire = bot:GetAbilityByName('lich_ice_spire')
local ChainFrost = bot:GetAbilityByName('lich_chain_frost')

local FrostBlastDesire, FrostBlastTarget
local FrostShieldDesire, FrostShieldTarget
local SinisterGazeDesire, SinisterGazeTarget
local IceSpireDesire, IceSpireLocation
local ChainFrostDesire, ChainFrostTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	FrostBlast = bot:GetAbilityByName('lich_frost_nova')
	FrostShield = bot:GetAbilityByName('lich_frost_shield')
	SinisterGaze = bot:GetAbilityByName('lich_sinister_gaze')
	IceSpire = bot:GetAbilityByName('lich_ice_spire')
	ChainFrost = bot:GetAbilityByName('lich_chain_frost')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	ChainFrostDesire, ChainFrostTarget = X.ConsiderChainFrost()
	if ChainFrostDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		if J.CanCastAbility(IceSpire) and bot:GetMana() > (IceSpire:GetManaCost() + ChainFrost:GetManaCost() + 75) then
			bot:ActionQueue_UseAbilityOnEntity(ChainFrost, ChainFrostTarget)
			bot:ActionQueue_UseAbilityOnLocation(IceSpire, ChainFrostTarget:GetLocation())
			return
		end

		bot:ActionQueue_UseAbilityOnEntity(ChainFrost, ChainFrostTarget)
		return
	end

	FrostBlastDesire, FrostBlastTarget = X.ConsiderFrostBlast()
	if FrostBlastDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FrostBlast, FrostBlastTarget)
		return
	end

	FrostShieldDesire, FrostShieldTarget = X.ConsiderFrostShield()
	if FrostShieldDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FrostShield, FrostShieldTarget)
		return
	end

	IceSpireDesire, IceSpireLocation = X.ConsiderIceSpire()
	if IceSpireDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(IceSpire, IceSpireLocation)
		return
	end

	SinisterGazeDesire, SinisterGazeTarget = X.ConsiderSinisterGaze()
	if SinisterGazeDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		if J.CheckBitfieldFlag(SinisterGaze:GetBehavior(), ABILITY_BEHAVIOR_POINT)
		then
			bot:ActionQueue_UseAbilityOnLocation(SinisterGaze, SinisterGazeTarget:GetLocation())
		else
			bot:ActionQueue_UseAbilityOnEntity(SinisterGaze, SinisterGazeTarget)
		end
		return
	end
end

function X.ConsiderFrostBlast()
	if not J.CanCastAbility(FrostBlast) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = FrostBlast:GetCastRange()
	local nCastPoint = FrostBlast:GetCastPoint()
	local nRadius = FrostBlast:GetSpecialValueInt('radius')
	local nBaseDamage = FrostBlast:GetSpecialValueInt('damage')
	local nAoEDamage = FrostBlast:GetSpecialValueInt('aoe_damage')
	local nDamage = nBaseDamage + nAoEDamage
	local nManaCost = FrostBlast:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FrostShield, SinisterGaze, IceSpire, ChainFrost})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {FrostBlast, FrostShield, SinisterGaze, IceSpire, ChainFrost})

	local hTarget = nil
	local hTargetScore = -math.huge
	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count > hTargetScore then
				hTarget = enemyHero
				hTargetScore = nLocationAoE.count
			end
		end
	end

	if hTarget then
		return BOT_ACTION_DESIRE_HIGH, hTarget
	end

	if J.IsInTeamFight(bot, 1200) then
		hTarget = nil
		hTargetScore = -math.huge
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count > hTargetScore then
					hTarget = enemyHero
					hTargetScore = nLocationAoE.count
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
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
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local sCreepName = creep:GetUnitName()
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
					if string.find(sCreepName, 'ranged')
					or nLocationAoE.count >= 2
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end

				if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 3 and string.find(sCreepName, 'upgraded'))
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local sCreepName = creep:GetUnitName()
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 3 and string.find(sCreepName, 'upgraded'))
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
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

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		if fManaAfter > 0.4 then
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
					local nLocationAoE = bot:FindAoELocation(true, false, enemyHero:GetLocation(), 0, nRadius, 0, nAoEDamage)
					if nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
		end

		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsAllysTarget(creep) then
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
						if J.IsKeyWordUnit('ranged', creep) then
							return BOT_ACTION_DESIRE_HIGH, creep
						else
							if not J.WillKillTarget(creep, nDamage * 0.5, DAMAGE_TYPE_MAGICAL, nCastPoint) then
								return BOT_ACTION_DESIRE_HIGH, creep
							end
						end
					end

					nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nAoEDamage)
					if nLocationAoE.count >= 3 then
						return BOT_ACTION_DESIRE_HIGH, creep
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

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderFrostShield()
	if not J.CanCastAbility(FrostShield) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = FrostShield:GetCastRange()
	local nRadius = FrostShield:GetSpecialValueInt('radius')
	local nDuration = FrostShield:GetSpecialValueInt('duration')
	local nHealthRegen = FrostShield:GetSpecialValueInt('health_regen')
	local nManaCost = FrostShield:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FrostBlast, SinisterGaze, IceSpire, ChainFrost})

	if J.IsInTeamFight(bot, 900) then
		local hAllyTarget = nil
		local hAllyTargetScore = 0
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange + 300)
			and not J.IsSuspiciousIllusion(allyHero)
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local allyHeroScrore = 0
				local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)
				local nEnemyCreeps = allyHero:GetNearbyCreeps(1200, true)

				allyHeroScrore = allyHeroScrore + #nEnemyHeroesTargetingAlly * 5

				for _, creep in pairs(nEnemyCreeps) do
					if J.IsValid(creep) and creep:GetAttackTarget() == allyHero then
						allyHeroScrore = allyHeroScrore + 1
					end
				end

				if allyHeroScrore > hAllyTargetScore then
					hAllyTarget = allyHero
					hAllyTargetScore = allyHeroScrore
				end
			end
		end

		if hAllyTarget then
			return BOT_ACTION_DESIRE_HIGH, hAllyTarget
		end
	end

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not J.IsSuspiciousIllusion(allyHero)
		then
			local allyTarget = J.GetProperTarget(allyHero)
			local nInRangeEnemy = allyHero:GetNearbyHeroes(nRadius - 25, true, BOT_MODE_NONE)
			local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)

			if (#nInRangeEnemy >= 3 and fManaAfter > fManaThreshold1)
			or (#nEnemyHeroesTargetingAlly >= 2 and J.GetHP(allyHero) < 0.6)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsGoingOnSomeone(allyHero) then
				if J.IsValidHero(allyTarget)
				and J.CanCastOnNonMagicImmune(allyTarget)
				and J.IsInRange(bot, allyHero, nCastRange + 300)
				and J.IsInRange(allyHero, allyTarget, nRadius - 50)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) and not J.IsRealInvisible(bot) then
				for _, enemyHero in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemyHero)
					and J.CanCastOnNonMagicImmune(enemyHero)
					and J.IsInRange(bot, allyHero, nCastRange + 300)
					and allyHero:WasRecentlyDamagedByHero(enemyHero, 4.0)
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end
			end

			local nEnemyCreeps = allyHero:GetNearbyCreeps(nRadius, true)

			if not allyHero:HasModifier('modifier_lich_frost_shield') then
				if J.IsPushing(allyHero) and J.IsAttacking(allyHero) and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 and #nAllyHeroes <= 2 then
					if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
						if (#nEnemyCreeps >= 4) then
							return BOT_ACTION_DESIRE_HIGH, allyHero
						end
					end
				end

				if J.IsDefending(allyHero) and J.IsAttacking(allyHero) and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
					if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
						if (#nEnemyCreeps >= 4)
						or (#nEnemyCreeps >= 4 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded'))
						then
							return BOT_ACTION_DESIRE_HIGH, allyHero
						end
					end
				end

				if J.IsFarming(allyHero) and J.IsAttacking(allyHero) and fManaAfter > fManaThreshold1 then
					if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
						if (#nEnemyCreeps >= 3)
						or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
						or (#nEnemyCreeps >= 2 and botHP < 0.35)
						then
							return BOT_ACTION_DESIRE_HIGH, allyHero
						end
					end
				end

				if J.IsDoingRoshan(bot) then
					if J.IsRoshan(botTarget)
					and J.IsInRange(bot, botTarget, nCastRange)
					and bAttacking
					and fManaAfter > fManaThreshold1
					and botTarget:GetAttackTarget() == allyHero
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end

				if J.IsDoingTormentor(bot) then
					if J.IsTormentor(botTarget)
					and J.IsInRange(bot, botTarget, nCastRange)
					and bAttacking
					and fManaAfter > fManaThreshold1
					and J.GetHP(allyHero) < 0.5
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end

				if nHealthRegen > 0 then
					if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
						if #nEnemyHeroes == 0 and J.GetHP(allyHero) < 0.35 then
							return BOT_ACTION_DESIRE_HIGH, allyHero
						end
					end
				end
			end
		end
	end

	if nHealthRegen > 0 and fManaAfter > fManaThreshold1 then
		local hTeamAncient = GetAncient(GetTeam())
		if J.CanBeAttacked(hTeamAncient)
		and J.IsInRange(bot, hTeamAncient, nCastRange + 300)
		and hTeamAncient:GetMaxHealth() - hTeamAncient:GetHealth() > 1000
		and #nEnemyHeroes <= 1
		and not hTeamAncient:HasModifier('modifier_lich_frost_shield')
		then
			return BOT_ACTION_DESIRE_HIGH, hTeamAncient
		end

		local nAllyTowers = bot:GetNearbyTowers(nCastRange + 300, false)
		for _, tower in pairs(nAllyTowers) do
			if J.IsValidBuilding(tower)
			and J.CanBeAttacked(tower)
			and tower:GetMaxHealth() - tower:GetHealth() > nDuration * nHealthRegen
			and not tower:HasModifier('modifier_lich_frost_shield')
			then
				local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, tower)
				local nLocationAoE = bot:FindAoELocation(true, false, tower:GetLocation(), 0, nRadius, 0, 0)
				if #nEnemyHeroesTargetingAlly > 0 or nLocationAoE.count >= 4 then
					return BOT_ACTION_DESIRE_HIGH, tower
				end
			end
		end

		local nAllyBarracks = bot:GetNearbyBarracks(nCastRange + 300, false)
		for _, barracks in pairs(nAllyBarracks) do
			if J.IsValidBuilding(barracks)
			and J.CanBeAttacked(barracks)
			and barracks:GetMaxHealth() - barracks:GetHealth() > nDuration * nHealthRegen
			and not barracks:HasModifier('modifier_lich_frost_shield')
			then
				local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, barracks)
				local nLocationAoE = bot:FindAoELocation(true, false, barracks:GetLocation(), 0, nRadius, 0, 0)
				if #nEnemyHeroesTargetingAlly > 0 or nLocationAoE.count >= 4 then
					return BOT_ACTION_DESIRE_HIGH, barracks
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSinisterGaze()
	if not J.CanCastAbility(SinisterGaze) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = SinisterGaze:GetCastRange()

	local nAllyTowers = bot:GetNearbyTowers(400, false)

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.IsInLaningPhase() and not J.IsRetreating(bot) then
				if J.IsValidBuilding(nAllyTowers[1]) and J.IsInRange(nAllyTowers[1], enemyHero, 800) then
					if nAllyTowers[1] == nil or nAllyTowers[1]:GetAttackTarget() == enemyHero then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
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
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				local enemyHeroScore = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
				if enemyHeroScore > hTargetScore then
					hTarget = enemyHero
					hTargetScore = enemyHeroScore
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
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not J.IsInRange(bot, botTarget, nCastRange - 200)
		and bot:IsFacingLocation(botTarget:GetLocation(), 30)
		and not botTarget:IsFacingLocation(bot:GetLocation(), 100)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderIceSpire()
	if not J.CanCastAbility(IceSpire) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = IceSpire:GetCastRange()
	local nRadius = IceSpire:GetSpecialValueInt('aura_radius')
	local nManaCost = IceSpire:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ChainFrost})

	if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold1 + 0.1 then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
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
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
		and fManaAfter > fManaThreshold1 + 0.1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderChainFrost()
	if not J.CanCastAbility(ChainFrost) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ChainFrost:GetCastRange()
	local nDamage = ChainFrost:GetSpecialValueInt('damage')
	local nRadius = ChainFrost:GetSpecialValueInt('jump_range')

	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not (#nAllyHeroes >= #nEnemyHeroes + 2)
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		then
			local nEnemyCreeps = botTarget:GetNearbyCreeps(nRadius, false)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
			if #nEnemyCreeps >= 2 or #nInRangeEnemy >= 2 then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
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
			and bot:WasRecentlyDamagedByAnyHero(1.0)
			and J.GetHP(enemyHero) < 0.55
			then
				local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius * 0.8)
				if #nInRangeEnemy >= 2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
