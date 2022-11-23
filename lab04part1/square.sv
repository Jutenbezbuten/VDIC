class square extends rectangle;
	function new(real side);
		super.new(side, side);
	endfunction
	
	
	function void print();
		$display($sformatf("Square s=%g area=%g", height, get_area()));
	endfunction : print
endclass
