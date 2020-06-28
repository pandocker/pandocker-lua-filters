--[[
# AppendixHeadings

## Function

Applies level 1~5 headers in 'appendix' class to use dedicated headers

* Works with docx output only
* Level 6 and lower level headers are remain untouched
* "Appendix Heading x" must be prepared in template or inherits default style

| Level | Numbered  | Appendix              |
|-------------------------------------------|
| 1     | Heading 1 | Appendix Heading 1    |
| 2     | Heading 2 | Appendix Heading 2    |
| 3     | Heading 3 | Appendix Heading 3    |
| 4     | Heading 4 | Appendix Heading 4    |
| 5     | Heading 5 | Appendix Heading 5    |
| 6+    | Heading 6 |                       |
]]

local debug = require("pandocker.utils").debug

local META_KEY = "heading-appendix"
local CLASS_KEY = "appendix"

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
