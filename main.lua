display.setStatusBar(display.HiddenStatusBar)

local largura = display.contentWidth -- obtem a largura da tela do dispositivo
local altura = display.contentHeight -- obtem a altura da tela do dispositivo


W = display.contentWidth  -- Pega a largura da tela
H = display.contentHeight -- Pega a altura da tela

local physics = require('physics')
physics.start()

local background = display.newImage('fundo3.png')

background.x = 220
background.y = 420


-- Cria um circulo passando como parâmetro a posição inicial X e Y, e o raio do circulo
local vBola = display.newCircle( 90, 500, 30 ) -- display.newCircle( X, Y, RAIO )

local cocota = display.newImage('cocota.png')

cocota.x = 100
cocota.y = 480


-- cria a areia
controle = 550
local linha
local x = 2

while controle <= altura  do
	while x  <= altura  do
		linha = display.newRect(0, 0, x, 2)
		linha:setFillColor(0.64 , 0.16 , 0.16)	
		linha.x = x
		linha.y = controle
		controle = controle + 1
		physics.addBody( linha , "static" )
	end
	x = x + 2
end



 -- Cria um corpo fisico para o circulo, do tipo dinâmico
 -- Os outros parâmetros são a "elasticidade" e o raio do circulo,
 -- ainda podem ser passados outros parâmetros como, density, friction, etc
physics.addBody( vBola, "dynamic", { bounce=0.8, radius=30 } )

function printTimeSinceStart( event )

linha.x = event.x
linha.y = event.y
linha:setFillColor(0 , 0 , 0.16)
physics.addBody( linha , "dynamic" )


end 


Runtime:addEventListener( "touch", printTimeSinceStart )