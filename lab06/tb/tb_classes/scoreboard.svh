class scoreboard extends uvm_subscriber #(result_s);
    `uvm_component_utils(scoreboard)
       
//enum for test result
protected typedef enum bit {
    TEST_PASSED,
    TEST_FAILED
} test_result_t;

	command_s msg;
	
protected test_result_t result;
//virtual vdic_dut_2022_bfm bfm;
uvm_tlm_analysis_fifo #(command_s) din_msg;
	
function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
    din_msg = new ("din_msg", this);
endfunction : build_phase

function void write(result_s t);

bit [15:0] predicted_data;
bit calc_parity;
bit [7:0] data_in [];
	bit [7:0] status_received;
	 //$display("scoreboard %d %d %d %t",msg.cmd_parity, msg.data, msg.curr_cmd,$time());
	 do begin
	if (!din_msg.try_get(msg)) $fatal(1, "Missing command in self checker");
	 end
	 while((msg.state==1));
	//if (t.parity_err==1) begin
	//	result = TEST_FAILED;
	//end	
	data_in=new[msg.no_of_data+2];
	for(int i=0; i<=(msg.no_of_data+1);i++) begin
		data_in[i]=msg.data[i];
	end
	
	//bfm.read_msg(out_data, bfm.out_stat);
	predicted_data=0;
	calc_parity=0;
	result=TEST_PASSED;
	if(t.out_stat  != 0)begin
	if(t.out_stat & S_INVALID_COMMAND)begin
		if(msg.curr_cmd==CMD_INV) begin
				//$display("Test PASSED, invalid command at %0t",$time);
			end
			else begin
				result=TEST_FAILED;
				$display("Test FAILED, command transfer error at %0t, detected cmd %s",$time,msg.curr_cmd.name());
			end
	end
	if(t.out_stat & S_DATA_PARITY_ERROR)begin
		if (msg.data_parity!=1)begin
			result=TEST_FAILED;
			$display("Test FAILED, data parity error at %0t",$time);
			end
	end
	if(t.out_stat & S_COMMAND_PARITY_ERROR)begin
		if (msg.cmd_parity!=1)begin
			result=TEST_FAILED;
			$display("Test FAILED, command parity error at %0t",$time);
		end
	end
	end
	else begin
	
	//case(t.out_stat)
	//	S_INVALID_COMMAND:begin
	//		if(msg.curr_cmd==CMD_INV) begin
	//			//$display("Test PASSED, invalid command at %0t",$time);
	//		end
	//		else begin
	//			result=TEST_FAILED;
	//			//$display("Test FAILED, command transfer error at %0t",$time);
	//		end
	//	end
	//	S_DATA_PARITY_ERROR: begin
	//			if (msg.data_parity!=1) result=TEST_FAILED;
	//	end
	//	S_COMMAND_PARITY_ERROR: begin
	//		if (msg.cmd_parity!=1) result=TEST_FAILED;
	//	end
	//	S_NO_ERROR:begin
			case(msg.curr_cmd)
				CMD_AND:begin
					predicted_data=16'hff;
					foreach(data_in[i]) predicted_data=predicted_data&data_in[i];
					if(predicted_data==t.data) begin
						//$display("Test PASSED, AND OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						$display("Test FAILED, AND error at %0t",$time);
					end
				end
				CMD_ADD:begin
					foreach(data_in[i]) predicted_data=predicted_data+data_in[i];
					if(predicted_data==t.data) begin
						//$display("Test PASSED, calculation OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						$display("Test FAILED, calculation error at %0t",$time);
					end
				end
				default begin
					result=TEST_FAILED;
					$display("Test FAILED, invalid command accepted at %0t",$time);
				end
				CMD_NOP : begin 
					if(t.data==0)begin
						//$display("Test PASSED, data cleared",$time);
					end
					else begin
						result=TEST_FAILED;
						$display("Test FAILED, data not cleared",$time);
					end
				end
				CMD_OR : begin 
					foreach(data_in[i]) predicted_data=predicted_data|data_in[i];
					if(predicted_data==t.data) begin
						//$display("Test PASSED, OR OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						$display("Test FAILED, OR error at %0t",$time);
					end
				end
				CMD_XOR : begin 
					foreach(data_in[i]) predicted_data=predicted_data^data_in[i];
					if(predicted_data==t.data) begin
						//$display("Test PASSED, XOR OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						$display("Test FAILED, XOR error at %0t",$time);
					end
				end
				CMD_SUB : begin 
					predicted_data = data_in[0];
					for(int i=1;i<data_in.size();i++) predicted_data=predicted_data-data_in[i];
					if(predicted_data==t.data) begin
						//$display("Test PASSED, calculation OK at %0t",$time);
					end
					else begin
						result=TEST_FAILED;
						$display("Test FAILED, calculation error at %0t",$time);
					end
				end
			endcase
	
	end
	//	end
	//	default begin
	//		result=TEST_FAILED;
	//	//	$display("Test FAILED, unknown status at %0t",$time);
	//	end
	//endcase	
	//if (bfm.testbench_end==1)begin
	//if (!result) $display("Test PASSED!!!");
	//else $display("Test FAILED");
	//$finish;
	//end
endfunction

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (!result) $display("Test PASSED!!!");
	else $display("Test FAILED");
endfunction : report_phase

endclass : scoreboard
