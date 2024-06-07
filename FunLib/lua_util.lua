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

return U