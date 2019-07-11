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

local function landscape(el)
    if el.classes:find("LANDSCAPE") then
        debug(MESSAGE)
        table.insert(el.content, 1, start_landscape)
        table.insert(el.content, stop_landscape)
        return el.content
    end
end

return { { Meta = get_vars }, { Div = landscape } }
