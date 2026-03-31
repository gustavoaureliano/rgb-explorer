module rgb_level_counter (
    input        clock,
    input        zera_as,
    input        conta,
    input        neg,
    input  [1:0] max_val,
    output reg [1:0] Q
);
    always @(posedge clock or posedge zera_as) begin
        if (zera_as) begin
            Q <= 2'b00;
        end else if (conta) begin
            if (neg) begin
                if (Q == 2'b00)
                    Q <= max_val;
                else
                    Q <= Q - 1'b1;
            end else begin
                if (Q >= max_val)
                    Q <= 2'b00;
                else
                    Q <= Q + 1'b1;
            end
        end
    end
endmodule
