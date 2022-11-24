interface vdic_dut_2022_bfm;
import vdic_dut_2022_pkg::*;

//variable declarations
bit clk;
bit din;
bit rst_n;
bit enable_n;
wire dout;
wire dout_valid;
	
bit [2:0] no_of_args; //number of arguments sent to DUT, from 2 to 9
	
bit [7:0] data[];
bit [71:0] data_cov;
operation_t curr_cmd;
bit [9:0] payload_temp [$];
	
bit testbench_end;

modport tlm (import reset_alu, send_msg, read_msg, chip_enable, chip_disable);
	
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

//resets DUT
task reset_alu();
    rst_n = 1'b0;
    @(posedge clk);
	@(posedge clk);
    rst_n = 1'b1;
endtask 

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

    rando = 4'($random);

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

//sends created word
task send_word(input bit [9:0] word);
		for(int bit_count=9;bit_count>=0;bit_count--)begin
			@(negedge clk) din=word[bit_count];
		end
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

endinterface : vdic_dut_2022_bfm