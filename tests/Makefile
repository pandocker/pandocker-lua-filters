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
#REFERENCE := $(DATADIR)/ref.docx
#SYSTEM_DOCXFRONTPAGE := $(MDDIR)/frontpage.md
# COREPROPFLAGS := --table "Normal Table=Centered"
# COREPROPFLAGS += --paragraph "Normal=Body Text"
##
LUA_FILTER_BASE = ../lua
PANFLAGS := --read=markdown+east_asian_line_breaks
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/hide-frontpage-metadata.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/removable-note.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/tex-landscape.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/preprocess.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/docx-unnumberedheadings.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/docx-pagebreak-toc.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/csv2table.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/listingtable.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/wavedrom.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/svgbob.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/tex-underline.lua
#PANFLAGS += --filter=pantable
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/table-width.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/docx-apply-cell-styles.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/docx-custom-span-styles.lua
#PANFLAGS += --filter=pandocker-blockdiag-filters
#PANFLAGS += --filter=pandoc-svgbob-filter
PANFLAGS += --filter=pandoc-imagine
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/svgconvert.lua
#PANFLAGS += --filter=pandocker-filters
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/docx-extract-bullet-lists.lua
#PANFLAGS += --filter=pandoc-docx-extract-bullet-list
#PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/tex-remove-sout.lua
PANFLAGS += --filter=pandoc-crossref
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/docx-image-styles.lua
#PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/tex-rowcolors-reset.lua
PANFLAGS += --listings
PANFLAGS += --top-level-division=chapter
PANFLAGS += --number-sections --highlight-style=kate
PANFLAGS += -M short-hash=$(HASH)
PANFLAGS += -M tables=true
PANFLAGS += -M envversion=$(ENV_VERSION)
#PFLAGS += $(PANFLAGS)
#PANFLAGS = $(PFLAGS)

include $(MISC_SYS)/Makefile
