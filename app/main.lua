--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

require 'env'

logo()
log.info("version: " .. version)
log.info("by: Younis Bensalah")
log.debug(platform())

local game = Game()

function love.load() game:load() end
function love.update(dt) game:update(dt) end
function love.draw() game:draw() end
function love.textinput(t) game:text_input(t) end
function love.keypressed(key) game:key_pressed(key) end
function love.mousepressed(x, y, button) game:mouse_pressed(x, y, button) end
function love.mousereleased(x, y, button) game:mouse_released(x, y, button) end
function love.quit() return game:quit() end
