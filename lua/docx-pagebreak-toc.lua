--[[
# docx-pagebreak-toc.lua

Finds commands to insert TOC, sub section TOC, line break or a page break
Only works for `docx` format
TOC title is set to "Table of Contents" by default. Metadata `toc-title` overrides this setting.

## Syntax

```markdown
<!--Table of Contents-->
\toc

<!--Pagebreak-->
\newpage

<!--Linebreak-->
<br>

<!--Sub section TOC of a numbered Header-->
# Level1 header {.subsection-toc}

```
]]

--local stringify = require("pandoc.utils").stringify
--local pretty = require("pl.pretty")

local debug = require("pandocker.utils").debug
local strip = require("pl.stringx").strip

local RAW_TOC_TEMPLATE = [[
<w:sdt>
    <w:sdtContent xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
        <w:p>
            <w:r>
                <w:fldChar w:fldCharType="begin" w:dirty="true" />
                <w:instrText xml:space="preserve">%s</w:instrText>
                <w:fldChar w:fldCharType="separate" />
                <w:fldChar w:fldCharType="end" />
            </w:r>
        </w:p>
    </w:sdtContent>
</w:sdt>
]]
local RAW_PAGEBREAK = "<w:p><w:r><w:br w:type=\"page\" /></w:r></w:p>"
local NOT_FOUND = "[ lua ] metadata '%s' was not found in source, applying default %s."

local meta_key = "toc-title"
local default_meta = require("pandocker.default_loader")[meta_key]

local function get_vars (mt)
    meta = mt[meta_key]
    if meta ~= nil and meta.tag == "MetaInlines" then
        meta = { table.unpack(meta) }
    else
        meta = { table.unpack(default_meta) }
        debug(string.format(NOT_FOUND, meta_key, "")
        )
    end
end

local function toc(el)
    if el.text == "\\toc" then
        if FORMAT == "docx" or FORMAT == "native" then
            debug("[ lua ] insert Table of Contents")
            el.text = string.format(RAW_TOC_TEMPLATE, [[TOC \o "1-3" \h \z \u]])
            el.format = "openxml"
            local para = pandoc.Para(meta)
            local div = pandoc.Div({ para, el })
            div["attr"]["attributes"]["custom-style"] = "TOC Heading"
            return div
        else
            --debug("\\toc, not docx")
            return {}
        end
    elseif el.text == "\\newpage" then
        if FORMAT == "docx" or FORMAT == "native" then
            debug("[ lua ] insert a Pagebreak")
            el.text = RAW_PAGEBREAK
            el.format = "openxml"
            return el
        elseif FORMAT ~= "latex" then
            --debug("\\newpage, not docx nor latex")
            return {}
        end
    end
    --elseif FORMAT == "latex" then
end

local function linebreak(el)

    local text = strip(el.text)
    --debug('"' .. el.text .. '", "' .. text .. '"')
    if text == "<br>" then
        if FORMAT == "docx" or FORMAT == "native" then
            debug("[ lua ] insert a LineBreak")
            el = pandoc.LineBreak()
            return el
        end
    end
end

local function subsection_toc(el)
    if FORMAT == "docx" or FORMAT == "native" then
        if el.level == 1 then
            if el.classes:find("subsection-toc") then
                local id = el.identifier
                debug("[ lua ] insert subsection TOC for #" .. id)
                local subsectoc = string.format(RAW_TOC_TEMPLATE, [[TOC \o "2-2" \h \b ”]] .. id .. [[” \u]])
                return { el, pandoc.RawBlock("openxml", subsectoc) }
            end
        end
    end

end

return { { Meta = get_vars }, { RawBlock = toc }, { RawInline = linebreak }, { Header = subsection_toc } }
