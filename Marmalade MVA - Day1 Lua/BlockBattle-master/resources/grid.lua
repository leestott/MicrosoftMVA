-- Create grid of blocks

module(..., package.seeall)
require("class")

grid = inheritsFrom(baseClass)

objWidth = 50 
objHeight = 40

-- Create a new grid
function new(numY, enemyColl)
	local object = grid:create()
	grid:init(object, numY, enemyColl)
	return object
end

--This is used to reposition the grid of enemies when the screen size changes
function grid:recalc ()
  numY = self.numTall
  numX = self.numWide
  for x = 0, numX-1 do
    for y = 0, numY-1 do	
      if(self.blocks[x][y] ~= nil) then
      	self.blocks[x][y].remainder = ((gameData.graphicssWidth / (objWidth * 1.1)) -  (math.floor(gameData.gameWidth / (objWidth * 1.1)))) * (objWidth * 1.1)
        self.blocks[x][y].sprite.x = (x * objWidth) * 1.1 + self.blocks[x][y].remainder/2
      end
    end
  end
end

-- Construct the grid of enemies
function grid:init(object, numY, enemyColl)



	object.gridRootNode = director:createNode({
		x = 0,
		y = 0
	})

	-- how many enemies can fit across the screen?
	numX = math.floor(gameData.gameWidth / (objWidth * 1.1))
	-- how much spare room left on the sides?
	object.remainder = ((gameData.graphicssWidth / (objWidth * 1.1)) -  (math.floor(gameData.gameWidth / (objWidth * 1.1)))) * (objWidth * 1.1)
	
	-- No normal 2D arrays available in lua, so use a table
  -- These variables are useful to know elsewhere in the program, so worth storing as object properties
	object.blocks = {}
	object.numTall = numY
	object.numWide = numX
    object.numDestroyed = 0

  -- Create an enemy for each cell, applying the passed collision event function (in gameScreen.lua)
	for x = 0, numX-1 do
		object.blocks[x] = {}
		for y = 0, numY-1 do
			
			object.blocks[x][y]= gameObj.new((x * objWidth) * 1.1 + object.remainder/2,
                                      gameData.graphicsHeight - ((y+1)*objHeight + gameData.graphicsHeight/12),
                                      "textures/alien.png")
			object.blocks[x][y].sprite:addEventListener("collision", enemyColl)
			object.blocks[x][y].sprite.enemyGridX = x
			object.blocks[x][y].sprite.enemyGridY = y

			object.gridRootNode:addChild (object.blocks[x][y].sprite)
		end
	end
end

-- Loop through the table, removing references on each object and forcing garbage collection
function grid:destroy()
  numY = self.numTall
  numX = self.numWide
  for x = 0, numX-1 do
    for y = 0, numY-1 do	
      if(self.blocks[x][y] ~= nil) then
        physics:removeNode(self.blocks[x][y].sprite)
        self.blocks[x][y].sprite = self.blocks[x][y].sprite:removeFromParent()
        self.blocks[x][y] = nil
      end
    end
     self.blocks[x] = nil
  end
  physics:removeNode(self.bouncer.sprite)
  self.bouncer.sprite = self.bouncer.sprite:removeFromParent()
  self.bouncer = nil
  collectgarbage("collect")
end

-- Similar to the constructor, but using the stats that have already been calculated
function grid:rebuild(enemyColl)
  
  self.numDestroyed = 0
  objWidth = 50
	objHeight = 40
  numY = self.numTall
  numX = self.numWide
  
  for x = 0, numX-1 do
		self.blocks[x] = {}
		for y = 0, numY-1 do			
			self.blocks[x][y]= gameObj.new((x * objWidth) * 1.1 + self.remainder/2,
                                      gameData.graphicsHeight - ((y+1)*objHeight + gameData.graphicsHeight/12),
                                      "textures/alien.png")
			self.blocks[x][y].sprite:addEventListener("collision", enemyColl)
			self.blocks[x][y].sprite.enemyGridX = x
			self.blocks[x][y].sprite.enemyGridY = y
		end
	end  
end

-- Remove a single enemy from the grid
function grid:removeEnemy(givenX, givenY)
  if(self.blocks[givenX][givenY] ~= nil) then	
     self.blocks[givenX][givenY] = nil	
     self.numDestroyed = self.numDestroyed + 1
  end
end

-- Make a random alien fire if it has a clear shot
function grid:fire(multiplier)
  clearToFire = {}
	wide = self.numWide -1
	tall = self.numTall -1

  --The lowest enemy in each column is clear to fire
	for x = 0, wide do
		for y = tall,0,-1 do
			if( self.blocks[x][y] ~= nil) then
				table.insert(clearToFire, self.blocks[x][y])
				break
			end
		end
	end

  -- Choose a random alien to fire from the ones available, using its position when spawning the projectile
  if(clearToFire[1] ~= nil) then
    rand = math.random(#clearToFire)
    self.bouncer = gameObj.new(clearToFire[rand].sprite.x + (clearToFire[rand].sprite.w/2 * gameData.graphicsScale - 15 * gameData.graphicsScale),
                              clearToFire[rand].sprite.y - clearToFire[rand].sprite.h/2 * gameData.graphicsScale,
                              "textures/beam.png" )
                            
    -- Scale the projectile's speed according to the graphic scaler and given speed multiplier (gameScreen.lua)
    self.bouncer.sprite.vy = -180 * gameData.graphicsScale * multiplier
  end
end
