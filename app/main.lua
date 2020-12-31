--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

require 'env'

log.info([[


                         ,,                    ,,  ,,
`7MMF'  `7MMF'         `7MM                    db  db
  MM      MM             MM
  MM      MM   ,6"Yb.    MM  `7MMpMMMb.pMMMb.  ,pW"Wq.
  MMmmmmmmMM  8)   MM    MM    MM    MM    MM 6W'   `Wb
  MM      MM   ,pm9MM    MM    MM    MM    MM 8M     M8
  MM      MM  8M   MM    MM    MM    MM    MM YA.   ,A9
.JMML.  .JMML.`Moo9^Yo..JMML..JMML  JMML  JMML.`Ybmd9'


]])
log.info("version: " .. version)
log.info("by: Younis Bensalah")
log.debug(string.format("LÖVE %d.%d.%d - %s", love.getVersion()))
log.debug(_VERSION)

local game = Game()

function love.load() game:load() end
function love.update(dt) game:update(dt) end
function love.draw() game:draw() end
function love.textinput(t) game:textinput(t) end
function love.keypressed(key) game:keypressed(key) end
function love.mousepressed(x, y, button) game:mousepressed(x, y, button) end
function love.mousereleased(x, y, button) game:mousereleased(x, y, button) end
function love.quit() return game:quit() end
