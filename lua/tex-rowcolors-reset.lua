--[[
# tex-rowcolors-reset.lua

Finds table and inserts tex command to reset row rule
]]

local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local default_meta = require("pandocker.default_loader")["tex-rowcolors"]
assert(default_meta)

local METADATA_NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default."

local meta = {}
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
            debug(string.format(METADATA_NOT_FOUND, "tex-rowcolors", ""))
        end
        reset_colors = pandoc.RawBlock("latex", stringify(meta))
    end

    local function reset_table_color(el)
        return { reset_colors, el }
    end

    return { { Meta = get_vars }, { Table = reset_table_color } }
end
