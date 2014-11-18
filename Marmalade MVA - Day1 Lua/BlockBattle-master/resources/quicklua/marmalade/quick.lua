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


if (config.debug.makePrecompiledLua == true and config.debug.useConcatenatedLua == true) then
	quick.startFileConcat("quicklua/marmalade/quick.lua")
end

if ((config.debug.makePrecompiledLua == false and config.debug.useConcatenatedLua == true) == false) then
	-- Load these in the order of any dependencies
	dofile("quicklua/marmalade/QDevice.lua")
	dofile("quicklua/marmalade/QVideo.lua")

	--NOTE: always load QLuasocket.lua before QCrypto.lua
	dofile("quicklua/marmalade/QLuasocket.lua")

	--NOTE: always load QCrypto.lua after QLuasocket.lua
	dofile("quicklua/marmalade/QCrypto.lua")

	--NOTE: always load QNUI.lua before QAds.lua and QWebView.lua
	dofile("quicklua/marmalade/QNUI.lua")

	dofile("quicklua/marmalade/QAds.lua")
	dofile("quicklua/marmalade/QAnalytics.lua")
	dofile("quicklua/marmalade/QBilling.lua")
	dofile("quicklua/marmalade/QBrowser.lua")
	dofile("quicklua/marmalade/QCompass.lua")
	dofile("quicklua/marmalade/QFaceBook.lua")
	dofile("quicklua/marmalade/QLocation.lua")
	dofile("quicklua/marmalade/QWebView.lua")
end

if (config.debug.makePrecompiledLua == true and config.debug.useConcatenatedLua == true) then
	quick.endFileConcat()
end

if (config.debug.useConcatenatedLua == true) then
	-- Load the precompiled concatenated quick file
	dofile("quicklua/marmalade/quick.luac")
end
