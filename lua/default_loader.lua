--[[
HIGHLY INSPIRED FROM https://pandoc.org/lua-filters.html#default-metadata-file
]]
-- read metadata file (placed same directory as this file) into string
--local debug = require("pandocker.utils").debug

local pwd, _ = require("pandocker.utils").basename(PANDOC_SCRIPT_FILE)
local metafile = io.open(pwd .. 'metadata-file.yaml', 'r')
local content = metafile:read("*a")
metafile:close()
-- get metadata
local default_meta = pandoc.read(content, "markdown").meta
--[[
for i, v in pairs(default_meta) do
    debug(pandoc.utils.stringify(i) .. " = " .. pandoc.utils.stringify(v))
end
]]
return default_meta
