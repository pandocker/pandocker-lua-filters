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

local debug = require("pandocker.utils").debug
local stringify = require("pandoc.utils").stringify

function Para(el)
    if #(el.content) == 1 then
        sub_el = el.content[1]
        if sub_el.tag == "Link" then
            --debug("Para content is a Link")
            local newp = listingtable(sub_el)
            return newp
        end
    end
end

function listingtable(el)
    --[[
        debug(FORMAT)
        debug(stringify(el.content))
        debug(stringify(el.target))
        debug(stringify(el.identifier))
    ]]

    if el.classes:includes "listingtable" then
        debug("link in 'listingtable' class")
        if stringify(el.content) == "" then
            el.content = el.target
        end
        local listing_file = io.open(stringify(el.target), "r")
        local data = ""
        if listing_file == nil then
            debug("Failed to open " .. el.target)
            return
        else
            data = listing_file:read("*a")
            listing_file:close()
        end
        local caption = pandoc.Str(stringify(el.content))
        local file_type = el.attributes["type"] or "plain"

        local linefrom = el.attributes["from"] or 1
        local lineto = el.attributes["to"] or -1
        if tonumber(lineto) > #data then
            lineto = #data
        end

        local startFrom = el.attributes["startFrom"] or 1
        local numbers = el.attributes["numbers"] or "left"
        local raw_code = pandoc.CodeBlock(data)

        --[[
                debug(stringify(caption))
                debug(file_type)
                debug(linefrom)
                debug(lineto)
                debug(startFrom)
                debug(numbers)
        ]]

        local para = { pandoc.Para({ pandoc.Str("Listing:"), pandoc.Space(), caption }),
                       raw_code }
        --debug(stringify(p))
        return para
    end
    --[[
        for v in ipairs(el.classes) do
            debug(v)
        end
        for k, v in pairs(el.attributes) do
            debug(stringify(k))
            debug(stringify(v))
        end
    ]]

end
