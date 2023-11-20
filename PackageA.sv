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

// Enum for commands
typedef enum logic [2:0] {ACT0, ACT1, RD0, RD1, WR0, WR1, PRE, REF} commands;

// Queue Data type
typedef struct packed {
		input_data in_data;
		add_map add_mapped;	
		commands curr_cmd;
		bit row_col;
		} queue_str;

queue_str queue_in [15:0];
queue_str queue_row;

// Variables
bit [63:0] clock = 0;
int out_file;

// Task for address mappijng
task automatic address_mapping (input bit [33:0]address, 
				output add_map add_mapped);

add_mapped = address;

endtask

// Task to get next command
task automatic next_command (inout commands curr_cmd, input bit [1:0] operation, inout logic row_col);
/*
unique case(curr_cmd)
ACT0: begin curr_cmd = ACT1; row_col = 0; end
ACT1: begin curr_cmd = (operation == 1)? WR0 : RD0; row_col = 1; end
RD0: begin curr_cmd = RD1; row_col = 1; end
RD1: curr_cmd = PRE;
WR0: begin curr_cmd = WR1; row_col = 1; end
WR1: begin curr_cmd = PRE;
PRE: begin curr_cmd = ACT0; row_col = 1; end
REF: curr_cmd = PRE; 
default : begin curr_cmd = ACT0; row_col = 0; end
endcase
*/
endtask

// Task to generate output file
task automatic out_file_upd(input queue_str o, input clock);
$display(" output queue %p", o);
out_file=$fopen("dram.txt","a");
$fwrite(out_file, " %d\t%d\t%p\t%p\t%p\t", clock, o.add_mapped.channel, o.curr_cmd, o.add_mapped.bank_group, o.add_mapped.bank);   
if(o.row_col)
begin : col
$fwrite(out_file, " %b%b\n", o.add_mapped.col_high, o.add_mapped.col_low[5:4]);  
end : col
else
begin : row
$fwrite(out_file, " %b%b\n", o.add_mapped.row);  
end : row
$fclose(out_file);
endtask

endpackage


import PackageA::*;
module DRAM_Commands;

// input for test
initial begin
done = 0;
clock = 2;
queue_in[0].in_data.time_CPU_clock_cycles = 20;
queue_in[0].in_data.core = 1;
queue_in[0].in_data.operation = 2;
queue_in[0].in_data.address = 'h12345678;
$display("done = %b, clock = %b, input file %p", done, clock, queue_in[0].in_data);
end
// end of inputs


initial
begin : initial_blk

queue_row = queue_in[0];
$display(" queue_row %p", queue_row );
while (!done)
begin : while_done

if(!(clock%2))
begin : DIMM_clk
$display(" DIMM Clock");

next_command (queue_row.curr_cmd, queue_row.in_data.operation, queue_row.row_col);
$display(" next command %b", queue_row .curr_cmd);
$display(" Upload output file");
out_file_upd(queue_row, clock);
//end : initial_cmd

end : DIMM_clk

else
begin : else_DIMM_clock
$display("else  DIMM Clock");
end : else_DIMM_clock

clock++;
end : while_done

end : initial_blk

endmodule

// Local Testbench 
module tb;

import PackageA::*;


initial begin
queue_in[0].in_data.time_CPU_clock_cycles = 20;
queue_in[0].in_data.core = 1;
queue_in[0].in_data.operation = 2;
queue_in[0].in_data.address = 'h12345678;
end
endmodule