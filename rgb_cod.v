module rgb_pwm (
    input wire clk,
    input wire [1:0] r,
    input wire [1:0] g,
    input wire [1:0] b,
    output wire led_r,
    output wire led_g,
    output wire led_b
);

reg [1:0] counter;

always @(posedge clk)
    counter <= counter + 1;

assign led_r = counter < r;
assign led_g = counter < g;
assign led_b = counter < b;

endmodule

module rgb_cod (
	input clk,
	input  [5:0] jogada,
	output [2:0] display
);
	reg [1:0] pwm_r, pwm_g, pwm_b;
	rgb_pwm led_pwm (
		.clk(clk),
		.r(jogada[5:4]),
		.g(jogada[3:2]),
		.b(jogada[1:0]),
		.led_r(display[2]),
		.led_g(display[1]),
		.led_b(display[0])
	);
endmodule
