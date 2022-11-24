module top;
import vdic_dut_2022_pkg::*;
vdic_dut_2022_bfm bfm();
//---------------------------------
//DUT
//---------------------------------

vdic_dut_2022 DUT(.clk(bfm.clk), .rst_n(bfm.rst_n), .enable_n(bfm.enable_n), 
	.din(bfm.din), .dout(bfm.dout), .dout_valid(bfm.dout_valid));

testbench testbench_h;
	
initial begin
    testbench_h = new(bfm);
    testbench_h.execute();
end

endmodule : top
