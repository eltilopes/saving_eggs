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


	function novaEstrela(x,y)
		local estrela = display.newImageRect( "novasImagens/star.png", 60, 60 )
		estrela.x = x; estrela.y = y
		group:insert(estrela)
	end

	background = display.newImageRect( "novasImagens/ganhou.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0


	local gradient = graphics.newGradient( { 255, 255, 0 }, {218, 165, 32 }, "down" )
	--local textScore = display.newText("455 pts", display.contentWidth*0.25,
	local textScore = display.newText(scoreFase.."pts", display.contentWidth*0.25,
	display.contentHeight *0.2, "Ravie", 30)
	textScore:setTextColor(gradient)
	novaEstrela(display.contentWidth*0.5,display.contentHeight*0.2)

	local backBtn = display.newImageRect ("novasImagens/setaVermelha.gif", 70, 70 )
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.3
	backBtn.y = display.contentHeight*0.8
	backBtn:addEventListener("tap", denovo)
	
	playBtn = display.newImageRect ("novasImagens/setaVerde.gif", 70, 70 )
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.7
	playBtn.y = display.contentHeight *0.8
	playBtn:addEventListener("tap", proximaFase)

	group:insert( background )
	group:insert( textScore )
	group:insert( playBtn )
	group:insert( backBtn )
	
	novaEstrela(display.contentWidth*0.3,display.contentHeight*0.13)
	novaEstrela(display.contentWidth*0.47,display.contentHeight*0.1)
	novaEstrela(display.contentWidth*0.64,display.contentHeight*0.13)

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


