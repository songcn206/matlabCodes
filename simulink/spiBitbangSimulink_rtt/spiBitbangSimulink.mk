# File name: spiBitbangSimulink.mk
# Autogenerated on: 19-Apr-2014 21:32:56
# Copyright 2009-2012 The MathWorks, Inc.
#
# Model: SPIBITBANGSIMULINK
# Template: gmake 
# Template Version: 1.0 
# Tool Chain Configuration: LinuxRemoteBuild
# Tool Chain Configuration Version: 2.0

THIS_MAKEFILE        := $(lastword $(MAKEFILE_LIST))
EMPTY                :=
SPACE                := $(EMPTY) $(EMPTY)
MODEL_NAME           := spiBitbangSimulink
HOST_PLATFORM        := windows
BUILD_CFG            := MW
TARGET_EXT           := 
OBJ_EXT              := .o
TOOL_CHAIN_CFG       := LinuxRemoteBuild

FORMAT_PATH = $(if $(filter \\\\%,$(1)),"$(1)",$(subst $(SPACE),\$(SPACE),$(subst \,/,$(1))))

MATLAB_ROOT_RELATIVE := ..\..\..\..\..\..\Program Files\MATLAB\R2013b\#MATLAB_ROOT_RELATIVE_END
MATLAB_ROOT_ABSOLUTE := C:\Program Files\MATLAB\R2013b\#MATLAB_ROOT_ABSOLUTE_END
SOURCE_PATH          := $(call FORMAT_PATH,.\)
OUTPUT_PATH          := $(call FORMAT_PATH,$(SOURCE_PATH)$(BUILD_CFG)/)
DERIVED_PATH         := $(call FORMAT_PATH,$(SOURCE_PATH))
TARGET_NAME_PREFIX   := 
TARGET_NAME_POSTFIX  := 
TARGET_FILE          := $(TARGET_NAME_PREFIX)$(MODEL_NAME)$(TARGET_NAME_POSTFIX)$(TARGET_EXT)
TARGET               := $(OUTPUT_PATH)$(TARGET_FILE)

###########################################################################
# Code Generation Files
###########################################################################

SOURCE_FILES        := $(call FORMAT_PATH,.\MW_gpio.c) $(call FORMAT_PATH,.\MW_pinMux.c) $(call FORMAT_PATH,.\linuxUDP.c) $(call FORMAT_PATH,.\ert_main.c) $(call FORMAT_PATH,.\spiBitbangSimulink.c) $(call FORMAT_PATH,.\spiBitbangSimulink_data.c)
HEADER_FILES        := $(call FORMAT_PATH,.\spiBitbangSimulink.h)
LIBRARY_FILES       := 
OBJ_FILES           := $(addprefix $(DERIVED_PATH),$(addsuffix $(OBJ_EXT),$(basename $(notdir $(SOURCE_FILES)))))
SKIPPED_FILES       := 

###########################################################################
# Code Generation Information
###########################################################################

COMPILER_CODEGEN_ARGS := -I"C:/MATLAB/SupportPackages/R2013b/linux/include" -I"C:/Users/mainster/Documents/MATLAB/simulink/spiBitbangSimulink_rtt" -I"C:/Users/mainster/Documents/MATLAB/simulink" -I"C:/Program Files/MATLAB/R2013b/extern/include" -I"C:/Program Files/MATLAB/R2013b/simulink/include" -I"C:/Program Files/MATLAB/R2013b/rtw/c/src" -I"C:/Program Files/MATLAB/R2013b/rtw/c/src/ext_mode/common" -I"C:/Program Files/MATLAB/R2013b/rtw/c/ert" -I"C:/MATLAB/SupportPackages/R2013b/linux/blocks/sfcn/include" -I"C:/MATLAB/SupportPackages/R2013b/linux/blocks/sfcn/src" -I"C:/Program Files/MATLAB/R2013b/toolbox/shared/dspblks/extern/include" -O3 -D"MODEL=spiBitbangSimulink" -D"NUMST=2" -D"NCSTATES=0" -D"HAVESTDIO=" -D"ONESTEPFCN=0" -D"TERMFCN=1" -D"MAT_FILE=0" -D"MULTI_INSTANCE_CODE=0" -D"INTEGER_CODE=0" -D"MT=1" -D"CLASSIC_INTERFACE=0" -D"TID01EQ=0" -D"_USE_TARGET_UDP_=" -D"_RUNONTARGETHARDWARE_BUILD_="
COMPILER_TCCFG_ARGS   := -c
COMPILER_ARGS         := $(COMPILER_CODEGEN_ARGS) $(COMPILER_TCCFG_ARGS)
LINKER_CODEGEN_ARGS   :=  -lm -ldl -lpthread -lrt 
LINKER_TCCFG_ARGS     := -o $(TARGET)
LINKER_ARGS           := $(LINKER_CODEGEN_ARGS) $(LINKER_TCCFG_ARGS)
PREBUILD_ARGS         := 
POSTBUILD_ARGS        := 
EXECUTE_ARGS          := 



