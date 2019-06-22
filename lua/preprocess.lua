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

function replace(el)
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
                    return preprocess(sub)
                end
            end
            --print(stringify(rep[3].content))
        end
    end
end

function preprocess(doc)
    local sub
    for i, el in ipairs(doc.blocks) do
        print(i .. " " .. el.tag .. "(" .. stringify(el) .. ")")
        if el.tag == "Header" then
            sub = replace(el)
            if sub ~= nil then
                local bu = {}
                for j = i + 1, #doc.blocks do
                    --print(i, j)
                    bu[#bu + 1] = doc.blocks[j]
                    j = j + 1
                end
                --print(#doc.blocks)
                table.move(sub.blocks, 1, #sub.blocks, i, doc.blocks)
                --print(#doc.blocks)
                table.move(bu, 1, #bu, #doc.blocks + 1, doc.blocks)
                --print(#doc.blocks)
            end
        end
    end
    return doc
end

return { { Meta = store_meta }, { Pandoc = preprocess }
    --, { Header = replace }
}
