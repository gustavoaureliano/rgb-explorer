`timescale 1ns/1ps

module rgb_explorer_tb_fim_partida;

    reg clock;
    reg btn_reset;
    reg btn_modo;
    reg btn_jogar;
    reg btn_confirma;
    reg [2:0] btns_plus_rgb;
    reg [2:0] btns_minus_rgb;

    wire [2:0] rgb_alvo;
    wire [2:0] rgb_jogada;
    wire [2:0] leds_nivel;
    wire [2:0] leds_erro;
    wire [6:0] hex7seg_pontuacao;
    wire [6:0] hex7seg_modo;
    wire [6:0] db_jogada_r;
    wire [6:0] db_jogada_g;
    wire [6:0] db_jogada_b;
    wire [6:0] db_estado_lsb;
    wire [6:0] db_estado_msb;
    wire [3:0] intensidade_r;
    wire [3:0] intensidade_g;
    wire [3:0] intensidade_b;
    wire [2:0] db_btns_plus_rgb;
    wire [2:0] db_btns_minus_rgb;
    wire db_btn_modo;
    wire db_btn_confirma;
    wire db_btn_jogar;
    wire db_clock;
    wire buzzer;

    parameter clockPeriod = 20; // 50 MHz -> 20 ns
    parameter integer WAIT_LIMIT = 300;
    parameter integer PRESS_CYCLES = 100;
    parameter integer RESET_SETTLE_CYCLES = 200;

    localparam [7:0] ST_FIM_EXATO = 8'h9;
    localparam [7:0] ST_FIM_PERTO = 8'hA;
    localparam [7:0] ST_FIM_LONGE = 8'hB;
    localparam [7:0] ST_FIM_PARTIDA = 8'h1A;

    integer i;
    reg [3:0] pontuacao_final;

    always #((clockPeriod / 2)) clock = ~clock;

    rgb_explorer dut (
        .clock(clock),
        .btn_reset(btn_reset),
        .btn_modo(btn_modo),
        .btn_jogar(btn_jogar),
        .btn_confirma(btn_confirma),
        .btns_plus_rgb(btns_plus_rgb),
        .btns_minus_rgb(btns_minus_rgb),
        .rgb_alvo(rgb_alvo),
        .rgb_jogada(rgb_jogada),
        .leds_nivel(leds_nivel),
        .leds_erro(leds_erro),
        .hex7seg_pontuacao(hex7seg_pontuacao),
        .hex7seg_modo(hex7seg_modo),
        .db_jogada_r(db_jogada_r),
        .db_jogada_g(db_jogada_g),
        .db_jogada_b(db_jogada_b),
        .db_estado_lsb(db_estado_lsb),
        .db_estado_msb(db_estado_msb),
        .intensidade_r(intensidade_r),
        .intensidade_g(intensidade_g),
        .intensidade_b(intensidade_b),
        .db_btns_plus_rgb(db_btns_plus_rgb),
        .db_btns_minus_rgb(db_btns_minus_rgb),
        .db_btn_modo(db_btn_modo),
        .db_btn_confirma(db_btn_confirma),
        .db_btn_jogar(db_btn_jogar),
        .db_clock(db_clock),
        .buzzer(buzzer)
    );

    task reset_dut;
        begin
            @(negedge clock);
            btn_reset = 1'b0;
            #(PRESS_CYCLES*clockPeriod);
            btn_reset = 1'b1;
            #(RESET_SETTLE_CYCLES*clockPeriod);
        end
    endtask

    task press_modo;
        begin
            btn_modo = 1'b0;
            #(PRESS_CYCLES*clockPeriod);
            btn_modo = 1'b1;
            #(PRESS_CYCLES*clockPeriod);
        end
    endtask

    task press_jogar;
        begin
            btn_jogar = 1'b0;
            #(PRESS_CYCLES*clockPeriod);
            btn_jogar = 1'b1;
            #(PRESS_CYCLES*clockPeriod);
        end
    endtask

    task press_confirma;
        begin
            btn_confirma = 1'b0;
            #(PRESS_CYCLES*clockPeriod);
            btn_confirma = 1'b1;
            #(PRESS_CYCLES*clockPeriod);
        end
    endtask

    task wait_mode23_result;
        integer k;
        begin
            k = 0;
            while (!(dut.s_estado == ST_FIM_EXATO || dut.s_estado == ST_FIM_PERTO || dut.s_estado == ST_FIM_LONGE) && k < WAIT_LIMIT) begin
                @(posedge clock);
                k = k + 1;
            end

            if (!(dut.s_estado == ST_FIM_EXATO || dut.s_estado == ST_FIM_PERTO || dut.s_estado == ST_FIM_LONGE))
                $fatal(1, "Timeout esperando fim de rodada modo2/3, estado atual=%h", dut.s_estado);
        end
    endtask

    task wait_state;
        input [7:0] st;
        integer k;
        begin
            k = 0;
            while (dut.s_estado !== st && k < WAIT_LIMIT) begin
                @(posedge clock);
                k = k + 1;
            end

            if (dut.s_estado !== st)
                $fatal(1, "Timeout esperando estado %h, estado atual=%h", st, dut.s_estado);
        end
    endtask

    task select_mode;
        input [2:0] alvo;
        integer tries;
        begin
            tries = 0;
            while (dut.s_modo !== alvo && tries < 12) begin
                press_modo();
                repeat (50) @(posedge clock);
                tries = tries + 1;
            end

            if (dut.s_modo !== alvo)
                $fatal(1, "Falha ao selecionar modo alvo=%0d, s_modo=%0d", alvo, dut.s_modo);
        end
    endtask

    initial begin
        clock = 1'b1;
        btn_reset = 1'b1;
        btn_modo = 1'b1;
        btn_jogar = 1'b1;
        btn_confirma = 1'b1;
        btns_plus_rgb = 3'b111;
        btns_minus_rgb = 3'b111;

        // Cenario A: encerra automaticamente ao atingir 15 pontos
        reset_dut();
        select_mode(3'd1);

        press_jogar();
        force dut.erro = 4'd0; // 2 pontos por rodada

        for (i = 0; i < 7; i = i + 1) begin
            press_confirma();
            wait_mode23_result();
            press_jogar();
        end

        if (dut.s_pontuacao !== 4'd14)
            $fatal(1, "Pontuacao esperada=14 antes do teto, observada=%0d", dut.s_pontuacao);

        press_confirma();
        wait_state(ST_FIM_PARTIDA);

        if (dut.s_pontuacao !== 4'hF)
            $fatal(1, "Pontuacao deveria saturar em 15, observada=%0d", dut.s_pontuacao);

        pontuacao_final = dut.s_pontuacao;
        repeat (5) @(posedge clock);
        if (dut.s_pontuacao !== pontuacao_final)
            $fatal(1, "Pontuacao nao ficou estavel em fim_partida: esperado=%0d observado=%0d", pontuacao_final, dut.s_pontuacao);

        press_jogar();
        repeat (5) @(posedge clock);

        if (dut.s_pontuacao !== 4'd0)
            $fatal(1, "Pontuacao nao zerou apos reinicio no cenario A: %0d", dut.s_pontuacao);

        if (dut.fd.nivel !== 2'd0)
            $fatal(1, "Nivel nao voltou para facil apos reinicio no cenario A: %0d", dut.fd.nivel);

        release dut.erro;

        // Cenario B: encerra no ciclo de niveis (dificil -> facil) sem atingir teto
        reset_dut();
        select_mode(3'd1);

        press_jogar();
        force dut.erro = 4'd3; // 0 ponto por rodada

        for (i = 0; i < 8; i = i + 1) begin
            press_confirma();
            wait_mode23_result();
            press_jogar();
        end

        press_confirma();
        wait_state(ST_FIM_PARTIDA);

        if (dut.s_pontuacao !== 4'd0)
            $fatal(1, "Pontuacao deveria permanecer 0 no cenario B, observada=%0d", dut.s_pontuacao);

        release dut.erro;

        $display("tb_fim_partida: OK (score cap + ciclo de niveis)");
        $finish;
    end

endmodule
