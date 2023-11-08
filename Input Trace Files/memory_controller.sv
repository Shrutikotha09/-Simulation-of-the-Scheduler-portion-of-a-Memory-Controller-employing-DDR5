?// Code your design here
//=================================MEMORY CONTROLLER===================================//
//AUTHORS: Vinay Veerappa Goudar (vinayv2@pdx.edu)
//         Arkula Manish Shenoy (shenoyar@pdx.edu)
//         Gagan Chandra Basavaraju (gagan2@pdx.edu)
//         Vishwas Hanabe Neelakanta (vishwas2@pdx.edu)
//DATE: 10 - Nov - 2021
//Description:
//**
//Simulation of a memory controller capable serving the shared last level cache of a 
//four core 3.2 GHz processor employing a single memory channel. 
/////////////////////////////////////////////////////////////////////////////////////////
module memory_controller;
  parameter tRC = 76;
  parameter tRAS = 52;
  parameter tRRD_L = 6;
  parameter tRRD_S = 4;
  parameter tRP = 24;
  parameter tRFC = 350;
  parameter CWL = 20;
  parameter tCAS = 24;
  parameter tRCD = 24;
  parameter tWR = 20;
  parameter tRTP =12;
  parameter tCCD_L = 8;
  parameter tCCD_S = 4;
  parameter tBURST = 4;
  parameter tWTR_L = 12;
  parameter tWTR_S = 4;
  parameter REFI = 7;
  int i,j,k;
//Signals declaration
  logic clock = 0;			                          // clock
  
  //File handlers
  int File,outFile;                         			          // File input
  string filename;			       		          // for reading user defined file name
  
  //memory_references from CPU
  bit [33:0] cpu_address;                                         // address from the cpu
  bit [64:0] cpu_time;			                          // CPU_Execution time
	enum bit [1:0] {READ=0, WRITE=1, FETCH=2} cpu_opcode;           // type of CPU_operation to be performed
  
  //Signals for Queue Operations
  logic [100:0] memory_queue[$:15];			          // queue to store cpu_address, cpu_execution time, and cpu_operation of size 16
  int que_size = 0;			                          // queue size 
  longint simulation = 0;	                                  // simulation time
  int que_count;			 	                  // count the queue elements
  int length;  				                          // count the length of input trace file
  bit flag=0;
  longint simulation_t = 0;
  //Address Mapping

  bit [2:0] byte_select;
  bit [2:0] low_column;
  bit [1:0] bank_group;
  bit [1:0] bank_select;
  bit [7:0] high_column;
  bit [14:0] row;
  logic [3:0][3:0]bank_status = 0;
  bit [14:0] active_row[15:0]; 
  
  //Handle for address_map struct
  bit [1:0] temp_bank_group;
  bit [1:0] temp_bank_select;
  bit [14:0] temp_row;
  enum bit [1:0] {READ_D, WRITE_D, FETCH_D} command;
  //command com;
  
  //Handle for addr
  initial begin
    bank_status[2][0] = 0;
    
  end

//clock generation
always  
 #5 clock = ~clock;
  
initial
 begin
  $display("clock = %0d", clock);
  #100000000;
  $stop;
 end

