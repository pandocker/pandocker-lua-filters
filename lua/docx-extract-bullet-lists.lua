--[[
# docx-extract-bullet-lists.lua

Finds and converts all bullet lists into Divs in certain styles
Level-4 and deeper level items are promoted to level-3

## Syntax
```markdown
# Inputs

- Level1
  - Level2
    - Level3
      - Level4


# Equivalent outputs

:::{custom-style="Bullet List 1"}
Level1
:::

:::{custom-style="Bullet List 2"}
Level2
:::

:::{custom-style="Bullet List 3"}
Level3
:::

:::{custom-style="Bullet List 3"}
Level4
:::
```
]]

local stringify = require("pandoc.utils").stringify

--local pretty = require("pl.pretty")

local debug = require("pandocker.utils").debug
local util_get_meta = require("pandocker.utils").util_get_meta

local META_KEY = "bullet-style"
local meta = {}
local MAX_DEPTH = 3
local TOO_DEEP = "[ lua ] Listed item found at too deep level. Promote to level-%d."

local default_meta = require("pandocker.default_loader")[META_KEY]
assert(default_meta)

if FORMAT == "docx" then

    local function get_meta(mt)
        meta = util_get_meta(mt, default_meta, META_KEY)
        --debug(stringify(meta))
    end

    local function get_style(depth)
        local style = ""
        if depth > MAX_DEPTH then
            style = meta[tostring(MAX_DEPTH)]
            debug(string.format(TOO_DEEP, MAX_DEPTH))
            --debug(stringify(meta[tostring(max_depth)]))
        else
            style = meta[tostring(depth)]
            --debug(stringify(meta[tostring(depth)]))
        end
        return style
    end

    local function combine_para_plain(paras, depth)
        local _content = {}
        for idx, para in ipairs(paras) do
            table.insert(_content, para.content)
            if idx ~= #paras then
                table.insert(_content, {})
            end
        end

        bullet = pandoc.Div({ pandoc.LineBlock(_content) })
        bullet["attr"]["attributes"]["custom-style"] = stringify(get_style(depth))
        table.insert(bl, bullet)
    end

    local function extract_bullet_list(el, depth)
        local paras = {}
        local style = get_style(depth)

        for _, blocks in ipairs(el.content) do
            --debug(depth .. ", " .. #v .. ", " .. stringify(v))
            for idx, block in ipairs(blocks) do
                if block.tag ~= "Para" and block.tab ~= "Plain" then
                    combine_para_plain(paras, depth)
                    paras = {}
                    if block.tag == "BulletList" then
                        extract_bullet_list(block, depth + 1)
                    else
                        bullet = pandoc.Div(block)
                        bullet["attr"]["attributes"]["custom-style"] = stringify(style)
                        table.insert(bl, bullet)
                    end
                else
                    table.insert(paras, block)
                    if idx == #blocks then
                        combine_para_plain(paras, depth)
                        paras = {}
                    end
                    --debug(depth .. " " .. e.tag .. " " .. stringify(e))
                end
            end
        end
    end

    local function bulletlist_to_divs(doc)
        local head = {}
        local tail = {}

        for i, el in ipairs(doc.blocks) do
            bl = {}
            if el.tag == "BulletList" then
                debug("[ lua ] Bullet list found")
                extract_bullet_list(el, 1)
                table.move(doc.blocks, 1, i - 1, 1, head) -- head has contents before BulletList
                table.move(doc.blocks, i + 1, #doc.blocks, 1, tail) -- tail has after BulletList
                table.move(bl, 1, #bl, #head + 1, head) -- concat head and bl -> head
                table.move(tail, 1, #tail, #head + 1, head) -- concat head and tail
                doc.blocks = head
                return bulletlist_to_divs(doc)
                --debug(stringify(bl))
            end
        end
        return doc
    end

    return { { Meta = get_meta }, { Pandoc = bulletlist_to_divs } }
end
