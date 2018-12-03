module sbox(inText, outText);

  input [3:0] inText;
  output [3:0] outText;
  wire [3:0] outText;


  assign outText = (inText == 4'h0) ? 4'hC
          :(inText == 4'h1) ? 4'h9
          :(inText == 4'h2) ? 4'hD
          :(inText == 4'h3) ? 4'h2
          :(inText == 4'h4) ? 4'h5
          :(inText == 4'h5) ? 4'hF
          :(inText == 4'h6) ? 4'h3
          :(inText == 4'h7) ? 4'h6
          :(inText == 4'h8) ? 4'h7
          :(inText == 4'h9) ? 4'hE
          :(inText == 4'hA) ? 4'h0
          :(inText == 4'hB) ? 4'h1
          :(inText == 4'hC) ? 4'hA
          :(inText == 4'hD) ? 4'h4
          :(inText == 4'hE) ? 4'hB
          :4'h8;

endmodule
