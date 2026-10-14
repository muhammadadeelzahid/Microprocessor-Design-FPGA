# NuCore

NuCore is a small pipelined 32-bit soft-core processor written in Verilog-2001
for the Terasic DE1-SoC (Intel Cyclone V 5CSEMA5F31C6). It executes a fixed
program from instruction memory, keeps its operands in two 16-entry register
files, and shows the operands and the ALU result on the board's seven-segment
displays.

The instruction set and the original design report are in
`Instruction_set+Details.pdf`.

## Layout

| Path                      | Contents                                                        |
| ------------------------- | --------------------------------------------------------------- |
| `rtl/NuCore.v`            | Board top level: KEY/HEX/LEDR mapping and seven-segment drivers  |
| `rtl/nucore_core.v`       | The processor: fetch, decode and execute stages                 |
| `rtl/program_counter.v`   | Program counter with synchronous restart                        |
| `rtl/instruction_memory.v`| 64 x 39-bit instruction ROM loaded with `$readmemb`             |
| `rtl/instruction_decoder.v`| Pipeline register holding the decoded instruction              |
| `rtl/register_file.v`     | 16 x 32-bit register file, one write port, one read port        |
| `rtl/alu.v`               | Combinational ALU                                               |
| `rtl/seg_7.v`             | Hex digit to active-low seven-segment decoder                   |
| `rtl/nucore_opcodes.vh`   | Instruction field widths and opcode constants                   |
| `tb/NuCore_TB.v`          | Self-checking testbench with a reference model of the ISA       |
| `memory.dat`              | Default program (loaded by both Quartus and the testbench)      |
| `programs/`               | Alternative programs in the same format                         |
| `sim/Waveform.vwf`        | Quartus vector waveform file from the original project          |
| `NuCore.qpf`, `NuCore.qsf`| Quartus Prime project and settings (pin assignments included)   |
| `Makefile`                | Simulation, lint and synthesis-check targets                    |

## Instruction set

Every instruction is 39 bits, written as one binary line in the program file.

```
 38 36 35  32 31  28 27                              0
+-----+------+------+---------------------------------+
| op  | addrA| addrB|                                 |
+-----+------+------+---------------------------------+
 38 36 35  32 31                                     0
+-----+------+----------------------------------------+
| op  | addr |              32-bit immediate          |
+-----+------+----------------------------------------+
```

| Opcode | Mnemonic | Format           | Effect                                          |
| ------ | -------- | ---------------- | ----------------------------------------------- |
| `000`  | RESET    | -                | Clear both register files and the output registers, restart the program |
| `001`  | STORE_A  | addr, immediate  | `A[addr] <= immediate`                          |
| `010`  | STORE_B  | addr, immediate  | `B[addr] <= immediate`                          |
| `011`  | ADD      | addrA, addrB     | `result <= A[addrA] + B[addrB]`                 |
| `100`  | SUB      | addrA, addrB     | `result <= A[addrA] - B[addrB]`                 |
| `101`  | OR       | addrA, addrB     | `result <= A[addrA] | B[addrB]`                 |
| `110`  | AND      | addrA, addrB     | `result <= A[addrA] & B[addrB]`                 |
| `111`  | SHL      | addrA, addrB     | `result <= A[addrA] << B[addrB]`                |

Every ALU instruction also latches its operands into `Data_A` and `Data_B`
and sets the zero flag when the result is zero. Store and RESET instructions
leave `result`, `Data_A` and `Data_B` unchanged (RESET clears them).

## Micro-architecture

```
              +-----------------+
         +--->| program counter |
         |    +--------+--------+
         |             | pc
         |    +--------v--------+
         |    | instruction ROM |
         |    +--------+--------+
         |             | instr
 restart +-------------+  (opcode == RESET)
                       |
              +--------v--------+
              | decode register |  opcode, addr_a, addr_b, imm,
              +--------+--------+  write_a, write_b, alu_en, soft_reset
                       |
           +-----------+-----------+
           |                       |
     +-----v------+          +-----v------+
     | reg file A |          | reg file B |
     +-----+------+          +-----+------+
           | operand_a             | operand_b
           +----------+ +----------+
                      | |
                  +---v-v---+
                  |   ALU   |
                  +----+----+
                       |
              +--------v--------+
              | output register |--> result, zero, Data_A, Data_B
              +-----------------+
```

- **Fetch.** The program counter addresses the instruction ROM. When the
  fetched opcode is RESET the counter restarts at zero on the next clock, so a
  program loops forever once it reaches its RESET instruction. Instruction
  memory not covered by the program file reads as RESET.
- **Decode.** The instruction fields and the control strobes derived from the
  opcode are registered together, so the execute stage always sees a
  consistent instruction.
- **Execute.** Stores write the immediate into the addressed register file
  entry. ALU instructions read both register files, compute the result and
  register `result`, `zero`, `Data_A` and `Data_B`. RESET clears all of them.

An instruction fetched on clock edge N takes effect after edge N+2. Because the
register files are written at the end of the execute stage and read
combinationally at the start of it, an ALU instruction immediately following a
store already sees the stored value, so there are no hazards to manage.

All state has an asynchronous active-low reset from `KEY[1]`.

## Board interface

| Signal    | Function                                              |
| --------- | ----------------------------------------------------- |
| `KEY[0]`  | Clock. Each press and release executes one instruction |
| `KEY[1]`  | Reset, active low (hold the button to reset)          |
| `HEX1:0`  | Low byte of `Data_A`                                  |
| `HEX3:2`  | Low byte of `Data_B`                                  |
| `HEX5:4`  | Low byte of `result`                                  |
| `LEDR[0]` | Zero flag                                             |

The 32-bit `result`, `Data_A` and `Data_B` ports exist so the testbench can
observe the full values. They are declared as virtual pins in `NuCore.qsf` so
the fitter does not route them to physical pins.

## Simulation

Requires [Icarus Verilog](https://steveicarus.github.io/iverilog/). Verilator
and Yosys are optional for `make lint` and `make synth`.

```sh
make              # run the self-checking testbench on memory.dat
make VCD=1        # also write build/NuCore_TB.vcd
make PROGRAM=programs/memory.txt
make lint         # Verilator -Wall
make synth        # Yosys elaboration as a synthesizability check
```

The testbench loads the program into its own reference model of the
instruction set and compares `result`, the zero flag, `Data_A`, `Data_B` and
all six HEX displays against it after every instruction. It runs the program
twice (which crosses the RESET restart), then asserts the asynchronous reset in
the middle of the program and runs it again. It prints `TEST PASSED` or
`TEST FAILED` and `make` fails on the latter.

With `memory.dat`, which stores 1..10 into `A[0..9]` and 10..1 into
`B[0..9]` before adding and AND-ing them pairwise, every ADD produces 11.

## Building for the DE1-SoC

Open `NuCore.qpf` in Quartus Prime, compile, and program the generated `.sof`.
The project lists the files under `rtl/` and uses `rtl` as its search path for
the opcode header. The program file is read from the project directory, so
keep `memory.dat` next to `NuCore.qpf` or change the `PROGRAM_FILE` parameter
of the top level.

Simulation from Quartus (NativeLink) uses `tb/NuCore_TB.v`; ModelSim must be
started from the project directory so the testbench can find `memory.dat`.

## Program files

One instruction per line, 39 binary digits, most significant bit first.
Lines are loaded from address 0 upwards. End the program with a RESET
instruction (`000...0`) to make it loop; this is also what the testbench uses
to find the program length.
