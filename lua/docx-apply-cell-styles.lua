--[[
# docx-apply-cell-styles.lua

Finds table; get list of alignment; get list of styles to apply; apply styles for each cell
]]
--local pretty = require("pl.pretty")

local stringify = require("pandoc.utils").stringify
local debug = require("pandocker.utils").debug
local util_get_meta = require("pandocker.utils").util_get_meta

local meta_key = "table-cell-styles"
local meta = {}
local default_meta = require("pandocker.default_loader")[meta_key]

local tablex = require("pl.tablex")

MESSAGE = "[ lua ] Apply table cell styles"

if FORMAT == "docx" then

    local function get_meta(mt)
        meta = util_get_meta(mt, default_meta, meta_key)
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

    local function plain2para(el)
        --pretty.dump(el.content)
        --pretty.dump(el.tag)
        if el.tag == "Plain" then
            el = pandoc.Para(el.content)
        end
        return el
    end

    local function get_aligns(el)
        local aligns = {}
        for _, v in ipairs(el.colspecs) do
            table.insert(aligns, v[1])
        end
        return aligns
    end

    local function get_headers(el)
        local headers = {}
        headers = el.head
        return headers
    end

    local function get_body_rows(el)
        local rows = {}
        rows = el.bodies[1].body
        return rows
    end

    local function apply_rows_styles(rows, styles)
        local row_attr = {}
        local _cell = {}
        --local rows_attr = rows[1]
        --rows = rows[2]
        for i, row in ipairs(rows) do
            if tablex.find(tablex.keys(row), "cells") ~= nil then
                -- pandoc >= 2.17
                row_attr = row.attr
                row = row.cells
            else
                -- pandoc < 2.17
                row_attr = row[1]
                row = row[2]
            end
            --debug(tostring(tablex.deepcompare(empty_attr, row_attr)))
            for j, cell in ipairs(row) do
                --pretty.dump(cell.contents)
                _cell = pandoc.Div(cell.contents)
                _cell["attr"]["attributes"]["custom-style"] = stringify(styles[j])
                cell.contents = { _cell }
                row[j] = cell
            end
            rows[i] = { row_attr, row }
        end
        return rows
    end

    local function apply_header_styles(header, styles)
        local headers
        local header_attr = nil
        if tablex.find(tablex.keys(header), "rows") ~= nil then
            -- pandoc >= 2.17
            header_attr = header.attr
            headers = header.rows
            header.rows = apply_rows_styles(headers, styles)
            return header
        else
            --debug("header[1]." .. tostring(tablex.keys(header[1])))
            -- pandoc < 2.17
            header_attr = header[1]
            headers = header[2]
            header = apply_rows_styles(headers, styles)
            return { header_attr, header }
        end
    end

    local function apply_cell_styles(el)
        debug(MESSAGE)
        local aligns = get_aligns(el)
        local headers = get_headers(el)
        local rows = get_body_rows(el)
        --pretty.dump(aligns)
        local body_styles = {}
        local header_styles = {}
        for _, v in ipairs(aligns) do
            table.insert(body_styles, get_body_styles(v))
            table.insert(header_styles, get_header_styles(v))
        end
        --pretty.dump(body_styles)
        --pretty.dump(header_styles)
        el.head = apply_header_styles(headers, header_styles)
        rows = apply_rows_styles(rows, body_styles)

        return el
    end

    local function apply_simple_cell_styles(el)
        debug(MESSAGE)
        local body_styles = {}
        local header_styles = {}
        for _, v in ipairs(el.aligns) do
            table.insert(body_styles, get_body_styles(v))
            table.insert(header_styles, get_header_styles(v))
        end
        for i, header in ipairs(el.headers) do
            if #header > 0 then
                local header_cell = pandoc.Div(header)
                header_cell["attr"]["attributes"]["custom-style"] = stringify(header_styles[i])
                el.headers[i] = { header_cell }
            end
        end

        for i, row in ipairs(el.rows) do
            for j, cell in ipairs(row) do
                --cell = plain2para(cell)
                local body_cell = pandoc.Div(cell)
                body_cell["attr"]["attributes"]["custom-style"] = stringify(body_styles[j])
                el.rows[i][j] = { body_cell }
            end
        end
        return el
    end

    local function version_switch (el)
        -- apply plein2para() for each Plain in el
        el = pandoc.walk_block(el, { Plain = plain2para })
        if PANDOC_VERSION < { 2, 10 } then
            return apply_simple_cell_styles(el)
        else
            return apply_cell_styles(el)
        end
    end
    return { { Meta = get_meta }, { Table = version_switch } }

end

