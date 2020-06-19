--[[
# UnnumberedHeadings

## Function

Converts level 1~5 headers in 'unnumbered' class to unnumbered headers

* Works with docx output only
* Level 6 and lower level headers are remain untouched
* "Heading Unnumbered x" must be prepared in template or inherits default style

| Level | Numbered  | Unnumbered            |
|-------------------------------------------|
| 1     | Heading 1 | Heading Unnumbered 1  |
| 2     | Heading 2 | Heading Unnumbered 2  |
| 3     | Heading 3 | Heading Unnumbered 3  |
| 4     | Heading 4 | Heading Unnumbered 4  |
| 5     | Heading 5 | Heading Unnumbered 5  |
| 6+    | Heading 6 |                       |
]]

local debug = require("pandocker.utils").debug

local META_KEY = "heading-unnumbered"
local CLASS_KEY = "unnumbered"

local default_meta = require("pandocker.default_loader")[META_KEY]
assert(default_meta)

local meta = {}
local APPLY_DEFAULT = "[ lua ] metadata '%s' was not found in source, applying default %s."
local TOO_DEEP_LEVEL = "[ lua ] unnumbered heading greater than level %d is found and ignored"
local MAX_HEADING_LEVEL = 5

if FORMAT == "docx" then
    local function get_vars (mt)
        meta = mt[META_KEY]
        if meta ~= nil then
            for k, v in pairs(default_meta) do
                if meta[k] == nil then
                    meta[k] = v
                    local d = pandoc.utils.stringify(mt[META_KEY][k])
                    debug(string.format(APPLY_DEFAULT, META_KEY .. "." .. k, d))
                end
            end
        else
            meta = default_meta
            debug(string.format(APPLY_DEFAULT, META_KEY, ""))
            --debug("metadata 'heading-unnumbered' was not found in source, applying defaults.")
        end
    end

    local function replace(el)
        if el.classes:includes(CLASS_KEY) then
            if el.level <= MAX_HEADING_LEVEL then
                local style = pandoc.utils.stringify(meta[tostring(el.level)])
                el.attributes["custom-style"] = style
                local content = pandoc.Para(el.content)
                local attr = pandoc.Attr(el.identifier, el.classes, el.attributes)

                --debug(pandoc.utils.stringify(content))
                --debug(pandoc.utils.stringify(div))
                return pandoc.Div(content, attr)
            else
                debug(string.format(TOO_DEEP_LEVEL, MAX_HEADING_LEVEL))
            end
        end
        --debug(el.level .. tostring(el.classes[1]))
    end

    return { { Meta = get_vars }, { Header = replace } }
end
