local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_dazzle'
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
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,1,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_faerie_fire",
			
				"item_bottle",
				"item_magic_wand",
				"item_arcane_boots",
				"item_orchid",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_octarine_core",--
				"item_hurricane_pike",--
				"item_bloodthorn",--
				"item_sphere",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_circlet", "item_ultimate_scepter",
				"item_circlet", "item_octarine_core",
				"item_magic_wand", "item_hurricane_pike",
				"item_bottle", "item_sphere",
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
				"item_blood_grenade",
				"item_magic_stick",
				"item_enchanted_mango",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_solar_crest",--
				"item_aghanims_shard",
				"item_holy_locket",--
				"item_boots_of_bearing",--
				"item_octarine_core",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard"
			},
            ['sell_list'] = {},
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
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_magic_stick",
				"item_enchanted_mango",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_solar_crest",--
				"item_aghanims_shard",
				"item_holy_locket",--
				"item_guardian_greaves",--
				"item_octarine_core",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard"
			},
            ['sell_list'] = {},
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

local abilityQ = bot:GetAbilityByName('dazzle_poison_touch')
local abilityW = bot:GetAbilityByName('dazzle_shallow_grave')
local abilityE = bot:GetAbilityByName('dazzle_shadow_wave')
local abilityR = bot:GetAbilityByName('dazzle_bad_juju')
local NothlProjection = bot:GetAbilityByName('dazzle_nothl_projection')
local NothlProjectionEnd = bot:GetAbilityByName('dazzle_nothl_projection_end')

