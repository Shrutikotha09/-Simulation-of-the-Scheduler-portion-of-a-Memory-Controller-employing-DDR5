package Definitions2;

import Declarations2::*;
import Declarations1::*;
import Definitions1::*;  

// Function to map address to topological components
    function void map_address_to_topological(input logic [35:0] address, inout mem_request_t req);
        req.byte_sel = address[1:0];
        req.col_low = address[5:2];
        req.channel = address[6];
        req.bank_group = address[9:7];
        req.bank = address[11:10];
        req.col_high = address[17:12];
        req.row = address[33:18];
        $display("Address Mapping Debug: %h -> byte_sel: %0d, col_low: %0d, channel: %0d, bank_group: %0d, bank: %0d, col_high: %0d, row: %0d", 
                 address, req.byte_sel, req.col_low, req.channel, req.bank_group, req.bank, req.col_high, req.row);
    endfunction

    // Task to push a request into the queue
    task push_request(mem_request_t req);
        if (request_queue.size() < MAX_QUEUE_SIZE) begin
            request_queue.push_back(req);
            $display("[%0d] Pushed request: Time %0d, Core %0d", clock, req.time_CPU_clock_cycles, req.core);
            if (debug) begin
                print_queue_contents(); // Print queue contents after insertion
            end
        end else begin
            $display("Queue is full. Cannot enqueue new request.");
        end
    endtask

    // Task to print queue contents
    task print_queue_contents;
        $display("Printing Queue Contents at simulation time %0d", clock);
        foreach (request_queue[i]) begin
            $display("Queue Element %0d: Time: %0d, byte_sel: %0d, Address: %h", 
                     i, request_queue[i].time_CPU_clock_cycles, request_queue[i].byte_sel, 
                     request_queue[i].address);
        end
    endtask


    // Task to read and process requests
    task read_and_process_requests(string filename);

        mem_request_t req;
        automatic int max_time_in_file = 0;
        automatic bit request_pending = 0; // Indicates if a request is pending to be added to the queue

        file = $fopen(filename, "r");
        if (file == 0) begin
            $display("Error: Failed to open file %s", filename);
            $finish;
        end

        // Initialize the first request
        if (!$feof(file)) begin
            $fscanf(file, "%0d %0d %0d %h", req.time_CPU_clock_cycles, req.core, req.operation, req.address);
		 map_address_to_topological(req.address, req); // Mapping function called here
            request_pending = 1;
        end

        //clock = 0;

while (!done)
begin : while_done

  if (request_pending || !$feof(file) || request_queue.size() > 0) begin
            if (request_pending && req.time_CPU_clock_cycles <= clock) begin
                push_request(req);
                request_pending = 0; // Reset flag as the request is now in the queue

                // Read the next request
                if (!$feof(file)) begin
                    $fscanf(file, "%0d %0d %0d %h", req.time_CPU_clock_cycles, req.core, req.operation, req.address);
			 map_address_to_topological(req.address, req); // Mapping function called here
                    request_pending = 1;
                end
            end

            //clock++; // Increment simulation time
        end




clock++;
if(request_queue.size() > 0)
begin

queue_row = request_queue[0]; //queue_in[0];
$display(" queue_row %p", queue_row );

if(!(clock%2))
begin : DIMM_clk
$display(" DIMM Clock");

// code added for checkpoint
while(1)
begin
next_command (queue_row.curr_cmd, queue_row.in_data.operation, queue_row.row_col);
out_file_upd(queue_row, clock);
if(queue_row.curr_cmd == PRE) begin
remove_from_queue ();
break;
end
end
//End of CP code 



end : DIMM_clk

else
begin : else_DIMM_clock
$display("else  DIMM Clock");
end : else_DIMM_clock
end
$display(" eof status %b", $feof(file));
// Add code for setting done to exit loop
if(request_queue.size() == 0 && $feof(file))
begin : set_done
done = 1;
end : set_done
//
end : while_done

      
        $fclose(file);
        if (debug) begin
            $display("End of simulation at time %0d", clock);
            print_queue_contents();
        end
    endtask
endpackage
