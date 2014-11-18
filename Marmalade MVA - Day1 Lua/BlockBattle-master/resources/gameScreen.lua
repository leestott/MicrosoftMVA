-- Create Game Scene --

require("class")
require("gameObj")
require("grid")

-- Seed the random function once with the current system time 
math.randomseed(os.time())

gameScene = director:createScene()

-- Globals
paused = true

-- Locals
local touchDown = false
local touchX = 0
local touchY = 0
local shouldFire = true
local shouldRebuild = false
local expiredPhysicsObjs = {}
local hitPlayer = false
local speedMulti = 1.0
local numRestarts = 0


local background = director:createSprite({
	x = director.displayCenterX,
	y = director.displayCenterY,
	source = "textures/blockBattleBG.jpg"
	})



-- Set background positioning and scale
background.xAnchor = 0.5
background.yAnchor = 0.5
local bg_width, bg_height = background:getAtlas():getTextureSize()
background.xScale = gameData.graphicssWidth / bg_width
background.yScale = gameData.graphicsHeight / bg_height

---MAIN GAME STUFF

-- Set background image
local background = director:createSprite({
	x = director.displayCenterX,
	y = director.displayCenterY,
	source = "textures/blockBattleBG.jpg"
	})

-- Set background positioning and scale
background.xAnchor = 0.5
background.yAnchor = 0.5
local bg_width, bg_height = background:getAtlas():getTextureSize()
background.xScale = gameData.graphicssWidth / bg_width
background.yScale = gameData.graphicsHeight / bg_height

-- Text is scaled to be the same size on screen regardless of resolution
-- by using the fontScale variable set in gameData.lua
local scoreLabel = director:createLabel( {
	x = 0, y = gameData.graphicsHeight - gameData.graphicsHeight/15, 
	hAlignment="centre",
	textXScale = gameData.fontScale,
	textYScale = gameData.fontScale,
	text=("SCORE: "..gameData.playerScore)
})

-- Short instruction to be shown at the start of the game
local tutLabel = director:createLabel( {
	x = 0, y = gameData.graphicsHeight / 2, 
	hAlignment="centre",  
	textXScale = gameData.fontScale,
	textYScale = gameData.fontScale,
	text="Bounce the bullets back! Save the Earth!"
})

-- Called when the player's sprite triggers a collision event
function playerCollision(event)
	if event.phase == "began" then
		local bouncer, rhs
		hit = false
    
    -- Figure out which node was which, making sure that the object 
    -- that the player collided with was actually the projectile
		if event.nodeA == gameGrid.bouncer.sprite then
			bouncer = event.nodeA
			rhs = event.nodeB
			hit = true
		elseif event.nodeB == gameGrid.bouncer.sprite then
			bouncer = event.nodeB
			rhs = event.nodeA
			hit = true
		end

    -- reverse the projectile direction if the collision was between 
    -- the player and the bouncer, with the bouncer being above
    -- the bottom of the player sprite
		if hit and hitPlayer ~= true and bouncer.y > rhs.y then
			bouncer.vy = -bouncer.vy
			hitPlayer = true
		end

	end
end

-- Similar to above, but called by enemies' collision events
function enemyCollision(event)
	if gameGrid.bouncer == nil then return end
	if hitPlayer ~= true then return end
  
  	--This happens at the start of a collision
	if event.phase == "began" then
		local bouncer, enemy
		hit = false
		if event.nodeA == gameGrid.bouncer.sprite then
			bouncer = event.nodeA
			enemy = event.nodeB
			hit = true
		elseif event.nodeB == gameGrid.bouncer.sprite then
			bouncer = event.nodeB
			enemy = event.nodeA
			hit = true
		end

    -- The projectile hit an enemy after hitting the player! 
    -- Destroy the projectile and enemy, removing the reference to it from the grid
		if hit then
      gameData.playerScore = gameData.playerScore + 100
      scoreLabel.text = ("SCORE: "..gameData.playerScore)
      
			-- as physics objects can't be deleted in callback functions, we flag for deletion in the next update cycle
			table.insert(expiredPhysicsObjs, event.nodeA)
			table.insert(expiredPhysicsObjs, event.nodeB)

			bouncer:removeFromParent()
			bouncer = nil
			
      -- Ensure the grid space is set to nil
			gameGrid:removeEnemy(enemy.enemyGridX, enemy.enemyGridY)
      enemy:removeFromParent()
			enemy = nil
      
      -- Have all the enemies been destroyed? Respawn the grid if true
      if(gameGrid.numDestroyed >= gameGrid.numTall * gameGrid.numWide) then
        shouldRebuild = true        
			end
      
      hitPlayer = false
      shouldFire = true      
		end
	end
end

-- Initialise the player obj and add the player collision function as a listener
playerObj = gameObj.new(director.displayCenterX, gameData.graphicsHeight / 5, "textures/player.png")
playerObj.sprite:addEventListener("collision", playerCollision)

-- Spawn the first grid of enemies, passing the enemy collision function
-- to use upon each spawned enemy (see grid.lua)
gameGrid = grid.new(4, enemyCollision)

gameRootNode = director:createNode({
	x = gameData.graphicssWidth  / 2,
	y = 0
})
gameRootNode:addChild (scoreLabel)
gameRootNode:addChild (tutLabel)



---PAUSE MENU STUFF

--We use this to position, enable and diable all of the scene nodes
--used for the pause screen
local pauseNode = director:createNode({
		x = 0,
		y = 0, 
	})


-- Set background image
local pause_background = director:createSprite({
	x = director.displayCenterX,
	y = director.displayCenterY, 
	source = "textures/background.jpg",

	zOrder = 10,

	xAnchor = 0.5,
	yAnchor = 0.5,
	})

