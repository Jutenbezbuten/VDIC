class command_monitor extends uvm_component;
    `uvm_component_utils(command_monitor)
    
protected virtual vdic_dut_2022_bfm bfm;
uvm_analysis_port #(command_transaction) ap;
	
function new (string name, uvm_component parent);
    super.new(name,parent);
endfunction

function void write_to_monitor(bit [8:0][7:0]data,bit [2:0] no_of_data,operation_t curr_cmd,bit data_parity,bit cmd_parity,bit state);
	//$display("write to scoreboard fifo parity: %d data: %d cmd: %s %t",cmd.cmd_parity, cmd.data, cmd.curr_cmd.name(),$time());
    command_transaction cmd;
    cmd    = new("cmd");
	cmd.data=data;
	cmd.no_of_data=no_of_data;
	cmd.curr_cmd=curr_cmd;
	cmd.data_parity=data_parity;
	cmd.cmd_parity=cmd_parity;
	cmd.state=state;
    ap.write(cmd);
endfunction : write_to_monitor

function void build_phase(uvm_phase phase);

    if(!uvm_config_db #(virtual vdic_dut_2022_bfm)::get(null, "*","bfm", bfm))
        $fatal(1, "Failed to get BFM");
    bfm.command_monitor_h = this;
    ap                    = new("ap",this);
    endfunction : build_phase

endclass
