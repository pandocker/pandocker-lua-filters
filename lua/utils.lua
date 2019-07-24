--[[
# utils.lua

Utility functions
]]


local function debug(string)
    io.stderr:write(string .. "\n")
end

local function basename(path)
    --[[
    INSPIRED FROM https://stackoverflow.com/a/17387077/6592473?stw=2
    split `path` into pwd and file

    | path              | pwd               | file      |
    |---------------------------------------------------|
    | /path             | /                 | path      |
    | /path/to/file     | /path/to          | file      |
    | /path/to/file/    | /path/to/file/    | nil       |
    | /path/to/file.txt | /path/to          | file.txt  |
    ]]

    return path:match('(.*/)(.*)')
end

-- Return true if file exists and is readable.
-- from http://lua-users.org/wiki/FileInputOutput
local function file_exists(path)
    local file = io.open(path, "rb")
    if file then
        file:close()
    end
    return file ~= nil
end

local function get_tf(item, default)
    if type(item) == "string" then
        item = string.upper(item)
        if tablex.search({ "TRUE", "YES" }, item) then
            return true
        else
            return false
        end
    else
        return default
    end
end

return {
    debug = debug,
    basename = basename,
    file_exists = file_exists,
    get_tf = get_tf,
}
