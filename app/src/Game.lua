--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local Game = class("Game")

function Game:initialize()
    -- TODO: these values are only known later
    local number_players = 3
    local player_pov = 1

    self.state = "main_menu"

    self.main_menu =
        MenuUI(
        {
            {id = "new_game", text = "New Game"},
            {id = "quit", text = "Quit"}
        }
    )

    self.engine = Engine(Board(number_players))
    self.board = BoardUI(self.engine.board, player_pov)

    -- TODO: hard-coded window dimensions
    self.width = 1024
    self.height = 800

    self.positions = {
        board = {x = 0, y = 0},
        main_menu = {x = 0, y = 0}
    }

    -- update ui when board state changes
    self.engine.board:register_hooks("on_update", partial(self.board.update, self.board))

    -- relay moves from ui to engine
    self.board:register_hooks("on_move", partial(self.engine.move, self.engine))
    self.board:register_hooks("on_finish", partial(self.engine.finish, self.engine))

    self.main_menu:register_hooks("on_select", partial(self.menu_selected, self))
end

function Game:load()
    log.info("loading game...")

    love.window.setMode(self.width, self.height)
    love.window.setTitle("Halmö (" .. version .. ")")
end

function Game:update(dt)
    local x, y = love.mouse.getPosition()

    if self.state == "main_menu" then
        self.main_menu:update_mouse(x - self.positions.main_menu.x, y - self.positions.main_menu.y)
    elseif self.state == "in_game" then
        self.board:update_mouse(x - self.positions.board.x, y - self.positions.board.y)
    end
end

function Game:draw()
    if self.state == "main_menu" then
        local canvas = self.main_menu:draw()
        self.positions.main_menu.x = (self.width - canvas:getWidth()) / 2
        self.positions.main_menu.y = (self.height - canvas:getHeight()) / 2
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(canvas, self.positions.main_menu.x, self.positions.main_menu.y)
    elseif self.state == "in_game" then
        local canvas = self.board:draw()
        self.positions.board.x = (self.width - canvas:getWidth()) / 2
        self.positions.board.y = (self.height - canvas:getHeight()) / 2
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(canvas, self.positions.board.x, self.positions.board.y)
    end
end

function Game:text_input(t)
end

function Game:key_pressed(key)
end

function Game:mouse_pressed(x, y, button)
    if self.state == "main_menu" then
        if button == 1 or button == "l" then
            self.main_menu:mouse_pressed(x - self.positions.main_menu.x, y - self.positions.main_menu.y, 1)
        elseif button == 2 or button == "r" then
            self.main_menu:mouse_pressed(x - self.positions.main_menu.x, y - self.positions.main_menu.y, 2)
        end
    elseif self.state == "in_game" then
        if button == 1 or button == "l" then
            self.board:mouse_pressed(x - self.positions.board.x, y - self.positions.board.y, 1)
        elseif button == 2 or button == "r" then
            self.board:mouse_pressed(x - self.positions.board.x, y - self.positions.board.y, 2)
        end
    end
end

function Game:mouse_released(x, y, button)
    if self.state == "main_menu" then
        if button == 1 or button == "l" then
            self.main_menu:mouse_released(x - self.positions.main_menu.x, y - self.positions.main_menu.y, 1)
        elseif button == 2 or button == "r" then
            self.main_menu:mouse_released(x - self.positions.main_menu.x, y - self.positions.main_menu.y, 2)
        end
    elseif self.state == "in_game" then
        if button == 1 or button == "l" then
            self.board:mouse_released(x - self.positions.board.x, y - self.positions.board.y, 1)
        elseif button == 2 or button == "r" then
            self.board:mouse_released(x - self.positions.board.x, y - self.positions.board.y, 2)
        end
    end
end

function Game:quit()
    log.info("bye!")
    return false
end

function Game:menu_selected(item)
    if item.id == "quit" then
        love.event.quit()
    elseif item.id == "new_game" then
        self.state = "in_game"
    end
end

return Game
