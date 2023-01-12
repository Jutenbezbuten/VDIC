class minmax_sequence extends uvm_sequence #(minmax_sequence_item);
    `uvm_object_utils(minmax_sequence)
    
    function new(string name = "minmax_sequence");
        super.new(name);
    endfunction : new
    
    task body();
        `uvm_info("SEQ_MINMAX","",UVM_MEDIUM)
        repeat (100) begin
//            req = minmax_sequence_item::type_id::create("req");
//            start_item(req);
//            assert(req.randomize());
//            finish_item(req);
            `uvm_do(req);
            req.print();
        end
    endtask : body

endclass : minmax_sequence