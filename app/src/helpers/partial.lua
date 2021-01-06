--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local function partial(f, a)
    return function(...)
        return f(a, ...)
    end
end

return partial
