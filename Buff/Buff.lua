dofile('bots/Buff/Timers')
dofile('bots/Buff/Experience')
dofile('bots/Buff/GPM')
dofile('bots/Buff/NeutralItems')
dofile('bots/Buff/Helper')
dofile('bots/Buff/Towers')

if Buff == nil
then
    Buff = {}
end

if BuffEnabled == nil then BuffEnabled = false end

local botTable = {
    [DOTA_TEAM_GOODGUYS]    = {},
    [DOTA_TEAM_BADGUYS]     = {}
}

function Buff:AddBotsToTable()
    local playerCount = PlayerResource:GetPlayerCount()

    for playerID = 0, playerCount - 1 do
        local player = PlayerResource:GetPlayer(playerID)
        local hero = player:GetAssignedHero()
        local team = player:GetTeam()

        if hero then
            -- just do how we're counting bots from below
            if PlayerResource:GetSteamID(playerID) == PlayerResource:GetSteamID(playerCount + 1) then
                -- check if these heroes do not have the specified spell
                if string.find(hero:GetUnitName(), 'life_stealer') then
                    if not hero:HasAbility('life_stealer_rage') then
                        AddAbilityToHero(hero, 'life_stealer_rage')
                    end
                elseif string.find(hero:GetUnitName(), 'faceless_void') then
                    if not hero:HasAbility('faceless_void_chronosphere') then
                        AddAbilityToHero(hero, 'faceless_void_chronosphere')
                    end
                end

                table.insert(botTable[team], hero)
            end
        end
    end
end

-- fix Lifestealer and Faceless Void missing ultimates due to facet
-- if anyone is using this vscript with another bot script, you might need to change some stuff to work with it (ie. level up list)
function AddAbilityToHero(hero, hAbilityName)
    local missingSpell = nil
    local abilityCount = hero:GetAbilityCount()
    hero:AddAbility(hAbilityName)

    for i = abilityCount - 1, 0, -1
    do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            if ability:GetAbilityName() == hAbilityName
            then
                missingSpell = ability
            end

            if ability:GetAbilityName() == 'generic_hidden' and missingSpell then
                hero:SwapAbilities(missingSpell:GetAbilityName(), ability:GetAbilityName(), true, false)
                break
            end
        end
    end

    -- swap lifestealer's spells to their correct slots for sAbilityLevelUpList
    if hero:GetUnitName() == 'npc_dota_hero_life_stealer' then
        local ability_1 = 'life_stealer_rage'
        local ability_2 = 'life_stealer_open_wounds'
        local ability_3 = 'life_stealer_ghoul_frenzy'

        if hero:HasAbility(ability_1) and hero:HasAbility(ability_2) and hero:HasAbility(ability_3) then
            hero:SwapAbilities(ability_2, ability_3, true, true)
            hero:SwapAbilities(ability_1, ability_3, true, true)
        end
    end
end

local BotCount = 0
local SelectedHeroCount = 0
local function CheckBotCount()
    BotCount = 0
    SelectedHeroCount = 0
    local playerCount = PlayerResource:GetPlayerCount()

    for playerID = 0, playerCount - 1 do
        if PlayerResource:GetSteamID(playerID) == PlayerResource:GetSteamID(playerCount + 1) then
            if PlayerResource:GetSelectedHeroName(playerID) ~= '' then
                SelectedHeroCount = SelectedHeroCount + 1
            end

            BotCount = BotCount + 1
        end
    end
end

local bTowerBuff = true -- enable tower buff

function Buff:Init()
    if not BuffEnabled then
        GameRules:SendCustomMessage('Buff mode enabled!', 0, 0)
        BuffEnabled = true
    end

    Timers:CreateTimer(function()
        -- CheckBotCount()
        -- if BotCount ~= SelectedHeroCount then return 1 end

        -- just refresh instead of above
        botTable[DOTA_TEAM_GOODGUYS] = {}
        botTable[DOTA_TEAM_BADGUYS] = {}
        Buff:AddBotsToTable()
        local TeamRadiant = botTable[DOTA_TEAM_GOODGUYS]
        local TeamDire = botTable[DOTA_TEAM_BADGUYS]
        local hHeroList = {}

        if GameRules:GetDOTATime(false, false) > 0 then
            if bTowerBuff then
                T.HandleTowerBuff(DOTA_TEAM_GOODGUYS)
                T.HandleTowerBuff(DOTA_TEAM_BADGUYS)
            end

            for _, h in pairs(TeamRadiant) do
                table.insert(hHeroList, h)
            end
            for _, h in pairs(TeamDire) do
                table.insert(hHeroList, h)
            end

            NeutralItems.GiveNeutralItems(hHeroList)

            if not Helper.IsTurboMode()
            then
                for _, h in pairs(TeamRadiant) do
                    GPM.UpdateBotGold(h, TeamRadiant)
                    XP.UpdateXP(h, TeamRadiant)
                end

                for _, h in pairs(TeamDire) do
                    GPM.UpdateBotGold(h, TeamDire)
                    XP.UpdateXP(h, TeamDire)
                end
            end
        end

        return 1
    end)
end

Buff:Init()