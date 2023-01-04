module top;
import uvm_pkg::*;
`include "uvm_macros.svh"
import vdic_dut_2022_pkg::*;
vdic_dut_2022_bfm bfm();
//---------------------------------
//DUT
//---------------------------------

vdic_dut_2022 DUT(.clk(bfm.clk), .rst_n(bfm.rst_n), .enable_n(bfm.enable_n), 
	.din(bfm.din), .dout(bfm.dout), .dout_valid(bfm.dout_valid));

initial begin
    uvm_config_db #(virtual vdic_dut_2022_bfm)::set(null, "*", "bfm", bfm);
    run_test();
end

endmodule : top
