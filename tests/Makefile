ifeq ($(OS),Windows_NT)
HOME = C:/Users/$(USERNAME)
endif
PANSTYLES= /usr/local/var
MISC= $(PANSTYLES)/pandoc_misc
include $(MISC)/Makefile.in
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
LUA_FILTER_BASE = /usr/local/share/lua/5.3/pandocker
PANFLAGS =
PANFLAGS += --lua-filter=../lua/preprocess.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/default_loader.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/docx-unnumberedheadings.lua
PANFLAGS += --lua-filter=$(LUA_FILTER_BASE)/listingtable.lua

include $(MISC)/Makefile
