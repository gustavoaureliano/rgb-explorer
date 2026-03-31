module timeout_counter #(
    parameter integer TIMEOUT_CYCLES = 5000
) (
    input  clock,
    input  zera,
    input  conta,
    output timeout
);
    localparam integer COUNTER_BITS = (TIMEOUT_CYCLES > 1) ? $clog2(TIMEOUT_CYCLES) : 1;

    reg [COUNTER_BITS-1:0] q_counter;

    always @(posedge clock or posedge zera) begin
        if (zera)
            q_counter <= {COUNTER_BITS{1'b0}};
        else if (conta && !timeout)
            q_counter <= q_counter + 1'b1;
    end

    assign timeout = (q_counter == TIMEOUT_CYCLES-1);

endmodule
