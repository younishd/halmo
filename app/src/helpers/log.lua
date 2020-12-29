--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local log = {}

log.reset     = string.char(27) .. '[' .. tostring(0)  .. 'm'
log.red       = string.char(27) .. '[' .. tostring(31) .. 'm'
log.green     = string.char(27) .. '[' .. tostring(32) .. 'm'
log.yellow    = string.char(27) .. '[' .. tostring(33) .. 'm'

function log.info(msg)
    if (type(msg) == 'number') then msg = tostring(msg) end
    msg = table.explode("\n", msg)
    for _, v in pairs(msg) do
        print(log.green .. "[+]  " .. v .. log.reset)
    end
end

function log.error(msg)
    if (type(msg) == 'number') then msg = tostring(msg) end
    msg = table.explode("\n", msg)
    for _, v in pairs(msg) do
        print(log.red .. "[-]  " .. v .. log.reset)
    end
end

function log.debug(msg)
    if (type(msg) == 'number') then msg = tostring(msg) end
    msg = table.explode("\n", msg)
    for _, v in pairs(msg) do
        print(log.yellow .. "[*]  " .. v .. log.reset)
    end
end

return log
