--[[
# docx-colored-span.lua
]]

local List = require("pandoc").List
local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local MESSAGE = "[ lua ] Colored span found - 0x%s"
local KEY = "color"

local COLORHEAD = "<w:r><w:rPr><w:color w:val=\"%s\"/></w:rPr>`"
local COLORFOOT = "</w:r>"

--[[
`<w:r><w:rPr><w:color w:val="0000FF"/></w:rPr>`{=openxml}
**Span**
`</w:r>`{=openxml}
]]

if FORMAT == "docx" then
    local function replace(el)
        if not List({ nil, "" }):includes(el.attributes[KEY]) then
            -- 'comment' attribute value is not blank nor nil
            local color_name = el.attributes[KEY]
            debug(string.format(MESSAGE, tostring(color_name)))
            local comment_start = pandoc.RawInline("openxml", string.format(COLORHEAD, color_name))
            local comment_end = pandoc.RawInline("openxml", COLORFOOT)
            el.attributes[KEY] = nil

            return pandoc.Span({ comment_start, el, comment_end })
        end
    end
    return { { Span = replace } }
end
