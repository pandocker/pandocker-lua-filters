---
heading-unnumbered:
  2: "Heading Unnumbered 1.1"
codeBlockCaptions: true
listingTitle: "List"
listings: true
#rmnote: true
...

\toc

# Level1

[Table Caption](data/table.csv){.table subset_from=(1,2) alignment=CCC width=[1]}

[@tbl:table]

## Level2
# Level1 unnumbered {-}
## Level2 unnumbered {-}
# #include "section2.md"

::::::{custom-style="Heading Unnumbered 3"}
Level3 *unnumbered*
::::::

:::::{custom-style="Bullet List 1"}
Bullet List 1

:::{custom-style="Bullet List 2"}
Bullet List 2
:::
:::::
[@lst:lst]

[bit.yaml](data/bit.yaml){.bitfield}

#### Level4 unnumbered {-}

# #include "section1.md"

[Title](markdown/config.yaml){.listingtable from=2 to=5 #lst:lst}

[Wavedrom(BitField)](data/json.json){.wavedrom}

\newpage

[](markdown/config.yaml){.listingtable type=yaml from=2 to=10 }

<!--[This failes to list](markdown/config){.listingtable numbers=right type=python from=2 to=5 #lst:list}-->

![dummy](images/dummy.png)

::: LANDSCAPE :::
##### Level5
# #include "section2.md"
:::
