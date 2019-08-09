--[[
# table-width.lua
]]

local stringify = require("pandoc.utils").stringify

local pretty = require("pl.pretty")
require("pl.stringx").import()

local debug = require("pandocker.utils").debug

local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."
local MESSAGE = "[ lua ] Div in 'LANDSCAPE' class found"

local function get_widths(attr)
    local widths = {}
    for _, v in ipairs(attr:split(",")) do
        v = tonumber(v)
        if v == nil then
            v = 0
        end
        if v == 0 and FORMAT == "docx" then
            v = 0.01
        end
        table.insert(widths, v)
    end
    return widths
end

local function table_width(el)
    if el.classes:find("table") then
        debug("table class div")
        if #el.content == 1 and el.content[1].tag == "Table" then
            --pretty.dump(el.attributes["width"])
            local widths = el.attributes["width"]
            local tbl = el.content[1]
            local col_max = #tbl.widths
            if widths ~= nil then
                widths = widths:match("%[(.*)%]")
                widths = get_widths(widths)
            else
                widths = {}
            end
            while col_max > #widths do
                if FORMAT == "docx" then
                    table.insert(widths, 0.01)
                else
                    table.insert(widths, 0)
                end
            end

            --pretty.dump(widths)
            tbl.widths = widths
            return tbl
        end
    end
end

return { { Div = table_width } }
