# pandocker-lua-filters

Lua filters for pandoc

## Install

- installs as a python package for ease of use
    - `pip install pandocker-lua-filters`
- lua filters should be installed under `<sys.prefix>/share/lua/5.3/pandocker` where
  `<sys.prefix>` can be confirmed by `python -c "import sys; print(sys.prefix)"`.
  This `<sys.prefix>/share/lua/5.3` should be added to `package.path` which can be confirmed
  by `lua -e "print(package.path)"`

## General use

#### Convert AAFigure ascii art

- requires `aafigure` python package

[**`aafigure.lua`**](lua/aafigure.lua)

#### Convert CSV into table

- requires `csv` and `penlight` luarocks packages

[**`csv2table.lua`**](lua/csv2table.lua)

#### Replace `title` `subtitle` `date` `author` metadata

[**`hide-frontpage-metadata`**](lua/hide-frontpage-metadata.lua)

#### Text file listing

- requires `penlight` luarocks package

[**`listingtable.lua`**](lua/listingtable.lua)

#### Concatenate text files

[**`preprocess.lua`**](lua/preprocess.lua)

#### Removable note block

[**`removable-note.lua`**](lua/removable-note.lua)

#### Convert svgbob ascii art

[**`svgbob.lua`**](lua/svgbob.lua)

#### Convert SVG images to other formats

- requires `rsvg-convert` in `$PATH`

[**`svgconvert.lua`**](lua/svgconvert.lua)

#### Applies table attributes to a table

- requires `penlight` luarocks package

[**`table-width.lua`**](lua/table-width.lua)

#### Wavedrom / Bit-Field

- requires `wavedrom-cli` in `$PATH` (`npm i -g wavedrom-cli`)
- requires `lyaml` and `lua-cjson2` luarocks packages

[**`wavedrom.lua`**](lua/wavedrom.lua)

## *LaTeX* output only

#### Landscape pages

[**`tex-landscape.lua`**](lua/tex-landscape.lua)

<!--
#### Reset table coloring

[**`tex-rowcolors-reset`**](lua/tex-rowcolors-reset.lua)
-->

#### Applies underline to `.underline` class span

[**`tex-underline.lua`**](lua/tex-underline.lua)

## *Docx* output only

#### Inserts a comment

[**`docx-comment.lua`**](lua/docx-comment.lua)

#### Apply custom (paragraph) styles for each table cell

[**`docx-apply-cell-styles.lua`**](lua/docx-apply-cell-styles.lua)

#### Apply custom (paragraph) styles for image and its caption

[**`docx-image-styles.lua`**](lua/docx-image-styles.lua)

#### Apply custom (character) styles for any span

[**`docx-custom-span-styles.lua`**](lua/docx-custom-span-styles.lua)

#### Apply in-place color for any span

[**`docx-colored-span.lua`**](lua/docx-colored-span.lua)

#### Apply custom (paragraph) styles for any unnumbered bullet lists

Finds unnumbered bullet lists down to 3rd level and applies custom paragraph styles.
**4th level and lower list items are escalated to 3rd level**.

[**`docx-extract-bullet-lists.lua`**](lua/docx-extract-bullet-lists.lua)

##### Requirement for template

- Prepare `Bullet List 1` to `Bullet List 3` paragraph styles (by the way this is 1st level list item)
    - Otherwise these headers inherit `Body` style (this is 2nd level)

| Level | Unnumbered    |
|:-----:|:--------------|
|   1   | Bullet List 1 |
|   2   | Bullet List 2 |
|  3+   | Bullet List 3 |

#### TOC / Pagebreak / Linebreak

[**`docx-pagebreak-toc.lua`**](lua/docx-pagebreak-toc.lua)

- Adds TOC(Table Of Contents), a line break or a page break at any point of document

##### Requirement for template

TOC title is set to "Table of Contents" by default. Metadata `toc-title` overrides this setting.

#### Appendix headings

[**`docx-appendixheadings.lua`**](lua/docx-appendixheadings.lua)

- Makes `appendix` class work to _appendix_ headings in DOCX format
- Limited to level-1 to 5 headings

##### Requirement for template

- Prepare `Appendix Heading 1` to `Appendix Heading 5` heading styles
    - Otherwise these headers inherit `Body` style

| Level | Numbered  | Unnumbered         |
|:-----:|:----------|:-------------------|
|   1   | Heading 1 | Appendix Heading 1 |
|   2   | Heading 2 | Appendix Heading 2 |
|   3   | Heading 3 | Appendix Heading 3 |
|   4   | Heading 4 | Appendix Heading 4 |
|   5   | Heading 5 | Appendix Heading 5 |
|   6   | Heading 6 |                    |

#### Unnumbered headings

[**`docx-unnumberedheadings.lua`**](lua/docx-unnumberedheadings.lua)

- Makes `UnnumberHeadings` class work to _unnumber_ headings in DOCX format
- Limited to level-1 to 5 headings

##### Requirement for template

- Prepare `Heading Unnumbered 1` to `Heading Unnumbered 5` heading styles
    - Otherwise these headers inherit `Body` style

| Level | Numbered  | Unnumbered           |
|:-----:|:----------|:---------------------|
|   1   | Heading 1 | Heading Unnumbered 1 |
|   2   | Heading 2 | Heading Unnumbered 2 |
|   3   | Heading 3 | Heading Unnumbered 3 |
|   4   | Heading 4 | Heading Unnumbered 4 |
|   5   | Heading 5 | Heading Unnumbered 5 |
|   6   | Heading 6 |                      |

#### Figure styles

[**`docx-image-styles.lua`**](lua/docx-image-styles.lua)

- Processes only paragraph having single image link
    - Blank lines required before and after image link
- Requires `Graphic Anchor` and `Figure Caption` paragraph styles in template
  otherwise these styles inherit `Body` style
    - the filter creates two divs having `custom-style` attribute
    - after process the image is placed in `custom-style="Graphic Anchor"` div and its caption is
      in `custom-style="Figure Caption"`
      div respectively

##### Requirement for template

- Prepare `Graphic Anchor` and `Figure Caption` styles

# samples

```markdown
![Centered image](https://github.com/pandocker/pandoc-docx-utils-py/raw/master/qr.png){width=100mm #fig:centered}
```

## Want a new feature?

Feature request (via issues) and PRs are welcome. Post questions in issues with `[Q]` in issue title.

### DIY

As lua filters only requires pandoc itself, it is relatively easy
to try develop a new filter. I recommend to use `k4zuki/pandocker-alpine`
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

You don't have to `reinstall` for every source code updates. Instead edit `tests/Makefile`
to run your new filter from inside repository.
