module fluxo_dados (
	input        clock,
	input        zera_rgb_jogada,
	input        zera_rgb_alvo,
	input        zera_pontuacao,
	input        zera_nivel,
	input        zera_modo,
	input        zera_rnd,
	input  [5:0] btns_plus_minus_rgb,
	input        btn_modo,
	input        btn_confirma,
	input        btn_jogar,
	input        registra_jogada,
	input        registra_rgb_alvo,
	input        registra_pontuacao,
	input        mudar_rgb,
	input        conta_nivel,
	input        conta_modo,
	input        zera_timeout,
	input        conta_timeout,
	input        enable_cod_erro,
	input        m4_ativo,
	input        registra_seq,
	input        zera_seq_len,
	input        conta_seq_len,
	input        zera_idx_show,
	input        conta_idx_show,
	input        zera_idx_input,
	input        conta_idx_input,
	input        zera_t_show,
	input        conta_t_show,
	input        zera_t_gap,
	input        conta_t_gap,
	input        usa_alvo_seq,
	output       pulso_modo,
	output       pulso_jogar,
	output       jogada_feita,
	output       confirmar,
	output       fim_t_show,
	output       fim_t_gap,
	output       fim_show_seq,
	output       fim_input_seq,
	output       seq_no_max,
	output [5:0] m4_rgb_show,
	output [5:0] s_rgb_alvo,
	output [5:0] s_rgb_jogada,
	output [3:0] s_pontuacao,
	output [2:0] leds_nivel,
	output [2:0] leds_erro,
	output [2:0] s_modo,
	output [1:0] nivel_atual,
	output       timeout,
	output [3:0] erro,
	output [5:0] db_rgb_alvo
);
	localparam RGB_LEDS_MODULUS = 4;
	localparam RGB_NUM_BITS = $clog2(RGB_LEDS_MODULUS);
	localparam DEBOUNCE_INTERVAL = 4; // 1 KHz -> 4 ms
	// localparam DEBOUNCE_INTERVAL = 200000; // 50 MHz -> 4 ms
	localparam TIMEOUT_CYCLES = 5000; // 1 KHz -> 5 s
	// localparam TIMEOUT_CYCLES = 250000000; // 50 MHz -> 5 s
	localparam MODE_MODULUS = 4;
	localparam MODE_COUNTER_NUM_BITS = 3;
	localparam RGB_REG_NUM_BITS = RGB_NUM_BITS*3;
	localparam JOGADA_BITS = 6;
	localparam PONTUACAO_NUM_BITS = 4;
	localparam IDX_R = 2;
	localparam IDX_G = 1;
	localparam IDX_B = 0;
	localparam [1:0] NIVEL_FACIL = 2'd0;
	localparam [1:0] NIVEL_NORMAL = 2'd1;
	localparam [1:0] MAX_RGB_FACIL = 2'd1;
	localparam [1:0] MAX_RGB_NORMAL = 2'd2;
	localparam [1:0] MAX_RGB_DIFICIL = 2'd3;
	localparam [2:0] MODO_LIVRE = 3'd0;

	localparam SHOW_CYCLES = 2000; // 1 KHz -> 2 s
	// localparam SHOW_CYCLES = 100000000; // 50 MHz -> 2 s
	localparam GAP_CYCLES = 500; // 1 KHz -> 500 ms
	// localparam GAP_CYCLES = 25000000; // 50 MHz -> 500 ms

	wire [RGB_NUM_BITS-1:0] q_led_r, q_led_g, q_led_b;

	wire [RGB_REG_NUM_BITS-1:0] random;
	wire [RGB_REG_NUM_BITS-1:0] random_limitado;
	wire [RGB_REG_NUM_BITS-1:0] random_limitado_nonzero;
	wire [RGB_REG_NUM_BITS-1:0] random_nonzero;
	wire [RGB_REG_NUM_BITS-1:0] alvo_comp;
	wire [5:0] db_btns_plus_minus_rgb;
	wire db_btn_modo, db_btn_confirma, db_btn_jogar;
	wire [1:0] max_rgb;
	wire [1:0] nivel_efetivo;
	wire modo_fim, modo_meio;

	wire [5:0] seq_show_word;
	wire [5:0] seq_input_word;

	assign s_rgb_jogada = {q_led_r, q_led_g, q_led_b};

	wire [5:0] s_jogada;
	wire [2:0] add_rgb_jogada;
	wire [2:0] sub_rgb_jogada;
	assign add_rgb_jogada = s_jogada[5:3];
	assign sub_rgb_jogada = s_jogada[2:0];

	wire sinal_btn_rgb, rst_detect_rgb;

	assign sinal_btn_rgb = ~&db_btns_plus_minus_rgb;
	assign rst_detect_rgb = &db_btns_plus_minus_rgb;

	wire sinal_btn_modo, rst_detect_modo;

	assign sinal_btn_modo = ~db_btn_modo;
	assign rst_detect_modo = db_btn_modo;

	wire sinal_confirmar, rst_detect_confirmar;
	wire [1:0] nivel;

	assign sinal_confirmar = ~db_btn_confirma;
	assign rst_detect_confirmar = db_btn_confirma;

	wire sinal_jogar, rst_detect_jogar;

	assign sinal_jogar = ~db_btn_jogar;
	assign rst_detect_jogar = db_btn_jogar;

	assign nivel_efetivo = (s_modo == MODO_LIVRE || m4_ativo) ? MAX_RGB_DIFICIL : nivel;
	assign max_rgb = (nivel_efetivo == NIVEL_FACIL) ? MAX_RGB_FACIL :
	                 (nivel_efetivo == NIVEL_NORMAL) ? MAX_RGB_NORMAL : MAX_RGB_DIFICIL;
	assign nivel_atual = nivel_efetivo;

	assign m4_rgb_show = seq_show_word;
	assign alvo_comp = (m4_ativo && usa_alvo_seq) ? seq_input_word : s_rgb_alvo;

	assign db_rgb_alvo = (s_modo == 3) ? seq_input_word : s_rgb_alvo;

	genvar i;
	generate
		for (i = 0; i < JOGADA_BITS; i = i + 1) begin : gen_debounce_rgb
			debounce #(.INTERVAL(DEBOUNCE_INTERVAL)) db_btn_rgb (
				.pb1(btns_plus_minus_rgb[i]),
				.clk(clock),
				.pb1_debounced(db_btns_plus_minus_rgb[i])
			);
		end
	endgenerate

	debounce #(.INTERVAL(DEBOUNCE_INTERVAL)) db_modo (
		.pb1(btn_modo),
		.clk(clock),
		.pb1_debounced(db_btn_modo)
	);

	debounce #(.INTERVAL(DEBOUNCE_INTERVAL)) db_confirma (
		.pb1(btn_confirma),
		.clk(clock),
		.pb1_debounced(db_btn_confirma)
	);

	debounce #(.INTERVAL(DEBOUNCE_INTERVAL)) db_jogar (
		.pb1(btn_jogar),
		.clk(clock),
		.pb1_debounced(db_btn_jogar)
	);

	wire [3:0] pontuacao;

	lfsr_random rnd (
		.clk(clock),
		.reset(zera_rnd),
		.random(random)
	);

	rgb_nonzero_guard guard_seq_nonzero (
		.rgb_in(random),
		.rgb_out(random_nonzero)
	);

	mode4_seq_engine #(
		.MAX_SEQ_LEN(4),
		.SHOW_CYCLES(SHOW_CYCLES),
		.GAP_CYCLES(GAP_CYCLES)
	) seq_mode4 (
		.clock(clock),
		.rnd_step(random_nonzero),
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
		.fim_t_show(fim_t_show),
		.fim_t_gap(fim_t_gap),
		.fim_show_seq(fim_show_seq),
		.fim_input_seq(fim_input_seq),
		.seq_no_max(seq_no_max),
		.seq_show_word(seq_show_word),
		.seq_input_word(seq_input_word)
	);

	rgb_level_limit limitador_rgb_alvo (
		.nivel(nivel),
		.rgb_in(random),
		.rgb_out(random_limitado)
	);

	rgb_nonzero_guard guard_alvo_nonzero (
		.rgb_in(random_limitado),
		.rgb_out(random_limitado_nonzero)
	);

	color_error diff_color (
		.R1(alvo_comp[5:4]),
		.G1(alvo_comp[3:2]),
		.B1(alvo_comp[1:0]),
		.R2(s_rgb_jogada[5:4]),
		.G2(s_rgb_jogada[3:2]),
		.B2(s_rgb_jogada[1:0]),
		.error(erro)
	);

	level_system level_sys (
		.clk(clock),
		.reset(zera_nivel),
		.jogada(conta_nivel),
		.level(nivel)
	);

	score_calc calc_pontuacao (
		.clock(clock),
		.erro(erro),
		.pontos(pontuacao)
	);

	timeout_counter #(.TIMEOUT_CYCLES(TIMEOUT_CYCLES)) counter_timeout (
		.clock(clock),
		.zera(zera_timeout),
		.conta(conta_timeout),
		.timeout(timeout)
	);

	cod_erro coderro (
		.erro(erro),
		.enable(enable_cod_erro),
		.leds_erro(leds_erro)
	);

	cod_leds_nivel codnivel (
		.level(nivel),
		.leds(leds_nivel)
	);

	edge_detector detect_btn_rgb (
		.clock(clock),
		.reset(rst_detect_rgb),
		.sinal(sinal_btn_rgb),
		.pulso(jogada_feita)
	);

	edge_detector detect_btn_jogar (
		.clock(clock),
		.reset(rst_detect_jogar),
		.sinal(sinal_jogar),
		.pulso(pulso_jogar)
	);

	edge_detector detect_btn_modo (
		.clock(clock),
		.reset(rst_detect_modo),
		.sinal(sinal_btn_modo),
		.pulso(pulso_modo)
	);

	edge_detector detect_btn_confirma (
		.clock(clock),
		.reset(rst_detect_confirmar),
		.sinal(sinal_confirmar),
		.pulso(confirmar)
	);

	register_n # ( .N(JOGADA_BITS) ) reg_jogada (
		.clock(clock),
		.clear(zera_rgb_jogada),
		.enable(registra_jogada),
		.D(~db_btns_plus_minus_rgb),
		.Q(s_jogada)
	);

	full_counter #( .M(MODE_MODULUS), .N(MODE_COUNTER_NUM_BITS) ) counter_modo  (
		.clock  (clock),
		.zera_as(zera_modo),
		.zera_s (1'b0),
		.conta  (conta_modo),
		.neg    (1'b0),
		.Q      (s_modo),
		.fim    (modo_fim),
		.meio   (modo_meio)
	);

	rgb_level_counter counter_led_r  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[IDX_R] || sub_rgb_jogada[IDX_R]) && mudar_rgb),
		.neg    (sub_rgb_jogada[IDX_R] && !add_rgb_jogada[IDX_R]),
		.max_val(max_rgb),
		.Q      (q_led_r)
	);
	rgb_level_counter counter_led_g  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[IDX_G] || sub_rgb_jogada[IDX_G]) && mudar_rgb),
		.neg    (sub_rgb_jogada[IDX_G] && !add_rgb_jogada[IDX_G]),
		.max_val(max_rgb),
		.Q      (q_led_g)
	);
	rgb_level_counter counter_led_b  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[IDX_B] || sub_rgb_jogada[IDX_B]) && mudar_rgb),
		.neg    (sub_rgb_jogada[IDX_B] && !add_rgb_jogada[IDX_B]),
		.max_val(max_rgb),
		.Q      (q_led_b)
	);
	
	register_n # ( .N(RGB_REG_NUM_BITS) ) reg_rgb_alvo (
		.clock(clock),
		.clear(zera_rgb_alvo),
		.enable(registra_rgb_alvo),
		.D(random_limitado_nonzero),
		.Q(s_rgb_alvo)
	);

	register_n # ( .N(PONTUACAO_NUM_BITS) ) reg_pontuacao (
		.clock(clock),
		.clear(zera_pontuacao),
		.enable(registra_pontuacao),
		.D(s_pontuacao + pontuacao),
		.Q(s_pontuacao)
	);

endmodule
