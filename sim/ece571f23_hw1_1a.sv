/////////////////////////////////////////////
// ece571f23_hw1_1a.sv - Gate Level Structural Modeling
// Author: Deepthi Chevuru <chevuru@pdx.edu>
// Date: 14-Oct-2023
// Description: Gate level modeling of a decoder with two 
// inputs A and B and 4 outputs Z[0] to Z[3]
//////////////////////////////////////////////

module ece571f23_hw1_1a(  input logic a, b, en,
		output logic [3:0]z);

timeunit 1ns/1ns;

// Internal variables
logic Abar, Bbar;

// Instantiating not gates
not v0(Abar, a);
not v1(Bbar, b);

// Instantiating nand gates
nand n0(z[0], en, Abar, Bbar);
nand n1(z[1], en, Abar, b);
nand n2(z[2], en, a, Bbar);
nand n3(z[3], en, a, b);

endmodule
