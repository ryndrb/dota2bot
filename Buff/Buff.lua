dofile('bots/Buff/Timers')
dofile('bots/Buff/Experience')
dofile('bots/Buff/GPM')
dofile('bots/Buff/NeutralItems')
dofile('bots/Buff/Helper')
dofile('bots/Buff/Towers')
dofile('bots/Buff/Facets')
dofile('bots/Buff/Spells')

local SpellMode = require('bots/Buff/SpellsMore')

if Buff == nil
then
    Buff = {}
end

if BuffEnabled == nil then BuffEnabled = false end

local HeroTable = {
    bot = { [DOTA_TEAM_GOODGUYS] = {}, [DOTA_TEAM_BADGUYS] = {} },
    all = { [DOTA_TEAM_GOODGUYS] = {}, [DOTA_TEAM_BADGUYS] = {} },
}

function Buff:AddPlayersToTable()
    for _, team in pairs({DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS}) do
        local playerCount = PlayerResource:GetPlayerCountForTeam(team)
        for j = 1, playerCount do
            local playerID = PlayerResource:GetNthPlayerIDOnTeam(team, j)
            local player = PlayerResource:GetPlayer(playerID)
            if player then
                local hero = player:GetAssignedHero()
                if hero then
                    if PlayerResource:GetSteamID(playerID) == PlayerResource:GetSteamID(playerCount + 1) then
                        table.insert(HeroTable.bot[team], hero)
                    end
                    table.insert(HeroTable.all[team], hero)
                end
            end
        end
    end
end

local function MergeTables(...)
    local result = {}
    for _, tbl in ipairs({...}) do
        for _, v in pairs(tbl) do
            table.insert(result, v)
        end
    end

    return result
end

local function GetHeroes(nHeroTable)
    return MergeTables( nHeroTable[DOTA_TEAM_GOODGUYS], nHeroTable[DOTA_TEAM_BADGUYS] )
end

local function CheckHeroTables()
    HeroTable.bot[DOTA_TEAM_GOODGUYS] = {}
    HeroTable.bot[DOTA_TEAM_BADGUYS]  = {}
    HeroTable.all[DOTA_TEAM_GOODGUYS] = {}
    HeroTable.all[DOTA_TEAM_BADGUYS]  = {}
    Buff:AddPlayersToTable()
end

-- script flags
local bBuffFlags = {
    -- Needed
    spellUsage      = true,
    bountyPickUpFix = true,

    -- General
    facets = {
        change  = false,  -- Set to 'false' to disable changing (a) facet/s (See /Facets.lua for the heroes).
    },
    towers = {
        radiant = true, -- Set to 'false' to disable Radiant towers buff.
        dire    = true, -- Set to 'false' to disable Dire towers buff.
    },
    neutrals = {
        radiant = true, -- Set to 'false' to disable Radiant bots receiving neutral items.
        dire    = true, -- Set to 'false' to disable Dire bots receiving neutral items.
    },
    mana_regen = {
        radiant = true, -- Set to 'false' to disable aiding Radiant bots' receiving added mana regen.
        dire    = true, -- Set to 'false' to disable aiding Dire bots' receiving added mana regen.
    },
    gpm = {
        radiant = true, -- Set to 'false' to disable Radiant bots receiving a Gold boost.
        dire    = true, -- Set to 'false' to disable Dire bots receiving a Gold boost.
    },
    morespells = {
        enable  = false, -- Set to 'false' to disable all playes getting more spells.
                        -- Proper LoD would be too tedious; pseudo.
                        -- Can be laggy.
        humans  = true, -- Set to 'false' to disable humans getting more spells.
                        -- Don't manually upgrade the added spells.
                        -- Don't hover over the added spell if not cached yet (see Console).
    },
    -- Applies to All Pick only
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
        CheckHeroTables()

        local nBotHeroes = GetHeroes(HeroTable.bot)
        local nAllHeroes = GetHeroes(HeroTable.all)

        for _, hero in pairs(nAllHeroes) do
            -- Facet Change
            if bBuffFlags.facets.change and GameRules:GetDOTATime(false, true) < 0 then
                if not hero.facet_flag then
                    F.ChangeHeroFacet(hero)
                end
            end
        end

        for _, hero in pairs(nBotHeroes) do
            if hero and hero:IsAlive() then
                -- Spell Usage
                if bBuffFlags.spellUsage then
                    if S.AbilityUsageHeroList[hero:GetUnitName()] then
                        S.AbilityUsageThink(hero)
                    end
                end

                if bBuffFlags.bountyPickUpFix then
                    S.TryPickUpNearbyBounty(hero)
                end
            end
        end

        -- More Spells
        if bBuffFlags.morespells.enable and GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
            local hHeroList = (bBuffFlags.morespells.humans and nAllHeroes) or nBotHeroes
            for _, hero in pairs(hHeroList) do
                if hero then
                    SpellMode.InitMoreSpells(hero, HeroTable.all)
                end
            end
        end

        if GameRules:GetDOTATime(false, false) > 0 then
            -- Mana
            for _, hero in pairs(nBotHeroes) do
                if  hero then
                    if (bBuffFlags.mana_regen.radiant and hero:GetTeam() == DOTA_TEAM_GOODGUYS)
                    or (bBuffFlags.mana_regen.dire and hero:GetTeam() == DOTA_TEAM_BADGUYS)
                    then
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
                end
            end

            -- Towers
            T.HandleTowerBuff(DOTA_TEAM_GOODGUYS, bBuffFlags.towers.radiant)
            T.HandleTowerBuff(DOTA_TEAM_BADGUYS, bBuffFlags.towers.dire)

            -- Neutral Items
            local hHeroList = {}
            if bBuffFlags.neutrals.radiant then
                for _, h in pairs(HeroTable.bot[DOTA_TEAM_GOODGUYS]) do
                    table.insert(hHeroList, h)
                end
            end
            if bBuffFlags.neutrals.dire then
                for _, h in pairs(HeroTable.bot[DOTA_TEAM_BADGUYS]) do
                    table.insert(hHeroList, h)
                end
            end

            NeutralItems.GiveNeutralItems(hHeroList)

            -- Gold
            for _, hero in pairs(nBotHeroes) do
                if hero then
                    local nTeam = hero:GetTeam()
                    if (bBuffFlags.gpm.radiant and nTeam == DOTA_TEAM_GOODGUYS)
                    or (bBuffFlags.gpm.dire and nTeam == DOTA_TEAM_BADGUYS)
                    then
                        GPM.UpdateBotGold(hero, HeroTable.all[hero:GetTeam()])
                    end
                end
            end

            -- Experience
            if not Helper.IsTurboMode() then
                for _, hero in pairs(nBotHeroes) do
                    if hero then
                        local nTeam = hero:GetTeam()
                        if (bBuffFlags.xpm.radiant and nTeam == DOTA_TEAM_GOODGUYS)
                        or (bBuffFlags.xpm.dire and nTeam == DOTA_TEAM_BADGUYS)
                        then
                            XP.UpdateXP(hero, HeroTable.all[hero:GetTeam()])
                        end
                    end
                end
            end
        end

        return 1
    end)
end

Buff:Init()