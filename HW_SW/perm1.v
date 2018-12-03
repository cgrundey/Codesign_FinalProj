// Nios custom instruction for permutation 1

module perm1(a, b, res);
	input [31:0] a, b;
	output [63:0] res;

	wire [63:0] in3, in2, in1, in0;

	assign in3 = (16'hFFFF & {a,b});
	assign in2 = (16'hFFFF & ({a,b} >> 16));
	assign in1 = (16'hFFFF & ({a,b} >> 32));
	assign in0 = {a,b} >> 48;

	assign res = (in1 << 48) | (in0 << 32) | (in3 << 16) | in2;

endmodule