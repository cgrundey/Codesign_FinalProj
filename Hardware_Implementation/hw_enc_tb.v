//`timescale 1ns/1ps

module hw_enc_tb();
  parameter PERIOD = 10;

  reg clk, address, write, read, reset;
  reg [31:0] writedata;
  reg [63:0] counter;

  wire [31:0] readdata;
  wire waitrequest;

  hw_imp DUT( .clk(clk),
            .address(address),
            .reset(reset),
            .waitrequest(waitrequest), .
            write(write),
            .writedata(writedata),
            .read(read),
            .readdata(readdata));

  initial begin
    clk = 0;
    counter = 0;
    reset = 1;
    #(PERIOD*2) reset = 0;
    write = 1;
    address = 1;
    //ENCRYPT
    writedata = 32'h33221100;
    #(PERIOD)
    writedata = 32'h77665544;
    #(PERIOD)
    writedata = 32'h10fedcba;
    #(PERIOD)
    writedata = 32'h98765432;
    //Key
    #(PERIOD)
    writedata = 32'heeff0011;
    #(PERIOD)
    writedata = 32'haabbccdd;
    #(PERIOD)
    writedata = 32'h9abcdef0;
    #(PERIOD)
    writedata = 32'h12345678;
    #(PERIOD)
    read = 1;


  end

  always begin
    #(PERIOD/2) clk = ~clk;
    counter = counter + 1;
  end

endmodule
