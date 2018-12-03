module perm2(a, b, res);
	input [31:0] a, b;
	output [63:0] res;

	wire [63:0] bottom, top;

	assign bottom = {a,b} >> 43;
	assign top = ({a,b} & 64'h7FFFFFFFFFF) << 21;

	assign res = top | bottom;

endmodule