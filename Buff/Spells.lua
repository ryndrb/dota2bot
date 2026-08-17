if S == nil then S = {} end

-- this is for the can't be implemented spells using the regular bot api (ie Visage Familiars).
-- this doesn't run every frame

S.AbilityUsageHeroList = {
    ['npc_dota_hero_visage'] = true,
}

function S.AbilityUsageThink(bot)
    if bot then
        local botID = bot:GetPlayerOwnerID()
        local botAbilityCount = bot:GetAbilityCount()

        for i = 0, botAbilityCount - 1 do
            local hAbility = bot:GetAbilityByIndex(i)
            if hAbility then
                local sAbilityName = hAbility:GetAbilityName()
                local hAbilityFunction = S.ConsiderAbilityUsage[sAbilityName]

                if hAbilityFunction then
                    local bCast, hCastTarget, hCastType = hAbilityFunction(bot, hAbility)
                    if bCast then
                        if hCastType == 'unit' then
                            bot:CastAbilityOnTarget(hCastTarget, hAbility, botID)
                            return
                        elseif hCastType == 'point' then
                            bot:CastAbilityOnPosition(hCastTarget, hAbility, botID)
                            return
                        elseif hCastType == 'none' then
                            bot:CastAbilityNoTarget(hAbility, botID)
                            return
                        end
                    end
                end
            end
        end
    end
end

S.ConsiderAbilityUsage = {}

S.ConsiderAbilityUsage['visage_summon_familiars'] = function(bot, hAbility)
    if not Helper.CanCastAbility(hAbility) then return false end

    local nFamiliarCount = 2
    local addedFamiliarTalent = S.GetAbilityHandle(bot, 'special_bonus_unique_visage_6')
    if addedFamiliarTalent and addedFamiliarTalent:IsTrained() then
        nFamiliarCount = nFamiliarCount + 1
    end

    local hUnitList = FindUnitsInRadius(
        bot:GetTeam(),
        Vector(0, 0, 0),
        nil,
        FIND_UNITS_EVERYWHERE,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_ALL,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    local nCurrFamiliar = 0
	for i = 1, #hUnitList do
        if hUnitList[i] then
            if string.find(hUnitList[i]:GetUnitName(), 'npc_dota_visage_familiar') then
                nCurrFamiliar = nCurrFamiliar + 1
            end
        end
	end

	if nFamiliarCount > nCurrFamiliar then
		return true, nil, 'none'
	end

    return false
end

-- for picking up bounty runes; 7.41+
function S.TryPickUpNearbyBounty(bot)
    local bountyRuneSpawners = Entities:FindAllByClassnameWithin('dota_item_rune_spawner_bounty', bot:GetAbsOrigin(), 150)
    for _, spawner in pairs(bountyRuneSpawners) do
        if spawner and (bot:GetAbsOrigin() - spawner:GetAbsOrigin()):Length2D() < 150 then
            local bountyRunes = Entities:FindAllByClassnameWithin('dota_item_rune', bot:GetAbsOrigin(), 150)
            for _, rune in pairs(bountyRunes) do
                if rune and (rune:GetAbsOrigin() - spawner:GetAbsOrigin()):Length2D() < 150 then
                    bot:PickupRune(rune)
                    print('[Buff]' .. bot:GetUnitName() .. ' picked bounty rune using Buff.. ')
                end
            end
        end
    end
end

function S.GetAbilityHandle(bot, sAbilityName)
    local botAbilityCount = bot:GetAbilityCount()
    for i = 0, botAbilityCount - 1 do
        local hAbility = bot:GetAbilityByIndex(i)
        if hAbility and hAbility:GetAbilityName() == sAbilityName then
            return hAbility
        end
    end

    return nil
end

return S