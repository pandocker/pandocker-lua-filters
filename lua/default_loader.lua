local debug = require("pandocker.debugger").debug
--[[
HIGHLY INSPIRED FROM https://pandoc.org/lua-filters.html#default-metadata-file
]]
-- read metadata file into string
local metafile = io.open('/usr/local/share/lua/5.3/pandocker/metadata-file.yaml', 'r')
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
