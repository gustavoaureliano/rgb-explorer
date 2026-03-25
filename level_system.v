module level_system (
    input clk,
    input reset,
    input jogada,      // entrada de erro do sistema
    output reg [1:0] level
);

reg [7:0] score;  // contador de acertos

always @(posedge clk or posedge reset) begin
    if (reset) begin
        score <= 0;
        level <= 1;
    end else begin
        // incrementa score quando acerta
        if (error >= 0 && error < 3)  // considerando erro < 3 como acerto
            score <= score + 1;
        else if (error >= 3 && error < 9)  // considerando erro >= 3 como erro
            score <= score;  // mantém o score (ou poderia decrementar)
        else score <= score;  // para outros casos, mantém o score

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

