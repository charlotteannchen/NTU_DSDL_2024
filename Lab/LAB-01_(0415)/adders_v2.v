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
	wire[3:0] c;
	wire[2:0] p, g;

	// Compute Propagate (p) and Generate (g) signals
	OR p0(p[0], A[0], B[0]);
	OR p1(p[1], A[1], B[1]);
	OR p2(p[2], A[2], B[2]);

	AND g0(g[0], A[0], B[0]);
	AND g1(g[1], A[1], B[1]);
	AND g2(g[2], A[2], B[2]);

	assign c[0] = C0;
	assign C3 = c[3];

    // Compute the internal carry signals
    wire p0C0;
	// wire p0C0
	AND p0C0(p0C0, p[0], C0);
	// c1
	OR c1(c1, g[0], p0C0);

    wire p1g0, p1p0C0;
	// wire p1g0
    AND p1g0(p1g0, p[1], g[0]);
	// wire p1p0C0
	AND p1p0(p1p0, p[1], p0);
	AND p1p0C0(p1p0C0, p1p0, C0);  
	// c2
    OR g1p1g0(g1p1g0, g[1], p1g0);   
	OR c2(c2, g1p1g0, p1p0C0);

    wire p2g1, p2p1g0, p2p1p0C0;
	// wire p2g1
    AND p2g1(p2g1, p[2], g[1]);
	// wire p2p1g0
	AND p2p1(p2p1, p[2], p[1]);
	AND p2p1g0(p2p1g0, p2p1, g[0]);
    // wire p2p1p0C0
	AND p2p1p0c0(p2p1p0C0, p2p1, p0C0);
	// c3
    OR g2p2g1(g2p2g1, g[2], p2g1);  
	OR p2p1g0p2p1p0C0(p2p1g0p2p1p0C0, p2p1g0, p2p1p0C0);
	OR c3(C3, g2p2g1, p2p1g0p2p1p0C0);

    // Compute the sums
    OR s0(S[0], p[0], C0);
    OR s1(S[1], p[1], c1);
    OR s2(S[2], p[2], c2);

endmodule

`endif
