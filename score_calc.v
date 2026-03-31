module score_calc (
    input        clock,
    input  [3:0] erro,
    output reg [3:0] pontos
);
    always @(posedge clock) begin
        if (erro == 0)
            pontos = 4;
        else if (erro < 3)
            pontos = 2;
        else
            pontos = 0;
    end
endmodule
