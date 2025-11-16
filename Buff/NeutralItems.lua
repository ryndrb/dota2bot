local neutrals_data = require('bots/Buff/script/neutrals_data')

if NeutralItems == nil
then
    NeutralItems = {}
end

local isTierOneDone   = false
local isTierTwoDone   = false
local isTierThreeDone = false
local isTierFourDone  = false
local isTierFiveDone  = false

-- Neutrals

local Tier1NeutralItems = {
    -- --[[Trusty Shovel]]         "item_trusty_shovel",
    -- --[[Arcane Ring]]           "item_arcane_ring",
    -- --[[Fairy's Trinket]]       "item_mysterious_hat",
    -- --[[Pig Pole]]              "item_unstable_wand",
    -- --[[Safety Bubble]]         "item_safety_bubble",
    -- --[[Seeds of Serenity]]     "item_seeds_of_serenity",
    -- --[[Lance of Pursuit]]      "item_lance_of_pursuit",
    --[[Occult Bracelet]]       "item_occult_bracelet",
    -- --[[Duelist Gloves]]        "item_duelist_gloves",
    -- --[[Broom Handle]]          "item_broom_handle",
    -- --[[Royal Jelly]]           "item_royal_jelly",
    -- --[[Faded Broach]]          "item_faded_broach",
    --[[Spark Of Courage]]      "item_spark_of_courage",
    -- --[[Ironwood Tree]]         "item_ironwood_tree",
    -- --[[Mana Draught]]          "item_mana_draught",
    --[[Polliwog Charm]]        "item_polliwog_charm",
    --[[Ripper's Lash]]         "item_rippers_lash",
    -- -- [[Orb of Destruction]]    "item_orb_of_destruction",
    --[[Chipped Vest]]          "item_chipped_vest",
    --[[Dormant Curio]]         "item_dormant_curio",
    --[[Kobold Cup]]            "item_kobold_cup",
    --[[Sister's Shroud]]       "item_sisters_shroud",
}

local Tier2NeutralItems = {
    -- --[[Dragon Scale]]          "item_dragon_scale",
    -- --[[Whisper of the Dread]]  "item_whisper_of_the_dread",
    -- --[[Pupil's Gift]]          "item_pupils_gift",
    -- --[[Grove Bow]]             "item_grove_bow",
    -- --[[Philosopher's Stone]]   "item_philosophers_stone",
    -- --[[Bullwhip]]              "item_bullwhip",
    -- --[[Orb of Destruction]]    "item_orb_of_destruction",
    -- --[[Specialist's Array]]    "item_specialists_array",
    -- --[[Eye of the Vizier]]     "item_eye_of_the_vizier",
    -- --[[Vampire Fangs]]         "item_vampire_fangs",
    -- --[[Gossamer's Cape]]       "item_gossamer_cape",
    -- --[[Light Collector]]       "item_light_collector",
    -- --[[Iron Talon]]            "item_iron_talon",
    --[[Essence Ring]]          "item_essence_ring",
    --[[Searing Signet]]        "item_searing_signet",
    --[[Brigand's Balde]]       "item_misericorde",
    --[[Tumbler's Toy]]         "item_pogo_stick",
    --[[Mana Draught]]          "item_mana_draught",
    --[[Poor Man's Shield]]     "item_poor_mans_shield",
}

local Tier3NeutralItems = {
    -- --[[Defiant Shell]]         "item_defiant_shell",
    -- --[[Paladin Sword]]         "item_paladin_sword",
    -- --[[Nemesis Curse]]         "item_nemesis_curse",
    -- --[[Vindicator's Axe]]      "item_vindicators_axe",
    -- --[[Dandelion Amulet]]      "item_dandelion_amulet",
    -- --[[Craggy Coat]]           "item_craggy_coat",
    -- --[[Enchanted Quiver]]      "item_enchanted_quiver",
    -- --[[Elven Tunic]]           "item_elven_tunic",
    -- --[[Cloack of Flames]]      "item_cloak_of_flames",
    -- --[[Ceremonial Robe]]       "item_ceremonial_robe",
    --[[Psychic Headband]]      "item_psychic_headband",
    -- --[[Doubloon]]              "item_doubloon",
    -- --[[Vambrace]]              "item_vambrace",
    --[[Whisper of the Dread]]  "item_whisper_of_the_dread",
    --[[Serrrated Shiv]]        "item_serrated_shiv",
    --[[Gale Guard]]            "item_gale_guard",
    --[[Gunpowder Gauntlet]]    "item_gunpowder_gauntlets",
    -- --[[Ninja Gear]]            "item_ninja_gear",
    --[[Jidi Pollen Bag]]       "item_jidi_pollen_bag",
}

local Tier4NeutralItems = {
    -- --[[Timeless Relic]]        "item_timeless_relic",
    -- --[[Ascetic Cap]]           "item_ascetic_cap",
    -- --[[Aviana's Feather]]      "item_avianas_feather",
    -- --[[Ninja Gear]]            "item_ninja_gear",
    -- --[[Telescope]]             "item_spy_gadget",
    -- --[[Trickster Cloak]]       "item_trickster_cloak",
    -- --[[Stormcrafter]]          "item_stormcrafter",
    -- --[[Ancient Guardian]]      "item_ancient_guardian",
    -- --[[Havoc Hammer]]          "item_havoc_hammer",
    -- --[[Mind Breaker]]          "item_mind_breaker",
    -- --[[Martyr's Plate]]        "item_martyrs_plate",
    -- --[[Rattlecage]]            "item_rattlecage",
    -- --[[Ogre Seal Totem]]       "item_ogre_seal_totem",
    --[[Crippling Crossbow]]    "item_crippling_crossbow",
    --[[Magnifying Monocle]]    "item_magnifying_monocle",
    -- --[[Ceremonial Robe]]       "item_ceremonial_robe",
    --[[Pyrrhic Cloak]]         "item_pyrrhic_cloak",
    --[[Dezun Bloodrite]]       "item_dezun_bloodrite",
    --[[Giant's Maul]]          "item_giant_maul",
    --[[Outworld Staff]]        "item_outworld_staff",
}

local Tier5NeutralItems = {
    -- --[[Force Boots]]           "item_force_boots",
    --[[Stygian Desolator]]     "item_desolator_2",
    -- --[[Seer Stone]]            "item_seer_stone",
    -- --[[Mirror Shield]]         "item_mirror_shield",
    -- --[[Apex]]                  "item_apex",
    --[[Book of the Dead]]      "item_demonicon",
    -- --[[Arcanist's Armor]]      "item_force_field",
    -- --[[Pirate Hat]]            "item_pirate_hat",
    -- --[[Giant's Ring]]          "item_giants_ring",
    -- --[[Unwavering Condition]]  "item_unwavering_condition",
    -- --[[Book of Shadows]]       "item_book_of_shadows",
    -- --[[Magic Lamp]]            "item_panic_button",
    --[[Fallen Sky]]            "item_fallen_sky",
    --[[Minotaur Horn]]         "item_minotaur_horn",
    --[[Spider Legs]]           "item_spider_legs",
    --[[Unrelenting Eye]]       "item_unrelenting_eye",
    --[[Divine Regalia]]        "item_divine_regalia",
    -- -- [[Disgraced Regalia]]     "item_divine_regalia_broken", -- what 'item_divine_regalia' turns into
    --[[Helm of the Undying]]   "item_helm_of_the_undying",
}

local hNeutralItemsList = {
    [1] = Tier1NeutralItems,
    [2] = Tier2NeutralItems,
    [3] = Tier3NeutralItems,
    [4] = Tier4NeutralItems,
    [5] = Tier5NeutralItems,
}

-- Enhancements

local TierEnhancements = {
    [1] = {
        "item_enhancement_alert",
        "item_enhancement_brawny",
        "item_enhancement_mystical",
        "item_enhancement_quickened",
        "item_enhancement_tough",
    },
    [2] = {
        "item_enhancement_alert",
        "item_enhancement_brawny",
        "item_enhancement_mystical",
        "item_enhancement_quickened",
        "item_enhancement_tough",

        "item_enhancement_vast",
        "item_enhancement_greedy",
        "item_enhancement_keen_eyed",
        "item_enhancement_vampiric",
    },
    [3] = {
        "item_enhancement_alert",
        "item_enhancement_brawny",
        "item_enhancement_mystical",
        "item_enhancement_quickened",
        "item_enhancement_tough",

        "item_enhancement_vast",
        "item_enhancement_greedy",
        "item_enhancement_keen_eyed",
        "item_enhancement_vampiric",
    },
    [4] = {
        "item_enhancement_alert",
        "item_enhancement_brawny",
        "item_enhancement_mystical",
        "item_enhancement_quickened",
        "item_enhancement_tough",

        "item_enhancement_vampiric",

        "item_enhancement_timeless",
        "item_enhancement_titanic",
        "item_enhancement_crude",
    },
    [5] = {
        "item_enhancement_timeless",
        "item_enhancement_titanic",
        "item_enhancement_crude",

        "item_enhancement_feverish",
        "item_enhancement_fleetfooted",
        "item_enhancement_audacious",
        "item_enhancement_evolved",
        "item_enhancement_boundless",
        "item_enhancement_wise",
    }
}

local function DoGive(hero, nTier)
    local sItemName = ''
    local heroData = neutrals_data[hero:GetUnitName()]['neutral']
    if heroData and heroData[nTier] then
        sItemName = NeutralItems.SelectItem(heroData[nTier])
    else
        sItemName = hNeutralItemsList[nTier][RandomInt(1, #hNeutralItemsList[nTier])]
    end

    if sItemName ~= '' then
        NeutralItems.GiveItem(sItemName, hero, nTier)
        -- something green
        GameRules:SendCustomMessage("<font color='#70EA71'>"..string.gsub(hero:GetUnitName(), 'npc_dota_hero_', '').."</font>"..' recieved a Tier '..tostring(nTier)..' neutral item!', -1, 0)
        hero.neutral_items[nTier].assigned = true
    end
end

-- with 11/10/25 update, this will override (or get overriden), since valve made bots craft items
-- will disable (?); can't check madstones
local bInitTimes = false
function NeutralItems.GiveNeutralItems(hHeroList)
    local bTurboMode = Helper.IsTurboMode()
    local fCurrentTime = Helper.DotaTime()
    local nCurrentTierWindow = NeutralItems.GetCurrentTierWindow(bTurboMode, fCurrentTime)

    if not bInitTimes and #hHeroList > 0 then
        for _, hero in pairs(hHeroList) do
            if hero.neutral_items == nil then
                hero.neutral_items = {
                    [1] = { assign_time = 0, assigned = false },
                    [2] = { assign_time = 0, assigned = false },
                    [3] = { assign_time = 0, assigned = false },
                    [4] = { assign_time = 0, assigned = false },
                    [5] = { assign_time = 0, assigned = false },
                }
            end

            if hero.neutral_items then
                -- range; to feel more natural
                if bTurboMode then
                    hero.neutral_items[1].assign_time = RandomFloat( 2.5,  4.5)
                    hero.neutral_items[2].assign_time = RandomFloat( 7.5,  9.5)
                    hero.neutral_items[3].assign_time = RandomFloat(12.5, 14.5)
                    hero.neutral_items[4].assign_time = RandomFloat(17.5, 19.5)
                    hero.neutral_items[5].assign_time = RandomFloat(30.0, 32.0)
                else
                    hero.neutral_items[1].assign_time = RandomFloat( 5,  8)
                    hero.neutral_items[2].assign_time = RandomFloat(15, 18)
                    hero.neutral_items[3].assign_time = RandomFloat(25, 28)
                    hero.neutral_items[4].assign_time = RandomFloat(35, 38)
                    hero.neutral_items[5].assign_time = RandomFloat(60, 63)
                end
            end
        end

        bInitTimes = true
    end

    -- Give Neutral Items
    for _, hero in pairs(hHeroList) do
        if hero.neutral_items then
            if hero.neutral_items[nCurrentTierWindow].assigned == false and fCurrentTime >= hero.neutral_items[nCurrentTierWindow].assign_time * 60 then
                DoGive(hero, nCurrentTierWindow)
            end

            -- if fCurrentTime >= hero.neutral_items[nCurrentTierWindow].assign_time * 60 then
            --     local hItem = hero:GetItemInSlot(16)
            --     if hItem then
            --         local itemTier = NeutralItems.GetItemTier(hItem:GetName())
            --         if itemTier > 0 and itemTier ~= nCurrentTierWindow then
            --             DoGive(hero, nCurrentTierWindow)
            --         end
            --     end
            -- end
        end
    end

    -- replace 'item_divine_regalia_broken'; right away?
    for _, h in pairs(hHeroList) do
        if h and h:HasItemInInventory('item_divine_regalia_broken') then
            local sItemName = ''
            local heroData = neutrals_data[h:GetUnitName()]['neutral']
            if heroData and heroData[5] then
                sItemName = NeutralItems.SelectItem(heroData[5])
            else
                sItemName = Tier5NeutralItems[RandomInt(1, #Tier5NeutralItems)]
            end

            if sItemName ~= '' then
                NeutralItems.GiveItem(sItemName, h, 5)
            end
        end
    end
end

function NeutralItems.GiveItem(itemName, hero, tier)
    if hero:HasRoomForItem(itemName, true, true)
    then
        local item = CreateItem(itemName, hero, hero)
        item:SetPurchaseTime(0)

        -- remove so they don't stick to the next item
        if hero then
            local itemEnhancement = hero:GetItemInSlot(17)
            if itemEnhancement then hero:RemoveItem(itemEnhancement) end
        end

        -- neutral item
        hero:RemoveItem(hero:GetItemInSlot(16))
        hero:AddItem(item)

        -- give some enhancement
        local eList = TierEnhancements[tier]
        if eList then
            local e = eList[RandomInt(1, #eList)]
            local heroData = neutrals_data[hero:GetUnitName()]['enhancement']
            if heroData and heroData[tier] then
                e = NeutralItems.SelectItem(heroData[tier])
            end

            if e ~= nil then
                item = CreateItem(e, hero, hero)

                -- check if this enhancement is available in lower tiers
                -- if it does, upgrade it n times
                local nCount = 0
                for i = 1, tier - 1 do
                    if TierEnhancements[i] then
                        for _, prev in pairs(TierEnhancements[i]) do
                            if prev == e then
                                nCount = nCount + 1
                            end
                        end
                    end
                end

                for _ = 1, nCount do
                    item:UpgradeAbility(true)
                end

                item:SetPurchaseTime(0)
                hero:AddItem(item)
            end
        end
    end
end

-- do a simple weighted random selection
function NeutralItems.SelectItem(hNeutralItemList)
    local items = {}
    local weights = {}
    for item, weight in pairs(hNeutralItemList) do
        table.insert(items,item)
        table.insert(weights,weight)
    end

    local totalWeight = 0
    for _, weight in pairs(weights) do
        totalWeight = totalWeight + weight
    end

    local randVal = (RandomInt(0, 100) / 100) * totalWeight
    local accumWeight = 0
    local selectedItem = ''

    for i, weight in ipairs(weights) do
        accumWeight = accumWeight + weight
        if randVal <= accumWeight then
            selectedItem = items[i]
            break
        end
    end

    return selectedItem
end

function NeutralItems.GetCurrentTierWindow(bTurboMode, fCurrentTime)
    local thresholds = bTurboMode and {2.5, 7.5, 12.5, 17.5, 30} or {5, 15, 25, 35, 60}
    for i = #thresholds, 1, -1 do
        if fCurrentTime >= thresholds[i] * 60 then return i end
    end

    return 1
end

function NeutralItems.GetItemTier(sItemName)
    local itemList = { Tier1NeutralItems, Tier2NeutralItems, Tier3NeutralItems, Tier4NeutralItems, Tier5NeutralItems }
    for tier, items in pairs(itemList) do
        for _, item in pairs(items) do
            if item == sItemName then
                return tier
            end
        end
    end

    return -1
end

return NeutralItems