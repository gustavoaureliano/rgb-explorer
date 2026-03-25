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
	input        registra_jogada,
	input        registra_rgb_alvo,
	input        registra_pontuacao,
	input        mudar_rgb,
	input        conta_nivel,
	input        conta_modo,
	input        enable_cod_erro,
	input		 foi_jogada,
	output       pulso_modo,
	output       jogada_feita,
	output       confirmar,
	output [5:0] s_rgb_alvo,
	output [5:0] s_rgb_jogada,
	output [3:0] s_pontuacao,
	output [2:0] leds_nivel,
	output [2:0] leds_erro,
	output [2:0] s_modo,
	output [3:0] erro
);
	localparam rgb_leds_modulus = 4;
	localparam rgb_num_bits = $clog2(rgb_leds_modulus);
	localparam mode_modulus = 4;
	localparam mode_num_bits = $clog2(mode_modulus);
	localparam rgb_reg_num_bits = rgb_num_bits*3;
	localparam pontuacao_num_bits = 4;

	wire [rgb_num_bits-1:0] q_led_r, q_led_g, q_led_b;
	wire fim_led_r, fim_led_g, fim_led_b;

	wire [rgb_reg_num_bits-1:0] random;

	assign s_rgb_jogada = {q_led_r, q_led_g, q_led_b};

	wire [5:0] s_jogada;
	wire [2:0] add_rgb_jogada;
	wire [2:0] sub_rgb_jogada;
	assign add_rgb_jogada = s_jogada[5:3];
	assign sub_rgb_jogada = s_jogada[2:0];

	wire sinal_btn_rgb, rst_detect_rgb;

	assign sinal_btn_rgb = ~&btns_plus_minus_rgb;
	assign rst_detect_rgb = &btns_plus_minus_rgb;

	wire sinal_btn_modo, rst_detect_modo;

	assign sinal_btn_modo = |btn_modo;
	assign rst_detect_modo = ~|btn_modo;

	wire sinal_confirmar, rst_detect_confirmar;
	wire [1:0]nivel;

	assign sinal_confirmar = |btn_confirma;
	assign rst_detect_confirmar = ~|btn_confirma;

	// create module later
	reg [3:0] pontuacao;
	always @(posedge clock) begin
		if (erro == 0)
			pontuacao = 4;
		else if (erro < 3)
			pontuacao = 2;
		else
			pontuacao = 0;
	end

	lfsr_random rnd (
		.clk(clock),
		.reset(zera_rnd),
		.random(random)
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
		.jogada(foi_jogada),  // usando o sinal de confirmação como "jogada feita"
		.level(nivel)
	);

	cod_erro coderro (
		.erro(erro),
		.enable(1'b1),
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
		.D(~btns_plus_minus_rgb),
		.Q(s_jogada)
	);

	full_counter #( .M(4), .N(3) ) counter_modo  (
		.clock  (clock),
		.zera_as(zera_modo),
		.conta  (conta_modo),
		.neg    (1'b0),
		.Q      (s_modo)
	);

	full_counter #( .M(rgb_leds_modulus), .N(rgb_num_bits) ) counter_led_r  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[2] || sub_rgb_jogada[2]) && mudar_rgb),
		.neg    (sub_rgb_jogada[2] && !add_rgb_jogada[2]),
		.Q      (q_led_r),
		.fim    (fim_led_r)
	);
	full_counter #( .M(rgb_leds_modulus), .N(rgb_num_bits) ) counter_led_g  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[1] || sub_rgb_jogada[1]) && mudar_rgb),
		.neg    (sub_rgb_jogada[1] && !add_rgb_jogada[1]),
		.Q      (q_led_g),
		.fim    (fim_led_g)
	);
	full_counter #( .M(rgb_leds_modulus), .N(rgb_num_bits) ) counter_led_b  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  ((add_rgb_jogada[0] || sub_rgb_jogada[0]) && mudar_rgb),
		.neg    (sub_rgb_jogada[0] && !add_rgb_jogada[0]),
		.Q      (q_led_b),
		.fim    (fim_led_b)
	);
	
	register_n # ( .N(rgb_reg_num_bits) ) reg_rgb_alvo (
		.clock(clock),
		.clear(zera_rgb_alvo),
		.enable(registra_rgb_alvo),
		.D(random),
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
