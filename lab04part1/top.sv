module top;
	initial begin
		shape shape_h;
		
		rectangle rectangle_h;
		square square_h;
		triangle triangle_h;
		
		int shape_txt, status;
		
		string shape_type;
		real w,h;
		
		shape_txt=$fopen("lab04part1_shapes.txt", "r");
		while (!$feof(shape_txt))begin
			status=$fscanf(shape_txt,"%s %g %g/n",shape_type, w, h);
			shape_h=shape_factory::make_shape(shape_type, w, h);
			shape_reporter#(rectangle)::report_shapes();
			shape_reporter#(square)::report_shapes();
			shape_reporter#(triangle)::report_shapes();
		end
	end
endmodule
