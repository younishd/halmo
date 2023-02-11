--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local Scene = class("Scene")

function Scene:initialize(ui)
    self.position = {
        x = 0,
        y = 0
    }
    self.ui = ui
end

function Scene:draw()
end

return Scene
