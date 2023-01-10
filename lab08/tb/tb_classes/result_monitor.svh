class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor)

protected virtual vdic_dut_2022_bfm bfm;
uvm_analysis_port #(result_transaction) ap;

function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void write_to_monitor(result_s r);
	result_transaction result;
	result        = new("result_s");
    result.result = r;
    ap.write(result);
endfunction : write_to_monitor

function void build_phase(uvm_phase phase);
    vdic_dut_2022_agent_config agent_config_h;
        if(!uvm_config_db #(vdic_dut_2022_agent_config)::get(this, "","config", agent_config_h))
            `uvm_fatal("RESULT MONITOR", "Failed to get CONFIG");

        // pass the result_monitor handler to the BFM
        agent_config_h.bfm.result_monitor_h = this;
		
        ap = new("ap",this);
endfunction : build_phase

endclass
