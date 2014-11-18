-- game settings & stats
module(..., package.seeall)

gameWidth = 300

--This calculates the scale value required to make the game scale
--properly on all devices.
calcScreenScales = function ()
	gameData.graphicssWidth = director.displayWidth
	gameData.graphicsHeight = director.displayHeight

	widthScale = graphicssWidth / 480
	heightScale = graphicsHeight / 800

	if heightScale > widthScale then
		gameData.graphicsScale = graphicssWidth / 480	
		gameData.fontScale = graphicssWidth / 360
	else
		gameData.graphicsScale = graphicssWidth / 800	
		gameData.fontScale = graphicssWidth / 720
	end
end

--Checks if the resolution has changed since we last updated it
--this can happen on Windows 8 when the snap view is used or changed.
checkResChange = function ()
	if gameData.graphicssWidth ~= director.displayWidth 
		or gameData.graphicssWidth ~= director.displayWidth then
		
		calcScreenScales()
		-- Recalc screen coordinates!
		return true

	end 

	return false
end

calcScreenScales()
physics:setScale(graphicsScale)

playerScore = 0
restarts = 0

