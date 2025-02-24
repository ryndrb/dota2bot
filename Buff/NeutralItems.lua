local ndata = require('bots/Buff/script/ndata')

if NeutralItems == nil
then
    NeutralItems = {}
end

local isTierOneDone   = false
local isTierTwoDone   = false
local isTierThreeDone = false
local isTierFourDone  = false
local isTierFiveDone  = false

-- use these for now until stratz update their stuff

-- Neutrals

local Tier1NeutralItems = {
    --[[Trusty Shovel]]         "item_trusty_shovel",
    -- --[[Arcane Ring]]           "item_arcane_ring",
    -- --[[Fairy's Trinket]]       "item_mysterious_hat",
    --[[Pig Pole]]              "item_unstable_wand",
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
    --[[Mana Draught]]          "item_mana_draught",
    --[[Polliwog Charm]]        "item_polliwog_charm",
    --[[Ripper's Lash]]         "item_rippers_lash",
    --[[Orb of Destruction]]    "item_orb_of_destruction",
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
    --[[Gossamer's Cape]]       "item_gossamer_cape",
    -- --[[Light Collector]]       "item_light_collector",
    --[[Iron Talon]]            "item_iron_talon",
    --[[Essence Ring]]          "item_essence_ring",
    --[[Searing Signet]]        "item_searing_signet",
    --[[Brigand's Balde]]       "item_misericorde",
    --[[Tumbler's Toy]]         "item_pogo_stick",
}

local Tier3NeutralItems = {
    -- --[[Defiant Shell]]         "item_defiant_shell",
    -- --[[Paladin Sword]]         "item_paladin_sword",
    --[[Nemesis Curse]]         "item_nemesis_curse",
    -- --[[Vindicator's Axe]]      "item_vindicators_axe",
    -- --[[Dandelion Amulet]]      "item_dandelion_amulet",
    -- --[[Craggy Coat]]           "item_craggy_coat",
    -- --[[Enchanted Quiver]]      "item_enchanted_quiver",
    -- --[[Elven Tunic]]           "item_elven_tunic",
    -- --[[Cloack of Flames]]      "item_cloak_of_flames",
    -- --[[Ceremonial Robe]]       "item_ceremonial_robe",
    -- --[[Psychic Headband]]      "item_psychic_headband",
    -- --[[Doubloon]]              "item_doubloon",
    -- --[[Vambrace]]              "item_vambrace",
    --[[Whisper of the Dread]]  "item_whisper_of_the_dread",
    --[[Serrrated Shiv]]        "item_serrated_shiv",
    --[[Gale Guard]]            "item_gale_guard",
    --[[Gunpowder Gauntlet]]    "item_gunpowder_gauntlets",
    --[[Ninja Gear]]            "item_ninja_gear",
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
    --[[Mind Breaker]]          "item_mind_breaker",
    -- --[[Martyr's Plate]]        "item_martyrs_plate",
    -- --[[Rattlecage]]            "item_rattlecage",
    --[[Ogre Seal Totem]]       "item_ogre_seal_totem",
    --[[Crippling Crossbow]]    "item_crippling_crossbow",
    --[[Magnifying Monocle]]    "item_magnifying_monocle",
    --[[Ceremonial Robe]]       "item_ceremonial_robe",
    --[[Pyrrhic Cloak]]         "item_pyrrhic_cloak",
}

local Tier5NeutralItems = {
    -- --[[Force Boots]]           "item_force_boots",
    --[[Stygian Desolator]]     "item_desolator_2",
    -- --[[Seer Stone]]            "item_seer_stone",
    -- --[[Mirror Shield]]         "item_mirror_shield",
    -- --[[Apex]]                  "item_apex",
    --[[Book of the Dead]]      "item_demonicon",
    -- --[[Arcanist's Armor]]      "item_force_field",
    --[[Pirate Hat]]            "item_pirate_hat",
    -- --[[Giant's Ring]]          "item_giants_ring",
    -- --[[Unwavering Condition]]  "item_unwavering_condition",
    -- --[[Book of Shadows]]       "item_book_of_shadows",
    --[[Magic Lamp]]            "item_panic_button",
    --[[Fallen Sky]]            "item_fallen_sky",
    --[[Minotaur Horn]]         "item_minotaur_horn",
    --[[Spider Legs]]           "item_spider_legs",
    --[[Unrelenting Eye]]       "item_unrelenting_eye",
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

-- Just give out random for now.
function NeutralItems.GiveNeutralItems(hHeroList)
    local isTurboMode = Helper.IsTurboMode()

    -- Tier 1 Neutral Items
    if (isTurboMode and Helper.DotaTime() >= 2.5 * 60 or Helper.DotaTime() >= 5 * 60)
    and not isTierOneDone
    then
        GameRules:SendCustomMessage('Bots receiving Tier 1 Neutral Items...', 0, 0)

        for _, h in pairs(hHeroList) do
            local sItemName = ''
            -- local heroData = ndata[h:GetUnitName()]
            -- if heroData and heroData['TIER_1'] then
            --     sItemName = NeutralItems.SelectItem(heroData['TIER_1'])
            -- else
                sItemName = Tier1NeutralItems[RandomInt(1, #Tier1NeutralItems)]
            -- end

            if sItemName ~= '' then
                NeutralItems.GiveItem(sItemName, h, isTierOneDone, 1)
            end
        end

        isTierOneDone = true
    end

    -- Tier 2 Neutral Items
    if (isTurboMode and Helper.DotaTime() >= 7.5 * 60 or Helper.DotaTime() >= 15 * 60)
    and not isTierTwoDone
    then
        GameRules:SendCustomMessage('Bots receiving Tier 2 Neutral Items...', 0, 0)

        for _, h in pairs(hHeroList) do
            local sItemName = ''
            -- local heroData = ndata[h:GetUnitName()]
            -- if heroData and heroData['TIER_2'] then
            --     sItemName = NeutralItems.SelectItem(heroData['TIER_2'])
            -- else
                sItemName = Tier2NeutralItems[RandomInt(1, #Tier2NeutralItems)]
            -- end

            if sItemName ~= '' then
                NeutralItems.GiveItem(sItemName, h, isTierOneDone, 2)
            end
        end

        isTierTwoDone = true
    end

    -- Tier 3 Neutral Items
    if (isTurboMode and Helper.DotaTime() >= 12.5 * 60 or Helper.DotaTime() >= 25 * 60)
    and not isTierThreeDone
    then
        GameRules:SendCustomMessage('Bots receiving Tier 3 Neutral Items...', 0, 0)

        for _, h in pairs(hHeroList) do
            local sItemName = ''
            -- local heroData = ndata[h:GetUnitName()]
            -- if heroData and heroData['TIER_3'] then
            --     sItemName = NeutralItems.SelectItem(heroData['TIER_3'])
            -- else
                sItemName = Tier3NeutralItems[RandomInt(1, #Tier3NeutralItems)]
            -- end

            if sItemName ~= '' then
                NeutralItems.GiveItem(sItemName, h, isTierOneDone, 3)
            end
        end

        isTierThreeDone = true
    end

    -- Tier 4 Neutral Items
    if (isTurboMode and Helper.DotaTime() >= 17.5 * 60 or Helper.DotaTime() >= 35 * 60)
    and not isTierFourDone
    then
        GameRules:SendCustomMessage('Bots receiving Tier 4 Neutral Items...', 0, 0)

        for _, h in pairs(hHeroList) do
            local sItemName = ''
            -- local heroData = ndata[h:GetUnitName()]
            -- if heroData and heroData['TIER_4'] then
            --     sItemName = NeutralItems.SelectItem(heroData['TIER_4'])
            -- else
                sItemName = Tier4NeutralItems[RandomInt(1, #Tier4NeutralItems)]
            -- end

            if sItemName ~= '' then
                NeutralItems.GiveItem(sItemName, h, isTierOneDone, 4)
            end
        end

        isTierFourDone = true
    end

    -- Tier 5 Neutral Items
    if (isTurboMode and Helper.DotaTime() >= 30 * 60 or Helper.DotaTime() >= 60 * 60)
    and not isTierFiveDone
    then
        GameRules:SendCustomMessage('Bots receiving Tier 5 Neutral Items...', 0, 0)

        for _, h in pairs(hHeroList) do
            local sItemName = ''
            -- local heroData = ndata[h:GetUnitName()]
            -- if heroData and heroData['TIER_5'] then
            --     sItemName = NeutralItems.SelectItem(heroData['TIER_5'])
            -- else
                sItemName = Tier5NeutralItems[RandomInt(1, #Tier5NeutralItems)]
            -- end

            if sItemName ~= '' then
                NeutralItems.GiveItem(sItemName, h, isTierOneDone, 5)
            end
        end

        isTierFiveDone = true
    end
end

function NeutralItems.GiveItem(itemName, hero, isTierDone, tier)
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
        if NeutralItems.HasNeutralItem(hero)
        and isTierDone
        then
            hero:RemoveItem(hero:GetItemInSlot(16))
            hero:AddItem(item)
        else
            hero:AddItem(item)
        end

        -- give some enhancement
        local eList = TierEnhancements[tier]
        if eList then
            local e = eList[RandomInt(1, #eList)]
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

function NeutralItems.HasNeutralItem(hero)
    if not hero then
        return false
    end

    local item = hero:GetItemInSlot(16)
    if item then
        return true
    end

    return false
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

    local randVal = math.random() * totalWeight
    local accumWeight = 0
    local selectedItem = ''

    for i, weight in pairs(weights) do
        accumWeight = accumWeight + weight
        if randVal <= accumWeight then
            selectedItem = items[i]
            break
        end
    end

    return selectedItem
end

return NeutralItems