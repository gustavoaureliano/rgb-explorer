module rgb_level_scale (
    input  [1:0] nivel,
    input  [5:0] rgb_in,
    output [5:0] rgb_out
);
    function [1:0] escala_cor;
        input [1:0] cor;
        input [1:0] nivel_atual;
        begin
            case (nivel_atual)
                2'd0: begin
                    if (cor == 2'd0)
                        escala_cor = 2'd0;
                    else
                        escala_cor = 2'd3;
                end
                2'd1: begin
                    case (cor)
                        2'd0: escala_cor = 2'd0;
                        2'd1: escala_cor = 2'd2;
                        default: escala_cor = 2'd3;
                    endcase
                end
                default: escala_cor = cor;
            endcase
        end
    endfunction

    assign rgb_out = {
        escala_cor(rgb_in[5:4], nivel),
        escala_cor(rgb_in[3:2], nivel),
        escala_cor(rgb_in[1:0], nivel)
    };

endmodule
