class random_sequence extends uvm_sequence #(sequence_item);
    `uvm_object_utils(random_sequence)

bit is_reset;

    function new(string name = "random_sequence");
        super.new(name);
    endfunction : new
    
    task body();
	    bit state;
        `uvm_info("SEQ_RANDOM","",UVM_MEDIUM)

       req = sequence_item::type_id::create("req");
       // `uvm_create(req);
       start_item(req);
	    req.state=1;
		is_reset=1;
	    finish_item(req);
        repeat (5000) begin : random_loop
         start_item(req);
         assert(req.randomize());
         if (is_reset==1) begin
			req.state=0;
			is_reset=0;
		end
		else begin
		//state=get_state();
		is_reset=req.state;
		end
         finish_item(req);
           // `uvm_rand_send(req)
        end : random_loop
    endtask : body


endclass : random_sequence