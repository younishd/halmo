--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
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
function love.textinput(t) game:textinput(t) end
function love.keypressed(key) game:keypressed(key) end
function love.mousepressed(x, y, button) game:mousepressed(x, y, button) end
function love.mousereleased(x, y, button) game:mousereleased(x, y, button) end
function love.quit() return game:quit() end
