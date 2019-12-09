--[[
# tex-hide-meta.lua

hides certain metadata when LaTeX output

]]

-- local pretty = require("pl.pretty")

local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug

local MESSAGE = "[ lua ] metadata '%s' has found and removed"

if FORMAT == "latex" then
    local function get_vars (mt)
        local meta = {
            "author",
            "date",
            "subtitle",
            "title",
        }

        for i, v in ipairs(meta) do
            if mt[v] ~= nil then
                mt[v] = nil
                debug(string.format(MESSAGE, v))
            end
        end
--         pretty.dump(mt)
        return mt
    end
    return { { Meta = get_vars } }
end
