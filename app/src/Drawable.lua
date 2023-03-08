--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local Drawable = class("Drawable")

Drawable:include(mixins.hooks)

function Drawable:initialize()
    assert(false, "class is abstract!")
end

function Drawable:draw()
    assert(false, "class is abstract!")
end

function Drawable:on_mouse_update(x, y)
end

function Drawable:on_mouse_pressed(x, y, button)
end

function Drawable:on_mouse_released(x, y, button)
end

function Drawable:on_text_input(t)
end

function Drawable:on_key_pressed(key)
end

return Drawable
