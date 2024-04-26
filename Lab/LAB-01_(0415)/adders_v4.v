`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder
module FA(output C, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(C, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	
	// Implement your code here.
	// Hint: should be done in 1 line.
	// You can use this adder to debug the gate-level implemented adder.
	assign {C3, S} = A + B + C0;

endmodule

//  ripple-carry adder, gate level modeling
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	wire[3:0] c;

	assign c[0] = C0;
	assign C3 = c[3];
	
	FA fa0(c[1], S[0], A[0], B[0], c[0]);
	FA fa1(c[2], S[1], A[1], B[1], c[1]);
	FA fa2(c[3], S[2], A[2], B[2], c[2]);
endmodule

// carry-lookahead adder, gate level modeling
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	
	// Implement your code here.
	wire [3:0] C;
	wire [2:0] G, P, M;

	AND g0(G[0],  A[0],  B[0]);
	AND g1(G[1],  A[1],  B[1]);
	AND g2(G[2],  A[2],  B[2]);
	OR p0(P[0], A[0], B[0]);
	OR p1(P[1], A[1], B[1]);
	OR p2(P[2], A[2], B[2]);

	assign C[0]=C0;
	assign C3=C[3];
	
	//assign C[1] = G[0] | (P[0] & C[0]);
	AND p0c0(M[0], P[0], C[0]);
	OR c1(C[1], G[0], M[0]);
	
	//assign C[2] = G[1] | (P[1] & C[1]);
	AND p1c1(M[1], P[1], C[1]);
	OR c2(C[2], G[1], M[1]);
	
	//assign C[3] = G[2] | (P[2] & C[2]);
	AND p2c2(M[2], P[2], C[2]);
	OR c3(C[3], G[2], M[2]);
	
	FA fa0(, S[0], A[0], B[0], C[0]);
	FA fa1(, S[1], A[1], B[1], C[1]);
	FA fa2(, S[2], A[2], B[2], C[2]);

endmodule

`endif