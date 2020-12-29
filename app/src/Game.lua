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
    self.engine = Engine(Board())
    self.board = BoardUI(self.engine.board)

    self.board:register_callback('on_move', partial(self.engine.move, self.engine))
    self.board:register_callback('on_finish', partial(self.engine.finish, self.engine))
end

function Game:load()
    log.info("loading game...")
    love.window.setMode(self.width, self.height)
    love.window.setTitle("Halmö (" .. version .. ")")
end

function Game:update(dt)
    local x, y = love.mouse.getPosition()
end

function Game:draw()
    self.board:draw()
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
    log.info("bye!")
    return false
end

return Game