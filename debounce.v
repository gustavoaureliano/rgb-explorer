module debounce (
    input pb1,
    input clk,
    output reg pb1_debounced
);
    reg [15:0] counter; // Contador para o debounce
    reg pb1_sync_0, pb1_sync_1; // Registradores para sincronização

    // Sincronização do sinal de entrada
    always @(posedge clk) begin
        pb1_sync_0 <= pb1;
        pb1_sync_1 <= pb1_sync_0;
    end

    // Lógica de debounce
    always @(posedge clk) begin
        if (pb1_sync_1 == 0) begin
            counter <= 0; // Resetar contador se o botão estiver pressionado
            pb1_debounced <= 0; // Botão pressionado
        end else if (counter < 16'hFFFF) begin
            counter <= counter + 1; // Incrementar contador se o botão não estiver pressionado
        end else begin
            pb1_debounced <= 1; // Botão liberado após debounce
        end
    end
    
endmodule