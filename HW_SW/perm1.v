// datab unused

module perm1(dataa, datab, result);
	input [31:0] dataa, datab;
	output [31:0] result;

	assign result = {dataa[15:0], dataa[31:16]};

endmodule
