module vdic_dut_2022_1_tb;

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
 //   CMD_ERR= 8'b11111111,//added for testing
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
	
typedef enum bit [1:0] {
    min=2'b00,
    max=2'b01,
    random=2'b10
} test_config_t;

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
	
bit [7:0] data[];
bit [71:0] data_cov;
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
//COVERAGE
//---------------------------------

// Covergroup checking the op codes and their sequences
covergroup op_cov;

    option.name = "op_cov";

    cov_op: coverpoint curr_cmd {
        // #A1 test all operations
        bins A1_single_cycle[] = {[CMD_NOP:CMD_SUB]};
	    ignore_bins null_ops = {CMD_INV};
        // #A6 two operations in row
        bins A6_twoops[]       = ([CMD_NOP:CMD_SUB] [* 2]);

    }

endgroup

covergroup zeros_or_ones_on_ops;

    option.name = "zeros_or_ones_on_ops";

    all_ops : coverpoint curr_cmd {
        ignore_bins null_ops = {CMD_NOP, CMD_INV};
    }

    data_vals: coverpoint data_cov {
        bins min_min ={72'h000000000000000000};
	    bins min_max ={72'h00000000000000FFFF};
	    bins max_max ={72'hFFFFFFFFFFFFFFFFFF};
	    bins others ={[72'h000000000000000000:72'h00000000000000FFFE],[72'h000000000000010000:72'hFFFFFFFFFFFFFFFFFF]};
    }


    B_op_00_FF: cross data_vals, all_ops {

        // #B1 simulate all zero input for all the operations

        bins B1_add_00          = binsof (all_ops) intersect {CMD_ADD} &&
        binsof (data_vals.min_min);

        bins B1_and_00          = binsof (all_ops) intersect {CMD_AND} &&
        binsof (data_vals.min_min);

        bins B1_xor_00          = binsof (all_ops) intersect {CMD_XOR} &&
        binsof (data_vals.min_min);

        bins B1_or_00          = binsof (all_ops) intersect {CMD_OR} &&
        binsof (data_vals.min_min);
	    
	    bins B1_sub_00          = binsof (all_ops) intersect {CMD_SUB} &&
        binsof (data_vals.min_min);

        // #B2 simulate all one input for all the operations

        bins B1_add_01          = binsof (all_ops) intersect {CMD_ADD} &&
        binsof (data_vals.min_max);

        bins B1_and_01          = binsof (all_ops) intersect {CMD_AND} &&
        binsof (data_vals.min_max);

        bins B1_xor_01          = binsof (all_ops) intersect {CMD_XOR} &&
        binsof (data_vals.min_max);

        bins B1_or_01          = binsof (all_ops) intersect {CMD_OR} &&
        binsof (data_vals.min_max);
	    
	    bins B1_sub_01          = binsof (all_ops) intersect {CMD_SUB} &&
        binsof (data_vals.min_max);
	    
	    // #B2 simulate all one input for all the operations

        bins B1_add_11          = binsof (all_ops) intersect {CMD_ADD} &&
        binsof (data_vals.max_max);

        bins B1_and_11          = binsof (all_ops) intersect {CMD_AND} &&
        binsof (data_vals.max_max);

        bins B1_xor_11          = binsof (all_ops) intersect {CMD_XOR} &&
        binsof (data_vals.max_max);

        bins B1_or_11          = binsof (all_ops) intersect {CMD_OR} &&
        binsof (data_vals.max_max);
	    
	    bins B1_sub_11          = binsof (all_ops) intersect {CMD_SUB} &&
        binsof (data_vals.max_max);

        ignore_bins others_only =
        binsof(data_vals.others);
    }

endgroup

covergroup rst_ops;

    option.name = "rst_ops";

    ops_rst: coverpoint curr_cmd {
        // #A1 test all operations
        bins A1_single_cycle[] = {CMD_AND,CMD_ADD,CMD_XOR,CMD_OR,CMD_SUB,CMD_NOP};
	    ignore_bins null_ops = {CMD_INV};
    }
    
    rst: coverpoint rst_n{
	    bins rst_en=(1=>0);
	    bins rst_den=(0=>1);
    }
    ops_on_rst: cross rst, ops_rst{
	    bins R1_add_before          = binsof (ops_rst) intersect {CMD_ADD} &&
        binsof (rst.rst_en);

        bins R1_and_before          = binsof (ops_rst) intersect {CMD_AND} &&
        binsof (rst.rst_en);

        bins R1_xor_before          = binsof (ops_rst) intersect {CMD_XOR} &&
        binsof (rst.rst_en);

        bins R1_or_before          = binsof (ops_rst) intersect {CMD_OR} &&
        binsof (rst.rst_en);
	    
	    bins R1_sub_before          = binsof (ops_rst) intersect {CMD_SUB} &&
        binsof (rst.rst_en);
	    
	    bins R1_nop_before          = binsof (ops_rst) intersect {CMD_NOP} &&
        binsof (rst.rst_en);

        // #B2 simulate all one input for all the operations

        bins R1_add_after          = binsof (ops_rst) intersect {CMD_ADD} &&
        binsof (rst.rst_den);

        bins R1_and_after          = binsof (ops_rst) intersect {CMD_AND} &&
        binsof (rst.rst_den);

        bins R1_xor_after          = binsof (ops_rst) intersect {CMD_XOR} &&
        binsof (rst.rst_den);

        bins R1_or_after          = binsof (ops_rst) intersect {CMD_OR} &&
        binsof (rst.rst_den);
	    
	    bins R1_sub_after          = binsof (ops_rst) intersect {CMD_SUB} &&
        binsof (rst.rst_den);
	    
	    bins R1_nop_after          = binsof (ops_rst) intersect {CMD_NOP} &&
        binsof (rst.rst_en);
    }

endgroup

op_cov oc;
zeros_or_ones_on_ops        c_00_FF;
rst_ops rst_cov;


initial begin : coverage
    oc      = new();
	c_00_FF = new();
	rst_cov=new();
    forever begin 
	    @(negedge clk);
        oc.sample();
	    c_00_FF.sample();
	    rst_cov.sample();
    end
end : coverage
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
	
    bit [3:0] rando;
    operation_t op_out;

    rando = $random;

    if (rando == 3'b000)begin
        op_out=CMD_AND;
    end
    else if (rando == 3'b001)begin
        op_out=CMD_ADD;
    end
    else if (rando == 3'b010)begin
        op_out=CMD_OR;
    end
    else if (rando == 3'b011)begin
        op_out=CMD_XOR;
    end
    else if (rando == 3'b100)begin
        op_out=CMD_SUB;
    end
    else if (rando == 3'b101)begin
        op_out=CMD_NOP;
    end
    else if (rando == 3'b110)begin
        op_out=CMD_INV;
    end
    else begin
 //       op_out=CMD_ERR;
	    op_out=CMD_INV;
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

task send_msg(test_config_t no_args, test_config_t values, operation_t command);
	bit [7:0] temp;
	bit [9:0] temp_word;
	wait(!dout_valid);
	payload_temp={};
	for(int i=0; i<=71; i++)begin
		data_cov[i]=0;
	end
	data.delete();
	
	if (command==CMD_INV) curr_cmd=get_cmd();
	else curr_cmd=command;
	
	if (no_args==min) no_of_args=0;
	else if (no_args==max) no_of_args=7;
	else no_of_args=3'($random);
	
	if (values==min) begin
		for(int i=0;i<=no_of_args;i++)begin
			temp=8'b00000000;
			data= new [data.size() + 1] (data);
			data[data.size()-1]=temp;
			//data.insert(i, temp);
		end
		temp=8'b00000000;
		data= new [data.size() + 1] (data);
		data[data.size()-1]=temp;
		//data={data,temp};
	end
	else if (values==max) begin
		for(int i=0;i<=no_of_args;i++)begin
			temp=8'b11111111;
			data= new [data.size() + 1] (data);
			data[data.size()-1]=temp;
		end
		temp=8'b11111111;
		data= new [data.size() + 1] (data);
		data[data.size()-1]=temp;
	end
	else begin
		for(int i=0;i<=no_of_args;i++)begin
			temp=get_data();
			data= new [data.size() + 1] (data);
			data[data.size()-1]=temp;
		end
		temp=get_data();
		data= new [data.size() + 1] (data);
		data[data.size()-1]=temp;
	end
	for(int i=0; i<=no_of_args+2; i++)begin
		for (int j=0; j<=8; j++)begin
			data_cov[(8*i)+j]=data[i][j];
		end
	end
	case(curr_cmd)
//		CMD_ERR : begin 
//			#1000;
//			reset_alu();
//		end
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
		end
	endcase
	@(posedge clk);
	@(posedge clk);
endtask

//MAIN TESTER
initial begin: tester
	int loop_count;
	loop_count=0;
	enable_n=1;
	reset_alu();
	send_msg(random, random, CMD_AND);
	send_msg(random, random, CMD_OR);
	send_msg(random, random, CMD_XOR);
	send_msg(random, random, CMD_ADD);
	send_msg(random, random, CMD_SUB);
	send_msg(random, random, CMD_NOP);
	reset_alu();
//	send_msg(random, random, CMD_ERR);
	send_msg(random, random, CMD_ADD);
	reset_alu();
//	send_msg(random, random, CMD_ERR);
	send_msg(random, random, CMD_AND);
	reset_alu();
//	send_msg(random, random, CMD_ERR);
	send_msg(random, random, CMD_OR);
	reset_alu();
//	send_msg(random, random, CMD_ERR);
	send_msg(random, random, CMD_XOR);
	reset_alu();
//	send_msg(random, random, CMD_ERR);
	send_msg(random, random, CMD_SUB);
	reset_alu();
//	send_msg(random, random, CMD_ERR);
	send_msg(random, random, CMD_NOP);
	send_msg(random, random, CMD_NOP);
	send_msg(random, random, CMD_ADD);
	send_msg(random, random, CMD_ADD);
	send_msg(random, random, CMD_AND);
	send_msg(random, random, CMD_AND);
	send_msg(random, random, CMD_OR);
	send_msg(random, random, CMD_OR);
	send_msg(random, random, CMD_XOR);
	send_msg(random, random, CMD_XOR);
	send_msg(random, random, CMD_SUB);
	send_msg(random, random, CMD_SUB);
	
	send_msg(min, min, CMD_ADD);
	send_msg(min, min, CMD_AND);
	send_msg(min, min, CMD_OR);
	send_msg(min, min, CMD_XOR);
	send_msg(min, min, CMD_SUB);
	
	send_msg(min, max, CMD_ADD);
	send_msg(min, max, CMD_AND);
	send_msg(min, max, CMD_OR);
	send_msg(min, max, CMD_XOR);
	send_msg(min, max, CMD_SUB);
	
	send_msg(max, min, CMD_ADD);
	send_msg(max, min, CMD_AND);
	send_msg(max, min, CMD_OR);
	send_msg(max, min, CMD_XOR);
	send_msg(max, min, CMD_SUB);
	
	send_msg(max, max, CMD_ADD);
	send_msg(max, max, CMD_AND);
	send_msg(max, max, CMD_OR);
	send_msg(max, max, CMD_XOR);
	send_msg(max, max, CMD_SUB);
	repeat (1000) begin : tester_main_blk
		send_msg(random, random, CMD_INV);
	end
	#1500;
	$finish;
end: tester

//---------------------------------
//SCOREBOARD
//---------------------------------

always @(negedge clk) begin : scoreboard
	bit [15:0] predicted_data;
	wait (dout_valid);
	
	read_msg(out_data, out_stat);
				predicted_data=0;
				result=TEST_PASSED;
				case(out_stat)
					S_INVALID_COMMAND:begin
						if(curr_cmd==CMD_INV) begin
							//$display("Test PASSED, invalid command at %0t",$time);
						end
						else begin
							result=TEST_FAILED;
							//$display("Test FAILED, command transfer error at %0t",$time);
						end
					end
					S_NO_ERROR:begin
						case(curr_cmd)
							CMD_AND:begin
								predicted_data=16'hff;
								foreach(data[i]) predicted_data=predicted_data&data[i];
								if(predicted_data==out_data) begin
									//$display("Test PASSED, AND OK at %0t",$time);
								end
								else begin
									result=TEST_FAILED;
									//$display("Test FAILED, AND error at %0t",$time);
								end
							end
							CMD_ADD:begin
								foreach(data[i]) predicted_data=predicted_data+data[i];
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
								foreach(data[i]) predicted_data=predicted_data|data[i];
								if(predicted_data==out_data) begin
									//$display("Test PASSED, OR OK at %0t",$time);
								end
								else begin
									result=TEST_FAILED;
									//$display("Test FAILED, OR error at %0t",$time);
								end
							end
							CMD_XOR : begin 
								foreach(data[i]) predicted_data=predicted_data^data[i];
								if(predicted_data==out_data) begin
									//$display("Test PASSED, XOR OK at %0t",$time);
								end
								else begin
									result=TEST_FAILED;
									//$display("Test FAILED, XOR error at %0t",$time);
								end
							end
							CMD_SUB : begin 
								predicted_data=data[0];
								for(int i=1;i<=data.size();i++) predicted_data=predicted_data-data[i];
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
end : scoreboard

final begin
	if (!result) $display("Test PASSED!!!");
	else $display("Test FAILED");
end

endmodule
