module color_error (
    input  [1:0] R1, G1, B1,
    input  [1:0] R2, G2, B2,
    output [3:0] error
);
	function [1:0] abs_diff;
		input [1:0] a, b;
		begin
			if (a > b)
				abs_diff = a - b;
			else
				abs_diff = b - a;
		end
	endfunction
	assign error = abs_diff(R1, R2) +
	               abs_diff(G1, G2) +
	               abs_diff(B1, B2);
endmodule
