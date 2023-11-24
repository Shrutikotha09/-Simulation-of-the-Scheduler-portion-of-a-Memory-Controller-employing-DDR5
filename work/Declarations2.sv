package Declarations2;

import Declarations1::*;

string filename;
string out_filename;
int debug;
int file;
bit request_pending = 0;

 typedef struct packed {
        int time_CPU_clock_cycles;
        int core;
        int operation;
        logic [35:0] address;
        // Fields for topological mapping
        logic [33:18] row;
        logic [17:12] col_high;
        logic [11:10] bank;
        logic [9:7] bank_group;
        logic channel;
        logic [5:2] col_low;
        logic [1:0] byte_sel;
	commands curr_cmd;
		logic row_col;
        int age; // Age of the request
        int status; // Status of the request
    } mem_request_t;

  mem_request_t request_queue[$];
    localparam int MAX_QUEUE_SIZE = 16;
   

endpackage