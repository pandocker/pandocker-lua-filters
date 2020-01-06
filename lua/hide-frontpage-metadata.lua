--[[
# hide-frontpage-metadata.lua

hides certain metadata when LaTeX or Docx output

]]

-- local pretty = require("pl.pretty")

local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug

local MESSAGE = "[ lua ] metadata '%s' has found and removed"

if FORMAT == "latex" or FORMAT == "docx" then
    local function get_vars (mt)
        local meta = {
            author = "author-meta",
            date = "date-meta",
            subtitle = "subtitle-meta",
            title = "title-meta",
        }

        for k, v in pairs(meta) do
            --debug(k .. ": " .. v)
            if mt[k] ~= nil then
                mt[v] = stringify(mt[k])
                --debug(stringify(mt[k]))
                mt[k] = nil
                debug(string.format(MESSAGE, k))
            end
        end
        --pretty.dump(mt)
        return mt
    end
    return { { Meta = get_vars } }
end
