vlog test.sv
vsim -c -do "run -all" +filename=trace1cp1.txt +debug=1 file_read
gvim output.txt
