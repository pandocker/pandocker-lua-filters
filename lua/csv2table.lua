--[[
# csv2table.lua

Converts Link to a csv file into Table object

## Syntax

[Caption](/path/to/file){.table width=[w1,w2,...] header=true nocaption=true alignment=a1a2... \
                                subset_from=(y1,x1) subset_to=(y2,x2) #tbl:table}
where,

- Caption: caption of this table. if not given filename is used
- /path/to/file : path to file. relative to directory where pandoc is invoked
- header : flag to let first row as header row. defaults true
- nocaption : Flag to unset temporary caption. defaults false
- w1,w2,... : width value for each column. if not given padded by 0
- a1a2... : alignment list for each column. c=Center, d=Default, l=Left, r=Right.
if not given padded by d
- subset_from : (row,col) pair to specify coordinate to cut FROM
- subset_to : (row,col) pair to specify coordinate to cut TO

### Equivalent output

: Caption {#tbl:table}

| Header    | Row   | Table |
|:----------|:-----:|------:|
| Cell      | Cell  | Cell  |

]]

--local pretty = require("pl.pretty")
require("pl.stringx").import()
local List = require("pl.List")
local tablex = require("pl.tablex")
local csv = require("csv")

local stringify = require("pandoc.utils").stringify
local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists

local MESSAGE = "[ lua ] insert a table from %s"
local FILE_NOT_FOUND = "[ lua ] %s: file not found"

local table_template = [==[
| table |
|-------|
| cell  |

Table: caption
]==]

local my_table = pandoc.read(table_template, "markdown").blocks[1]

local empty_attr = { "", {}, {} }
local empty_row = function()
    if PANDOC_VERSION < { 2, 10 } then
        return { {} }
    else
        return { empty_attr, {} }
    end
end

local function get_tf(item, default)
    if type(item) == "string" then
        item = string.upper(item)
        if tablex.search({ "TRUE", "YES" }, item) then
            return true
        else
            return false
        end
    else
        return default
    end
end

local function get_cell(c)
    if type(c) ~= "string" then
        c = tostring(c)
    end
    --pretty.dump(c)

    local _cell = pandoc.read(c, "markdown").blocks
    if PANDOC_VERSION < { 2, 10 } then
        return _cell -- List of Blocks
    else
        return { attr = empty_attr,
                 alignment = pandoc.AlignDefault,
                 row_span = 1,
                 col_span = 1,
                 contents = pandoc.List(_cell) } -- Cell
    end
end

local function get_row(t)
    local row = {}
    for _, v in ipairs(t) do
        --dump(get_cell(v), "")
        table.insert(row, get_cell(v))
    end
    if PANDOC_VERSION < { 2, 10 } then
        return row -- List of List of Blocks
    else
        return { empty_attr, row }
    end
end

local ALIGN = { ["D"] = pandoc.AlignDefault,
                ["L"] = pandoc.AlignLeft,
                ["C"] = pandoc.AlignCenter,
                ["R"] = pandoc.AlignRight
}

local function get_xy(attr)
    local _y = 1
    local _x = 1
    _y, _x = string.match(attr, "(%d+),(%d+)")
    --debug(attr .. " " .. _y .. " " .. _x)
    _y = tonumber(_y)
    _x = tonumber(_x)
    return _y, _x
end

local function get_widths(attr)
    local widths = List()
    for num in string.gmatch(attr, "(%d+%.?%d*),?") do
        --debug(num)
        widths:append(tonumber(num))
    end
    return widths
end

local function get_alignments(attr)
    local alignment = List()
    for al in string.gmatch(attr, "[dlrcDLRC]") do
        --debug(al)
        alignment:append(ALIGN[al:upper()])
    end
    return alignment
end

local function tabular(el)
    if el.classes:includes "table" then
        if tostring(PANDOC_VERSION) == "2.15" then
            debug("[ Lua ] " .. PANDOC_SCRIPT_FILE .. ": Pandoc version 2.15 is not supported. Bypassing.")
            return
        end
        local tab = {}
        local source_file = stringify(el.target)
        local header_avail = get_tf(el.attributes.header, true)
        local header = empty_row()
        local nocaption = get_tf(el.attributes.nocaption, false)
        local y_from = 1
        local x_from = 1
        local y_to = -1
        local x_to = -1
        local caption = ""
        local alignment = List()
        local widths = List()

        if file_exists(source_file) then
            tab = csv.open(source_file)
            --pretty.dump(tab)
        else
            debug(string.format(FILE_NOT_FOUND, source_file))
            return
        end
        if stringify(el.content) == "" then
            if nocaption then
                caption = {}
            else
                caption = { pandoc.Str(el.target) }
            end
        else
            caption = el.content
        end
        --pretty.dump(caption)
        if el.identifier ~= "" then
            caption = List(caption)
            caption:append(pandoc.Space())
            caption:append(pandoc.Str("{#" .. el.identifier .. "}"))
        end
        if el.attributes.subset_from ~= nil then
            y_from, x_from = get_xy(el.attributes.subset_from)
        end
        if el.attributes.subset_to ~= nil then
            y_to, x_to = get_xy(el.attributes.subset_to)
            if x_to < x_from then
                x_to = x_from
            end
            if y_to < y_from then
                y_to = y_from
            end
        end
        if el.attributes.alignment ~= nil then
            alignment = get_alignments(el.attributes.alignment)
        end
        if el.attributes.width ~= nil then
            widths = get_widths(el.attributes.width)
        end
        local rows = List()
        local i = 1
        local col_max = 1
        for row in tab:lines() do
            if i >= y_from then
                row = List(row):slice(x_from, x_to)
                --pretty.dump(row)
                col_max = math.max(col_max, #row)
                rows:append(get_row(row))
                if y_to > 0 and i >= y_to then
                    break
                end
            end
            i = i + 1
        end
        if header_avail then
            header = rows:pop(1)
            --pretty.dump(header)
        end
        --pretty.dump(header)
        while col_max > #alignment do
            alignment:append(ALIGN.D)
        end
        while col_max > #widths do
            if FORMAT == "docx" then
                widths:append(0.01)
            else
                widths:append(0)
            end
        end
        --pretty.dump(alignment)
        debug(string.format(MESSAGE, source_file))
        if PANDOC_VERSION < { 2, 10 } then
            return pandoc.Table(
                    caption,
                    alignment,
                    widths,
                    header,
                    rows
            )
        else
            --pretty.dump(header)
            local table = my_table:clone()
            --debug("table." .. tostring(tablex.keys(table)))
            --debug(tostring(tablex.keys(table.head)))
            if tablex.find(tablex.keys(table.head), "rows") ~= nil then
                -- pandoc >= 2.17
                table.head.rows = { header }
            else
                -- pandoc < 2.17
                table.head[2] = { header }
            end
            --pretty.dump(table.head)
            table.caption = { long = { pandoc.Plain(caption) } }
            --pretty.dump(table.caption)
            table.colspecs = tablex.zip(alignment, widths)
            --pretty.dump(table.colspecs)
            table.bodies = { { attr = empty_attr,
                               head = {   },
                               body = rows,
                               row_head_columns = 0 } }
            --pretty.dump(table.bodies)
            return table
        end
    end
end

local function link2table(el)
    if #el.content == 1 and el.content[1].tag == "Link" then
        return tabular(el.content[1])
    end
end

return { { Para = link2table } }
