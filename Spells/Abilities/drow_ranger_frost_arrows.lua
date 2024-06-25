local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FrostArrows

function X.Cast()
    bot = GetBot()
    FrostArrows = bot:GetAbilityByName('drow_ranger_frost_arrows')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FrostArrows)
        return
    end
end

local lastAutoTime = 0
function X.Consider()
    if not FrostArrows:IsFullyCastable()
    or bot:IsDisarmed()
    or J.GetDistanceFromEnemyFountain( bot ) < 800
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nAttackRange = bot:GetAttackRange() + 40
    local nAttackDamage = bot:GetAttackDamage() + FrostArrows:GetSpecialValueInt( "damage" )
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
        and not FrostArrows:GetAutoCastState()
        then
            lastAutoTime = DotaTime()
            FrostArrows:ToggleAutoCast()
        elseif ( hEnemyList[1] == nil and J.GetMP(bot) < 0.7 )
            and lastAutoTime + 3.0 < DotaTime()
            and FrostArrows:GetAutoCastState()
            then
                FrostArrows:ToggleAutoCast()
        end
    else
        if FrostArrows:GetAutoCastState()
        then
            FrostArrows:ToggleAutoCast()
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
    and not FrostArrows:GetAutoCastState()
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

return X