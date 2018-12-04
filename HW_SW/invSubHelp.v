// dataa - input sbox
// datab - unused
// result - output sbox
module invSubHelp(dataa, datab, result);
    input [31:0] dataa, datab;
    output [31:0] result;

    assign result = (dataa == 0) ? 4'ha :
                    (dataa == 1) ? 4'hb :
                    (dataa == 2) ? 4'h3 :
                    (dataa == 3) ? 4'h6 :
                    (dataa == 4) ? 4'hd :
                    (dataa == 5) ? 4'h4 :
                    (dataa == 6) ? 4'h7 :
                    (dataa == 7) ? 4'h8 :
                    (dataa == 8) ? 4'hf :
                    (dataa == 9) ? 4'h1 :
                    (dataa == 10) ? 4'hc :
                    (dataa == 11) ? 4'he :
                    (dataa == 12) ? 4'h0 :
                    (dataa == 13) ? 4'h2 :
                    (dataa == 14) ? 4'h9 :
                    4'h5;

endmodule
