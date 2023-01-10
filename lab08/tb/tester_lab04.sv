module tester_lab04(vdic_dut_2022_bfm bfm);
import vdic_dut_2022_pkg::*;	
	
//virtual vdic_dut_2022_bfm bfm;
	bit is_reset;

//function new (virtual vdic_dut_2022_bfm b);
//	bfm=b;
//	bfm.enable_n=1;
//	//bfm.testbench_end=0;
//endfunction: new

function bit [8:0][7:0] get_data(bit [2:0] size);
	bit [8:0][7:0] data;
    bit [2:0] zero_ones;

    zero_ones = 3'($random);
	data=0;
	for(int i=0;i<=(size+1);i++)begin
	if (zero_ones == 3'b000)
        data[i]= 8'h00;
    else if (zero_ones == 3'b111)
        data[i]= 8'hFF;
    else
        data[i]= 8'($random);
	end
return data;    
endfunction : get_data

function operation_t get_cmd();
	
    bit [2:0] rando;
    operation_t op_out;

    rando = 3'($random);

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

function bit get_state();
	bit [1:0] rando;
	bit state;
	rando = 2'($random);
	if (rando==2'b00) state=1;
	else state=0;
	return state;
endfunction

//MAIN TESTER
initial begin
	bit [8:0][7:0]data;
	bit [2:0] no_of_data;
    operation_t curr_cmd;
	bit state;
	
	state=1;
	bfm.send_msg(0,0,CMD_NOP,0,0,state);
	
	is_reset=1;
	repeat (1000) begin : tester_main_blk
		if (is_reset==1) begin
			state=0;
			is_reset=0;
		end
		else begin
		state=get_state();
		is_reset=state;
		end
		no_of_data=3'($random);
		data=get_data(no_of_data);
		curr_cmd=get_cmd();
		//state=get_state();
		bfm.send_packet(data,no_of_data,curr_cmd,0,0,state);
	end
	//bfm.testbench_end=1;
	//#1500;
	//$finish;
end

endmodule  : tester_lab04
