module score_calc (
    input        clock,
    input  [3:0] erro,
    output reg [3:0] pontos
);
    localparam [3:0] ERRO_EXATO = 4'd0;
    localparam [3:0] ERRO_PERTO_LIMITE = 4'd3;

    localparam [3:0] PONTOS_EXATO = 4'd4;
    localparam [3:0] PONTOS_PERTO = 4'd2;
    localparam [3:0] PONTOS_LONGE = 4'd0;

    always @(posedge clock) begin
        if (erro == ERRO_EXATO)
            pontos = PONTOS_EXATO;
        else if (erro < ERRO_PERTO_LIMITE)
            pontos = PONTOS_PERTO;
        else
            pontos = PONTOS_LONGE;
    end
endmodule
