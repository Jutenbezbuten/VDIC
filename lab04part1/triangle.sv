class triangle extends shape;
	function new(real w, real h);
		width=w;
		height=h;
	endfunction
	
	function real get_area();
		return (width*height)/2;
	endfunction : get_area
	
	function void print();
		$display($sformatf("Triangle w=%g h=%g area=%g", width, height, get_area()));
	endfunction : print
endclass
