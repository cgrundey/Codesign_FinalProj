// Nios custom instruction for permutation 1

module perm1(a, b, res);
	input [31:0] a, b;
	output [31:0] res;

	wire [63:0] in;

	assign in = {a,b};
	assign res_lower = {in[15:0], in[31:16]};
	assign res_upper = {in[47:32], in[63:48]};
	// two different modules
endmodule
