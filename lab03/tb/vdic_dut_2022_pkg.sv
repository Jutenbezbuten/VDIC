package vdic_dut_2022_pkg;
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
	
typedef enum bit[7:0]{
	S_NO_ERROR=8'b00000000,
	S_MISSING_DATA=8'b00000001,
	S_DATA_STACK_OVERFLOW=8'b00000010,
	S_OUTPUT_FIFO_OVERFLOW=8'b00000100,
	S_DATA_PARITY_ERROR=8'b00100000,
	S_COMMAND_PARITY_ERROR=8'b01000000,
	S_INVALID_COMMAND=8'b10000000
} stat_t;
endpackage : vdic_dut_2022_pkg
