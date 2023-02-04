transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/ALU.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/Program_Counter.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/NuCore.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/Reg.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/seg_7.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/decoder.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/instruction_update.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/Instruction_Queue.v}

vlog -vlog01compat -work work +incdir+G:/My\ Drive/EE/EE\ -\ 06/Digital\ System\ Design/Assignments/Assignment\ 2/dsd\ assignment\ 2 {G:/My Drive/EE/EE - 06/Digital System Design/Assignments/Assignment 2/dsd assignment 2/NuCore_TB.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  NuCore_TB

add wave *
view structure
view signals
run -all
