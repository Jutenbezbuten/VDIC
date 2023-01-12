class minmax_sequence_item extends sequence_item;
    `uvm_object_utils(minmax_sequence_item)
    
    constraint min_or_max {data inside {72'h000000000000000000,72'h00000000000000FFFF,72'hFFFFFFFFFFFFFFFFFF};}
	    
	function new(string name = "minmax_sequence_item");
        super.new(name);
    endfunction : new

endclass : minmax_sequence_item
