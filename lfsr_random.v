module lfsr_random (
    input wire clk,
    input wire reset,
    output [5:0] random
);

reg [7:0] rnd;

assign random = rnd[5:0];

always @(posedge clk or posedge reset) begin
    if (reset)
        rnd <= 8'h1;  // seed inicial
    else
        rnd <= {rnd[6:0], rnd[7] ^ rnd[5] ^ rnd[4] ^ rnd[3]};
end

endmodule
