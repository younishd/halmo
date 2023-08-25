----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local hooks = {}

function hooks.init_events(self, events)
    assert(type(events) == "table")
    self._hooks = {}
    for _, e in ipairs(events) do
        self._hooks[e] = {}
    end
    return self
end

function hooks.clear_events(self)
    self._hooks = {}
end

-- get a call when an event happens
function hooks.on_event(self, event, callback)
    assert(self._hooks and self._hooks[event])
    assert(type(callback) == "function")
    table.append(self._hooks[event], callback)
    return self
end

-- notify all who registered for an event
function hooks.notify(self, event, ...)
    assert(self._hooks and self._hooks[event])
    for _, callback in pairs(self._hooks[event]) do
        callback(...)
    end
    return self
end

return hooks
