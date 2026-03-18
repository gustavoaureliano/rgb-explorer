module rgb_explorer (
	input        clock,
	input        btn_reset,
	input        btn_modo,
	input        btn_jogar,
	input        btn_confirma,
	input  [2:0] btns_plus_rgb,
	input  [2:0] btns_minus_rgb,
	output [2:0] rgb_alvo,
	output [2:0] rgb_jogada,
	output [2:0] leds_nivel,
	output [6:0] hex7seg_pontuacao,
	output [6:0] hex7seg_modo,
	output [6:0] db_jogada_r,
	output [6:0] db_jogada_g,
	output [6:0] db_jogada_b,
	output [6:0] db_estado_lsb,
	output [6:0] db_estado_msb,
	output       db_clock,
	output       buzzer
);
	wire zera_rgb_jogada, registra_jogada;
	wire zera_rgb_alvo, registra_rgb_alvo;
	wire zera_pontuacao, registra_pontuacao;
	wire zera_nivel, conta_nivel;
	wire zera_modo, conta_modo;
	wire jogada_feita, pulso_modo;
	wire mudar_rgb;
	wire [5:0] s_rgb_jogada;
	wire [5:0] s_rgb_alvo;
	wire [2:0] s_modo;
	wire [7:0] s_estado;

	assign db_clock = clock;

	unidade_controle uc (
		.clock(clock),
		.btn_reset(btn_reset),
		.pulso_modo(pulso_modo),
		.btn_jogar(btn_jogar),
		.jogada(jogada_feita),
		.s_modo(s_modo),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.registra_jogada(registra_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.mudar_rgb(mudar_rgb),
		.conta_nivel(conta_nivel),
		.conta_modo(conta_modo),
		.db_estado(s_estado)
	);

	fluxo_dados fd (
		.clock(clock),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.btns_plus_minus_rgb({btns_plus_rgb, btns_minus_rgb}),
		.btn_modo(btn_modo),
		.registra_jogada(registra_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.mudar_rgb(mudar_rgb),
		.conta_nivel(conta_nivel),
		.conta_modo(conta_modo),
		.pulso_modo(pulso_modo),
		.jogada_feita(jogada_feita),
		.s_rgb_jogada(s_rgb_jogada),
		.s_rgb_alvo(s_rgb_alvo),
		.leds_nivel(leds_nivel),
		.s_modo(s_modo)
	);

	rgb_cod cod_rgb_jogada (
		.clk(clock),
		.jogada(s_rgb_jogada),
		.display(rgb_jogada)
	);

	rgb_cod cod_rgb_alvo (
		.clk(clock),
		.jogada(s_rgb_alvo),
		.display(rgb_alvo)
	);

	hexa7seg display_jogada_r (
		.hexa({2'b0, s_rgb_jogada[5:4]}),
		.display(db_jogada_r)
	);

	hexa7seg display_jogada_g (
		.hexa({2'b0, s_rgb_jogada[3:2]}),
		.display(db_jogada_g)
	);

	hexa7seg display_jogada_b (
		.hexa({2'b0, s_rgb_jogada[1:0]}),
		.display(db_jogada_b)
	);

	hexa7seg display_modo (
		.hexa({1'b0, s_modo}),
		.display(hex7seg_modo)
	);

	hexa7seg display_estado_msb (
		.hexa(s_estado[7:4]),
		.display(db_estado_msb)
	);

	hexa7seg display_estado_lsb (
		.hexa(s_estado[3:0]),
		.display(db_estado_lsb)
	);
endmodule
