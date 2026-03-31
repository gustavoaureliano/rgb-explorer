module level_system #(
    parameter integer PLAYS_PER_LEVEL = 3
) (
    input            clk,
    input            reset,
    input            jogada,
    output reg [1:0] level
);
    localparam [1:0] NIVEL_FACIL = 2'd0;
    localparam [1:0] NIVEL_NORMAL = 2'd1;
    localparam [1:0] NIVEL_DIFICIL = 2'd2;
    localparam integer COUNT_BITS = (PLAYS_PER_LEVEL > 1) ? $clog2(PLAYS_PER_LEVEL) : 1;

    reg [COUNT_BITS-1:0] conta_jogada;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            conta_jogada <= {COUNT_BITS{1'b0}};
            level <= NIVEL_FACIL;
        end else if (jogada) begin
            if (conta_jogada == PLAYS_PER_LEVEL-1) begin
                conta_jogada <= {COUNT_BITS{1'b0}};

                if (level == NIVEL_DIFICIL)
                    level <= NIVEL_FACIL;
                else
                    level <= level + 1'b1;
            end else begin
                conta_jogada <= conta_jogada + 1'b1;
            end
        end
    end

endmodule
