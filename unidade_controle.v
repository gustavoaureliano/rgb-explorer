module unidade_controle (
	input            clock,
	input            btn_reset,
	input            pulso_modo,
	input            pulso_jogar,
	input            jogada ,
	input            confirmar,
	input            timeout,
	input      [2:0] s_modo,
	input      [3:0] erro,
	input            fim_t_show,
	input            fim_t_gap,
	input            fim_show_seq,
	input            fim_input_seq,
	input            seq_no_max,
	input            ciclo_niveis_completo,
	input            atingiu_pontuacao_max,
	output reg       zera_rgb_jogada,
	output reg       zera_rgb_alvo,
	output reg       zera_pontuacao,
	output reg       zera_nivel,
	output reg       zera_modo,
	output reg       zera_rnd,
	output reg       registra_jogada,
	output reg       registra_rgb_alvo,
	output reg       registra_pontuacao,
	output reg       mudar_rgb,
	output reg       conta_nivel,
	output reg       conta_modo,
	output reg       zera_timeout,
	output reg       conta_timeout,
	output reg       mostra_rgb_alvo,
	output reg       m4_ativo,
	output reg       registra_seq,
	output reg       zera_seq_len,
	output reg       conta_seq_len,
	output reg       zera_idx_show,
	output reg       conta_idx_show,
	output reg       zera_idx_input,
	output reg       conta_idx_input,
	output reg       zera_t_show,
	output reg       conta_t_show,
	output reg       zera_t_gap,
	output reg       conta_t_gap,
	output reg       mostra_seq,
	output reg       usa_alvo_seq,
	output reg       zera_erro_latch,
	output reg       registra_erro_latch,
	output reg       enable_cod_erro,
	output reg [7:0] db_estado
);

parameter inicial      = 8'h0;
parameter sel_modo     = 8'h1;
parameter reg_modo     = 8'h2;
parameter espera_btn   = 8'h3;
parameter reg_rgb_btn  = 8'h4;
parameter muda_rgb     = 8'h5;
parameter rst_pontos   = 8'h6;
parameter reg_cor_alvo = 8'h7;
parameter compara_cor  = 8'h8;
parameter fim_exato    = 8'h9;
parameter fim_perto    = 8'hA;
parameter fim_longe    = 8'hB;
parameter espera_timeout = 8'hC;
parameter m4_game_init = 8'hD;
parameter m4_add_step = 8'hE;
parameter m4_show_step = 8'hF;
parameter m4_show_gap = 8'h10;
parameter m4_next_show = 8'h11;
parameter m4_wait_input = 8'h12;
parameter m4_reg_rgb_btn = 8'h13;
parameter m4_muda_rgb = 8'h14;
parameter m4_next_input = 8'h15;
parameter m4_round_ok = 8'h16;
parameter m4_add_len = 8'h17;
parameter m4_round_fail = 8'h18;
parameter m4_vitoria_final = 8'h19;
parameter fim_partida = 8'h1A;

localparam [2:0] MODO_LIVRE = 3'd0;
localparam [2:0] MODO_REPRODUZIR = 3'd1;
localparam [2:0] MODO_MEMORIA = 3'd2;
localparam [2:0] MODO_DESAFIO = 3'd3;

localparam [3:0] ERRO_EXATO = 4'd0;
localparam [3:0] ERRO_PERTO_LIMITE = 4'd3;

reg [7:0] Eatual, Eprox;

always @(posedge clock or posedge btn_reset) begin
	if (btn_reset)
		Eatual <= inicial; 
	else
		Eatual <= Eprox;
end

