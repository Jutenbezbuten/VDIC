class sequence_item extends uvm_sequence_item;
	
    rand bit [8:0][7:0]data;
	rand bit [2:0] no_of_data;
    rand operation_t curr_cmd;
	rand bit data_parity; 
	rand bit cmd_parity;
	rand bit state;
	
	`uvm_object_utils_begin(sequence_item)
		`uvm_field_int(data, UVM_ALL_ON | UVM_DEC)
		`uvm_field_int(no_of_data, UVM_ALL_ON | UVM_DEC)
		`uvm_field_enum(operation_t,curr_cmd, UVM_ALL_ON)
		`uvm_field_int(data_parity, UVM_ALL_ON | UVM_DEC)
		`uvm_field_int(cmd_parity, UVM_ALL_ON | UVM_DEC)
		`uvm_field_int(state, UVM_ALL_ON | UVM_DEC)
	`uvm_object_utils_end
	
	    constraint size {no_of_data inside {[0:7]};}
    constraint parity {
	    data_parity dist {0:=7,1:=1};
	    cmd_parity dist {0:=7,1:=1};
	    state dist {0:=3,1:=1};
    }
    
    function new(string name = "sequence_item");
        super.new(name);
    endfunction : new
    
    function string convert2string();
        string s;
        s = $sformatf("data: %20h no_of_data: %d curr_cmd: %s data_parity: %d cmd_parity: %d state: %d",
	        data,no_of_data,curr_cmd.name(),data_parity,cmd_parity,state);
        return s;
    endfunction : convert2string
    
endclass : sequence_item