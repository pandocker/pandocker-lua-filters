--[[
# table-width.lua

Applies table attributes to a table inside a Div

## Syntax

:::{.table width=[w1,w2,...] noheader=true|false}

: Caption {#tbl:table}

| Header    | Row   | Table |
|:----------|:-----:|------:|
| Cell      | Cell  | Cell  |

:::

where,

- w1,w2,... : width value for each column. if not given padded by 0.0
- noheader: flag if header row exists. `true` to move header row to head of body rows.
  Default is `false`. When table has only one blank row, header row overrides body row so that
  table has single row without header row.

]]

--local stringify = require("pandoc.utils").stringify

--local pretty = require("pl.pretty")
--local tablex = require("pl.tablex")
local List = require("pl.List")
require("pl.stringx").import()

local debug = require("pandocker.utils").debug
local get_tf = require("pandocker.utils").get_tf

local MESSAGE = "[ lua ] Div in 'table' class found"
local NOHEADER_MESSAGE = "[ lua ] Move header row to general rows"
local WIDTH_MESSAGE = "[ lua ] Adjust column ratio"

local function get_widths(attr)
    local widths = List()
    for num in string.gmatch(attr, "(%d+%.?%d*),?") do
        --debug(num)
        num = tonumber(num)
        if num == 0 and FORMAT == "docx" then
            v = 0.01
        end
        widths:append(num)
    end
    return widths
end

local function sum_content(el)
    local sum = 0
    --pretty.dump(el)
    for i, v in ipairs(el) do
        sum = sum + #v
    end
    return sum
end

local function fill_widths(col_max, widths)
    while col_max > #widths do
        if FORMAT == "docx" then
            table.insert(widths, 0.01)
        else
            table.insert(widths, 0)
        end
    end
    return widths
end

local function merge_colspecs(colspecs, widths)
    for idx, _ in ipairs(widths) do
        table.insert(colspecs[idx], widths[idx])
    end
    return colspecs
end

local function table_width(el)
    if el.classes:find("table") then
        if #el.content == 1 and el.content[1].tag == "Table" then
            debug(MESSAGE)
            --pretty.dump(el.attributes["width"])
            local widths = el.attributes["width"]
            local noheader = get_tf(el.attributes["noheader"], false)
            local tbl = el.content[1] -- Table

            local col_max = 1
            if PANDOC_VERSION < { 2, 10 } then
                col_max = #tbl.widths
            else
                col_max = #tbl.colspecs
            end

            if noheader and tbl.headers ~= {} then
                debug(NOHEADER_MESSAGE)
                if #tbl.rows == 1 and sum_content(tbl.rows[1]) == 0 then
                    debug("[ lua ] header row overrides first body row")
                    tbl.rows[1] = tbl.headers
                else
                    debug("[ lua ] header row is inserted at head of body rows")
                    table.insert(tbl.rows, 1, tbl.headers)
                end
                tbl.headers = {}
            end
            if widths ~= nil then
                widths = get_widths(widths)
                debug(WIDTH_MESSAGE)
            else
                widths = {}
            end
            widths = fill_widths(col_max, widths)
            if PANDOC_VERSION < { 2, 10 } then
                tbl.widths = widths
            else
                tbl.colspecs = merge_colspecs(tbl.colspecs, widths)
                --pretty.dump(tbl.colspecs)
            end

            --pretty.dump(widths)
            return tbl
        end
    end
end

return { { Div = table_width } }
