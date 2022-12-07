class random_tester extends base_tester;
    `uvm_component_utils (random_tester)
    
function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function bit [7:0] get_data();

    bit [2:0] zero_ones;

    zero_ones = 3'($random);

    if (zero_ones == 3'b000)
        return 8'h00;
    else if (zero_ones == 3'b111)
        return 8'hFF;
    else
        return 8'($random);
endfunction : get_data

//get a random command, only implemented ones and invalid
function operation_t get_cmd();
	
    bit [3:0] rando;
    operation_t op_out;

    rando = 3'($random);

    if (rando == 3'b000)begin
        op_out=CMD_AND;
    end
    else if (rando == 3'b001)begin
        op_out=CMD_ADD;
    end
    else if (rando == 3'b010)begin
        op_out=CMD_OR;
    end
    else if (rando == 3'b011)begin
        op_out=CMD_XOR;
    end
    else if (rando == 3'b100)begin
        op_out=CMD_SUB;
    end
    else if (rando == 3'b101)begin
        op_out=CMD_NOP;
    end
    else if (rando == 3'b110)begin
        op_out=CMD_INV;
    end
    else begin
 //       op_out=CMD_ERR;
	    op_out=CMD_INV;
    end
    return op_out;
endfunction: get_cmd



endclass
