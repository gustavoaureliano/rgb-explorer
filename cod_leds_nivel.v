module cod_leds_nivel (
	input      [1:0] level,
	output reg [2:0] leds
);
	always @(*) begin
		if (level == 0)
			leds = 3'b100;
		else if (level == 1)
			leds = 3'b010;
		else
			leds = 3'b001;
	end
endmodule
