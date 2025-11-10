# Booth Multiplier + LFSR (Fibonacci) — Parametric RTL Design

A parameterized RTL implementation of a **Booth multiplier**, a **Fibonacci-style LFSR** (pseudo-random number generator), and a **generic top module** that feeds the Booth multiplier with LFSR-generated operands.  
The verification environment includes a **differential testbench** that compares the Booth result against a reference implementation that uses the `*` operator, plus saved **waveforms** showcasing simulations across the project’s main blocks.

## Table of Contents
- [Features](#features)  
- [Design Overview](#design-overview)  
  - [Parametric Booth Multiplier](#parametric-booth-multiplier)  
  - [Fibonacci LFSR](#fibonacci-lfsr)  
  - [Generic Top Module](#generic-top-module)  
- [Getting Started](#getting-started)  
  - [Vivado (Synthesis & Simulation)](#vivado-synthesis--simulation)  
  - [Verilator / Other Simulators](#verilator--other-simulators)  
- [Testbench & Differential Checking](#testbench--differential-checking)  
- [Waveforms](#waveforms)  
- [Results & Notes](#results--notes)

---

## Features
- **Parametric Booth multiplier** RTL (configurable bit-width).
- **Fibonacci LFSR** as a pseudo-random stimulus generator.
- **Generic top module** that wires LFSR outputs into the Booth multiplier’s inputs.
- **Differential verification**: compares Booth output against a reference `a * b`.
- **Portable**: synthesizable Verilog; works with Xilinx Vivado, Verilator, Questa, etc.
- **Clean project scripts** (Tcl/Make) and example `.gitignore` for Vivado artifacts.

---

## Design Overview

### Parametric Booth Multiplier
- Implements Booth’s multiplication algorithm in RTL.
- Written to be **parameterized** (e.g., `parameter WIDTH = 16;`).
- Produces a signed/unsigned product depending on configuration (match to your use).
- Focuses on a clean, synthesizable description suitable for FPGA targets.

### Fibonacci LFSR
- LFSR designed with the **Fibonacci** method (feedback from taps into MSB, shift-right/left depending on convention).
- Parameterizable **polynomial taps** and **seed**.
- Generates pseudo-random sequences used to drive the multiplier inputs during verification and in the generic top.

### Generic Top Module
- Instantiates two LFSRs (or one, if you prefer) to produce operands `a` and `b`.
- Feeds those operands into the Booth multiplier.
- Keeps interfaces and parameters **generic** so it can be reused across parts/boards.

---

## Getting Started

### Vivado (Synthesis & Simulation)
**Batch synthesis (example):**
```bash
vivado -mode batch -source scripts/build.tcl
```

**Vivado Simulator (example):**
```tcl
# In Vivado Tcl console (or add to a sim.tcl)
read_verilog rtl/booth_multiplier.v rtl/lfsr_fib.v rtl/top_booth_lfsr.v tb/tb_top.sv
set_property top tb_top [current_fileset]
launch_simulation
# Optionally, log signals and export waveforms
```

### Verilator / Other Simulators

**Make (example):**
```bash
make -f scripts/sim.mk sim  WIDTH=16
```

You can adapt `scripts/sim.mk` to your preferred simulator (Verilator/Questa/VCS).

---

## Testbench & Differential Checking

The SystemVerilog testbench **drives the top module**, captures the Booth multiplier result, and **compares it against a golden reference** computed with the built-in `*` operator:

* On each cycle (or when ready/valid if you use handshakes), the testbench:
  1. Samples operands `a` and `b` from the LFSR-driven top.
  2. Computes `golden = $signed(a) * $signed(b)` (or unsigned—match your design).
  3. Compares `golden` vs. `dut_product` and **asserts** on any mismatch.

* Final pass/fail summary is printed at the end of simulation.

---

## Waveforms

Waveform captures from simulations are included under `waves/`.
Update the list/paths below to your actual files:

* `waves/booth_core.png` — Internal signals of the Booth multiplier during a sample transaction.
* `waves/lfsr_sequence.png` — LFSR bit evolution showing the expected pseudo-random sequence.
* `waves/top_diffcheck.png` — Top-level signals and the differential check against the `*` operator.

You can regenerate waveforms using your simulator’s GUI or dumping VCD/FSDB and plotting with your preferred viewer.

---

## Results & Notes

* The differential testbench showed **functional equivalence** between the Booth RTL and the reference `*` operator across the simulated vectors driven by the LFSR(s).
* Timing/area will vary by FPGA/ASIC target and constraints.

  * If you target Xilinx devices, add/adjust `constraints/top.xdc`.
  * For deeper pipelines or higher Fmax, consider registering partial sums or adding a ready/valid interface.

---

**Programmer:** Shadi Nikooei
