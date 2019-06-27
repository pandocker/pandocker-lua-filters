local debug = require("pandocker.utils").debug
local stringify = require("pandoc.utils").stringify
local default_meta = require("pandocker.default_loader")["lgeometry"]
local _meta = {}
--[[
\newcommand{\Startlandscape}{\newgeometry{$lgeometry$}\begin{landscape}}
\newcommand{\Stoplandscape}{\end{landscape}\restoregeometry}

def action(self, elem, doc):
    if isinstance(elem, pf.Div) and "LANDSCAPE" in elem.classes:
        if doc.format in ["latex"]:
            pf.debug("LANDSCAPE")
            elem.content.insert(0, pf.RawBlock("\\Startlandscape", format="latex"))
            elem.content.append(pf.RawBlock("\\Stoplandscape", format="latex"))
            # pf.debug(elem)
        ret = elem
        return ret
]]
local start_landscape = ""
local stop_landscape = pandoc.RawBlock("latex", "\\end{landscape}\\restoregeometry")

local function dump(tt, mm)
    for ii, vv in ipairs(tt) do
        print(mm .. ii .. " " .. tostring(vv["tag"]) .. "(" .. stringify(vv) .. ")")
    end
end

function get_vars (meta)
    if FORMAT == "latex" then
        _meta = meta["lgeometry"]
        if _meta == nil then
            _meta = default_meta
            debug("metadata 'lgeometry' was not found in source, applying defaults.")
        end
        start_landscape = pandoc.RawBlock("latex", "\\newgeometry{" .. stringify(_meta) .. "}\\begin{landscape}")
    end
end

function landscape(el)
    if el.classes:find("LANDSCAPE") then
        debug("Div in 'LANDSCAPE' class found")
        table.insert(el.content, 1, start_landscape)
        table.insert(el.content, stop_landscape)
        --dump(el.content, "  ")
        return el
    end

end
return { { Meta = get_vars }, { Div = landscape } }
