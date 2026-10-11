# =============================================================================
#  QuestaSim flow (run from WSL, Questa installed on Windows)
#
#    make                 -> compile design/ + verif/ and run TOP in batch mode
#    make TOP=<module>    -> same, but with a different top module
#    make waves           -> open the saved WLF in the Questa GUI
#    make clean           -> remove all generated files
# =============================================================================

# TOP        ?= tb_comp_mult
TOP        ?= tb_axi_comp_mult
TOP        := $(strip $(TOP))

DESIGN_DIR := design
VERIF_DIR  := verif
BUILD_DIR  := sim_build
TOP_WAVE_DO := $(VERIF_DIR)/$(TOP)_wave.do
WAVE_DO     := $(VERIF_DIR)/wave.do

VLOG_FLAGS ?= -sv
VSIM_FLAGS ?=

# ---- derived ----------------------------------------------------------------
# Design sources first, then verification sources. Header files (*.svh/*.vh)
# are not compiled directly; they're picked up via +incdir.
SRCS := $(shell find $(DESIGN_DIR) -type f \( -name '*.sv' -o -name '*.v' \) | sort) \
        $(shell find $(VERIF_DIR)  -type f \( -name '*.sv' -o -name '*.v' \) | sort)
INCDIRS := $(addprefix +incdir+,$(sort $(dir $(SRCS))))

WORK      := $(BUILD_DIR)/work
WLF       := $(BUILD_DIR)/$(TOP).wlf
COMPILED  := $(BUILD_DIR)/.compiled

# All Questa tools are Windows executables -> invoke them through PowerShell.
# Relative paths work because WSL hands the current dir (/mnt/d/...) to
# Windows as D:\... . "exit $LASTEXITCODE" propagates the tool's exit status.
PS := powershell.exe -NoProfile -NonInteractive -Command

.PHONY: all sim compile waves clean

all: sim

# ---- compile ----------------------------------------------------------------
compile: $(COMPILED)

$(COMPILED): $(SRCS) Makefile
	@mkdir -p $(BUILD_DIR)
	@test -d $(WORK) || $(PS) "vlib $(WORK); exit \$$LASTEXITCODE"
	$(PS) "vlog $(VLOG_FLAGS) -work $(WORK) $(INCDIRS) -l $(BUILD_DIR)/compile.log $(SRCS); exit \$$LASTEXITCODE"
	@touch $@

# ---- simulate (batch / no GUI) ----------------------------------------------
sim: $(COMPILED)
	$(PS) "vsim -c -lib $(WORK) -voptargs='+acc' -wlf $(WLF) -l $(BUILD_DIR)/sim.log -onfinish stop $(VSIM_FLAGS) $(TOP) -do 'log -r /*; run -all; quit -f'; exit \$$LASTEXITCODE"
	@echo "==> WLF saved to $(WLF)"

# ---- waves (GUI) ------------------------------------------------------------
# The WLF opens as dataset "$(TOP)"; unprefixed paths in wave.do
# (e.g. /tb_comp_mult/clk) resolve against it like in a live simulation.
waves:
	@test -f $(WLF) || { echo "ERROR: $(WLF) not found. Run 'make TOP=$(TOP)' first."; exit 1; }
	@if [ -f $(TOP_WAVE_DO) ]; then \
	    echo "==> Loading $(WLF) with $(TOP_WAVE_DO)"; \
	    $(PS) "vsim -view $(WLF) -l $(BUILD_DIR)/waves.log -do 'do $(TOP_WAVE_DO)'"; \
	elif [ -f $(WAVE_DO) ]; then \
	    echo "==> Loading $(WLF) with $(WAVE_DO)"; \
	    $(PS) "vsim -view $(WLF) -l $(BUILD_DIR)/waves.log -do 'do $(WAVE_DO)'"; \
	else \
	    echo "==> Loading $(WLF) with all signals"; \
	    $(PS) "vsim -view $(WLF) -l $(BUILD_DIR)/waves.log -do 'add wave -r /*; wave zoom full'"; \
	fi

# ---- clean ------------------------------------------------------------------
clean:
	rm -rf $(BUILD_DIR) work transcript *.wlf wlft* vsim_stacktrace.vstf modelsim.ini
