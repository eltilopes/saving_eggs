local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local banco = require("banco")

local physics = require("physics")
--physics.setDrawMode("hybrid")
physics.start()
physics.setGravity( 0, 9.8 )
display.setStatusBar(display.HiddenStatusBar)

local physicsPedra = (require "fisicaPedra").physicsData(1.0)
local physicsNinho = (require "fisicaNinho").physicsData(1.0)
local physicsOvo = (require "fisicaOvo").physicsData(1.0)


function scene:createScene( event )
	--print("Estou createScene upGravit")
	local cenaFase1 = self.view

				
					
		local M = {}  
		local physics = require("physics")

		-- Private Variables to this Lib, with good method coding the user never should see this stuff

		M.x = nil
		M.y = nil
		M.w = nil
		M.h = nil
		--M.terraGrid = {}
		M.terraLookup = {}
		M.displayGroup = display.newGroup ( )
		M.displayGroupFG = display.newGroup ( )
		M.dynamicMask = display.newGroup();
		M.carveMask = display.newGroup();
		M.alphaRect = nil
		M.removeQueue = {}
		M.debug = false
		M.bounce = .5
		M.friction = 0.02
		M.density = .5
		M.pxH = 2
		M.pxW = 2
		M.boundRect = nil
		M.maskCarve = false
		M.BGdrawCarve = true
		M.graphics = nil



		-- functions are now local:
		local function newTerrain(x,y,width,height,pxW,pxH,img )
		    print( "init New Terrain" )
		    if M.debug then physics.setDrawMode( "hybrid" ) end
		    M.x = x
			M.y = y
		    M.w = width
		    M.h = height
		    M.pxH = pxH
			M.pxW = pxW
		    M.dynamicMask:toBack();
		    M.alphaRect =  display.newRect( M.displayGroupFG, M.x,M.y, M.w * M.pxW, M.h * M.pxH ) 
			M.alphaRect:setFillColor(255,255,255)
		    M.dynamicMask:insert(M.alphaRect);	
			M.boundRect =  display.newRect( M.displayGroupFG, M.x,M.y, M.w * M.pxW, M.h * M.pxH ) 
			--local g = graphics.newGradient({ 64,28,28 },{ 2, 2, 2 },"down" )
			--M.boundRect:setFillColor(g)
			M.boundRect:setFillColor(192, 128, 0)
			M.boundRect:addEventListener ( "touch", M.terrainBoundTouch )
			M.radius =  (((M.pxW+M.pxH)/2)/2) 
		    if img ~= "rect" then M.graphics = img  end
			
		    local count = 1
		    local object
		    for w = 1, M.w do
			--M.terraGrid[w]= {}
			for h = 1, M.h do
				
					--M.terraGrid[w][h] = display.newRect( M.displayGroup, (w-1)*pxW+x, (h-1)*pxH+y, pxW, pxH )  --Create a Rect for Terrain, this should be an image eventualy
					if M.debug then display.newText(  count,  (w-1)*pxW+x, (h-1)*pxH+y,nil,45) end
					--M.terraGrid[w][h]:addEventListener ( "touch", M.terrainTouch )
					--M.terraGrid[w][h]:setFillColor ( math.random(0,255), math.random(0,255), math.random(0,255),0  )
					--M.terraGrid[w][h] = {}
					--M.terraGrid[w][h].name = count
					M.terraLookup[count] =  {}
					M.terraLookup[count]["w"] = w
					M.terraLookup[count]["h"] = h
					M.terraLookup[count]["state"] = "dirt"
					M.terraLookup[count]["grid"] = M.gridLookup(count)
					if M.terraLookup[count]["state"] == "edge" then 	
						object = nil

						object = display.newRect( M.displayGroup, (w-1)*pxW+x, (h-1)*pxH+y,  pxW, pxH  )
						object:setFillColor(244, 164, 96)
						physics.addBody ( object,  "static",{density=M.density, friction=M.friction, bounce=M.bounce,radius = M.radius } )
						
						M.terraLookup[count]["object"]   =  object
					end
				
				count = count + 1
			end
		    end
		    
		end
		-- assign a reference to the above local function
		M.newTerrain = newTerrain

		--[[
		local terrainTouch = function(event)
		    if M.debug then print( "Touched it",event.phase ,event.target.name) end
		    --M.removeBlock(event.target)
		    M.removeQueue[event.target] = event.target
		    --remove the object touched here
		end
		M.terrainTouch = terrainTouch
		]]

		local terrainBoundTouch = function(event)
		 local a = event.x
		 local b = event.y

		 local w = 5
		 local x = event.x - w
		 local y = event.y - w

		 for x = x , a+w do
			 for y = y , b+w do
				 if M.debug then print( "Touched it",event.phase ,x,y	) end
				    --M.removeQueue[event.target] = event.target
				    --remove the object touched here
					local id = M.coord2grid(x,y)
					M.removeQueue[id] = id
					
					if M.maskCarve then
						if  M.terraLookup[id]["state"] ~= "hole" then
							M.updateMask(id) 
						end
					end
					if M.BGdrawCarve then
						if  M.terraLookup[id]["state"] ~= "hole" then
							M.updateCarveBG(id)
						end
					end
				    
				end
				y = y +1
			end
			x = x+1
		end
		M.terrainBoundTouch = terrainBoundTouch


		local updateMask = function(id)  --update our mask image
			local newCarve = display.newRect( M.dynamicMask, (M.terraLookup[id]["w"]-1)*M.pxW+M.x, (M.terraLookup[id]["h"]-1)*M.pxH+M.y, M.pxW, M.pxH )
			newCarve:setFillColor(0,0,0)
			display.save (M.dynamicMask, "tmp.jpg",  system.DocumentsDirectory)
			local mask = graphics.newMask( "tmp.jpg", system.DocumentsDirectory )
			M.boundRect:setMask(nil)
			M.boundRect:setMask(mask)
		    M.boundRect.maskX = .0001
		    M.boundRect.maskY = .0001       
			
		end	
		M.updateMask = updateMask


		local updateCarveBG = function(id)  --update our mask image
			if M.graphics then
				local newCarve = display.newImage(M.graphics.hole)
				newCarve:setReferencePoint( display.TopLeftReferencePoint )
				newCarve.x = (M.terraLookup[id]["w"]-1)*M.pxW+M.x
				newCarve.y = (M.terraLookup[id]["h"]-1)*M.pxH+M.y
				M.carveMask:insert(newCarve)
			else
				local newCarve = display.newRect( M.carveMask, (M.terraLookup[id]["w"]-1)*M.pxW+M.x, (M.terraLookup[id]["h"]-1)*M.pxH+M.y, M.pxW, M.pxH )
				newCarve:setFillColor(0,0,0)       
			end 
		end

		M.updateCarveBG = updateCarveBG



		local removeBlock = function(id)
			--if target then
			if M.debug then print("removing",id) end
			if M.terraLookup[id]["state"] == "edge" then
				physics.removeBody(M.terraLookup[id]["object"] ) 	 	--remove our physics objects
			end
			display.remove(M.terraLookup[id]["object"])					-- remove display objects
			M.terraLookup[id]["state"] = "hole"
			--M.displayGroup:remove(target)
			--target = nil 									-- remove the display object from memory now
			--end
		end
		M.removeBlock = removeBlock



		local enterFrameProcess = function()
			--print(#M.removeQueue)
			for k,v in pairs(M.removeQueue) do
					if M.terraLookup[k]["state"] == "dirt" then
					M.gridTestbyID(k)	
					M.removeBlock(k)

					elseif M.terraLookup[k]["state"] == "edge" then
					M.gridTestbyID(k)
					M.removeBlock(k)
					
					
					end
					M.terraLookup[k]["state"] = "hole"
										 
					
					--			
			end
			M.removeQueue = {}


		end
		M.enterFrameProcess = enterFrameProcess

		--[[
		local gridTest = function(target)  		-- OLD
			-- for loop of the array in side here: M.terraLookup[target.name]
			for k,v in pairs(M.terraLookup[target.name]["grid"]) do
				if M.terraLookup[v]["state"] == "dirt" then
					M.terraLookup[v]["object"] = display.newRect( M.displayGroup, (w-1)*M.pxW+x, (h-1)*M.pxH+y, M.pxW, M.pxH )
					M.terraLookup[v]["object"]:setFillColor(128,128,128)
					M.terraLookup[v]["state"] = "edge"
					physics.addBody ( M.terraLookup[v]["object"],  "static",{density=.5, friction=0.02, bounce=.5 ,radius = ((M.pxW+M.pxH)/2)/2  } )
				end
			end

		end
		M.gridTest = gridTest
		]]

		local gridTestbyID = function(id)  		-- OLD
			-- for loop of the array in side here: M.terraLookup[target.name]
			for k,v in pairs(M.terraLookup[id]["grid"]) do
				if v ~= id then
				if M.terraLookup[v]["state"] == "dirt" then
					if M.graphics then
						M.terraLookup[v]["object"] = display.newRect( M.displayGroup, (M.terraLookup[v]["w"]-1)*M.pxW+M.x,
							(M.terraLookup[v]["h"]-1)*M.pxH+M.y,  5,5 )
						M.terraLookup[v]["object"]:setFillColor(244, 164, 96)	
						M.displayGroup:insert(M.terraLookup[v]["object"])					
					else
					
					
					M.terraLookup[v]["object"] = display.newRect( M.displayGroup, ((M.terraLookup[v]["w"]-1)*M.pxW)+M.x, (M.terraLookup[v]["h"]-1)*M.pxH+M.y, M.pxW, M.pxH )
					M.terraLookup[v]["object"]:setFillColor(128,128,128)
					end
					M.terraLookup[v]["state"] = "edge"
					
			
				
					
					physics.addBody ( M.terraLookup[v]["object"],  "static",{density=.5, friction=0.02, bounce=.5 ,radius =M.radius  } )
				end
				end

			end

		end
		M.gridTestbyID = gridTestbyID



		local coord2grid  = function(x,y)
			w = math.ceil(((x-M.x) / (M.w * M.pxW)) *M.w)
			h = math.ceil(((y-M.y) / (M.h * M.pxH)) *M.h)
			id = ((w-1)*M.h)+h
			if M.debug then print("coord2grid w,h,id",w,h,id) end
			return id
		end
		M.coord2grid = coord2grid

		local gridLookup = function(id)
		-- Look up the 8 squares around us top row, middle row, bottom row
		-- 1,2,3
		-- 4,x,6
		-- 7,8,9
			local id2 = nil
			local id1 = nil
			local id3 = nil
			local id4 = nil
			local id5 = id
			local id6 = nil
			 local id7 = nil
			 local id8 = nil
			 local id9 = nil
				
		if (id%M.h)-1 == 0 then   	--we are the top edge
			 id2 = nil
			 id1 = nil
			 id3 = nil
			 M.terraLookup[id]["state"] = "edge"
		else  									--not the top edge store values
			 id2 = id-1
			 id1 = id2-M.h
			 id3 = id2+M.h
		end

		if (id%M.h) == 0 then   	--we are the bottom edge
			 id7 = nil
			 id8 = nil
			 id9 = nil
			 M.terraLookup[id]["state"] = "edge"
		else  									--not the top edge store values
			id8 = id+1
			id7 = id8-M.h
			id9 = id8+M.h
		end


		if id-M.h < 1 then 	-- left edge
			 id4 = nil  --center left and fix edge
			 id1 = nil
			 id7 = nil
			 M.terraLookup[id]["state"] = "edge"
			else
			 id4 = id-M.h 			--just set center left
		end


		if id+M.h > M.h*M.w then  -- right edge
				id3 = nil
				id6 = nil
				id9 = nil
				M.terraLookup[id]["state"] = "edge"
			else
				id6 = id+M.h
			
		end

		return {id1,id2,id3,id4,id5,id6,id7,id8,id9}

		end
		M.gridLookup = gridLookup

	local background = display.newImage("novasImagens/fundoNuven.png")
	local squishSound = audio.loadSound("squish_wav.wav")
	movingObjects = display.newGroup ( )
	local score = 500
	local  textScore
	local wx = display.contentWidth
	local h = display.contentHeight
	local movieclip = require("movieclip")
	M.debug = false
	M.bounce = .8
	M.carve = false
	M.BGdrawCarve = true
	local graphics = { hole="imagens/buraco.png",edge="imagens/borda.png",dirt="imagens/sujeira.png"}
	M.newTerrain(0,100,71,87,5,5,graphics)  -- our 'mid' res  with Graphics

		
	local function atualizaScore()
		if score>0 and score<301 then
			textScore:setTextColor(255, 0, 0)
		end
		if score>-10 and score<10 then
		   storyboard.gotoScene( "fimJogo", "crossFade", 600 )
		end
	    textScore.text = score.." pts"
	end

	local function decrementaPonto()
	    score = score - 10 -- Incremento de 1seg do contador
	    atualizaScore()
	end

	timer1 = timer.performWithDelay( 1000, decrementaPonto, -1 )

	local function fimJogo()
	    storyboard.gotoScene( "fimJogo", "crossFade", 600 )
	    return true
	end

	local function passouFase()
	    storyboard.purgeScene( "scene" )
	    scene: destroyScene ()
	    storyboard.gotoScene( "passarFase", "crossFade", 600 )
	    return true
	end

	function novoOvo(x,y)
		ovo = movieclip.newAnim{ "novasImagens/ovo.png", "imagens/quebrado.png"  }
		ovo.x = x; ovo.y = y; ovo.id = "ovo"; ovo.myName = "ovo"
		movingObjects:insert(ovo)
		--physics.addBody( ovo, { density=1.0, friction=0.1, bounce=0.5, radius=15 } )
		physics.addBody( ovo, physicsOvo:get("ovo") )


		-- Adicionando colisao ao ovo

		function startListening()
				
			if ovo.postCollision then
				return
			end

			local function onOvoCollision ( self, event )

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
			
			-- Set table listeners in each Ovo to check for collisions
			ovo.postCollision = onOvoCollision
			ovo:addEventListener( "postCollision", ovo )
			

		end
		------------------------------------------------------------

		function caiuNoNinho()
				
			if ovo.postCollision then
				return
			end

			local function onOvoCollision ( self, event )
				score=score+50
				banco.atualiza(score)
				atualizaScore()
				scoreFase = score
				passouFase()
			end
			
			ovo.postCollision = onOvoCollision
			ovo:addEventListener( "postCollision", ovo )
			

		end
		------------------------------------------------------------
	end

	function novaPedra(x,y)

		pedra = display.newImage( "novasImagens/pedra.png" )
		pedra.x = x; pedra.y = y; pedra.id = "pedra"; pedra.myName="pedra"
		movingObjects:insert(pedra)

		--physics.addBody( pedra,'static', { density=15.0, friction=0.5, bounce=0.2, radius=36 } )
		physics.addBody( pedra, "static", physicsPedra:get("pedra") )

		--Adicionando colisao  pedra

		local function onBounce ( self, event )
			startListening()
		end

		pedra.collision = onBounce
		pedra:addEventListener( "collision", pedra )
	end

	function novoNinho(x,y)

		ninho = display.newImage( "novasImagens/ninho.png" )
		ninho.x = x; ninho.y = y; ninho.id = "ninho"; ninho.myName = "ninho"
		movingObjects:insert(ninho)

		--physics.addBody( ninho,'static', { density=15.0, friction=0.5, bounce=0.7, radius=20 } )
		physics.addBody( ninho, "static", physicsNinho:get("ninho") )
		--Adicionando colisao  pedra

		local function onBounce ( self, event )
			caiuNoNinho()
		end

		ninho.collision = onBounce
		ninho:addEventListener( "collision", ninho )
	end
	cenaFase1:insert(M.dynamicMask)
	cenaFase1:insert( background )
	cenaFase1:insert( M.displayGroupFG )
	--cenaFase1:insert(M.dynamicMask)
	cenaFase1:insert(M.carveMask)
	cenaFase1:insert( movingObjects )
	cenaFase1:insert( M.displayGroup )
	
	textScore = display.newText("Score: "..score, wx*0.01,h*0.01, "Ravie", 12)
	textScore:setTextColor(218, 165, 32)
	cenaFase1:insert( textScore )

	novoOvo(100,10)
	novaPedra(100,300)
	novoNinho(300,450)

	Runtime:addEventListener ("enterFrame",M.enterFrameProcess)		--this event processes our terrain each frame

end

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view	
	timer.cancel( timer1 ); timer1 = nil;
end

function scene:destroyScene( event )
	local group = self.view
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene

