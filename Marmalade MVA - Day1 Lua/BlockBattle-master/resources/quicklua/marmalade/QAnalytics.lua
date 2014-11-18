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

--[[

/**
 Global unified analytics API that supports the following platforms:
 - Android
 - iOS

 Function descriptions:
 - analytics:isAvailable() - Returns true if analytics is supported by the platform
 - analytics:startSession(apiKey) - Starts a flurry analytics session with the supplied API KEY
 - analytics:logEvent(name, params) - Logs the named event, with optional table of parameters (key, value strings). Returns 
 true if successful or false otherwise
 - analytics:logError(name, message) - Logs the named error with supplied message

 Limitations:
 - Maximum logEvent parameter key length is 255 characters
 - Maximum logEvent parameter value length is 255 characters
 - Maximum logEvent parameters is 100
 
 Example:

 if (analytics:isAvailable()) then
	analytics:startSession("YOUR_API_KEY_GOES_HERE")
	analytics:logEvent("Game Started")
	analytics:logEvent("Game Menu", {option="Option1", data="Selected", time="18:10"})
 else
	dbg.log("Analytics not available")
 end

*/

--]]

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------
analytics = {}

--[[
/**
@brief Checks availability of analytics.

@return True if analytics is available, false otherwise.
*/
--]]
function analytics:isAvailable()
	return quick.QAnalytics:isAvailable()
end

--[[
/**
@brief Initialises a new session.

@param apiKey The applications Flurry API key.
*/
--]]
function analytics:startSession(apiKey)
    dbg.assertFuncVarType("string", apiKey)
	return quick.QAnalytics:startSession(apiKey)
end

--[[
/**
@brief Ends the current session.

*/
--]]
function analytics:endSession()
	return quick.QAnalytics:endSession()
end

--[[
/**
@brief Logs an event.

@param name The name of the event.
@param params A table of key value pairs (must both be strings) that will be logged with the event (optional)
*/
--]]
function analytics:logEvent(name, params)
    dbg.assertFuncVarType("string", name)

	if (params ~= nil) then
	    dbg.assertFuncVarType("table", params)
		quick.QAnalytics:_clearParams()
        for i,v in pairs(params) do
            if type(v) == "string" then
                quick.QAnalytics:_addParam(i, v)
            end
        end
		quick.QAnalytics:logEventParams(name)
	else
		quick.QAnalytics:logEvent(name)
	end
end

--[[
/**
@brief Logs an error.

@param name The name of the error.
@param mmessage An additional error message that will be logged with the error.
*/
--]]
function analytics:logError(name, message)
    dbg.assertFuncVarType("string", name)
    dbg.assertFuncVarType("string", message)

	quick.QAnalytics:logError(name, message)
end


