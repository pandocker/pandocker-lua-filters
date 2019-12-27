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

-- requires global definition of `default_meta` and `meta_key`
local function get_meta(doc_meta, default_meta, meta_key)
    local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."

    meta = doc_meta[meta_key]
    if meta ~= nil then
        for k, v in pairs(default_meta) do
            if meta[k] == nil then
                meta[k] = v
                local d = pandoc.utils.stringify(doc_meta[meta_key][k])
                debug(string.format(NOT_FOUND, meta_key .. "." .. k, d))
            end
        end
    else
        meta = default_meta
        debug(string.format(NOT_FOUND, meta_key, ""))
    end
    --pretty.dump(meta)
    return meta
end

return {
    basename = basename,
    debug = debug,
    file_exists = file_exists,
    get_tf = get_tf,
    util_get_meta = get_meta,
}
