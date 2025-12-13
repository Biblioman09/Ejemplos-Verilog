// semaforo_top.v
// Archivo .TOP del ejemplo
module semaforo_top (
    input  wire clk_50MHz,   // reloj principal de la FPGA (50 MHz)
    input  wire rst_n,       // reset activo en bajo
    output wire rojo,
    output wire amarillo,
    output wire verde
);

    // =========================================
    // Generación de enable de 1 segundo
    // 50 MHz -> 1 Hz: 50_000_000 ciclos
    // =========================================
    localparam integer MAX_COUNT = 50_000_000 - 1; // cuenta 0..49_999_999

    reg [25:0] count;        // 2^26 ~= 67M > 50M
    reg        tick_1s;      // pulso de 1 clk de duración cada segundo

    always @(posedge clk_50MHz or negedge rst_n) begin
        if (!rst_n) begin
            count   <= 26'd0;
            tick_1s <= 1'b0;
        end else begin
            if (count == MAX_COUNT) begin
                count   <= 26'd0;
                tick_1s <= 1'b1;       // genera el pulso de 1s
            end else begin
                count   <= count + 26'd1;
                tick_1s <= 1'b0;
            end
        end
    end

    // ==================================================
    // Registro para convertir tick_1s en “reloj” lento
    // ==================================================
    reg clk_1Hz;

    always @(posedge clk_50MHz or negedge rst_n) begin
        if (!rst_n) begin
            clk_1Hz <= 1'b0;
        end else if (tick_1s) begin
            clk_1Hz <= ~clk_1Hz;  // opcional: puede usarse tick_1s como enable
        end
    end

    // Para esta FSM vamos a usar tick_1s como reloj/enable.
    // Si prefieres un reloj cuadrado de 1 Hz, puedes usar clk_1Hz.

    // =========================================
    // Instancia de la FSM
    // =========================================
    semaforo_fsm u_semaforo (
        .clk      (tick_1s),   // avanza la FSM cada segundo
        .rst_n    (rst_n),
        .rojo     (rojo),
        .amarillo (amarillo),
        .verde    (verde)
    );

endmodule
