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

return {
    debug = debug,
    basename = basename,
}
