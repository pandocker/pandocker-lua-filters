--[[
Finds Link in listingtable class and get content of the file into a CodeBlock
Guesses included file type and adds to classes
Cuts into subset if corresponding options are set

Link (content, target[, title[, attr] ])
[content](target){.class-1 .class-2 attr=alpha attr=beta #lst:list}
                  |               | | k    v     k   v | |
                  |  classes      | |    attributes    | identifier
                  .listingtable     type=plain numbers=left from=5 to=10
]]

local debug = require("pandocker.debugger").debug
local stringify = require("pandoc.utils").stringify

function Link(el)
    debug(FORMAT)
    debug(stringify(el.content))
    debug(stringify(el.target))
    debug(stringify(el.identifier))
    if el.classes:includes "listingtable" then
        debug("link in 'listingtable' class")
        if stringify(el.content) == "" then
            el.content = el.target
        end
        file = io.open(stringify(el.target), "r")
        if file == nil then
            debug("failed to open " .. el.target)
        else
            data = file.read()
            file:close()
        end
        local caption = pandoc.Str(stringify(el.content))
        debug(stringify(caption))
        local file_type = el.attributes["type"] or "plain"
        local linefrom = el.attributes["from"] or 0
        local lineto = el.attributes["to"] or 0
        local startFrom = el.attributes["startFrom"] or 1
        local numbers = el.attributes["numbers"] or "left"
        debug(file_type)
        debug(linefrom)
        debug(lineto)
        debug(startFrom)
        debug(numbers)
        local p = pandoc.Para({ pandoc.Str("Listing:"), pandoc.Space(), caption })
        debug(stringify(p))
        return p
    end
    --[[
        for _, v in pairs(el.classes) do
            debug(v)
        end
        for k, v in pairs(el.attributes) do
            debug(stringify(k))
            debug(stringify(v))
        end
    ]]

end
