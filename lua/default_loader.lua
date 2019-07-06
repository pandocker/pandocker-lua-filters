--[[
HIGHLY INSPIRED FROM https://pandoc.org/lua-filters.html#default-metadata-file
]]
-- read metadata file (placed same directory as this file) into string
local debug = require("pandocker.utils").debug

local pwd, _ = require("pandocker.utils").basename(PANDOC_SCRIPT_FILE)
local metafile = io.open(pwd .. 'metadata-file.yaml', 'r')
local content = metafile:read("*a")
metafile:close()
-- get metadata
local default_meta = pandoc.read(content, "markdown").meta
--debug(pandoc.utils.stringify(default_meta))
return default_meta
