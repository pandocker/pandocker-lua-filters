--[[
# tex-rowcolors-reset.lua

Finds table and inserts tex command to reset row rule
]]

local debug = require("pandocker.utils").debug
local stringify = require("pandoc.utils").stringify
local default_meta = require("pandocker.default_loader")["tex-rowcolors"]
local MESSAGE = "[ lua ] Table found"
local meta = {}
local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."
local reset_colors = {}

local function dump(tt, mm)
    for ii, vv in ipairs(tt) do
        print(mm .. ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

if FORMAT == "latex" then
    local function get_vars (mt)
        meta = mt["tex-rowcolors"]
        if meta == nil then
            meta = default_meta
            debug(string.format(NOT_FOUND, "tex-rowcolors", ""))
        end
        reset_colors = pandoc.RawBlock("latex", stringify(meta))
    end

    local function reset_table_color(el)
        if FORMAT == "latex" then
            return { reset_colors, el }
        end

    end

    return { { Meta = get_vars }, { Table = reset_table_color } }
end
