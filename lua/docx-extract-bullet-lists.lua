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

--local stringify = require("pandoc.utils").stringify

--local pretty = require("pl.pretty")

local debug = require("pandocker.utils").debug

local default_meta = require("pandocker.default_loader")["bullet-style"]
assert(default_meta)

local meta = {}
local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."

if FORMAT == "docx" then
    local function get_vars (mt)
        meta = mt["bullet-style"]
        if meta ~= nil then
            for k, v in pairs(default_meta) do
                if meta[k] == nil then
                    meta[k] = v
                    local d = pandoc.utils.stringify(mt["bullet-style"][k])
                    debug(string.format(NOT_FOUND, "bullet-style." .. k, d))
                end
            end
        else
            meta = default_meta
            debug(string.format(NOT_FOUND, "bullet-style", ""))
            --debug("metadata 'heading-unnumbered' was not found in source, applying defaults.")
        end
    end

    return { { Meta = get_vars }
        --, { Header = replace }
    }
end
