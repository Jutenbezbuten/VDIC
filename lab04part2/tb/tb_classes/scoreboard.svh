class scoreboard;
	
virtual vdic_dut_2022_bfm bfm;
    
//enum for test result
protected typedef enum bit {
    TEST_PASSED,
    TEST_FAILED
} test_result_t;

protected bit[15:0] out_data;
protected stat_t out_stat;
protected test_result_t result;
	
function new (virtual vdic_dut_2022_bfm b);
	bfm=b;
endfunction : new

task execute();
bit [15:0] predicted_data;
forever  begin : scoreboard
	@(negedge bfm.clk);
	wait (bfm.dout_valid);
	
	bfm.read_msg(out_data, out_stat);
	predicted_data=0;
	result=TEST_PASSED;
	case(out_stat)
		S_INVALID_COMMAND:begin
			if(bfm.curr_cmd==CMD_INV) begin
				//$display("Test PASSED, invalid command at %0t",$time);
			end
			else begin
				result=TEST_FAILED;
				//$display("Test FAILED, command transfer error at %0t",$time);
			end
		end
		S_NO_ERROR:begin
			case(bfm.curr_cmd)
				CMD_AND:begin
					predicted_data=16'hff;
					foreach(bfm.data[i]) predicted_data=predicted_data&bfm.data[i];
					if(predicted_data==out_data) begin
						//$display("Test PASSED, AND OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						//$display("Test FAILED, AND error at %0t",$time);
					end
				end
				CMD_ADD:begin
					foreach(bfm.data[i]) predicted_data=predicted_data+bfm.data[i];
					if(predicted_data==out_data) begin
						//$display("Test PASSED, calculation OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						//$display("Test FAILED, calculation error at %0t",$time);
					end
				end
				default begin
					result=TEST_FAILED;
					//$display("Test FAILED, invalid command accepted at %0t",$time);
				end
				CMD_NOP : begin 
					if(out_data==0)begin
						//$display("Test PASSED, data cleared",$time);
					end
					else begin
						result=TEST_FAILED;
						//$display("Test FAILED, data not cleared",$time);
					end
				end
				CMD_OR : begin 
					foreach(bfm.data[i]) predicted_data=predicted_data|bfm.data[i];
					if(predicted_data==out_data) begin
						//$display("Test PASSED, OR OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						//$display("Test FAILED, OR error at %0t",$time);
					end
				end
				CMD_XOR : begin 
					foreach(bfm.data[i]) predicted_data=predicted_data^bfm.data[i];
					if(predicted_data==out_data) begin
						//$display("Test PASSED, XOR OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						//$display("Test FAILED, XOR error at %0t",$time);
					end
				end
				CMD_SUB : begin 
					predicted_data=bfm.data[0];
					for(int i=1;i<=bfm.data.size();i++) predicted_data=predicted_data-bfm.data[i];
					if(predicted_data==out_data) begin
						//$display("Test PASSED, calculation OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						//$display("Test FAILED, calculation error at %0t",$time);
					end
				end
			endcase
		end
		default begin
			result=TEST_FAILED;
		//	$display("Test FAILED, unknown status at %0t",$time);
		end
	endcase	
	if (bfm.testbench_end==1)begin
	if (!result) $display("Test PASSED!!!");
	else $display("Test FAILED");
	$finish;
	end
end : scoreboard
endtask

endclass : scoreboard
