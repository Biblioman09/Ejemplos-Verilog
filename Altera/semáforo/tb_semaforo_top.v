`timescale 1ns/1ps

module tb_semaforo_fsm;

    // Señales del DUT
    reg  clk;       // aquí cada flanco = 1 "segundo lógico"
    reg  rst_n;
    wire rojo;
    wire amarillo;
    wire verde;

    // Generación de reloj "lento" para FSM
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;   // periodo 10 ns
    end

    // Estímulos de reset
    initial begin
        rst_n = 1'b0;
        #20;              // 20 ns en reset
        rst_n = 1'b1;     // liberar reset
    end

    // Instancia de la FSM
    semaforo_fsm dut (
        .clk      (clk),      // cada flanco = 1 "segundo"
        .rst_n    (rst_n),
        .rojo     (rojo),
        .amarillo (amarillo),
        .verde    (verde)
    );

    // Control de simulación y ondas
    initial begin
        // Si quieres VCD (otros simuladores)
        // $dumpfile("fsm_semaforo.vcd");
        // $dumpvars(0, tb_semaforo_fsm);

        // Espera tiempo suficiente para ver varios ciclos:
        // 1 flanco = 1 s lógico → un ciclo completo son 9 flancos.
        // Con 200 ns ves muchos cambios (cada 10 ns un "segundo").
        #200;
        $stop;
    end

endmodule
