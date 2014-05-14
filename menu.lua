local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
scene.name = "menu"
local widget = require "widget"
local somJogo = audio.loadSound("somJogo.wav")
numeroFase = 1
scoreFase = 0
local function creditos()
	storyboard.gotoScene( "creditos", "crossFade", 500 )
	return true	
end

local function fases()
	storyboard.gotoScene( "fases", "crossFade", 500 )
	return true	
end

function scene:createScene( event )

	audio.play( somJogo )
	local group = self.view
	local background = display.newImageRect( "novasImagens/capa.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	font = "Ravie"
	
	local gradient = graphics.newGradient(  {  0, 128, 0 }, {  0, 128, 0 }, "down" )
	local backBtn = display.newText(  "> Levels", 0, 0, font, 25 )
	backBtn:setTextColor( gradient)
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.51
	backBtn.y = display.contentHeight*0.86
	backBtn:addEventListener("tap", fases)

	gradient = graphics.newGradient( { 138, 43, 226}, {  0, 0, 255 }, "down" )
	local creditsBtn = display.newText(  "> Credits", 0, 0, font, 20 )
	creditsBtn:setTextColor(gradient )
	creditsBtn:setReferencePoint( display.CenterReferencePoint )
	creditsBtn.x = display.contentWidth*0.5
	creditsBtn.y = display.contentHeight*0.92
	creditsBtn:addEventListener("tap", creditos)
	
	group:insert( background )
	group:insert( creditsBtn )
	group:insert( backBtn )

end

function scene:enterScene( event )
	storyboard.purgeScene("fimJogo")
	local group = self.view
end

function scene:exitScene( event )
	audio.pause( somJogo )
	local group = self.view
end

function scene:destroyScene( event )
	local group = self.view
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
