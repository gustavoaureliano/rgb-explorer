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
	output       pulso_modo,
	output       pulso_jogar,
	output       jogada_feita,
	output       confirmar,
	output [5:0] s_rgb_alvo,
	output [5:0] s_rgb_jogada,
	output [3:0] s_pontuacao,
	output [2:0] leds_nivel,
	output [2:0] leds_erro,
	output [2:0] s_modo,
	output [1:0] nivel_atual,
	output       timeout,
	output [3:0] erro
);
	localparam rgb_leds_modulus = 4;
	localparam rgb_num_bits = $clog2(rgb_leds_modulus);
	localparam debounce_interval = 4; // 1 KHz -> 4 ms
	// localparam debounce_interval = 200000; // 50 MHz -> 4 ms
	localparam timeout_cycles = 5000; // 1 KHz -> 5 s
	// localparam timeout_cycles = 250000000; // 50 MHz -> 5 s
	localparam mode_modulus = 4;
	localparam mode_num_bits = $clog2(mode_modulus);
	localparam rgb_reg_num_bits = rgb_num_bits*3;
	localparam pontuacao_num_bits = 4;

	wire [rgb_num_bits-1:0] q_led_r, q_led_g, q_led_b;

	wire [rgb_reg_num_bits-1:0] random;
	wire [rgb_reg_num_bits-1:0] random_limitado;
	wire [5:0] db_btns_plus_minus_rgb;
	wire db_btn_modo, db_btn_confirma, db_btn_jogar;
	wire [1:0] max_rgb;
	wire modo_fim, modo_meio;

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
	wire [1:0]nivel;

	assign sinal_confirmar = ~db_btn_confirma;
	assign rst_detect_confirmar = db_btn_confirma;

	wire sinal_jogar, rst_detect_jogar;

	assign sinal_jogar = ~db_btn_jogar;
	assign rst_detect_jogar = db_btn_jogar;

	assign max_rgb = (nivel == 2'd0) ? 2'd1 :
	                 (nivel == 2'd1) ? 2'd2 : 2'd3;
	assign nivel_atual = nivel;

	genvar i;
	generate
		for (i = 0; i < 6; i = i + 1) begin : gen_debounce_rgb
			debounce #(.INTERVAL(debounce_interval)) db_btn_rgb (
				.pb1(btns_plus_minus_rgb[i]),
				.clk(clock),
				.pb1_debounced(db_btns_plus_minus_rgb[i])
			);
		end
	endgenerate

	debounce #(.INTERVAL(debounce_interval)) db_modo (
		.pb1(btn_modo),
		.clk(clock),
		.pb1_debounced(db_btn_modo)
	);

	debounce #(.INTERVAL(debounce_interval)) db_confirma (
		.pb1(btn_confirma),
		.clk(clock),
		.pb1_debounced(db_btn_confirma)
	);

	debounce #(.INTERVAL(debounce_interval)) db_jogar (
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

	rgb_level_limit limitador_rgb_alvo (
		.nivel(nivel),
		.rgb_in(random),
		.rgb_out(random_limitado)
	);

	color_error diff_color (
		.R1(s_rgb_alvo[5:4]),
		.G1(s_rgb_alvo[3:2]),
		.B1(s_rgb_alvo[1:0]),
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

	timeout_counter #(.TIMEOUT_CYCLES(timeout_cycles)) counter_timeout (
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

	register_n # ( .N(6) ) reg_jogada (
		.clock(clock),
		.clear(zera_rgb_jogada),
		.enable(registra_jogada),
		.D(~db_btns_plus_minus_rgb),
		.Q(s_jogada)
	);

	full_counter #( .M(4), .N(3) ) counter_modo  (
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
		.conta  ((add_rgb_jogada[2] || sub_rgb_jogada[2]) && mudar_rgb),
		.neg    (sub_rgb_jogada[2] && !add_rgb_jogada[2]),
		.max_val(max_rgb),
		.Q      (q_led_r)
	);
	rgb_level_counter counter_led_g  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[1] || sub_rgb_jogada[1]) && mudar_rgb),
		.neg    (sub_rgb_jogada[1] && !add_rgb_jogada[1]),
		.max_val(max_rgb),
		.Q      (q_led_g)
	);
	rgb_level_counter counter_led_b  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[0] || sub_rgb_jogada[0]) && mudar_rgb),
		.neg    (sub_rgb_jogada[0] && !add_rgb_jogada[0]),
		.max_val(max_rgb),
		.Q      (q_led_b)
	);
	
	register_n # ( .N(rgb_reg_num_bits) ) reg_rgb_alvo (
		.clock(clock),
		.clear(zera_rgb_alvo),
		.enable(registra_rgb_alvo),
		.D(random_limitado),
		.Q(s_rgb_alvo)
	);

	register_n # ( .N(pontuacao_num_bits) ) reg_pontuacao (
		.clock(clock),
		.clear(zera_pontuacao),
		.enable(registra_pontuacao),
		.D(s_pontuacao + pontuacao),
		.Q(s_pontuacao)
	);

endmodule
