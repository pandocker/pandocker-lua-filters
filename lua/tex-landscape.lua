--[[
# tex-landscape.lua

Finds `LANDSCAPE` class Div and inserts LaTeX RawBlock-s
which sets contents of Div in landscape geometry.

## Syntax

```markdown
::: LANDSCAPE :::
# #include "section1.md"
:::::::::::::::::
```
]]

local debug = require("pandocker.utils").debug
local stringify = require("pandoc.utils").stringify
local default_meta = require("pandocker.default_loader")["lgeometry"]
local _meta = {}
local NOT_FOUND = "metadata '%s' was not found in source, applying default %s."
local MESSAGE = "[ lua ] Div in 'LANDSCAPE' class found"
local start_landscape = ""
local stop_landscape = pandoc.RawBlock("latex", "\\end{landscape}\\restoregeometry")

local function dump(tt, mm)
    for ii, vv in ipairs(tt) do
        print(mm .. ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

local function get_vars (meta)
    _meta = meta["lgeometry"]
    if _meta == nil then
        _meta = default_meta
        debug(string.format(NOT_FOUND, "lgeometry", ""))
    end
    start_landscape = pandoc.RawBlock("latex", "\\newgeometry{" .. stringify(_meta) .. "}\\begin{landscape}")
end

function landscape(doc)
    local head = {}
    local tail = { stop_landscape }
    for i, el in ipairs(doc.blocks) do
        --print(i .. " " .. el.tag .. "(" .. stringify(el) .. ")")
        if el.tag == "Div" and el.classes:find("LANDSCAPE") then
            debug(MESSAGE)
            table.move(doc.blocks, 1, i - 1, 1, head) -- head has contents before #include
            table.insert(head, start_landscape)
            --dump(head, "hh")
            --dump(el.content, "ss")
            table.move(doc.blocks, i + 1, #doc.blocks, 2, tail) -- tail has after #include
            --dump(tail, "tt")
            table.move(el.content, 1, #el.content, #head + 1, head) -- concat head and sub.blocks -> head
            table.move(tail, 1, #tail, #head + 1, head) -- concat head and tail
            --dump(head, "    ")
            doc.blocks = head
        end
    end
    --dump(doc.blocks, "    ")
    return doc
end

return { { Meta = get_vars }, { Pandoc = landscape } }
