module cod_erro (
	input  [3:0] erro,
	input        enable,
	output [2:0] leds_erro
);
	localparam [3:0] ERRO_EXATO = 4'd0;
	localparam [3:0] ERRO_PERTO_LIMITE = 4'd3;

	localparam [2:0] LED_VERMELHO = 3'b100;
	localparam [2:0] LED_AMARELO  = 3'b010;
	localparam [2:0] LED_VERDE    = 3'b001;

	reg [2:0] leds; 
	assign leds_erro = enable ? leds : 3'b000;
	always @(*) begin
		if (erro == ERRO_EXATO)
			leds = LED_VERDE;
		else if (erro < ERRO_PERTO_LIMITE)
			leds = LED_AMARELO;
		else
			leds = LED_VERMELHO;
	end
endmodule
