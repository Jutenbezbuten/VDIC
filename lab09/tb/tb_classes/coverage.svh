class coverage extends uvm_subscriber #(sequence_item);
    `uvm_component_utils(coverage)
 //virtual vdic_dut_2022_bfm bfm;
	
protected bit [8:0][7:0] data;
protected operation_t curr_cmd;
//protected stat_t curr_stat;
protected bit rst_n;
	
//---------------------------------
//COVERAGE
//---------------------------------

// Covergroup checking the op codes and their sequences
covergroup op_cov;

    option.name = "op_cov";

    cov_op: coverpoint curr_cmd {
        // #A1 test all operations
        bins A1_single_cycle[] = {[CMD_NOP:CMD_SUB]};
	    ignore_bins null_ops = {CMD_INV};
        // #A6 two operations in row
        bins A6_twoops[]       = ([CMD_NOP:CMD_SUB] [* 2]);

    }

endgroup

//covergroup stat_cov;
//
//    option.name = "stat_cov";
//
//    cov_op: coverpoint curr_stat {
//        // #A1 test all operations
//        bins A1_single_cycle[] = {S_NO_ERROR,S_DATA_PARITY_ERROR,S_COMMAND_PARITY_ERROR,S_INVALID_COMMAND};
//
//    }
//
//endgroup

covergroup zeros_or_ones_on_ops;

    option.name = "zeros_or_ones_on_ops";

    all_ops : coverpoint curr_cmd {
        ignore_bins null_ops = {CMD_NOP, CMD_INV};
    }

    data_vals: coverpoint data {
        bins min_min ={{{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00}}};
	    bins min_max ={{{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'hFF},{8'hFF}}};
	    bins max_max ={{{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF}}};
	    bins others ={[{{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h01}}:
		    {{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'hFF},{8'hFE}}],
		    [{{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h00},{8'h01},{8'h00},{8'h00}}:
			    {{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFF},{8'hFE}}]};
    }


    B_op_00_FF: cross data_vals, all_ops {

        // #B1 simulate all zero input for all the operations

        bins B1_add_00          = binsof (all_ops) intersect {CMD_ADD} &&
        binsof (data_vals.min_min);

        bins B1_and_00          = binsof (all_ops) intersect {CMD_AND} &&
        binsof (data_vals.min_min);

        bins B1_xor_00          = binsof (all_ops) intersect {CMD_XOR} &&
        binsof (data_vals.min_min);

        bins B1_or_00          = binsof (all_ops) intersect {CMD_OR} &&
        binsof (data_vals.min_min);
	    
	    bins B1_sub_00          = binsof (all_ops) intersect {CMD_SUB} &&
        binsof (data_vals.min_min);

        // #B2 simulate all one input for all the operations

        bins B1_add_01          = binsof (all_ops) intersect {CMD_ADD} &&
        binsof (data_vals.min_max);

        bins B1_and_01          = binsof (all_ops) intersect {CMD_AND} &&
        binsof (data_vals.min_max);

        bins B1_xor_01          = binsof (all_ops) intersect {CMD_XOR} &&
        binsof (data_vals.min_max);

        bins B1_or_01          = binsof (all_ops) intersect {CMD_OR} &&
        binsof (data_vals.min_max);
	    
	    bins B1_sub_01          = binsof (all_ops) intersect {CMD_SUB} &&
        binsof (data_vals.min_max);
	    
	    // #B2 simulate all one input for all the operations

        bins B1_add_11          = binsof (all_ops) intersect {CMD_ADD} &&
        binsof (data_vals.max_max);

        bins B1_and_11          = binsof (all_ops) intersect {CMD_AND} &&
        binsof (data_vals.max_max);

        bins B1_xor_11          = binsof (all_ops) intersect {CMD_XOR} &&
        binsof (data_vals.max_max);

        bins B1_or_11          = binsof (all_ops) intersect {CMD_OR} &&
        binsof (data_vals.max_max);
	    
	    bins B1_sub_11          = binsof (all_ops) intersect {CMD_SUB} &&
        binsof (data_vals.max_max);

        ignore_bins others_only =
        binsof(data_vals.others);
    }

endgroup

covergroup rst_ops;

    option.name = "rst_ops";

    ops_rst: coverpoint curr_cmd {
        // #A1 test all operations
        bins A1_single_cycle[] = {CMD_AND,CMD_ADD,CMD_XOR,CMD_OR,CMD_SUB,CMD_NOP};
	    ignore_bins null_ops = {CMD_INV};
    }
    
    rst: coverpoint rst_n{
	    bins rst_en=(1=>0);
	    bins rst_den=(0=>1);
    }
    ops_on_rst: cross rst, ops_rst{
	    bins R1_add_before          = binsof (ops_rst) intersect {CMD_ADD} &&
        binsof (rst.rst_en);

        bins R1_and_before          = binsof (ops_rst) intersect {CMD_AND} &&
        binsof (rst.rst_en);

        bins R1_xor_before          = binsof (ops_rst) intersect {CMD_XOR} &&
        binsof (rst.rst_en);

        bins R1_or_before          = binsof (ops_rst) intersect {CMD_OR} &&
        binsof (rst.rst_en);
	    
	    bins R1_sub_before          = binsof (ops_rst) intersect {CMD_SUB} &&
        binsof (rst.rst_en);
	    
	    bins R1_nop_before          = binsof (ops_rst) intersect {CMD_NOP} &&
        binsof (rst.rst_en);

        // #B2 simulate all one input for all the operations

        bins R1_add_after          = binsof (ops_rst) intersect {CMD_ADD} &&
        binsof (rst.rst_den);

        bins R1_and_after          = binsof (ops_rst) intersect {CMD_AND} &&
        binsof (rst.rst_den);

        bins R1_xor_after          = binsof (ops_rst) intersect {CMD_XOR} &&
        binsof (rst.rst_den);

        bins R1_or_after          = binsof (ops_rst) intersect {CMD_OR} &&
        binsof (rst.rst_den);
	    
	    bins R1_sub_after          = binsof (ops_rst) intersect {CMD_SUB} &&
        binsof (rst.rst_den);
	    
	    bins R1_nop_after          = binsof (ops_rst) intersect {CMD_NOP} &&
        binsof (rst.rst_en);
    }

endgroup

function new (string name, uvm_component parent);
    super.new(name, parent);
	op_cov      = new();
	//stat_cov=new();
	zeros_or_ones_on_ops=new();
	rst_ops=new();
endfunction: new

//function void build_phase(uvm_phase phase);
//    if(!uvm_config_db #(virtual vdic_dut_2022_bfm)::get(null, "*","bfm", bfm))
//        $fatal(1,"Failed to get BFM");
//endfunction : build_phase
//
//task run_phase(uvm_phase phase);
//    forever begin 
//	    @(negedge bfm.clk);
//	    data=bfm.data;
//	    curr_cmd=bfm.curr_cmd;
//	    curr_stat=bfm.out_stat;
//	    rst_n=bfm.rst_n;
//        op_cov.sample();
//	    stat_cov.sample();
//	    zeros_or_ones_on_ops.sample();
//	    rst_ops.sample();
//    end
//endtask
	
function void write(sequence_item t);
		data=t.data;
	    curr_cmd=t.curr_cmd;
	    rst_n=t.state;
        op_cov.sample();
	    //stat_cov.sample();
	    zeros_or_ones_on_ops.sample();
	    rst_ops.sample();
endfunction
endclass : coverage
