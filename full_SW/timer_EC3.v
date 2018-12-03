/*
 * Mini Project 6
 * Timer
 * Colin Grundey & Wes Hirsheimer
 *
 * Start timer: write=1 writedata=1
 * Stop timer: write=1 writedata=2
 * Reset timer: write=1 writedata=3
 * Read timer: read=1 readdata=output
 */

module timer_mp6(clk, address, reset, write, writedata, read, readdata);
	/* Avalon MM signals */
	input clk, reset, write, read;
	input [7:0] address;
	input [31:0] writedata;
	output reg [31:0] readdata;

	reg [31:0] timer_count; /* Holds timer value */
	reg t_state; /* State of timer */

	parameter START = 1'b1, STOP = 1'b0; /* Timer states */

	always @ ( posedge clk ) begin

		if (reset) begin /* Global reset */
			t_state <= STOP; // Initialize to stopped state
			timer_count <= 32'h00000000; // Timer value intialized to 0
		end
		/* Timer STARTED */
		else if (t_state == START) begin
			/* Stop Timer */
			if (write && writedata == 2) t_state <= STOP;
			else begin
				/* Overflow Roll over */
				if (timer_count == 32'hFFFFFFFF) timer_count <= 32'h00000000;
				/* Increment Timer */
				else timer_count <= timer_count + 1;
			end
		end
		/* Timer STOPPED */
		else if (t_state == STOP) begin
			if (write) begin
				/* Start Timer */
				if (writedata == 1) t_state <= START;
				/* Reset Timer */
				else if (writedata == 3) timer_count <= 32'h00000000;
			end
		end
		/* READ Timer */
		if (read) readdata <= timer_count;

	end

endmodule
