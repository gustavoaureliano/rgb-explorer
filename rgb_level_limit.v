module rgb_level_limit (
    input  [1:0] nivel,
    input  [5:0] rgb_in,
    output [5:0] rgb_out
);
    function [1:0] limita_cor;
        input [1:0] cor;
        input [1:0] nivel_atual;
        begin
            case (nivel_atual)
                2'd0: limita_cor = {1'b0, cor[0]};
                2'd1: limita_cor = (cor == 2'd3) ? 2'd2 : cor;
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
