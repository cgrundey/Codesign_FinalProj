// Hardware Implementation for Final Project
// Encrypt and Decrypt functions
`timescale 1ns/1ps
module hw_imp(clk, address, reset, waitrequest, write, writedata, read, readdata);

  input clk, reset, write, read;
  input address;
  input [31:0] writedata;
  output reg waitrequest;
  output reg [31:0] readdata;

  reg [127:0] text, key, outreg, roundKey;
  reg [63:0] tempHalf;
  //reg [63:0] temp1, temp2, temp3, temp4;
  reg [4:0] state, next_state, rounds;
  reg state_change;
  reg [3:0] sbox_in;
  wire [3:0] sbox_out;

  sbox my_sbox(.inText(sbox_in), .outText(sbox_out));

  //FSM states
  localparam  START = 5'h00,
              LDTXT1 = 5'h01,
              LDTXT2 = 5'h02,
              LDTXT3 = 5'h03,
              LDTXT4 = 5'h04,
              LDKEY1 = 5'h05,
              LDKEY2 = 5'h06,
              LDKEY3 = 5'h07,
              LDKEY4 = 5'h08,
              ENCRYPT = 5'h09,
              DECRYPT = 5'h0A,
              OUT1 = 5'h0B,
              OUT2 = 5'h0C,
              OUT3 = 5'h0D,
              OUT4 = 5'h0E,
              ENCALC = 5'h0F,
              DECALC = 5'b10;


  always @(posedge clk) begin

    if (reset) begin
      state = START;
      rounds = 0;
      waitrequest = 0;
    end
    else begin
      state = next_state;
      state_change = 1'b1;
    end

  end

  //FSM
  always @(posedge state_change or posedge write or posedge read) begin
    //next_state = START;
    state_change = 1'b0;
    waitrequest = 0;

    case(state)
      START: begin
        rounds = 0;
        next_state = START;
        if(write)
          next_state = LDTXT1;
      end

      LDTXT1: begin
        if(write) begin
          text[31:0] = writedata;
          next_state = LDTXT2;
        end
      end

      LDTXT2: begin
        if(write) begin
          text[63:32] = writedata;
          next_state = LDTXT3;
        end
      end

      LDTXT3: begin
        if(write) begin
          text[95:64] = writedata;
          next_state = LDTXT4;
        end
      end

      LDTXT4: begin
        if(write) begin
          text[127:96] = writedata;
          next_state = LDKEY1;
        end
      end

      LDKEY1: begin
        if(write) begin
          key[31:0] = writedata;
          next_state = LDKEY2;
        end
      end

      LDKEY2: begin
        if(write) begin
          key[63:32] = writedata;
          next_state = LDKEY3;
        end
      end

      LDKEY3: begin
        if(write) begin
          key[95:64] = writedata;
          next_state = LDKEY4;
        end
      end

      LDKEY4: begin
        if(write) begin
          key[127:96] = writedata;
          roundKey = key;
          if(address == 1'b1)begin
            next_state = ENCRYPT;
          end
        end
        else begin
          next_state = DECRYPT;
        end
      end
      // Encrypt state machine
      ENCRYPT: begin
        //Step1: start loop
        if(rounds < 4'b1100)begin
          next_state = ENCALC;
        end
        else begin
          waitrequest = 1'b0;
          next_state = OUT1;
        end

      end

      ENCALC: begin
        waitrequest = 1'b1;
      //Step2: Calculate round Key
        // tempHalf = {roundKey[47:32], roundKey[63:48], roundKey[15:0], roundKey[31:16]};
        // roundKey[63:0] = tempHalf ^ roundKey[127:64];
        // roundKey[127:64] = tempHalf;
        // //Step3: update upper half
        // text[127:64] = text[127:64] ^ roundKey[127:64];
        // $display("Text 1: %x",text);
        // //step4: subBytes(text upper half)
        // //1
        // sbox_in = text[67:64];
        // #5
        // text[67:64] = sbox_out;
        // //2
        // sbox_in = text[71:68];
        // #5
        // text[71:68] = sbox_out;
        // //3
        // sbox_in = text[75:72];
        // #5
        // text[75:72] = sbox_out;
        // //4
        // sbox_in = text[79:76];
        // #5
        // text[79:76] = sbox_out;
        // //5
        // sbox_in = text[83:80];
        // #5
        // text[83:80] = sbox_out;
        // //6
        // sbox_in = text[87:84];
        // #5
        // text[87:84] = sbox_out;
        // //7
        // sbox_in = text[91:88];
        // #5
        // text[91:88] = sbox_out;
        // //8
        // sbox_in = text[95:92];
        // #5
        // text[95:92] = sbox_out;
        // //9
        // sbox_in = text[99:96];
        // #5
        // text[99:96] = sbox_out;
        // //10
        // sbox_in = text[103:100];
        // #5
        // text[107:104] = sbox_out;
        // //11
        // sbox_in = text[111:108];
        // #5
        // text[111:108] = sbox_out;
        // //12
        // sbox_in = text[115:112];
        // #5
        // text[115:112] = sbox_out;
        // //13
        // sbox_in = text[119:116];
        // #5
        // text[119:116] = sbox_out;
        // //14
        // sbox_in = text[123:120];
        // #5
        // text[123:120] = sbox_out;
        // //15
        // sbox_in = text[127:124];
        // #5
        // text[127:124] = sbox_out;
        // //16
        // sbox_in = text[107:104];
        // #5
        // text[107:104] = sbox_out;
        //
        // $display("Text 2: %x",text);
        //
        // //step5: add round constant
        // #5
        // text[20:14] = (rounds == 7'd0) ? text[20:14] + 7'h5A
        //               :(rounds == 7'd1) ? text[20:14] + 7'h34
        //               :(rounds == 7'd2) ? text[20:14] + 7'h73
        //               :(rounds == 7'd3) ? text[20:14] + 7'h66
        //               :(rounds == 7'd4) ? text[20:14] + 7'h57
        //               :(rounds == 7'd5) ? text[20:14] + 7'h35
        //               :(rounds == 7'd6) ? text[20:14] + 7'h71
        //               :(rounds == 7'd7) ? text[20:14] + 7'h62
        //               :(rounds == 7'd8) ? text[20:14] + 7'h5F
        //               :(rounds == 7'd9) ? text[20:14] + 7'h25
        //               :(rounds == 7'd10) ? text[20:14] + 7'h51
        //               :text[20:14] + 7'h22;
        //
        //
        // //step6: xor
        // #5
        // text[63:0] = text[63:0] ^ roundKey[63:0];
        //
        // //step7: perm2(perm1(textlow))
        // //perm1
        // #5
        // tempHalf = {text[31:16], text[15:0], text[63:48], text[47:32]};
        // //perm2
        // #5
        // tempHalf = {tempHalf[42:0], tempHalf[63:43]};
        // #5
        // text[63:0] = tempHalf;
        // //step8
        // #5
        // tempHalf = text[127:64];
        // //step9
        // #5
        // text[127:64] = text[127:64] ^ text[63:0];
        // //step 10
        // #5
        rounds = rounds + 1;
        next_state = ENCRYPT;
      end


      //Decrypt State machine
      DECRYPT: begin
        waitrequest = 1'b1;

      end

      //output states
      OUT1: begin
        if(read == 1'b1) begin
          readdata = text[31:0];
          next_state = OUT2;
        end
        else next_state = OUT1;
      end

      OUT2: begin
        if(read == 1'b1) begin
          readdata = text[63:32];
          next_state = OUT3;
        end
        else next_state = OUT2;
      end

      OUT3: begin
        if(read == 1'b1) begin
          readdata = text[95:64];
          next_state = OUT4;
        end
        else next_state = OUT3;
      end

      OUT4: begin
        if(read == 1'b1) begin
          readdata = text[127:96];
          next_state = START;
        end
        else next_state = OUT4;
      end
    endcase
  end

endmodule
