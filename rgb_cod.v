module rgb_pwm #(
    parameter integer PWM_BITS = 2
) (
    input wire clk,
    input wire [PWM_BITS-1:0] r,
    input wire [PWM_BITS-1:0] g,
    input wire [PWM_BITS-1:0] b,
    output wire led_r,
    output wire led_g,
    output wire led_b
);

reg [PWM_BITS-1:0] counter = {PWM_BITS{1'b0}};

always @(posedge clk)
    counter <= counter + 1'b1;

assign led_r = counter < r;
assign led_g = counter < g;
assign led_b = counter < b;

endmodule

module rgb_cod (
	input clk,
	input  [5:0] jogada,
	output [2:0] display
);
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
