local X = {}

local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local Tormentor = nil
local TormentorLocation = 0
local vWaitingLocation = 0

local tormentorMessageTime = 0
local canDoTormentor = false

if bot.tormentor_state == nil then bot.tormentor_state = false end
if bot.tormentor_kill_time == nil then bot.tormentor_kill_time = 0 end

local nCoreCountInLoc = 0
local nSuppCountInLoc = 0

function GetDesire()
    TormentorLocation = J.GetTormentorLocation(GetTeam())
    vWaitingLocation = J.GetTormentorWaitingLocation(GetTeam())

    local tAllyInTormentorLocation = J.GetAlliesNearLoc(TormentorLocation, 900)
    local tAllyInTormentorWaitLocation = J.GetAlliesNearLoc(vWaitingLocation, 900)
    local tInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
    local nAliveAlly = J.GetNumOfAliveHeroes(false)

    local nTormentorSpawnInterval = J.IsModeTurbo() and 5 or 10
    local nTormentorSpawnTime = J.IsModeTurbo() and 7.5 or 15

    local nHumanCountInLoc = 0
    local nAttackingTormentorCount = 0

    local nAveCoreLevel = 0
    local nAveSuppLevel = 0

    -- update vars
    local tAliveAllies = {}
    for i = 1, 5 do
        local member = GetTeamMember(i)
        if member ~= nil then
            if member:IsAlive() then
                table.insert(tAliveAllies, member)

                if not member:IsBot() then
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
            end

            -- get average levels
            if J.IsCore(member) then
                if GetUnitToLocationDistance(member, TormentorLocation) <= 900
                or GetUnitToLocationDistance(member, vWaitingLocation) <= 900
                then
                    nCoreCountInLoc = nCoreCountInLoc + 1
                end

                nAveCoreLevel = nAveCoreLevel + member:GetLevel()
            else
                if GetUnitToLocationDistance(member, TormentorLocation) <= 900
                or GetUnitToLocationDistance(member, vWaitingLocation) <= 900
                then
                    nSuppCountInLoc = nSuppCountInLoc + 1
                end

                nAveSuppLevel = nAveSuppLevel + member:GetLevel()
            end

            -- update tormentor state
            if member.tormentor_state == true then
                bot.tormentor_state = true
            end

            --update kill time
            if member.tormentor_kill_time ~= nil
            and member.tormentor_kill_time > 0
            and member.tormentor_kill_time > bot.tormentor_kill_time
            then
                bot.tormentor_kill_time = member.tormentor_kill_time
            end
        end
    end

    if #tAllyInTormentorLocation <= 1 and nHumanCountInLoc == 0
    and DotaTime() > (J.IsModeTurbo() and (20 * 60) or (40 * 60)) then
        return BOT_MODE_DESIRE_NONE
    end

    local hEnemyAncient = GetAncient(GetOpposingTeam())
    if #tAllyInTormentorLocation <= 1 and nHumanCountInLoc == 0
    and GetUnitToLocationDistance(bot, TormentorLocation) > 1600
    and (GetUnitToUnitDistance(bot, hEnemyAncient) < 4000
        and #J.GetEnemiesAroundAncient(4000) > 0
        or J.IsDoingRoshan(bot)
        or #tInRangeEnemy > 0
    ) then
        return BOT_MODE_DESIRE_NONE
    end

    local tEnemyInTormentorLocation = J.GetEnemiesNearLoc(TormentorLocation, 1600)
    if #tEnemyInTormentorLocation > #tAllyInTormentorLocation then
        return BOT_MODE_DESIRE_NONE
    end

    nAveCoreLevel = nAveCoreLevel / 3
    nAveSuppLevel = nAveSuppLevel / 2

    -- TODO: reduce wasting time waiting for someone as the location is very far now
    -- Someone go check Tormentor
    if DotaTime() >= nTormentorSpawnTime * 60 and (DotaTime() - bot.tormentor_kill_time) >= nTormentorSpawnInterval * 60 then
        if not X.IsTormentorAlive() then
            if not J.IsCore(bot) and GetUnitToUnitDistance(bot, hEnemyAncient) > 4000 then
                local ally = nil
                local allyDist = 100000
                for i = 1, 5 do
                    local member = GetTeamMember(i)
                    if member ~= nil and member:IsAlive() and member:IsBot() and not J.IsCore(member) then
                        local memberDist = GetUnitToLocationDistance(member, TormentorLocation)
                        if memberDist < allyDist then
                            ally = member
                            allyDist = memberDist
                        end
                    end
                end

                if ally ~= nil and bot == ally and bot.tormentor_state == false then
                    return 0.8
                end
            end
        else
            bot.tormentor_state = true
        end
    else
        bot.tormentor_state = false
    end

    if bot.tormentor_state == true
    and nAveCoreLevel >= 13
    and nAveSuppLevel >= 11
    and (  (bot.tormentor_kill_time == 0 and nAliveAlly >= 5)
        or (bot.tormentor_kill_time == 0 and nAliveAlly >= 4 and nCoreCountInLoc >= 3 and nSuppCountInLoc >= 1)
        or (bot.tormentor_kill_time > 0 and nAliveAlly >= 3 and J.GetAliveAllyCoreCount() >= 2)
        or (nAttackingTormentorCount >= 2)
    ) then
        canDoTormentor = true

        if J.GetHP(bot) < 0.3
        and J.IsTormentor(Tormentor)
        and J.GetHP(Tormentor) > 0.3 then
            return BOT_MODE_DESIRE_NONE
        end

        if X.IsEnoughAllies(TormentorLocation, 900) or X.IsEnoughAllies(vWaitingLocation, 1600) then
            return BOT_MODE_DESIRE_ABSOLUTE
        end

        if (#tAllyInTormentorLocation >= 2 or #tAllyInTormentorWaitLocation >= 2)
        or nCoreCountInLoc >= 1
        or nSuppCountInLoc >= 2
        or nHumanCountInLoc >= 1 then
            return 0.95
        else
            return 0.8
        end
    end

    canDoTormentor = false
    return BOT_MODE_DESIRE_NONE
end

local fStillAlive = 0
local bTormentorAlive = false
function Think()
    if bot.tormentor_state == true and not X.IsEnoughAllies(vWaitingLocation, 1600) then
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
                    bot.tormentor_kill_time = DotaTime()
                    bot.tormentor_state = false
                    bTormentorAlive = false
                end
            end

            bot:Action_MoveToLocation(TormentorLocation)
            return
        end

        bot:Action_MoveToLocation(vWaitingLocation)
        return
    else
        if GetUnitToLocationDistance(bot, TormentorLocation) > bot:GetAttackRange() + 50 then
            bot:Action_MoveToLocation(TormentorLocation)
            return
        else
            local tCreeps = bot:GetNearbyNeutralCreeps(900)
            for _, c in pairs(tCreeps) do
                if J.IsValid(c) and string.find(c:GetUnitName(), 'miniboss') then
                    Tormentor = c
                    if GetUnitToUnitDistance(bot, c) > bot:GetAttackRange() + 50 then
                        bot:Action_MoveDirectly(TormentorLocation)
                        return
                    else
                        if X.IsEnoughAllies(TormentorLocation, 900) or J.GetHP(c) < 0.25 then
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
    if IsLocationVisible(TormentorLocation) then
        for i = 1, 5 do
            local member = GetTeamMember(i)
            if member ~= nil and member:IsAlive() then
                if GetUnitToLocationDistance(member, TormentorLocation) <= 350 then
                    local nNeutralCreeps = member:GetNearbyNeutralCreeps(900)
                    for j = #nNeutralCreeps, 1, -1 do
                        if J.IsValid(nNeutralCreeps[j]) and string.find(nNeutralCreeps[j]:GetUnitName(), 'miniboss') then
                            return true
                        end
                    end

                    member.tormentor_kill_time = DotaTime()
                end
            end
        end
	end

	return false
end

function X.IsEnoughAllies(vLocation, nRadius)
    local nAllyCount = 0
    local nCoreCountInLoc2 = 0
    local nSuppCountInLoc2 = 0
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if member ~= nil and member:IsAlive() then
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

	return ((bot.tormentor_kill_time == 0 and nAllyCount >= 5)
         or (bot.tormentor_kill_time == 0 and nAllyCount >= 4 and nCoreCountInLoc2 >= 3 and nSuppCountInLoc2 >= 1)
         or (bot.tormentor_kill_time > 0 and nAllyCount >= 3))
    and nCoreCountInLoc2 >= 2
end

function X.GetClosestBot()
    local hUnitList = J.GetAlliesNearLoc(vWaitingLocation, 2800)
    local hTarget = nil
    local hTargetDistance = math.huge
    for _, unit in pairs(hUnitList) do
        if J.IsValidHero(unit) and GetUnitToLocationDistance(unit, TormentorLocation) < 2000 then
            local unitDistance = GetUnitToLocationDistance(unit, TormentorLocation)
            if hTargetDistance > unitDistance then
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
