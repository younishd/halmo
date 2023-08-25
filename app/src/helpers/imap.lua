----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----

local function imap(f, ...)
    local t = {}
    for _, v in ipairs(...) do
        t[#t+1] = f(v)
    end
    return t
end

return imap
