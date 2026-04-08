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

module rgb_pwm_expand #(
    parameter integer PWM_BITS = 8,
    parameter integer MAP_PROFILE = 1
) (
    input  wire [1:0] r_in,
    input  wire [1:0] g_in,
    input  wire [1:0] b_in,
    output wire [PWM_BITS-1:0] r_out,
    output wire [PWM_BITS-1:0] g_out,
    output wire [PWM_BITS-1:0] b_out
);

localparam integer PWM_MAX_INT = (1 << PWM_BITS) - 1;
localparam [PWM_BITS-1:0] PWM_ZERO = {PWM_BITS{1'b0}};
localparam [PWM_BITS-1:0] PWM_ONE_THIRD = PWM_MAX_INT / 3;
localparam [PWM_BITS-1:0] PWM_TWO_THIRD = (2 * PWM_MAX_INT) / 3;
localparam [PWM_BITS-1:0] PWM_MAX = PWM_MAX_INT;

localparam integer MAP_LINEAR = 0;
localparam integer MAP_GAMMA_SOFT = 1;
localparam integer MAP_GAMMA_STRONG = 2;

localparam [PWM_BITS-1:0] SOFT_LVL1 = (PWM_MAX_INT * 32) / 255;
localparam [PWM_BITS-1:0] SOFT_LVL2 = (PWM_MAX_INT * 120) / 255;
localparam [PWM_BITS-1:0] STRONG_LVL1 = (PWM_MAX_INT * 20) / 255;
localparam [PWM_BITS-1:0] STRONG_LVL2 = (PWM_MAX_INT * 105) / 255;

function [PWM_BITS-1:0] expand_2b;
    input [1:0] value;
    begin
        case (MAP_PROFILE)
            MAP_LINEAR: begin
                case (value)
                    2'd0: expand_2b = PWM_ZERO;
                    2'd1: expand_2b = PWM_ONE_THIRD;
                    2'd2: expand_2b = PWM_TWO_THIRD;
                    default: expand_2b = PWM_MAX;
                endcase
            end
            MAP_GAMMA_STRONG: begin
                case (value)
                    2'd0: expand_2b = PWM_ZERO;
                    2'd1: expand_2b = STRONG_LVL1;
                    2'd2: expand_2b = STRONG_LVL2;
                    default: expand_2b = PWM_MAX;
                endcase
            end
            default: begin
                case (value)
                    2'd0: expand_2b = PWM_ZERO;
                    2'd1: expand_2b = SOFT_LVL1;
                    2'd2: expand_2b = SOFT_LVL2;
                    default: expand_2b = PWM_MAX;
                endcase
            end
        endcase
    end
endfunction

assign r_out = expand_2b(r_in);
assign g_out = expand_2b(g_in);
assign b_out = expand_2b(b_in);

endmodule

module rgb_cod #(
	parameter integer PWM_BITS = 8,
	parameter integer MAP_PROFILE = 1
) (
	input clk,
	input  [5:0] jogada,
	output [2:0] display
);
	wire [PWM_BITS-1:0] r_pwm;
	wire [PWM_BITS-1:0] g_pwm;
	wire [PWM_BITS-1:0] b_pwm;

	rgb_pwm_expand #(
		.PWM_BITS(PWM_BITS),
		.MAP_PROFILE(MAP_PROFILE)
	) expander (
		.r_in(jogada[5:4]),
		.g_in(jogada[3:2]),
		.b_in(jogada[1:0]),
		.r_out(r_pwm),
		.g_out(g_pwm),
		.b_out(b_pwm)
	);

	rgb_pwm #(
		.PWM_BITS(PWM_BITS)
	) led_pwm (
		.clk(clk),
		.r(r_pwm),
		.g(g_pwm),
		.b(b_pwm),
		.led_r(display[2]),
		.led_g(display[1]),
		.led_b(display[0])
	);
endmodule
