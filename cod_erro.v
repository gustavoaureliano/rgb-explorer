module cod_erro (
	input  [3:0] erro,
	input        enable,
	output [2:0] leds_erro
);
	localparam vermelho = 3'b100;
	localparam amarelo  = 3'b010;
	localparam verde    = 3'b001;

	reg [2:0] leds; 
	assign leds_erro = enable ? leds : 3'b000;
	always @(*) begin
		if (erro == 0)
			leds = verde;
		else if (erro < 3)
			leds = amarelo;
		else
			leds = vermelho;
	end
endmodule
