-- Block Battle Marmalade Quick example project

require("gameData")
require("gameScreen")
require("gameOver")
require("mainMenu")
--require("mobdebug").start()

gameData.restart = false

-- Scene selector - the first passed scene is the last one to be included above (mainMenu, here)
function switchToScene(scene)
	if( scene == "menuScene") then
		dbg.print("Moving to main menu!")
		director:moveToScene(menuScene, {transitionType="crossFade", transitionTime = 0.3})
	elseif( scene == "gameScene") then
		dbg.print("Moving to game screen")
		director:moveToScene(gameScene)
	end
end