--[[
# table-width.lua
]]

local stringify = require("pandoc.utils").stringify

local pretty = require("pl.pretty")
require("pl.stringx").import()

local debug = require("pandocker.utils").debug

local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."
local MESSAGE = "[ lua ] Div in 'LANDSCAPE' class found"

local function get_widths(attr)
    local widths = {}
    for _, v in ipairs(attr:split(",")) do
        v = tonumber(v)
        if v == nil then
            v = 0
        end
        if v == 0 and FORMAT == "docx" then
            v = 0.01
        end
        table.insert(widths, v)
    end
    return widths
end

local function table_width(el)
    local attr = stringify(el):match("width=%[(.*)%]")
    --pretty.dump(attr)
    if attr ~= nil then
        local widths = get_widths(attr)
        if #widths == #el.widths then
            el.widths = widths
            --debug(type(widths))
        end
        local caption = {}
        local st = ""
        local open_curly_brace = ""
        local close_curly_brace = ""
        local crossref = ""
        local width = ""

        for _, sub_el in ipairs(el.caption) do
            st = stringify(sub_el)
            --pretty.dump(st:match("{"))
            if st:match("{") == nil and st:match("}") == nil then
                table.insert(caption, sub_el)
            else
                open_curly_brace = st:match("{")
                close_curly_brace = st:match("}")
                if open_curly_brace ~= nil then
                    sub_el.text = sub_el.text:replace("{", "")
                elseif close_curly_brace ~= nil then
                    sub_el.text = sub_el.text:replace("}", "")
                end
                st = stringify(sub_el)
                --pretty.dump(st)
                crossref = st:match("#tbl:.*")
                width = st:match("width=%[.*")
                --pretty.dump(width)
                if crossref ~= nil then
                    sub_el.text = string.format("{%s}", crossref)
                elseif width ~= nil or sub_el.text == "" then
                    sub_el = pandoc.Null()
                end
                if sub_el.tag ~= "Null" then
                    table.insert(caption, sub_el)
                end
            end
        end
        if caption[#caption].tag ~= "Str" then
            table.remove(caption)
        end
        el.caption = caption
        --debug(el.caption[#el.caption].tag)
        --debug(el.caption[#el.caption].text)
        --pretty.dump(el)
        return el
    end
end

return { { Table = table_width } }
