if F == nil then F = {} end

-- Mainly for Morphling (bot str is ass); since can't change his primary with 'SetPrimaryAttribute'
-- In-game UI doesn't show the change, but it works
-- Only for bots that considers a facet as an ability (most do not), and needs changing (ie Morphling, etc)
function F.ChangeHeroFacet(bot)
    if bot ~= nil then
        local heroName = bot:GetUnitName()
        local hAbility_remove = nil
        local hAbility_add = nil

        -- TODO: others if there's more / possible
        if string.find(heroName, 'morphling') then
            if bot:HasAbility('morphling_flow') then
                hAbility_add = 'morphling_ebb'
                hAbility_remove = 'morphling_flow'
            end
        end

        if hAbility_remove ~= nil and hAbility_add ~= nil then
            bot:RemoveAbility(hAbility_remove)
            bot:AddAbility(hAbility_add)
            bot.facet_flag = true
            print('Changed ' .. heroName .. ' facet from ' .. hAbility_remove .. ' to ' .. hAbility_add .. '!')
        end
    end
end

return F