local bg_width, bg_height = pause_background:getAtlas():getTextureSize()
pause_background.xScale = director.displayWidth / bg_width
pause_background.yScale = director.displayHeight / bg_height

local pause_label = director:createLabel( {
	x = director.displayCenterX ,
	y = director.displayCenterY, 

	zOrder = 11,

	hAlignment="centre",
	textXScale = gameData.fontScale * 2 ,
	textYScale = gameData.fontScale * 2,

	color = {0, 0, 0},

	text=("Tap to continue")
})

--This method will toggle the visibilty of the pause screen and will
--enable and disable the physics system as needed.
local toggle_pause = function ()
	if isPaused then
		isPaused = false
		physics:resume()
	else 
		isPaused = true
		physics:pause()
	end
end

--Callback called when the pause button is tapped
local on_unpause = function(event)
	if event.phase ~= "ended" then
		return 
	end 

	toggle_pause()
end

--When the back button has been pressed toggle the pause menu
function keyPressed(event, listener)
	if event.phase ~= "released" then
		return
	end

	if event.keyCode == event.back or event.keyCode == event.back then
	toggle_pause()
  end
end

pause_background:addEventListener("touch", on_unpause)
pause_background:addEventListener("key", keyPressed)

pauseNode:addChild(pause_background)
pauseNode:addChild(pause_label)

isPaused = false
pauseNode.isVisible = false
pause_background.isTouchable = false

-- Called once per frame by an system update event listener
local update = function(event)

	--Keep the level and labels centered in the window - BRUTE FORCE!!
	gameGrid:recalc()
	gameRootNode.x = gameData.graphicssWidth  / 2

	background.x = director.displayCenterX
	background.y = director.displayCenterY
	background.xScale = gameData.graphicssWidth / bg_width
	background.yScale = gameData.graphicsHeight / bg_height

	--Keep fontscale up to date
	gameData.fontScale =  director.displayWidth / 360

	scoreLabel.textXScale = gameData.fontScale / 2
	scoreLabel.textYScale = gameData.fontScale / 2 

	tutLabel.textXScale = gameData.fontScale / 2
	tutLabel.textYScale = gameData.fontScale / 2

	if isPaused then
		pauseNode.isVisible = true
		pause_background.isTouchable = true
		return 0
	end 

	pauseNode.isVisible = false
	pause_background.isTouchable = false

  -- A new restart has been registered, rebuild!
  -- We could use the number of restarts as a form of credit if we wanted
  if(gameData.restarts > numRestarts) then
    --reset the game
    dbg.print("Restarting...")
    numRestarts = gameData.restarts
    gameData.playerScore = 0
    speedMulti = 1
    scoreLabel.text = ("SCORE: "..gameData.playerScore)
    shouldRebuild = false
    tutLabel.text = "Bounce the bullets back! Save the Earth!"
    gameGrid:destroy()
    shouldRebuild = true
    shouldFire = true
    paused = false
  end
  
  -- Has touch listener function shown that a touch is active? 
  -- If so, move the player towards the latest touch event
	if(touchDown) then
		paused = false
		playerObj:moveTowards(touchX, touchY, true, false)
	end

  -- The game can be registered as paused, meaning that the code below
  -- won't run when a separate scene is active
	if(paused) then return end

  -- Projectile movement & behaviours
	if(gameGrid.bouncer ~= nil) then
    
    -- Update the sprite position using deltaTime to give framerate independent movement
		gameGrid.bouncer.sprite.y = gameGrid.bouncer.sprite.y + gameGrid.bouncer.sprite.vy * system.deltaTime

		--shot off top of screen...shouldn't happen!
		if(gameGrid.bouncer.sprite.y > gameData.graphicsHeight - gameGrid.bouncer.sprite.h) then
			table.insert(expiredPhysicsObjs, gameGrid.bouncer.sprite)
			gameGrid.bouncer = nil
			hitPlayer = false
			shouldFire = true
		end
    
    --...bottom of screen - trigger game over
    if(gameGrid.bouncer.sprite.y < 0) then
       paused = true
			 physics:pause()
       dbg.print("Moving to game over")
       director:moveToScene(gameOverScene)
		end
	end

  -- Check if the enemy grid should be remade
  if(shouldRebuild) then
    dbg.print("rebuilding")
    gameGrid:rebuild(enemyCollision)
    shouldRebuild = false    
   
  -- A projectile can't be created during a collision, so has to be done here
  elseif(shouldFire) then
    shouldFire = false
		gameGrid:fire(speedMulti)
		gameGrid.bouncer.sprite:addEventListener("collision", playerCollision)
		gameGrid.bouncer.sprite:addEventListener("collision", enemyCollision)		
    
    -- Make the projectiles get progressively faster (within reason)
		if(speedMulti < 3.2) then
			speedMulti = speedMulti * 1.1
		end
	end

	-- Remove nodes which have been flagged for deletion
  -- Again, can't be done during the collision so has to be done here
	for i = 1, #expiredPhysicsObjs do
		if(expiredPhysicsObjs[i] ~= nil) then
			physics:removeNode(expiredPhysicsObjs[i])
			expiredPhysicsObjs[i] = nil
		end
	end  
	expiredPhysicsObjs = {}
end
system:addEventListener("update", update)


-- Function which records the latest touch event's 
-- details, logging if a touch is still active
local touchListener = function(event)
	if isPaused then
		return 0
	end 

  if( director:getCurrentScene() == gameScene) then
    if(event.phase == "ended") then
      touchDown = false
    else
      if(event.phase == "began") then
        tutLabel.text = ""
        touchDown 	= true
      end
      touchX 	= event.x
      touchY 	= event.y
    end
  end
end
system:addEventListener("touch", touchListener)

