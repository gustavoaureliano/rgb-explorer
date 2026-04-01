module rgb_intensity_bar (
    input  [5:0] rgb_in,
    output [3:0] intensidade_r,
    output [3:0] intensidade_g,
    output [3:0] intensidade_b
);
    function [3:0] nivel_para_barra;
        input [1:0] nivel;
        begin
            case (nivel)
                2'd0: nivel_para_barra = 4'b0001;
                2'd1: nivel_para_barra = 4'b0011;
                2'd2: nivel_para_barra = 4'b0111;
                default: nivel_para_barra = 4'b1111;
            endcase
        end
    endfunction

    assign intensidade_r = nivel_para_barra(rgb_in[5:4]);
    assign intensidade_g = nivel_para_barra(rgb_in[3:2]);
    assign intensidade_b = nivel_para_barra(rgb_in[1:0]);

endmodule
