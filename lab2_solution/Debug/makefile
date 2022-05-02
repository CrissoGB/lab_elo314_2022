################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
"./L138_LCDK_aic3106_init.obj" \
"./L2p2-overdrive.obj" \
"./dsp_lab_utils.obj" \
"./vectors_intr.obj" \
"C:/Users/makcr/workspace_v11/lab1repo/lab2p2/sources/linker_dsp.cmd" \
$(GEN_CMDS__FLAG) \
-llibc.a \
-l"C:/Users/makcr/workspace_v11/lab1repo/DSP_BSL/lib/evmomapl138_bsl.lib" \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include targetConfigs/subdir_vars.mk
-include subdir_rules.mk
-include targetConfigs/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
lab2_solution.out \

EXE_OUTPUTS__QUOTED += \
"lab2_solution.out" \

BIN_OUTPUTS += \
lab2_solution.hex \

BIN_OUTPUTS__QUOTED += \
"lab2_solution.hex" \


# All Target
all: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@$(MAKE) --no-print-directory -Onone "lab2_solution.out"

# Tool invocations
lab2_solution.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: "$@"'
	@echo 'Invoking: C6000 Linker'
	"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/bin/cl6x" -mv6740 --abi=eabi --define=c6748 -g --diag_warning=225 --diag_wrap=off --display_error_number -z -m"lab2_solution.map" --heap_size=0x800 --stack_size=0x800 -i"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/lib" -i"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/include" --reread_libs --diag_wrap=off --display_error_number --warn_sections --xml_link_info="lab2_solution_linkInfo.xml" --rom_model -o "lab2_solution.out" $(ORDERED_OBJS)
	@echo 'Finished building target: "$@"'
	@echo ' '

lab2_solution.hex: $(EXE_OUTPUTS)
	@echo 'Building secondary target: "$@"'
	@echo 'Invoking: C6000 Hex Utility'
	"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/bin/hex6x" --diag_wrap=off -o "lab2_solution.hex" $(EXE_OUTPUTS__QUOTED)
	@echo 'Finished building secondary target: "$@"'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(BIN_OUTPUTS__QUOTED)$(EXE_OUTPUTS__QUOTED)
	-$(RM) "L138_LCDK_aic3106_init.obj" "L2p2-overdrive.obj" "dsp_lab_utils.obj" "vectors_intr.obj" 
	-$(RM) "L138_LCDK_aic3106_init.d" "L2p2-overdrive.d" "dsp_lab_utils.d" 
	-$(RM) "vectors_intr.d" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

