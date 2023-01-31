--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local _table  = {}

function _table.contains(t, v)
    for _, j in pairs(t) do
        if j == v then
            return true
        end
    end
    return false
end

function _table.explode(d, p)
    local t, ll
    t = {}
    ll = 0
    if (#p == 1) then return {p} end
    while true do
        l = string.find(p, d, ll, true)
        if l ~= nil then
            table.insert(t, string.sub(p, ll, l - 1))
            ll = l + 1
        else
            table.insert(t, string.sub(p, ll))
            break
        end
    end
    return t
end

function _table.append(t, x)
    t[#t+1] = x
end

return _table
