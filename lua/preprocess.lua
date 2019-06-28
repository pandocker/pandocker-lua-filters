--[[
# preprocess.lua
Finds level-1 heading starting with `#include` and "filename"
and tries to include contents of filename into AST tree

## Syntax

# #include "section1.md"

]]

local stringify = require("pandoc.utils").stringify
local file_exists = require("pandocker.utils").file_exists
local List = require("pandoc.List")
local search_paths = {}

function store_meta (meta)
    search_paths = meta["include"]
    --[[
        for _, v in ipairs(_meta) do
            print(stringify(v))
        end
    ]]
end

local function replace(el)
    local rep = el.content
    local sub
    if #rep == 3 then
        --for ii, vv in ipairs(rep) do
        --    print(vv.tag .. "(" .. stringify(vv) .. ")")
        --end
        if rep[1] == pandoc.Str("#include") and rep[2].tag == "Space" and rep[3].tag == "Quoted" then
            for _, v in ipairs(search_paths) do
                included = "./" .. stringify(v) .. "/" .. stringify(rep[3].content)
                if file_exists(included) then
                    f = io.open(included, "r")
                    sub = pandoc.read(f:read("*a"), "markdown")
                    f:close()
                    --for ii, vv in ipairs(sub.blocks) do
                    --    print(vv.tag .. "(" .. stringify(vv) .. ")")
                    --end
                    return sub
                end
            end
            --print(stringify(rep[3].content))
        end
    end
end

local function dump(tt, mm)
    for ii, vv in ipairs(tt) do
        print(mm .. ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

function preprocess(doc)
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

return { { Meta = store_meta }, { Pandoc = preprocess }
    --, { Header = replace }
}
