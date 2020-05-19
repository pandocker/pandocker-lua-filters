--[[
# tex-remove-sout.lua

Removes Strikeout when tex output
]]

local debug = require("pandocker.utils").debug

if FORMAT == "latex" then
    function Strikeout(el)
        debug("[ lua ] strikeout found and removed")
        return el.content
    end
    return { { Strikeout = Strikeout } }
end
