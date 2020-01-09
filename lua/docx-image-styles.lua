--[[
# docx-image-styles.lua

applies different styles image and its caption
when image link does not have caption
]]

--local pretty = require("pl.pretty")
--require("pl.stringx").import()

local stringify = require("pandoc.utils").stringify
local debug = require("pandocker.utils").debug
--local file_exists = require("pandocker.utils").file_exists

local MESSAGE = "[ lua ] Para having one Image element found"
local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."

local default_meta = require("pandocker.default_loader")["figure-styles"]

if FORMAT == "docx" then
    local function get_vars (mt)
        meta = mt["figure-styles"]
        if meta ~= nil then
            for k, v in pairs(default_meta) do
                if meta[k] == nil then
                    meta[k] = v
                    local d = pandoc.utils.stringify(mt["figure-styles"][k])
                    debug(string.format(NOT_FOUND, "figure-styles." .. k, d))
                end
            end
        else
            meta = default_meta
            debug(string.format(NOT_FOUND, "figure-styles", ""))
            --debug("metadata 'heading-unnumbered' was not found in source, applying defaults.")
        end
    end

    local function para(elem)
        if #elem.content == 1 and elem.content[1].tag == "Image" then
            debug(MESSAGE)
            image = elem.content[1]
            --debug(stringify(image.src))
            local caption_div = pandoc.Div({})
            local image_div = pandoc.Div({})
            caption_div["attr"]["attributes"]["custom-style"] = stringify(meta["caption"])
            image_div["attr"]["attributes"]["custom-style"] = stringify(meta["anchor"])

            if stringify(image.caption) ~= "" then
                caption_div.content = { pandoc.Para(image.caption) }
                image.caption = {}
                image.title = ""
            end
            image_div.content = { pandoc.Para(image) }
            return { image_div, caption_div }
        end
    end

    return { { Meta = get_vars }, { Para = para } }
end
