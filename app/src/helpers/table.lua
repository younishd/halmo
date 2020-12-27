--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local _table  = {}

function _table.print(t)
    local print_cache = {}
    local function sub_print(t, indent)
        if (print_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print(t, "  ")
        print("}")
    else
        sub_print(t, "  ")
    end
    print()
end

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
