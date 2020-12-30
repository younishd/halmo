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

local function string(o)
    return '"' .. tostring(o) .. '"'
end

local function recurse(o, indent)
    indent = indent or ''
    local indent2 = indent .. '    '
    if type(o) == 'table' then
        local s = indent .. '{' .. '\n'
        local first = true
        for k, v in pairs(o) do
            if not first then s = s .. ', \n' end
            if type(k) ~= 'number' then k = string(k) end
            s = s .. indent2 .. '[' .. k .. '] = ' .. recurse(v, indent2)
            first = false
        end
        return s .. '\n' .. indent .. '}'
    else
        return string(o)
    end
end

local function cast_msg(msg)
    if (type(msg) == 'table') then
        msg = recurse(msg)
    end
    msg = table.explode("\n", tostring(msg))
    return msg
end

function log.info(msg)
    msg = cast_msg(msg)

    for _, v in pairs(msg) do
        print(green .. "[+]  " .. v .. reset)
    end
end

function log.error(msg)
    msg = cast_msg(msg)

    for _, v in pairs(msg) do
        print(red .. "[-]  " .. v .. reset)
    end
end

function log.debug(msg)
    msg = cast_msg(msg)

    for _, v in pairs(msg) do
        print(yellow .. "[*]  " .. v .. reset)
    end
end

return log
