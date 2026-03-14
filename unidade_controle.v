module unidade_controle (
	input        clock,
	input        btn_reset,
	input        jogar,
	output       zera_rgb_jogada,
	output       zera_rgb_alvo,
	output       zera_pontuacao,
	output       zera_nivel,
	output       zera_modo,
	output [2:0] add_rgb_jogada,
	output [2:0] sub_rgb_jogada,
	output       registra_rgb_alvo,
	output       registra_pontuacao,
	output       conta_nivel,
	output       conta_modo
);
endmodule
