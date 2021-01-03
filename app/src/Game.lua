--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local Game = class('Game')

function Game:initialize()
    self.engine = Engine(Board())
    self.board = BoardUI(self.engine.board)

    self.width = 1024
    self.height = 800

    self.positions = {
        board = { x=0, y=0 }
    }

    self.engine.board:register_hooks('on_update', partial(self.board.update, self.board))
    self.board:register_hooks('on_move', partial(self.engine.move, self.engine))
    self.board:register_hooks('on_finish', partial(self.engine.finish, self.engine))
end

function Game:load()
    log.info("loading game...")

    love.window.setMode(self.width, self.height)
    love.window.setTitle("Halmö (" .. version .. ")")
end

function Game:update(dt)
    local x, y = love.mouse.getPosition()
    self.board:update_mouse(x - self.positions.board.x, y - self.positions.board.y)
end

function Game:draw()
    local board = self.board:draw()
    self.positions.board.x = (self.width - board:getWidth()) / 2
    self.positions.board.y = (self.height - board:getHeight()) / 2
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(board, self.positions.board.x, self.positions.board.y)
end

function Game:textinput(t)
end

function Game:keypressed(key)
end

function Game:mousepressed(x, y, button)
    if button == 1 or button == 'l' then
        self.board:mousepressed(x - self.positions.board.x, y - self.positions.board.y, 1)
    elseif button == 2 or button == 'r' then
        self.board:mousepressed(x - self.positions.board.x, y - self.positions.board.y, 2)
    end
end

function Game:mousereleased(x, y, button)
    if button == 1 or button == 'l' then
        self.board:mousereleased(x - self.positions.board.x, y - self.positions.board.y, 1)
    elseif button == 2 or button == 'r' then
        self.board:mousereleased(x - self.positions.board.x, y - self.positions.board.y, 2)
    end
end

function Game:quit()
    log.info("bye!")
    return false
end

return Game
