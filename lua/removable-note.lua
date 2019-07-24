--[[
# removable-note.lua

Finds "rmnote" class Div and removes if metadata "rmnote" is set `true`

## Syntax

```markdown
::: rmnote :::::::::::
- All the contents
- inside this div

is removed when flag is set `true`.
::::::::::::::::::::::
```
]]

local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local default_meta = require("pandocker.default_loader")["rmnote"]
assert(default_meta ~= nil)

local meta = {}
local METADATA_NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."

local function dump(tt, mm)
    for ii, vv in ipairs(tt) do
        print(mm .. ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

local function get_vars (mt)
    meta = mt["rmnote"]
    if meta == nil then
        meta = default_meta
        debug(string.format(METADATA_NOT_FOUND, "rmnote", stringify(default_meta)))
    end
    meta = stringify(meta)
    --debug(tostring(meta == "true"))
end

local function remove(doc)
    for i, el in ipairs(doc.blocks) do
        --print(i .. " " .. el.tag .. "(" .. stringify(el) .. ")")
        if el.tag == "Div" and el.classes:find("rmnote") then
            if meta == "true" then
                --debug("remove")
                debug("[ lua ] Div in 'rmnote' class found and removed")
                table.remove(doc.blocks, i)
            end
        end
    end
    --dump(doc.blocks, "    ")
    return doc
end

return { { Meta = get_vars }, { Pandoc = remove } }
