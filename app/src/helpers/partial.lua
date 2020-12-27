--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local function partial(f, arg)
    return function(...)
        return f(arg, ...)
    end
end

return partial
