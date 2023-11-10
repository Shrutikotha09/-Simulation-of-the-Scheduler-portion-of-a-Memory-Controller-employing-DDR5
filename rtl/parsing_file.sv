module file_read;
string filename;
bit debug;

task read_file(string name);
  int file;
  string line;

  file=$fopen(name,"r");
   if(file==0) begin
      $display("Error: Failed to open file %s", name);
      $finish;
   end

  while(!$feof(file)) begin 
     void'($fgets(line,file));
  if(debug)
    $display("readline : %s", line);
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