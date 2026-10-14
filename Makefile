# NuCore simulation makefile (ModelSim-Altera / Questa).
#
#   make            run the self-checking testbench in ModelSim (batch mode)
#   make lint       lint the RTL with Verilator (optional)
#   make synth      elaborate the RTL with Yosys as a synthesizability check (optional)
#   make clean
#
# PROGRAM selects the instruction file used by both the DUT and the testbench.
# vsim must be on PATH (e.g. <quartus>/modelsim_ase/bin), or set VSIM.

VSIM      ?= vsim
VERILATOR ?= verilator
YOSYS     ?= yosys

PROGRAM ?= memory.dat
BUILD   ?= build

RTL_DIR := rtl
RTL     := $(wildcard $(RTL_DIR)/*.v)

MSIM_LOG := $(BUILD)/modelsim.log

.PHONY: all modelsim lint synth clean

all: modelsim

$(BUILD):
	mkdir -p $(BUILD)

# ModelSim writes its work library and transcript into the current directory.
modelsim: | $(BUILD)
	$(VSIM) -c -do "set PROGRAM $(PROGRAM); do sim/modelsim.do; quit -f" | tee $(MSIM_LOG)
	@grep -q "TEST PASSED" $(MSIM_LOG)

lint:
	$(VERILATOR) --lint-only -Wall -Wno-ASCRANGE -I$(RTL_DIR) --top-module NuCore $(RTL)

synth: | $(BUILD)
	$(YOSYS) -q -p "read_verilog -I$(RTL_DIR) $(RTL); hierarchy -top NuCore; proc; opt; check -assert; stat" -l $(BUILD)/yosys.log

clean:
	rm -rf $(BUILD) work transcript vsim.wlf
