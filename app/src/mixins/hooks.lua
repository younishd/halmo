--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
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

function hooks.register_hooks(self, event, callback)
    assert(self.hooks[event])
    table.append(self.hooks[event], callback)
end

function hooks.notify_hooks(self, event, ...)
    assert(self.hooks[event])
    for _, callback in pairs(self.hooks[event]) do
        callback(...)
    end
end

return hooks
