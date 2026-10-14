# ModelSim-Altera / Questa script for the NuCore self-checking testbench.
#
# Run it from the project root (the directory containing NuCore.qpf):
#
#   vsim -c -do "do sim/modelsim.do; quit -f"     batch: prints TEST PASSED/FAILED
#   vsim -do sim/modelsim.do                       GUI: also opens the wave window
#
# Pick another program file by setting PROGRAM before sourcing the script:
#
#   vsim -c -do "set PROGRAM programs/memory.txt; do sim/modelsim.do; quit -f"
#
# `make modelsim` wraps the batch form.
#
# Quartus' own flow (Tools > Run Simulation Tool > RTL Simulation) does not
# use this script; it compiles the same files from NuCore.qsf and runs in
# simulation/modelsim, which the testbench accounts for.

if {![info exists PROGRAM]} {
    set PROGRAM memory.dat
}
if {![file exists $PROGRAM]} {
    error "Program file '$PROGRAM' not found; run this script from the project root."
}

if {![file exists work]} {
    vlib work
}

vlog -vlog01compat -work work +incdir+rtl +define+PROGRAM_FILE=\"$PROGRAM\" \
    rtl/NuCore.v \
    rtl/nucore_core.v \
    rtl/program_counter.v \
    rtl/instruction_memory.v \
    rtl/instruction_decoder.v \
    rtl/register_file.v \
    rtl/alu.v \
    rtl/seg_7.v \
    tb/NuCore_TB.v

vsim -t 1ps -voptargs=+acc work.NuCore_TB

if {![batch_mode]} {
    add wave -divider "Board"
    add wave -radix binary   /NuCore_TB/KEY
    add wave -radix binary   /NuCore_TB/HEX0 /NuCore_TB/HEX1 /NuCore_TB/HEX2 \
                             /NuCore_TB/HEX3 /NuCore_TB/HEX4 /NuCore_TB/HEX5
    add wave -radix binary   /NuCore_TB/LEDR
    add wave -divider "Observation ports"
    add wave -radix unsigned /NuCore_TB/Data_A /NuCore_TB/Data_B /NuCore_TB/result
    add wave -divider "Core"
    add wave -radix unsigned /NuCore_TB/dut/u_core/pc
    add wave -radix binary   /NuCore_TB/dut/u_core/instr
    add wave -divider "Reference model"
    add wave -radix unsigned /NuCore_TB/exp_data_a /NuCore_TB/exp_data_b /NuCore_TB/exp_result
    add wave                 /NuCore_TB/exp_zero
    add wave -radix unsigned /NuCore_TB/errors
}

run -all

if {![batch_mode]} {
    wave zoom full
}
