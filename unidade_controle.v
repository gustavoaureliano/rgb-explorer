module unidade_controle (
	input            clock,
	input            btn_reset,
	input            pulso_modo,
	input            btn_jogar,
	input            jogada,
	input      [2:0] s_modo,
	output reg       zera_rgb_jogada,
	output reg       zera_rgb_alvo,
	output reg       zera_pontuacao,
	output reg       zera_nivel,
	output reg       zera_modo,
	output reg       registra_jogada,
	output reg       registra_rgb_alvo,
	output reg       registra_pontuacao,
	output reg       mudar_rgb,
	output reg       conta_nivel,
	output reg       conta_modo
);

parameter inicial     = 8'h0;
parameter sel_modo    = 8'h1;
parameter reg_modo    = 8'h2;
parameter espera_btn  = 8'h3;
parameter reg_rgb_btn = 8'h4;
parameter muda_rgb    = 8'h5;
parameter rst_pontos  = 8'h6;

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
		espera_btn:  Eprox = jogada ? reg_rgb_btn : espera_btn;
		reg_rgb_btn: Eprox = muda_rgb;
		muda_rgb:    Eprox = espera_btn;
		rst_pontos:  Eprox = sel_modo; // temp. sol. until mode 2 added
		default: Eprox = inicial;
	endcase
end

always @* begin
	zera_modo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rgb_jogada = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rgb_alvo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_pontuacao = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_nivel = (Eatual == inicial) ? 1'b1 : 1'b0;
	conta_modo = (Eatual == reg_modo) ? 1'b1 : 1'b0;
	registra_jogada = (Eatual == reg_rgb_btn) ? 1'b1 : 1'b0;
	mudar_rgb = (Eatual == muda_rgb) ? 1'b1 : 1'b0;
end
endmodule
