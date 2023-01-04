class command_transaction extends uvm_transaction;
    `uvm_object_utils(command_transaction)

//------------------------------------------------------------------------------
// transaction variables
//------------------------------------------------------------------------------

    rand bit [8:0][7:0]data;
	rand bit [2:0] no_of_data;
    rand operation_t curr_cmd;
	rand bit data_parity;
	rand bit cmd_parity;
	rand bit state;

//------------------------------------------------------------------------------
// constraints
//------------------------------------------------------------------------------

    //constraint data {
    //    A dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
    //    B dist {8'h00:=2, [8'h01 : 8'hFE]:=1, 8'hFF:=2};
    //}
    constraint size {no_of_data inside {[0:7]};}
    constraint parity {
	    data_parity dist {0:=7,1:=1};
	    cmd_parity dist {0:=7,1:=1};
	    state dist {0:=3,1:=1};
	}
//------------------------------------------------------------------------------
// transaction functions: do_copy, clone_me, do_compare, convert2string
//------------------------------------------------------------------------------

    function void do_copy(uvm_object rhs);
        command_transaction copied_transaction_h;

        if(rhs == null)
            `uvm_fatal("COMMAND TRANSACTION", "Tried to copy from a null pointer")

        super.do_copy(rhs); // copy all parent class data

        if(!$cast(copied_transaction_h,rhs))
            `uvm_fatal("COMMAND TRANSACTION", "Tried to copy wrong type.")

        data=copied_transaction_h.data;
        no_of_data=copied_transaction_h.no_of_data;
        curr_cmd=copied_transaction_h.curr_cmd;
        data_parity=copied_transaction_h.data_parity;
        cmd_parity=copied_transaction_h.cmd_parity;
        state=copied_transaction_h.state;

    endfunction : do_copy


    function command_transaction clone_me();
        
        command_transaction clone;
        uvm_object tmp;

        tmp = this.clone();
        $cast(clone, tmp);
        return clone;
        
    endfunction : clone_me


    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        
        command_transaction compared_transaction_h;
        bit same;

        if (rhs==null) `uvm_fatal("RANDOM TRANSACTION",
                "Tried to do comparison to a null pointer");

        if (!$cast(compared_transaction_h,rhs))
            same = 0;
        else
            same = super.do_compare(rhs, comparer) &&
            (compared_transaction_h.data == data) &&
            (compared_transaction_h.no_of_data == no_of_data) &&
            (compared_transaction_h.curr_cmd == curr_cmd) &&
            (compared_transaction_h.data_parity == data_parity) &&
            (compared_transaction_h.cmd_parity == cmd_parity) &&
            (compared_transaction_h.state == state);
        return same;
        
    endfunction : do_compare


    function string convert2string();
        string s;
        s = $sformatf("data: %20h no_of_data: %d curr_cmd: %s data_parity: %d cmd_parity: %d state: %d",
	        data,no_of_data,curr_cmd.name(),data_parity,cmd_parity,state);
        return s;
    endfunction : convert2string

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new (string name = "");
        super.new(name);
    endfunction : new

endclass : command_transaction

