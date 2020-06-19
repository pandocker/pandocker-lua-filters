--[[
# tex-remove-sout.lua

Removes Strikeout when tex output
]]

local debug = require("pandocker.utils").debug
local stringify = require("pandoc.utils").stringify

if FORMAT == "latex" then
    function Strikeout(el)
        debug("[ lua ] strikeout span '" .. stringify(el.content) .. "' found and removed")
        return {}
    end
    return { { Strikeout = Strikeout } }
end
