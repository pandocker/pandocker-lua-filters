--[[
# csv2table.lua
]]

local pretty = require("pl.pretty")
require("pl.stringx").import()
local List = require("pl.List")
local tablex = require("pl.tablex")
local csv = require("csv")

local stringify = require("pandoc.utils").stringify
local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists

local MESSAGE = "[ lua ] insert a table from %s"
local FILE_NOT_FOUND = "[ lua ] %s: file not found"

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

local ALIGN = { ["D"] = pandoc.AlignDefault,
                ["L"] = pandoc.AlignLeft,
                ["C"] = pandoc.AlignCenter,
                ["R"] = pandoc.AlignRight
}

local function tabular(el)
    if el.classes:includes "table" then
        local tab = {}
        local source_file = stringify(el.target)
        local y_from = 1
        local x_from = 1
        local y_to = -1
        local x_to = -1
        local caption = ""
        local alignment = List()
        local header = true
        local widths = List()

        if file_exists(source_file) then
            tab = csv.open(source_file)
            --pretty.dump(tab)
        else
            debug(string.format(FILE_NOT_FOUND, source_file))
            return
        end
        if stringify(el.content) == "" then
            caption = { pandoc.Str(el.target) }
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
            local subset_from = el.attributes.subset_from:lstrip("[("):rstrip(")]"):split(",")
            y_from = tonumber(subset_from[1])
            x_from = tonumber(subset_from[2])
        end
        if el.attributes.subset_to ~= nil then
            local subset_to = el.attributes.subset_to:lstrip("[("):rstrip(")]"):split(",")
            y_to = tonumber(subset_to[1])
            x_to = tonumber(subset_to[2])
            if x_to < x_from then
                x_to = x_from
            end
            if y_to < y_from then
                y_to = y_from
            end
        end
        if el.attributes.alignment ~= nil then
            local i = 1
            local al = ""
            while i <= #el.attributes.alignment do
                al = string.sub(el.attributes.alignment, i, i)
                --print(string.sub(el.attributes.alignment, i, i))
                alignment:append(ALIGN[al:upper()])
                i = i + 1
            end

        end
        if el.attributes.header ~= nil then
            header = get_tf(el.attributes.header, true)
        end
        if el.attributes.width ~= nil then
            local _widths = el.attributes.width:lstrip("[("):rstrip(")]"):split(",")
            for _, v in ipairs(_widths) do
                widths:append(tonumber(v))
            end
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
        if header then
            header = rows:pop(1)
        else
            header = { {} }
        end
        --pretty.dump(header)
        while col_max > #alignment do
            alignment:append(ALIGN.D)
        end
        while col_max > #widths do
            widths:append(0.0)
        end
        --pretty.dump(alignment)
        debug(string.format(MESSAGE, source_file))
        return pandoc.Table(
                caption,
                alignment,
                widths,
                header,
                rows
        )
    end
end

function link2table(el)
    if #el.content == 1 and el.content[1].tag == "Link" then
        return tabular(el.content[1])
    end
end

return { { Para = link2table } }
