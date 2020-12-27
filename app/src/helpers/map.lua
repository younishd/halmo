--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local function map(f, ...)
    local t = {}
    for k, v in ipairs(...) do
        t[#t+1] = f(v)
    end
    return t
end

return map