COMPILER           ?= $(subst \,/,gcc)
LINKER             ?= $(subst \,/,gcc)
PREBUILD_TOOL      ?= 
POSTBUILD_TOOL     ?= 
EXECUTE_USES_TARGET = on

ifeq (on,$(EXECUTE_USES_TARGET))
 EXECUTE_TOOL ?= $(TARGET)
else
 EXECUTE_TOOL ?= 
endif

ifeq (windows,$(HOST_PLATFORM))
 RM ?= del /q
else
 RM ?= rm -f
endif

ifeq (windows,$(HOST_PLATFORM))
 MKDIR ?= mkdir
else
 MKDIR ?= mkdir -p
endif

###########################################################################
# Targets
###########################################################################

.DEFAULT_GOAL := all

.PHONY : all execute prebuild build postbuild info environment check clean

all : execute

ifneq (,$(strip $(EXECUTE_TOOL)))
execute : build
	$(info "Evaluating execute target...")
	"$(EXECUTE_TOOL)" $(EXECUTE_ARGS)
else
execute : build
endif

build : postbuild
	$(info "Evaluating build target...")

ifneq (,$(strip $(PREBUILD_TOOL)))
prebuild : | $(OUTPUT_PATH) $(DERIVED_PATH)
	$(info "Evaluating prebuild target...")
	"$(PREBUILD_TOOL)" $(PREBUILD_ARGS)
else
prebuild : | $(OUTPUT_PATH) $(DERIVED_PATH)
endif

ifneq (,$(strip $(POSTBUILD_TOOL)))
postbuild : $(TARGET)
	$(info "Evaluating postbuild target...")
	"$(POSTBUILD_TOOL)" $(POSTBUILD_ARGS)
else
postbuild : $(TARGET)
endif

ifneq (,$(strip $(LINKER)))
$(TARGET) : prebuild $(OBJ_FILES)
	"$(LINKER)" $(OBJ_FILES) $(LIBRARY_FILES) $(LINKER_ARGS)

$(OBJ_FILES) : $(SOURCE_FILES) $(HEADER_FILES)
	"$(COMPILER)" $(COMPILER_ARGS) $(SOURCE_FILES)
else
$(TARGET) : prebuild $(SOURCE_FILES) $(HEADER_FILES)
	"$(COMPILER)" $(COMPILER_ARGS) $(SOURCE_FILES)
endif

$(OUTPUT_PATH) :
ifeq (,$(wildcard $(OUTPUT_PATH)))
	@$(MKDIR) "$(OUTPUT_PATH)"
endif

$(DERIVED_PATH) :
ifeq (,$(wildcard $(DERIVED_PATH)))
	@$(MKDIR) "$(DERIVED_PATH)"
endif

clean :
	-@$(RM) $(TARGET) $(OBJ_FILES)

info : 
	$(info MODEL_NAME=$(MODEL_NAME))
	$(info HOST_PLATFORM=$(HOST_PLATFORM))
	$(info BUILD_CFG=$(BUILD_CFG))
	$(info TOOL_CHAIN_CFG=$(TOOL_CHAIN_CFG))
	$(info TARGET_EXT=$(TARGET_EXT))
	$(info OBJ_EXT=$(OBJ_EXT))
	$(info SOURCE_PATH=$(SOURCE_PATH))
	$(info OUTPUT_PATH=$(OUTPUT_PATH))
	$(info DERIVED_PATH=$(DERIVED_PATH))
	$(info TARGET_FILE=$(TARGET_FILE))
	$(info TARGET=$(TARGET))
	$(info COMPILER=$(COMPILER))
	$(info COMPILER_ARGS=$(COMPILER_ARGS))
	$(info COMPILER_CODEGEN_ARGS=$(COMPILER_CODEGEN_ARGS))
	$(info COMPILER_TCCFG_ARGS=$(COMPILER_TCCFG_ARGS))
	$(info LINKER=$(LINKER))
	$(info LINKER_ARGS=$(LINKER_ARGS))
	$(info LINKER_CODEGEN_ARGS=$(LINKER_CODEGEN_ARGS))
	$(info LINKER_TCCFG_ARGS=$(LINKER_TCCFG_ARGS))
	$(info PREBUILD_TOOL=$(PREBUILD_TOOL))
	$(info PREBUILD_ARGS=$(PREBUILD_ARGS))
	$(info POSTBUILD_TOOL=$(POSTBUILD_TOOL))
	$(info POSTBUILD_ARGS=$(POSTBUILD_ARGS))
	$(info EXECUTE_TOOL=$(EXECUTE_TOOL))
	$(info EXECUTE_ARGS=$(EXECUTE_ARGS))
	$(info SOURCE_FILES=$(SOURCE_FILES))
	$(info HEADER_FILES=$(HEADER_FILES))
	$(info LIBRARY_FILES=$(LIBRARY_FILES))
	$(info OBJ_FILES=$(OBJ_FILES))
	$(info SKIPPED_FILES=$(SKIPPED_FILES))
	$(info RM=$(RM))
	$(info MKDIR=$(MKDIR))

environment :
	$(if $(findstring windows,$(HOST_PLATFORM)),$(info ENVIRONMENT=$(shell set)),$(info ENVIRONMENT=$(shell env)))
