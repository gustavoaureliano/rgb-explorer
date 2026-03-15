module unidade_controle (
	input            clock,
	input            btn_reset,
	input            btn_modo,
	input            btn_jogar,
	input            jogada,
	input      [2:0] s_modo,
	output reg       zera_rgb_jogada,
	output reg       zera_rgb_alvo,
	output reg       zera_pontuacao,
	output reg       zera_nivel,
	output reg       zera_modo,
	output reg [2:0] add_rgb_jogada,
	output reg [2:0] sub_rgb_jogada,
	output reg       registra_rgb_alvo,
	output reg       registra_pontuacao,
	output reg       conta_nivel,
	output reg       conta_modo
);

parameter inicial     = 8'h0;
parameter sel_modo    = 8'h1;
parameter reg_modo    = 8'h2;
parameter espera_btn  = 8'h3;
parameter reg_rgb_btn = 8'h4;
parameter add_led_r   = 8'h5;
parameter add_led_g   = 8'h6;
parameter add_led_b   = 8'h7;
parameter sub_led_r   = 8'h8;
parameter sub_led_g   = 8'h9;
parameter sub_led_b   = 8'hA;
parameter rst_pontos  = 8'hB;

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
						if (btn_modo)
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
		espera_btn:  Eprox = reg_rgb_btn;
		reg_rgb_btn: Eprox = espera_btn;
		rst_pontos: Eprox = sel_modo; // temp sol until mode 2 added
		default: Eprox = inicial;
	endcase
end

always @* begin
	zera_modo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rgb_jogada = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_rgb_alvo = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_pontuacao = (Eatual == inicial) ? 1'b1 : 1'b0;
	zera_nivel = (Eatual == inicial) ? 1'b1 : 1'b0;
	case (Eatual)
		add_led_r: add_rgb_jogada = 3'b100;
		add_led_g: add_rgb_jogada = 3'b010;
		add_led_b: add_rgb_jogada = 3'b001;
		sub_led_r: sub_rgb_jogada = 3'b100;
		sub_led_g: sub_rgb_jogada = 3'b010;
		sub_led_b: sub_rgb_jogada = 3'b001;
		default: begin
			add_rgb_jogada = 3'b000;
			sub_rgb_jogada = 3'b000;
		end
	endcase
end
endmodule
