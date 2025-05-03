local U = {}

-- http://lua-users.org/wiki/CopyTable
function U.deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[U.deepCopy(orig_key)] = U.deepCopy(orig_value)
        end
        setmetatable(copy, U.deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function U.tablesEqual(t1, t2)
    if t1 == t2 then return true end

    if type(t1) ~= 'table' or type(t2) ~= 'table' then return false end

    local t1_len, t2_len = 0, 0
    for k1, v1 in pairs(t1)
    do
        t1_len = t1_len + 1
        local v2 = t2[k1]
        if v2 == nil or not U.tablesEqual(v1, v2)
        then
            return false
        end
    end

    for _ in pairs(t2) do t2_len = t2_len + 1 end

    return t1_len == t2_len
end

function U.shuffleWeighted(items, weights)
    local order = {}
    for i = 1, #items do
        -- math.random not seeded?
        order[i] = {index = i, score = (RandomInt(0, 100) / 100) ^ (1.0 / weights[i])}
    end

    table.sort(order, function(a, b) return a.score > b.score end)

    local shuffled = {}
    for _, entry in ipairs(order) do
        table.insert(shuffled, items[entry.index])
    end

    return shuffled
end

return U