local castQDesire, castQTarget
local castWDesire, castWTarget
local castEDesire, castETarget
local castRDesire
local NothlProjectionDesire, NothlProjectionLocation
local NothlProjectionEndDesire

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) or bot:HasModifier('modifier_dazzle_nothl_projection_physical_body_debuff') then return end

	abilityQ = bot:GetAbilityByName('dazzle_poison_touch')
	abilityW = bot:GetAbilityByName('dazzle_shallow_grave')
	abilityE = bot:GetAbilityByName('dazzle_shadow_wave')
	abilityR = bot:GetAbilityByName('dazzle_bad_juju')
	NothlProjection = bot:GetAbilityByName('dazzle_nothl_projection')
	NothlProjectionEnd = bot:GetAbilityByName('dazzle_nothl_projection_end')

	NothlProjectionDesire, NothlProjectionLocation = X.ConsiderNothlProjection()
	if NothlProjectionDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbilityOnLocation(NothlProjection, NothlProjectionLocation)
		return
	end

	NothlProjectionEndDesire = X.ConsiderNothlProjectionEnd()
	if NothlProjectionEndDesire > 0 then
		bot:Action_UseAbility(NothlProjectionEnd)
		return
	end

	castWDesire, castWTarget = X.ConsiderW()
	if ( castWDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnEntity( abilityW, castWTarget )
		return
	end

	castQDesire, castQTarget = X.ConsiderQ()
	if ( castQDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnEntity( abilityQ, castQTarget )
		return
	end

	castEDesire, castETarget = X.ConsiderE()
	if ( castEDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnEntity( abilityE, castETarget )
		return
	end

	castRDesire = X.ConsiderR()
	if ( castRDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbility( abilityR )
		return
	end
end

function X.ConsiderQ()
	if not J.CanCastAbility(abilityQ) then return BOT_ACTION_DESIRE_NONE, nil end

	local nSkillLV = abilityQ:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, abilityQ:GetCastRange())
	local nManaCost = abilityQ:GetManaCost()
	local nPerDamage = abilityQ:GetSpecialValueInt( "damage" )

    if string.find(bot:GetUnitName(), 'dazzle')
    then
        local talent20left = bot:GetAbilityByName('special_bonus_unique_dazzle_3')
        if talent20left:IsTrained() then nPerDamage = nPerDamage + talent20left:GetSpecialValueInt( "value" ) end
    end

	local nDuration = abilityQ:GetSpecialValueInt( "duration" )

	local nDamage = nPerDamage * nDuration

	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.IsInRange(bot, npcEnemy, nCastRange + 200)
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanCastOnTargetAdvanced( npcEnemy )
			and J.CanKillTarget( npcEnemy, nDamage, nDamageType )
            and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
            and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcWeakestEnemy = nil
		local npcWeakestEnemyHealth = 10000

		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
                and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyHealth = npcEnemy:GetHealth()
				if ( npcEnemyHealth < npcWeakestEnemyHealth )
				then
					npcWeakestEnemyHealth = npcEnemyHealth
					npcWeakestEnemy = npcEnemy
				end
			end
		end

		if npcWeakestEnemy ~= nil
			and J.IsInRange( bot, npcWeakestEnemy, nCastRange + 100 )
		then
			return BOT_ACTION_DESIRE_HIGH, npcWeakestEnemy
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange + 50 )
			and J.CanCastOnNonMagicImmune( botTarget )
			and J.CanCastOnTargetAdvanced( botTarget )
		then
			if nSkillLV >= 2 or J.GetMP(bot) > 0.68 or J.GetHP( botTarget ) < 0.43 or J.GetHP(bot) <= 0.4
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsFarming( bot )
		and nSkillLV >= 3
		and nAllyHeroes ~= nil and #nAllyHeroes <= 1
		and J.IsAllowedToSpam( bot, nManaCost * 0.25 )
	then
		local nCreeps = bot:GetNearbyNeutralCreeps( nCastRange + 200 )

		local targetCreep = J.GetMostHpUnit( nCreeps )

		if J.IsValid( targetCreep )
			and not J.IsRoshan( targetCreep )
			and #nCreeps >= 3
			and bot:IsFacingLocation( targetCreep:GetLocation(), 40 )
			and ( targetCreep:GetMagicResist() < 0.3 or J.GetMP(bot) > 0.9 )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.88, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost )
		and nSkillLV >= 3 and DotaTime() > 6 * 60
        and nAllyHeroes ~= nil and #nAllyHeroes <= 2
        and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local nLaneCreeps = bot:GetNearbyLaneCreeps( nCastRange + 300, true )
		local targetCreep = nLaneCreeps[3]

		if #nLaneCreeps >= 4
			and J.IsValid( targetCreep )
			and J.CanBeAttacked(targetCreep)
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.88, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.CanBeAttacked(botTarget)
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if ( nEnemyHeroes ~= nil and #nEnemyHeroes > 0 or bot:WasRecentlyDamagedByAnyHero( 3.0 ) )
		and ( not J.IsRetreating(bot) or nAllyHeroes ~= nil and #nAllyHeroes >= 2 )
		and J.IsValidHero(nEnemyHeroes[1])
		and nSkillLV >= 4
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end


function X.ConsiderW()
	if not J.CanCastAbility(abilityW) then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, abilityW:GetCastRange())

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

	for _, npcAlly in pairs( nAllyHeroes )
	do
		if J.IsValidHero( npcAlly )
        and not npcAlly:IsIllusion()
        and J.IsInRange( bot, npcAlly, nCastRange + 600 )
        and not npcAlly:HasModifier( 'modifier_dazzle_shallow_grave' )
        and J.GetHP( npcAlly ) < 0.4
		then
			local nCastDelay = X.GetCastAbilityWDelay( npcAlly, nCastRange ) * 1.1
			if X.GetEnemyFacingAllyDamage( npcAlly, 1100, nCastDelay ) > npcAlly:GetHealth()
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end

			if npcAlly:GetHealth() < 200
			then

				if npcAlly:HasModifier( 'modifier_sniper_assassinate' )
				then
					return BOT_ACTION_DESIRE_HIGH, npcAlly
				end

				if npcAlly:HasModifier( 'modifier_huskar_burning_spear_counter' )
                or npcAlly:HasModifier( 'modifier_jakiro_macropyre_burn' )
                or npcAlly:HasModifier( 'modifier_necrolyte_reapers_scythe' )
                or npcAlly:HasModifier( 'modifier_viper_viper_strike_slow' )
                or npcAlly:HasModifier( 'modifier_viper_nethertoxin' )
                or npcAlly:HasModifier( 'modifier_viper_poison_attack_slow' )
                or npcAlly:HasModifier( 'modifier_maledict' )
				then
					return BOT_ACTION_DESIRE_HIGH, npcAlly
				end
			end

			if J.GetHP( npcAlly ) < 0.13
            and J.IsInRange( bot, npcAlly, nCastRange + 200 )
            and J.GetEnemyCount( npcAlly, 600 ) >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderE()
	if not J.CanCastAbility(abilityE) then return 0 end

	local nSkillLV = abilityE:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, abilityE:GetCastRange())
	local nRadius = abilityE:GetSpecialValueInt( 'damage_radius' )
	local nDamage = abilityE:GetSpecialValueInt( 'damage' )
	local nMaxHealCount = abilityE:GetSpecialValueInt( 'tooltip_max_targets_inc_dazzle' )
	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local nInRangeAllyList = J.GetAlliesNearLoc( bot:GetLocation(), nCastRange + 300 )
    local botTarget = J.GetProperTarget(bot)

	local nWeakestAlly = J.GetLeastHpUnit( nInRangeAllyList )

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if string.find(bot:GetUnitName(), 'dazzle')
    then
        local talent15right = bot:GetAbilityByName('special_bonus_unique_dazzle_2')
        if talent15right:IsTrained() then nDamage = nDamage + talent15right:GetSpecialValueInt( "value" ) end
    end

	local nNeedHealHeroCount = 0
	for _, npcAlly in pairs( nAllyHeroes )
	do
		if J.IsValidHero(npcAlly)
        then
            if npcAlly:GetMaxHealth() - npcAlly:GetHealth() > nDamage
            then
                nNeedHealHeroCount = nNeedHealHeroCount + 1
            end
        end
	end

	if J.IsValid(nWeakestAlly)
	then
		if J.GetHP( nWeakestAlly ) < 0.8
        and ( nNeedHealHeroCount >= nMaxHealCount - 2 or nNeedHealHeroCount >= 4 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end

		if J.GetHP( nWeakestAlly ) < 0.6
        and ( J.GetMP(bot) > 0.9
            or nNeedHealHeroCount >= nMaxHealCount - 3
            or nNeedHealHeroCount >= 3 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end

		if J.GetHP( nWeakestAlly ) < 0.35
        or ( J.GetHP( nWeakestAlly ) < 0.5 and nNeedHealHeroCount >= 2 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end
	end

	if nAllyHeroes ~= nil and #nAllyHeroes <= 2
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    and nSkillLV >= 3
    and J.IsAllowedToSpam( bot, 90 )
	then
		local allyCreepList = bot:GetNearbyLaneCreeps( 1400, false )
		local needHealCreepCount = 0
		for _, creep in pairs( allyCreepList )
		do
            if J.IsValid(creep)
            then
                if creep:GetMaxHealth() - creep:GetHealth() > nDamage
                then
                    needHealCreepCount = needHealCreepCount + 1
                elseif creep:GetMaxHealth() - creep:GetHealth() > nDamage * 0.6
                then
                    needHealCreepCount = needHealCreepCount + 0.6
                end
            end
		end

		if needHealCreepCount >= nMaxHealCount - 1
		then
			local nWeakestCreep = J.GetLeastHpUnit( allyCreepList )
			if J.IsValid(nWeakestCreep)
			then
				return 	BOT_ACTION_DESIRE_HIGH, nWeakestCreep
			end
		end
	end

	local abilityETotalDamage = 0
	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.IsInRange( bot, npcEnemy, nCastRange + 300 )
        and J.CanCastOnMagicImmune( npcEnemy )
		then
			local allyUnitCount = J.GetUnitAllyCountAroundEnemyTarget( npcEnemy, nRadius )
			if J.CanKillTarget( npcEnemy, allyUnitCount * nDamage, nDamageType )
			then
				local target = X.GetBestHealTarget( npcEnemy, nRadius )
				if J.IsValid(target)
				then
					return BOT_ACTION_DESIRE_HIGH, target
				end
			end

			if allyUnitCount >= 1 and nSkillLV >= 3
			then
				abilityETotalDamage = abilityETotalDamage + allyUnitCount * nDamage
			end
			if abilityETotalDamage >= 800
            and nWeakestAlly ~= nil
            and J.IsInRange( bot, nWeakestAlly, nCastRange + 50 )
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestAlly
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange + 200 )
        and J.CanCastOnMagicImmune( botTarget )
		then
			local allyUnitCount = J.GetUnitAllyCountAroundEnemyTarget( botTarget, nRadius )
			if allyUnitCount >= nMaxHealCount - 2 or allyUnitCount >= 4
			then
				local target = X.GetBestHealTarget( botTarget, nRadius )
				if target ~= nil
				then
					return 	BOT_ACTION_DESIRE_HIGH, target
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderR()
	if not J.CanCastAbility(abilityR) then return BOT_ACTION_DESIRE_NONE end

    local nBaseHealth = 75
    local nCDR = abilityR:GetSpecialValueInt('cooldown_reduction')
    local nJuJuStacks = bot:GetModifierStackCount(bot:GetModifierByName('modifier_dazzle_bad_juju_manacost'))

    local _, PoisonTouch_ = J.HasAbility(bot, 'dazzle_poison_touch')
    local _, ShallowGrave_ = J.HasAbility(bot, 'dazzle_shallow_grave')
    local _, ShadowWave_ = J.HasAbility(bot, 'dazzle_shadow_wave')

    if J.IsRetreating(bot) and J.IsRealInvisible(bot) and ShallowGrave_ ~= nil and not ShallowGrave_:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if PoisonTouch_ ~= nil and not PoisonTouch_:IsFullyCastable()
    and ShallowGrave_ ~= nil and not ShallowGrave_:IsFullyCastable()
    and ShadowWave_ ~= nil and not ShadowWave_:IsFullyCastable()
    and (bot:HasModifier('modifier_dazzle_shallow_grave') or J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.25)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if ShallowGrave_ ~= nil and ShallowGrave_:GetCooldownTimeRemaining() > nCDR
    and J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.15
	then
		return BOT_ACTION_DESIRE_HIGH
	end

    if not string.find(bot:GetUnitName(), 'dazzle')
    and J.IsGoingOnSomeone(bot)
    then
        local sAbilityList_ = J.Skill.GetAbilityList(bot)
        local ability1 = bot:GetAbilityByName(sAbilityList_[1])
        local ability2 = bot:GetAbilityByName(sAbilityList_[2])
        local ability3 = bot:GetAbilityByName(sAbilityList_[3])

        if J.IsGoingOnSomeone(bot)
        and J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.25
        then
            if (ability1 ~= nil and not ability1:IsPassive() and ability1:GetCooldownTimeRemaining() > nCDR)
            or (ability2 ~= nil and not ability2:IsPassive() and ability2:GetCooldownTimeRemaining() > nCDR)
            or (ability3 ~= nil and not ability3:IsPassive() and ability3:GetCooldownTimeRemaining() > nCDR)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderNothlProjection()
	if not J.CanCastAbility(NothlProjection)
	or bot:HasModifier('modifier_dazzle_nothl_projection_soul_debuff')
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local bSpellsAvailable = J.CanCastAbility(abilityQ)

	if J.IsInTeamFight(bot, 1200) and bSpellsAvailable then
		local nTeamFightLocation = J.GetTeamFightLocation(bot)
		if nTeamFightLocation ~= nil and GetUnitToLocationDistance(bot, nTeamFightLocation) < 900 then
			local nAllyHeroes = J.GetAlliesNearLoc(nTeamFightLocation, 1200)
			local nEnemyHeroes = J.GetEnemiesNearLoc(nTeamFightLocation, 1600)
			if #nAllyHeroes >= #nEnemyHeroes then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	local botTarget = J.GetProperTarget(bot)
	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 500)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsCore(botTarget)
		and J.GetHP(botTarget) < 0.7
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			local nAllyHeroes = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nEnemyHeroes = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
			local nEnemyTowers = bot:GetNearbyTowers(900, true)
			if #nAllyHeroes >= #nEnemyHeroes
			and not (#nAllyHeroes >= #nEnemyHeroes + 2)
			and #nEnemyTowers == 0
			then
				if #nEnemyHeroes <= 1 then
					local nDamage = bot:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL)
					if (botTarget:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_ALL) / bot:GetHealth()) >= 0.4 then
						return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
					end
				else
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderNothlProjectionEnd()
	if not J.CanCastAbility(NothlProjectionEnd) then
		return BOT_ACTION_DESIRE_NONE
	end

	local hOriginal = nil

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if J.IsValidHero(unit) and string.find(unit:GetUnitName(), 'dazzle') and unit:HasModifier('modifier_dazzle_nothl_projection_physical_body_debuff') then
			hOriginal = unit
			break
		end
	end

	local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
	local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

	if hOriginal ~= nil then
		nEnemyHeroes = J.GetEnemiesNearLoc(hOriginal:GetLocation(), 1600)
		if #nEnemyHeroes == 0 or GetUnitToUnitDistance(bot, hOriginal) > 1200 then
			return BOT_ACTION_DESIRE_HIGH
		end

		if (#nEnemyHeroes > #nAllyHeroes)
		or (not J.CanCastAbility(abilityQ) and not J.CanCastAbility(abilityW) and not J.CanCastAbility(abilityE) and J.GetModifierTime(bot, 'modifier_dazzle_nothl_projection_soul_debuff') <= 5.0)
		then
			nEnemyHeroes = J.GetEnemiesNearLoc(hOriginal:GetLocation(), 600)
			if #nEnemyHeroes <= 1 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.GetBestHealTarget( npcEnemy, nRadius )
	local bestTarget = nil
	local maxLostHealth = -1

	local allyCreepList = bot:GetNearbyCreeps( 1600, false )
	local allyHeroList = bot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE )
	local allyUnit = J.CombineTwoTable( allyCreepList, allyHeroList )

	for _, unit in pairs( allyUnit )
	do
		if J.IsValid(unit)
        and J.IsInRange( npcEnemy, unit, nRadius + 9 )
			and unit:GetMaxHealth() - unit:GetHealth() > maxLostHealth
		then
			maxLostHealth = unit:GetMaxHealth() - unit:GetHealth()
			bestTarget = unit
		end
	end

	return bestTarget
end

function X.GetCastAbilityWDelay( npcAlly, nCastRange )
	if not J.IsInRange( bot, npcAlly, nCastRange )
	then
		local nDistance = GetUnitToUnitDistance( bot, npcAlly ) - nCastRange
		local moveDelay = nDistance/bot:GetCurrentMovementSpeed()

		return 0.4 + moveDelay + 1.3
	end

	return 0.4 + 1.1
end

function X.GetEnemyFacingAllyDamage( npcAlly, nRadius, nDelay )
	local enemyList = J.GetEnemyList( npcAlly, nRadius )
	local totalDamage = 0

	for _, npcEnemy in pairs( enemyList )
	do
		if J.IsValidHero(npcEnemy)
        and (npcEnemy:IsFacingLocation( npcAlly:GetLocation(), 15 )
			or npcEnemy:GetAttackTarget() == npcAlly)
		then
			local enemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, npcAlly, nDelay, DAMAGE_TYPE_ALL )
			totalDamage = totalDamage + enemyDamage
		end
	end

	return totalDamage
end

return X