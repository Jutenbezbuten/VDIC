module tester(vdic_dut_2022_bfm bfm);
import vdic_dut_2022_pkg::*;

	
typedef enum bit [1:0] {
    min=2'b00,
    max=2'b01,
    random=2'b10
} test_config_t;
	

//MAIN TESTER
initial begin: tester
	int loop_count;
	loop_count=0;
	bfm.enable_n=1;
	bfm.reset_alu();
	bfm.send_msg(random, random, CMD_AND);
	bfm.send_msg(random, random, CMD_OR);
	bfm.send_msg(random, random, CMD_XOR);
	bfm.send_msg(random, random, CMD_ADD);
	bfm.send_msg(random, random, CMD_SUB);
	bfm.send_msg(random, random, CMD_NOP);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	bfm.send_msg(random, random, CMD_ADD);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	bfm.send_msg(random, random, CMD_AND);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	bfm.send_msg(random, random, CMD_OR);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	bfm.send_msg(random, random, CMD_XOR);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	bfm.send_msg(random, random, CMD_SUB);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	bfm.send_msg(random, random, CMD_NOP);
	bfm.send_msg(random, random, CMD_NOP);
	bfm.send_msg(random, random, CMD_ADD);
	bfm.send_msg(random, random, CMD_ADD);
	bfm.send_msg(random, random, CMD_AND);
	bfm.send_msg(random, random, CMD_AND);
	bfm.send_msg(random, random, CMD_OR);
	bfm.send_msg(random, random, CMD_OR);
	bfm.send_msg(random, random, CMD_XOR);
	bfm.send_msg(random, random, CMD_XOR);
	bfm.send_msg(random, random, CMD_SUB);
	bfm.send_msg(random, random, CMD_SUB);
	
	bfm.send_msg(min, min, CMD_ADD);
	bfm.send_msg(min, min, CMD_AND);
	bfm.send_msg(min, min, CMD_OR);
	bfm.send_msg(min, min, CMD_XOR);
	bfm.send_msg(min, min, CMD_SUB);
	
	bfm.send_msg(min, max, CMD_ADD);
	bfm.send_msg(min, max, CMD_AND);
	bfm.send_msg(min, max, CMD_OR);
	bfm.send_msg(min, max, CMD_XOR);
	bfm.send_msg(min, max, CMD_SUB);
	
	bfm.send_msg(max, min, CMD_ADD);
	bfm.send_msg(max, min, CMD_AND);
	bfm.send_msg(max, min, CMD_OR);
	bfm.send_msg(max, min, CMD_XOR);
	bfm.send_msg(max, min, CMD_SUB);
	
	bfm.send_msg(max, max, CMD_ADD);
	bfm.send_msg(max, max, CMD_AND);
	bfm.send_msg(max, max, CMD_OR);
	bfm.send_msg(max, max, CMD_XOR);
	bfm.send_msg(max, max, CMD_SUB);
	repeat (1000) begin : tester_main_blk
		bfm.send_msg(random, random, CMD_INV);
	end
	#1500;
	$finish;
end: tester

endmodule : tester