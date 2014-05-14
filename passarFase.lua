local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"
local somPassou = audio.loadSound("passou.wav")
audio.play( somPassou )
local playBtn,playBtnTentarNovamente, fundoOk, background
local w = display.contentWidth
local h = display.contentHeight

local function proximaFase()
	storyboard.gotoScene("savingEggs2", "slideUp", 400)
	return true	
end

local function denovo()
	storyboard.gotoScene("savingEggs1", "slideUp", 400)
	return true	
end

function scene:createScene( event )
	
	local group = self.view

	background = display.newImageRect( "novasImagens/ganhou.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0

	local textScore = display.newText(scoreFase.."pts", display.contentWidth*0.2,
	display.contentHeight *0.3, "Ravie", 30)
	textScore:setTextColor(218, 165, 32)
	

	playBtnTentarNovamente = widget.newButton{
		label="RETURN",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/buttonRed.png",
		overFile="imagens/buttonRedOver.png",
		width=100, height=50,
		onRelease = denovo
	}
	playBtnTentarNovamente:setReferencePoint( display.CenterReferencePoint )
	playBtnTentarNovamente.x = display.contentWidth*0.3
	playBtnTentarNovamente.y = display.contentHeight *0.8

	playBtn = widget.newButton{
		label="NEXT",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/buttonOver.png",
		width=100, height=50,
		onRelease = proximaFase	
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.7
	playBtn.y = display.contentHeight *0.8

	group:insert( background )
	group:insert( textScore )
	group:insert( playBtn )
	group:insert( playBtnTentarNovamente )
	
	return true	

end

function scene:enterScene( event )
	local group = self.view
	storyboard.purgeScene("savingEggs1")
end

function scene:exitScene( event )
	local group = self.view
	audio.pause( somPassou )
end

function scene:destroyScene( event )
	local group = self.view
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene


