--[[
# csv2table.lua
]]

local pretty = require("pl.pretty")
require("pl.stringx").import()
local List = require("pl.List")
local csv = require("csv")

local stringify = require("pandoc.utils").stringify
local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists

local FILE_NOT_FOUND = "[ lua ] %s: file not found"

--local data = [[
--,,,"\
--"
--
--,,a,,"c\
--d",,
--,e,f,
--]]
--local f = csv.openstring(data)
--for fields in f:lines() do
--    pretty.dump(fields)
--end

local function get_cell(c)
    if type(c) ~= "string" then
        c = tostring(c)
    end
    --pretty.dump(c)
    local cell = pandoc.read(c, "markdown").blocks
    return cell
end

local function get_row(t)
    local row = {}
    for _, v in ipairs(t) do
        --dump(get_cell(v), "")
        table.insert(row, get_cell(v))
    end
    return row
end

local function get_table(tb)
    --tb.name
    --tb.rows
    --tb.idn
    local rows = {}
    for row in tb.rows do
        table.insert(rows, get_row(row))
    end
    return pandoc.Table(
            { pandoc.Str(tb.name), pandoc.Space(), pandoc.Str(tb.idn) },
            ALIGN,
            { },
            get_row(HEADER_ROW),
            rows
    )
end

local function tabular(el)
    if el.classes:includes "table" then
        local tab = {}
        local source_file = stringify(el.target)
        local y_from = 1
        local x_from = 1
        local y_to = -1
        local x_to = -1

        if file_exists(source_file) then
            tab = csv.open(source_file)
            --pretty.dump(tab)
        else
            debug(string.format(FILE_NOT_FOUND, source_file))
            return
        end
        if stringify(el.content) == "" then
            el.content = el.target
        end
        if el.attributes.subset_from ~= nil then
            local subset_from = el.attributes.subset_from:lstrip("[("):rstrip(")]"):split(",")
            y_from = tonumber(subset_from[1])
            x_from = tonumber(subset_from[2])
        end
        if el.attributes.subset_to ~= nil then
            local subset_to = el.attributes.subset_to:lstrip("[("):rstrip(")]"):split(",")
            y_to = tonumber(subset_to[1])
            x_to = tonumber(subset_to[2])
        end
        if x_to < x_from then
            x_to = x_from
        end
        if y_to < y_from then
            y_to = y_from
        end
        --print(x_from, y_from, x_to, y_to)
        --local idn = el.identifier
        local rows = List()
        local i = 1
        for row in tab:lines() do
            if i >= y_from and i <= y_to then
                row = List(row):slice(x_from, x_to)
                --pretty.dump(row)
                rows:append(get_row(row))
                --for _, col in ipairs(row) do
                --    pretty.dump(col)
                --end
            end
            i = i + 1
        end
        t = pandoc.Table(
                { pandoc.Str("Title"), pandoc.Space(), pandoc.Str("{#" .. el.identifier .. "}") },
                { pandoc.AlignDefault },
                { },
                { pandoc.Str("Header") },
                { { pandoc.Str("Row1") } }
        --rows
        )
        pretty.dump(t)
        return t
    end
end

return { { Link = tabular } }
