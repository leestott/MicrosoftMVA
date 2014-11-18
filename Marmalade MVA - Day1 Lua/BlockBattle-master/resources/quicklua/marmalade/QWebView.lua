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
-- Public API
--------------------------------------------------------------------------------
QWebView = {}
QWebView.__index = QWebView

QWebView.serialize = function(o)
	local obj = serializeTLMT(getmetatable(o), o)
	return obj
end

function QWebView:initWebView(n)
	local np
	np = {}
	setmetatable(np, QWebView)
	tolua.setpeer(n, np)

    local mt = getmetatable(n) 
    mt.__serialize = QWebView.serialize
end

function nui:createWebView(values)
    dbg.assertFuncVarTypes({"table", "string"}, values)
    local n = quick.QWebView()
    QWebView:initWebView(n)

    if (type(values) == "table") then
		values.x = values.x or 0
		values.y = values.y or 0
		values.w = values.w or director.displayWidth
		values.h = values.h or director.displayHeight
		values.transparentBackground = values.transparentBackground or false
 
		n:init(values.x, values.y, values.w, values.h, values.transparentBackground)
		if (values.url ~= nil) then
			n.url = values.url
		end
    else
        -- Create full screen web view with url
        dbg.assertFuncVarTypes({"string"}, values)
        n:initWithUrl(values)
    end

    -- Store this WebView in the NUI singleton's WebView list
    table.insert(self._webViewList, n)

    return n
end

--------------------------------------------------------------------------------
-- Private API
--------------------------------------------------------------------------------
function nui:removeWebView(n)
    for i,v in ipairs(self._webViewList) do
        if v == n then
            table.remove(self._webViewList, i)
            break
        end
    end
end

function QWebView:destroy()
    -- Remove from NUI singleton list
    nui:removeWebView(self)

    -- Destroy C++ object, which calls s3eWebViewDestroy()
    dbg.print("Deleting QWebView")
    quick.QWebView.delete()
end
