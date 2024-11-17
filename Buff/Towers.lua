
if T == nil then
    T = {}
end

-- some stuff for now

function T.HandleTowerBuff(nTeam)
    local hBuildings = Entities:FindAllByClassname("npc_dota_tower")
    local hBarracks = Entities:FindAllByClassname("npc_dota_barracks")
    local hAncients = Entities:FindAllByClassname("npc_dota_fort")

    for _, b in pairs(hBarracks) do table.insert(hBuildings, b) end
    for _, a in pairs(hAncients) do table.insert(hBuildings, a) end

    for _, tower in pairs(hBuildings) do
        if tower ~= nil and tower:IsAlive() and tower:GetTeam() == nTeam then
            local hUnitList = T.GetNonHeroAttackingUnit(tower)
            local nAdd = 0

            if string.find(tower:GetUnitName(), 'tower1') then
                nAdd = 10
            elseif string.find(tower:GetUnitName(), 'tower2') then
                nAdd = 12
            elseif string.find(tower:GetUnitName(), 'tower3') then
                nAdd = 14
            elseif string.find(tower:GetUnitName(), 'tower4') then
                nAdd = 16
            elseif string.find(tower:GetUnitName(), 'rax') then
                nAdd = 18
            elseif string.find(tower:GetUnitName(), 'fort') then
                nAdd = 20
            end

            local fRegen = T.GetAverageUnitsDamage(hUnitList) + nAdd

            if tower:IsBarracks() then
                fRegen = fRegen * 1.25
            elseif tower:IsFort() then
                fRegen = fRegen * 1.5
            end

            tower:SetBaseHealthRegen(fRegen)
        end
    end
end

function T.GetNonHeroAttackingUnit(tower)
    local hAttackingList = {}
    local hUnitList = FindUnitsInRadius(
        tower:GetTeam(),
        tower:GetAbsOrigin(),
        nil,
        1600,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_COURIER,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, unit in pairs(hUnitList) do
        if unit ~= nil and unit:IsAlive() then
            if (tower:IsTower() and not unit:IsHero())
            or tower:IsBarracks()
            or tower:IsFort()
            then
                table.insert(hAttackingList, unit)
            end
        end
    end

    return hAttackingList
end

function T.GetAverageUnitsDamage(hUnitList)
    local fTotalDamage = 0
    local nCount = 0
    for _, unit in pairs(hUnitList) do
        if unit ~= nil and unit:IsAlive() then
            fTotalDamage = fTotalDamage + unit:GetAttackDamage()
            nCount = nCount + 1
        end
    end

    if nCount > 0 then
        return fTotalDamage / nCount
    else
        return 0
    end
end

return T