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
PANDOC_VERSION:must_be_at_least '2.8'

local yaml = require("lyaml")
local json = require("cjson")

local abs_pwd = require("pandoc.system").get_working_directory()
local stringify = require("pandoc.utils").stringify

--local pretty = require("pl.pretty")

local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists

local INVALID_FILETYPE = "[ lua ] %s: invalid file format for wavedrom. must be JSON" -- or YAML
local MESSAGE = "[ lua ] convert wavedrom to svg/%s.svg"
local BYPASS = "[ lua ] Skipping conversion as target 'svg/%s.svg' exists"
local NOT_FOUND = "[ lua ] %s: file not found"

function Link(el)
    if el.classes:includes "wavedrom" or el.classes:includes "bitfield" then
        if tostring(PANDOC_VERSION) == "2.15" then
            debug("[ Lua ] " .. PANDOC_SCRIPT_FILE .. ": Pandoc version 2.15 is not supported. Bypassing.")
            return
        end
        --debug("Link in 'wavedrom' class")
        if stringify(el.content) == "" then
            el.content = el.target
        end
        local idn = el.identifier

        -- remove "wavedrom" and "bitfield" classes
        local classes = {}
        for i, v in ipairs(el.classes) do
            if v ~= "wavedrom" and v ~= "bitfield" then
                table.insert(classes, v)
            end
        end

        -- main block
        local source_file = stringify(el.target)
        local source_ext = source_file:match('.*%.(.*)')
        if file_exists(source_file) then
            -- reads file contents as string anyway; assuming input a JSON file
            local data = io.open(source_file, "r"):read("*a")
            if source_ext == "yaml" then
                -- if extension is YAML: convert to JSON string
                data = json.encode(yaml.load(data))
                --debug(json.encode(yaml.load(data)))
            elseif source_ext ~= "json" then
                -- prints error message if extension is not YAML nor JSON
                debug(string.format(INVALID_FILETYPE, source_file))
                return
            end

            local attr = pandoc.Attr(idn, classes, el.attributes)
            local content = io.open(source_file, "rb"):read("a")
            local hash = pandoc.utils.sha1(content)
            local fullpath = string.format("%s/svg/%s.svg", abs_pwd, hash)

            -- for wavedrompy > 2.0.3
            -- pipes JSON string to wavedrompy; equivalent to `echo <data> | wavedrompy --input - --svg <fullpath>`
            if not file_exists(fullpath) then
                pandoc.pipe("wavedrompy", { "--input", "-", "--svg", fullpath }, data)
                debug(string.format(MESSAGE, hash))
            else
                debug(string.format(BYPASS, hash))
            end
            local img = pandoc.Image(el.content, fullpath, "fig:", attr)
            --pretty.dump(img)
            return img
        else
            debug(string.format(NOT_FOUND, source_file))
        end
    end
end
