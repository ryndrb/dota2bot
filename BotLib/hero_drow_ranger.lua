local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_drow_ranger'
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
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,3,6,3,3,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_slippers",
				"item_circlet",
			
				"item_wraith_band",
				"item_power_treads",
				"item_magic_wand",
				"item_dragon_lance",
				"item_manta",
				"item_ultimate_scepter",
				"item_hurricane_pike",--
				"item_black_king_bar",--
				"item_butterfly",--
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_travel_boots",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_wraith_band",
				"item_magic_wand",
				"item_manta",
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

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local abilityQ = bot:GetAbilityByName( sAbilityList[1] )
local abilityW = bot:GetAbilityByName( sAbilityList[2] )
local abilityE = bot:GetAbilityByName( sAbilityList[3] )
local Glacier 	= bot:GetAbilityByName( 'drow_ranger_glacier' )
local abilityM = nil

local castQDesire, castQTarget
local castWDesire, castWLocation
local castEDesire, castELocation
local GlacierDesire
local castMDesire
local castWMDesire, castWMLocation

local nKeepMana, nMP, nHP, nLV, hEnemyList, hAllyList, botTarget, sMotive

function X.SkillsComplement()
	-- J.ConsiderForMkbDisassembleMask( bot )
	if J.CanNotUseAbility( bot ) then return end

	nKeepMana = 90
	nMP = bot:GetMana()/bot:GetMaxMana()
	nHP = bot:GetHealth()/bot:GetMaxHealth()
	nLV = bot:GetLevel()
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	hAllyList = J.GetAlliesNearLoc( bot:GetLocation(), 1600 )
	abilityM = J.IsItemAvailable( "item_mask_of_madness" )

	GlacierDesire = X.ConsiderGlacier()
	if GlacierDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Glacier)
		return
	end

	castEDesire, castELocation = X.ConsiderE()
	if castEDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnLocation( abilityE , castELocation )
		return
	end

	castWMDesire, castWMLocation = X.ConsiderWM()
	if castWMDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnLocation( abilityW , castWMLocation )
		bot:ActionQueue_UseAbility( abilityM )
		return
	end

	castWDesire, castWLocation = X.ConsiderW()
	if castWDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnLocation( abilityW , castWLocation )
		return
	end

	castMDesire = X.ConsiderM()
	if castMDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbility( abilityM )
		return
	end

	castQDesire, castQTarget = X.ConsiderQ()
	if castQDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnEntity( abilityQ , castQTarget )
		return
	end
end

