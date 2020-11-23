--[[
tex-quote.lua
]]

local debug = require("pandocker.utils").debug

local begin_env = pandoc.Para(pandoc.RawInline("latex", "\\begin{mdframed}[skipabove=3pt,hidealllines=true,leftline=true,linewidth=2pt]"))
local end_env = pandoc.Para(pandoc.RawInline("latex", "\\end{mdframed}"))

if FORMAT == "latex" then
    function BlockQuote(el)
        debug("[ lua ] BlockQuote found")
        --debug(pandoc.utils.stringify(el))
        table.insert(el.content, 1, begin_env)
        table.insert(el.content, #el.content + 1, end_env)

        return pandoc.Div(el.content)
    end
    return { { BlockQuote = BlockQuote } }
end
