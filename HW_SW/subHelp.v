// dataa - input sbox
// datab - unused
// result - output sbox
module subHelp(dataa, datab, result);
    input [31:0] dataa, datab;
    output [31:0] result;

    assign result = (dataa == 0) ? 4'hc :
                    (dataa == 1) ? 4'h9 :
                    (dataa == 2) ? 4'hd :
                    (dataa == 3) ? 4'h2 :
                    (dataa == 4) ? 4'h5 :
                    (dataa == 5) ? 4'hf :
                    (dataa == 6) ? 4'h3 :
                    (dataa == 7) ? 4'h6 :
                    (dataa == 8) ? 4'h7 :
                    (dataa == 9) ? 4'he :
                    (dataa == 10) ? 4'h0 :
                    (dataa == 11) ? 4'h1 :
                    (dataa == 12) ? 4'ha :
                    (dataa == 13) ? 4'h4 :
                    (dataa == 14) ? 4'hb :
                    4'h8;

endmodule
