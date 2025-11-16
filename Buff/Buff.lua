dofile('bots/Buff/Timers')
dofile('bots/Buff/Experience')
dofile('bots/Buff/GPM')
dofile('bots/Buff/NeutralItems')
dofile('bots/Buff/Helper')
dofile('bots/Buff/Towers')
dofile('bots/Buff/Facets')
dofile('bots/Buff/Spells')

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
    -- with 7.38, player IDs are not 9<= anymore; when no human on either side
    -- 2 rad, 3 dire
    for _, team in pairs({DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS}) do
        local playerCount = PlayerResource:GetPlayerCountForTeam(team)
        for j = 1, playerCount do
            local playerID = PlayerResource:GetNthPlayerIDOnTeam(team, j)
            local player = PlayerResource:GetPlayer(playerID)
            if player then
                local hero = player:GetAssignedHero()
                -- just do how we're counting bots from below
                if hero and PlayerResource:GetSteamID(playerID) == PlayerResource:GetSteamID(playerCount + 1) then
                    -- -- check if these heroes do not have the specified spell
                    -- -- valve fixed this a while ago
                    -- if string.find(hero:GetUnitName(), 'life_stealer') then
                    --     if not hero:HasAbility('life_stealer_rage') then
                    --         AddAbilityToHero(hero, 'life_stealer_rage')
                    --     end
                    -- elseif string.find(hero:GetUnitName(), 'faceless_void') then
                    --     if not hero:HasAbility('faceless_void_chronosphere') then
                    --         AddAbilityToHero(hero, 'faceless_void_chronosphere')
                    --     end
                    -- end

                    table.insert(botTable[team], hero)
                end
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

-- script flags
local bBuffFlags = {
    -- General
    facets = {
        change  = true,  -- Set to 'false' to disable changing (a) facet/s (See /Facets.lua for the heroes).
    },
    towers = {
        radiant = true, -- Set to 'false' to disable Radiant towers buff.
        dire    = true, -- Set to 'false' to disable Dire towers buff.
    },
    neutrals = {
        radiant = false, -- Set to 'false' to disable Radiant bots receiving neutral items.
        dire    = false, -- Set to 'false' to disable Dire bots receiving neutral items.
    },
    manga_regen = {
        radiant = true, -- Set to 'false' to disable aiding Radiant bots' receiving added mana regen.
        dire    = true, -- Set to 'false' to disable aiding Dire bots' receiving added mana regen.
    },
    -- Applies to All Pick only
    gpm = {
        radiant = true, -- Set to 'false' to disable Radiant bots receiving a Gold boost.
        dire    = true, -- Set to 'false' to disable Dire bots receiving a Gold boost.
    },
    xpm = {
        radiant = true, -- Set to 'false' to disable Radiant bots receiving an Experience boost.
        dire    = true, -- Set to 'false' to disable Dire bots receiving an Experience boost.
    },
}

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

        if bBuffFlags.facets.change and GameRules:GetDOTATime(false, true) < 0 then
            for _, h in pairs(TeamRadiant) do table.insert(hHeroList, h) end
            for _, h in pairs(TeamDire) do table.insert(hHeroList, h) end

            for _, hero in pairs(hHeroList) do
                if hero.facet_flag == nil then hero.facet_flag = false end
                if hero.facet_flag == false then
                    F.ChangeHeroFacet(hero)
                end
            end
        end

        -- Spell Usage
        for _, h in pairs(TeamRadiant) do table.insert(hHeroList, h) end
        for _, h in pairs(TeamDire) do table.insert(hHeroList, h) end
        for _, hero in pairs(hHeroList) do
            if hero and S.AbilityUsageHeroList[hero:GetUnitName()] then
                S.AbilityUsageThink(hero)
            end
        end

        if GameRules:GetDOTATime(false, false) > 0 then
            -- Mana
            hHeroList = {}
            if bBuffFlags.manga_regen.radiant then
                for _, h in pairs(TeamRadiant) do
                    table.insert(hHeroList, h)
                end
            end
            if bBuffFlags.manga_regen.dire then
                for _, h in pairs(TeamDire) do
                    table.insert(hHeroList, h)
                end
            end

            for _, hero in pairs(hHeroList) do
                local nManaCost = 0
                for i = 0, hero:GetAbilityCount() - 1 do
                    local hAbility = hero:GetAbilityByIndex(i)
                    if hAbility then nManaCost = nManaCost + hAbility:GetManaCost(-1) end
                end

                local idx = {0, 1, 2, 3, 4, 5, 15, 16}
                for _, i in ipairs(idx) do
                    local hItem = hero:GetItemInSlot(i)
                    if hItem then nManaCost = nManaCost + hItem:GetManaCost(-1) end
                end

                hero:SetBaseManaRegen(((math.max(nManaCost - hero:GetMana(), 0)) / 30))
            end

            -- Towers
            if bBuffFlags.towers.radiant then
                T.HandleTowerBuff(DOTA_TEAM_GOODGUYS)
            end
            if bBuffFlags.towers.dire then
                T.HandleTowerBuff(DOTA_TEAM_BADGUYS)
            end

            hHeroList = {}
            -- Neutral Items
            if bBuffFlags.neutrals.radiant then
                for _, h in pairs(TeamRadiant) do
                    table.insert(hHeroList, h)
                end
            end
            if bBuffFlags.neutrals.dire then
                for _, h in pairs(TeamDire) do
                    table.insert(hHeroList, h)
                end
            end

            NeutralItems.GiveNeutralItems(hHeroList)

            -- Gold and Experience
            if not Helper.IsTurboMode() then
                for _, h in pairs(TeamRadiant) do
                    if bBuffFlags.gpm.radiant then
                        GPM.UpdateBotGold(h, TeamRadiant)
                    end
                    if bBuffFlags.xpm.radiant then
                        XP.UpdateXP(h, TeamRadiant)
                    end
                end

                for _, h in pairs(TeamDire) do
                    if bBuffFlags.gpm.dire then
                        GPM.UpdateBotGold(h, TeamDire)
                    end
                    if bBuffFlags.xpm.dire then
                        XP.UpdateXP(h, TeamDire)
                    end
                end
            end
        end

        return 1
    end)
end

Buff:Init()