-- chamada de requisição para uma nova cena
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local font = "Ravie"

-- efeito de transição da cena
local function buttonHit(event)
	storyboard.gotoScene (  event.target.destination, {effect = "slideUp"} )
	return true
end


-- criação da cena
function scene:createScene( event )
	local group = self.view

	local background = display.newImageRect( "novasImagens/creditos.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	group:insert( background )
		
	local title = display.newText( "by Elton Lopes", 0, 0, font, 20 )
	local gradient = graphics.newGradient( { 0, 0, 255 }, { 200, 200, 200 }, "down" )
	title:setTextColor(gradient)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth*0.5
	title.y = display.contentHeight*0.3
	group:insert( title )	

	title = display.newText( "I thank", 0, 0, font, 20 )
	title:setTextColor(gradient)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth*0.5
	title.y = display.contentHeight*0.4
	group:insert( title )

	title = display.newText( "the teacher,", 0, 0, font, 20 )
	title:setTextColor(gradient)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth*0.5
	title.y = display.contentHeight*0.45
	group:insert( title )

	title = display.newText( "my fiancee", 0, 0, font, 20 )
	title:setTextColor(gradient)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth*0.5
	title.y = display.contentHeight*0.5
	group:insert( title )

	title = display.newText( "and the class!", 0, 0, font, 20 )
	title:setTextColor(gradient)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth*0.5
	title.y = display.contentHeight*0.55
	group:insert( title )

	local backBtn = display.newText(  "< Back", 0, 0, font, 25 )
	backBtn:setTextColor( {0.8, 0.8, 0.8} )
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.5
	backBtn.y = display.contentHeight*0.7
	backBtn.destination = "menu" 
	backBtn:addEventListener("tap", buttonHit)
	group:insert( backBtn )

end

function scene:enterScene( event )
	local group = self.view
	storyboard.purgeScene("menu")
end

function scene:exitScene( event )
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