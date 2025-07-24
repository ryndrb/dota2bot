local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_skeleton_king'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_gauntlets",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_armlet",
				"item_radiance",--
				"item_blink",
				"item_black_king_bar",--
				"item_assault",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_swift_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_radiance",
				"item_gauntlets", "item_blink",
				"item_gauntlets", "item_black_king_bar",
				"item_magic_wand", "item_assault",
				"item_armlet", "item_abyssal_blade",
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
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_gauntlets",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_armlet",
				"item_radiance",--
				"item_blink",
				"item_black_king_bar",--
				"item_assault",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_swift_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_radiance",
				"item_gauntlets", "item_blink",
				"item_gauntlets", "item_black_king_bar",
				"item_magic_wand", "item_assault",
				"item_armlet", "item_abyssal_blade",
			},
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_heavens_halberd", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )


X['bDeafaultAbility'] = true
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
		and hMinionUnit:GetUnitName() ~= "npc_dota_wraith_king_skeleton_warrior"
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local WraithfireBlast = bot:GetAbilityByName('skeleton_king_hellfire_blast')
local BoneGuard = bot:GetAbilityByName('skeleton_king_bone_guard')
local SpectralBlade = bot:GetAbilityByName('skeleton_king_spectral_blade')
local MortalStrike = bot:GetAbilityByName('skeleton_king_mortal_strike')
local Reincarnation = bot:GetAbilityByName('skeleton_king_reincarnation')

local WraithfireBlastDesire, WraithfireBlastTarget
local BoneGuardDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	WraithfireBlast = bot:GetAbilityByName('skeleton_king_hellfire_blast')
	BoneGuard = bot:GetAbilityByName('skeleton_king_bone_guard')
	Reincarnation = bot:GetAbilityByName('skeleton_king_reincarnation')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	WraithfireBlastDesire, WraithfireBlastTarget = X.ConsiderWraithfireBlast()
	if WraithfireBlastDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(WraithfireBlast, WraithfireBlastTarget)
		return
	end

	BoneGuardDesire = X.ConsiderBoneGuard()
	if BoneGuardDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(BoneGuard)
		return
	end
end

function X.ConsiderWraithfireBlast()
	if not J.CanCastAbility(WraithfireBlast) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, WraithfireBlast:GetCastRange())
	local nCastPoint = WraithfireBlast:GetCastPoint()
	local nSpeed = WraithfireBlast:GetSpecialValueInt('blast_speed')
	local nDamage = WraithfireBlast:GetSpecialValueInt('damage')
    local nManaCost = WraithfireBlast:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WraithfireBlast, BoneGuard, Reincarnation})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BoneGuard, Reincarnation})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Reincarnation, 100})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and fManaAfter > fManaThreshold3
		then
			if enemyHero:IsChanneling() and fManaAfter > fManaThreshold2 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) and fManaAfter > fManaThreshold3 then
        for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if (J.IsChasingTarget(enemyHero, bot))
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

    if ((J.IsPushing(bot) or J.IsDefending(bot)) and #nEnemyHeroes <= 1) or J.IsFarming(bot) then
        if  J.IsValid(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastPoint)
        and botTarget:IsCreep()
        and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
        and not J.CanKillTarget(botTarget, nDamage * 1.5, DAMAGE_TYPE_MAGICAL)
        and not J.IsOtherAllysTarget(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold3 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and not J.IsRunning(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('range', creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 500)
                if  J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PURE, eta)
				and (J.IsUnitTargetedByTower(creep, true) or #nInRangeEnemy > 0)
				then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
			end
		end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			and not J.IsDisabled(enemyHero)
			and J.GetAttackEnemysAllyCreepCount(enemyHero, 1400) >= 4
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
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
        and not J.IsDisabled(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBoneGuard()
	if not J.CanCastAbility(BoneGuard)
	or not bot:HasModifier('modifier_skeleton_king_bone_guard')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nStack = J.GetModifierCount(bot, 'modifier_skeleton_king_bone_guard')
	local nStackMax = BoneGuard:GetSpecialValueInt('max_skeleton_charges')
	local nManaCost = BoneGuard:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WraithfireBlast, Reincarnation})

	local hTalent_20Left = bot:GetAbilityByName('special_bonus_unique_wraith_king_facet_3')
	local bTalent_20Left = hTalent_20Left and hTalent_20Left:IsTrained()

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and (nStack / nStackMax >= 0.6 or bTalent_20Left)
		and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot) then
		local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
		if #nEnemyCreeps >= 3 and bAttacking and (nStack == nStackMax or bTalent_20Left) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