//open the trace file
initial 
  begin 
   $value$plusargs("filename=%s",filename);   //reads the file from user through the command line 
   File = $fopen(filename,"r");  			   //open  a file                  
    if(File)  
    $display("File opened succcessfully", File);
    outFile = $fopen("gagan.txt","w");
    if(outFile)  
     $display("File opened successfully for writing", File);
  end

  always @(posedge clock) 
  begin
      simulation = simulation+1;  // advancing simulation time
       //condtion check and executes until the end of a file
    if(simulation%2==0) begin
       if(!$feof(File))   
	    begin 
          ////parsing the trace file in the required format (time, operation, address)
          $fscanf(File, "%d %d %h",cpu_time , cpu_opcode , cpu_address); 
          ////Debugging mode to enable/disable the operation. pass the switch in command line (+ENABLE)
          if($test$plusargs("ENABLE"))    
		    begin
              //Check if queue is not full and execute accordingly
             if(que_size<17)             
			   begin  
                 // push elements of the request into the queue
                 memory_queue.push_front({cpu_time, cpu_opcode, cpu_address}); 
                 address_map(cpu_address);   // address mapping function
            	 que_size+=1;                            //incrementing the size of queue
            	 								// to count the number of lines in trace file
                 if(cpu_time>simulation) begin
                   simulation = cpu_time;
                 end
                 //$display("Bank Group = %d and Bank select = %d",bank_group,bank_select);                 
				  if(bank_group == 0 && bank_select == 0) 
                  begin
                    delay(0,0,0);  
            	  end
            	else if(bank_group == 0 && bank_select == 1) 
                  begin
                      delay(0,1,1);
            	  end
            	else if(bank_group == 0 && bank_select == 2) 
                  begin
                      delay(0,2,2);
            	  end
            	else if(bank_group == 0 && bank_select == 3) 
                  begin
                      delay(0,3,3);
            	  end
            	else if(bank_group == 1 && bank_select == 0) 
                  begin
                      delay(1,0,4);
            	  end
            	else if(bank_group == 1 && bank_select == 1) 
                  begin
                      delay(1,1,5);
            	  end
            	else if(bank_group == 1 && bank_select == 2) 
                  begin
                      delay(1,2,6);
                  end
                else if(bank_group == 1 && bank_select == 3) 
                  begin
                      delay(1,3,7);
                  end
               else if(bank_group == 2 && bank_select == 0) 
                  begin
                      delay(2,0,8);  
                  end
                else if(bank_group == 2 && bank_select == 1) 
                  begin
                      delay(2,1,9);  
                  end
                else if(bank_group == 2 && bank_select == 2) 
                  begin
                      delay(2,2,10);  
                  end
                else if(bank_group == 2 && bank_select == 3) 
                  begin
                      delay(2,3,11);   
                    end
                else if(bank_group == 3 && bank_select == 0) 
                  begin
                      delay(3,0,12);  
                  end
                else if(bank_group == 3 && bank_select == 1) 
                  begin
                      delay(3,1,13);  
                  end
                else if(bank_group == 3 && bank_select == 2) 
                  begin
                      delay(3,2,14); 
                  end
                else if(bank_group == 3 && bank_select == 3) 
                  begin
                      delay(3,3,15);
                  end
               end

                     

			
          if(que_size!=0) 
          begin
               {cpu_time, cpu_opcode, cpu_address}=memory_queue.pop_back();           
			    que_size = que_size-1;
             	address_map(cpu_address);
             	temp_bank_group = bank_group;
  			 	temp_bank_select = bank_select;
  			 	temp_row = row;
            if(bank_group ==0 && bank_select==0) begin
              active_row[0] = temp_row;
              bank_status [0][0] = 1;
            end
            else if(bank_group == 0 && bank_select == 1) begin
              active_row[1] = temp_row;
              bank_status [0][1] = 1;
            end
            else if(bank_group == 0 && bank_select == 2) begin
              active_row[2] = temp_row;
              bank_status [0][2] = 1;
            end
            else if(bank_group == 0 && bank_select == 3) begin
              active_row[3] = temp_row;
              bank_status [0][3] = 1;
            end
            else if(bank_group == 1 && bank_select == 0) begin
              active_row[4] = temp_row;
              bank_status [1][0] = 1;
            end
            else if(bank_group == 1 && bank_select == 1) begin
              active_row[5] = temp_row;
              bank_status [1][1] = 1;
            end
            else if(bank_group == 1 && bank_select == 2) begin
              active_row[6] = temp_row;
              bank_status [1][2] = 1;
            end
            else if(bank_group == 1 && bank_select == 3) begin
              active_row[7] = temp_row;
              bank_status [1][3] = 1;
            end
            else if(bank_group == 2 && bank_select == 0) begin
              active_row[8] = temp_row;
              bank_status [2][0] = 1;
            end
            else if(bank_group == 2 && bank_select == 1) begin
              active_row[9] = temp_row;
              bank_status [2][1] = 1;
            end
            else if(bank_group == 2 && bank_select == 2) begin
              active_row[10] = temp_row;
              bank_status [2][2] = 1;
            end
            else if(bank_group == 2 && bank_select == 3) begin
              active_row[11] = temp_row;
              bank_status [2][3] = 1;
            end
            else if(bank_group == 3 && bank_select == 0) begin
              active_row[12] = temp_row;
              bank_status [3][0] = 1;
            end
            else if(bank_group == 3 && bank_select == 1) begin
              active_row[13] = temp_row;
              bank_status [3][1] = 1;
            end
            if(bank_group == 3 && bank_select == 2) begin
              active_row[14] = temp_row;
              bank_status [3][2] = 1;
            end
            else if(bank_group == 3 && bank_select == 3) begin
              active_row[15] = temp_row;
              bank_status [3][3] = 1;
            end
    	   end
	     end
  		end
     end
  end 

  
  function address_map(bit [33:0] cpu_address);
    begin
           byte_select = cpu_address[2:0];
           low_column = cpu_address[5:3];
           bank_group = cpu_address[7:6];
      	   bank_select = cpu_address[10:9];
           high_column = cpu_address[17:11];
           row = cpu_address[33:18];
    end
   endfunction: address_map
 

 
  task delay(int i, int j, int k);
    begin
