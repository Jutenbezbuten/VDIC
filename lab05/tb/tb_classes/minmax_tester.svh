class add_tester extends random_tester;
    `uvm_component_utils(add_tester)

function bit [7:0] get_data();

    bit zero_ones;

    zero_ones = 1'($random);

    if (zero_ones == 1'b0)
        return 8'h00;
    else if (zero_ones == 1'b1)
        return 8'hFF;
    else
        return 8'hFF;
endfunction : get_data

function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

endclass