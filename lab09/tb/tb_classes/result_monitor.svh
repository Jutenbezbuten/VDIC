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
    if(!uvm_config_db #(virtual vdic_dut_2022_bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM");
    //bfm.result_monitor_h = this;
    ap                   = new("ap",this);
endfunction : build_phase

	function void connect_phase(uvm_phase phase);
      bfm.result_monitor_h = this;
   endfunction : connect_phase

endclass
