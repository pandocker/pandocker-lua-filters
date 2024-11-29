--[[
# docx-colored-span.lua

Highlights a span in specified foreground and background colors.
Foreground is specified by RRGGBB style hex value; Background is chosen from color name list.
It won't change text content regardless of colors.

## Syntax

<!--Colored text (0xABABAB), transparent background-->
[Highlighted text 1]{.highlight foreground="ABABAB"}

<!--Text color unchanged, light gray background-->
[Highlighted text 2]{.highlight background="lightgray"}

<!--Colored text (0x7F7F7f), dark gray background-->
[Highlighted text 3]{.highlight foreground="ABABAB" background="darkgray"}

]]

local List = require("pandoc").List
local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local MESSAGE = "[ lua ] Colored span found"
local KEY = "highlight"

local COLORHEAD = pandoc.RawInline("openxml", "<w:r><w:rPr>")
local COLORMID = pandoc.RawInline("openxml", "</w:rPr>")
local COLORFOOT = pandoc.RawInline("openxml", "</w:r>")
local FG_KEY = "foreground"
local FG_TAG = "<w:color w:val=\"%s\"/>"
local FG_MESSAGE = "[ lua ] `- Foreground color - 0x%s"
local BG_KEY = "background"
local BG_TAG = "<w:highlight w:val=\"%s\"/>"
local BG_MESSAGE = "[ lua ] `- Background color - %s"

local BG_TABLE = List({
    default = 'default',
    black = 'black',
    blue = 'blue',
    cyan = 'cyan',
    green = 'green',
    magenta = 'magenta',
    red = 'red',
    white = 'white',
    yellow = 'yellow',

    lightgray = 'lightgray',

    darkblue = 'darkBlue',
    darkcyan = 'darkCyan',
    darkgray = 'darkGray',
    darkgreen = 'darkGreen',
    darkmagenta = 'darkMagenta',
    darkred = 'darkRed',
    darkyellow = 'darkYellow',
})

--[[
`<w:r><w:rPr><w:color w:val="0000FF"/></w:rPr>`{=openxml}
**Span**
`</w:r>`{=openxml}
]]

if FORMAT == "docx" or FORMAT == "native" then
    local function replace(el)
        if el.classes:includes(KEY) then
            local foreground = pandoc.Span({})
            local background = pandoc.Span({})
            local fg_name = ""
            local bg_name = "default"

            debug(MESSAGE)

            if el.attributes[FG_KEY] ~= nil then
                -- 'foreground' attribute value is not blank nor nil
                fg_name = el.attributes[FG_KEY]
                if string.match(fg_name, "^[0-9a-fA-F].....$") ~= nil then
                    debug(string.format(FG_MESSAGE, fg_name))
                    foreground = pandoc.RawInline("openxml", string.format(FG_TAG, fg_name))
                end
                el.attributes[FG_KEY] = nil
            end

            if el.attributes[BG_KEY] ~= nil then
                -- 'background' attribute value is not blank nor nil
                bg_name = el.attributes[BG_KEY]
                if BG_TABLE[string.lower(bg_name)] ~= nil then
                    debug(string.format(BG_MESSAGE, BG_TABLE[bg_name]))
                    background = pandoc.RawInline("openxml", string.format(BG_TAG, BG_TABLE[bg_name]))
                else
                    debug(string.format("[ Lua ] `- Background color %s is not found", bg_name))
                end
                el.attributes[BG_KEY] = nil
            end

            return pandoc.Span({ COLORHEAD, foreground, background, COLORMID, el, COLORFOOT })
        end
    end
    return { { Span = replace } }
end
