local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_shadow_shaman'
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
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,2,2,6,2,2,3,3,6,1,1,1,6},
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
				"item_ancient_janggo",
				"item_blink",
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_boots_of_bearing",--
				"item_refresher",--
				"item_black_king_bar",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_arcane_blink",--
				"item_moon_shard",
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
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,2,2,6,2,2,3,3,6,1,1,1,6},
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
				"item_mekansm",
				"item_blink",
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_guardian_greaves",--
				"item_refresher",--
				"item_black_king_bar",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_arcane_blink",--
				"item_moon_shard",
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

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

end

local EtherShock = bot:GetAbilityByName('shadow_shaman_ether_shock')
local Hex = bot:GetAbilityByName('shadow_shaman_voodoo')
local Shackles = bot:GetAbilityByName('shadow_shaman_shackles')
local MassSerpentWard = bot:GetAbilityByName('shadow_shaman_mass_serpent_ward')

local EtherShockDesire, EtherShockTarget
local HexDesire, HexTarget
local ShacklesDesire, ShacklesTarget
local MassSerpentWardDesire, MassSerpentWardLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	EtherShock = bot:GetAbilityByName('shadow_shaman_ether_shock')
	Hex = bot:GetAbilityByName('shadow_shaman_voodoo')
	Shackles = bot:GetAbilityByName('shadow_shaman_shackles')
	MassSerpentWard = bot:GetAbilityByName('shadow_shaman_mass_serpent_ward')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	HexDesire, HexTarget = X.ConsiderHex()
	if HexDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Hex, HexTarget)
		return
	end

	MassSerpentWardDesire, MassSerpentWardLocation = X.ConsiderMassSerpentWard()
	if MassSerpentWardDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(MassSerpentWard, MassSerpentWardLocation)
		return
	end

	EtherShockDesire, EtherShockTarget = X.ConsiderEtherShock()
	if EtherShockDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(EtherShock, EtherShockTarget)
		return
	end

	ShacklesDesire, ShacklesTarget = X.ConsiderShackles()
	if ShacklesDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Shackles, ShacklesTarget)
		return
	end
end

function X.ConsiderEtherShock()
	if not J.CanCastAbility(EtherShock) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = EtherShock:GetCastRange()
	local nCastPoint = EtherShock:GetCastPoint()
	local nRadius = EtherShock:GetSpecialValueInt('end_radius')
	local nDamage = EtherShock:GetSpecialValueInt('damage')
	local nManaCost = EtherShock:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Hex, Shackles, MassSerpentWard})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EtherShock, Hex, Shackles, MassSerpentWard})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange )
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.2 and #nAllyHeroes <= 3 and #nEnemyHeroes <= 1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not enemyHero:HasModifier('modifier_rubick_telekinesis')
            then
                local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 3 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            and not J.IsOtherAllysTarget(creep)
			then
                local sCreepName = creep:GetUnitName()
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                if string.find(sCreepName, 'ranged') then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end

                nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage * 2)
                if fManaAfter > fManaThreshold1 + 0.1 and nLocationAoE.count > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 and #nEnemyHeroes > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep
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

function X.ConsiderHex()
	if not J.CanCastAbility(Hex) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = Hex:GetCastRange()
	local nManaCost = Hex:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Hex, Shackles, MassSerpentWard})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EtherShock, Hex, Shackles, MassSerpentWard})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling() or enemyHero:IsCastingAbility() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamge = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
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
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
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
			and not enemyHero:IsDisarmed()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
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
					and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end

		if not J.IsInTeamFight(bot, 1200) and not bot:WasRecentlyDamagedByAnyHero(3.0) then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and J.IsSuspiciousIllusion(enemyHero)
				then
					local sEnemyHeroName = enemyHero:GetUnitName()
					if sEnemyHeroName == 'npc_dota_hero_naga_siren'
					or sEnemyHeroName == 'npc_dota_hero_chaos_knight'
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
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
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShackles()
	if not J.CanCastAbility(Shackles) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = Shackles:GetCastRange()
	local nAllyTowers = bot:GetNearbyTowers(800, false)

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 550) then
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

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
				if J.IsValidBuilding(nAllyTowers[1]) and J.IsInRange(nAllyTowers[1], enemyHero, 600) then
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
				local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
				if enemyHeroScore > hTargetScore and #nAllyHeroesTargetingTarget >= 2 then
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
		and not J.IsDisabled(botTarget)
		then
			local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
			if #nAllyHeroesTargetingTarget >= 2 or J.GetHP(botTarget) < 0.2 then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
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

function X.ConsiderMassSerpentWard()
	if not J.CanCastAbility(MassSerpentWard) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = MassSerpentWard:GetCastRange()
	local nRadius = MassSerpentWard:GetSpecialValueInt('spawn_radius')
	local nManaCost = MassSerpentWard:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EtherShock, Hex, 150})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not J.IsChasingTarget(bot, botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), nRadius)
			if J.GetHP(botTarget) > 0.4 then
				if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 8.0) > botTarget:GetHealth() and #nInRangeAlly == 0 then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end

			if J.IsInTeamFight(bot, 1200) then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsRealInvisible(bot) and not J.CanCastAbility(Hex) and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsInRange(bot, enemyHero, nRadius + 75)
			and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
				local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), nRadius)
				if J.GetHP(enemyHero) < 0.25 and #nInRangeAlly == 0 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
            end
        end
	end

	if J.IsPushing(bot) and #nAllyHeroes >= #nEnemyHeroes and fManaAfter > fManaThreshold1 then
		local radius = Min(nCastRange + bot:GetAttackRange(), 1600)
		local nEnemyTowers = bot:GetNearbyTowers(radius, true)
		local nEnemyBarracks = bot:GetNearbyBarracks(radius, true)
		local hEnemyAcient = GetAncient(GetOpposingTeam())
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)

		local hBuildingList = {
			botTarget,
			nEnemyTowers[1],
			nEnemyBarracks[1],
			hEnemyAcient,
		}

		for _, building in pairs(hBuildingList) do
			if  J.IsValidBuilding(building)
			and J.CanBeAttacked(building)
			and J.IsInRange(bot, building, nCastRange + bot:GetAttackRange())
			and not J.IsKeyWordUnit('DOTA_Outpost', building)
			then
				local sBuildingName = building:GetUnitName()
				if #nInRangeAlly <= 3 or string.find(sBuildingName, 'barracks') or building == hEnemyAcient then
					if (building:GetHealthRegen() == 0)
					or (bot:GetAttackTarget() == building)
					then
						return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(building:GetLocation(), bot:GetLocation(), nRadius)
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X
