----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local function map(f, ...)
    local t = {}
    for k, v in pairs(...) do
        t[k] = f(v)
    end
    return t
end

return map
