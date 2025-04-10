if F == nil then F = {} end

-- Mainly for Morphling (bot str is ass); since can't change his primary with 'SetPrimaryAttribute'
-- In-game UI doesn't show the change, but it works
-- Only for bots that considers a facet as an ability (most do not), and needs changing (ie Morphling, etc)
function F.ChangeHeroFacet(bot)
    if bot ~= nil then
        local heroName = bot:GetUnitName()

        -- TODO: others (if possible)

        if heroName == 'npc_dota_hero_morphling' then
            if bot:HasAbility('morphling_flow') then
                F.DoChange(bot, 'morphling_flow', 'morphling_ebb', false)
            end

        -- Comment out if not using TA bot script, as it requires some other edits (main).
        elseif heroName == 'npc_dota_hero_faceless_void' then
                if RandomInt(1,2) == 1 then
                    if bot:HasAbility('faceless_void_time_zone') then
                        F.DoChange(bot, 'faceless_void_time_zone', 'faceless_void_chronosphere', true)
                    end
                end
        elseif heroName == 'npc_dota_hero_disruptor' then
            if RandomInt(1,2) == 1 then
                if bot:HasAbility('disruptor_kinetic_fence') then
                    F.DoChange(bot, 'disruptor_kinetic_fence', 'disruptor_kinetic_field', true)
                end
            end
        elseif heroName == 'npc_dota_hero_keeper_of_the_light' then
            if RandomInt(1,2) == 1 then
                if bot:HasAbility('keeper_of_the_light_recall') then
                    F.DoChange(bot, 'keeper_of_the_light_recall', 'keeper_of_the_light_radiant_bind', true)
                end
            end
        elseif heroName == 'npc_dota_hero_tusk' then
            if RandomInt(1,2) == 1 then
                if bot:HasAbility('tusk_drinking_buddies') then
                    F.DoChange(bot, 'tusk_drinking_buddies', 'tusk_tag_team', true)
                end
            end
        end

        bot.facet_flag = true
    end
end

function F.DoChange(hUnit, sAbilityName1, sAbilityName2, bSwap)
    if bSwap then
        hUnit:AddAbility(sAbilityName2)
        hUnit:SwapAbilities(sAbilityName1, sAbilityName2, false, true)
    else
        hUnit:RemoveAbility(sAbilityName1)
        hUnit:AddAbility(sAbilityName2)
    end

    print('Changed ' .. hUnit:GetUnitName() .. ' facet/ability from ' .. sAbilityName1 .. ' to ' .. sAbilityName2 .. '!')
end

return F
