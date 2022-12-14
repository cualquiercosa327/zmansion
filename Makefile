#stolen from Metroid Prime 1 repo, TODO: cleanup

ifneq ($(findstring MINGW,$(shell uname)),)
  WINDOWS := 1
endif
ifneq ($(findstring MSYS,$(shell uname)),)
  WINDOWS := 1
endif

# If 0, tells the console to chill out. (Quiets the make process.)
VERBOSE ?= 0

# If GENERATE_MAP set to 1, tells LDFLAGS to generate a mapfile, which makes linking take several minutes.
GENERATE_MAP ?= 0

# Enable non-matching code & various fixes
NONMATCHING ?= 0

ifeq ($(VERBOSE),0)
  QUIET := @
endif

#-------------------------------------------------------------------------------
# Files
#-------------------------------------------------------------------------------

NAME := mansion
VERSION := usa

BUILD_DIR := build/$(NAME).$(VERSION)

# Inputs
S_FILES := $(wildcard asm/*.s)
C_FILES := $(wildcard src/*.c)
CPP_FILES := $(wildcard src/*.cpp)
CPP_FILES += $(wildcard src/*.cp)
LDSCRIPT := $(BUILD_DIR)/ldscript.lcf

# Outputs
DOL     := $(BUILD_DIR)/main.dol
ELF     := $(DOL:.dol=.elf)
MAP     := $(BUILD_DIR)/$(NAME).$(VERSION).map


ifeq ($(GENERATE_MAP),1)
  MAPGEN := -map $(MAP)
endif

include obj_files.mk

O_FILES := $(GAME_O_FILES)
DEPENDS := $(O_FILES:.o=.d)
# If a specific .o file is passed as a target, also process its deps
DEPENDS += $(MAKECMDGOALS:.o=.d)

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------

MWCC_VERSION := 1.1
MWLD_VERSION := 1.1

# Programs
export WINEDEBUG ?= -all
ifeq ($(WINDOWS),1)
  WINE    :=
  AS      := $(DEVKITPPC)/bin/powerpc-eabi-as.exe
  CPP     := $(DEVKITPPC)/bin/powerpc-eabi-cpp.exe -P
  PYTHON  := py
else
  WIBO   := $(shell command -v wibo 2> /dev/null)
  ifdef WIBO
    WINE ?= wibo
  else
    WINE ?= wine
  endif
  DEVKITPPC ?= /opt/devkitpro/devkitPPC
  DEPENDS   := $(DEPENDS:.d=.d.unix)
  AS        := $(DEVKITPPC)/bin/powerpc-eabi-as
  CPP       := $(DEVKITPPC)/bin/powerpc-eabi-cpp -P
  PYTHON    := python3
endif
CC      =  $(WINE) tools/mwcc_compiler/$(MWCC_VERSION)/mwcceppc.exe
LD      := $(WINE) tools/mwcc_compiler/$(MWLD_VERSION)/mwldeppc.exe
ELF2DOL := tools/elf2dol
SHA1SUM := shasum -a 1

TRANSFORM_DEP := tools/transform-dep.py
FRANK := tools/franklite.py

# Options
INCLUDES := -i include/ -i libc/
ASM_INCLUDES := -I include/ -I asm/

# DotKuribo/llvm-project
CLANG_CC ?= clang-kuribo
CLANG_CFLAGS := --target=ppc32-kuribo -mcpu=750 -nostdlib -fno-exceptions -fno-rtti -O3 -Wall -Wno-trigraphs -Wno-inline-new-delete -Wno-unused-private-field -fpermissive -std=gnu++11 $(ASM_INCLUDES)

ASFLAGS := -mgekko $(ASM_INCLUDES)
ifeq ($(VERBOSE),1)
# this set of LDFLAGS outputs warnings.
LDFLAGS := $(MAPGEN) -fp fmadd -nodefaults
endif
ifeq ($(VERBOSE),0)
# this set of LDFLAGS generates no warnings.
LDFLAGS := $(MAPGEN) -fp fmadd -nodefaults -w off
endif
DEFINES = -DNONMATCHING=$(NONMATCHING)
CFLAGS_BASE = -proc gekko -nodefaults -Cpp_exceptions off -RTTI off -fp hard -fp_contract on -O4,p -maxerrors 1 -enum int -inline auto -str reuse -nosyspath -MMD $(DEFINES) $(INCLUDES)
CFLAGS = $(CFLAGS_BASE) -use_lmw_stmw on -str reuse,pool,readonly -gccinc -inline deferred,noauto -common on
CFLAGS_RUNTIME = $(CFLAGS_BASE) -use_lmw_stmw on -str reuse,pool,readonly -gccinc -inline deferred,auto
CFLAGS_MUSYX = $(CFLAGS_BASE) -str reuse,pool,readonly

ifeq ($(VERBOSE),0)
# this set of ASFLAGS generates no warnings.
ASFLAGS += -W
endif

$(INIT_O_FILES): MWCC_VERSION := 1.1
$(INIT_O_FILES): CFLAGS := $(CFLAGS_BASE)


#-------------------------------------------------------------------------------
# Recipes
#-------------------------------------------------------------------------------

### Default target ###

default: all

all: $(DOL)

ALL_DIRS := $(sort $(dir $(O_FILES)))

# Make sure build directory exists before compiling anything
DUMMY != mkdir -p $(ALL_DIRS)

.PHONY: tools

$(LDSCRIPT): ldscript.lcf
	$(QUIET) $(CPP) -MMD -MP -MT $@ -MF $@.d -I include/ -I . -DBUILD_DIR=$(BUILD_DIR) -o $@ $<

$(DOL): $(ELF) | tools
	$(QUIET) $(ELF2DOL) -v -v $< $@
	$(QUIET) $(SHA1SUM) -c sha1/$(NAME).$(VERSION).sha1
ifneq ($(findstring -map,$(LDFLAGS)),)
	$(QUIET) $(PYTHON) tools/calcprogress.py $(DOL) $(MAP)
endif

clean:
	$(RM) $(O_FILES) $(DEPENDS)
	$(MAKE) -C tools clean
tools:
	$(MAKE) -C tools

# ELF creation makefile instructions
$(ELF): $(O_FILES) $(LDSCRIPT)
	@echo Linking ELF $@
	$(QUIET) @echo $(O_FILES) > build/o_files
	$(QUIET) $(LD) $(LDFLAGS) -o $@ -lcf $(LDSCRIPT) @build/o_files

%.d.unix: %.d $(TRANSFORM_DEP)
	@echo Processing $<
	$(QUIET) $(PYTHON) $(TRANSFORM_DEP) $< $@

-include $(DEPENDS)

$(BUILD_DIR)/%.o: %.s
	@echo "Assembling" $<
	$(QUIET) $(AS) $(ASFLAGS) -o $@ $<

$(BUILD_DIR)/%.clang.o: %.cpp
	@echo "Clang     " $<
	$(QUIET) $(CLANG_CC) $(CLANG_CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.ep.o: $(BUILD_DIR)/%.o
	@echo Frank is fixing $<
	$(QUIET) $(PYTHON) $(FRANK) $< $@

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling " $<
	$(QUIET) $(CC) $(CFLAGS) -c -o $(dir $@) $<

$(BUILD_DIR)/%.o: %.cp
	@echo "Compiling " $<
	$(QUIET) $(CC) $(CFLAGS) -c -o $(dir $@) $<

$(BUILD_DIR)/%.o: %.cpp
	@echo "Compiling " $<
	$(QUIET) $(CC) $(CFLAGS) -c -o $(dir $@) $<

### Debug Print ###

print-% : ; $(info $* is a $(flavor $*) variable set to [$($*)]) @true
