--[[
# docx-pagebreak-toc.lua

Finds commands to insert TOC or a page break
Only works for `docx` format

## Syntax

```markdown
<!--Table of Contents-->
\toc

<!--Pagebreak-->
\newpage

```
]]

local stringify = require("pandoc.utils").stringify

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

function toc(el)
    if el.text == "\\toc" then
        if FORMAT == "docx" then
            debug("Table of Contents")
            el.text = RAW_TOC
            el.format = "openxml"
            local para = pandoc.Para({ pandoc.Str("Table"), pandoc.Space(),
                                       pandoc.Str("of"), pandoc.Space(), pandoc.Str("Contents") })
            local div = pandoc.Div({ para, el })
            div["attr"]["attributes"]["custom-style"] = "TOC Heading"
            return div
        else
            --debug("\\toc, not docx")
            return {}
        end
    elseif el.text == "\\newpage" then
        if FORMAT == "docx" then
            debug("Pagebreak")
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

return { { RawBlock = toc } }
