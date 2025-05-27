local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_huskar'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe"}
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
            },
            ['ability'] = {
				[1] = {2,3,3,2,3,6,3,1,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_faerie_fire",
				"item_double_gauntlets",
				"item_double_branches",
			
				"item_magic_wand",
				"item_boots",
				"item_armlet",
				"item_phase_boots",
				"item_sange_and_yasha",--
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_satanic",--
				"item_aghanims_shard",
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_hurricane_pike",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_gauntlets", "item_black_king_bar",
				"item_gauntlets", "item_ultimate_scepter",
				"item_magic_wand", "item_satanic",
				"item_armlet", "item_hurricane_pike",
			},
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
				},
				[2] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,3,2,3,6,3,1,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_faerie_fire",
				"item_double_gauntlets",
			
				"item_boots",
				"item_armlet",
				"item_vanguard",
				"item_black_king_bar",--
				"item_heavens_halberd",--
				"item_ultimate_scepter",
				"item_travel_boots",
				"item_satanic",--
				"item_aghanims_shard",
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_hurricane_pike",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_gauntlets", "item_ultimate_scepter",
				"item_gauntlets", "item_satanic",
				"item_armlet", "item_hurricane_pike",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {1,3,2,2,3,6,3,3,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_faerie_fire",
			
				"item_double_bracer",
				"item_boots",
				"item_armlet",
				"item_vanguard",
				"item_black_king_bar",--
				"item_heavens_halberd",--
				sUtilityItem,--
				"item_ultimate_scepter",
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_travel_boots",
				"item_sheepstick",--
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_bracer", sUtilityItem,
				"item_bracer", "item_ultimate_scepter",
				"item_armlet", "item_sheepstick",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_huskar' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local abilityQ = bot:GetAbilityByName('huskar_inner_fire')
local abilityW = bot:GetAbilityByName('huskar_burning_spear')
local abilityE = bot:GetAbilityByName('huskar_berserkers_blood')
local abilityR = bot:GetAbilityByName('huskar_life_break')

local castQDesire
local castWDesire, castWTarget
local BerserkersBloodDesire
local castRDesire, castRTarget

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	abilityQ = bot:GetAbilityByName('huskar_inner_fire')
	abilityW = bot:GetAbilityByName('huskar_burning_spear')
	abilityR = bot:GetAbilityByName('huskar_life_break')

	botTarget = J.GetProperTarget( bot )

	castQDesire = X.ConsiderQ()
	if ( castQDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbility( abilityQ )
		return
	end


	castRDesire, castRTarget = X.ConsiderR()
	if ( castRDesire > 0 )
	then
		bot:Action_ClearActions( true )
		bot:ActionQueue_UseAbilityOnEntity( abilityR, castRTarget )
		return

	end


	castWDesire, castWTarget = X.ConsiderW()
	if ( castWDesire > 0 )
	then
		bot:Action_ClearActions( false )
		bot:ActionQueue_UseAbilityOnEntity( abilityW, castWTarget )
		return
	end

	BerserkersBloodDesire = X.ConsiderBerserkersBlood()
	if BerserkersBloodDesire > 0 then
		bot:Action_ClearActions( false )
		bot:ActionQueue_UseAbility(abilityE)
		return
	end
end

function X.ConsiderQ()
	if not J.CanCastAbility(abilityQ) then return 0 end

	local nSkillLV = abilityQ:GetLevel()
	local nCastPoint = abilityQ:GetCastPoint()
	local nDamage = abilityQ:GetSpecialValueInt( 'damage' )
	local nRadius = abilityQ:GetSpecialValueInt( 'radius' )
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = bot:GetNearbyHeroes( nRadius -32, true, BOT_MODE_NONE )

	local nCanHurtCount = 0
	for _, npcEnemy in pairs( nInRangeEnemyList )
	do
		if J.IsValidHero( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
		then

			nCanHurtCount = nCanHurtCount + 1
			if nCanHurtCount >= 2
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.WillMagicKillTarget( bot, npcEnemy, nDamage, nCastPoint )
            and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
            and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.IsRetreating( bot )
            and not J.IsRealInvisible(bot)
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
			then
				return BOT_ACTION_DESIRE_HIGH
			end

		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nRadius -32 )
			and ( not J.IsInRange( bot, botTarget, 200 )
				or J.IsAttacking( botTarget )
				or botTarget:GetAttackTarget() ~= nil )
			and J.CanCastOnNonMagicImmune( botTarget )
			and not J.IsDisabled( botTarget )
			and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    local nLaneCreepList = bot:GetNearbyLaneCreeps( nRadius, true )

	if J.IsLaning( bot )
	then
		local nCanKillCount = 0
		for _, creep in pairs( nLaneCreepList )
		do
			if J.IsValid( creep )
				and J.CanBeAttacked(creep)
				and J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint )
			then
				nCanKillCount = nCanKillCount + 1
			end
		end
		if nCanKillCount >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming( bot ) and bot:GetLevel() >= 8
        and J.GetHP(bot) > 0.45
	then
		local nCreepList = bot:GetNearbyNeutralCreeps( nRadius )
		local targetCreep = nCreepList[1]
		if nCreepList ~= nil and #nCreepList >= 2
			and J.IsValid( targetCreep )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 2.2, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    local hAllyList = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if hEnemyList ~= nil and #hEnemyList == 0 and hAllyList ~= nil and #hAllyList <= 2 and nSkillLV >= 3 and bot:GetLevel() >= 8
		and J.GetHP(bot) > 0.4
		and ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
	then
		local nCanKillCount = 0
		nCanHurtCount = 0
		for _, creep in pairs( nLaneCreepList )
		do
			if J.IsValid( creep )
				and J.CanBeAttacked(creep)
			then
				nCanHurtCount = nCanHurtCount + 1

				if J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint )
				then
					nCanKillCount = nCanKillCount + 1
				end
			end
		end

		if nCanKillCount >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
		if nCanHurtCount >= 4
		then
			return BOT_ACTION_DESIRE_HIGH
		end

	end

	if J.IsDoingRoshan( bot )
	then
		if J.IsRoshan( botTarget )
			and J.IsInRange( bot, botTarget, nRadius)
			and J.GetHP( botTarget ) > 0.3
            and J.GetHP(bot) > 0.45
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor( bot )
	then
		if J.IsTormentor( botTarget )
			and J.IsInRange( bot, botTarget, nRadius)
            and J.GetHP(bot) > 0.45
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


