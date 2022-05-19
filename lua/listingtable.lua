--[[
# listingtable.lua

Finds Link in `listingtable` class and get the file content into a CodeBlock
Guesses included file type and adds to classes
Cuts into subset if corresponding options are set

## Syntax

```markdown
[Caption](/path/to/file){.listingtable <attributes>}
```

### Attributes

- `from`
- `startFrom`
- `to`
- `type`
- `numbers`
- `nocaption`

## Note

| Link (content, target[, title[, attr] ])
| [content](target){.class-1 .class-2 attr=alpha attr=beta #lst:list}
|                   |               | | k    v     k   v | |
|                   |  classes      | |    attributes    | identifier
|                   .listingtable     type=plain numbers=left from=5 to=10
]]

local tablex = require("pl.tablex")

local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug
local get_tf = require("pandocker.utils").get_tf

local function listingtable(el)
    --[[
        debug(FORMAT)
        debug(stringify(el.content))
        debug(stringify(el.target))
        debug(stringify(el.identifier))
    ]]

    if el.classes:includes "listingtable" then
        if tostring(PANDOC_VERSION) == "2.15" then
            debug("[ Lua ] " .. PANDOC_SCRIPT_FILE .. ": Pandoc version 2.15 is not supported. Bypassing.")
            return
        end
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
            debug(string.format("[ lua ] listing %s", listing_file))
        else
            debug("Failed to open " .. el.target)
            return
        end
        local caption = pandoc.Str(stringify(el.content))
        local file_type = el.attributes["type"] or "plain"
        local nocaption = get_tf(el.attributes.nocaption, false)
        local linefrom = tonumber(el.attributes["from"]) or 1
        if linefrom < 1 then
            linefrom = 1
        end

        local lineto = tonumber(el.attributes["to"]) or #lines
        if tonumber(lineto) > #lines then
            lineto = #lines
        end
        local attributes = {}
        for k, v in pairs(el.attributes) do
            if not tablex.search({ "type", "from", "to", "nocaption" }, k) then
                attributes[k] = v
            end
        end
        attributes["startFrom"] = el.attributes["startFrom"] or linefrom
        attributes["numbers"] = el.attributes["numbers"] or "left"

        local data = table.concat(lines, "\n", linefrom, lineto)
        --debug(data)
        local _, basename = require("pandocker.utils").basename(listing_file)
        local idn = el.identifier
        if idn == "" then
            idn = "lst:" .. string.gsub(basename, "%.", "_")
        end
        --debug(idn)

        el.classes:extend { file_type, "numberLines" }
        local attr = pandoc.Attr(idn, el.classes, attributes)
        local raw_code = pandoc.CodeBlock(data, attr)

        --[[
                debug(stringify(caption))
                debug(file_type)
                debug(linefrom)
                debug(lineto)
                debug(startFrom)
                debug(numbers)
        ]]

        local para = { raw_code }
        if not nocaption then
            table.insert(para, 1, pandoc.Para({ pandoc.Str("Listing:"), pandoc.Space(), caption }))
        end
        --debug(stringify(para))
        return para
    end
end

function Para(el)
    if #(el.content) == 1 then
        el = el.content[1]
        if el.tag == "Link" then
            --debug("Para content is a Link")
            return listingtable(el)
        end
    end
end
