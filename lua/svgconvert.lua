--[[
# svgconvert.lua


# Note
| Image (alt, src[, title[, attr] ])
| ![alt](src){.class-1 .class-2 attr=alpha attr=beta #fig:figure}
|             |               | | k    v     k   v | |
|             |  classes      | |    attributes    | | identifier
|             |  (preserve)   | |    (preserve)    | | (preserve)
]]

PANDOC_VERSION:must_be_at_least '2.8'

local stringify = require("pandoc.utils").stringify
local get_current_directory = require("pandoc.system").get_working_directory

local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists

local MESSAGE = "[ lua ] convert a svg file to svg/%s.%s"
local BYPASS = "[ lua ] Skipping conversion as target 'svg/%s.%s' exists"
local ERROR_MESSAGE = "[ lua ] %s: file not found"

local get_ext = {
    ["html"] = "svg",
    ["html5"] = "svg",
    ["latex"] = "pdf",
    ["docx"] = "png",
}

function convert_from_svg(el)
    --for k, v in pairs(el) do
    --    print(stringify(k), stringify(v))
    --end
    local ext = get_ext[FORMAT] or "png"
    local source_file = stringify(el.src)
    --debug(source_file)
    local source_base, source_ext = source_file:match('(.*)%.(.*)')
    if ext ~= "svg" and source_ext == "svg" then
        if file_exists(source_file) then
            local _, basename = require("pandocker.utils").basename(source_base)
            local abspath = get_current_directory()
            local fullpath = string.format("%s/svg/%s.%s", abspath, basename, ext)
            if not file_exists(fullpath) then
                pandoc.pipe("rsvg-convert", { source_file, "-f", ext, "-o", fullpath }, "")
                debug(string.format(MESSAGE, basename, ext))
            else
                debug(string.format(BYPASS, basename, ext))
            end
            el.src = fullpath
            --debug(abspath, path, source_file, basename, ext, fullpath)
            return el
        else
            debug(string.format(ERROR_MESSAGE, source_file))
        end
    end
end

return { { Image = convert_from_svg } }
