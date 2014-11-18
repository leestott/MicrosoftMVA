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

quick.QCrypto:registerLuaFunctions()

crypto = {}

--[[
    /**
    Compute the message digest and return a base64 encoded string.
    @param data the string containing the data to digest.
    @return the computed digest of data encoded in base64.
    */
--]]
function crypto:digestSha1(msg)
    dbg.assertFuncVarType("string", msg)
	return quick.QCrypto:digestToB64Encoded(quick.QCrypto:getSHA1AlgorithmName(), msg)
end

--[[
Performs base64 encoding.
@param data the data to be encoded.
@return a base64 encoded string.
--]]
function crypto:base64Encode(data)
    dbg.assertFuncVarType("string", data)
	local mime = require("mime")
	return mime.b64(data)
end

--[[
Performs base64 encoding.
@param data the data to be encoded.
@return a base64 encoded string.
--]]
function crypto:base64Decode(data)
    dbg.assertFuncVarType("string", data)
	local mime = require("mime")
	return mime.unb64(data)
end

--[[
Gets the list of supported digest algorithm names.
@return an array containing the list of supported digest algorithm names.
--]]
function crypto:getSupportedAlgorithmNames()
	return cl_QCrypto_getSupportedDigestAlgorithmNames()
end



--TEST functions
--[[
/**
Decodes a base64 input string into a LUA array of decimal numbers.
@param data the string to decode
@return a lua array of decimal numbers 
*/
--]]
function crypto:base64DecodeToNumArray(data)
	if(type(data) ~= "string") then
		dbg.print("error in crypto:base64DecodeToNumArray data must be a string")
		return {}
	end
	return cl_QCrypto_base64Decode_toNumberArray(data)
end

--[[
/**
Decodes a base64 input string into a LUA array of string representing hex values of the decoded array.
@param data the string to decode
@return a lua array of string representing hexadecimal numbers
*/
--]]
function crypto:base64DecodeToStringArray(data)
	if(type(data) ~= "string") then
		dbg.print("error in crypto:base64DecodeToNumArray data must be a string")
		return {}
	end
	return cl_QCrypto_base64Decode_toStringArray(data)
end

--[[
/**
Encode a lua array of numbers representing the values of bytes to a base64 encoded string.
@param data a lua array containing mumbers to be encoded. Each number must represent a byte.
@return a lua base64 encoded string.
*/
--]]
function crypto:tableTobase64Encode(data)
	return cl_QCrypto_base64Encode(data)
end
-- end test functions