class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor)

protected virtual vdic_dut_2022_bfm bfm;
uvm_analysis_port #(result_s) ap;

function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void write_to_monitor(result_s r);
    ap.write(r);
endfunction : write_to_monitor

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual vdic_dut_2022_bfm)::get(null, "*","bfm", bfm))
        $fatal(1, "Failed to get BFM");
    bfm.result_monitor_h = this;
    ap                   = new("ap",this);
endfunction : build_phase

endclass
