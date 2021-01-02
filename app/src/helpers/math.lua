--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local _math = {}

function _math.sign(n)
    if n < 0 then return -1
    elseif n > 0 then return 1
    else return 0 end
end

return _math
