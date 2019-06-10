--[[
# UnnumberedHeadings

## Function
Converts level 1~4 headers in 'unnumbered' class to unnumbered headers

* Works with docx output only
* Level 5 header is unnumbered regardless to the class
* "Heading Unnumbered x" must be prepared in template

| Level | Numbered  | Unnumbered            |
|-------------------------------------------|
| 1     | Heading 1 | Heading Unnumbered 1  |
| 2     | Heading 2 | Heading Unnumbered 2  |
| 3     | Heading 3 | Heading Unnumbered 3  |
| 4     | Heading 4 | Heading Unnumbered 4  |
| 5     |           | Heading 5             |
]]

local debug = require("pandocker.debugger").debug

local default_meta = require("pandocker.default_loader")["heading-unnumbered"]
local _meta = {}

function get_vars (meta)
    if FORMAT == "docx" then
        _meta = meta["heading-unnumbered"]
        if _meta ~= nil then
            for k, v in pairs(default_meta) do
                if _meta[k] == nil then
                    _meta[k] = v
                    debug("metadata 'heading-unnumbered." .. k .. "' was not found in source, applying default '" ..
                            pandoc.utils.stringify(meta["heading-unnumbered"][k]) .. "'.")
                end
            end
        else
            _meta = default_meta
            debug("metadata 'heading-unnumbered' was not found in source, applying defaults.")
        end
    end
end

function replce(el)
    if FORMAT == "docx" and el.level <= 4 and el.classes:find "unnumbered" then
        local style = _meta[tostring(el.level)]
        el.attributes["custom-class"] = style
        local content = pandoc.Para(el.content)
        local attr = pandoc.Attr(el.identifier, el.classes, el.attributes)

        --debug(pandoc.utils.stringify(content))
        --debug(pandoc.utils.stringify(div))
        return pandoc.Div(content, attr)
    end
    --debug(el.level .. tostring(el.classes[1]))
end

return { { Meta = get_vars }, { Header = replce } }
