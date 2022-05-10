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

try:
$ pandoc -t native -L lua/table-width.lua
:::{.table width=[0.5] noheader=true}
: Test1

| Header    |
|:----------|
| Cell      |
:::

:::{.table width=[0.5] noheader=true}
: Test2

| Cell      | Cell      |
|:----------|----------:|
|           |           |
:::

:::{.table }
|  head  | head2   |
|----|----|
|cell|cell|
:::


:::{.table }
|head|
|----|
|    |
:::
]]

--local stringify = require("pandoc.utils").stringify

local pretty = require("pl.pretty")
local tablex = require("pl.tablex")
local List = require("pl.List")
require("pl.stringx").import()

local debug = require("pandocker.utils").debug
local get_tf = require("pandocker.utils").get_tf

local MESSAGE = "[ lua ] Div in 'table' class found"
local NOHEADER_MESSAGE = "[ lua ] Move header row to body rows"
local WIDTH_MESSAGE = "[ lua ] Adjust column ratio"
local empty_attr = { "", {}, {} }
local empty_cell = { attr = empty_attr,
                     alignment = pandoc.AlignDefault,
                     row_span = 1,
                     col_span = 1,
                     contents = {} }

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

local function simple_sum_content(row)
    local sum = 0
    -- Row is a list of Cell's
    debug("simple_sum_content()")
    for _, cell in ipairs(row) do
        sum = sum + #cell
    end
    return sum
end

local function sum_content(row)
    local sum = 0
    --pretty.dump(el)
    --row _should_ be a list of cells but:
    --when whole row is blank cells, __row is a nil__
    if row ~= nil then
        for _, cell in ipairs(row[2]) do
            --debug(tostring(tablex.deepcompare(empty_cell, cell)))
            if not tablex.deepcompare(empty_cell, cell) then
                --pretty.dump(cell)
                sum = sum + 1
            end
        end
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

local function table_width(tbl, attr)
    local headers = {}
    local body = {}
    debug(MESSAGE)
    --pretty.dump(el.attributes["width"])
    local widths = attr["width"]
    local noheader = get_tf(attr["noheader"], false)
    local empty_row = { empty_attr, {} }

    local col_max = 1
    if PANDOC_VERSION < { 2, 10 } then
        headers = tbl.headers
        body = tbl.rows
        col_max = #tbl.widths
        sum_content = simple_sum_content
    else
        headers = tbl.head[2]
        body = tbl.bodies[1].body
        --pretty.dump(body)
        col_max = #tbl.colspecs
        for _, v in ipairs(tablex.range(1, col_max)) do
            table.insert(empty_row[2], empty_cell)
        end
    end

    if noheader and headers ~= {} then
        debug(NOHEADER_MESSAGE)
        if PANDOC_VERSION < { 2, 10 } then
            if #body == 1 and sum_content(body[1]) == 0 then
                -- valid header row + first body row is blank
                -- -> remove header row + first body row has ex-header row contents
                debug("[ lua ] header row overrides first body row && remove header row")
                tbl.rows[1] = headers
            else
                -- valid header row + first body row is not blank
                -- -> remove header row + ex-header row stacks at top of body rows
                debug("[ lua ] header row is inserted at head of body rows")
                table.insert(tbl.rows, 1, headers)
            end
            tbl.headers = {}
        else
            --debug(#body)
            --debug(sum_content(body[1]))
            -- valid header row + first body row is blank
            if #body == 1 and sum_content(body[1]) == 0 then
                debug("[ lua ] header row overrides first body row && remove header row (pandoc >= 2.10)")
                tbl.bodies[1].body = headers
            else
                debug("[ lua ] header row is inserted at head of body rows (pandoc >= 2.10)")
                --pretty.dump(tbl.bodies[1].body)
                --pretty.dump(headers)
                table.insert(tbl.bodies[1].body, 1, headers[1])
            end
            tbl.head = { empty_attr, {  } }
        end
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

local function table_finder(el)
    if el.classes:find("table") then
        if #el.content == 1 and el.content[1].tag == "Table" then
            table_width(el.content[1], el.attributes)
        end
    end
end

return { { Div = table_finder } }
