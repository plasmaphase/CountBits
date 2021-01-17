<!--lint disable no-literal-urls-->
<p align="center">
  <a href="https://github.com/plasmaphase/CountBits/">
    <img
      src="https://github.com/plasmaphase/CountBits/blob/main/CountBits.png"
    />
  </a>
</p>
VHDL module which counts set bits on an AXI4 bus at the bus, word, and byte level.  As an example, with a 512-bit AXI bus, there would be accumulators for 16 independent words, and 32 independent byte accumulators.

Sources:
 - cb_top.vhd - Top RTL containing top level ports and component instantiations necessary for count bits
 - AxiLiteCtrl.vhd - RTL containing logic to control AXI4 Lite interface and manage the register space therein
 - cb_pkg.vhd - RTL package containing support functions and types for the count bits module
 - countbits.vhd - RTL logic for accumulating bus, word, and byte level set bits.


Sim:
 - cb_sim.sv - SystemVerilog simulation logic to support basic level simulation of countbits using Xilinx VIP AXI simulation blocks
 

