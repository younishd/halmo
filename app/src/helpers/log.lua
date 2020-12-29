--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local log = {}

local reset     = string.char(27) .. '[' .. tostring(0)  .. 'm'
local red       = string.char(27) .. '[' .. tostring(31) .. 'm'
local green     = string.char(27) .. '[' .. tostring(32) .. 'm'
local yellow    = string.char(27) .. '[' .. tostring(33) .. 'm'

function log.info(msg)
    if (type(msg) == 'number') then msg = tostring(msg) end
    msg = table.explode("\n", msg)
    for _, v in pairs(msg) do
        print(green .. "[+]  " .. v .. reset)
    end
end

function log.error(msg)
    if (type(msg) == 'number') then msg = tostring(msg) end
    msg = table.explode("\n", msg)
    for _, v in pairs(msg) do
        print(red .. "[-]  " .. v .. reset)
    end
end

function log.debug(msg)
    if (type(msg) == 'number') then msg = tostring(msg) end
    msg = table.explode("\n", msg)
    for _, v in pairs(msg) do
        print(yellow .. "[*]  " .. v .. reset)
    end
end

return log
