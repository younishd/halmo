--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local function file_exists(f)
    local f = io.open(f, "r")
    if f ~= nil then
        io.close(f)
        return true
    end
    return false
end

return file_exists
