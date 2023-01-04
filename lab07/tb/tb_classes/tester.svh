class tester extends uvm_component;
	`uvm_component_utils(tester)
	
uvm_put_port #(command_transaction) command_port;
	
 //virtual vdic_dut_2022_bfm bfm;

function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction: new

////Get random data to send. 12.5% of getting all zeros, 12.5% of getting all ones
//pure virtual  function bit [8:0][7:0] get_data(bit [2:0] size);
//
bit is_reset;
//
////get a random command, only implemented ones and invalid
//pure virtual  function operation_t get_cmd();
//
//pure virtual function bit get_parity();
//
//pure virtual function bit get_state();
//
//protected command_s message;
//
//protected function command_s config_msg(bit state);
//	//bit [8:0][7:0] data;
//	command_s message;
//	bit [2:0] number_of_d;
//	//wait(!bfm.dout_valid);
//	//bfm.payload_temp={};
//	//for(int i=0; i<=8; i++)begin
//	//	data[i]=8'b0;
//	//end
//	//data.delete();
//	message.curr_cmd=get_cmd();
//	message.cmd_parity=get_parity();
//	message.data_parity=get_parity();
//	message.state=state;
//	number_of_d=3'($random);
//	message.no_of_data=number_of_d;
//	message.data=get_data(number_of_d);
//	return message;
//	
//	//if (no_args==min) no_of_data=0;
//	//else if (no_args==max) no_of_data=7;
//	//else no_of_data=3'($random);
//	////no_of_data=bfm.no_of_args;
//	//if (values==min) begin
//	//	for(int i=0;i<=no_of_data;i++)begin
//	//		temp=8'b00000000;
//	//		data[i]=temp;
//	//		//data= new [data.size() + 1] (data);
//	//		//data[data.size()-1]=temp;
//	//		//data.insert(i, temp);
//	//	end
//	//	temp=8'b00000000;
//	//	data[no_of_data+1]=temp;
//	//	//data= new [data.size() + 1] (data);
//	//	//data[data.size()-1]=temp;
//	//	//data={data,temp};
//	//end
//	//else if (values==max) begin
//	//	for(int i=0;i<=no_of_data;i++)begin
//	//		temp=8'b11111111;
//	//		data[i]=temp;
//	//		//data= new [data.size() + 1] (data);
//	//		//data[data.size()-1]=temp;
//	//	end
//	//	temp=8'b11111111;
//	//	data[no_of_data+1]=temp;
//	//	//data= new [data.size() + 1] (data);
//	//	//data[data.size()-1]=temp;
//	//end
//	//else begin
//	//	for(int i=0;i<=no_of_data;i++)begin
//	//		temp=get_data();
//	//		data[i]=temp;
//	//		//data= new [data.size() + 1] (data);
//	//		//data[data.size()-1]=temp;
//	//	end
//	//	temp=get_data();
//	//	data[no_of_data+1]=temp;
//	//	//data= new [data.size() + 1] (data);
//	//	//data[data.size()-1]=temp;
//	//end
//	////for(int i=0; i<=bfm.no_of_args+2; i++)begin
//	//		//bfm.data_cov[i]=data[i];
//	////end
//endfunction

function void build_phase(uvm_phase phase);
    command_port = new("command_port", this);
	//bfm.testbench_end=0;
    endfunction : build_phase

//MAIN TESTER
task run_phase(uvm_phase phase);
	bit state;
	command_transaction message;
	phase.raise_objection(this);
	//bfm.reset_alu();
	//config_msg(random, random, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,1);
	//config_msg(random, random, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//bfm.reset_alu();
//	//send_msg(random, random, CMD_ERR);
	//config_msg(random, random, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//bfm.reset_alu();
//	//send_msg(random, random, CMD_ERR);
	//config_msg(random, random, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//bfm.reset_alu();
//	//send_msg(random, random, CMD_ERR);
	//config_msg(random, random, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//bfm.reset_alu();
//	//send_msg(random, random, CMD_ERR);
	//config_msg(random, random, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//bfm.reset_alu();
//	//send_msg(random, random, CMD_ERR);
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//bfm.reset_alu();
//	//send_msg(random, random, CMD_ERR);
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,1,0);
	//config_msg(random, random, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	////annoying transitions
	//config_msg(random, random, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,1);
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,1);
	//config_msg(random, random, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,1);
	//
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,1,0);
	//config_msg(random, random, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,1,0);
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,1,0);
	//config_msg(random, random, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,1,0);
	//
	//config_msg(random, random, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	//config_msg(random, random, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(random, random, CMD_NOP,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	//config_msg(min, min, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, min, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, min, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, min, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, min, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	//config_msg(min, max, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, max, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, max, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, max, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(min, max, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	//config_msg(max, min, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, min, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, min, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, min, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, min, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//
	//config_msg(max, max, CMD_ADD,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, max, CMD_AND,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, max, CMD_OR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, max, CMD_XOR,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//config_msg(max, max, CMD_SUB,bfm.curr_cmd,bfm.data,bfm.no_of_args);
	//bfm.send_msg(bfm.no_of_args,bfm.data,bfm.curr_cmd,0,0);
	//message=config_msg(1);
	message=new("message");
	message.state=1;
	is_reset=1;
	command_port.put(message);
	message    = command_transaction::type_id::create("message");
	repeat (5000) begin : tester_main_blk
		assert(message.randomize());
		if (is_reset==1) begin
			message.state=0;
			is_reset=0;
		end
		else begin
		//state=get_state();
		is_reset=message.state;
		end
		//message=config_msg(state);
		command_port.put(message);
			end
	//bfm.testbench_end=1;
	#1500;
	//$finish;
	phase.drop_objection(this);
endtask

endclass: tester
