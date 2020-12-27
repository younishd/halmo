--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local Game = class('Game')

function Game:initialize()
    self.width = 1024
    self.height = 800
end

function Game:load()
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

    love.window.setMode(self.width, self.height)
    love.window.setTitle("Halmö (" .. version .. ")")
end

function Game:update(dt)
    local x, y = love.mouse.getPosition()
end

function Game:draw()
end

function Game:textinput(t)
end

function Game:keypressed(key)
end

function Game:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button)
end

function Game:conf(t)
    -- anti-aliasing
    t.window.fsaa = 4
end

function Game:quit()
    log.info("Bye.")
    return false
end

function Game:callback_move(from, to)
    self.engine:move(from, to)
end

function Game:callback_finish()
    self.engine:finish()
end

return Game
