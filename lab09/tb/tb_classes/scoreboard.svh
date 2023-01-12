class scoreboard extends uvm_subscriber #(result_transaction);
    `uvm_component_utils(scoreboard)
       
//enum for test result
protected typedef enum bit {
    TEST_PASSED,
    TEST_FAILED
} test_result_t;

	//command_s msg;
	
local test_result_t result=TEST_PASSED;
//virtual vdic_dut_2022_bfm bfm;
uvm_tlm_analysis_fifo #(sequence_item) din_msg;
	
function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
    din_msg = new ("din_msg", this);
endfunction : build_phase

local function result_transaction predict_result(sequence_item cmd);
        result_transaction predicted;
		
	bit [7:0] data_in [];
	data_in=new[cmd.no_of_data+2];
	foreach(data_in[i])begin
		data_in[i]=cmd.data[i];
	end
	
        predicted = new("predicted");
	predicted.result.out_stat=S_NO_ERROR;
	predicted.result.parity_err=0;
	if((cmd.curr_cmd!=CMD_ADD)&&(cmd.curr_cmd!=CMD_AND)&&(cmd.curr_cmd!=CMD_OR)&&(cmd.curr_cmd!=CMD_XOR)&&
		(cmd.curr_cmd!=CMD_NOP)&&(cmd.curr_cmd!=CMD_SUB))begin
			predicted.result.out_stat|=S_INVALID_COMMAND;
		end
	if(cmd.data_parity)begin
		predicted.result.out_stat|=S_DATA_PARITY_ERROR;
	end
	if(cmd.cmd_parity)begin
		//predicted.result.out_stat|=S_COMMAND_PARITY_ERROR;
	end
        case (cmd.curr_cmd)
            CMD_AND:begin 
	            predicted.result.data=16'hffff;
				foreach(data_in[i]) predicted.result.data=predicted.result.data&data_in[i];
	        end
            CMD_ADD:begin 
				foreach(data_in[i]) predicted.result.data=predicted.result.data+data_in[i];
	        end
            CMD_NOP: begin predicted.result.data = 0;
	           end
            CMD_OR: begin 
				foreach(data_in[i]) predicted.result.data=predicted.result.data|data_in[i];
	        end
	        CMD_XOR:begin 
				foreach(data_in[i]) predicted.result.data=predicted.result.data^data_in[i];
	        end
	        CMD_SUB: begin 
					predicted.result.data = data_in[0];
					for(int i=1;i<data_in.size();i++) predicted.result.data=predicted.result.data-data_in[i];
	        end
	        default:begin
		        //predicted.result.out_stat=|S_INVALID_COMMAND;
	        end
        endcase // case (op_set)
        if(predicted.result.out_stat!=S_NO_ERROR)begin
	    	predicted.result.data=0;
	    end
        return predicted;

    endfunction : predict_result

function void write(result_transaction t);
	string data_str;
	sequence_item cmd;
	result_transaction predicted;
//bit [15:0] predicted_data;

//bit [7:0] data_in [];
	//bit [7:0] status_received;
	 //$display("scoreboard %d %d %d %t",msg.cmd_parity, msg.data, msg.curr_cmd,$time());
	 do begin
	if (!din_msg.try_get(cmd)) $fatal(1, "Missing command in self checker");
	 end
	 while((cmd.state==1));
	//if (t.parity_err==1) begin
	//	result = TEST_FAILED;
	//end	
	//bfm.read_msg(out_data, bfm.out_stat);
	predicted=predict_result(cmd);
	data_str  = { cmd.convert2string(),
            " ==>  Actual " , t.convert2string(),
            "/Predicted ",predicted.convert2string()};

        if (!predicted.compare(t)) begin
            `uvm_error("SELF CHECKER", {"FAIL: ",data_str})
            result = TEST_FAILED;
        end
        else
            `uvm_info ("SELF CHECKER", {"PASS: ", data_str}, UVM_HIGH)

    endfunction : write

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (!result) $display("Test PASSED!!!");
	else $display("Test FAILED");
endfunction : report_phase

endclass : scoreboard
