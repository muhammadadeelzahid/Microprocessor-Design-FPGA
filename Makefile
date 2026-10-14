# NuCore simulation makefile (Icarus Verilog).
#
#   make            compile and run the self-checking testbench
#   make sim VCD=1  same, and write build/NuCore_TB.vcd for a waveform viewer
#   make lint       lint the RTL with Verilator
#   make synth      elaborate the RTL with Yosys as a synthesizability check
#   make clean
#
# PROGRAM selects the instruction file used by both the DUT and the testbench.

IVERILOG  ?= iverilog
VVP       ?= vvp
VERILATOR ?= verilator
YOSYS     ?= yosys

PROGRAM ?= memory.dat
BUILD   ?= build

RTL_DIR := rtl
TB_DIR  := tb
RTL     := $(wildcard $(RTL_DIR)/*.v)
HEADERS := $(wildcard $(RTL_DIR)/*.vh)
TB      := $(TB_DIR)/NuCore_TB.v
TOP_TB  := NuCore_TB

SIM_BIN := $(BUILD)/$(TOP_TB).vvp
SIM_LOG := $(BUILD)/sim.log

VVP_ARGS :=
ifdef VCD
VVP_ARGS += +vcd
endif

.PHONY: all sim lint synth clean

all: sim

$(BUILD):
	mkdir -p $(BUILD)

$(SIM_BIN): $(RTL) $(HEADERS) $(TB) | $(BUILD)
	$(IVERILOG) -g2005 -Wall -I$(RTL_DIR) -DPROGRAM_FILE='"$(PROGRAM)"' -o $@ $(TB) $(RTL)

sim: $(SIM_BIN)
	$(VVP) -N $(SIM_BIN) $(VVP_ARGS) | tee $(SIM_LOG)
	@if [ -n "$(VCD)" ] && [ -f $(TOP_TB).vcd ]; then mv $(TOP_TB).vcd $(BUILD)/; fi
	@grep -q "TEST PASSED" $(SIM_LOG)

lint:
	$(VERILATOR) --lint-only -Wall -Wno-ASCRANGE -I$(RTL_DIR) --top-module NuCore $(RTL)

synth: | $(BUILD)
	$(YOSYS) -q -p "read_verilog -I$(RTL_DIR) $(RTL); hierarchy -top NuCore; proc; opt; check -assert; stat" -l $(BUILD)/yosys.log

clean:
	rm -rf $(BUILD) $(TOP_TB).vcd
