--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local function kpairs(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0
    return function()
        i = i + 1
        if a[i] == nil then return nil end
        return a[i], t[a[i]]
    end
end

return kpairs
