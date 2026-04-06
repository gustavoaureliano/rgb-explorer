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
	output [2:0] leds_erro,
	output [6:0] hex7seg_pontuacao,
	output [6:0] hex7seg_modo,
	output [6:0] db_jogada_r,
	output [6:0] db_jogada_g,
	output [6:0] db_jogada_b,
	output [6:0] db_estado_lsb,
	output [6:0] db_estado_msb,
	output [3:0] intensidade_r,
	output [3:0] intensidade_g,
	output [3:0] intensidade_b,
	output [2:0] db_btns_plus_rgb,
	output [2:0] db_btns_minus_rgb,
	output       db_btn_modo,
	output       db_btn_confirma,
	output       db_btn_jogar,
	output       db_clock,
	output       buzzer
);
	wire zera_rgb_jogada, registra_jogada;
	wire zera_rgb_alvo, registra_rgb_alvo;
	wire zera_pontuacao, registra_pontuacao;
	wire zera_rnd;
	wire zera_nivel, conta_nivel;
	wire zera_modo, conta_modo;
	wire zera_timeout, conta_timeout;
	wire m4_ativo, registra_seq, zera_seq_len, conta_seq_len;
	wire zera_idx_show, conta_idx_show, zera_idx_input, conta_idx_input;
	wire zera_t_show, conta_t_show, zera_t_gap, conta_t_gap;
	wire mostra_seq, usa_alvo_seq;
	wire zera_erro_latch, registra_erro_latch;
	wire jogada_feita, pulso_modo, confirmar, pulso_jogar;
	wire timeout;
	wire ciclo_niveis_completo;
	wire atingiu_pontuacao_max;
	wire fim_t_show, fim_t_gap, fim_show_seq, fim_input_seq, seq_no_max;
	wire mudar_rgb;
	wire mostra_rgb_alvo;
	wire enable_cod_erro;
	wire [5:0] s_rgb_jogada;
	wire [5:0] db_rgb_alvo;
	wire [5:0] s_rgb_alvo;
	wire [5:0] m4_rgb_show;
	wire [5:0] s_rgb_alvo_vis;
	wire [5:0] s_rgb_jogada_pwm;
	wire [5:0] s_rgb_alvo_vis_pwm;
	wire [3:0] s_pontuacao;
	wire [3:0] modo_display;
	wire [2:0] s_modo;
	wire [1:0] nivel_atual;
	wire [7:0] s_estado;
	wire [3:0] erro;

	assign db_clock = clock;

	assign db_btns_plus_rgb = btns_plus_rgb;
	assign db_btns_minus_rgb = btns_minus_rgb;
	assign db_btn_modo = btn_modo;
	assign db_btn_confirma = btn_confirma;
	assign db_btn_jogar = btn_jogar;
	assign modo_display = {1'b0, s_modo} + 4'd1;

	assign s_rgb_alvo_vis = mostra_seq ? m4_rgb_show : (mostra_rgb_alvo ? s_rgb_alvo : 6'b0);

	unidade_controle uc (
		.clock(clock),
		.btn_reset(btn_reset),
		.pulso_modo(pulso_modo),
		.pulso_jogar(pulso_jogar),
		.jogada(jogada_feita),
		.confirmar(confirmar),
		.timeout(timeout),
		.s_modo(s_modo),
		.erro(erro),
		.fim_t_show(fim_t_show),
		.fim_t_gap(fim_t_gap),
		.fim_show_seq(fim_show_seq),
		.fim_input_seq(fim_input_seq),
		.seq_no_max(seq_no_max),
		.ciclo_niveis_completo(ciclo_niveis_completo),
		.atingiu_pontuacao_max(atingiu_pontuacao_max),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.zera_rnd(zera_rnd),
		.registra_jogada(registra_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.mudar_rgb(mudar_rgb),
		.conta_nivel(conta_nivel),
		.conta_modo(conta_modo),
		.zera_timeout(zera_timeout),
		.conta_timeout(conta_timeout),
		.mostra_rgb_alvo(mostra_rgb_alvo),
		.m4_ativo(m4_ativo),
		.registra_seq(registra_seq),
		.zera_seq_len(zera_seq_len),
		.conta_seq_len(conta_seq_len),
		.zera_idx_show(zera_idx_show),
		.conta_idx_show(conta_idx_show),
		.zera_idx_input(zera_idx_input),
		.conta_idx_input(conta_idx_input),
		.zera_t_show(zera_t_show),
		.conta_t_show(conta_t_show),
		.zera_t_gap(zera_t_gap),
		.conta_t_gap(conta_t_gap),
		.mostra_seq(mostra_seq),
		.usa_alvo_seq(usa_alvo_seq),
		.zera_erro_latch(zera_erro_latch),
		.registra_erro_latch(registra_erro_latch),
		.enable_cod_erro(enable_cod_erro),
		.db_estado(s_estado)
	);

	fluxo_dados fd (
		.clock(clock),
		.zera_rgb_jogada(zera_rgb_jogada),
		.zera_rgb_alvo(zera_rgb_alvo),
		.zera_pontuacao(zera_pontuacao),
		.zera_nivel(zera_nivel),
		.zera_modo(zera_modo),
		.zera_rnd(zera_rnd),
		.btns_plus_minus_rgb({btns_plus_rgb, btns_minus_rgb}),
		.btn_modo(btn_modo),
		.btn_confirma(btn_confirma),
		.btn_jogar(btn_jogar),
		.registra_jogada(registra_jogada),
		.registra_rgb_alvo(registra_rgb_alvo),
		.registra_pontuacao(registra_pontuacao),
		.mudar_rgb(mudar_rgb),
		.conta_nivel(conta_nivel),
		.conta_modo(conta_modo),
		.zera_timeout(zera_timeout),
		.conta_timeout(conta_timeout),
		.enable_cod_erro(enable_cod_erro),
		.m4_ativo(m4_ativo),
		.registra_seq(registra_seq),
		.zera_seq_len(zera_seq_len),
		.conta_seq_len(conta_seq_len),
		.zera_idx_show(zera_idx_show),
		.conta_idx_show(conta_idx_show),
		.zera_idx_input(zera_idx_input),
		.conta_idx_input(conta_idx_input),
		.zera_t_show(zera_t_show),
		.conta_t_show(conta_t_show),
		.zera_t_gap(zera_t_gap),
		.conta_t_gap(conta_t_gap),
		.usa_alvo_seq(usa_alvo_seq),
		.zera_erro_latch(zera_erro_latch),
		.registra_erro_latch(registra_erro_latch),
		.pulso_modo(pulso_modo),
		.pulso_jogar(pulso_jogar),
		.jogada_feita(jogada_feita),
		.confirmar(confirmar),
		.fim_t_show(fim_t_show),
		.fim_t_gap(fim_t_gap),
		.fim_show_seq(fim_show_seq),
		.fim_input_seq(fim_input_seq),
		.seq_no_max(seq_no_max),
		.m4_rgb_show(m4_rgb_show),
		.s_rgb_jogada(s_rgb_jogada),
		.s_rgb_alvo(s_rgb_alvo),
		.db_rgb_alvo(db_rgb_alvo),
		.s_pontuacao(s_pontuacao),
		.leds_nivel(leds_nivel),
		.leds_erro(leds_erro),
		.s_modo(s_modo),
		.nivel_atual(nivel_atual),
		.ciclo_niveis_completo(ciclo_niveis_completo),
		.atingiu_pontuacao_max(atingiu_pontuacao_max),
		.timeout(timeout),
		.erro(erro)
	);

	rgb_level_scale escala_jogada_pwm (
		.nivel(nivel_atual),
		.rgb_in(s_rgb_jogada),
		.rgb_out(s_rgb_jogada_pwm)
	);

	rgb_level_scale escala_alvo_pwm (
		.nivel(nivel_atual),
		.rgb_in(s_rgb_alvo_vis),
		.rgb_out(s_rgb_alvo_vis_pwm)
	);

	rgb_cod cod_rgb_jogada (
		.clk(clock),
		.jogada(s_rgb_jogada_pwm),
		.display(rgb_jogada)
	);

	rgb_cod cod_rgb_alvo (
		.clk(clock),
		.jogada(s_rgb_alvo_vis_pwm),
		.display(rgb_alvo)
	);

	rgb_intensity_bar intensidade_jogada (
		.rgb_in(s_rgb_jogada),
		.intensidade_r(intensidade_r),
		.intensidade_g(intensidade_g),
		.intensidade_b(intensidade_b)
	);

	hexa7seg display_jogada_r (
		.hexa({2'b0, db_rgb_alvo[5:4]}),
		.display(db_jogada_r)
	);

	hexa7seg display_jogada_g (
		.hexa({2'b0, db_rgb_alvo[3:2]}),
		.display(db_jogada_g)
	);

	hexa7seg display_jogada_b (
		.hexa({2'b0, db_rgb_alvo[1:0]}),
		.display(db_jogada_b)
	);

	hexa7seg display_modo (
		.hexa(modo_display),
		.display(hex7seg_modo)
	);

	hexa7seg display_pontuacao (
		.hexa(s_pontuacao),
		.display(hex7seg_pontuacao)
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
