---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yamamoto.
--- DateTime: 2019-06-29 00:54

local debug = require("pandocker.utils").debug
local stringify = require("pandoc.utils").stringify

local raw_toc = [[
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

function toc(el)
    if el.text == "\\toc" then
        if FORMAT == "docx" then
            debug("Table of Contents")
            el.text = raw_toc
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
            el.text = "<w:p><w:r><w:br w:type=\"page\" /></w:r></w:p>"
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
