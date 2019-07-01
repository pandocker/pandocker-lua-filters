--[[
# svgconvert.lua


# Note
| Image (alt, src[, title[, attr] ])
| ![alt](src){.class-1 .class-2 attr=alpha attr=beta #fig:figure}
|             |               | | k    v     k   v | |
|             |  classes      | |    attributes    | | identifier
|             |  (preserve)   | |    (preserve)    | | (preserve)
]]

local stringify = require("pandoc.utils").stringify
local file_exists = require("pandocker.utils").file_exists

local get_ext = {
    --["html"] = "svg",
    --["html5"] = "svg",
    ["latex"] = "pdf",
    ["docx"] = "png",
}

function convert_from_svg(el)
    PANDOC_VERSION:must_be_at_least '2.7.3'
    --for k, v in pairs(el) do
    --    print(stringify(k), stringify(v))
    --end
    local ext = get_ext[FORMAT] or "png"
    local source_file = stringify(el.src)
    --print(source_file)
    if ext ~= "svg" then
        if file_exists(source_file) then
            local content = io.open(source_file, "rb"):read("a")
            local path, basename = require("pandocker.utils").basename(source_file)
            local abspath = require("pandoc.system").get_current_directory()
            local hash = pandoc.utils.sha1(content)
            local fullinputpath = string.format("%s/%s", abspath, source_file)
            local fullpath = string.format("%s/svg/%s.%s", abspath, hash, ext)
            if file_exists(fullinputpath) then
                local output = pandoc.pipe("rsvg-convert", { fullinputpath, "-f", ext, "-o", fullpath }, "")
                print(string.format("[ lua ] convert a svg file to svg/%s.png", hash))
                el.src = fullpath
            end
            --print(abspath, path, source_file, basename, hash, ext, fullpath)
        end
    end
end

return { { Image = convert_from_svg } }
