--[[
UnnumberedHeadings

* Only for docx output

Converts level 1~4 headers in 'unnumbered' class to unnumbered headers
* works with docx output only
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

package.searchpath("pandocker", package.path)

local debug = require("pandocker.debugger").debug
local metafile = [[
---
heading-unnumbered:
  1: Heading Unnumbered 1
  2: Heading Unnumbered 2
  3: Heading Unnumbered 3
  4: Heading Unnumbered 4
---
]]
local default_meta = pandoc.read(metafile, "markdown").meta["heading-unnumbered"]

local vars = {}

function get_vars (meta)
    local _meta = meta["heading-unnumbered"]
    for k, v in pairs(default_meta) do
        if _meta[k] == nil then
            _meta[k] = v
            debug(pandoc.utils.stringify(meta["heading-unnumbered"][k]))
        end
    end
end

--[[
function replace (el)
    if vars[el.text] then
        return pandoc.Span(vars[el.text])
    else
        return el
    end
end
]]

return { { Meta = get_vars }, { Str = replace } }
