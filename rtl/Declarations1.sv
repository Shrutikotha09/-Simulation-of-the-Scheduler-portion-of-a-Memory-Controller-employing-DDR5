package Declarations1;

bit done = 0;

// Address Mapping
typedef struct packed {
		bit [33:18] row;
		bit [17:12] col_high;
		bit [11:10] bank;
		bit [9:7] bank_group;
		bit channel;
		bit [5:2] col_low;
		bit [1:0] byte_sel;
		} 
		add_map;

// Input file format
typedef struct packed {
		bit [63:0] time_CPU_clock_cycles;
		bit [3:0] core;
		bit [1:0] operation;
		bit [33:0] address;
		} input_data;

input_data in_data;

// Enum for commands
typedef enum logic [2:0] {ACT0, ACT1, RD0, RD1, WR0, WR1, PRE, REF} commands;

// Queue Data type
typedef struct packed {
		input_data in_data;
		add_map add_mapped;	
		commands curr_cmd;
		logic row_col;
		} queue_str;

queue_str queue_in [$];
queue_str queue_row;

// Variables
bit [63:0] clock = 0;
int out_file;

endpackage
