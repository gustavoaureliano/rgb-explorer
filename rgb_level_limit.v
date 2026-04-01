module rgb_level_limit (
    input  [1:0] nivel,
    input  [5:0] rgb_in,
    output [5:0] rgb_out
);
    localparam [1:0] NIVEL_FACIL = 2'd0;
    localparam [1:0] NIVEL_NORMAL = 2'd1;
    localparam [1:0] MAX_NORMAL = 2'd2;
    localparam [1:0] MAX_DIFICIL = 2'd3;

    function [1:0] limita_cor;
        input [1:0] cor;
        input [1:0] nivel_atual;
        begin
            case (nivel_atual)
                NIVEL_FACIL: limita_cor = {1'b0, cor[0]};
                NIVEL_NORMAL: limita_cor = (cor == MAX_DIFICIL) ? MAX_NORMAL : cor;
                default: limita_cor = cor;
            endcase
        end
    endfunction

    assign rgb_out = {
        limita_cor(rgb_in[5:4], nivel),
        limita_cor(rgb_in[3:2], nivel),
        limita_cor(rgb_in[1:0], nivel)
    };

endmodule
