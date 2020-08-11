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

local meta_key = "bullet-style"
local meta = {}
local default_meta = require("pandocker.default_loader")[meta_key]
assert(default_meta)
local max_depth = 3

if FORMAT == "docx" then
    local depth = 0

    local function get_meta(mt)
        meta = util_get_meta(mt, default_meta, meta_key)
        --debug(stringify(meta))
    end

    local function extract(el)
        for i, v in ipairs(el.content) do
            for _, e in ipairs(v) do
                if e.tag == "BulletList" then
                    depth = depth + 1
                    extract(e)
                    depth = depth - 1
                else
                    if depth >= max_depth then
                        style = meta[tostring(max_depth)]
                        --debug(stringify(meta[tostring(max_depth)]))
                    else
                        style = meta[tostring(depth)]
                        --debug(stringify(meta[tostring(depth)]))
                    end
                    bullet = pandoc.Div(e)
                    bullet["attr"]["attributes"]["custom-style"] = stringify(style)

                    table.insert(bl, bullet)
                    debug(depth .. " " .. e.tag .. " " .. stringify(e))
                end
            end
        end
    end

    local function Pandoc(doc)
        local head = {}
        local tail = {}

        for i, el in ipairs(doc.blocks) do
            bl = {}
            if el.tag == "BulletList" then
                --doc.blocks[i] = pandoc.Null()
                depth = depth + 1
                extract(el)
                depth = depth - 1
                --debug(stringify(bl))
            end
        end
        return doc
    end

    return { { Meta = get_meta }, { Pandoc = Pandoc } }
end
