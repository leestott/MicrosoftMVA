-- Create menu scene-- 
module(..., package.seeall)

menuScene = director:createScene()

physics:pause()

-- Set background image
local background = director:createSprite({
		x = 0,
		y = director.displayCenterY,
		source = "textures/background.jpg"
	})

-- Set background positioning
background.xAnchor = 0.5
background.yAnchor = 0.5
local bg_width, bg_height = background:getAtlas():getTextureSize()
background.xScale = gameData.graphicssWidth / bg_width
background.yScale = gameData.graphicsHeight / bg_height

-- We use this to control the positions of the gameLogo and the startButton 
local anchorNode = director:createNode({
		x = gameData.graphicssWidth  / 2,
		y = 0
	})

-- Set game logo, use the calculated scale to ensure that the image will be the same size
-- regardless of display resolution
local gameLogo = director:createSprite({
		x = 0,
		y = gameData.graphicsHeight - (gameData.graphicsHeight / 4),
		source  = "textures/gameLogo.png",
		xAnchor = 0.5,
		yAnchor = 0.5,
		xScale  = gameData.graphicsScale,
		yScale  = gameData.graphicsScale
	})

-- Set start button
local startButton = director:createSprite({
		x = 0,
		y = gameData.graphicsHeight / 2,
		source  = "textures/startButton.png",
		xAnchor = 0.5,
		yAnchor = 0.5,
		xScale  = gameData.graphicsScale,
		yScale  = gameData.graphicsScale
	})


anchorNode:addChild(background)
anchorNode:addChild(gameLogo)
anchorNode:addChild(startButton)


-- Handle the start button being pressed
function buttonPressed(event)
	if event.phase ~= "ended" then
		return 
	end 

	--Renable the physics system and transition to the gamescene
	physics:resume()
	switchToScene("gameScene")
end

--A callback which is called every time a key event occurs
function keyPressed(event)
	--Lets check if the key that was pressed is the back button
	if event.keyCode == event.back then
		dbg.print("QUIT!!!...")
	end
end

local update = function(event)
	anchorNode.x = gameData.graphicssWidth / 2
	anchorNode.y = 0 
end

startButton:addEventListener("touch", buttonPressed)
startButton:addEventListener("back", keyPressed)

system:addEventListener("update", update)
