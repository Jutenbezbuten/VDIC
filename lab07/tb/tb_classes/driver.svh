class driver extends uvm_component;
    `uvm_component_utils(driver)

virtual vdic_dut_2022_bfm bfm;
uvm_get_port #(command_transaction) command_port;
	
function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual vdic_dut_2022_bfm)::get(null, "*","bfm", bfm))
        $fatal(1, "Failed to get BFM");
    command_port = new("command_port",this);
endfunction : build_phase

task run_phase(uvm_phase phase);
    command_transaction command;
    //result_s result;
	bfm.rst_n=1;
    forever begin : command_loop
        command_port.get(command);
	    //$display("data sent data: %d command: %s size: %d time: %t",command.data, command.curr_cmd.name(), command.no_of_data, $time());
	    bfm.send_packet(command.data,command.no_of_data,command.curr_cmd,command.data_parity,command.cmd_parity,command.state);
         //   bfm.send_op(command.A, command.B, command.op, result);
    end : command_loop
endtask : run_phase

endclass
