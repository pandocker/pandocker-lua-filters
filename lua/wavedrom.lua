--[[
# wavedrom.lua

# Note
| Link (content, target[, title[, attr] ])
| [content](target){.class-1 .class-2 attr=alpha attr=beta #lst:list}
|                   |               | | k    v     k   v | |
|                   |  classes      | |    attributes    | identifier
|                   .listingtable     type=plain numbers=left from=5 to=10
|
| Image (alt, src[, title[, attr] ])
| ![alt](src){.class-1 .class-2 attr=alpha attr=beta #fig:figure}
|             |               | | k    v     k   v | |
|             |  classes      | |    attributes    | | identifier
|             |  (preserve)   | |    (preserve)    | | (preserve)

]]
PANDOC_VERSION:must_be_at_least '2.7.3'

local abs_pwd = require("pandoc.system").get_current_directory()
local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists

local INVALID_FILETYPE = "[ lua ] invalid wavedrom file format. must be JSON"
local MESSAGE = "[ lua ] convert wavedrom to svg/%s.svg"
local NOT_FOUND = "[ lua ] %s: file not found"

function Link(el)
    if el.classes:includes "wavedrom" or el.classes:includes "bitfield" then
        --debug("Link in 'wavedrom' class")
        if stringify(el.content) == "" then
            el.content = el.target
        end
        local idn = el.identifier
        local classes = {}
        for i, v in ipairs(el.classes) do
            if v ~= "wavedrom" and v ~= "bitfield" then
                table.insert(classes, v)
            end
        end

        local source_file = stringify(el.target)
        local source_ext = source_file:match('.*%.(.*)')
        if file_exists(source_file) then
            if source_ext ~= "json" then
                debug(INVALID_FILETYPE)
                return
            end
            local _, basename = require("pandocker.utils").basename(source_file)
            if idn == "" then
                idn = "fig:" .. string.gsub(basename, "%.", "_")
            end
            local attr = pandoc.Attr(idn, classes, el.attributes)
            local content = io.open(source_file, "rb"):read("a")
            local hash = pandoc.utils.sha1(content)
            local fullinputpath = string.format("%s/%s", abs_pwd, source_file)
            local fullpath = string.format("%s/svg/%s.svg", abs_pwd, hash)
            --print(fullinputpath, hash, fullpath)
            pandoc.pipe("wavedrompy", { "--input", fullinputpath, "--svg", fullpath }, "")
            debug(string.format(MESSAGE, hash))
            local img = pandoc.Image({}, fullpath, "", attr)
            return img
        else
            debug(string.format(NOT_FOUND, source_file))
        end
    end
end
