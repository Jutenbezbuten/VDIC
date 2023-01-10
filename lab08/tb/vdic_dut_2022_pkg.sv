package vdic_dut_2022_pkg;
	import uvm_pkg::*;
    `include "uvm_macros.svh"
    
	typedef enum bit[7:0] {
    CMD_NOP  = 8'b00000000,
    CMD_AND = 8'b00000001,
    CMD_OR = 8'b00000010,
    CMD_XOR = 8'b00000011,
    CMD_ADD = 8'b00010000,
    CMD_SUB = 8'b00100000,
 //   CMD_ERR= 8'b11111111,//added for testing
    CMD_INV= 8'b11111110//added for testing
	} operation_t;
	
//typedef struct packed {
//    bit [8:0][7:0]data;
//	bit [2:0] no_of_data;
//    operation_t curr_cmd;
//	bit data_parity;
//	bit cmd_parity;
//	bit state;//0=operation, 1=reset
//} command_s;
	
	
typedef enum bit[7:0]{
	S_NO_ERROR=8'b00000000,
	S_MISSING_DATA=8'b00000001,
	S_DATA_STACK_OVERFLOW=8'b00000010,
	S_OUTPUT_FIFO_OVERFLOW=8'b00000100,
	S_DATA_PARITY_ERROR=8'b00100000,
	S_COMMAND_PARITY_ERROR=8'b01000000,
	S_INVALID_COMMAND=8'b10000000
} stat_t;
	
typedef struct packed {
    bit [15:0]data;
    bit [7:0] out_stat;
	bit parity_err;
    } result_s;
	
typedef enum bit [1:0] {
    min=2'b00,
    max=2'b01,
    random=2'b10
} test_config_t;

// configs
`include "env_config.svh"
`include "vdic_dut_2022_agent_config.svh"

`include "command_transaction.svh"
`include "result_transaction.svh"
`include "minmax_transaction.svh"

`include "coverage.svh"
`include "tester.svh"
`include "scoreboard.svh"
//`include "base_tester.svh"
//`include "random_tester.svh"
//`include "minmax_tester.svh"
`include "driver.svh"
`include "command_monitor.svh"
`include "result_monitor.svh"
`include "vdic_dut_2022_agent.svh"
`include "env.svh"

//`include "random_test.svh"
//`include "minmax_test.svh"
`include "dual_test.svh"
endpackage : vdic_dut_2022_pkg