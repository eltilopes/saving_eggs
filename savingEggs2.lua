
movingObjects = display.newGroup ( )
local background = display.newImage("imagens/fundo_areia.png")
local squishSound = audio.loadSound("squish_wav.wav")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local terra = require("terra")
local movieclip = require("movieclip")
terra.debug = false
local physics = require("physics")
--physics.setDrawMode("hybrid")
physics.start()
physics.setGravity( 0, 9.8 )
display.setStatusBar(display.HiddenStatusBar)
balls = display.newGroup
local function fimJogo()
    storyboard.gotoScene( "fimJogo", "crossFade", 600 )
    return true
end

function criarAgua()

        for r=1, 50 do
                for c=1, 5 do
                        local x, y = 200+1*c+math.random(-3,3), -100-r*1
                        
                        local ball = display.newGroup()
                        ball.history = {}
                        
                        for i=16, 10, -2 do
                                display.newCircle( ball, 0, 0, 5 ):setFillColor(0,255,255)
                                ball.history[#ball.history+1] = {x=-100,y=-100}
                        end
                        
                        ball[1].x, ball[1].y = x, y
                        ball.updateTrail = updateTrail
                        
                        physics.addBody( ball[1], "dynamic", { friction=.3, bounce=.4, density=.4, radius=2 } )
                end
        end
end        

function novoOvo(x,y)
	egg = movieclip.newAnim{ "imagens/ovo.png", "imagens/quebrado.png"  }
	egg.x = x; egg.y = y; egg.id = "egg"
	movingObjects:insert(egg)
	physics.addBody( egg, { density=0.3, friction=0.1, bounce=0.5, radius=15 } )


	-- Adicionando colisao ao ovo

	function startListening()
			
		if egg.postCollision then
			return
		end

		local function onEggCollision ( self, event )

			if ( event.force > 2.0 ) then
				self:stopAtFrame(2)
				audio.play( squishSound )
			end

			if ( event.force > 5.0 ) then	
				audio.play( squishSound )
				audio.play( squishSound )
				audio.play( squishSound )
				self:removeEventListener( "postCollision", self )
				fimJogo()
			end
		end
		
		-- Set table listeners in each egg to check for collisions
		egg.postCollision = onEggCollision
		egg:addEventListener( "postCollision", egg )
		

	end
	------------------------------------------------------------
end

function novaPedra(x,y)

	pedra = display.newImage( "imagens/pedra.png" )
	pedra.x = x; pedra.y = y; pedra.id = "pedra"
	movingObjects:insert(pedra)

	physics.addBody( pedra,'static', { density=15.0, friction=0.5, bounce=0.2, radius=36 } )

	--Adicionando colisao  pedra

	local function onBounce ( self, event )
		startListening()
	end

	pedra.collision = onBounce
	pedra:addEventListener( "collision", pedra )
end

function scene:createScene( event )
	--print("Estou createScene upGravit")
	local cenaFase1 = self.view
	terra.bounce = .8
	terra.carve = false
	terra.BGdrawCarve = true

	local graphics = { hole="imagens/buraco.png",edge="imagens/borda.png",dirt="imagens/sujeira.png"}

	terra.newTerrain(0,100,71,87,5,5,graphics)  -- our 'mid' res  with Graphics
	cenaFase1:insert(terra.dynamicMask)
	cenaFase1:insert( background )
	cenaFase1:insert( terra.displayGroupFG )
	--cenaFase1:insert(terra.dynamicMask)
	cenaFase1:insert(terra.carveMask)
	cenaFase1:insert( movingObjects )
	cenaFase1:insert( terra.displayGroup )
	
	novaPedra(100,300)
	criarAgua()
   	novoOvo(100,10)


-- draw obstacles
function draw(e)
        local blob = display.newCircle( blobs, e.x, e.y, 20 )
        blob:setFillColor(0, 0, 0)
        physics.addBody( blob, "static" )
        return true
end
 
	Runtime:addEventListener ("enterFrame",terra.enterFrameProcess)		--this event processes our terrain each frame

end

function scene:enterScene( event )
	local group = self.view
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

