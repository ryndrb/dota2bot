local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_warlock'
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
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
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
				"item_aghanims_shard",
				"item_force_staff",
				"item_boots_of_bearing",--
				"item_ultimate_scepter",
				"item_refresher",--
				"item_lotus_orb",--
				"item_ultimate_scepter_2",
				"item_assault",--
				"item_hurricane_pike",--
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
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
				"item_aghanims_shard",
				"item_force_staff",
				"item_guardian_greaves",--
				"item_ultimate_scepter",
				"item_refresher",--
				"item_lotus_orb",--
				"item_ultimate_scepter_2",
				"item_assault",--
				"item_hurricane_pike",--
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_priest' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
		and ( not J.IsKeyWordUnit( 'npc_dota_warlock_minor_imp', hMinionUnit ) )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end


local FatalBonds = bot:GetAbilityByName('warlock_fatal_bonds')
local ShadowWord = bot:GetAbilityByName('warlock_shadow_word')
local Upheaval = bot:GetAbilityByName('warlock_upheaval')
local ChaoticOffering = bot:GetAbilityByName('warlock_rain_of_chaos')

local FatalBondsDesire, FatalBondsTarget
local ShadowWordDesire, ShadowWordTarget
local UpheavalDesire, UpheavalLocation
local ChaoticOfferingDesire, ChaoticOfferingLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if Upheaval and Upheaval:IsTrained() and Upheaval:IsChanneling() then
		local nRadius = Upheaval:GetSpecialValueInt('aoe')
		if UpheavalLocation then
			local nLocationAoE = bot:FindAoELocation(true, false, UpheavalLocation, 0, nRadius, 0, 0)
			if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot) then
				if nLocationAoE.count == 0 then
					bot:Action_ClearActions(true)
					return
				end
			else
				nLocationAoE = bot:FindAoELocation(true, true, UpheavalLocation, 0, nRadius, 0, 0)
				if nLocationAoE.count == 0 then
					nLocationAoE = bot:FindAoELocation(false, true, UpheavalLocation, 0, nRadius, 0, 0)
					if nLocationAoE.count <= 1 then
						bot:Action_ClearActions(true)
						return
					end
				end
			end
		end
	end

	if J.CanNotUseAbility(bot) then return end

	FatalBonds = bot:GetAbilityByName('warlock_fatal_bonds')
	ShadowWord = bot:GetAbilityByName('warlock_shadow_word')
	Upheaval = bot:GetAbilityByName('warlock_upheaval')
	ChaoticOffering = bot:GetAbilityByName('warlock_rain_of_chaos')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	FatalBondsDesire, FatalBondsTarget = X.ConsiderFatalBonds()
	if FatalBondsDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FatalBonds, FatalBondsTarget)
		return
	end

	ChaoticOfferingDesire, ChaoticOfferingLocation = X.ConsiderChaoticOffering()
	if ChaoticOfferingDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(ChaoticOffering, ChaoticOfferingLocation)
		return
	end

	ShadowWordDesire, ShadowWordTarget = X.ConsiderShadowWord()
	if ShadowWordDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ShadowWord, ShadowWordTarget)
		return
	end

	UpheavalDesire, UpheavalLocation = X.ConsiderUpheaval()
	if UpheavalDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Upheaval, UpheavalLocation)
		return
	end
end

