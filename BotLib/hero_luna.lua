local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_luna'
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_power_treads",
				"item_lifesteal",
				"item_manta",--
				"item_dragon_lance",
				"item_butterfly",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_hurricane_pike",--
				"item_satanic",--
				"item_moon_shard",
				"item_greater_crit",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_manta",
				"item_circlet", "item_dragon_lance",
				"item_circlet", "item_butterfly",
				"item_magic_wand", "item_black_king_bar",
			},
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_ranged_carry' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local LucentBeam 	= bot:GetAbilityByName('luna_lucent_beam')
local LunarOrbit 	= bot:GetAbilityByName("luna_lunar_orbit")
-- local MoonGlaives 	= bot:GetAbilityByName('luna_moon_glaive')
-- local LunarBlessing = bot:GetAbilityByName('luna_lunar_blessing')
local Eclipse 		= bot:GetAbilityByName('luna_eclipse')

local LucentBeamDesire, LucentBeamTarget
local LunarOrbitDesire
local EclipseDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	LucentBeam 	= bot:GetAbilityByName('luna_lucent_beam')
	LunarOrbit 	= bot:GetAbilityByName("luna_lunar_orbit")
	Eclipse 		= bot:GetAbilityByName('luna_eclipse')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	LunarOrbitDesire = X.ConsiderLunarOrbit()
	if LunarOrbitDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(LunarOrbit)
		return
	end

	EclipseDesire = X.ConsiderEclipse()
	if EclipseDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		if bot:HasScepter() then
			bot:ActionQueue_UseAbilityOnEntity(Eclipse, bot)
		else
			bot:ActionQueue_UseAbility(Eclipse)
		end
		return
	end

	LucentBeamDesire, LucentBeamTarget = X.ConsiderLucentBeam()
	if LucentBeamDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(LucentBeam, LucentBeamTarget)
		return
	end
end

function X.ConsiderLucentBeam()
	if not J.CanCastAbility(LucentBeam) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, LucentBeam:GetCastRange())
	local nCastPoint = LucentBeam:GetCastPoint()
	local nDamage = LucentBeam:GetSpecialValueInt('beam_damage')
	local nManaCost = LucentBeam:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {LunarOrbit, Eclipse})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {LucentBeam, LunarOrbit, Eclipse})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local npcWeakestEnemy = nil
		local npcWeakestEnemyScore = -math.huge
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				local enemyHeroScore = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL) / enemyHero:GetHealth()
				if enemyHeroScore > npcWeakestEnemyScore then
					npcWeakestEnemy = enemyHero
					npcWeakestEnemyScore = enemyHeroScore
				end
			end
		end

		if npcWeakestEnemy ~= nil then
			return BOT_ACTION_DESIRE_HIGH, npcWeakestEnemy
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.5 and bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
            end
        end
    end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange + 300, true)

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold2 then
		local botTarget_Creep = J.GetMostHpUnit(nEnemyCreeps)

		if  J.IsValid(botTarget_Creep)
		and J.CanBeAttacked(botTarget_Creep)
		and J.CanCastOnNonMagicImmune(botTarget_Creep)
		and J.CanCastOnTargetAdvanced(botTarget_Creep)
		and not J.IsRoshan(botTarget_Creep)
		and not J.IsTormentor(botTarget_Creep)
		and not J.CanKillTarget(botTarget_Creep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and not J.CanKillTarget(botTarget_Creep, nDamage, DAMAGE_TYPE_MAGICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget_Creep
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
				local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 650, 0, 0)
				if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
					if string.find(creep:GetUnitName(), 'ranged') or fManaAfter > fManaThreshold2 then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

		if fManaAfter > fManaThreshold2 and #nEnemyHeroesTargetingMe <= 1 then
			for _, allyHero in pairs(nAllyHeroes) do
				if  J.IsValidHero(allyHero)
				and bot ~= allyHero
				and J.CanBeAttacked(allyHero)
				and J.IsRetreating(allyHero)
				and allyHero:WasRecentlyDamagedByAnyHero(3.0)
				and not J.IsSuspiciousIllusion(allyHero)
				then
					for _, enemyHero in pairs(nEnemyHeroes) do
						if  J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and J.CanCastOnTargetAdvanced(enemyHero)
						and J.IsChasingTarget(enemyHero, allyHero)
						and not J.IsDisabled(enemyHero)
						then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderLunarOrbit()
	if not J.CanCastAbility(LunarOrbit) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = LunarOrbit:GetSpecialValueInt('rotating_glaives_movement_radius')
	local nManaCost = LunarOrbit:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {LucentBeam, Eclipse})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {LucentBeam, LunarOrbit, Eclipse})

	local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nInRangeEnemy, bot)

	if botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(2.0) and #nEnemyHeroesTargetingMe > 0 and fManaAfter > fManaThreshold1 then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsChasingTarget(bot, botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and bot:WasRecentlyDamagedByAnyHero(2.0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
            and not J.IsDisabled(enemyHero)
			and enemyHero:GetAttackTarget() == bot
            then
				return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking then
		local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsDisabled(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEclipse()
	if not J.CanCastAbility(Eclipse) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Eclipse:GetSpecialValueInt('radius')
	local nBeamCount = Eclipse:GetSpecialValueInt('beams')

	if J.IsInTeamFight(bot, 1200) then
		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
			and not botTarget:HasModifier('modifier_ursa_enrage')
			then
				count = count + 1
			end
		end

		local nLocationAoE_heroes = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		local nLocationAoE_creeps = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)

		if count >= 2 and (nLocationAoE_creeps.count + nLocationAoE_heroes.count <= (nBeamCount / 2)) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
		and not botTarget:HasModifier('modifier_ursa_enrage')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL)
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy_ = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
			local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)

			if not (#nInRangeAlly >= #nInRangeEnemy + 2) and nLocationAoE.count <= 2 and #nInRangeEnemy_ <= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X