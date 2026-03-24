`timescale 1ns/1ps

module debounce_tb;

    // Entradas
    reg clk;
    reg pb1;

    // Saída
    wire pb1_debounced;

    // Instancia o DUT (Device Under Test)
    debounce uut (
        .pb1(pb1),
        .clk(clk),
        .pb1_debounced(pb1_debounced)
    );

    // Geração de clock (50 MHz → período = 20ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Estímulos
    initial begin
        // Inicialização
        pb1 = 1; // botão não pressionado
        #100;

        // Simular bounce ao pressionar
        $display("Simulando bounce ao pressionar...");
        pb1 = 1;
        #20 pb1 = 0;
        #10 pb1 = 1;
        #15 pb1 = 0;
        #10 pb1 = 1;
        #10 pb1 = 0; // finalmente pressionado estável

        // Mantém pressionado
        #100000;

        // Simular bounce ao soltar
        $display("Simulando bounce ao soltar...");
        pb1 = 0;
        #20 pb1 = 1;
        #10 pb1 = 0;
        #15 pb1 = 1;
        #10 pb1 = 0;
        #10 pb1 = 1; // finalmente solto estável

        // Espera debounce completar
        #100000;

        $stop;
    end

    // Monitoramento
    initial begin
        $monitor("Tempo=%0t | pb1=%b | debounced=%b | counter=%d",
                 $time, pb1, pb1_debounced, uut.counter);
    end

endmodule