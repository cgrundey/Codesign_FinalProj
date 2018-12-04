//`timescale 1ns/1ps

module hw_imp_tb();
  parameter PERIOD = 10;

  reg clk, address, write, read, reset;
  reg [31:0] writedata;

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
    reset = 1;
    #(PERIOD*2) reset = 0;
    write = 1;
    address = 1;
    // writedata = 32'h00000000;
    // #(PERIOD)
    // writedata = 32'h00000000;
    // #(PERIOD)
    // writedata = 32'h00000000;
    // #(PERIOD)
    // writedata = 32'h00000000;
    // //Key
    // #(PERIOD)
    // writedata = 32'h00000000;
    // #(PERIOD)
    // writedata = 32'h00000000;
    // #(PERIOD)
    // writedata = 32'h00000000;
    // #(PERIOD)
    // writedata = 32'h00000000;
    // #(PERIOD)
    // read = 1;
    writedata = 32'h9abcdef0;
    #(PERIOD)
    writedata = 32'h12345678;
    #(PERIOD)
    writedata = 32'hfefebabe;
    #(PERIOD)
    writedata = 32'hdeadbeef;
    //Key
    #(PERIOD)
    writedata = 32'haa998877;
    #(PERIOD)
    writedata = 32'hffeeddcc;
    #(PERIOD)
    writedata = 32'h89abcdef;
    #(PERIOD)
    writedata = 32'h01234567;
    #(PERIOD)
    read = 1;
  end

  always
    #(PERIOD/2) clk = ~clk;


endmodule
