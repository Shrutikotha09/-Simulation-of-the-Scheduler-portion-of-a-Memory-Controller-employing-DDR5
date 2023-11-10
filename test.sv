
module file_read;
string filename;
bit debug;

task read_file(string name);
  int file;
  string line;
typedef struct packed {
	logic [31:0] time_CPU_clock_cycles;
	logic [3:0] core;
	logic [1:0] operation;
	logic [31:0] address;
	} input_data;
input_data i;
  
file=$fopen(name,"r");
   if(file==0) begin
      $display("Error: Failed to open file %s", name);
      $finish;
   end

  while(!$feof(file)) begin 
     void'($fgets(line,file));
    
  if(debug) begin
	$sscanf (line, "%0d %0d %0d %h", i.time_CPU_clock_cycles, i.core, i.operation, i.address);
        $display("CPU_clock_cycles= %0d Core=%0d operation=%0d address=%h", i.time_CPU_clock_cycles, i.core, i.operation, i.address);
    //$display("readline : %s", line);
  end
 end
   $fclose(file);
endtask

initial begin 
    
    if (!$value$plusargs("filename=%s", filename)) begin
      filename = "trace.txt";
    end

     if ($value$plusargs("debug=%d", debug)) begin
          $display("Debug mode is %0d", debug);
     end else begin
          debug = 0;
      end
      read_file(filename);
 end

endmodule