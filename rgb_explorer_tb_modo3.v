`timescale 1ns/1ps

module rgb_explorer_tb_modo3;

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
            #(2*clockPeriod);
            btn_reset = 1'b1;
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

    task jogada(input reg [5:0] btns_plus_minus_rgb);
        begin
            btns_plus_rgb = ~btns_plus_minus_rgb[5:3];
            btns_minus_rgb = ~btns_plus_minus_rgb[2:0];
            #(10*clockPeriod);
            btns_plus_rgb = 3'b111;
            btns_minus_rgb = 3'b111;
            #(10*clockPeriod);
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

        reset_dut();

        // Seleciona modo 3 (codigo 2)
        press_modo();
        press_modo();
        repeat (500) @(posedge clock);
        if (dut.s_modo !== 3'd2)
            $fatal(1, "Modo 3 nao selecionado: s_modo=%0d", dut.s_modo);

        // Inicia rodada em modo 3
        press_jogar();

        // Deve entrar em espera_timeout e mostrar alvo
        #(15*clockPeriod);
        if (dut.s_estado !== 8'hC)
            $fatal(1, "Estado esperado espera_timeout (0xC), obtido=%h", dut.s_estado);

        if (dut.mostra_rgb_alvo !== 1'b1)
            $fatal(1, "mostra_rgb_alvo deve estar ativo durante timeout");

        if (dut.s_rgb_alvo_vis !== dut.s_rgb_alvo)
            $fatal(1, "s_rgb_alvo_vis deve refletir s_rgb_alvo durante timeout");

        // Aguarda timeout no perfil SIM_FAST (5000 ciclos)
        repeat (5010) @(posedge clock);
        #(2*clockPeriod);

        if (dut.s_estado !== 8'h3)
            $fatal(1, "Apos timeout, estado esperado espera_btn (0x3), obtido=%h", dut.s_estado);

        if (dut.mostra_rgb_alvo !== 1'b0)
            $fatal(1, "mostra_rgb_alvo deve estar inativo apos timeout em modo 3");

        if (dut.s_rgb_alvo_vis !== 6'b0)
            $fatal(1, "s_rgb_alvo_vis deve ser zero apos timeout em modo 3");

        // Jogada real: R=01, G=00 e B=01
        jogada(6'b101_000);
        #(5*clockPeriod);

        if (dut.s_rgb_jogada !== 6'b010001)
            $fatal(1, "Jogada esperada R=01 G=00 B=01 (010001), obtido=%b", dut.s_rgb_jogada);

        // Fluxo pos-timeout deve seguir igual ao modo 2
        press_confirma();
        #(5*clockPeriod);

        if (!(dut.s_estado == 8'h9 || dut.s_estado == 8'hA || dut.s_estado == 8'hB ||
              dut.s_estado == 8'h7 || dut.s_estado == 8'hC || dut.s_estado == 8'h3))
            $fatal(1, "Apos confirmar, estado esperado em fim/auto-proxima rodada (9/A/B/7/C/3), obtido=%h", dut.s_estado);

        $display("tb_modo3: OK");
        $stop;
    end

endmodule
