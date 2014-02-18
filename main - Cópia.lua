display.setStatusBar(display.HiddenStatusBar)

local physics = require('physics')
physics.start()

local background = display.newImage('fundo3.png')

background.x = 220
background.y = 420

local areia = display.newImage('areia.png')

areia.x = 220
areia.y = 640

local cocota = display.newImage('cocota.png')

cocota.x = 100
cocota.y = 480
