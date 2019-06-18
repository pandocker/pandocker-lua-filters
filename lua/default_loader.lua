local debug = require("pandocker.debugger").debug
--[[
HIGHLY INSPIRED FROM https://pandoc.org/lua-filters.html#default-metadata-file
AND FROM https://stackoverflow.com/a/17387077/6592473?stw=2
]]
-- read metadata file (placed same directory as this file) into string

local pwd, _ = PANDOC_SCRIPT_FILE:match('(.*/)(.*)')
local metafile = io.open(pwd .. 'metadata-file.yaml', 'r')
local content = metafile:read("*a")
metafile:close()
-- get metadata
local default_meta = pandoc.read(content, "markdown").meta
--debug(pandoc.utils.stringify(default_meta))
return default_meta

--[[
return {
    {
        Meta = function(meta)
            debug("- load defaults -")
            -- use default metadata field if it hasn't been defined yet.
            for k, v in pairs(default_meta) do
                if meta[k] == nil then
                    meta[k] = v
                    --debug(pandoc.utils.stringify(v))
                end
            end
            return meta
        end,
    }
}
]]
