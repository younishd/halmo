--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local hooks = {}

function hooks.init_hooks(self, events)
    assert(type(events) == 'table')
    self.hooks = {}
    for _, e in ipairs(events) do
        self.hooks[e] = {}
    end
end

-- get a call when an event happens
function hooks.register_hooks(self, event, callback)
    assert(self.hooks[event])
    table.append(self.hooks[event], callback)
end

-- notify all who registered for an event
function hooks.notify_hooks(self, event, ...)
    assert(self.hooks[event])
    for _, callback in pairs(self.hooks[event]) do
        callback(...)
    end
end

return hooks
