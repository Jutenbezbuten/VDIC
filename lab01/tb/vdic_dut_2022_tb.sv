module vdic_dut_2022_tb;

//---------------------------------
//VAR/TYPE
//---------------------------------


//enum of all operations
typedef enum bit[7:0] {
    CMD_NOP  = 8'b00000000,
    CMD_AND = 8'b00000001,
    CMD_OR = 8'b00000010,
    CMD_XOR = 8'b00000011,
    CMD_ADD = 8'b00010000,
    CMD_SUB = 8'b00100000,
    CMD_ERR= 8'b11111111,//added for testing
    CMD_INV= 8'b11111110//added for testing
} operation_t;
	
typedef enum bit[7:0]{
	S_NO_ERROR=8'b00000000,
	S_MISSING_DATA=8'b00000001,
	S_DATA_STACK_OVERFLOW=8'b00000010,
	S_OUTPUT_FIFO_OVERFLOW=8'b00000100,
	S_DATA_PARITY_ERROR=8'b00100000,
	S_COMMAND_PARITY_ERROR=8'b01000000,
	S_INVALID_COMMAND=8'b10000000
} stat_t;

//enum for test result
typedef enum bit {
    TEST_PASSED,
    TEST_FAILED
} test_result_t;

//variable declarations
bit clk;
bit din;
bit rst_n;
bit enable_n;
wire dout;
wire dout_valid;
	
bit [7:0] data[$];
bit [2:0] no_of_args; //number of arguments sent to DUT, from 2 to 9
operation_t curr_cmd;
bit [9:0] payload_temp [$];
	
bit[15:0] out_data;
stat_t out_stat;
test_result_t result;
//---------------------------------
//CLOCK GENERATION
//---------------------------------
	
initial begin : clk_gen_blk
    clk = 0;
    forever begin : clk_frv_blk
        #10;
        clk = ~clk;
    end
end

//---------------------------------
//DUT
//---------------------------------

vdic_dut_2022 DUT(.clk, .rst_n, .enable_n, .din, .dout, .dout_valid);

//---------------------------------
//TESTER
//---------------------------------

