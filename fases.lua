
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local font = "Ravie"
local banco = require("banco")
levels = {1,2,2,2,2,2}
	
images ={
	{ getFile = "novasImagens/ovinho.png", types = "play"   },
	{ getFile = "novasImagens/cadeado.png", types = "locked"},
	{ getFile = "novasImagens/check.png", types = "done"}
}

local function buttonHit(event)
	storyboard.gotoScene ( event.target.destination, {effect = "slideUp"} )	
	print( event.target.destination)
	return true
end

local function menu(event)
	storyboard.gotoScene ( "menu", {effect = "slideUp"} )	
	return true
end

-- criação da cena para o nivel selecionado
function scene:createScene( event )
	local group = self.view
	
	local background = display.newImageRect( "novasImagens/selectlevel.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	group:insert( background )

	local levelIndex =0
		for i=0,1 do
			for j=1,3 do
				tablePlace =   i*5 + j	
				levelIndex = levelIndex + 1
					local imagesId = levels[levelIndex] 
						levelImg = display.newImageRect (images[imagesId].getFile , 45, 45 )
						levelImg.x = 45 + (j*65)
						levelImg.y  = 195+ (i*75)
						group:insert(levelImg)

						leveltxt = display.newText("Level "..tostring(tablePlace), 0,0, font, 10)
						leveltxt.x = 45 + (j*65)
						leveltxt .y = 230+ (i*75)
						leveltxt:setTextColor (250, 255, 251)
						group:insert (leveltxt)
						
						levelImg.destination = "savingEggs"..tostring(tablePlace)
						
						if images[imagesId].types ~= "locked" then
						levelImg:addEventListener("tap", buttonHit)
						end
 end
	
end	
	        
	local backBtn = display.newImageRect ("novasImagens/setaAzul.gif", 70, 70 )
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.2
	backBtn.y = display.contentHeight*0.9
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
	



