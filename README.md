# pandocker-lua-filters
Lua filters for pandoc

## Install

`pip install git+https://github.com/pandocker/pandocker-lua-filters.git`

## General use
#### Concatenate text files

[**`preprocess.lua`**](lua/preprocess.lua)

#### Text file listing

[**`listingtable.lua`**](lua/listingtable.lua)

#### Removable note block

[**`removable-note.lua`**](lua/removable-note.lua)

#### Convert SVG images to other formats

- requires `rsvg-convert` in `$PATH`

[**`svgconvert.lua`**](lua/svgconvert.lua)

#### Wavedrom / Bit-Field

- requires `wavedrom` python package

[**`wavedrom.lua`**](lua/wavedrom.lua)

<!--
#### convert CSV into table

- requires `lua-csv` luarocks package

[**`csv2table.lua`**](lua/csv2table.lua)
-->

## *LaTeX* output only
#### Landscape pages

[**`tex-landscape.lua`**](lua/tex-landscape.lua)

#### Reset table coloring

[**`tex-rowcolors-reset`**](lua/tex-rowcolors-reset.lua)

## *Docx* output only
#### unnumbered headings

[**`docx-unnumberedheadings.lua`**](lua/docx-unnumberedheadings.lua)

- Makes `UnnumberHeadings` class work to _unnumber_ headings in DOCX format
- Limited to level-1 to 4 headings

##### Requirement for template

- Prepare `Heading Unnumbered 1` to `Heading Unnumbered 4` heading styles
  - otherwise these headers appear in `Body` style

| Level | Numbered  | Unnumbered           |
|:-----:|:----------|:---------------------|
|   1   | Heading 1 | Heading Unnumbered 1 |
|   2   | Heading 2 | Heading Unnumbered 2 |
|   3   | Heading 3 | Heading Unnumbered 3 |
|   4   | Heading 4 | Heading Unnumbered 4 |
|   5   | Heading 5 |                      |

<!--
#### centering images

- an image link in paragraph will be centered
- blank lines required before and after image link
- Requires `Centered` paragraph style in template otherwise no effect can be seen

##### Requirement for template
-->

#### TOC / Pagebreak

[**`docx-pagebreak-toc.lua`**](lua/docx-pagebreak-toc.lua)

- Adds TOC(Table Of Contents) or a pagebreak at any point of document

# samples

```markdown
![Centered image](https://github.com/pandocker/pandoc-docx-utils-py/raw/master/qr.png){width=100mm #fig:centered}
```

## Want a new feature?

Feature request (via issues) and PRs are welcome. Post questions in issues with `[Q]` in issue title.

### DIY

As lua filters only requires pandoc itself, it is relatively easy
to try develop a new filter. I recommend to use `k4zuki/pandocker`
*docker image* like

- `docker pull k4zuki/pandocker-alpine` to get image
- clone this repo `git clone git@github.com:pandocker/pandocker-lua-filters.git`
- `cd pandocker-lua-filters`
- `docker run --rm -it -v/$PWD:/workdir k4zuki/pandocker-alpine` to start docker image
- `make install` to install filters in image. They are installed in `/usr/local/share/lua/5.3/pandocker/`
- `make reinstall` to *reinstall* so that filters will be updated
- `make uninstall` to uninstall filters
- `make html|pdf|docx` to compile test document
- edit `tests/Makefile` to configure options for pandoc

You dont have to `reinstall` for every source code updates. Instead edit `tests/Makefile`
to run your new filter from inside repository.
