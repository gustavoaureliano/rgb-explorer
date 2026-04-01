`timescale 1ns/1ps

module tb_rgb_level_scale;
    reg  [1:0] nivel;
    reg  [5:0] rgb_in;
    wire [5:0] rgb_out;

    rgb_level_scale dut (
        .nivel(nivel),
        .rgb_in(rgb_in),
        .rgb_out(rgb_out)
    );

    function [1:0] escala_esperada;
        input [1:0] cor;
        input [1:0] nivel_atual;
        begin
            case (nivel_atual)
                2'd0: escala_esperada = (cor == 2'd0) ? 2'd0 : 2'd3;
                2'd1: begin
                    case (cor)
                        2'd0: escala_esperada = 2'd0;
                        2'd1: escala_esperada = 2'd2;
                        default: escala_esperada = 2'd3;
                    endcase
                end
                default: escala_esperada = cor;
            endcase
        end
    endfunction

    task check_case;
        input [1:0] nivel_in;
        input [5:0] rgb_in_local;
        reg [1:0] r_exp, g_exp, b_exp;
        begin
            nivel = nivel_in;
            rgb_in = rgb_in_local;
            #1;

            r_exp = escala_esperada(rgb_in_local[5:4], nivel_in);
            g_exp = escala_esperada(rgb_in_local[3:2], nivel_in);
            b_exp = escala_esperada(rgb_in_local[1:0], nivel_in);

            if (rgb_out !== {r_exp, g_exp, b_exp}) begin
                $fatal(1, "Falha escala: nivel=%0d rgb_in=%b esperado=%b obtido=%b",
                       nivel_in, rgb_in_local, {r_exp, g_exp, b_exp}, rgb_out);
            end
        end
    endtask

    integer n;
    integer v;
    reg [5:0] max_easy;
    reg [5:0] max_normal;
    reg [5:0] max_hard;

    initial begin
        // Verificacao exaustiva das combinacoes por nivel
        for (n = 0; n < 3; n = n + 1) begin
            for (v = 0; v < 64; v = v + 1) begin
                check_case(n[1:0], v[5:0]);
            end
        end

        // Verifica proporcionalidade de maxima intensidade por canal (R)
        nivel = 2'd0; rgb_in = 6'b01_00_00; #1; max_easy = rgb_out;
        nivel = 2'd1; rgb_in = 6'b10_00_00; #1; max_normal = rgb_out;
        nivel = 2'd2; rgb_in = 6'b11_00_00; #1; max_hard = rgb_out;

        if (!(max_easy[5:4] == max_normal[5:4] && max_normal[5:4] == max_hard[5:4])) begin
            $fatal(1, "Maximos nao proporcionais no canal R: facil=%b normal=%b dificil=%b",
                   max_easy[5:4], max_normal[5:4], max_hard[5:4]);
        end

        $display("tb_rgb_level_scale: OK");
        $finish;
    end

endmodule
