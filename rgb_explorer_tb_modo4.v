`timescale 1ns/1ps

module rgb_explorer_tb_modo4;

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

    parameter clockPeriod = 1_000_000; // 1 KHz
    parameter integer WAIT_LIMIT = 7000;
    integer len;
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
            btn_reset = 1'b1;
            #(2*clockPeriod);
            btn_reset = 1'b0;
            #(8*clockPeriod);
        end
    endtask

    task press_modo;
        begin
            btn_modo = 1'b0;
            #(10*clockPeriod);
            btn_modo = 1'b1;
            #(10*clockPeriod);
        end
    endtask

    task press_jogar;
        begin
            btn_jogar = 1'b0;
            #(10*clockPeriod);
            btn_jogar = 1'b1;
            #(10*clockPeriod);
        end
    endtask

    task press_confirma;
        begin
            btn_confirma = 1'b0;
            #(10*clockPeriod);
            btn_confirma = 1'b1;
            #(10*clockPeriod);
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

    initial begin
        clock = 1'b1;
        btn_reset = 1'b0;
        btn_modo = 1'b1;
        btn_jogar = 1'b1;
        btn_confirma = 1'b1;
        btns_plus_rgb = 3'b111;
        btns_minus_rgb = 3'b111;

        reset_dut();

        // Seleciona modo 4 (codigo 3)
        press_modo();
        press_modo();
        press_modo();
        if (dut.s_modo !== 3'd3)
            $fatal(1, "Modo 4 nao selecionado: s_modo=%0d", dut.s_modo);

        // Inicia modo 4
        press_jogar();

        // Espera fase de entrada da sequencia
        wait_state(8'h12); // m4_wait_input

        // Forca comparacao com erro alto para validar caminho de falha
        force dut.fd.seq_mode4.seq_mem[0] = 6'b000000;
        force dut.s_rgb_jogada = 6'b111111;
        press_confirma();
        release dut.s_rgb_jogada;
        release dut.fd.seq_mode4.seq_mem[0];

        wait_state(8'h18); // m4_round_fail

        // Cenário de vitória final (MAX_SEQ_LEN=3)
        // Acelera exibição da sequência e força acertos.
        force dut.fim_t_show = 1'b1;
        force dut.fim_t_gap = 1'b1;
        force dut.erro = 4'd0;

        press_jogar();

        for (len = 1; len <= 3; len = len + 1) begin
            wait_state(8'h12); // m4_wait_input

            // Confirma cada passo da sequência na rodada atual
            repeat (len-1) begin
                press_confirma();
                wait_state(8'h12);
            end

            press_confirma();

            if (len < 3) begin
                wait_state(8'h16); // m4_round_ok
                press_jogar();
            end else begin
                wait_state(8'h19); // m4_vitoria_final
            end
        end

        release dut.erro;
        release dut.fim_t_show;
        release dut.fim_t_gap;

        // Reinicia após vitória final
        press_jogar();
        wait_state(8'hF); // m4_show_step

        $display("tb_modo4: OK");
        $finish;
    end

endmodule
