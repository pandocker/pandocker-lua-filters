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

- w1,w2,... : width value for each column. if not fully given padded by
  (1 - (sum of given widths)) / (number of unnumbered columns)
  e.g. When [0.5] is given for 4-column table, the first column will have 0.5 and the rest will have 0.16667 each
  of page width (i.e. (1 - 0.5) / 3)
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
local seq = require("pl.seq")
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
        --[[
                num = tonumber(num)
                if num == 0 and FORMAT == "docx" then
                    num = 0.01
                end
        ]]
        widths:append(tonumber(num))
    end
    --pretty.dump(widths)
    return widths
end

local function sum_content(row)
    local sum = 0
    -- Row is a list of Cell's
    --debug("simple_sum_content()")
    for _, cell in ipairs(row) do
        sum = sum + #cell
    end
    return sum
end

local function fill_widths(col_max, widths)
    if widths ~= nil then
        widths = get_widths(widths)
        debug(WIDTH_MESSAGE)
    else
        widths = {}
    end

    local rest = 1 - seq.sum(widths)
    local rest_columns_width = 0
    if rest <= 1 then
        rest_columns_width = rest / (col_max - #widths)
    end
    --debug(rest_columns_width)

    while col_max > #widths do
        if FORMAT == "docx" then
            table.insert(widths, 0.01)
        else
            table.insert(widths, rest_columns_width)
        end
    end
    --pretty.dump(widths)
    return widths
end

local function merge_colspecs(colspecs, widths)
    for idx, _ in ipairs(widths) do
        table.insert(colspecs[idx], widths[idx])
    end
    pretty.dump(table.colspecs)
    return colspecs
end

local function table_width(tbl, attr)
    debug(MESSAGE)
    --pretty.dump(el.attributes["width"])
    local widths = attr["width"]
    local noheader = get_tf(attr["noheader"], false)

    local headers = tbl.headers
    local body = tbl.rows
    local col_max = #tbl.widths

    if noheader and headers ~= {} then
        debug(NOHEADER_MESSAGE)
        if #body == 1 and sum_content(body[1]) == 0 then
            -- valid header row + first body row is blank
            -- -> remove header row + first body row has ex-header row contents
            debug("[ lua ] header row overrides first body row && remove header row (pandoc < 2.10)")
            tbl.rows[1] = headers
        else
            -- valid header row + first body row is not blank
            -- -> remove header row + ex-header row stacks at top of body rows
            debug("[ lua ] header row is inserted at head of body rows (pandoc < 2.10)")
            table.insert(tbl.rows, 1, headers)
        end
        tbl.headers = {}
    end
    widths = fill_widths(col_max, widths)
    tbl.widths = widths

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

if PANDOC_VERSION < { 2, 10 } then
    return { { Div = table_finder } }
end
