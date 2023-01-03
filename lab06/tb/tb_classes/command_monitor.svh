class command_monitor extends uvm_component;
    `uvm_component_utils(command_monitor)
    
protected virtual vdic_dut_2022_bfm bfm;
uvm_analysis_port #(command_s) ap;
	
function new (string name, uvm_component parent);
    super.new(name,parent);
endfunction

function void write_to_monitor(command_s cmd);
	//$display("write to scoreboard fifo parity: %d data: %d cmd: %s %t",cmd.cmd_parity, cmd.data, cmd.curr_cmd.name(),$time());
    ap.write(cmd);
    
endfunction : write_to_monitor

function void build_phase(uvm_phase phase);

    if(!uvm_config_db #(virtual vdic_dut_2022_bfm)::get(null, "*","bfm", bfm))
        $fatal(1, "Failed to get BFM");
    bfm.command_monitor_h = this;
    ap                    = new("ap",this);
    endfunction : build_phase

endclass
