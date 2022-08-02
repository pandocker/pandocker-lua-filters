--[[
# aafigure.lua
]]
PANDOC_VERSION:must_be_at_least '2.8'

local abs_pwd = require("pandoc.system").get_working_directory()
local stringify = require("pandoc.utils").stringify

--local pretty = require("pl.pretty")

local debug = require("pandocker.utils").debug
local file_exists = require("pandocker.utils").file_exists

local util_get_meta = require("pandocker.utils").util_get_meta
local platform = require("pandocker.utils").get_os()
local base = require("pandocker.utils").package_base_path()

local META_KEY = "aafigure"
local meta = {}

local default_meta = require("pandocker.default_loader")[META_KEY]
assert(default_meta)

local MESSAGE = "[ lua ] convert aafigure to svg/%s.svg"
local BYPASS = "[ lua ] Skipping conversion as target 'svg/%s.svg' exists"
local NOT_FOUND = "[ lua ] %s: file not found"
local AAFIGURE = "%s/bin/%s"

local function get_meta(mt)
    meta = util_get_meta(mt, default_meta, META_KEY)
    --debug(stringify(meta))
end

function Link(el)
    if el.classes:includes(META_KEY) then
        if tostring(PANDOC_VERSION) == "2.15" then
            debug("[ Lua ] " .. PANDOC_SCRIPT_FILE .. ": Pandoc version 2.15 is not supported. Bypassing.")
            return
        end
        --debug("Link in 'wavedrom' class")
        if stringify(el.content) == "" then
            el.content = el.target
        end
        local idn = el.identifier

        -- remove classes
        local classes = {}
        for i, v in ipairs(el.classes) do
            if v ~= META_KEY then
                table.insert(classes, v)
            end
        end

        -- main block
        local source_file = stringify(el.target)
        local source_ext = source_file:match('.*%.(.*)')
        if file_exists(source_file) then
            -- reads file contents as string anyway; assuming input a JSON file

            local attr = pandoc.Attr(idn, classes, el.attributes)
            local content = io.open(source_file, "rb"):read("a")
            local hash = pandoc.utils.sha1(content)
            local fullpath = string.format("%s/svg/%s.svg", abs_pwd, hash)

            if not file_exists(fullpath) then
                local aafigure = META_KEY
                pandoc.pipe(aafigure, { source_file, "-o", fullpath }, "")
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

if tostring(PANDOC_VERSION) ~= "2.15" then
    --debug(tostring(tostring(PANDOC_VERSION) == "2.15"))
    return { { Meta = get_meta }, { Link = Link } }
else
    debug("[ Lua ] " .. PANDOC_SCRIPT_FILE .. ": Pandoc version 2.15 is not supported. Bypassing.")
    return
end
