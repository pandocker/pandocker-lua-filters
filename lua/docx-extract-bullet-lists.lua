--[[
# docx-extract-bullet-lists.lua
]]

local debug = require("pandocker.utils").debug

local default_meta = require("pandocker.default_loader")["bullet-style"]
local meta = {}
local NOT_FOUND = "metadata '%s' was not found in source, applying default %s."

local function get_vars (mt)
    if FORMAT == "docx" then
        meta = mt["bullet-style"]
        if meta ~= nil then
            for k, v in pairs(default_meta) do
                if meta[k] == nil then
                    meta[k] = v
                    local d = pandoc.utils.stringify(mt["bullet-style"][k])
                    debug(string.format(NOT_FOUND, "bullet-style." .. k, d))
                end
            end
        else
            meta = default_meta
            debug(string.format(NOT_FOUND, "bullet-style", ""))
            --debug("metadata 'heading-unnumbered' was not found in source, applying defaults.")
        end
    end
end

return { { Meta = get_vars }
    --, { Header = replace }
}
