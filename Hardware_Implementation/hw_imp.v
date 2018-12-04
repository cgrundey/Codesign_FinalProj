// Hardware Implementation for Final Project
// Encrypt and Decrypt functions

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
  reg [31:0] sbox_in;
  wire [31:0] sbox_out;

  sbox my_sbox(.inText(sbox_in), .outText(sbox_out));

  //FSM states
  localparam  START = 8'h00,
              LDTXT1 = 8'h01,
              LDTXT2 = 8'h02,
              LDTXT3 = 8'h03,
              LDTXT4 = 8'h04,
              LDKEY1 = 8'h05,
              LDKEY2 = 8'h06,
              LDKEY3 = 8'h07,
              LDKEY4 = 8'h08,
              ENCRYPT = 8'h09,
              SBOX3 = 8'h0A,
              OUT1 = 8'h0B,
              OUT2 = 8'h0C,
              OUT3 = 8'h0D,
              OUT4 = 8'h0E,
              ENCALC = 8'h0F,
              SBOX1 = 8'h10,
              SBOX2 = 8'h11,
              ENFINAL = 8'h12;



  always @(posedge clk) begin

    if (reset) begin
      state = START;
      waitrequest = 0;
    end
    else begin
      state = next_state;
      state_change = 1'b1;
    end

  end

  //FSM
  always @(posedge state_change or posedge write or posedge read) begin
    next_state = START;
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
        text[31:0] = writedata;
        next_state = LDTXT2;
      end

      LDTXT2: begin
        text[63:32] = writedata;
        next_state = LDTXT3;
      end

      LDTXT3: begin
        text[95:64] = writedata;
        next_state = LDTXT4;
      end

      LDTXT4: begin
        text[127:96] = writedata;
        next_state = LDKEY1;
      end

      LDKEY1: begin
        key[31:0] = writedata;
        next_state = LDKEY2;
      end

      LDKEY2: begin
        key[63:32] = writedata;
        next_state = LDKEY3;
      end

      LDKEY3: begin
        key[95:64] = writedata;
        next_state = LDKEY4;
      end

      LDKEY4: begin
        key[127:96] = writedata;
        roundKey = key;
        if(address == 1'b1)begin
          next_state = ENCRYPT;
        end
      end
      // Encrypt state machine
      ENCRYPT: begin
        //Step1: start loop
        if(rounds < 4'b1100)begin
          waitrequest = 1'b1;
          tempHalf = {roundKey[47:32], roundKey[63:48], roundKey[15:0], roundKey[31:16]};
          roundKey[63:0] = tempHalf ^ roundKey[127:64];
          roundKey[127:64] = tempHalf;
          //Step3: update upper half
          text[127:64] = text[127:64] ^ roundKey[127:64];
          next_state = SBOX1;
        end
        else begin
          waitrequest = 1'b0;
          next_state = OUT1;
        end

      end

    SBOX1: begin
      sbox_in = text[95:64];
      next_state = SBOX2;

    end

    SBOX2: begin
      text[95:64] = sbox_out;
      sbox_in = text[127:96];
      next_state = SBOX3;
    end

    SBOX3: begin
      text[127:96] = sbox_out;

      //add round constant
      text[20:14] = (rounds == 7'd0) ? text[20:14] + 7'h5A
                    :(rounds == 7'd1) ? text[20:14] + 7'h34
                    :(rounds == 7'd2) ? text[20:14] + 7'h73
                    :(rounds == 7'd3) ? text[20:14] + 7'h66
                    :(rounds == 7'd4) ? text[20:14] + 7'h57
                    :(rounds == 7'd5) ? text[20:14] + 7'h35
                    :(rounds == 7'd6) ? text[20:14] + 7'h71
                    :(rounds == 7'd7) ? text[20:14] + 7'h62
                    :(rounds == 7'd8) ? text[20:14] + 7'h5F
                    :(rounds == 7'd9) ? text[20:14] + 7'h25
                    :(rounds == 7'd10) ? text[20:14] + 7'h51
                    :text[20:14] + 7'h22;
      next_state = ENCALC;
    end


    ENCALC: begin
      //step6
      text[63:0] = text[63:0] ^ roundKey[63:0];
      //step7 perm1
      tempHalf = {text[47:32], text[63:48], text[15:0], text[31:16]};
      text[63:0] = {tempHalf[42:0], tempHalf[63:43]};

      tempHalf = text[127:64];
      text[127:64] = text[127:64] ^ text[63:0];
      text[63:0] = tempHalf;

      rounds = rounds + 1;
      next_state = ENCRYPT;

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
    end


      //Decrypt State machine
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
