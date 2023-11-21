module memory_scheuler();

import Definitions2::*;
import Declarations2::*;
import Definitions1::*;
import Declarations1::*;


initial begin
        if (!$value$plusargs("debug=%d", debug)) begin
            debug = 1;  // Default to debug mode if not set
        end

        if (!$value$plusargs("filename=%s", filename)) begin
            filename = "trace.txt";  // Default filename
        end

        read_and_process_requests(filename);


        if (debug) begin
            $display("Final Queue Contents at time %0d", clock);
            print_queue_contents();
        end
    end

/*
initial
begin : initial_blk

while (!done)
begin : while_done
clock++;
queue_row = queue_in[0];
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


// Add code for setting done to exit loop
if(queue_in.empty() && $feof(file))
begin : set_done
done = 1;
end : set_done
//
end : while_done

end : initial_blk
*/
endmodule