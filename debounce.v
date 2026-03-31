module debounce #(
    parameter integer INTERVAL = 4
) (
    input  pb1,
    input  clk,
    output reg pb1_debounced
);
    localparam integer COUNTER_BITS = (INTERVAL > 1) ? $clog2(INTERVAL) : 1;

    reg [COUNTER_BITS-1:0] counter;
    reg pb1_sync_0;
    reg pb1_sync_1;

    initial begin
        counter = {COUNTER_BITS{1'b0}};
        pb1_sync_0 = 1'b1;
        pb1_sync_1 = 1'b1;
        pb1_debounced = 1'b1;
    end

    always @(posedge clk) begin
        pb1_sync_0 <= pb1;
        pb1_sync_1 <= pb1_sync_0;

        if (pb1_sync_1 == pb1_debounced) begin
            counter <= {COUNTER_BITS{1'b0}};
        end else if (counter == INTERVAL-1) begin
            pb1_debounced <= pb1_sync_1;
            counter <= {COUNTER_BITS{1'b0}};
        end else begin
            counter <= counter + 1'b1;
        end
    end

endmodule
