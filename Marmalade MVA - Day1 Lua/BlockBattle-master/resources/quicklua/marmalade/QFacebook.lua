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
-- Facebook singleton
--------------------------------------------------------------------------------
facebook = quick.QFacebook:new()

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

--[[
/*!
*/
]]
function facebook:showDialog(action, params)
    dbg.assertFuncVarType("string", action)
    dbg.assertFuncVarTypes({"table", "nil"}, params)

    -- Initialise the dialog
    if not facebook:_InitDialog(action) then
        return false
    end

    -- Set any parameters we were passed
    if params ~= nil then
        for i,v in pairs(params) do
            if type(v) == "string" then
                facebook:_AddDialogString( i, v)
            elseif type(v) == "number" then
                facebook:_AddDialogNumber( i, v)
            end
        end
    end

    -- do the dialog
    facebook:_ShowDialog()

    return true;

end

--[[
/*!
*/
]]
function facebook:request(methodorgraph, paramsorhttpmethod, params)
    dbg.assertFuncVarType("string", methodorgraph)
    dbg.assertFuncVarTypes({"string", "table"}, paramsorhttpmethod)
    dbg.assertFuncVarTypes({"table", "nil"}, params)

    local retval

    -- Initialise the request
    if type(paramsorhttpmethod) == "string" then
        -- Method call
        retval = facebook:_InitMethodRequest(methodorgraph, paramsorhttpmethod)
    else
        -- Graph call
        retval = facebook:_InitGraphRequest(methodorgraph)
        params = paramsorhttpmethod
    end

    if not retval then
        return false
    end

    -- Set any parameters we were passed
    if params ~= nil then
        for i,v in pairs(params) do
            if type(v) == "string" then
                facebook:_AddRequestString( i, v)
            elseif type(v) == "number" then
                facebook:_AddRequestNumber( i, v)
            end
        end
    end

    -- do the dialog
    facebook:_SendRequest()

    return true
end

--------------------------------------------------------------------------------
-- Private API
--------------------------------------------------------------------------------
