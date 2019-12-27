--[[
# docx-apply-cell-styles.lua

Finds table; get list of alignment; get list of styles to apply; apply styles for each cell
]]
local pretty = require("pl.pretty")

local stringify = require("pandoc.utils").stringify
local debug = require("pandocker.utils").debug
local util_get_meta = require("pandocker.utils").util_get_meta

local meta_key = "table-cell-styles"
local meta = {}
local default_meta = require("pandocker.default_loader")[meta_key]
--local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."

if FORMAT == "docx" then

    local function get_meta(mt)
        meta = util_get_meta(mt, default_meta, meta_key)
        return meta
    end

    local function get_header_styles(align)
        local aligns_table = {
            AlignDefault = stringify(meta["header-default"]),
            AlignLeft = stringify(meta["header-left"]),
            AlignCenter = stringify(meta["header-center"]),
            AlignRight = stringify(meta["header-right"]) }
        --debug(aligns_table[align])
        return aligns_table[align]
    end
    local function get_body_styles(align)
        --pretty.dump(meta)
        local aligns_table = {
            AlignDefault = stringify(meta["body-default"]),
            AlignLeft = stringify(meta["body-left"]),
            AlignCenter = stringify(meta["body-center"]),
            AlignRight = stringify(meta["body-right"]) }
        --debug(aligns_table[align])
        return aligns_table[align]
    end
    local function apply_cell_styles(el)
        debug("[ lua ] Apply table styles")
        local aligns = el.aligns
        local headers = el.headers
        local rows = el.rows
        --pretty.dump(aligns)
        local body_styles = {}
        local header_styles = {}
        for i, v in ipairs(aligns) do
            table.insert(body_styles, get_body_styles(v))
            table.insert(header_styles, get_header_styles(v))
        end
        --pretty.dump(body_styles)
        --pretty.dump(header_styles)

        for i, header in ipairs(headers) do
            if header ~= nil then

                local header_cell = pandoc.Div(header)
                header_cell["attr"]["attributes"]["custom-style"] = stringify(header_styles[i])
                el.headers[i] = { header_cell }
                --pretty.dump(header_cell)
            end
        end
        --pretty.dump(headers)

        for i, row in ipairs(rows) do
            for j, cell in ipairs(row) do
                local body_cell = pandoc.Div(cell)
                body_cell["attr"]["attributes"]["custom-style"] = stringify(body_styles[j])
                el.rows[i][j] = { body_cell }
            end
        end
        --pretty.dump(el)
        return el
    end
    return { { Meta = get_meta }, { Table = apply_cell_styles } }
end
