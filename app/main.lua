--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

package.path                = require 'path'
version                     = require 'version'
class                       = require 'middleclass.middleclass'
_table                      = require 'helpers.table'
table.print                 = _table.print
table.explode               = _table.explode
table.contains              = _table.contains
table.append                = _table.append
log                         = require 'helpers.log'
map                         = require 'helpers.map'
partial                     = require 'helpers.partial'
times                       = require 'helpers.times'

Game                        = require 'Game'
Engine                      = require 'Engine'
Board                       = require 'Board'
Player                      = require 'Player'
