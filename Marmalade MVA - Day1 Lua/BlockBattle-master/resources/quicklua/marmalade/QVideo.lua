--[[/*
 * (C) 2012-2013 Marmalade.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */--]]

quick.QVideo:registerLuaFunctions()

video = {}

--[[
/**
Plays in loop a video from a file.
@param filename the path of the vidoe file to play
@param OPTIONAL: x the top left corner x display coordinate (default value = 0). 
@param OPTIONAL: y the top left corner y display coordinate (default value = 0). 
@param OPTIONAL: width the width at which play the video. If width or height is 0 (or non specified) the system will pick the current window width.
@param OPTIONAL: height the height at which play the video. If width or height is 0 (or non specified) the system will pick the current window width.
@return true on success, false otherwise
*/
--]]
function video:playVideoLoop(fileName, x, y, width, height)
    dbg.assertFuncVarType("string", fileName)
    dbg.assertFuncVarTypes({"number", nil}, x)
    dbg.assertFuncVarTypes({"number", nil}, y)
    dbg.assertFuncVarTypes({"number", nil}, width)
    dbg.assertFuncVarTypes({"number", nil}, height)

	x = x or 0
	y = y or 0
	width = width or 0
	height = height or 0
	return video:playVideo(fileName, 0, x, y, width, height)
end

--[[
/**
Plays once a video from a file.
@param filename the path of the vidoe file to play
@param OPTIONAL: x the top left corner x display coordinate (default value = 0). 
@param OPTIONAL: y the top left corner y display coordinate (default value = 0). 
@param OPTIONAL: width the width at which play the video. If width or height is 0 (or non specified) the system will pick the current window width.
@param OPTIONAL: height the height at which play the video. If width or height is 0 (or non specified) the system will pick the current window width.
@return true on success, false otherwise
*/
--]]
function video:playVideoOnce(fileName, x, y, width, height)
    dbg.assertFuncVarType("string", fileName)
    dbg.assertFuncVarTypes({"number", nil}, x)
    dbg.assertFuncVarTypes({"number", nil}, y)
    dbg.assertFuncVarTypes({"number", nil}, width)
    dbg.assertFuncVarTypes({"number", nil}, height)

	x = x or 0
	y = y or 0
	width = width or 0
	height = height or 0
	return video:playVideo(fileName, 1, x, y, width, height)
end

--[[
/**
Plays a video from a file.
@param filename the path of the vidoe file to play
@param OPTIONAL: repeatCount 0 = loop, 1= once, any other n is the number of time it will be repeated.
@param OPTIONAL: x the top left corner x display coordinate. 
@param OPTIONAL: y the top left corner y display coordinate. 
@param OPTIONAL: width the width at which play the video. If width or height is 0 the system will pick the current window width.
@param OPTIONAL: height the height at which play the video. If width or height is 0 the system will pick the current window width.
@return true on success, false otherwise
*/
--]]
function video:playVideo(fileName, repeatCount, x, y, width, height)
    dbg.assertFuncVarType("string", fileName)
    dbg.assertFuncVarTypes({"number", "nil"}, repeatCount)
    dbg.assertFuncVarTypes({"number", "nil"}, x)
    dbg.assertFuncVarTypes({"number", "nil"}, y)
    dbg.assertFuncVarTypes({"number", "nil"}, width)
    dbg.assertFuncVarTypes({"number", "nil"}, height)

	return quick.QVideo:playVideo(fileName, repeatCount, x, y, width, height)
end

--[[
/**
Checks if a video is currently being played.
@return true if the video is playing, false otherwise.
*/
--]]
function video:isVideoPlaying()
	return quick.QVideo:isVideoPlaying()
end

--[[
/**
Pauses the current video. 
@return true on success, false otherwise.
*/
--]]
function video:pauseVideo()
	return quick.QVideo:pauseVideo()
end

--[[
/**
Resumes the current video. 
@return true on success, false otherwise.
*/
--]]
function video:resumeVideo()
	return quick.QVideo:resumeVideo()
end

--[[
/**
Stops the current video.
*/
--]]
function video:stopVideo()
	quick.QVideo:stopVideo()
end

--[[
/**
Increases the volume of the current video by few units.
The value is clamped between the maximum and the minimum.
@return true on success, false otherwise.
*/
--]]
function video:volumeUp()
	return quick.QVideo:volumeUp()
end

--[[
/**
Increases the volume of the current video by few units.
The value is clamped between the maximum and the minimum.
@return true on success, false otherwise.
*/
--]]
function video:volumeDown()
	return quick.QVideo:volumeDown()
end

--[[
/**
Gets the volume from 0 to 1.
@return the current volume from 0 to 1.
*/
--]]
function video:getVolume()
	return quick.QVideo:getVolume()
end

--[[
/**
Gets the current vidoe position in milliseconds.
@return the current vidoe position in milliseconds or 0 if no video is playing, -1 on error.
*/
--]]
function video:getVideoPosition()
	return quick.QVideo:getVideoPosition()
end

--[[
/**
Gets the video state. Possible values "playing", "stopped", "failed", "paused"
@return the video state. Possible values "playing", "stopped", "failed", "paused"
*/
--]]
function video:getVideoState()
	return quick.QVideo:getVideoState()
end

--[[
/**
Sets the video volume clamping from 0 to 1.
@param the video volume clamping from 0 to 1.
@return true on success, false otherwise.
*/
--]]
function video:setVolume(volume)
    dbg.assertFuncVarType("number", volume)
	return quick.QVideo:setVolume(volume)
end

--[[
/**
Checks if a video codec is supported.
@param a video codec name.
@return true if suported, false otherwise.
*/
--]]
function video:isVideoCodecSupported(codecName)
    dbg.assertFuncVarType("string", codecName)
	return quick.QVideo:isVideoCodecSupported(codecName)
end

--[[
/**
Gets a vector of allowed video codec names.
@return a vector of allowed codec names.
*/
--]]
function video:getSupportedVideoCodecsList()
	return cl_QVideo_getSupportedVideoCodecsList()
end

--[[
/**
Gets a table of allowed video codecs. The keys are the codec names and 
values are true for those which are supported, false otherwise.
@return a table of allowed codec names.
*/
--]]
function video:getSupportedVideoCodecsTable()
	return cl_QVideo_getSupportedVideoCodecsTable()
end
