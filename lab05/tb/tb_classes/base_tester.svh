virtual class base_tester extends uvm_component;
	
 virtual vdic_dut_2022_bfm bfm;

function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction: new

//Get random data to send. 12.5% of getting all zeros, 12.5% of getting all ones
pure virtual  function bit [7:0] get_data();


//get a random command, only implemented ones and invalid
pure virtual  function operation_t get_cmd();


task config_msg(test_config_t no_args, test_config_t values, operation_t command);
	bit [7:0] temp;
	wait(!bfm.dout_valid);
	bfm.payload_temp={};
	for(int i=0; i<=71; i++)begin
		bfm.data_cov[i]=0;
	end
	bfm.data.delete();
	
	if (command==CMD_INV) bfm.curr_cmd=get_cmd();
	else bfm.curr_cmd=command;
	
	if (no_args==min) bfm.no_of_args=0;
	else if (no_args==max) bfm.no_of_args=7;
	else bfm.no_of_args=3'($random);
	
	if (values==min) begin
		for(int i=0;i<=bfm.no_of_args;i++)begin
			temp=8'b00000000;
			bfm.data= new [bfm.data.size() + 1] (bfm.data);
			bfm.data[bfm.data.size()-1]=temp;
			//data.insert(i, temp);
		end
		temp=8'b00000000;
		bfm.data= new [bfm.data.size() + 1] (bfm.data);
		bfm.data[bfm.data.size()-1]=temp;
		//data={data,temp};
	end
	else if (values==max) begin
		for(int i=0;i<=bfm.no_of_args;i++)begin
			temp=8'b11111111;
			bfm.data= new [bfm.data.size() + 1] (bfm.data);
			bfm.data[bfm.data.size()-1]=temp;
		end
		temp=8'b11111111;
		bfm.data= new [bfm.data.size() + 1] (bfm.data);
		bfm.data[bfm.data.size()-1]=temp;
	end
	else begin
		for(int i=0;i<=bfm.no_of_args;i++)begin
			temp=get_data();
			bfm.data= new [bfm.data.size() + 1] (bfm.data);
			bfm.data[bfm.data.size()-1]=temp;
		end
		temp=get_data();
		bfm.data= new [bfm.data.size() + 1] (bfm.data);
		bfm.data[bfm.data.size()-1]=temp;
	end
	for(int i=0; i<=bfm.no_of_args+2; i++)begin
		for (int j=0; j<=8; j++)begin
			bfm.data_cov[(8*i)+j]=bfm.data[i][j];
		end
	end
endtask

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual vdic_dut_2022_bfm)::get(null, "*","bfm", bfm))
        $fatal(1,"Failed to get BFM");
    bfm.enable_n=1;
	//bfm.testbench_end=0;
    endfunction : build_phase

//MAIN TESTER
task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	bfm.reset_alu();
	config_msg(random, random, CMD_AND);
	bfm.send_msg(0);
	config_msg(random, random, CMD_OR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_XOR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_ADD);
	bfm.send_msg(0);
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(0);
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(0);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	config_msg(random, random, CMD_ADD);
	bfm.send_msg(0);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	config_msg(random, random, CMD_AND);
	bfm.send_msg(0);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	config_msg(random, random, CMD_OR);
	bfm.send_msg(0);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	config_msg(random, random, CMD_XOR);
	bfm.send_msg(0);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(0);
	bfm.reset_alu();
//	send_msg(random, random, CMD_ERR);
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(0);
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(1);
	config_msg(random, random, CMD_ADD);
	bfm.send_msg(0);
	config_msg(random, random, CMD_ADD);
	bfm.send_msg(0);
	config_msg(random, random, CMD_AND);
	bfm.send_msg(0);
	config_msg(random, random, CMD_AND);
	bfm.send_msg(0);
	config_msg(random, random, CMD_OR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_OR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_XOR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_XOR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(0);
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(0);
	
	//annoying transitions
	config_msg(random, random, CMD_ADD);
	bfm.send_msg(0);
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(0);
	config_msg(random, random, CMD_OR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(0);
	
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(0);
	config_msg(random, random, CMD_XOR);
	bfm.send_msg(0);
	
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(0);
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(0);
	config_msg(random, random, CMD_XOR);
	bfm.send_msg(0);
	
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(1);
	config_msg(random, random, CMD_AND);
	bfm.send_msg(1);
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(1);
	config_msg(random, random, CMD_AND);
	bfm.send_msg(1);
	
	config_msg(random, random, CMD_AND);
	bfm.send_msg(0);
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(0);
	
	config_msg(random, random, CMD_SUB);
	bfm.send_msg(0);
	config_msg(random, random, CMD_OR);
	bfm.send_msg(0);
	config_msg(random, random, CMD_NOP);
	bfm.send_msg(0);
	
	config_msg(min, min, CMD_ADD);
	bfm.send_msg(0);
	config_msg(min, min, CMD_AND);
	bfm.send_msg(0);
	config_msg(min, min, CMD_OR);
	bfm.send_msg(0);
	config_msg(min, min, CMD_XOR);
	bfm.send_msg(0);
	config_msg(min, min, CMD_SUB);
	bfm.send_msg(0);
	
	config_msg(min, max, CMD_ADD);
	bfm.send_msg(0);
	config_msg(min, max, CMD_AND);
	bfm.send_msg(0);
	config_msg(min, max, CMD_OR);
	bfm.send_msg(0);
	config_msg(min, max, CMD_XOR);
	bfm.send_msg(0);
	config_msg(min, max, CMD_SUB);
	bfm.send_msg(0);
	
	config_msg(max, min, CMD_ADD);
	bfm.send_msg(0);
	config_msg(max, min, CMD_AND);
	bfm.send_msg(0);
	config_msg(max, min, CMD_OR);
	bfm.send_msg(0);
	config_msg(max, min, CMD_XOR);
	bfm.send_msg(0);
	config_msg(max, min, CMD_SUB);
	bfm.send_msg(0);
	
	config_msg(max, max, CMD_ADD);
	bfm.send_msg(0);
	config_msg(max, max, CMD_AND);
	bfm.send_msg(0);
	config_msg(max, max, CMD_OR);
	bfm.send_msg(0);
	config_msg(max, max, CMD_XOR);
	bfm.send_msg(0);
	config_msg(max, max, CMD_SUB);
	bfm.send_msg(0);
	repeat (1000) begin : tester_main_blk
		config_msg(random, random, CMD_INV);
		bfm.send_msg(0);
	end
	//bfm.testbench_end=1;
	#1500;
	//$finish;
	phase.drop_objection(this);
endtask

endclass: base_tester