always @* begin
	case (Eatual)
		inicial:     Eprox = sel_modo;
		sel_modo:	begin
						if (pulso_modo)
							Eprox = reg_modo;
						else if (pulso_jogar) begin
							case (s_modo)
								MODO_LIVRE:    Eprox = espera_btn;
								default: Eprox = rst_pontos;
							endcase
						end else
							Eprox = sel_modo;
					end
		reg_modo :   Eprox = sel_modo;
		espera_btn:  begin
				if (jogada)
					Eprox = reg_rgb_btn;
				else if (confirmar)
					Eprox = compara_cor;
				else
					Eprox = espera_btn;
			end
		reg_rgb_btn: Eprox = muda_rgb;
		muda_rgb:    Eprox = espera_btn;
		rst_pontos:  Eprox = (s_modo == MODO_DESAFIO) ? m4_game_init : reg_cor_alvo;
		reg_cor_alvo: Eprox = (s_modo == MODO_MEMORIA) ? espera_timeout : espera_btn;
		espera_timeout: Eprox = timeout ? espera_btn : espera_timeout;
		m4_game_init: Eprox = m4_add_step;
		m4_add_step: Eprox = m4_show_step;
		m4_show_step: Eprox = fim_t_show ? m4_show_gap : m4_show_step;
		m4_show_gap: Eprox = fim_t_gap ? m4_next_show : m4_show_gap;
		m4_next_show: Eprox = fim_show_seq ? m4_wait_input : m4_show_step;
		m4_wait_input: begin
			if (jogada)
				Eprox = m4_reg_rgb_btn;
			else if (confirmar)
				Eprox = compara_cor;
			else
				Eprox = m4_wait_input;
		end
		m4_reg_rgb_btn: Eprox = m4_muda_rgb;
		m4_muda_rgb: Eprox = m4_wait_input;
		compara_cor: begin
				if (s_modo == MODO_DESAFIO)
					Eprox = m4_next_input;
				else if ((s_modo == MODO_REPRODUZIR || s_modo == MODO_MEMORIA) && atingiu_pontuacao_max)
					Eprox = fim_partida;
				else if ((s_modo == MODO_REPRODUZIR || s_modo == MODO_MEMORIA) && ciclo_niveis_completo)
					Eprox = fim_partida;
				else if (erro == ERRO_EXATO)
					Eprox = fim_exato;
				else if (erro < ERRO_PERTO_LIMITE)
					Eprox = fim_perto;
				else
					Eprox = fim_longe;
			end
		m4_next_input: begin
			if (erro >= ERRO_PERTO_LIMITE)
				Eprox = m4_round_fail;
			else if (fim_input_seq && seq_no_max)
				Eprox = m4_vitoria_final;
			else if (fim_input_seq)
				Eprox = m4_round_ok;
			else
				Eprox = m4_wait_input;
		end
		m4_round_ok: Eprox = pulso_jogar ? m4_add_len : m4_round_ok;
		m4_add_len: Eprox = m4_add_step;
		m4_round_fail: Eprox = pulso_jogar ? rst_pontos : m4_round_fail;
		m4_vitoria_final: Eprox = pulso_jogar ? rst_pontos : m4_vitoria_final;
		fim_partida: Eprox = pulso_jogar ? rst_pontos : fim_partida;
		fim_exato: Eprox = pulso_jogar ? reg_cor_alvo : fim_exato;
		fim_perto: Eprox = pulso_jogar ? reg_cor_alvo : fim_perto;
		fim_longe: Eprox = pulso_jogar ? reg_cor_alvo : fim_longe;
		default: Eprox = inicial;
	endcase
end

