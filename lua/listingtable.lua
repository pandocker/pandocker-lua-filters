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
        local listing_file = stringify(el.target)
        local lines = {}
        -- test if file exists
        if require("pandocker.utils").file_exists(listing_file) then

            --convert file contents to list of strings
            for line in io.lines(listing_file) do
                lines[#lines + 1] = line
            end
        else
            debug("Failed to open " .. el.target)
            return nil
        end
        local caption = pandoc.Str(stringify(el.content))
        local file_type = el.attributes["type"] or "plain"
        local linefrom = tonumber(el.attributes["from"]) or 1
        if linefrom < 1 then
            linefrom = 1
        end

        local lineto = tonumber(el.attributes["to"]) or #lines
        if tonumber(lineto) > #lines then
            lineto = #lines
        end
        for k, v in pairs(el.attributes) do
            if v == "type" or v == "from" or v == "to" then
                table.remove(el.attributes, k)
            end
        end
        local data = table.concat(lines, "\n", linefrom, lineto)
        --debug(data)

        if el.attributes["startFrom"] == nil then
            el.attributes["startFrom"] = linefrom
        end
        if el.attributes["numbers"] == nil then
            el.attributes["numbers"] = "left"
        end
        local _, basename = require("pandocker.utils").basename(listing_file)
        local idn = el.identifier
        if idn == "" then
            idn = "#lst:" .. string.gsub(basename, "%.", "_")
        end

        --el.identifier or tostring("#lst:" .. string.gsub(basename, "%.", "_"))
        --debug(idn)
        local classes = { file_type, }
        local attr = pandoc.Attr(idn, el.classes, el.attributes)
        local raw_code = pandoc.CodeBlock(data, attr)

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
