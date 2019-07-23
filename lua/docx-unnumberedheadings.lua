--[[
# UnnumberedHeadings

## Function

Converts level 1~4 headers in 'unnumbered' class to unnumbered headers

* Works with docx output only
* Level 5 and lower level headers are remain untouched
* "Heading Unnumbered x" must be prepared in template or inherits default style

| Level | Numbered  | Unnumbered            |
|-------------------------------------------|
| 1     | Heading 1 | Heading Unnumbered 1  |
| 2     | Heading 2 | Heading Unnumbered 2  |
| 3     | Heading 3 | Heading Unnumbered 3  |
| 4     | Heading 4 | Heading Unnumbered 4  |
| 5+    |           | Heading 5             |
]]

local debug = require("pandocker.utils").debug

local default_meta = require("pandocker.default_loader")["heading-unnumbered"]
assert(default_meta)

local meta = {}
local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."

if FORMAT == "docx" then
    local function get_vars (mt)
        meta = mt["heading-unnumbered"]
        if meta ~= nil then
            for k, v in pairs(default_meta) do
                if meta[k] == nil then
                    meta[k] = v
                    local d = pandoc.utils.stringify(mt["heading-unnumbered"][k])
                    debug(string.format(NOT_FOUND, "heading-unnumbered." .. k, d))
                end
            end
        else
            meta = default_meta
            debug(string.format(NOT_FOUND, "heading-unnumbered", ""))
            --debug("metadata 'heading-unnumbered' was not found in source, applying defaults.")
        end
    end

    local function replace(el)
        if FORMAT == "docx" and el.level <= 4 and el.classes:includes "unnumbered" then
            local style = pandoc.utils.stringify(meta[tostring(el.level)])
            el.attributes["custom-style"] = style
            local content = pandoc.Para(el.content)
            local attr = pandoc.Attr(el.identifier, el.classes, el.attributes)

            --debug(pandoc.utils.stringify(content))
            --debug(pandoc.utils.stringify(div))
            return pandoc.Div(content, attr)
        end
        --debug(el.level .. tostring(el.classes[1]))
    end

    return { { Meta = get_vars }, { Header = replace } }
end
