--[[
# csv2table.lua
]]

local pretty = require("pl.pretty")
local csv = require("lua-csv.csv")

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

local function get_cell(st)
end

local function get_row(cells)
end

local function get_table(rows)
end

local function tabular(el)
    if el.classes:includes "table" then
        local source_file = stringify(el.target)
        if file_exists(source_file) then
            if stringify(el.content) == "" then
                el.content = el.target
            end
            local idn = el.identifier
        else
            debug(string.format(FILE_NOT_FOUND, source_file))
            return
        end

    end
end

function Para(el)
    if #(el.content) == 1 then
        sub_el = el.content[1]
        if sub_el.tag == "Link" then
            --debug("Para content is a Link")
            local newp = tabular(sub_el)
            return newp
        end
    end
end
