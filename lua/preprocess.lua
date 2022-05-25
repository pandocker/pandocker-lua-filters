--[[
# preprocess.lua

Finds heading starting with `#include` and "filename"
and tries to include contents of filename into AST tree

- Metadata "include" is used as search path list
- Does not apply to contents of a Div
- search paths are inherited from option parameter for pandoc

## Syntax

```markdown
# #include "section1.md"
<!--      ||           |
          | `-----------`--- Filename must be quoted
           `-- White space(s) required here
-->
```
]]

local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists
--local default_meta = require("pandocker.default_loader")["include"]
--assert(default_meta ~= nil)

--local search_paths = {}
--local META_NOT_FOUND = "metadata '%s' was not found in source, applying default %s."
local FILE_NOT_FOUND = "[ lua ] %s: file not found in search paths"

local function dump(tt, mm)
    if mm == nil then
        mm = ""
    end
    for ii, vv in ipairs(tt) do
        print(mm, ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

--[[
local function store_meta (mt)
    search_paths = mt["include"]
    if search_paths == nil then
        search_paths = default_meta
        debug(string.format(META_NOT_FOUND, "include", "./"))
    end
    table.insert(search_paths, "")
end
]]

local function replace(el)
    local rep = el.content
    local sub
    local data
    if #rep == 3 then
        if tostring(PANDOC_VERSION) == "2.15" then
            debug("[ Lua ] " .. PANDOC_SCRIPT_FILE .. ": Pandoc version 2.15 is not supported. Bypassing.")
            return
        end
        --dump(rep)
        if rep[1] == pandoc.Str("#include") and rep[2].tag == "Space" and rep[3].tag == "Quoted" then
            for _, v in ipairs(PANDOC_STATE.resource_path) do
                local included = "./" .. stringify(v) .. "/" .. stringify(rep[3].content)
                if file_exists(included) then
                    data = io.open(included, "r"):read("*a")
                    sub = pandoc.read(data)
                    --dump(sub.blocks)
                    return sub
                end
            end
            debug(string.format(FILE_NOT_FOUND, stringify(rep[3].content)))
            --print(stringify(rep[3].content))
        end
    end
end

local function preprocess(doc)
    local sub = {}
    local head = {}
    local tail = {}
    for i, el in ipairs(doc.blocks) do
        --print(i .. " " .. el.tag .. "(" .. stringify(el) .. ")")
        if el.tag == "Header" then
            sub = replace(el)
            --print(tostring(sub))
            if sub ~= nil then
                --sub = preprocess(sub)
                --print(#sub.blocks)
                --print("\n--- counter reset?")
                table.move(doc.blocks, 1, i - 1, 1, head) -- head has contents before #include
                --dump(head, "hh")
                table.move(doc.blocks, i + 1, #doc.blocks, 1, tail) -- tail has after #include
                --dump(sub.blocks, "ss")
                --dump(tail, "tt")
                table.move(sub.blocks, 1, #sub.blocks, #head + 1, head) -- concat head and sub.blocks -> head
                table.move(tail, 1, #tail, #head + 1, head) -- concat head and tail
                --dump(head, "    ")
                doc.blocks = head
                return preprocess(doc)
            end
        end
    end
    return doc
end

return { { Pandoc = preprocess } }