function X.ConsiderFatalBonds()
	if not J.CanCastAbility(FatalBonds) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = FatalBonds:GetCastRange()
	local nRadius = FatalBonds:GetSpecialValueInt('search_aoe')
	local nCount = FatalBonds:GetSpecialValueInt('count')
	local nManaCost = FatalBonds:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowWord, Upheaval, ChaoticOffering})

	if J.IsInTeamFight(bot, 1200) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_warlock_fatal_bonds')
			then
				local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_warlock_fatal_bonds')
		and fManaAfter > fManaThreshold1
		then
			local nLocationAoE_Heroes = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
			local nLocationAoE_Creeps = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if (nLocationAoE_Heroes.count + nLocationAoE_Creeps.count) >= 3 then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_warlock_fatal_bonds')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
				local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
				local nLocationAoE_Heroes = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				local nLocationAoE_Creeps = bot:FindAoELocation(true, false, enemyHero:GetLocation(), 0, nRadius, 0, 0)

				if (nLocationAoE_Heroes.count + nLocationAoE_Creeps.count) >= 3 and #nAllyHeroesTargetingTarget > 0 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShadowWord()
	if not J.CanCastAbility(ShadowWord) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ShadowWord:GetCastRange()
	local nCastPoint = ShadowWord:GetCastPoint()
	local nRadius = ShadowWord:GetSpecialValueInt('spell_aoe')
	local nDPS = ShadowWord:GetSpecialValueInt('damage')
	local nDuration = ShadowWord:GetSpecialValueInt('duration')
	local nManaCost = ShadowWord:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FatalBonds, Upheaval, ChaoticOffering})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ChaoticOffering})

	if fManaAfter > fManaThreshold2 then
		local hTargetAlly = nil
		local hTargetAllyHP = math.huge
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and not J.IsSuspiciousIllusion(allyHero)
			and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not allyHero:HasModifier('modifier_warlock_shadow_word')
			then
				local allyHP = J.GetHP(allyHero)
				if allyHP < hTargetAllyHP and allyHP <= 0.65 then
					hTargetAlly = allyHero
					hTargetAllyHP = allyHP
				end
			end
		end

		if hTargetAlly then
			return BOT_ACTION_DESIRE_HIGH, hTargetAlly
		end
	end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		and J.WillKillTarget(enemyHero, nDPS * nDuration, DAMAGE_TYPE_MAGICAL, nDuration + nCastPoint)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not enemyHero:HasModifier('modifier_warlock_shadow_word')
		and not J.IsGoingOnSomeone(bot)
		and fManaAfter > fManaThreshold1
        then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not botTarget:HasModifier('modifier_warlock_shadow_word')
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderUpheaval()
	if not J.CanCastAbility(Upheaval) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = Upheaval:GetCastRange()
	local nCastPoint = Upheaval:GetCastPoint()
	local nRadius = Upheaval:GetSpecialValueInt('aoe')
	local nManaCost = Upheaval:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FatalBonds, ShadowWord, ChaoticOffering})

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 800) then
			return BOT_ACTION_DESIRE_NONE, 0
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5)
                or (nLocationAoE.count >= 4 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.CanCastAbility(FatalBonds)
	or J.CanCastAbility(ShadowWord)
	or J.CanCastAbility(ChaoticOffering)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius / 2, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not J.IsChasingTarget(bot, enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				then
					if enemyHero:HasModifier('modifier_enigma_black_hole_pull')
					or enemyHero:HasModifier('modifier_legion_commander_duel')
					or enemyHero:HasModifier('modifier_bane_fiends_grip')
					or enemyHero:HasModifier('modifier_sand_king_epicenter_slow')
					or enemyHero:HasModifier('modifier_jakiro_macropyre_burn')
					then
						if J.IsCore(enemyHero) and J.GetHP(enemyHero) > 0.4 then
							return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
						end
					end

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
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			local nInRangeEnemy = botTarget:GetNearbyHeroes(nRadius * 0.8, false, BOT_MODE_NONE)
			if J.IsDisabled(botTarget) or #nInRangeEnemy >= 2 then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderChaoticOffering()
	if not J.CanCastAbility(ChaoticOffering) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ChaoticOffering:GetCastRange()
	local nCastPoint = ChaoticOffering:GetCastPoint()
	local nRadius = ChaoticOffering:GetSpecialValueInt('aoe')
	local nManaCost = ChaoticOffering:GetManaCost()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and enemyHero:IsChanneling()
		and enemyHero:GetLevel() >= 6
		and J.IsInRange(bot, enemyHero, nCastRange)
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_teleporting')
		and not enemyHero:IsMagicImmune()
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
			local sEnemyHeroName = enemyHero:GetUnitName()

			if (sEnemyHeroName == 'npc_dota_hero_enigma')
			or (sEnemyHeroName == 'npc_dota_hero_witch_doctor')
			or (sEnemyHeroName == 'npc_dota_hero_bane')
			or (sEnemyHeroName == 'npc_dota_hero_dawnbreaker' and #nAllyHeroesAttackingTarget > 0)
			then
				if #nInRangeAlly >= #nInRangeEnemy or J.IsInTeamFight(bot, 1200) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end

		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not (#nAllyHeroes >= #nEnemyHeroes + 2)
		then
			if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nCastPoint then
				if J.GetHP(enemyHero) > 0.4 and (J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, 5.0) > enemyHero:GetHealth()) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			if not (#nAllyHeroes >= #nEnemyHeroes + 2) then
				if (J.IsInTeamFight(bot, 1200))
				or (J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 5.0) > botTarget:GetHealth() and (J.GetHP(botTarget) > 0.35 or J.IsCore(botTarget)))
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X
