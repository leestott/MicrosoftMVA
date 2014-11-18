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
Global object for GPS location services.
After starting the service add a listener to the system event named "location"
that is triggered when the location data change.
*/
--]]
location = {}

--[[
    /**
    Starts the location service. 
    @return true on success, false otherwise.
    */
--]]
function location:start()	
	if(quick.QLocation:start()) then
		system:addEventListener("update",location)
		return true
	end
	return false
end

--[[
    /**
    Stops the location service.
    */
--]]
function location:stop()
	system:removeEventListener("update",location)
	return quick.QLocation:stop()
end

--[[
    /**
    If the service has started this method is called on every update by the system.
	It queries the location values and if any change is detected the corresponding following event
	is triggered:
	triggeredEvent 
	{
		event.name = "location"
		event.altitude = number
		event.horizontal_accuracy = number
		event.latitude = number
		event.longitude = number
		event.timestamp_utc = string
		event.vertical_accuracy = number
	}
	@param event the system update event
    */
--]]
function location:update(event)
	quick.QLocation:update()
end

--[[
    /**
    Gets a description of the type of the started location service.
    @return the description of the type of the started location service on success, or error description on failure.
    */
--]]
function location:getLocationType()
	return quick.QLocation:getLocationType()
end

--[[
    /**
    Calls s3e querying for service started integer property.
    @return true if the service is started, false otherwise.
    */
--]]
function location:hasStarted()
	return quick.QLocation:hasStarted()
end

--[[
    /**
    Calls s3e and gets the location reading available property.
    @return true if a location reading is available, false otherwise.
    */
--]]
function location:isReadingAvailable()
	return quick.QLocation:isReadingAvailable()
end
