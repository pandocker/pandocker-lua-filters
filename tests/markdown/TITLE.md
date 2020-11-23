---
heading-unnumbered:
  2: "Heading Unnumbered 1.1"
codeBlockCaptions: true
listingTitle: "List"
listings: true
#rmnote: true
...

\toc

\newpage

:::{.table width=[0.8,0.3]}
Table: table **width** {#tbl:tabls}

| Table | Header |  Row |
|:------|:------:|-----:|
| Cell  |  Cell  | Cell |
:::
\

::: {#fig:tiled-figures width=[0.5,0.5]}
::: {.table noheader=true}

| [Wavedrom(BitField)](data/tutorial_0.json){.wavedrom width=70mm #fig:wavedrom--1} |                                                                                   |
|:---------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------:|
|          [svgbob](data/svgbob.bob){.svgbob width=70mm #fig:wavedrom--3}           | [Wavedrom(BitField)](data/tutorial_0.json){.wavedrom width=70mm #fig:wavedrom--2} |

:::
Tiled figures on a table
:::
\

[**Tiled figures on a table**]{.colored color="FF0000"}

# #include "rest.rst"

[CSV file with caption](data/table.csv){.table}

[Alignment = DLCR](data/table.csv){.table alignment=DLCR}

[Subset table](data/table.csv){.table subset_from=(1,2)}

[Set widths](data/table.csv){.table width=[0.2,0.3,0.2,0.3]}

##### Auto caption

[](data/table.csv){.table}

##### No caption

[](data/table.csv){.table nocaption=true}

[@tbl:table]

## Level2
# Level1 unnumbered {-}
## Level2 unnumbered {-}
##### Level5 unnumbered {-}

<!--# #include "section2.md"-->

::::::{custom-style="Heading Unnumbered 3"}
Level3 *unnumbered*
::::::

:::::{custom-style="Bullet List 1"}
Bullet List 1

:::{custom-style="Bullet List 2"}
Bullet List 2
:::
:::::

[red?]{.red}
[green?]{.green}
[blue?]{.blue}
[foo?]{.default-paragraph-font}

[[@lst:lst]]{.underline}

> Lorem ipsum dolor sit amet, にほんご
>
> > consectetur adipiscing elit, sed do eiusmod
>
> tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
> quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
> Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
> dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,
> sunt in culpa qui officia deserunt mollit anim id est laborum.

[bit.yaml](data/bit.yaml){.bitfield}

#### Level4 unnumbered {-}

<!--# #include "section1.md"-->

[Title](markdown/config.yaml){.listingtable from=2 to=5 #lst:lst}

[Wavedrom(BitField)](data/tutorial_0.json){.wavedrom #fig:wavedrom}

\newpage

[](markdown/config.yaml){.listingtable type=yaml from=2 to=10 nocaption=true}

::: LANDSCAPE

[](data/ditaa.puml){.listingtable type=puml #lst:ditaa-sample}

[](data/ditaa.puml){.listingtable nocaption=true
                    .plantuml #fig:ditaa-sample im_out="img" im_fmt='png' caption="PlantUML x ditaa x imagine"}

:::

[This failes to list](markdown/config.yaml){.listingtable numbers=right type=yaml from=2 to=5 #lst:list}

![dummy](images/dummy.png)

::: LANDSCAPE :::
##### Level5
# #include "section2.md"
:::

~~Strikeout~~ ~~ごはんはおかず~~
