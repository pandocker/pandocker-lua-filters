--[[
# docx-colored-span.lua
]]

local debug = require("pandocker.utils").debug
local MESSAGE = "[ lua ] Colored span found - 0x%s"

local COLORHEAD = [[<w:color w:val="%s" />]]

if FORMAT == "docx" then
    function Span(el)
        if el.classes:find "colored" then

            local color = el.attributes["color"] or "000000"
            debug(string.format(MESSAGE, color))

            table.insert(el.content, pandoc.RawInline("openxml", string.format(COLORHEAD, color)))
            --table.insert(el.content, pandoc.RawInline("openxml", "</w:t></w:r><!--inserted-->"))
        end
        return el
    end
    return { { Span = Span } }
end
