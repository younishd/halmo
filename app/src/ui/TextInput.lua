--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local TextInput = class("TextInput", Drawable)

function TextInput:initialize(params)
    assert(params and params.text)

    self.id = params.id or params.text
    self.text = params.text
    self.r, self.g, self.b, self.a = params.r, params.g, params.b, params.a
    self.x, self.y = -1, -1
    self.w, self.h = -1, -1
    self.disabled = params.disabled or false
    self.active = false
    self.font = love.graphics.newFont("assets/fonts/Azonix.otf", 24)
end

function TextInput:draw()
end

function TextInput:on_mouse_update(x, y)
end

function TextInput:on_mouse_pressed(x, y, button)
end

function TextInput:on_mouse_released(x, y, button)
end

function TextInput:set_disabled(flag)
    self.disabled = flag
end

return TextInput
