display.setStatusBar( display.HiddenStatusBar )
local storyboard = require "storyboard"
local banco = require("banco")

banco.criarBd()

storyboard.gotoScene("menu")

