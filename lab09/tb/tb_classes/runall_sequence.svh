class runall_sequence extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(runall_sequence)
    
    local sequencer sequencer_h;
    local uvm_component uvm_component_h;
	
    local minmax_sequence minmax;
    local random_sequence random;
	
    function new(string name = "runall_sequence");
        super.new(name);

        // runall_sequence is called with null sequencer; another way to
        // define the sequence is to use find function;
        uvm_component_h = uvm_top.find("*.env_h.sequencer_h");

        if (uvm_component_h == null)
            `uvm_fatal("RUNALL_SEQUENCE", "Failed to get the sequencer")

        // find function returns uvm_component, needs casting
        if (!$cast(sequencer_h, uvm_component_h))
            `uvm_fatal("RUNALL_SEQUENCE", "Failed to cast from uvm_component_h.")

        random          = random_sequence::type_id::create("random");
        minmax         = minmax_sequence::type_id::create("minmax");
    endfunction : new

//------------------------------------------------------------------------------
// the sequence body
//------------------------------------------------------------------------------

    task body();
        `uvm_info("SEQ_RUNALL","",UVM_MEDIUM)
        random.start(sequencer_h);
	    minmax.start(sequencer_h);
    endtask : body


endclass : runall_sequence
