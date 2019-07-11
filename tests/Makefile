ifeq ($(OS),Windows_NT)
HOME = C:/Users/$(USERNAME)
endif
PIPBASE= $(shell get-pip-base)
PANSTYLES= $(PIPBASE)/var
MISC= $(PANSTYLES)/pandoc_misc
MISC_SYS = $(MISC)/system
MISC_USER = $(MISC)/user
include $(MISC_SYS)/Makefile.in
PROJECT= `pwd`

## userland: uncomment and replace
# MDDIR:= markdown
# DATADIR:= data
# TARGETDIR:= Out
# IMAGEDIR:= images

# CONFIG:= config.yaml
# INPUT:= TITLE.md
# TARGET:= TARGET-$(DATE)-$(HASH)
# REVERSE_INPUT:= reverse-input.docx
# REFERENCE:= $(MISC)/ref.docx
# COREPROPFLAGS := --table "Normal Table=Centered"
# COREPROPFLAGS += --paragraph "Normal=Body Text"
##
LUA_FILTER_BASE = $(PIPBASE)/share/lua/5.3/pandocker
PANFLAGS =
PANFLAGS += $(MISC_SYS)/$(CONFIG)
PANFLAGS += $(MDDIR)/$(CONFIG)
PANFLAGS += --lua-filter=../lua/tex-landscape.lua
PANFLAGS += --lua-filter=../lua/preprocess.lua
PANFLAGS += --lua-filter=../lua/removable-note.lua
PANFLAGS += --lua-filter=../lua/docx-pagebreak-toc.lua
PANFLAGS += --lua-filter=../lua/docx-unnumberedheadings.lua
PANFLAGS += --lua-filter=../lua/docx-extract-bullet-lists.lua
PANFLAGS += --lua-filter=../lua/listingtable.lua
PANFLAGS += --lua-filter=../lua/wavedrom.lua
PANFLAGS += --lua-filter=../lua/svgconvert.lua
PANFLAGS += --lua-filter=../lua/tex-rowcolors-reset.lua
PANFLAGS += --filter=pandoc-crossref
#PFLAGS += $(PANFLAGS)
#PANFLAGS = $(PFLAGS)

include $(MISC_SYS)/Makefile
