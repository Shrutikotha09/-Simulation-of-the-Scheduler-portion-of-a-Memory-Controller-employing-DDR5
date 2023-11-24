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

	if (!$value$plusargs("out_filename=%s", out_filename)) begin
            out_filename = "dram.txt";  // Default filename
        end

        read_and_process_requests(filename, out_filename);


        if (debug) begin
            $display("Final Queue Contents at time %0d", clock);
            print_queue_contents();
        end
    end
endmodule
