----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local Scene = class("Scene")

Scene:include(mixins.hooks)

function Scene:initialize(h, w)
    assert(h)
    assert(w)
    self.height, self.width = h, w
    self.objects = {}
end

function Scene:on_enter()
end

function Scene:on_leave()
    self.objects = {}
end

function Scene:add(object, x, y, transform)
    assert(object:isInstanceOf(Drawable))
    transform = transform or function(ox, oy, oh, ow, sh, sw)
            return ox, oy
        end
    assert(type(transform) == "function")

    table.append(self.objects, {object = object, x = x, y = y, h = 0, w = 0, transform = transform})

    return object
end

function Scene:draw()
    for _, o in ipairs(self.objects) do
        local canvas = o.object:draw()
        o.h, o.w = canvas:getHeight(), canvas:getWidth()
        local ox, oy = o.transform(o.x, o.y, o.h, o.w, self.height, self.width)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(canvas, ox, oy)
    end
end

function Scene:update(dt)
end

function Scene:on_mouse_update(x, y)
    for _, o in ipairs(self.objects) do
        local ox, oy = o.transform(o.x, o.y, o.h, o.w, self.height, self.width)
        o.object:on_mouse_update(x - ox, y - oy)
    end
end

function Scene:on_mouse_pressed(x, y, button)
    for _, o in ipairs(self.objects) do
        local ox, oy = o.transform(o.x, o.y, o.h, o.w, self.height, self.width)
        o.object:on_mouse_pressed(x - ox, y - oy, button)
    end
end

function Scene:on_mouse_released(x, y, button)
    for _, o in ipairs(self.objects) do
        local ox, oy = o.transform(o.x, o.y, o.h, o.w, self.height, self.width)
        o.object:on_mouse_released(x - ox, y - oy, button)
    end
end

function Scene:on_text_input(t)
    for _, o in ipairs(self.objects) do
        o.object:on_text_input(t)
    end
end

function Scene:on_key_pressed(key)
    for _, o in ipairs(self.objects) do
        o.object:on_key_pressed(key)
    end
end

function Scene.center(ox, oy, oh, ow, sh, sw)
    return math.floor((sw - ow) / 2), math.floor((sh - oh) / 2)
end

function Scene.center_h(ox, oy, oh, ow, sh, sw)
    return ox, math.floor((sh - oh) / 2)
end

function Scene.center_v(ox, oy, oh, ow, sh, sw)
    return math.floor((sw - ow) / 2), oy
end

function Scene.bottom_right(ox, oy, oh, ow, sh, sw)
    return sw - ow - ox, sh - oh - oy
end

function Scene.bottom_left(ox, oy, oh, ow, sh, sw)
    return ox, sh - oh - oy
end

function Scene.top_right(ox, oy, oh, ow, sh, sw)
    return sw - ow - ox, oy
end

function Scene.top_left(ox, oy, oh, ow, sh, sw)
    return ox, oy
end

return Scene
