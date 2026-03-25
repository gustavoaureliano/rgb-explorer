module level_system (
    input clk,
    input reset,
    input correct,      // sinal: 1 quando acerta
    output reg [1:0] level
);

reg [7:0] score;  // contador de acertos

always @(posedge clk or posedge reset) begin
    if (reset) begin
        score <= 0;
        level <= 1;
    end else begin
        // incrementa score quando acerta
        if (correct)
            score <= score + 1;

        // lógica de mudança de nível
        if (score < 5)
            level <= 1;
        else if (score < 10)
            level <= 2;
        else
            level <= 3;
    end
end

endmodule