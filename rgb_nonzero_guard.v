module rgb_nonzero_guard (
    input  [5:0] rgb_in,
    output [5:0] rgb_out
);
    localparam [5:0] RGB_ZERO = 6'b000000;
    localparam [5:0] RGB_FALLBACK = 6'b010001;

    assign rgb_out = (rgb_in == RGB_ZERO) ? RGB_FALLBACK : rgb_in;
endmodule
