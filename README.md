# pandocker-lua-filters
Lua filters for pandoc

Experimental set of pandoc filters to output DOCX file

## General use
### Fills required metadata if not prepared

Use default metadata field if it hasn't been defined yet.

[**`default_loader.lua`**](lua/default_loader.lua)

### Text file listing

[**`listingtable.lua`**](lua/listingtable.lua)

## *LaTeX* output only
### Landscape pages

[**`tex-landscape.lua`**](lua/tex-landscape.lua)

## *Docx* output only
### unnumbered headings

[**`docx-unnumberedheadings.lua`**](lua/docx-unnumberedheadings.lua)

* Makes `UnnumberHeadings` class work to _unnumber_ headings in DOCX format
* Limited to level-1 to 4 headings

#### Requirement for template

* Prepare `Heading Unnumbered 1` to `Heading Unnumbered 4` heading styles
  * otherwise these headers appear in `Body` style

| Level | Numbered  | Unnumbered           |
|:-----:|:----------|:---------------------|
|   1   | Heading 1 | Heading Unnumbered 1 |
|   2   | Heading 2 | Heading Unnumbered 2 |
|   3   | Heading 3 | Heading Unnumbered 3 |
|   4   | Heading 4 | Heading Unnumbered 4 |
|   5   | Heading 5 |                      |

### centering images

* an image link in paragraph will be centered
* blank lines required before and after image link
* Requires `Centered` paragraph style in template otherwise no effect can be seen

#### Requirement for template

# samples

```markdown
![Centered image](https://github.com/pandocker/pandoc-docx-utils-py/raw/master/qr.png){width=100mm #fig:centered}
```
