--[[
# docx-pagebreak-toc.lua

Finds commands to insert TOC or a page break
Only works for `docx` format
TOC title is set to "Table of Contents" by default. Metadata `toc-title` overrides this setting.

## Syntax

```markdown
<!--Table of Contents-->
\toc

<!--Pagebreak-->
\newpage

```
]]

--local stringify = require("pandoc.utils").stringify

local debug = require("pandocker.utils").debug

local RAW_TOC = [[
<w:sdt>
    <w:sdtContent xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
        <w:p>
            <w:r>
                <w:fldChar w:fldCharType="begin" w:dirty="true" />
                <w:instrText xml:space="preserve">TOC \o "1-3" \h \z \u</w:instrText>
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
        if FORMAT == "docx" then
            debug("[ lua ] insert Table of Contents")
            el.text = RAW_TOC
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
        if FORMAT == "docx" then
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

return { { Meta = get_vars }, { RawBlock = toc } }
