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

local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local default_meta = require("pandocker.default_loader")["lgeometry"]
assert(default_meta ~= nil)

local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."
local MESSAGE = "[ lua ] Div in 'LANDSCAPE' class found"

local meta = {}
local start_landscape = ""
local stop_landscape = pandoc.RawBlock("latex", "\\end{landscape}\\restoregeometry")

local function dump(tt, mm)
    for ii, vv in ipairs(tt) do
        print(mm .. ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

local function get_vars (mt)
    meta = mt["lgeometry"]
    if meta == nil then
        meta = default_meta
        debug(string.format(NOT_FOUND, "lgeometry", ""))
    end
    start_landscape = pandoc.RawBlock("latex", "\\newgeometry{" .. stringify(meta) .. "}\\begin{landscape}")
end

local function landscape(el)
    if el.classes:find("LANDSCAPE") then
        debug(MESSAGE)
        if FORMAT == "latex" then
            table.insert(el.content, 1, start_landscape)
            table.insert(el.content, stop_landscape)
        end
        return el.content
    end
end

return { { Meta = get_vars }, { Div = landscape } }
