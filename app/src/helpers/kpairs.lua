--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local function kpairs(t, f)
    local keys = {}
    for k in pairs(t) do table.insert(keys, k) end
    table.sort(keys, f)
    local i = 0
    return function()
        i = i + 1
        if keys[i] == nil then return nil end
        return keys[i], t[keys[i]]
    end
end

return kpairs
