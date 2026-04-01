module rgb_level_scale (
    input  [1:0] nivel,
    input  [5:0] rgb_in,
    output [5:0] rgb_out
);
    localparam [1:0] NIVEL_FACIL = 2'd0;
    localparam [1:0] NIVEL_NORMAL = 2'd1;

    localparam [1:0] PWM_OFF = 2'd0;
    localparam [1:0] PWM_MID = 2'd2;
    localparam [1:0] PWM_MAX = 2'd3;

    function [1:0] escala_cor;
        input [1:0] cor;
        input [1:0] nivel_atual;
        begin
            case (nivel_atual)
                NIVEL_FACIL: begin
                    if (cor == PWM_OFF)
                        escala_cor = PWM_OFF;
                    else
                        escala_cor = PWM_MAX;
                end
                NIVEL_NORMAL: begin
                    case (cor)
                        PWM_OFF: escala_cor = PWM_OFF;
                        2'd1: escala_cor = PWM_MID;
                        default: escala_cor = PWM_MAX;
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
