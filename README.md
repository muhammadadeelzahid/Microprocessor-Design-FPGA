# Microprocessor-Design-FPGA

This repository contains Verilog Code for a soft core microprocessor “NuCore” and its testbench named “NuCore_TB”.</br></br>
A. The NuCore shall has the following major blocks</br>
  </br>&emsp;&emsp;&emsp;&emsp;&emsp;1. A 64 deep Instruction Queue, addressed by a Program Counter. The Program Counter resets on the RESET signal. The Program &emsp;&emsp;&emsp;&emsp;&emsp;Counter is    incremented by one on each subsequent posedge of clock.</br>
   </br>&emsp;&emsp;&emsp;&emsp;&emsp;2. Instruction decode module: The instruction from the Instruction Queue Module is decoded according to the supported  &emsp;&emsp;&emsp;&emsp;&emsp;instruction format as given in Table below.</br>
  </br>&emsp;&emsp;&emsp;&emsp;&emsp;3. Two register files: REG_FILE_A (for keeping operands A) and REG_FILE_B (for keeping operands B). Both of these are 16 deep with  &emsp;&emsp;&emsp;&emsp;&emsp;a word size of 32</br>
   </br>&emsp;&emsp;&emsp;&emsp;&emsp;4. An Arithmetic Logic Unit that performs the arithmetic as defined by the instruction. The output of ALU is registered and &emsp;&emsp;&emsp;&emsp;&emsp;goes directly as the output of NuCore. ALU also produces a registered ZERO FLAG that goes out as an output of “NuCore” module.</br>
</br>B. The testbench “NuCore_TB” shall perform the following:
    </br>&emsp;&emsp;&emsp;&emsp;&emsp;1. Provide the necessary interfacing signal, CLK and RESET and instantiate the NuCore.
     </br>&emsp;&emsp;&emsp;&emsp;&emsp;2. The testbench performs the testing as follows:
         </br>&emsp;&emsp;&emsp;&emsp;&emsp;a. Load the following set of instructions to the instruction queue
           </br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;i. RESET
           </br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;ii. Store values of 1,2,3,4,5,6,7,8,9,10 at locations 1,2,3,4,5,6,7,8,9,10 of REG FILE A
           </br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;iii. Store values of 10,9,8,7,6,5,4,3,2,1 at locations 1,2,3,4,5,6,7,8,9,10 of REG FILE B
           </br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;iv. Add all the consecutive locations of REG FILE A & REG FILE B
           </br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;v. Bitwise‐AND all the consecutive locations of REG FILE A & REG FILE B
					 </br></br> Note: Instruction set is provided in the "Instruction_set.pdf" file.
					 