//Get random data to send. 12.5% of getting all zeros, 12.5% of getting all ones
function bit [7:0] get_data();

    bit [2:0] zero_ones;

    zero_ones = 3'($random);

    if (zero_ones == 3'b000)
        return 8'h00;
    else if (zero_ones == 3'b111)
        return 8'hFF;
    else
        return 8'($random);
endfunction : get_data
	

//get a random command, only implemented ones and invalid
function operation_t get_cmd();
	
    bit [1:0] rando;
    operation_t op_out;

    rando = $random;

    if (rando == 2'b00)begin
        op_out=CMD_AND;
    end
    else if (rando == 2'b11)begin
        op_out=CMD_ADD;
    end
    else if (rando == 2'b10)begin
        op_out=CMD_INV;
    end
    else begin
        op_out=CMD_ERR;
    end
    return op_out;
endfunction: get_cmd


//adds payload type bit and parity bit to data
task build_word (input bit payload_t, input byte msg, output bit [9:0] word);
	bit [8:0] word_temp;
	bit crc;
	if(payload_t==1)word_temp={1'b1,msg};
	else word_temp={1'b0,msg};
	crc=^word_temp;
	word={word_temp,crc};
endtask

//sends created word
task send_word(input bit [9:0] word);
		for(int bit_count=9;bit_count>=0;bit_count--)begin
			@(negedge clk) din=word[bit_count];
		end
endtask

//resets DUT
task reset_alu();
    rst_n = 1'b0;
    @(posedge clk);
	@(posedge clk);
    rst_n = 1'b1;
endtask 

//enables data flow to the DUT; waits for dout_valid to go down first
task chip_enable();
	//while(dout_valid==1) @(posedge clk);
	wait(!dout_valid);
	#1 enable_n=1'b0;
endtask

//disables data flow to the DUT;
task chip_disable();
	@(negedge clk);
	#1 enable_n=1'b1;
endtask

//TASKS/FUNCTIONS FOR SIMPLE SCOREBOARD

//reads output message
task automatic read_msg(output bit [15:0] data, output stat_t status);
	bit msg_type;
	bit [7:0] data_buf;
	@(posedge dout_valid);
	read_word(msg_type, data_buf);
	$cast(status, data_buf);
	read_word(msg_type, data_buf);
	data[15:8]=data_buf;
	read_word(msg_type, data_buf);
	data[7:0]=data_buf;
endtask

//reads a single word
task read_word(output bit msg_type, output [7:0] data);
	bit parity;
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

//MAIN TESTER
initial begin: tester
	bit [7:0] temp;
	bit [9:0] temp_word;
	
	bit [15:0] predicted_data;
	int loop_count;
	loop_count=0;
	enable_n=1;
	reset_alu();
	repeat (100) begin : tester_main_blk
		case(loop_count)
			0:begin
				curr_cmd=CMD_ADD;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			1:begin
				curr_cmd=CMD_AND;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			2:begin
				curr_cmd=CMD_ERR;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			3:begin
				curr_cmd=CMD_ADD;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			4:begin
				curr_cmd=CMD_ERR;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			5:begin
				curr_cmd=CMD_AND;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			6:begin
				curr_cmd=CMD_AND;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			7:begin
				curr_cmd=CMD_ADD;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			8:begin
				curr_cmd=CMD_ADD;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			9:begin
				curr_cmd=CMD_ERR;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			10:begin
				curr_cmd=CMD_ERR;
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
				temp=get_data();
				data={data,temp};
			end
			11:begin
				curr_cmd=CMD_ADD;
				no_of_args=7;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b11111111;
					data.insert(i, temp);
				end
				temp=8'b11111111;
				data={data,temp};
			end
			12:begin
				curr_cmd=CMD_ADD;
				no_of_args=7;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b00000000;
					data.insert(i, temp);
				end
				temp=8'b00000000;
				data={data,temp};
			end
			13:begin
				curr_cmd=CMD_ADD;
				no_of_args=0;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b11111111;
					data.insert(i, temp);
				end
				temp=8'b11111111;
				data={data,temp};
			end
			14:begin
				curr_cmd=CMD_ADD;
				no_of_args=0;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b00000000;
					data.insert(i, temp);
				end
				temp=8'b00000000;
				data={data,temp};
			end
			15:begin
				curr_cmd=CMD_AND;
				no_of_args=7;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b11111111;
					data.insert(i, temp);
				end
				temp=8'b11111111;
				data={data,temp};
			end
			16:begin
				curr_cmd=CMD_AND;
				no_of_args=7;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b00000000;
					data.insert(i, temp);
				end
				temp=8'b00000000;
				data={data,temp};
			end
			17:begin
				curr_cmd=CMD_AND;
				no_of_args=0;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b11111111;
					data.insert(i, temp);
				end
				temp=8'b11111111;
				data={data,temp};
			end
			18:begin
				curr_cmd=CMD_AND;
				no_of_args=0;
				for(int i=0;i<=no_of_args;i++)begin
					temp=8'b00000000;
					data.insert(i, temp);
				end
				temp=8'b00000000;
				data={data,temp};
			end
			default begin
				curr_cmd=get_cmd();
				no_of_args=3'($random);
				for(int i=0;i<=no_of_args;i++)begin
					temp=get_data();
					data.insert(i, temp);
				end
		temp=get_data();
		data={data,temp};
			end
		endcase
		case(curr_cmd)
			CMD_ERR : begin 
				#1000;
				reset_alu();
			end
			default begin
				chip_enable();
				foreach(data[i])begin
					build_word(0, data[i], temp_word);
					payload_temp.insert(i,temp_word);
				end
				build_word(1, curr_cmd, temp_word);
				payload_temp={payload_temp,temp_word};
				foreach(payload_temp[i])begin
					send_word(payload_temp[i]);
				end
				chip_disable();
				read_msg(out_data, out_stat);
				predicted_data=0;
				result=TEST_PASSED;
				case(out_stat)
					S_INVALID_COMMAND:begin
						if(curr_cmd==CMD_INV) begin
							$display("Test PASSED, invalid command at %0t",$time);
						end
						else begin
							result=TEST_FAILED;
							$display("Test FAILED, command transfer error at %0t",$time);
						end
					end
					S_NO_ERROR:begin
						case(curr_cmd)
							CMD_AND:begin
								predicted_data=16'hff;
								foreach(data[i]) predicted_data=predicted_data&data[i];
								if(predicted_data==out_data) begin
									$display("Test PASSED, calculation OK at %0t",$time);
								end
								else begin
									result=TEST_FAILED;
									$display("Test FAILED, calculation error at %0t",$time);
								end
							end
							CMD_ADD:begin
								foreach(data[i]) predicted_data=predicted_data+data[i];
								if(predicted_data==out_data) begin
									$display("Test PASSED, calculation OK at %0t",$time);
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
						endcase
					end
					default begin
						result=TEST_FAILED;
						$display("Test FAILED, unknown status at %0t",$time);
					end
				endcase	
			end
		endcase
		payload_temp={};
		data={};
		loop_count++;
		@(posedge clk);
		@(posedge clk);
	end: tester_main_blk;
	
	#1500;
	$finish;
end: tester

final begin
		$display(result);
end

endmodule