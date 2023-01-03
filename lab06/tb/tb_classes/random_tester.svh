class random_tester extends base_tester;
    `uvm_component_utils (random_tester)
    
function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function bit [8:0][7:0] get_data(bit [2:0] size);
	bit [8:0][7:0] data;
    bit [2:0] zero_ones;

    zero_ones = 3'($random);
	data=0;
	for(int i=0;i<=(size+1);i++)begin
	if (zero_ones == 3'b000)
        data[i]= 8'h00;
    else if (zero_ones == 3'b111)
        data[i]= 8'hFF;
    else
        data[i]= 8'($random);
	end
return data;    
endfunction : get_data

//get a random command, only implemented ones and invalid
function operation_t get_cmd();
	
    bit [2:0] rando;
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

function bit get_parity();
	bit [2:0] rando;
	bit parity;
	rando = 3'($random);
	if (rando==3'b000) parity=1;
	else parity=0;
	return parity;
endfunction

function bit get_state();
	bit [1:0] rando;
	bit state;
	rando = 2'($random);
	if (rando==2'b00) state=1;
	else state=0;
	return state;
endfunction
endclass
