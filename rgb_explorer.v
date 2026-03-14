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
	output       buzzer
);
	wire zera_rgb_jogada;
	wire [2:0] add_rgb_jogada, sub_rgb_jogada;
	wire zera_rgb_alvo, registra_rgb_alvo;
	wire zera_pontuacao, registra_pontuacao;
	wire zera_nivel, conta_nivel;
	wire zera_modo, conta_modo;

	wire [2:0] s_modo;

	unidade_controle uc (
		.clock(clock),
		.btn_reset(btn_reset),
		.jogar(jogar),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.add_rgb_jogada(add_rgb_jogada),
		.sub_rgb_jogada(sub_rgb_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.conta_nivel(conta_nivel),
		.conta_modo(conta_modo)
	);

	fluxo_dados fd (
		.clock(clock),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.add_rgb_jogada(add_rgb_jogada),
		.sub_rgb_jogada(sub_rgb_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.conta_nivel(conta_nivel),
		.conta_modo(conta_modo)
	);

	hexa7seg display_modo (
		.hexa({1'b0, s_modo}),
		.display(hex7seg_modo)
	);
endmodule
