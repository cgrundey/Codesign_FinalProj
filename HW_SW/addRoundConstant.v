
module addRoundConstant(dataa, datab, result);
    input [31:0] dataa, datab;
    output [6:0] result;

    assign result = (datab == 4'd0) ? (dataa & 7'h7f) + 7'h5A :
                    (datab == 4'd1) ? (dataa & 7'h7f) + 7'h34 :
                    (datab == 4'd2) ? (dataa & 7'h7f) + 7'h73 :
                    (datab == 4'd3) ? (dataa & 7'h7f) + 7'h66 :
                    (datab == 4'd4) ? (dataa & 7'h7f) + 7'h57 :
                    (datab == 4'd5) ? (dataa & 7'h7f) + 7'h35 :
                    (datab == 4'd6) ? (dataa & 7'h7f) + 7'h71 :
                    (datab == 4'd7) ? (dataa & 7'h7f) + 7'h62 :
                    (datab == 4'd8) ? (dataa & 7'h7f) + 7'h5F :
                    (datab == 4'd9) ? (dataa & 7'h7f) + 7'h25 :
                    (datab == 4'd10) ? (dataa & 7'h7f) + 7'h51 :
                    (dataa & 7'h7f) + 7'h22;

endmodule
