// Code your testbench here
// or browse Examples
module test;
  int i,j;
  int q_in[$];
 
   // Task to remove element from head of queue
  task automatic remove_from_queue();
        int temp;
      if (q_in.empty()) begin
            $display("Queue is empty");
        end else begin
            temp = q_in.pop_front();
        end
    endtask
 
  initial
    begin
      for(i=0;i<10;i++)
        begin
          q_in.push_back(i);
          $display("Queue Size = %0d\n",q_in.size());
          $display("Queue Value = %p\n",q_in);
        end
      #10;
      for(j=0;j<10;j++)
        begin
          remove_from_queue();
          $display("Queue Size = %0d\n",q_in.size());
          $display("Queue Value = %p\n",q_in);
        end
    end
endmodule
