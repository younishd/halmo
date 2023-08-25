----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----

local function partial(f, a)
    return function(...)
        return f(a, ...)
    end
end

return partial
