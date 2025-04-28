
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
            local sTowerName = tower:GetUnitName()
            local bTierThreeTower = string.find(sTowerName, 'tower3')
            local bTierFourTower = string.find(sTowerName, 'tower4')
            local bRax = string.find(sTowerName, 'rax')
            -- local bAncient = string.find(sTowerName, 'fort')

            if bTierThreeTower or bTierFourTower or bRax --[[or bAncient]] then
                local bEnemyInRadius = T.IsThereEnemyHeroInRadius(tower, 950)
                local hUnitList = T.GetAttackingUnitsInRadius(tower, 1600)
                local fAverageUnitsDmg = T.GetAverageUnitsDamage(hUnitList)
                local fRegen = 0

                if bTierThreeTower or bTierFourTower then
                    if bEnemyInRadius then
                        fRegen = 17
                    else
                        fRegen = 17 + fAverageUnitsDmg
                    end
                elseif bRax then
                    if bEnemyInRadius then
                        fRegen = 20
                    else
                        fRegen = 20 + fAverageUnitsDmg
                    end
                -- elseif bAncient then
                --     fRegen = 23 + fAverageUnitsDmg
                end

                if tower:IsBarracks() then
                    fRegen = fRegen * 1.25
                -- elseif tower:IsFort() then
                --     fRegen = fRegen * 1.5
                end

                tower:SetBaseHealthRegen(fRegen)
            end
        end
    end
end

function T.GetAttackingUnitsInRadius(tower, nRadius)
    local hAttackingList = {}
    local hUnitList = FindUnitsInRadius(
        tower:GetTeam(),
        tower:GetAbsOrigin(),
        nil,
        nRadius,
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

function T.IsThereEnemyHeroInRadius(tower, nRadius)
    local hUnitList = FindUnitsInRadius(
        tower:GetTeam(),
        tower:GetAbsOrigin(),
        nil,
        nRadius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_COURIER,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, unit in pairs(hUnitList) do
        if unit ~= nil and unit:IsAlive() and unit:IsHero() and unit:GetAttackTarget() == tower then
            return true
        end
    end

    return false
end

return T