local lastAutoTime = 0
function X.ConsiderW()
	if not J.CanCastAbility(abilityW) or bot:IsDisarmed() then return 0 end

	local nCastRange = bot:GetAttackRange() + 50

	local nAttackDamage = bot:GetAttackDamage()

	local nTowerList = bot:GetNearbyTowers( 800, true )
	local nInAttackRangeWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, nCastRange, true, true )

    local hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if bot:GetLevel() >= 7
	then
		if ( hEnemyList[1] ~= nil
			or ( bot:GetLevel() >= 15 and J.GetHP(bot) > 0.38 ) )
			and not abilityW:GetAutoCastState()
		then
			lastAutoTime = DotaTime()
			abilityW:ToggleAutoCast()
		elseif hEnemyList[1] == nil
				and lastAutoTime < DotaTime() - 3.0
				and abilityW:GetAutoCastState()
			then
				abilityW:ToggleAutoCast()
		end
	else
		if abilityW:GetAutoCastState()
		then
			abilityW:ToggleAutoCast()
		end
	end

	if bot:GetLevel() <= 6 and not abilityW:GetAutoCastState()
		and J.IsValidHero( botTarget )
		and J.IsInRange( bot, botTarget, nCastRange + 99 )
		and ( not J.IsRunning( bot ) or J.IsInRange( bot, botTarget, nCastRange + 39 ) )
		and not botTarget:IsMagicImmune()
		and not botTarget:IsAttackImmune()
	then
		return BOT_ACTION_DESIRE_HIGH, botTarget
	end

	if J.IsLaning( bot ) and #nTowerList == 0 and J.GetHP(bot) > 0.5
	then
		if J.IsWithoutTarget( bot )
			and not J.IsAttacking( bot )
		then
			local nLaneCreepList = bot:GetNearbyLaneCreeps( 666, true )
			for _, creep in pairs( nLaneCreepList )
			do
				if J.IsValid( creep )
					and J.CanBeAttacked(creep)
					and creep:GetHealth() < nAttackDamage * 2.8
					and not J.IsAllysTarget( creep )
				then
					local nAttackProDelayTime = J.GetAttackProDelayTime( bot, creep ) * 1.12 + 0.05
					local nAD = nAttackDamage * 1.0
					if J.WillKillTarget( creep, nAD, DAMAGE_TYPE_PHYSICAL, nAttackProDelayTime )
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end

		end

		local nWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, 600, true, true )
		local nAllyCreepList = bot:GetNearbyCreeps( 500, false )
		local nEnemyCreepList = bot:GetNearbyCreeps( 800, true )
		if J.IsValidHero(nWeakestEnemyHero)
			and #nAllyCreepList >= 1
			and #nEnemyCreepList - #nAllyCreepList <= 4
			and not nWeakestEnemyHero:IsMagicImmune()
			and not bot:WasRecentlyDamagedByCreep( 1.5 )
		then
			return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHero
		end
	end

	if J.IsValidHero(botTarget)
		and not J.IsInRange( bot, botTarget, nCastRange + 120 )
		and J.IsValidHero( nInAttackRangeWeakestEnemyHero )
		and not nInAttackRangeWeakestEnemyHero:IsAttackImmune()
		and not nInAttackRangeWeakestEnemyHero:IsMagicImmune()
        and not nInAttackRangeWeakestEnemyHero:HasModifier('modifier_item_blade_mail_reflect')
	then
		bot:SetTarget( nInAttackRangeWeakestEnemyHero )
		return BOT_ACTION_DESIRE_HIGH, nInAttackRangeWeakestEnemyHero
	end

	if J.IsGoingOnSomeone( bot ) and not abilityW:GetAutoCastState()
	then
		if J.IsValidHero( botTarget )
			and not botTarget:IsAttackImmune()
			and J.CanCastOnNonMagicImmune( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange + 80 )
            and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsFarming( bot ) and bot:GetLevel() >= 7 and not abilityW:GetAutoCastState()
	then
		local nCreepList = bot:GetNearbyNeutralCreeps( nCastRange + 80 )
		local hMostHPCreep = J.GetMostHpUnit( nCreepList )
		local hTargetCreep = nil
		local nTargetHealth = 0
		for _, creep in pairs( nCreepList )
		do
			if J.IsValid( creep )
				and not creep:HasModifier( "modifier_huskar_burning_spear_debuff" )
				and creep:GetHealth() > nTargetHealth
			then
				hTargetCreep = creep
				nTargetHealth = creep:GetHealth()
			end
		end

		if J.IsValid(hTargetCreep)
		then
			return BOT_ACTION_DESIRE_HIGH, hTargetCreep
		end

		if J.IsValid(hTargetCreep)
			and not J.CanKillTarget( hMostHPCreep, nAttackDamage * 2.6, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, hMostHPCreep
		end

	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and bot:GetLevel() > 9 and #hEnemyList <= 1 and not abilityW:GetAutoCastState()
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps( nCastRange + 80, true )
		local nAllyLaneCreeps = bot:GetNearbyLaneCreeps( 1200, false )
		local nWeakestCreep = J.GetAttackableWeakestUnit( bot, nCastRange + 200, false, true )

		if ( #nAllyLaneCreeps == 0
			or ( J.IsValid(nWeakestCreep) and nWeakestCreep:GetHealth() > bot:GetAttackDamage() + 88 ) )
			and #nEnemyLaneCreeps >= 2
		then
			local hTargetCreep = nil
			local nTargetHealth = 0
			for _, creep in pairs( nEnemyLaneCreeps )
			do
				if J.IsValid( creep )
					and not J.IsKeyWordUnit( 'siege', creep )
					and not creep:HasModifier( "modifier_huskar_burning_spear_debuff" )
					and not J.CanKillTarget( creep, nAttackDamage * 1.68, DAMAGE_TYPE_PHYSICAL )
					and creep:GetHealth() > nTargetHealth
				then
					hTargetCreep = creep
					nTargetHealth = creep:GetHealth()
				end
			end

			if J.IsValid(hTargetCreep)
			then
				return BOT_ACTION_DESIRE_HIGH, hTargetCreep
			end
		end

	end

	if J.IsDoingRoshan( bot ) and abilityW:GetAutoCastState() == false
	then
		if J.IsRoshan( bot:GetAttackTarget() )
			and J.IsInRange( bot, botTarget, nCastRange -40 )
            and J.IsAttacking(bot)
            and J.GetHP(bot) > 0.3
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor( bot ) and abilityW:GetAutoCastState() == false
	then
		if J.IsTormentor( bot:GetAttackTarget() )
			and J.IsInRange( bot, botTarget, nCastRange -40 )
            and J.IsAttacking(bot)
            and J.GetHP(bot) > 0.35
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end


	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBerserkersBlood()
	if not J.CanCastAbility(abilityE) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nActivationCost = bot:GetHealth() * 0.30 -- <- should be; but in-game shows the wrong number/cost (?)
	local nHealthAfter = J.GetHealthAfter(nActivationCost)

	if nHealthAfter > 0.2 then
		if bot:IsRooted()
		or bot:IsDisarmed()
		or (bot:IsSilenced() and not bot:HasModifier('modifier_item_mask_of_madness_berserk'))
		or bot:HasModifier('modifier_item_spirit_vessel_damage')
		or bot:HasModifier('modifier_dragonknight_breathefire_reduction')
		or bot:HasModifier('modifier_slardar_amplify_damage')
		or bot:HasModifier('modifier_item_dustofappearance')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderR()
	if not J.CanCastAbility(abilityR) then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, abilityR:GetCastRange())

    local hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone( bot )
	then
        if bot:HasScepter()
        then
            for _, enemyHero in pairs(hEnemyList)
            do
                if J.IsValidHero(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange + 88)
                and bot:GetUnitName() == 'npc_dota_hero_bristleback'
                and J.CanCastOnNonMagicImmune( enemyHero )
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    bot:SetTarget(enemyHero)
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end

		if J.IsValidHero( botTarget )
			and J.CanCastOnNonMagicImmune( botTarget )
            and J.CanCastOnTargetAdvanced(botTarget)
			and ( J.IsInRange( bot, botTarget, nCastRange + 88 )
				  or J.IsInRange( bot, botTarget, bot:GetAttackRange() + 99 ) )
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    local hAllyList = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

	if bot:GetLevel() >= 12 and hEnemyList ~= nil and #hEnemyList == 0
		and bot:GetLevel() > 0.38 and hAllyList ~= nil and #hAllyList < 3
		and nCastRange > bot:GetAttackRange() + 58
	then
		if J.IsValid( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
			and not J.IsInRange( bot, botTarget, nCastRange -80 )
			and J.GetHP( botTarget ) > 0.9
			and not botTarget:IsHero()
			and not J.IsRoshan( botTarget )
            and not J.IsTormentor(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X