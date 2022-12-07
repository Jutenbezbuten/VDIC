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
stat_t out_stat;
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

	
task send_msg(bit data_err);
	bit [9:0] temp_word;
	chip_enable();
	foreach(data[i])begin
		build_word(0, data[i], temp_word);
		if (data_err==1) temp_word[0]=(~temp_word[0]);
		payload_temp.insert(i,temp_word);
	end
	build_word(1, curr_cmd, temp_word);
	payload_temp={payload_temp,temp_word};
	foreach(payload_temp[i])begin
		send_word(payload_temp[i]);
	end
	chip_disable();

	@(posedge clk);
	@(posedge clk);
endtask

task calc_crc([9:0] word, output bit calc_parity);
	bit [8:0]data;
	data=word [8:0];
	calc_parity=^data;
endtask

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

endinterface : vdic_dut_2022_bfm