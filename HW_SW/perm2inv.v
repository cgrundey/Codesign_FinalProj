module perm2inv(a, b, res);
	input [31:0] a, b;
	output [63:0] res;

	wire [63:0] bottom, top;

	assign top = ({a,b} & 64'h1FFFFF) << 43;
	assign bottom = {a,b} >> 21;

	assign res = top | bottom;

endmodule