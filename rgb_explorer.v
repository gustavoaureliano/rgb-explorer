module rgb_explorer (
	input clock,
	input btn_reset,
	input btn_modo,
	input btn_jogar,
	input btn_confirma,
	input  [2:0] btns_plus_rgb,
	input  [2:0] btns_minus_rgb,
	output [2:0] rgb_alvo,
	output [2:0] rgb_jogada,
	output [2:0] leds_nivel,
	output [6:0] hex7seg_pontuacao,
	output [6:0] hex7seg_modo,
	output       buzzer
);
	wire zera_rgb_jogada, registra_rgb_jogada;
	wire zera_rgb_alvo, registra_rgb_alvo;
	wire zera_pontuacao, registra_pontuacao;
	wire zera_nivel, registra_nivel;
	wire zera_modo, registra_modo;

	unidade_controle fd (
		.clock(clock),
		.btn_reset(btn_reset),
		.jogar(jogar),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.registra_rgb_jogada(registra_rgb_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.registra_nivel(registra_nivel),
		.registra_modo(registra_modo),
	);

	fluxo_dados fd (
		.clock(clock),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.registra_rgb_jogada(registra_rgb_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.registra_nivel(registra_nivel),
		.registra_modo(registra_modo),
	);
endmodule
