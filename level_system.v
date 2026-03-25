module level_system (
    input clk,
    input reset,
    input jogada,      // entrada de erro do sistema
    output reg [1:0] level
);

reg [7:0] conta_jogada;  // contador de jogadas

always @(posedge clk or posedge reset) begin
    if (reset) begin
        conta_jogada <= 0;
        level <= 1;
    end else begin
        if (jogada) begin
            conta_jogada <= conta_jogada + 1; // incrementa o contador a cada jogada
        end

        // lógica de mudança de nível
        if (conta_jogada < 3)
            level <= 1;
        else if (conta_jogada < 6)
            level <= 2;
        else
            level <= 3;
    end
end

endmodule

