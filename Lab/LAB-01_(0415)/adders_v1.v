`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder, gate level modeling
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder, gate level modeling
module FA(output CO, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(CO, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	assign {C3, S} = A+B+C0;
endmodule

//  ripple-carry adder, gate level modeling
//  Do not modify the input/output of module
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);

	// TODO:: Implement gate-level RCA
	wire c1, c2; // internal carry wires

	// Instantiate the Full Adder (FA) modules
	FA fa0(S[0], c1, A[0], B[0], C0);
	FA fa1(S[1], c2, A[1], B[1], c1);
	FA fa2(S[2], C3, A[2], B[2], c2);

endmodule

// carry-lookahead adder, gate level modeling
// Do not modify the input/output of module
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);

	// TODO:: Implement gate-level CLA
	wire c1, c2, p0, p1, p2, g0, g1, g2;

	// Compute Propagate (p) and Generate (g) signals
	XOR xorp0(p0, A[0], B[0]);
	XOR xorp1(p1, A[1], B[1]);
	XOR xorp2(p2, A[2], B[2]);

	AND andg0(g0, A[0], B[0]);
	AND andg1(g1, A[1], B[1]);
	AND andg2(g2, A[2], B[2]);

    // Compute the internal carry signals
    wire p0C0;
	AND andp0c0(p0C0, p0, C0);
	OR orc1(c1, g0, p0C0);

    wire p1g0, p1p0C0;
    AND andp1g0(p1g0, p1, g0);
	// AND andp1p0c0(p1p0C0, p1, p0, C0);
	AND andp1p0(p1p0, p1, p0);
	AND andp1p0c0(p1p0C0, p1p0, C0);  
	// OR orc2(c2, g1, p1g0, p1p0C0);    
    OR org1p1g0(g1p1g0, g1, p1g0);   
	OR orc2(c2, g1p1g0, p1p0C0);

    wire p2g1, p2p1g0, p2p1p0C0;
    AND andp2g1(p2g1, p2, g1);
	AND andp2p1(p2p1, p2, p1);
	AND andp2p1g0(p2p1g0, p2p1, g0);

    // AND andp2p1p0c0(p2p1p0C0, p2, p1, p0, C0);
	AND andp2p1_(p2p1, p2, p1);
	AND andp0c0_(p0C0, p0, C0);
	AND andp2p1p0c0(p2p1p0C0, p2p1, p0C0);
	// OR orc3(C3, g2, p2g1, p2p1g0, p2p1p0C0); 
    OR org2p2g1(g2p2g1, g2, p2g1);  
	OR orp2p1g0p2p1p0C0(p2p1g0p2p1p0C0, p2p1g0, p2p1p0C0);
	OR orc3(C3, g2p2g1, p2p1g0p2p1p0C0);

    // Compute the sums
    XOR xors0(S[0], p0, C0);
    XOR xors1(S[1], p1, c1);
    XOR xors2(S[2], p2, c2);

endmodule

`endif
