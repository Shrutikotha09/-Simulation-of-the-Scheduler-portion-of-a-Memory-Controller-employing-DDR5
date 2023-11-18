package PackageA;

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

// Queue Data type
typedef struct packed {
		input_data in_data;
		add_map add_mapped;		
		} queue_str;

queue_str queue_in [15:0];

// Task for address mappijng
task automatic address_mapping (input bit [33:0]address, 
				output add_map add_mapped);

add_mapped = address;

endtask

endpackage


import PackageA::*;
module DRAM_Commands ();

initial
begin

while (!done)
begin



end

end

endmodule

// Local Testbench 
module tb;

import PackageA::*;

bit [33:0]address; 
add_map add_mapped;

  initial begin
address = 'h12345678;
    $display("Before calling the task... address %b, add_map %p", address, add_mapped);
    address_mapping(address, add_mapped); // Call the task from the package
    $display("After calling the task... address %b, add_map %p", address, add_mapped);
  end

endmodule