class minmax_transaction extends command_transaction;
    `uvm_object_utils(minmax_transaction)

//------------------------------------------------------------------------------
// constraints
//------------------------------------------------------------------------------

    constraint minmax {data inside {72'h000000000000000000,72'h00000000000000FFFF,72'hFFFFFFFFFFFFFFFFFF};}

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name="");
        super.new(name);
    endfunction
    
    
endclass : minmax_transaction
