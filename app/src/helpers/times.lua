----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----

local function times(f, n, ...)
    if n == 0 then return ... end
    return f(times(f, n-1, ...))
end

return times
