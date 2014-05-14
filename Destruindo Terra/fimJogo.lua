local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

local playBtn,playBtnTentarNovamente,fundoGameOver
local w = display.contentWidth
local h = display.contentHeight

local function menu()
	storyboard.gotoScene("menu", "slideUp", 400)
	return true	
end

local function fases()
	storyboard.gotoScene("fases", "slideUp", 400)
	return true	
end

function scene:createScene( event )
	local group = self.view

	fundoGameOver = display.newImageRect("novasImagens/gameOver.png", display.contentWidth, display.contentHeight)
	fundoGameOver:setReferencePoint( display.TopLeftReferencePoint )
	fundoGameOver.x, fundoGameOver.y = 0,0

	playBtn = widget.newButton{
		label="MENU",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/buttonRed.png",
		overFile="imagens/buttonRedOver.png",
		width=154, height=50,
		onRelease = menu	
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight *0.7

	playBtnTentarNovamente = widget.newButton{
		label="LEVELS",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/buttonOver.png",
		width=154, height=50,
		onRelease = fases
	}
	playBtnTentarNovamente:setReferencePoint( display.CenterReferencePoint )
	playBtnTentarNovamente.x = display.contentWidth*0.5
	playBtnTentarNovamente.y = display.contentHeight *0.85

	group:insert(fundoGameOver)
	group:insert( playBtn )
	group:insert( playBtnTentarNovamente )
	
	return true	-- indica toque bem sucedida

end

function scene:enterScene( event )
	local group = self.view
	storyboard.purgeScene("savingEggs1")
end

function scene:exitScene( event )
	local group = self.view

end

function scene:destroyScene( event )
	local group = self.view
end

-----------------------------------------------------------------------------------------
-- FIM DA SUA IMPLEMENTA��O
-----------------------------------------------------------------------------------------

-- evento "createScene" � despachado se a vis�o de cena n�o existe
scene:addEventListener( "createScene", scene )

-- evento "enterScene" � despachado sempre que transi��o de cena terminou
scene:addEventListener( "enterScene", scene )

-- evento "exitScene" � despachado sempre que antes da transi��o da cena seguinte come�a
scene:addEventListener( "exitScene", scene )

-- Evento "destroyScene" � despachado antes vista � descarregado, o que pode ser
-- Descarregadas automaticamente em situa��es de pouca mem�ria, ou explicitamente, atrav�s de uma chamada para
-- Storyboard.purgeScene () ou storyboard.removeScene ().
scene:addEventListener( "destroyScene", scene )

return scene


