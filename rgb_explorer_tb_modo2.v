`timescale 1ns/1ps

module rgb_explorer_tb_modo2;

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

    // Clock 50 MHz (20ns período)
    parameter clockPeriod = 1_000_000; // in ns, f=1KHz
    always #((clockPeriod / 2)) clock = ~clock;

	task reset;
		begin
			@(negedge clock);
			btn_reset = 1;
			#(clockPeriod);
			btn_reset = 0;
			#(10*clockPeriod);
		end
	endtask

	task select_mode;
		begin
			@(negedge clock);
			btn_modo = 1;
			#(10*clockPeriod);
			btn_modo = 0;
			#(10*clockPeriod);
		end
	endtask

	task start;
		begin
			@(negedge clock);
			btn_jogar = 1;
			#(10*clockPeriod);
			btn_jogar = 0;
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

	task confirmmar;
		begin
			@(negedge clock);
			btn_confirma = 1;
			#(10*clockPeriod);
			btn_confirma = 0;
			#(10*clockPeriod);
		end
	endtask

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

    // Estímulos
    initial begin
        // Inicialização
		clock = 1;
        btn_reset = 0;
        btn_modo = 0;
        btn_jogar = 0;
        btn_confirma = 0;
        btns_plus_rgb = 3'b111;
        btns_minus_rgb = 3'b111;

		reset();

        // --- Selecionar modo ---
		select_mode();

        // --- Iniciar jogo ---
		start();

        // --- Simular jogada ---
        // Aumentar G e B
		jogada(6'b011_000);

        // Aumentar G
		jogada(6'b010_000);

		confirmmar();

		start();

		jogada(6'b010_000);

		confirmmar();

		$display("Fim da simulacao");
        $stop;
    end

endmodule
