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
    parameter clockPeriod = 1_000_000; // in ns, f=1KHz
    always #((clockPeriod / 2)) clock = ~clock;

    // Estímulos
    initial begin
        // Inicialização
		clock = 1;
        btn_reset = 0;
        btn_modo = 0;
        btn_jogar = 0;
        btn_confirma = 0;
        btns_plus_rgb = 3'b000;
        btns_minus_rgb = 3'b000;

        #50;
		@(negedge clock);
        btn_reset = 1;
		#(clockPeriod);
		btn_reset = 0;
		#(10*clockPeriod);

        // --- Selecionar modo ---
		@(negedge clock);
        btn_modo = 1;
		#(10*clockPeriod);
        btn_modo = 0;
		#(10*clockPeriod);

		@(negedge clock);
        btn_modo = 1;
		#(10*clockPeriod);
        btn_modo = 0;
		#(10*clockPeriod);

		@(negedge clock);
        btn_modo = 1;
		#(10*clockPeriod);
        btn_modo = 0;
		#(10*clockPeriod);

		@(negedge clock);
        btn_modo = 1;
		#(10*clockPeriod);
        btn_modo = 0;
		#(10*clockPeriod);

        // --- Iniciar jogo ---
		@(negedge clock);
        btn_jogar = 1;
		#(10*clockPeriod);
        btn_jogar = 0;
		#(10*clockPeriod);


        // --- Simular jogada ---
        // Aumentar R
        btns_plus_rgb = 3'b100;
		#(10*clockPeriod);
        btns_plus_rgb = 3'b000;
		#(10*clockPeriod);

        // Aumentar G
        btns_plus_rgb = 3'b010;
		#(10*clockPeriod);
        btns_plus_rgb = 3'b000;
		#(10*clockPeriod);

        // Diminuir B
        btns_minus_rgb = 3'b010;
		#(10*clockPeriod);
        btns_minus_rgb = 3'b000;
		#(10*clockPeriod);

        // jogada inválida
        btns_plus_rgb = 3'b111;
		#(10*clockPeriod);
        btns_plus_rgb = 3'b000;
		#(10*clockPeriod);
		$display("Fim da simulacao");
        $stop;
    end

endmodule