always @* begin
	zera_modo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rnd = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rgb_jogada = (Eatual == inicial || Eatual == rst_pontos || Eatual == reg_cor_alvo || Eatual == m4_add_step) ? 1'b1 : 1'b0;
	zera_rgb_alvo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_pontuacao = (Eatual == inicial || Eatual == rst_pontos) ? 1'b1 : 1'b0;
	zera_nivel = (Eatual == inicial || Eatual == rst_pontos) ? 1'b1 : 1'b0;
	zera_timeout = (Eatual == inicial || Eatual == rst_pontos || Eatual == reg_cor_alvo) ? 1'b1 : 1'b0;
	conta_timeout = (Eatual == espera_timeout) ? 1'b1 : 1'b0;
	conta_nivel = (Eatual == compara_cor && s_modo != MODO_DESAFIO) ? 1'b1 : 1'b0;
	conta_modo = (Eatual == reg_modo) ? 1'b1 : 1'b0;
	registra_jogada = (Eatual == reg_rgb_btn || Eatual == m4_reg_rgb_btn) ? 1'b1 : 1'b0;
	mudar_rgb = (Eatual == muda_rgb || Eatual == m4_muda_rgb) ? 1'b1 : 1'b0;
	registra_rgb_alvo = (Eatual == reg_cor_alvo) ? 1'b1 : 1'b0;
	registra_pontuacao = (Eatual == compara_cor) ? 1'b1 : 1'b0;
	mostra_rgb_alvo = (s_modo == MODO_REPRODUZIR) || ((s_modo == MODO_MEMORIA) && (Eatual == espera_timeout));
	m4_ativo = (s_modo == MODO_DESAFIO) ? 1'b1 : 1'b0;
	registra_seq = (Eatual == m4_add_step) ? 1'b1 : 1'b0;
	zera_seq_len = (Eatual == m4_game_init) ? 1'b1 : 1'b0;
	conta_seq_len = (Eatual == m4_add_len) ? 1'b1 : 1'b0;
	zera_idx_show = (Eatual == m4_game_init || Eatual == m4_add_step) ? 1'b1 : 1'b0;
	conta_idx_show = (Eatual == m4_next_show && !fim_show_seq) ? 1'b1 : 1'b0;
	zera_idx_input = (Eatual == m4_game_init || Eatual == m4_add_step || (Eatual == m4_next_show && fim_show_seq)) ? 1'b1 : 1'b0;
	conta_idx_input = (Eatual == m4_next_input && erro < ERRO_PERTO_LIMITE && !fim_input_seq) ? 1'b1 : 1'b0;
	zera_t_show = (Eatual != m4_show_step) ? 1'b1 : 1'b0;
	conta_t_show = (Eatual == m4_show_step) ? 1'b1 : 1'b0;
	zera_t_gap = (Eatual != m4_show_gap) ? 1'b1 : 1'b0;
	conta_t_gap = (Eatual == m4_show_gap) ? 1'b1 : 1'b0;
	mostra_seq = (Eatual == m4_show_step) ? 1'b1 : 1'b0;
	usa_alvo_seq = (Eatual == m4_wait_input || Eatual == compara_cor || Eatual == m4_next_input ||
	               Eatual == m4_round_ok || Eatual == m4_round_fail || Eatual == m4_vitoria_final) ? 1'b1 : 1'b0;
	zera_erro_latch = (Eatual == inicial || Eatual == rst_pontos || Eatual == m4_game_init) ? 1'b1 : 1'b0;
	registra_erro_latch = (Eatual == compara_cor) ? 1'b1 : 1'b0;
	enable_cod_erro = (Eatual == fim_exato) || (Eatual == fim_perto) || (Eatual == fim_longe) ||
	                 (Eatual == m4_round_ok) || (Eatual == m4_round_fail) || (Eatual == m4_vitoria_final) ||
	                 (Eatual == fim_partida);

	case (Eatual)
		inicial:      db_estado = 8'h0;
		sel_modo:     db_estado = 8'h1;
		reg_modo:     db_estado = 8'h2;
		espera_btn:   db_estado = 8'h3;
		reg_rgb_btn:  db_estado = 8'h4;
		muda_rgb:     db_estado = 8'h5;
		rst_pontos:   db_estado = 8'h6;
		reg_cor_alvo: db_estado = 8'h7;
		compara_cor:  db_estado = 8'h8;
		fim_exato:    db_estado = 8'h9;
		fim_perto:    db_estado = 8'hA;
		fim_longe:    db_estado = 8'hB;
		espera_timeout: db_estado = 8'hC;
		m4_game_init: db_estado = 8'hD;
		m4_add_step: db_estado = 8'hE;
		m4_show_step: db_estado = 8'hF;
		m4_show_gap: db_estado = 8'h10;
		m4_next_show: db_estado = 8'h11;
		m4_wait_input: db_estado = 8'h12;
		m4_reg_rgb_btn: db_estado = 8'h13;
		m4_muda_rgb: db_estado = 8'h14;
		m4_next_input: db_estado = 8'h15;
		m4_round_ok: db_estado = 8'h16;
		m4_add_len: db_estado = 8'h17;
		m4_round_fail: db_estado = 8'h18;
		m4_vitoria_final: db_estado = 8'h19;
		fim_partida: db_estado = 8'h1A;
		default: db_estado = 8'hFF;
	endcase
end
endmodule
