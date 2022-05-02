################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
L138_LCDK_aic3106_init.obj: C:/Users/makcr/workspace_v11/lab1repo/DSP_AIC3106/L138_LCDK_aic3106_init.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/bin/cl6x" -mv6740 --include_path="C:/Users/makcr/workspace_v11/lab1_p2" --include_path="C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/include" --include_path="C:/Users/makcr/workspace_v11/lab1repo/lab1p2/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_BSL/inc" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_AIC3106" --include_path="C:/Users/makcr/workspace_v11/lab1repo/dsp_lab_utils_lib/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/audio_files/c_arrays" --define=c6748 -g --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

L1p2.obj: C:/Users/makcr/workspace_v11/lab1repo/lab1p2/sources/L1p2.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/bin/cl6x" -mv6740 --include_path="C:/Users/makcr/workspace_v11/lab1_p2" --include_path="C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/include" --include_path="C:/Users/makcr/workspace_v11/lab1repo/lab1p2/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_BSL/inc" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_AIC3106" --include_path="C:/Users/makcr/workspace_v11/lab1repo/dsp_lab_utils_lib/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/audio_files/c_arrays" --define=c6748 -g --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

dsp_lab_utils.obj: C:/Users/makcr/workspace_v11/lab1repo/dsp_lab_utils_lib/sources/dsp_lab_utils.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/bin/cl6x" -mv6740 --include_path="C:/Users/makcr/workspace_v11/lab1_p2" --include_path="C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/include" --include_path="C:/Users/makcr/workspace_v11/lab1repo/lab1p2/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_BSL/inc" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_AIC3106" --include_path="C:/Users/makcr/workspace_v11/lab1repo/dsp_lab_utils_lib/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/audio_files/c_arrays" --define=c6748 -g --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

%.obj: ../%.asm $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/bin/cl6x" -mv6740 --include_path="C:/Users/makcr/workspace_v11/lab1_p2" --include_path="C:/ti/ccs1110/ccs/tools/compiler/ti-cgt-c6000_8.3.11/include" --include_path="C:/Users/makcr/workspace_v11/lab1repo/lab1p2/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_BSL/inc" --include_path="C:/Users/makcr/workspace_v11/lab1repo/DSP_AIC3106" --include_path="C:/Users/makcr/workspace_v11/lab1repo/dsp_lab_utils_lib/sources" --include_path="C:/Users/makcr/workspace_v11/lab1repo/audio_files/c_arrays" --define=c6748 -g --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


