local X = {}

local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local Tormentor = nil
local TormentorLocation = 0
local vWaitingLocation = 0

local tormentorMessageTime = 0
local canDoTormentor = false

local nCoreCountInLoc = 0
local nSuppCountInLoc = 0
local bHumanInTeam = false

_G.tormentor = {
    kill_time = 0,
    alive     = false,
    healthy   = false,
}

function GetDesire()
	local desire = GetDesireRaw()
	local activeMode = bot:GetActiveMode()
	local activeModeDesire = bot:GetActiveModeDesire()
	if  activeMode ~= BOT_MODE_ASSEMBLE_WITH_HUMANS
    and desire == activeModeDesire
	then
		desire = desire + 0.05
	end
	return desire
end

function GetDesireRaw()
    local nTormentorSpawnInterval = J.IsModeTurbo() and 5 or 10
    local nTormentorSpawnTime = J.IsModeTurbo() and 10 or 20

    if DotaTime() < nTormentorSpawnTime * 60 then return BOT_MODE_DESIRE_NONE end

    TormentorLocation = J.GetTormentorLocation(GetTeam())
    vWaitingLocation = J.GetTormentorWaitingLocation(GetTeam())

    local tAllyInTormentorLocation = J.GetAlliesNearLoc(TormentorLocation, 1200)
    local nAliveAlly = 0

    local nHumanCountInLoc = 0
    local nAttackingTormentorCount = 0

    local nAveCoreLevel = 0
    local nAveSuppLevel = 0

    if bot:HasModifier('modifier_miniboss_alleviation_active') then
        if  _G.tormentor.alive then
            _G.tormentor.alive = false
            _G.tormentor.kill_time = DotaTime()
        end

        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
        if J.GetHP(bot) < 0.75 and #nInRangeEnemy == 0 then
            return BOT_MODE_DESIRE_VERYHIGH
        end
    end

    -- update vars
    local tAliveAllies = {}
    for i = 1, 5 do
        local member = GetTeamMember(i)
        if member ~= nil then
            local memberLevel = member:GetLevel()

            if member:IsAlive() then
                nAliveAlly = nAliveAlly + 1
                table.insert(tAliveAllies, member)

                if not member:IsBot() then
                    if not _G.tormentor.alive and J.IsValidHero(member) then
                        if GetUnitToLocationDistance(member, TormentorLocation) <= 1300
                        and IsLocationVisible(TormentorLocation)
                        then
                            local nNeutralCreeps = member:GetNearbyNeutralCreeps(1300)
                            for j = #nNeutralCreeps, 1, -1 do
                                if J.IsValid(nNeutralCreeps[j]) and string.find(nNeutralCreeps[j]:GetUnitName(), 'miniboss') then
                                    _G.tormentor.alive = true
                                end
                            end
                        end
                    end

                    if GetUnitToLocationDistance(member, TormentorLocation) <= 1600
                    or GetUnitToLocationDistance(member, vWaitingLocation) <= 1600
                    then
                        nHumanCountInLoc = nHumanCountInLoc + 1
                    end
                end

                -- attacking tormentor count
                local memberTarget = J.GetProperTarget(member)
                if J.IsTormentor(memberTarget) then
                    nAttackingTormentorCount = nAttackingTormentorCount + 1
                end

                if J.IsCore(member) then
                    if GetUnitToLocationDistance(member, TormentorLocation) <= 1200
                    or GetUnitToLocationDistance(member, vWaitingLocation) <= 1200
                    then
                        nCoreCountInLoc = nCoreCountInLoc + 1
                    end
                else
                    if GetUnitToLocationDistance(member, TormentorLocation) <= 1200
                    or GetUnitToLocationDistance(member, vWaitingLocation) <= 1200
                    then
                        nSuppCountInLoc = nSuppCountInLoc + 1
                    end
                end
            end

            -- get average levels
            if J.IsCore(member) then
                if memberLevel < 13 then
                    nAveCoreLevel = 0
                else
                    nAveCoreLevel = nAveCoreLevel + member:GetLevel()
                end
            else
                if memberLevel < 11 then
                    nAveSuppLevel = 0
                else
                    nAveSuppLevel = nAveSuppLevel + member:GetLevel()
                end
            end

            if not member:IsBot() and not bHumanInTeam then
                bHumanInTeam = true
            end
        end
    end

    if #tAllyInTormentorLocation <= 1 and nHumanCountInLoc == 0
    and DotaTime() > (J.IsModeTurbo() and (25 * 60) or (40 * 60)) then
        return BOT_MODE_DESIRE_NONE
    end

    local hEnemyAncient = GetAncient(GetOpposingTeam())
    if #tAllyInTormentorLocation <= 1 and nHumanCountInLoc == 0
    and GetUnitToLocationDistance(bot, TormentorLocation) > 1600
    and (GetUnitToUnitDistance(bot, hEnemyAncient) < 4000
        and #J.GetEnemiesAroundAncient(4000) > 0
        or (J.IsDoingRoshan(bot) and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH)
    ) then
        return BOT_MODE_DESIRE_NONE
    end

    if #J.GetEnemiesNearLoc(GetAncient(GetTeam()):GetLocation(), 2000) >= 2
    or ((  not J.IsValidBuilding(GetTower(GetTeam(), TOWER_TOP_3))
        or not J.IsValidBuilding(GetTower(GetTeam(), TOWER_MID_3))
        or not J.IsValidBuilding(GetTower(GetTeam(), TOWER_BOT_3))) and #tAllyInTormentorLocation < 4) -- stop when any these towers fall
    then
        return BOT_MODE_DESIRE_NONE
    end

    nAveCoreLevel = nAveCoreLevel / 3
    nAveSuppLevel = nAveSuppLevel / 2

    if nAveSuppLevel < 11 then
        return BOT_MODE_DESIRE_NONE
    end

    local nInRangeAlly = J.GetAlliesNearLoc(TormentorLocation, 99999)
    local bGoodRightClickDamage = X.IsGoodRighClickDamage(nInRangeAlly, true)

    -- TODO: reduce wasting time waiting for someone as the location is very far now
    -- Someone go check Tormentor
    if DotaTime() >= nTormentorSpawnTime * 60 and (DotaTime() - _G.tormentor.kill_time) >= nTormentorSpawnInterval * 60 then
        if not X.IsTormentorAlive() and not _G.tormentor.alive then
            if  (nAveCoreLevel >= 13 and nAveSuppLevel >= 11)
            and bGoodRightClickDamage
            then
                local ally = nil
                local allyDist = 100000
                for i = 1, 5 do
                    local member = GetTeamMember(i)
                    if  J.IsValidHero(member)
                    and member:IsBot()
                    and GetUnitToUnitDistance(member, hEnemyAncient) > 4000
                    and GetUnitToLocationDistance(member, TormentorLocation) <= 9200
                    then
                        local memberDist = GetUnitToLocationDistance(member, TormentorLocation)
                        if memberDist < allyDist and (not J.IsCore(member) or memberDist < 2800) then
                            ally = member
                            allyDist = memberDist
                        end
                    end
                end

                if ally ~= nil and bot == ally then
                    if not bot:WasRecentlyDamagedByAnyHero(15) then
                        return BOT_MODE_DESIRE_VERYHIGH
                    end
                end
            end
        else
            _G.tormentor.alive = true
        end
    else
        _G.tormentor.alive = false
    end

    if  _G.tormentor.alive
    and bGoodRightClickDamage
    and nAveCoreLevel >= 13
    and nAveSuppLevel >= 11
    and (not bHumanInTeam or (bHumanInTeam and X.DidHumanPingedOrAtLocation()))
    and (  (_G.tormentor.kill_time == 0 and nAliveAlly >= 5)
        or (_G.tormentor.kill_time == 0 and nAliveAlly >= 4 and nCoreCountInLoc >= 3 and nSuppCountInLoc >= 1)
        or (_G.tormentor.kill_time  > 0 and nAliveAlly >= 3 and J.GetAliveAllyCoreCount() >= 2)
        or (nAttackingTormentorCount >= 2 and nCoreCountInLoc >= 2)
    ) then
        if _G.tormentor.alive and not _G.tormentor.healthy and bot == J.GetFirstBotInTeam() then
            if X.IsTeamHealthy() then _G.tormentor.healthy = true end
        end

        if not _G.tormentor.healthy then
            return BOT_MODE_DESIRE_NONE
        end

        local botHP = J.GetHP(bot) + ((bot:GetHealthRegen() * 6.0) / bot:GetMaxHealth())

        if  botHP < 0.2
        and J.CanBeAttacked(bot)
        and J.IsTormentor(Tormentor)
        and not X.HasFormOfSustain(bot)
        then
            return BOT_MODE_DESIRE_NONE
        end

        canDoTormentor = true

        return BOT_MODE_DESIRE_VERYHIGH
    end

    if not _G.tormentor.alive then
        _G.tormentor.healthy = false
    end

    canDoTormentor = false

    return BOT_MODE_DESIRE_NONE
end

local fNextMovementTime = 0
local fStillAlive = 0
local bTormentorAlive = false
function Think()
    if J.CanNotUseAction(bot)
    or bot:HasModifier('modifier_miniboss_alleviation_active')
    then
        return
    end

    if _G.tormentor.alive and GetUnitToLocationDistance(bot, TormentorLocation) > 800 and GetUnitToLocationDistance(bot, TormentorLocation) < 2200 then
        local nEnemyCreeps = bot:GetNearbyCreeps(Min(1600, bot:GetAttackRange() + 300), true)
        if #nEnemyCreeps > 0 and X.CanKillInTime(nEnemyCreeps, 5.2) then
            local creep = J.GetMostHpUnit(nEnemyCreeps)
            if J.IsValid(creep) then
                if bot:GetAnimActivity() == ACTIVITY_ATTACK then
					return
				end

                bot:Action_AttackUnit(creep, false)
                return
            end
        end
    end

    if _G.tormentor.alive and not X.IsEnoughToAttack(vWaitingLocation, 2200) then
        if X.GetClosestBot() == bot and DotaTime() > fStillAlive + 15.0 then
            if GetUnitToLocationDistance(bot, TormentorLocation) <= 350 then
                local nNeutralCreeps = bot:GetNearbyNeutralCreeps(900)
                for i = #nNeutralCreeps, 1, -1 do
                    if J.IsValid(nNeutralCreeps[i]) and string.find(nNeutralCreeps[i]:GetUnitName(), 'miniboss') then
                        fStillAlive = DotaTime()
                        bTormentorAlive = true
                    end
                end
                if not bTormentorAlive then
                    _G.tormentor.kill_time = DotaTime()
                    _G.tormentor.alive = false
                    bTormentorAlive = false
                end
            end

            bot:Action_MoveToLocation(TormentorLocation)
            return
        end

        if DotaTime() >= fNextMovementTime then
            bot:Action_MoveToLocation(vWaitingLocation + RandomVector(300))
            fNextMovementTime = DotaTime() + RandomFloat(1, 3)
            return
        end
    else
        if GetUnitToLocationDistance(bot, TormentorLocation) > bot:GetAttackRange() + 50 then
            bot:Action_MoveToLocation(TormentorLocation)
            return
        else
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(900)
            for _, c in pairs(nNeutralCreeps) do
                if J.IsValid(c) and string.find(c:GetUnitName(), 'miniboss') then
                    Tormentor = c
                    if GetUnitToUnitDistance(bot, c) > bot:GetAttackRange() + 50 then
                        bot:Action_MoveDirectly(TormentorLocation)
                        return
                    else
                        if X.IsEnoughToAttack(TormentorLocation, 1200) then
                            bot:SetTarget(c)
                            bot:Action_AttackUnit(c, true)
                            return
                        end
                    end

                    if J.GetFirstBotInTeam() == bot and canDoTormentor and (DotaTime() > tormentorMessageTime + 15) then
                        tormentorMessageTime = DotaTime()
                        bot:ActionImmediate_Chat("Let's try Tormentor?", false)
                        bot:ActionImmediate_Ping(c:GetLocation().x, c:GetLocation().y, true)
                        return
                    end
                end
            end
        end
    end
end

function X.IsTormentorAlive()
    local nUnitList = GetUnitList(UNIT_LIST_ALL)
    for _, u1 in pairs(nUnitList) do
        if J.IsValid(u1) and GetUnitToLocationDistance(u1, TormentorLocation) <= 350 then
            for _, u2 in pairs(nUnitList) do
                if  J.IsValid(u2)
                and GetUnitToUnitDistance(u1, u2) <= 900
                and string.find(u2:GetUnitName(), 'miniboss')
                then
                    return true
                end
            end

            _G.tormentor.kill_time = DotaTime()
        end
    end

	return false
end

function X.IsEnoughToAttack(vLocation, nRadius)
    local nAllyCount = 0
    local nCoreCountInLoc2 = 0
    local nSuppCountInLoc2 = 0
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if J.IsValidHero(member) then
            if GetUnitToLocationDistance(member, vLocation) <= nRadius then
                nAllyCount = nAllyCount + 1
                if J.IsCore(member) then
                    nCoreCountInLoc2 = nCoreCountInLoc2 + 1
                else
                    nSuppCountInLoc2 = nSuppCountInLoc2 + 1
                end
            end
		end
	end

    local bGoodRightClickDamage = X.IsGoodRighClickDamage({bot}, false)

    if  bGoodRightClickDamage
    and X.GetAllHeroCreepNearbyCount(vLocation, nRadius) >= 5
    and X.HasFormOfSustain(bot)
    then
        return true
    end

    return ((_G.tormentor.kill_time == 0 and nAllyCount >= 5)
        or  (_G.tormentor.kill_time == 0 and nAllyCount >= 4 and nCoreCountInLoc2 >= 3 and nSuppCountInLoc2 >= 1)
        or  (_G.tormentor.kill_time  > 0 and nAllyCount >= 3))
    and nCoreCountInLoc2 >= 2
end

function X.GetClosestBot()
    local hUnitList = J.GetAlliesNearLoc(vWaitingLocation, 2800)
    local hTarget = nil
    local hTargetDistance = math.huge
    for _, unit in pairs(hUnitList) do
        if J.IsValidHero(unit) and GetUnitToLocationDistance(unit, TormentorLocation) < 2000 then
            local unitDistance = GetUnitToLocationDistance(unit, TormentorLocation)
            if hTargetDistance > unitDistance * (1 - J.GetHP(unit)) then
                hTargetDistance = unitDistance
                hTarget = unit
            end
        end
    end

    if hTarget ~= nil then
        return hTarget
    end
    return nil
end

function X.IsTeamHealthy()
	local nHealthyAlly = 0
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if J.IsValid(member) then
            local memberHP = J.GetHP(member) + ((member:GetHealthRegen() * 6.0) / member:GetMaxHealth())
            if memberHP >= 0.4 or not member:IsBot() then
                nHealthyAlly = nHealthyAlly + 1
            end
		end
	end

	return nHealthyAlly >= J.GetNumOfAliveHeroes(false)
end

-- just some threshold
local tTeamDamage = {}
local fThresholdChatTime = 0
function X.IsGoodRighClickDamage(nUnitList, bIgnoreAfter)
    if bIgnoreAfter and _G.tormentor.kill_time > 0 then return true end

    for _, allyHero in pairs(nUnitList) do
        if J.IsValidHero(allyHero) then
            local allyHeroPosition = J.GetPosition(allyHero)
            local allyHeroAttackDamage = allyHero:GetAttackDamage() / allyHero:GetSecondsPerAttack()
            if allyHeroPosition == 1 then
                allyHeroAttackDamage = allyHeroAttackDamage * 0.40
            elseif allyHeroPosition == 2 then
                allyHeroAttackDamage = allyHeroAttackDamage * 0.25
            elseif allyHeroPosition == 3 then
                allyHeroAttackDamage = allyHeroAttackDamage * 0.25
            elseif allyHeroPosition == 4 then
                allyHeroAttackDamage = allyHeroAttackDamage * 0.05
            elseif allyHeroPosition == 5 then
                allyHeroAttackDamage = allyHeroAttackDamage * 0.05
            end

            local id = allyHero:GetPlayerID()
			if tTeamDamage[id] == nil then tTeamDamage[id] = 0 end
            if tTeamDamage[id] < allyHeroAttackDamage then
                tTeamDamage[id] = allyHeroAttackDamage
            end
        end
    end

    local totalAttackDamage = 0
    for _, damage in pairs(tTeamDamage) do totalAttackDamage = totalAttackDamage + damage end

    if not J.IsDoingTormentor(bot) and J.GetFirstBotInTeam() == bot and _G.tormentor.alive and DotaTime() - fThresholdChatTime < 30 and totalAttackDamage >= 160 then
        bot:ActionImmediate_Chat("Tormentor threshold met..", false)
        fThresholdChatTime = DotaTime()
    end

    return totalAttackDamage >= 160 -- ~
end

local bHumanPinged = false
function X.DidHumanPingedOrAtLocation()
    local human, ping = J.GetHumanPing()
    if _G.tormentor.alive and human and ping and not bHumanPinged then
        if J.GetDistance(ping.location, vWaitingLocation) <= 800
        or J.GetDistance(ping.location, TormentorLocation) <= 800
        then
            if GameTime() < ping.time + 15 then
                bHumanPinged = true
            end
        end
    end

    if not _G.tormentor.alive then
        bHumanPinged = false
    elseif _G.tormentor.alive and bHumanPinged then
        return true
    end

    return false
end

function X.CanKillInTime(nUnitList, fTime)
    for _, unit in pairs(nUnitList) do
        if  J.IsValid(unit)
        and J.CanBeAttacked(unit)
        and not J.IsRoshan(unit)
		and not J.IsTormentor(unit)
        then
            if bot:GetEstimatedDamageToTarget(true, unit, fTime, DAMAGE_TYPE_PHYSICAL) < unit:GetHealth() then
                return false
            end
        end
    end
    return true
end

function X.GetAllHeroCreepNearbyCount(vLocation, nRadius)
    local nLocationAoE_allyHeroes = bot:FindAoELocation(false, true, vLocation, 0, nRadius, 0, 0)
    local nLocationAoE_allyCreeps = bot:FindAoELocation(false, false, vLocation, 0, nRadius, 0, 0)
    local nLocationAoE_enemyHeroes = bot:FindAoELocation(true, true, vLocation, 0, nRadius, 0, 0)
    local nLocationAoE_enemyCreeps = bot:FindAoELocation(true, false, vLocation, 0, nRadius, 0, 0)
    return nLocationAoE_allyHeroes.count + nLocationAoE_allyCreeps.count + nLocationAoE_enemyHeroes.count + nLocationAoE_enemyCreeps.count
end

function X.HasFormOfSustain(hUnit)
    return hUnit:HasModifier('modifier_item_crimson_guard_extra')
        or hUnit:HasModifier('modifier_item_satanic_unholy')
        or hUnit:HasModifier('modifier_ursa_enrage')
        or hUnit:HasModifier('modifier_pudge_flesh_heap_block')
        or hUnit:GetHealthRegen() >= bot:GetAttackDamage()
end
