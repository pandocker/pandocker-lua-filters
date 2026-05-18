\toc

\newpage

# Section {.subsection-toc}

text<br><br>text
text

| head [a](b.txt){.class a1=b a2=c} |
|-----------------------------------|
| cell                              |

## Table header contains<br>linebreak

```{.haskell}
main :: IO ()
main = putStrLn "Hello World!"
```

[Title](markdown/config.yaml){.listingtable type=yaml numbers=true from=2 to=15 #lst:lst-1}

[Title](markdown/config.yaml){.listingtable type=yaml numbers=true from=2 #lst:lst-2}

[`.python` will be considered as plain](../setup.py){.listingtable type=python numbers=true #lst:lst-3}

\newpage

+---------------------------------------+
|:::  {.listing #lst:code1 from=1 to=2} |
|<p>Code Block Caption</p>              |
|```{.haskell from=1 to=2}              |
|main :: IO ()                          |
|main = putStrLn "Hello World!"         |
|```                                    |
|:::                                    |
+---------------------------------------+

## Autoset column width

<!--

:::{.table width=[0.5,0.3]}
Table: table **width** {#tbl:table}

| Table | Header |  Row |
|:------|:------:|-----:|
| Cell  |  Cell  | Cell |

:::
-->

## Tiled figures

# #include "rest.rst"

<!--

[CSV file with caption](data/table.csv){.table}

[Alignment = DLCR](data/table.csv){.table alignment=DLCR width=[0.5]}

[Subset table](data/table.csv){.table subset_from=(1,2)}

[Set widths](data/table.csv){.table width=[0.2,0.3,0.2,0.3]}

[CSV file with caption2](data/io_plan.csv){.table delimiter=";"}
-->

##### Auto caption

<!--

[](data/table.csv){.table width=[0.5]}
-->

##### No caption

<!--
[](data/table.csv){.table nocaption=true}
-->

[@tbl:table]

## Level2

# Level1 unnumbered {-}

# Level1 {.subsection-toc}

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

\newpage

[](markdown/config.yaml){.listingtable type=yaml from=2 to=10 nocaption=true}

::: LANDSCAPE

[](data/ditaa.puml){.listingtable type=puml #lst:ditaa-sample}

[](data/ditaa.puml){.listingtable nocaption=true
.plantuml #fig:ditaa-sample im_out="img" im_fmt='png' caption="PlantUML x ditaa x imagine"}

:::

[This _fails_ to `list`](markdown/config.yaml){.listingtable numbers=right type=yaml from=2 to=5 #lst:list}

![dummy](images/dummy.png)

::: LANDSCAPE :::

##### Level5

# #include "section2.md"

:::

~~Strikeout~~ ~~ごはんはおかず~~