local lastAutoTime = 0
function X.ConsiderQ()
    if not J.CanCastAbility(abilityQ)
    or bot:IsDisarmed()
    or J.GetDistanceFromEnemyFountain( bot ) < 800
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nAttackRange = bot:GetAttackRange() + 40
    local nAttackDamage = bot:GetAttackDamage() + abilityQ:GetSpecialValueInt( "damage" )
    local nDamageType = DAMAGE_TYPE_PHYSICAL
    local nTowers = bot:GetNearbyTowers( 900, true )
    local nEnemysLaneCreepsNearby = bot:GetNearbyLaneCreeps( 400, true )
    local nEnemysWeakestLaneCreepsInRange = J.GetAttackableWeakestUnit( bot, nAttackRange + 30, false, true )
    local nEnemysWeakestLaneCreepsInRangeHealth = 10000

    if J.IsValid(nEnemysWeakestLaneCreepsInRange)
    then
        nEnemysWeakestLaneCreepsInRangeHealth = nEnemysWeakestLaneCreepsInRange:GetHealth()
    end

    local hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemysHeroesInAttackRange = bot:GetNearbyHeroes( nAttackRange, true, BOT_MODE_NONE )
    local nInAttackRangeWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, nAttackRange, true, true )
    local nInViewWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, 800, true, true )

    local nAllyLaneCreeps = bot:GetNearbyLaneCreeps( 330, false )
    local npcTarget = J.GetProperTarget( bot )
    local nTargetUint = nil
    local npcMode = bot:GetActiveMode()


    if bot:GetLevel() >= 8
    then
        if ( J.IsValidHero(hEnemyList[1]) or J.GetMP(bot) > 0.76 )
        and not abilityQ:GetAutoCastState()
        then
            lastAutoTime = DotaTime()
            abilityQ:ToggleAutoCast()
        elseif ( hEnemyList[1] == nil and J.GetMP(bot) < 0.7 )
            and lastAutoTime + 3.0 < DotaTime()
            and abilityQ:GetAutoCastState()
            then
                abilityQ:ToggleAutoCast()
        end
    else
        if abilityQ:GetAutoCastState()
        then
            abilityQ:ToggleAutoCast()
        end
    end

    if bot:GetLevel() <= 7 and J.GetHP(bot) > 0.55
        and J.IsValidHero( npcTarget )
        and ( not J.IsRunning( bot ) or J.IsInRange( bot, npcTarget, nAttackRange + 18 ) )
    then
        if not npcTarget:IsAttackImmune()
            and J.IsInRange( bot, npcTarget, nAttackRange + 99 )
        then
            nTargetUint = npcTarget
            return BOT_ACTION_DESIRE_HIGH, nTargetUint
        end
    end

    if J.IsLaning(bot)
    and nTowers ~= nil and #nTowers == 0
    then
        if J.IsValidHero( nInAttackRangeWeakestEnemyHero )
        then
            if nEnemysWeakestLaneCreepsInRangeHealth > 130
                and J.GetHP(bot) >= 0.6
                and #nEnemysLaneCreepsNearby <= 3
                and #nAllyLaneCreeps >= 2
                and not bot:WasRecentlyDamagedByCreep( 1.5 )
                and not bot:WasRecentlyDamagedByAnyHero( 1.5 )
            then
                nTargetUint = nInAttackRangeWeakestEnemyHero
                return BOT_ACTION_DESIRE_HIGH, nTargetUint
            end
        end


        if J.IsValidHero( nInViewWeakestEnemyHero )
        then
            if nEnemysWeakestLaneCreepsInRangeHealth > 180
                and J.GetHP(bot) >= 0.7
                and #nEnemysLaneCreepsNearby <= 2
                and #nAllyLaneCreeps >= 3
                and not bot:WasRecentlyDamagedByCreep( 1.5 )
                and not bot:WasRecentlyDamagedByAnyHero( 1.5 )
                and not bot:WasRecentlyDamagedByTower( 1.5 )
            then
                nTargetUint = nInViewWeakestEnemyHero
                return BOT_ACTION_DESIRE_HIGH, nTargetUint
            end

            if J.GetUnitAllyCountAroundEnemyTarget( nInViewWeakestEnemyHero , 500 ) >= 4
                and not bot:WasRecentlyDamagedByCreep( 1.5 )
                and not bot:WasRecentlyDamagedByAnyHero( 1.5 )
                and not bot:WasRecentlyDamagedByTower( 1.5 )
                and J.GetHP(bot) >= 0.6
            then
                nTargetUint = nInViewWeakestEnemyHero
                return BOT_ACTION_DESIRE_HIGH, nTargetUint
            end
        end

        if J.IsWithoutTarget( bot )
        and not J.IsAttacking( bot )
        then
            local nLaneCreepList = bot:GetNearbyLaneCreeps( 1100, true )
            for _, creep in pairs( nLaneCreepList )
            do
                if J.IsValid( creep )
                and J.CanBeAttacked(creep)
                and creep:GetHealth() < nAttackDamage + 180
                and not J.IsAllysTarget( creep )
                then
                    local nAttackProDelayTime = J.GetAttackProDelayTime( bot, creep ) * 1.08 + 0.08
                    local nAD = nAttackDamage * 1.0
                    if J.WillKillTarget( creep, nAD, nDamageType, nAttackProDelayTime )
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    end

    if J.IsValidHero(npcTarget)
    and GetUnitToUnitDistance( npcTarget, bot ) > nAttackRange + 160
    and J.IsValidHero( nInAttackRangeWeakestEnemyHero )
    and not nInAttackRangeWeakestEnemyHero:IsAttackImmune()
    then
        nTargetUint = nInAttackRangeWeakestEnemyHero
        bot:SetTarget( nTargetUint )
        return BOT_ACTION_DESIRE_HIGH, nTargetUint
    end

    if bot:HasModifier( "modifier_item_hurricane_pike_range" )
    and J.IsValid( npcTarget )
    then
        nTargetUint = npcTarget
        return BOT_ACTION_DESIRE_HIGH, nTargetUint
    end

    if bot:GetAttackTarget() == nil
    and  bot:GetTarget() == nil
    and  #hEnemyList == 0
    and  npcMode ~= BOT_MODE_RETREAT
    and  npcMode ~= BOT_MODE_ATTACK
    and  npcMode ~= BOT_MODE_ASSEMBLE
    and  npcMode ~= BOT_MODE_FARM
    and  npcMode ~= BOT_MODE_TEAM_ROAM
    and  J.GetTeamFightAlliesCount( bot ) < 3
    and  bot:GetMana() >= 180
    and  not bot:WasRecentlyDamagedByAnyHero( 3.0 )
    then
        if bot:HasScepter()
        then
            local nEnemysCreeps = bot:GetNearbyCreeps( 1600, true )
            if J.IsValid( nEnemysCreeps[1] )
            then
                nTargetUint = nEnemysCreeps[1]
                return BOT_ACTION_DESIRE_HIGH, nTargetUint
            end
        end

        local nNeutralCreeps = bot:GetNearbyNeutralCreeps( 1600 )
        if npcMode ~= BOT_MODE_LANING
            and bot:GetLevel() >= 6
            and J.GetHP(bot) > 0.25
            and J.IsValid( nNeutralCreeps[1] )
            and not J.IsRoshan( nNeutralCreeps[1] )
            and ( nNeutralCreeps[1]:IsAncientCreep() == false or bot:GetLevel() >= 12 )
        then
            nTargetUint = nNeutralCreeps[1]
            return BOT_ACTION_DESIRE_HIGH, nTargetUint
        end


        local nLaneCreeps = bot:GetNearbyLaneCreeps( 1600, true )
        if npcMode ~= BOT_MODE_LANING
            and bot:GetLevel() >= 6
            and J.GetHP(bot) > 0.25
            and J.IsValid( nLaneCreeps[1] )
            and bot:GetAttackDamage() > 130
        then
            nTargetUint = nLaneCreeps[1]
            return BOT_ACTION_DESIRE_HIGH, nTargetUint
        end
    end


    if npcMode == BOT_MODE_RETREAT
    then

        local nDistance = 999
        nTargetUint = nil
        for _, npcEnemy in pairs( nEnemysHeroesInAttackRange )
        do
            if J.IsValidHero( npcEnemy )
            and npcEnemy:HasModifier( "modifier_drowranger_wave_of_silence_knockback" )
            and GetUnitToUnitDistance( npcEnemy, bot ) < nDistance
            then
                nTargetUint = npcEnemy
                nDistance = GetUnitToUnitDistance( npcEnemy, bot )
            end
        end

        if J.IsValidHero(nTargetUint)
        and not nTargetUint:HasModifier( "modifier_drow_ranger_frost_arrows_slow" )
        then
            return BOT_ACTION_DESIRE_HIGH, nTargetUint
        end
    end

    if J.IsFarming( bot )
    and J.GetMP(bot) > 0.55
    and not abilityQ:GetAutoCastState()
    then
        local botTarget = J.GetProperTarget(bot)
        if J.IsValid( botTarget )
        and botTarget:GetTeam() == TEAM_NEUTRAL
        and J.IsInRange( bot, botTarget, 1000 )
        and botTarget:GetHealth() > nAttackDamage
        then
            return BOT_ACTION_DESIRE_LOW, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderW()
    if not J.CanCastAbility(abilityW)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = J.GetProperCastRange(false, bot, abilityW:GetCastRange())
	local nRadius = abilityW:GetAOERadius()
	local nCastPoint = abilityW:GetCastPoint()
	local nTargetLocation = nil

	local nEnemyHeroes = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.IsInRange(bot, npcEnemy, nCastRange + 150)
        and npcEnemy:IsChanneling()
        and not npcEnemy:HasModifier( "modifier_teleporting" )
		then
			nTargetLocation = npcEnemy:GetLocation()
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end


	if bot:GetActiveMode() == BOT_MODE_RETREAT
    and not J.IsRealInvisible(bot)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange-100, nRadius, nCastPoint, 0 )
		if locationAoE.count >= 2
			or ( locationAoE.count >= 1 and J.GetHP(bot) < 0.5 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange + 150)
            and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
			then
				nTargetLocation = npcEnemy:GetExtrapolatedLocation( nCastPoint )
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
        and J.CanCastOnNonMagicImmune( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange )
        and not npcTarget:IsSilenced()
        and not J.IsDisabled( npcTarget )
        and ( npcTarget:IsFacingLocation( bot:GetLocation(), 120 )
                or npcTarget:GetAttackTarget() ~= nil )
		then
			nTargetLocation = npcTarget:GetExtrapolatedLocation( nCastPoint )
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0 )
		if ( locationAoE.count >= 2 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderE()
    if not J.CanCastAbility(abilityE)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = 850
	local nRadius = 200
	local nCastPoint = abilityE:GetCastPoint()
	local nManaCost = abilityE:GetManaCost()
	local nTargetLocation = nil

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE )
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
        and not npcTarget:IsAttackImmune()
        and J.CanCastOnNonMagicImmune( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange )
        and ( npcTarget:IsFacingLocation( bot:GetLocation(), 120 )
            or npcTarget:GetAttackTarget() ~= nil )
		then
			nTargetLocation = npcTarget:GetExtrapolatedLocation( nCastPoint )
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), 780, nRadius, nCastPoint, 0 )
		if ( locationAoE.count >= 2 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
    and J.IsAllowedToSpam( bot, 90 )
    and DotaTime() > 8 * 60
    and nAllyHeroes ~= nil and nEnemyHeroes ~= nil
    and #nAllyHeroes <= 2 and #nEnemyHeroes == 0
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( 1400, true )
		if #laneCreepList >= 4
        and J.CanBeAttacked( laneCreepList[1] )
		then
			local locationAoEHurt = bot:FindAoELocation( true, false, bot:GetLocation(), 700, nRadius + 50, 0, 0 )
			if locationAoEHurt.count >= 3
			then
				nTargetLocation = locationAoEHurt.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if J.IsFarming( bot )
	and J.IsAllowedToSpam( bot, nManaCost )
	then
        local botTarget = J.GetProperTarget(bot)
		if J.IsValid( botTarget )
        and botTarget:GetTeam() == TEAM_NEUTRAL
        and J.IsInRange( bot, botTarget, 1000 )
		then
			local nShouldHurtCount = J.GetMP(bot) > 0.6 and 2 or 3
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), 750, 300, 0, 0 )
			if ( locationAoE.count >= nShouldHurtCount )
			then
				nTargetLocation = locationAoE.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderWM()

	if nLV < 15
		or not J.CanCastAbility(abilityM)
		or not J.CanCastAbility(abilityW)
		or not J.CanCastAbility(abilityQ)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local abilityWCost = abilityW:GetManaCost()
	local abilityMCost = abilityM:GetManaCost()

	if abilityMCost + abilityWCost > bot:GetMana() then return 0 end

	local nCastRange = abilityW:GetCastRange()
	local nCastPoint = abilityW:GetCastPoint()
	local nRadius = abilityW:GetAOERadius()

	local nEnemysHeroesInView = hEnemyList
	local nEnemysHeroesNearBy = bot:GetNearbyHeroes( 500, true, BOT_MODE_NONE )
    local nTargetLocation = nil

	local npcTarget = J.GetProperTarget( bot )

	if J.IsGoingOnSomeone( bot )
		and #nEnemysHeroesNearBy == 0
		and not J.IsEnemyTargetUnit( bot, 1600 )
		and J.GetAllyCount( bot, 1000 ) >= 3
	then

		if J.IsValidHero( npcTarget )
			and not npcTarget:IsSilenced()
			and not J.IsDisabled( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange )
			and npcTarget:IsFacingLocation( bot:GetLocation(), 150 )
			and J.IsAllyHeroBetweenAllyAndEnemy( bot, npcTarget, npcTarget:GetLocation(), 500 )
		then
			nTargetLocation = npcTarget:GetExtrapolatedLocation( nCastPoint )
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0 )
		if ( locationAoE.count >= 2 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderM()

	if not J.CanCastAbility(abilityM) then return BOT_ACTION_DESIRE_NONE end

	local nCastRange = bot:GetAttackRange()
	local nAttackDamage = bot:GetAttackDamage()
	local nDamage = nAttackDamage
	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local npcTarget = J.GetProperTarget( bot )


	if J.IsGoingOnSomeone( bot )
		and #hEnemyList == 1
	then
		if J.IsValidHero( npcTarget )
			and J.CanBeAttacked( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and not J.IsInRange( npcTarget, bot, 400 )
			and J.IsInRange( npcTarget, bot, nCastRange + 300 )
			and bot:IsFacingLocation( npcTarget:GetLocation(), 30 )
			and not npcTarget:IsFacingLocation( bot:GetLocation(), 30 )
			and abilityQ:GetAutoCastState() == true
			and abilityW:GetCooldownTimeRemaining() > 5.0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	
	if J.IsRunning( bot ) or #hEnemyList > 0 then return BOT_ACTION_DESIRE_NONE end

	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		if J.IsRoshan( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 99 )
		then
			return BOT_ACTION_DESIRE_LOW
		end
	end

	if J.IsValidBuilding( npcTarget )
		and J.IsInRange( npcTarget, bot, nCastRange + 199 )
	then
		return BOT_ACTION_DESIRE_LOW
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
	then
		local nCreeps = bot:GetNearbyCreeps( 800, true )
		if J.IsValid( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 99 )
			and ( #nCreeps >= 2 or npcTarget:GetHealth() > nAttackDamage * 2.28 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

function X.ConsiderGlacier()
    if not J.CanCastAbility(Glacier)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and (bot:GetActiveModeDesire() > 0.7 or bot:WasRecentlyDamagedByHero(nEnemyHeroes[1], 2) or J.GetHP(bot) < 0.3 or #nEnemyHeroes >= 2)
        and bot:IsFacingLocation(J.GetTeamFountain(), 30)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and not botTarget:IsAttackImmune()
		and (J.CanCastAbility(abilityE)
            or botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 3.5, DAMAGE_TYPE_PHYSICAL))
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X