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

--------------------------------------------------------------------------------
-- Device singleton
--------------------------------------------------------------------------------
device = quick.QDevice:new()

-- Languages
device.languages = {}
device.languages[ 0] = "UNKNOWN"          
device.languages[ 1] = "ENGLISH"          
device.languages[ 2] = "FRENCH"           
device.languages[ 3] = "GERMAN"           
device.languages[ 4] = "SPANISH"          
device.languages[ 5] = "ITALIAN"          
device.languages[ 6] = "PORTUGUESE"         
device.languages[ 6] = "DUTCH"              
device.languages[ 7] = "TURKISH"            
device.languages[ 8] = "CROATIAN"           
device.languages[ 9] = "CZECH"              
device.languages[10] = "DANISH"             
device.languages[11] = "FINNISH"            
device.languages[12] = "HUNGARIAN"          
device.languages[13] = "NORWEGIAN"          
device.languages[14] = "POLISH"             
device.languages[15] = "RUSSIAN"            
device.languages[16] = "SERBIAN"            
device.languages[17] = "SLOVAK"             
device.languages[18] = "SLOVENIAN"          
device.languages[20] = "SWEDISH"            
device.languages[21] = "UKRAINIAN"          
device.languages[22] = "GREEK"              
device.languages[23] = "JAPANESE"           
device.languages[24] = "SIMPL_CHINESE"      
device.languages[25] = "TRAD_CHINESE"       
device.languages[26] = "KOREAN"             
device.languages[27] = "ICELANDIC"          
device.languages[28] = "FLEMISH"            
device.languages[29] = "THAI"               
device.languages[30] = "AFRIKAANS"          
device.languages[31] = "ALBANIAN"           
device.languages[32] = "AMHARIC"            
device.languages[33] = "ARABIC"            
device.languages[34] = "ARMENIAN"           
device.languages[35] = "AZERBAIJANI"        
device.languages[36] = "TAGALOG"            
device.languages[37] = "BELARUSSIAN"        
device.languages[38] = "BENGALI"            
device.languages[39] = "BULGARIAN"          
device.languages[40] = "BURMESE"            
device.languages[41] = "CATALAN"            
device.languages[42] = "ESTONIAN"           
device.languages[43] = "FARSI"              
device.languages[44] = "GAELIC"             
device.languages[45] = "GEORGIAN"           
device.languages[46] = "GUJARATI"           
device.languages[47] = "HEBREW"             
device.languages[48] = "HINDI"              
device.languages[49] = "INDONESIAN"         
device.languages[50] = "IRISH"              
device.languages[51] = "KANNADA"            
device.languages[52] = "KAZAKH"             
device.languages[53] = "KHMER"              
device.languages[54] = "LAO"                
device.languages[55] = "LATVIAN"            
device.languages[56] = "LITHUANIAN"         
device.languages[57] = "MACEDONIAN"         
device.languages[58] = "MALAY"              
device.languages[59] = "MALAYALAM"          
device.languages[60] = "MARATHI"            
device.languages[61] = "MOLDOVIAN"          
device.languages[62] = "MONGOLIAN"          
device.languages[63] = "PUNJABI"            
device.languages[64] = "ROMANIAN"           
device.languages[65] = "SINHALESE"          
device.languages[66] = "SOMALI"             
device.languages[67] = "SWAHILI"            
device.languages[68] = "TAJIK"              
device.languages[69] = "TAMIL"              
device.languages[70] = "TELUGU"             
device.languages[71] = "TIBETAN"            
device.languages[72] = "TIGRINYA"           
device.languages[73] = "TURKMEN"           
device.languages[74] = "URDU"               
device.languages[75] = "UZBEK"              
device.languages[76] = "VIETNAMESE"         
device.languages[77] = "WELSH"              
device.languages[78] = "ZULU"               

-- FPUs
device.fpus = {}
device.fpus[0] = "NONE"
device.fpus[1] = "VFP"
device.fpus[2] = "VFPV3"
device.fpus[3] = "NEON"

-- Initialise info table from device values
device:_init()

function device:getInfo(v)
    dbg.assertFuncVarType("string", v)
	dbg.assert(self.info[v], "Unrecognised device info type: " .. v)

    if v == "language" then
        return self.languages[self.info[v]]
    elseif v == "fpu" then
        return self.fpus[self.info[v]]
    elseif v == "mainsPower" then
        return self.info[v] ~= 0
    elseif v == "silentMode" then
        return self.info[v] ~= 0
    else
        return self.info[v]
    end
end


--[[
    /**
    Gets the availability of the vibration for this device.
    @return true if vibra is available, false otherwise.
    */
--]]
function device:isVibrationAvailable()
	return quick.QDevice:isVibrationAvailable()
end
	
--[[
    /**
    Checks if vibration has been enabled.
    @return true if vibra was enabled, false otherwise.
    */
--]]
function device:isVibrationEnabled()
	return quick.QDevice:isVibrationEnabled()
end
	
--[[
    /**
    Enables the vibration.
    @return true on success, false otherwise.
    */
--]]
function device:enableVibration()
	return quick.QDevice:enableVibration()
end

--[[
    /**
    Disables the vibration.
    @return true on success, false otherwise.
    */
--]]
function device:disableVibration()
	return quick.QDevice:disableVibration(th)
end
--[[
    /**
    Gets the vibration threshold
    @return the vibration threshold from 0 to 255 if successful, -1 otherwise.
    */
--]]
function device:getVibrationThreshold()
	return quick.QDevice:getVibrationThreshold(th)
end
	
--[[
    /**
    Sets the vibration threshold
    @param th the vibration threshold from 0 to 255.
    @return true on success, false otherwise.
    */
--]]
function device:setVibrationThreshold(th)
    dbg.assertFuncVarType("number", th)
	return quick.QDevice:setVibrationThreshold(th)
end

--[[
    /**
    Start the device vibration.
    @param level the priority that is checked against the current threshold. Default value = 255
    @param ms the duration of the vibration in ms.
    @return true on success, false otherwise.
    */
--]]
function device:vibrate(ms, level)
    dbg.assertFuncVarType("number", ms)
    dbg.assertFuncVarTypes({"number", nil} , level)

    level = level or 255
	return quick.QDevice:vibrate(ms, level)
end


--[[
    /**
    Stops Vibrating, if the device is currently vibrating. 
    */
--]]
function device:stopVibrate()
	quick.QDevice:stopVibrate()
end
--------------------------------------------------------------------------------
-- Private API
--------------------------------------------------------------------------------
