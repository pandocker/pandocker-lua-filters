--[[
# tex-underline.lua

Finds underline class span and convert it to \underline{}
]]

--local debug = require("pandocker.utils").debug

if FORMAT == "latex" then
    function Span(el)
        if el.classes[1] == "underline" then
            table.insert(el.content, 1, pandoc.RawInline("latex", "\\underline{"))
            table.insert(el.content, pandoc.RawInline("latex", "}"))
        end
        return el
    end
    return { { Span = Span } }
end