/////////////////////////////////////////FETCH OPERATION//////////////////////////////////////
if(row == active_row[k] && bank_status [i][j] == 1) begin //conditon for same row in same bank group        
 if(cpu_opcode == FETCH) begin
                   simulation = simulation + cpu_time;
                   $fwrite(outFile,"%d FE\t %d %d %h\n",simulation, bank_group, bank_select, row);
		   simulation = (simulation + 2*tCAS + 2*tBURST);
                   
              end

              end
      else if(cpu_opcode == FETCH && row != active_row[k] && bank_status [i][j] == 1) begin  // condition for different row in same bank group and bank
                    if(simulation >= simulation_t + tRRD_S) begin
		    simulation = simulation + tRRD_S;
                    end
		    simulation = simulation+ cpu_time;
                    $fwrite(outFile,"%d PRE\t %d %d\n",simulation, bank_group, bank_select);                     
                    simulation = simulation + 2*tRP;
                    $fwrite(outFile,"%d ACT\t %d %d %h\n",simulation, bank_group, bank_select, row);
                    simulation = simulation + 2*tRCD;
                    $fwrite(outFile,"%d FE \t %d %d %h\n",simulation, bank_group, bank_select, row);
		    simulation = simulation + 2*tCAS + 2*tBURST;
                	    
        active_row[k] = row;
              end
      else if(cpu_opcode == FETCH && row != active_row[k] && bank_status [i][j] == 0) begin // condition for different row in different bank group and bank
                     simulation = cpu_time;
        	     $fwrite(outFile,"%d ACT\t %d %d %h\n",simulation, bank_group, bank_select, row);
                     simulation = (simulation + 2*tRCD);
        	     $fwrite(outFile,"%d FE \t %d %d %h\n",simulation, bank_group, bank_select, row);
		     simulation = (simulation + 2*tCAS + 2*tBURST);
                     
        bank_status [i][j] = 1;
               end
////////////////////////////////////////READ OPERATION//////////////////////////////////////////////     
if(row == active_row[k] && bank_status [i][j] == 1) begin
                    if(cpu_opcode == READ) begin
                      simulation = simulation+cpu_time;
                      $fwrite(outFile,"%d RD\t %d %d %h\n",simulation, bank_group, bank_select, row);
                      simulation = (simulation + 2*tCAS + 2*tBURST);
                      
                      end

                    end
      else if(cpu_opcode == READ && row != active_row[k] && bank_status [i][j] == 1) begin
                          simulation = simulation + 2*tRP;
                      	  $fwrite(outFile,"%d PRE\t %d %d\n",simulation, bank_group, bank_select);                     
                      	  simulation = simulation + cpu_time;
                          $fwrite(outFile,"%d ACT\t %d %d %h\n",simulation, bank_group, bank_select, row);
                          simulation = (simulation + 2*tRCD);
                          $fwrite(outFile,"%d RD \t %d %d %h\n",simulation, bank_group, bank_select, row);
			  simulation = (simulation + 2*tCAS + 2*tBURST);
                           
        active_row[k] = row;
                      
                          
                      end
      else if(cpu_opcode == READ && row != active_row[k] && bank_status [i][j] == 0) begin
                          simulation = simulation +cpu_time;
                          $fwrite(outFile,"%d ACT\t %d %d %h\n",simulation, bank_group, bank_select, row);
                          simulation = (simulation + 2*tRCD);
                          $fwrite(outFile,"%d RD \t %d %d %h\n",simulation, bank_group, bank_select, row);
			  simulation = (simulation + 2*tCAS + 2*tBURST);
                          
        bank_status [i][j] = 1;
                    end
//////////////////////////////////////WRITE OPERATION/////////////////////////////////////////////////    
       if(row == active_row[k] && bank_status [i][j] == 1) begin
              if(cpu_opcode == WRITE) begin
                simulation = (simulation+cpu_time);
                $fwrite(outFile,"%d WR \t %d %d %d\n",simulation, bank_group, bank_select, row);
		simulation = (simulation + 2*CWL + 2*tBURST);
		
              end

              end
       else if(cpu_opcode == WRITE && row != active_row[k] && bank_status [i][j] == 1) begin
                simulation = simulation + 2*tRP;
                $fwrite(outFile,"%d PRE\t %d %d\n",simulation, bank_group, bank_select);                     
                simulation = simulation + cpu_time;
                $fwrite(outFile,"%d ACT\t %d %d %h\n",simulation, bank_group, bank_select, row);
                simulation = (simulation + 2*tRCD);
        	$fwrite(outFile,"%d WR \t %d %d %h\n",simulation, bank_group, bank_select, row);
		simulation = (simulation + 2*CWL + 2*tBURST);
		
       		 active_row[k] = row;
              end
      else if(cpu_opcode == WRITE && row != active_row[k] && bank_status [i][j] == 0) begin
                simulation = simulation +cpu_time;
                $fwrite(outFile,"%d ACT\t %d %d %h\n",simulation, bank_group, bank_select, row);
                simulation = (simulation + 2*tRCD);
                $fwrite(outFile,"%d WR \t %d %d %h\n",simulation, bank_group, bank_select, row);
	        simulation = (simulation + 2*CWL + 2*tBURST);
		
        	bank_status [i][j] = 1;
               end
           end
  endtask: delay
  
endmodule: memory_controller