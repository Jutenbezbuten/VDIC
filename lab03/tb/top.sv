module top;
vdic_dut_2022_bfm bfm();
tester tester_i (bfm);
coverage coverage_i (bfm);
scoreboard scoreboard_i(bfm);

//tinyalu DUT (.A(bfm.A), .B(bfm.B), .op(bfm.op),
//    .clk(bfm.clk), .reset_n(bfm.reset_n),
 //   .start(bfm.start), .done(bfm.done), .result(bfm.result));

//---------------------------------
//DUT
//---------------------------------

vdic_dut_2022 DUT(.clk(bfm.clk), .rst_n(bfm.rst_n), .enable_n(bfm.enable_n), 
	.din(bfm.din), .dout(bfm.dout), .dout_valid(bfm.dout_valid));

endmodule : top
