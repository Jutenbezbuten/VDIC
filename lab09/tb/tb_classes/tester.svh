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


function void build_phase(uvm_phase phase);
    command_port = new("command_port", this);
	//bfm.testbench_end=0;
    endfunction : build_phase

//MAIN TESTER
task run_phase(uvm_phase phase);
	bit state;
	command_transaction message;
	phase.raise_objection(this);
	
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
