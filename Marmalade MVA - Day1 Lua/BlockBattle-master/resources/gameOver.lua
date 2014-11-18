-- Create game over screen
--module(..., package.seeall)

gameOverScene = director:createScene()


-- Set background image
local background = director:createSprite({
	x = director.displayCenterX,
	y = director.displayCenterY,
	source = "textures/blockBattleBG.jpg"
})

-- Set background positioning
background.xAnchor = 0.5
background.yAnchor = 0.5
background.xScale = gameData.graphicssWidth / 720
background.yScale = gameData.graphicsHeight / 1280


--create game over text
local label = director:createLabel( {
	x = 0,
	y = gameData.graphicsHeight - (gameData.graphicsHeight / 4),
	textXScale = gameData.fontScale,
	textYScale = gameData.fontScale,
	text="GAME OVER"
})

-- score label
local scoreLabel = director:createLabel( {
	x = 0, y = gameData.graphicsHeight - (gameData.graphicsHeight / 3), 
  textXScale = gameData.fontScale,
  textYScale = gameData.fontScale,
	text=("SCORE: "..gameData.playerScore)
})

-- Set restart button
local restartButton = director:createSprite({
	x = gameData.graphicssWidth  / 2,
	y = gameData.graphicsHeight / 2,
	source  = "textures/restartButton.png",
	xAnchor = 0.5,
	yAnchor = 0.5,
  xScale  = gameData.graphicsScale,
  yScale  = gameData.graphicsScale
})

-- Handle the start button being pressed
function restartButtonPressed(event)
    gameData.restarts = gameData.restarts + 1
    physics:resume()
    switchToScene("gameScene")
end
restartButton:addEventListener("touch", restartButtonPressed)

-- Pull the final score only when this scene is active
local update = function(event)	
  gameData.calcScreenScales()

  --More brute forcing of layout
  label.x = director.displayWidth /2
  label.textXScale = gameData.fontScale
  label.textYScale = gameData.fontScale

-- score label
  scoreLabel.x = director.displayWidth /2
  scoreLabel.textXScale = gameData.fontScale
  scoreLabel.textYScale = gameData.fontScale

-- Set restart button
  restartButton.x = director.displayWidth  / 2
  restartButton.xScale  = gameData.graphicsScale
  restartButton.yScale  = gameData.graphicsScale


  if( director:getCurrentScene() == gameOverScene ) then
    scoreLabel.text = ("SCORE: "..gameData.playerScore)
    hasUpdated = true
  end
end

system:addEventListener("update", update)