`timescale 1ns/1ps

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
    writedata = 32'h00000000;
    // #7
    // writedata = 32'h00000001;
    // write = 0;
    // #5
    // write = 1;
    // writedata = 32'h00000002;
    // #5
    // write = 0;
    // #5
    // write = 1;
    // writedata = 32'h00000003;
    // #5
    // write = 0;
    // #5
    // write = 1;
    // writedata = 32'h00000004;
    // #5
    // write = 0;
    // #5
    // write = 1;
    // writedata = 32'h01234567;
    // #5
    // write = 0;
    // #5
    // write = 1;
    // writedata = 32'h89ABCDEF;
    // #5
    // write = 0;
    // #5
    // write = 1;
    // writedata = 32'h01234567;
    // #5
    // write = 0;
    // #5
    // write = 1;
    // writedata = 32'hABCDEF;
    // #5
    // write = 0;
    //#PERIOD
    //write = 0;
    #PERIOD;
    read = 1;
  end

  always
    #(PERIOD/2) clk = ~clk;


endmodule
