`timescale 1ns/1ps

module tb_rgb_level_limit;
    reg  [1:0] nivel;
    reg  [5:0] rgb_in;
    wire [5:0] rgb_out;

    rgb_level_limit dut (
        .nivel(nivel),
        .rgb_in(rgb_in),
        .rgb_out(rgb_out)
    );

    task check_limit;
        input [1:0] nivel_in;
        input [5:0] rgb_in_local;
        reg [1:0] r_in, g_in, b_in;
        reg [1:0] r_exp, g_exp, b_exp;
        begin
            nivel = nivel_in;
            rgb_in = rgb_in_local;
            #1;

            r_in = rgb_in_local[5:4];
            g_in = rgb_in_local[3:2];
            b_in = rgb_in_local[1:0];

            case (nivel_in)
                2'd0: begin
                    r_exp = {1'b0, r_in[0]};
                    g_exp = {1'b0, g_in[0]};
                    b_exp = {1'b0, b_in[0]};
                end
                2'd1: begin
                    r_exp = (r_in == 2'd3) ? 2'd2 : r_in;
                    g_exp = (g_in == 2'd3) ? 2'd2 : g_in;
                    b_exp = (b_in == 2'd3) ? 2'd2 : b_in;
                end
                default: begin
                    r_exp = r_in;
                    g_exp = g_in;
                    b_exp = b_in;
                end
            endcase

            if (rgb_out !== {r_exp, g_exp, b_exp}) begin
                $display("ERRO: nivel=%0d rgb_in=%b esperado=%b obtido=%b",
                         nivel_in, rgb_in_local, {r_exp, g_exp, b_exp}, rgb_out);
                $finish;
            end
        end
    endtask

    integer n;
    integer v;

    initial begin
        for (n = 0; n < 3; n = n + 1) begin
            for (v = 0; v < 64; v = v + 1) begin
                check_limit(n[1:0], v[5:0]);
            end
        end

        $display("tb_rgb_level_limit: OK");
        $finish;
    end

endmodule
