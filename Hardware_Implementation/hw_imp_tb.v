//`timescale 1ns/1ps

module hw_imp_tb();
  parameter PERIOD = 10;

  reg clk, address, write, read, reset;
  reg [31:0] writedata;

  wire [31:0] readdata;
  wire waitrequest;

  hw_decrypt DUT( .clk(clk),
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
    //DECRYPT
    writedata = 32'h70918058;
    #(PERIOD)
    writedata = 32'h0cf1931a;
    #(PERIOD)
    writedata = 32'he7734057;
    #(PERIOD)
    writedata = 32'h91f025e0;
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


    // //DECRYPT
    // writedata = 32'hdb925513;
    // #(PERIOD)
    // writedata = 32'h50eaf617;
    // #(PERIOD)
    // writedata = 32'hca4dcf5b;
    // #(PERIOD)
    // writedata = 32'hdab1c4c0;
    // //Key
    // #(PERIOD)
    // writedata = 32'haa998877;
    // #(PERIOD)
    // writedata = 32'hffeeddcc;
    // #(PERIOD)
    // writedata = 32'h89abcdef;
    // #(PERIOD)
    // writedata = 32'h01234567;
    // #(PERIOD)
    // read = 1;
  end

  always
    #(PERIOD/2) clk = ~clk;

endmodule
