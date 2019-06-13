--[[
Finds Link in listingtable class and get content of the file into a CodeBlock
Guesses included file type and adds to classes
Cuts into subset if corresponding options are set

Link (content, target[, title[, attr] ])
[content](target){.class-1 .class-2 attr=alpha attr=beta #lst:list}
                  |               | | k    v     k   v | |
                  |  classes      | |    attributes    | identifier
]]

local debug = require("pandocker.debugger").debug
local stringify = require("pandoc.utils").stringify

function Link(el)
    debug(stringify(el.content))
    debug(stringify(el.target))
    debug(stringify(el.identifier))
    for _, v in pairs(el.classes) do
        debug(v)
    end
    for k, v in pairs(el.attributes) do
        debug(stringify(k))
        debug(stringify(v))
    end
end
