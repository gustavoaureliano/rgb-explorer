`timescale 1ns/1ps

module tb_rgb_explorer_level;

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
    wire [2:0] db_btns_plus_rgb;
    wire [2:0] db_btns_minus_rgb;
    wire db_btn_modo;
    wire db_btn_confirma;
    wire db_btn_jogar;
    wire db_clock;
    wire buzzer;

    parameter clockPeriod = 1_000_000; // 1 KHz -> 1 ms
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

    task press_modo_stable;
        begin
            btn_modo = 1'b0;
            #(10*clockPeriod);
            btn_modo = 1'b1;
            #(10*clockPeriod);
        end
    endtask

    task press_jogar_stable;
        begin
            btn_jogar = 1'b0;
            #(10*clockPeriod);
            btn_jogar = 1'b1;
            #(10*clockPeriod);
        end
    endtask

    task press_confirma_stable;
        begin
            btn_confirma = 1'b0;
            #(10*clockPeriod);
            btn_confirma = 1'b1;
            #(10*clockPeriod);
        end
    endtask

    task press_plus_r_stable;
        begin
            btns_plus_rgb = 3'b011; // +R (ativo em 0)
            btns_minus_rgb = 3'b111;
            #(10*clockPeriod);
            btns_plus_rgb = 3'b111;
            btns_minus_rgb = 3'b111;
            #(10*clockPeriod);
        end
    endtask

    task assert_level(input [1:0] expected);
        begin
            if (dut.fd.nivel !== expected)
                $fatal(1, "Nivel incorreto: esperado=%0d observado=%0d", expected, dut.fd.nivel);
        end
    endtask

    task assert_jogada_bounds;
        reg [1:0] max_ch;
        begin
            case (dut.fd.nivel)
                2'd0: max_ch = 2'd1;
                2'd1: max_ch = 2'd2;
                default: max_ch = 2'd3;
            endcase

            if (dut.s_rgb_jogada[5:4] > max_ch || dut.s_rgb_jogada[3:2] > max_ch || dut.s_rgb_jogada[1:0] > max_ch)
                $fatal(1, "RGB jogada fora do nivel: nivel=%0d jogada=%b max=%0d", dut.fd.nivel, dut.s_rgb_jogada, max_ch);
        end
    endtask

    task assert_alvo_bounds;
        reg [1:0] max_ch;
        begin
            case (dut.fd.nivel)
                2'd0: max_ch = 2'd1;
                2'd1: max_ch = 2'd2;
                default: max_ch = 2'd3;
            endcase

            if (dut.s_rgb_alvo[5:4] > max_ch || dut.s_rgb_alvo[3:2] > max_ch || dut.s_rgb_alvo[1:0] > max_ch)
                $fatal(1, "RGB alvo fora do nivel: nivel=%0d alvo=%b max=%0d", dut.fd.nivel, dut.s_rgb_alvo, max_ch);
        end
    endtask

    task complete_one_play;
        begin
            press_confirma_stable();
            #(6*clockPeriod);
            press_jogar_stable();
            #(6*clockPeriod);
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

        // Bounce curto no modo: nao deve registrar troca
        btn_modo = 1'b0; #(clockPeriod);
        btn_modo = 1'b1; #(clockPeriod);
        btn_modo = 1'b0; #(clockPeriod);
        btn_modo = 1'b1; #(6*clockPeriod);
        if (dut.s_modo !== 3'd0)
            $fatal(1, "Debounce falhou no btn_modo curto: s_modo=%0d", dut.s_modo);

        // Troca valida para modo 2 (s_modo=1)
        press_modo_stable();
        if (dut.s_modo !== 3'd1)
            $fatal(1, "Falha ao selecionar modo 2: s_modo=%0d", dut.s_modo);

        // Inicia modo 2
        press_jogar_stable();
        #(8*clockPeriod);

        // Nivel facil e limites de alvo/jogada
        assert_level(2'd0);
        assert_alvo_bounds();

        press_plus_r_stable();
        press_plus_r_stable();
        press_plus_r_stable();
        assert_jogada_bounds();

        // 3 jogadas completas -> nivel normal
        complete_one_play();
        assert_level(2'd0);
        complete_one_play();
        assert_level(2'd0);
        complete_one_play();
        assert_level(2'd1);
        assert_alvo_bounds();

        // No nivel normal, jogada deve limitar em 0..2
        press_plus_r_stable();
        press_plus_r_stable();
        press_plus_r_stable();
        press_plus_r_stable();
        assert_jogada_bounds();

        // Mais 3 jogadas -> nivel dificil
        complete_one_play();
        complete_one_play();
        complete_one_play();
        assert_level(2'd2);
        assert_alvo_bounds();

        // Mais 3 jogadas -> volta para facil
        complete_one_play();
        complete_one_play();
        complete_one_play();
        assert_level(2'd0);
        assert_alvo_bounds();

        $display("TB nivel/debounce concluido com sucesso.");
        $finish;
    end

endmodule
