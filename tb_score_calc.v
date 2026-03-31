`timescale 1ns/1ps

module tb_score_calc;
    reg clock;
    reg [3:0] erro;
    wire [3:0] pontos;

    score_calc dut (
        .clock(clock),
        .erro(erro),
        .pontos(pontos)
    );

    initial clock = 1'b0;
    always #5 clock = ~clock;

    task check_score;
        input [3:0] erro_in;
        input [3:0] expected;
        begin
            erro = erro_in;
            @(posedge clock);
            #1;

            if (pontos !== expected) begin
                $display("ERRO: erro=%0d esperado=%0d obtido=%0d", erro_in, expected, pontos);
                $finish;
            end
        end
    endtask

    integer i;
    reg [3:0] exp;

    initial begin
        erro = 4'd0;
        @(posedge clock);

        for (i = 0; i < 16; i = i + 1) begin
            if (i == 0)
                exp = 4'd4;
            else if (i < 3)
                exp = 4'd2;
            else
                exp = 4'd0;

            check_score(i[3:0], exp);
        end

        $display("tb_score_calc: OK");
        $finish;
    end

endmodule
