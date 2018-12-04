module invsbox(inText, outText);

  input [31:0] inText;
  output [31:0] outText;
  wire [31:0] outText;

  assign outText[31:28] = (inText[31:28] == 4'h0) ? 4'hA
          :(inText[31:28] == 4'h1) ? 4'hB
          :(inText[31:28] == 4'h2) ? 4'h3
          :(inText[31:28] == 4'h3) ? 4'h6
          :(inText[31:28] == 4'h4) ? 4'hD
          :(inText[31:28] == 4'h5) ? 4'h4
          :(inText[31:28] == 4'h6) ? 4'h7
          :(inText[31:28] == 4'h7) ? 4'h8
          :(inText[31:28] == 4'h8) ? 4'hF
          :(inText[31:28] == 4'h9) ? 4'h1
          :(inText[31:28] == 4'hA) ? 4'hC
          :(inText[31:28] == 4'hB) ? 4'hE
          :(inText[31:28] == 4'hC) ? 4'h0
          :(inText[31:28] == 4'hD) ? 4'h2
          :(inText[31:28] == 4'hE) ? 4'h9
          :4'h5;

  assign outText[27:24] = (inText[27:24] == 4'h0) ? 4'hA
          :(inText[27:24] == 4'h1) ? 4'hB
          :(inText[27:24] == 4'h2) ? 4'h3
          :(inText[27:24] == 4'h3) ? 4'h6
          :(inText[27:24] == 4'h4) ? 4'hD
          :(inText[27:24] == 4'h5) ? 4'h4
          :(inText[27:24] == 4'h6) ? 4'h7
          :(inText[27:24] == 4'h7) ? 4'h8
          :(inText[27:24] == 4'h8) ? 4'hF
          :(inText[27:24] == 4'h9) ? 4'h1
          :(inText[27:24] == 4'hA) ? 4'hC
          :(inText[27:24] == 4'hB) ? 4'hE
          :(inText[27:24] == 4'hC) ? 4'h0
          :(inText[27:24] == 4'hD) ? 4'h2
          :(inText[27:24] == 4'hE) ? 4'h9
          :4'h5;

  assign outText[23:20] = (inText[23:20] == 4'h0) ? 4'hA
            :(inText[23:20] == 4'h1) ? 4'hB
            :(inText[23:20] == 4'h2) ? 4'h3
            :(inText[23:20] == 4'h3) ? 4'h6
            :(inText[23:20] == 4'h4) ? 4'hD
            :(inText[23:20] == 4'h5) ? 4'h4
            :(inText[23:20] == 4'h6) ? 4'h7
            :(inText[23:20] == 4'h7) ? 4'h8
            :(inText[23:20] == 4'h8) ? 4'hF
            :(inText[23:20] == 4'h9) ? 4'h1
            :(inText[23:20] == 4'hA) ? 4'hC
            :(inText[23:20] == 4'hB) ? 4'hE
            :(inText[23:20] == 4'hC) ? 4'h0
            :(inText[23:20] == 4'hD) ? 4'h2
            :(inText[23:20] == 4'hE) ? 4'h9
            :4'h5;

  assign outText[19:16] = (inText[19:16] == 4'h0) ? 4'hA
          :(inText[19:16] == 4'h1) ? 4'hB
          :(inText[19:16] == 4'h2) ? 4'h3
          :(inText[19:16] == 4'h3) ? 4'h6
          :(inText[19:16] == 4'h4) ? 4'hD
          :(inText[19:16] == 4'h5) ? 4'h4
          :(inText[19:16] == 4'h6) ? 4'h7
          :(inText[19:16] == 4'h7) ? 4'h8
          :(inText[19:16] == 4'h8) ? 4'hF
          :(inText[19:16] == 4'h9) ? 4'h1
          :(inText[19:16] == 4'hA) ? 4'hC
          :(inText[19:16] == 4'hB) ? 4'hE
          :(inText[19:16] == 4'hC) ? 4'h0
          :(inText[19:16] == 4'hD) ? 4'h2
          :(inText[19:16] == 4'hE) ? 4'h9
          :4'h5;


  assign outText[15:12] = (inText[15:12] == 4'h0) ? 4'hA
        :(inText[15:12] == 4'h1) ? 4'hB
        :(inText[15:12] == 4'h2) ? 4'h3
        :(inText[15:12] == 4'h3) ? 4'h6
        :(inText[15:12] == 4'h4) ? 4'hD
        :(inText[15:12] == 4'h5) ? 4'h4
        :(inText[15:12] == 4'h6) ? 4'h7
        :(inText[15:12] == 4'h7) ? 4'h8
        :(inText[15:12] == 4'h8) ? 4'hF
        :(inText[15:12] == 4'h9) ? 4'h1
        :(inText[15:12] == 4'hA) ? 4'hC
        :(inText[15:12] == 4'hB) ? 4'hE
        :(inText[15:12] == 4'hC) ? 4'h0
        :(inText[15:12] == 4'hD) ? 4'h2
        :(inText[15:12] == 4'hE) ? 4'h9
        :4'h5;

  assign outText[11:8] = (inText[11:8] == 4'h0) ? 4'hA
          :(inText[11:8] == 4'h1) ? 4'hB
          :(inText[11:8] == 4'h2) ? 4'h3
          :(inText[11:8] == 4'h3) ? 4'h6
          :(inText[11:8] == 4'h4) ? 4'hD
          :(inText[11:8] == 4'h5) ? 4'h4
          :(inText[11:8] == 4'h6) ? 4'h7
          :(inText[11:8] == 4'h7) ? 4'h8
          :(inText[11:8] == 4'h8) ? 4'hF
          :(inText[11:8] == 4'h9) ? 4'h1
          :(inText[11:8] == 4'hA) ? 4'hC
          :(inText[11:8] == 4'hB) ? 4'hE
          :(inText[11:8] == 4'hC) ? 4'h0
          :(inText[11:8] == 4'hD) ? 4'h2
          :(inText[11:8] == 4'hE) ? 4'h9
          :4'h5;

  assign outText[7:4] = (inText[7:4] == 4'h0) ? 4'hA
          :(inText[7:4] == 4'h1) ? 4'hB
          :(inText[7:4] == 4'h2) ? 4'h3
          :(inText[7:4] == 4'h3) ? 4'h6
          :(inText[7:4] == 4'h4) ? 4'hD
          :(inText[7:4] == 4'h5) ? 4'h4
          :(inText[7:4] == 4'h6) ? 4'h7
          :(inText[7:4] == 4'h7) ? 4'h8
          :(inText[7:4] == 4'h8) ? 4'hF
          :(inText[7:4] == 4'h9) ? 4'h1
          :(inText[7:4] == 4'hA) ? 4'hC
          :(inText[7:4] == 4'hB) ? 4'hE
          :(inText[7:4] == 4'hC) ? 4'h0
          :(inText[7:4] == 4'hD) ? 4'h2
          :(inText[7:4] == 4'hE) ? 4'h9
          :4'h5;



  assign outText[3:0] = (inText[3:0] == 4'h0) ? 4'hA
          :(inText[3:0] == 4'h1) ? 4'hB
          :(inText[3:0] == 4'h2) ? 4'h3
          :(inText[3:0] == 4'h3) ? 4'h6
          :(inText[3:0] == 4'h4) ? 4'hD
          :(inText[3:0] == 4'h5) ? 4'h4
          :(inText[3:0] == 4'h6) ? 4'h7
          :(inText[3:0] == 4'h7) ? 4'h8
          :(inText[3:0] == 4'h8) ? 4'hF
          :(inText[3:0] == 4'h9) ? 4'h1
          :(inText[3:0] == 4'hA) ? 4'hC
          :(inText[3:0] == 4'hB) ? 4'hE
          :(inText[3:0] == 4'hC) ? 4'h0
          :(inText[3:0] == 4'hD) ? 4'h2
          :(inText[3:0] == 4'hE) ? 4'h9
          :4'h5;







endmodule
