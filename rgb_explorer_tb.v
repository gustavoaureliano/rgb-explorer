`timescale 1ns/1ps

module tb_rgb_explorer;

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
    wire [6:0] hex7seg_pontuacao;
    wire [6:0] hex7seg_modo;
    wire buzzer;

    // Instância do DUT (Device Under Test)
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
        .hex7seg_pontuacao(hex7seg_pontuacao),
        .hex7seg_modo(hex7seg_modo),
        .buzzer(buzzer)
    );

    // Clock 50 MHz (20ns período)
    initial begin
        clock = 0;
        forever #10 clock = ~clock;
    end

    // Estímulos
    initial begin
        // Inicialização
        btn_reset = 1;
        btn_modo = 0;
        btn_jogar = 0;
        btn_confirma = 0;
        btns_plus_rgb = 0;
        btns_minus_rgb = 0;

        #50;
        btn_reset = 0;

        // --- Selecionar modo ---
        #50;
        btn_modo = 1;
        #20;
        btn_modo = 0;

        #100;

        // --- Iniciar jogo ---
        btn_jogar = 1;
        #20;
        btn_jogar = 0;

        #100;

        // --- Simular jogada ---
        // Aumentar R
        btns_plus_rgb = 3'b100;
        #20;
        btns_plus_rgb = 0;

        #100;

        // Aumentar G
        btns_plus_rgb = 3'b010;
        #20;
        btns_plus_rgb = 0;

        #100;

        // Diminuir B
        btns_minus_rgb = 3'b001;
        #20;
        btns_minus_rgb = 0;

        #200;

        // Outra jogada
        btns_plus_rgb = 3'b111;
        #20;
        btns_plus_rgb = 0;

        #300;

        $stop;
    end

endmodule