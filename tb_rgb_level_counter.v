`timescale 1ns/1ps

module tb_rgb_level_counter;
    reg clock;
    reg zera_as;
    reg conta;
    reg neg;
    reg [1:0] max_val;
    wire [1:0] Q;

    rgb_level_counter dut (
        .clock(clock),
        .zera_as(zera_as),
        .conta(conta),
        .neg(neg),
        .max_val(max_val),
        .Q(Q)
    );

    initial clock = 1'b0;
    always #5 clock = ~clock;

    task do_reset;
        begin
            zera_as = 1'b1;
            #1;
            zera_as = 1'b0;
            @(posedge clock);
            #1;
            if (Q !== 2'd0) begin
                $display("ERRO: reset esperado Q=0 obtido=%0d", Q);
                $finish;
            end
        end
    endtask

    task step_up;
        begin
            neg = 1'b0;
            conta = 1'b1;
            @(posedge clock);
            #1;
            conta = 1'b0;
        end
    endtask

    task step_down;
        begin
            neg = 1'b1;
            conta = 1'b1;
            @(posedge clock);
            #1;
            conta = 1'b0;
        end
    endtask

    task expect_q;
        input [1:0] expected;
        begin
            if (Q !== expected) begin
                $display("ERRO: esperado Q=%0d obtido=%0d", expected, Q);
                $finish;
            end
        end
    endtask

    initial begin
        zera_as = 1'b0;
        conta = 1'b0;
        neg = 1'b0;
        max_val = 2'd1;

        do_reset();

        // max=1: 0->1->0
        step_up(); expect_q(2'd1);
        step_up(); expect_q(2'd0);
        step_down(); expect_q(2'd1);

        // max=2: 1->2->0->1
        max_val = 2'd2;
        step_up(); expect_q(2'd2);
        step_up(); expect_q(2'd0);
        step_up(); expect_q(2'd1);
        step_down(); expect_q(2'd0);
        step_down(); expect_q(2'd2);

        // max=3: full modulo-4 behavior
        max_val = 2'd3;
        do_reset();
        step_up(); expect_q(2'd1);
        step_up(); expect_q(2'd2);
        step_up(); expect_q(2'd3);
        step_up(); expect_q(2'd0);
        step_down(); expect_q(2'd3);

        $display("tb_rgb_level_counter: OK");
        $finish;
    end

endmodule
