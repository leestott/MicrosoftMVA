-- Create Game Object object class --

module(..., package.seeall)
require("class")

--This file offers helper functions for creating objects - reducing boiler plate code around
--the project.

gameObj = inheritsFrom(baseClass)

-- Create a new game object
function new(posX, posY, texture)
	local object = gameObj:create()
	gameObj:init(object, posX, posY, texture)
	return object
end

-- Object 'constructor'
function gameObj:init(object, posX, posY, texture)
	object.sprite = director:createSprite(posX, posY, texture)
  	object.speed = 950 * gameData.graphicsScale
 	object.vx = 0;
 	object.vy = 0;
  physics:addNode(object.sprite, {isSensor=true})
end

--Return the center coordinate of the sprite
function gameObj:getCentrePoint()
	c = { x = self.sprite.x + self.sprite.w/2, y = self.sprite.y + self.sprite.h/2}
	return c
end

--Move the game object towards the target position indirectly by using speed
function gameObj:moveTowards(tX, tY, moveX, moveY)
	dx = 0;
	dy = 0;
	centre = self:getCentrePoint()

	if(moveX == true) then
		if(tX > centre.x + self.sprite.w/2) then
			dx = self.speed * system.deltaTime
			self.vx = self.speed
		elseif(tX < centre.x - self.sprite.w/2) then
			dx = -self.speed * system.deltaTime
			self.vx = -self.speed
		end
	end

	if(moveY == true) then
		if(tY > centre.y + self.sprite.h/2) then
			dy = self.speed * system.deltaTime
			self.vy = self.speed
		elseif(tY < centre.y - self.sprite.h/2) then
			dy = -self.speed * system.deltaTime
			self.vy = self.speed
		end
	end

	self.sprite.x = self.sprite.x + dx;
	self.sprite.y = self.sprite.y + dy;
end