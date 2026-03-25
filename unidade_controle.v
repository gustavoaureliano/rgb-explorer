module unidade_controle (
	input            clock,
	input            btn_reset,
	input            pulso_modo,
	input            btn_jogar,
	input            jogada ,
	input            confirmar,
	input      [2:0] s_modo,
	input      [3:0] erro,
	output reg       zera_rgb_jogada,
	output reg       zera_rgb_alvo,
	output reg       zera_pontuacao,
	output reg       zera_nivel,
	output reg       zera_modo,
	output reg       zera_rnd,
	output reg       registra_jogada,
	output reg       registra_rgb_alvo,
	output reg       registra_pontuacao,
	output reg       display_erro,
	output reg       mudar_rgb,
	output reg       conta_nivel,
	output reg       conta_modo,
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
						else if (btn_jogar) begin
							case (s_modo)
								8'b0:    Eprox = espera_btn;
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
		rst_pontos:  Eprox = reg_cor_alvo;
		reg_cor_alvo: Eprox = espera_btn;
		compara_cor: begin
				if (erro == 0)
					Eprox = fim_exato;
				else if (erro < 3)
					Eprox = fim_perto;
				else
					Eprox = fim_longe;
			end
		fim_exato: Eprox = btn_jogar ? reg_cor_alvo : fim_exato;
		fim_perto: Eprox = btn_jogar ? reg_cor_alvo : fim_perto;
		fim_longe: Eprox = btn_jogar ? reg_cor_alvo : fim_longe;
		default: Eprox = inicial;
	endcase
end

always @* begin
	zera_modo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rnd = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rgb_jogada = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rgb_alvo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_pontuacao = (Eatual == inicial || Eatual == rst_pontos) ? 1'b1 : 1'b0;
	zera_nivel = (Eatual == inicial || Eatual == rst_pontos) ? 1'b1 : 1'b0;
	conta_modo = (Eatual == reg_modo) ? 1'b1 : 1'b0;
	registra_jogada = (Eatual == reg_rgb_btn) ? 1'b1 : 1'b0;
	mudar_rgb = (Eatual == muda_rgb) ? 1'b1 : 1'b0;
	registra_rgb_alvo = (Eatual == reg_cor_alvo) ? 1'b1 : 1'b0;
	registra_pontuacao = (Eatual == compara_cor) ? 1'b1 : 1'b0;
	enable_cod_erro = (Eatual == fim_exato || Eatual == fim_perto || Eatual == fim_longe) ? 1'b1 : 1'b0;

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
	endcase
end
endmodule
