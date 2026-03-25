module cod_erro (
	input  [3:0] erro,
	input        enable,
	output [2:0] leds_erro
);
	reg [2:0] leds; 
	assign leds_erro = enable ? leds : 1'b0;
	always @(*) begin
		if (erro == 0)
			leds = 3'b100;
		else if (erro < 3)
			leds = 3'b010;
		else
			leds = 3'b001;
	end
endmodule
