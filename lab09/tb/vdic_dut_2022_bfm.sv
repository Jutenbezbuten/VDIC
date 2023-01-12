interface vdic_dut_2022_bfm;
import vdic_dut_2022_pkg::*;

//variable declarations
bit clk;
bit din;
bit rst_n;
bit enable_n;
wire dout;
wire dout_valid;
bit packet_rdy;

//command_s din_msg;
	
bit [2:0] no_of_args_din; //number of arguments sent to DUT, from 2 to 9
//	
bit [8:0][7:0] data_din;
////bit [8:0][7:0] data_cov;
operation_t curr_cmd_din;
bit data_parity_din;
bit cmd_parity_din;
bit state_din;

stat_t out_stat;
bit [15:0] data_out;
	bit initial_reset=0;
//bit [9:0] payload_temp [$];
int word_cnt;	
//bit testbench_end;
	
command_monitor command_monitor_h;
result_monitor result_monitor_h;

//modport tlm (import reset_alu, send_msg, read_msg, chip_enable, chip_disable);
	
//---------------------------------
//CLOCK GENERATION
//---------------------------------
	
initial begin : clk_gen_blk
    clk = 0;
	enable_n=1;
    forever begin : clk_frv_blk
        #10;
        clk = ~clk;
    end
end

//resets DUT
task reset_alu();
	enable_n=1;
	//packet_rdy = 1'b0;
	@(negedge dout_valid);
    rst_n = 1'b0;
    @(posedge clk);
	@(posedge clk);
	@(posedge clk);
    rst_n = 1'b1;
endtask 

task start_alu();
	rst_n = 1'b1;
endtask

//adds payload type bit and parity bit to data
task build_word (input bit payload_t, input byte msg, output bit [9:0] word);
	bit [8:0] word_temp;
	bit crc;
	if(payload_t==1)word_temp={1'b1,msg};
	else word_temp={1'b0,msg};
	crc=^word_temp;
	word={word_temp,crc};
	//if(payload_t==1'b1) $display("command word: %b",word);
endtask

//enables data flow to the DUT; waits for dout_valid to go down first
task chip_enable();
	//while(dout_valid==1) @(posedge clk);
	wait(!dout_valid);
	enable_n=1'b0;
endtask

//disables data flow to the DUT;
task chip_disable();
	@(negedge clk);
	enable_n=1'b1;
endtask

//sends created word
task send_word(input bit [9:0] word);
		for(int bit_count=9;bit_count>=0;bit_count--)begin
			@(negedge clk) din=word[bit_count];
			enable_n =0;
		end
endtask

	
task send_msg(bit [2:0] no_of_data,bit [8:0][7:0] data,operation_t curr_cmd,bit data_err, bit cmd_err, bit state);
	if(state==1)begin
		if (initial_reset==0)begin
			enable_n=1;
			//packet_rdy = 1'b0;
    		rst_n = 1'b0;
    		@(posedge clk);
			@(posedge clk);
			@(posedge clk);
    		rst_n = 1'b1;
			initial_reset=1;
		end
		else reset_alu();
	end
	else begin
		bit [9:0] temp_word;
		
		for(word_cnt=0;word_cnt<=(no_of_data+ 1);word_cnt++)begin
			build_word(0, data[word_cnt], temp_word);
			if (data_err==1) temp_word[0]=(~temp_word[0]);
			//payload_temp.insert(i,temp_word);
			send_word(temp_word);
		end
		build_word(1, curr_cmd, temp_word);
		if (cmd_err==1) temp_word[0]=(~temp_word[0]);
		send_word(temp_word);
//		enable_n =1;
		//@(posedge clk);
		//payload_temp={payload_temp,temp_word};
		//foreach(payload_temp[i])begin
			//send_word(payload_temp[i]);
		//end
	end

endtask

task send_packet(input bit [8:0][7:0] data,input bit [2:0] no_of_args, input operation_t curr_cmd,
	input bit data_parity, input bit cmd_parity, input bit state);
	//din_msg = packet;
	data_din=data;
	no_of_args_din=no_of_args;
	curr_cmd_din=curr_cmd;
	data_parity_din=data_parity;
	cmd_parity_din=cmd_parity;
	state_din=state;
	packet_rdy = 1'b1;
	//while(rst_n==0) @(posedge clk);
//	chip_enable();
	send_msg(no_of_args,data,curr_cmd,data_parity,cmd_parity, state);
	chip_disable();
	//@(posedge clk);
	//@(posedge clk);
	endtask

task calc_crc([9:0] word, output bit calc_parity);
	bit [8:0]data;
	data=word [9:1];
	calc_parity=^data;
endtask

//------------------------------------------------------------------------------
// write command monitor
//------------------------------------------------------------------------------

//always @(posedge clk) begin : op_monitor
//    static bit in_command = 0;
//    if (enable_n==0) begin : start_high
//        if (!in_command) begin : new_command
//            command_monitor_h.write_to_monitor(din_msg);
//            in_command = 1;
//        end : new_command
//    end : start_high
//    else // start low
//        in_command = 0;
//end : op_monitor

//reads output message
task automatic read_msg(output bit [15:0] data, output stat_t status);
	bit msg_type;
	bit parity;
	bit [7:0] data_buf;
	read_word(msg_type, data_buf, parity);
	$cast(status, data_buf);
	read_word(msg_type, data_buf, parity);
	data[15:8]=data_buf;
	read_word(msg_type, data_buf, parity);
	data[7:0]=data_buf;
endtask

//reads a single word
task read_word(output bit msg_type, output [7:0] data, output bit parity);
	data=0;
	@(posedge clk);
	msg_type=dout;
	for(int i=7;i>=0;i--)begin
		@(posedge clk); 
		data[i]=dout;
	end
	@(posedge clk);
	parity=dout;
endtask

//------------------------------------------------------------------------------
// write result monitor
//------------------------------------------------------------------------------
initial begin : packet_sender
	packet_rdy = 1'b0;
	
	forever begin
		@(posedge packet_rdy);
		//$display("command_monitor no of data: %d reset: %d cmd: %s %t",din_msg.no_of_data, din_msg.state, din_msg.curr_cmd.name(),$time());
			command_monitor_h.write_to_monitor(data_din,no_of_args_din,curr_cmd_din,data_parity_din,cmd_parity_din,state_din);
		packet_rdy = 1'b0;
	end
	
end : packet_sender


initial begin : result_monitor_thread
	result_s result;
	bit [29:0] out_buffer;
	bit [7:0] data_buf;
	stat_t buff;
    forever begin
        //while(dout_valid!==1'b1) @(negedge clk);
        @(posedge  dout_valid);
        @(negedge  clk);
        for (int i=0; i<30; i++) begin
			out_buffer[29-i]=dout;
			@(negedge clk);
        end
        data_buf=out_buffer[28:21];
        //$cast(buff, data_buf);
        result.out_stat=data_buf;
		result.data={out_buffer[18:11], out_buffer[8:1]};
        data_out=result.data;
        out_stat=result.out_stat;
		result.parity_err=0;
       // $display("result_monitor %s %t",result.out_stat.name(), $time());
        
        	result_monitor_h.write_to_monitor(result);
    end
end : result_monitor_thread

endinterface : vdic_dut_2022_bfm