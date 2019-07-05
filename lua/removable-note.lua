--[[
# removable-note.lua
]]

local debug = require("pandocker.utils").debug
local stringify = require("pandoc.utils").stringify
local default_meta = require("pandocker.default_loader")["rmnote"]
local meta = {}
local NOT_FOUND = "metadata '%s' was not found in source, applying default %s."

local function dump(tt, mm)
    for ii, vv in ipairs(tt) do
        print(mm .. ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

local function get_vars (mt)
    meta = mt["rmnote"]
    if meta == nil then
        meta = default_meta
        debug(string.format(NOT_FOUND, "rmnote", ""))
    end
end

function landscape(doc)
    local head = {}
    local tail = {  }
    for i, el in ipairs(doc.blocks) do
        --print(i .. " " .. el.tag .. "(" .. stringify(el) .. ")")
        if el.tag == "Div" and el.classes:find("rmnote") then
            debug("Div in 'rmnote' class found")
            if meta then
                debug("remove")
                el.content = { pandoc.Null() }
            end
            table.move(doc.blocks, 1, i - 1, 1, head) -- head has contents before #include
            table.insert(head, start_landscape)
            dump(head, "hh")
            dump(el.content, "ss")
            table.move(doc.blocks, i + 1, #doc.blocks, 1, tail) -- tail has after #include
            dump(tail, "tt")
            table.move(el.content, 1, #el.content, #head + 1, head) -- concat head and el.content -> head
            table.move(tail, 1, #tail, #head + 1, head) -- concat head and tail
            dump(head, "    ")
            doc.blocks = head
        end
    end
    --dump(doc.blocks, "    ")
    return doc
end

return { { Meta = get_vars }, { Pandoc = landscape } }