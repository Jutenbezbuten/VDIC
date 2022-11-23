class shape_reporter #(type T=shape);
	protected static T shape_storage[$];
	
	static function void add_shape(T shape);
		shape_storage.push_back(shape);
	endfunction
	
	static function void report_shapes();
		real area_sum;
		
		foreach (shape_storage[i])begin
			shape_storage[i].print();
			
			area_sum=area_sum+shape_storage[i].get_area();
		end
		$display($sformatf("Sum of all areas: %g", area_sum));
	endfunction
endclass
