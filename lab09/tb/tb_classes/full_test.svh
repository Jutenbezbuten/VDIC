class full_test extends vdic_dut_2022_base_test;
   `uvm_component_utils(full_test)

   local runall_sequence runall_seq;
	
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new
   
   task run_phase(uvm_phase phase);
      runall_seq = new("runall_seq");
      phase.raise_objection(this);
      runall_seq.start(null); // the sequence gets the sequencer by its own
      phase.drop_objection(this);
   endtask : run_phase


endclass