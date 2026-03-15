module fluxo_dados (
	input        clock,
	input        zera_rgb_jogada,
	input        zera_rgb_alvo,
	input        zera_pontuacao,
	input        zera_nivel,
	input        zera_modo,
	input  [2:0] add_rgb_jogada,
	input  [2:0] sub_rgb_jogada,
	input        registra_rgb_alvo,
	input        registra_pontuacao,
	input        conta_nivel,
	input        conta_modo,
	output [5:0] s_rgb_alvo,
	output [5:0] s_rgb_jogada,
	output [2:0] leds_nivel,
	output [2:0] s_modo
);
	localparam rgb_leds_modulus = 3;
	localparam rgb_num_bits = $clog2(rgb_leds_modulus);
	localparam mode_modulus = 4;
	localparam mode_num_bits = $clog2(mode_modulus);
	localparam rgb_reg_num_bits = rgb_num_bits*3;
	localparam rgb_reg_modulus = 2**(rgb_num_bits*3) - 1;

	wire [rgb_num_bits-1:0] q_led_r, q_led_g, q_led_b;

	wire [rgb_reg_num_bits-1:0] random;
	assign random = 6'b0; // temp fix until i create the random module

	assign s_rgb_jogada = {q_led_r, q_led_g, q_led_b};

	full_counter #( .M(4), .N(3) ) counter_modo  (
		.clock  (clock),
		.zera_as(zera_modo),
		.conta  (conta_modo),
		.neg    (1'b0),
		.Q      (s_modo),
		.fim    (fim_timeout)
	);

	full_counter #( .M(rgb_leds_modulus), .N(rgb_num_bits) ) counter_led_r  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  (add_rgb_jogada[2] | sub_rgb_jogada[2]),
		.neg    (sub_rgb_jogada[2] && !add_rgb_jogada[2]),
		.Q      (q_led_r),
		.fim    (fim_timeout)
	);
	full_counter #( .M(rgb_leds_modulus), .N(rgb_num_bits) ) counter_led_g  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  (add_rgb_jogada[1] | sub_rgb_jogada[1]),
		.neg    (sub_rgb_jogada[1] && !add_rgb_jogada[1]),
		.Q      (q_led_g),
		.fim    (fim_timeout)
	);
	full_counter #( .M(rgb_leds_modulus), .N(rgb_num_bits) ) counter_led_b  (
		.clock  (clock),
		.zera_as(zera_rgb_jogada),
		.conta  (add_rgb_jogada[0] | sub_rgb_jogada[0]),
		.neg    (sub_rgb_jogada[0] && !add_rgb_jogada[0]),
		.Q      (q_led_b),
		.fim    (fim_timeout)
	);
	
	register_m # ( .M(rgb_reg_modulus), .N(rgb_reg_num_bits) ) reg_rgb_target (
		.clock(clock),
		.clear(1'b0),
		.enable(registra_rgb_alvo),
		.D(random),
		.Q(s_rgb_alvo)
	);

endmodule
