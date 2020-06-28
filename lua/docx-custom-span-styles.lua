--[[
# docx-custom-span-styles.lua

- Generated by EmmyLua(https://github.com/EmmyLua)
- Created by yamamoto.
- DateTime: 2020/06/29 4:58

## Function

Detects Span in custom class listed in config file and apply custom-styles attribute.

]]

local debug = require("pandocker.utils").debug

local META_KEY = "custom-spans"

local default_meta = require("pandocker.default_loader")[META_KEY]
assert(default_meta)

local meta = {}
local APPLY_DEFAULT = "[ lua ] metadata '%s' was not found in source, applying default %s."
local APPLY = "[ lua ] '%s' class Span found and applied '%s' custom character style"

if FORMAT == "docx" then
    local function get_vars (mt)
        meta = mt[META_KEY]
        if meta == nil then
            meta = default_meta
            debug(string.format(APPLY_DEFAULT, META_KEY, ""))
        end
    end

    local function replace(el)
        for k, v in pairs(meta) do
            if el.classes:includes(k) then
                local style = pandoc.utils.stringify(v)
                el.attributes["custom-style"] = style
                debug(string.format(APPLY, k, style))
            end
        end

        return el
    end

    return { { Meta = get_vars }, { Span = replace } }

end
