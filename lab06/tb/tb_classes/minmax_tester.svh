class minmax_tester extends random_tester;
    `uvm_component_utils(minmax_tester)

function bit [8:0][7:0] get_data(bit [2:0] size);
	bit [8:0][7:0] data;
    bit zero_ones;

    zero_ones = 1'($random);
	data=0;
	
	for(int i=0;i<=(size+1);i++)begin
		if (zero_ones == 1'b0)
        data[i]= 8'h00;
    else if (zero_ones == 1'b1)
         data[i]=  8'hFF;
    else
         data[i]=  8'hFF;
	end
   return data;
endfunction : get_data

function new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

endclass