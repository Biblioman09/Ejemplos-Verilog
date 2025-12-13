// Máquina de estados fínita (Moore)
// semaforo_fsm.v 
module semaforo_fsm (
    input  wire clk,        // reloj lento (1 Hz) o enable de 1 s
    input  wire rst_n,      // reset activo en bajo
    output reg  rojo,
    output reg  amarillo,
    output reg  verde
);

    // Estados
    localparam S_ROJO     = 2'd0;
    localparam S_VERDE    = 2'd1;
    localparam S_AMARILLO = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] sec_count;   // cuenta segundos dentro de cada estado (0..7)

    // Registro de estado y contador
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= S_ROJO;
            sec_count <= 3'd0;
        end else begin
            state <= next_state;

            // lógica de contador de segundos por estado
            case (state)
                S_ROJO: begin
                    if (sec_count == 3'd1)      // 2 s: 0,1
                        sec_count <= 3'd0;
                    else
                        sec_count <= sec_count + 3'd1;
                end
                S_VERDE: begin
                    if (sec_count == 3'd4)      // 5 s: 0..4
                        sec_count <= 3'd0;
                    else
                        sec_count <= sec_count + 3'd1;
                end
                S_AMARILLO: begin
                    if (sec_count == 3'd1)      // 2 s: 0,1
                        sec_count <= 3'd0;
                    else
                        sec_count <= sec_count + 3'd1;
                end
                default: begin
                    sec_count <= 3'd0;
                end
            endcase
        end
    end

    // Lógica de siguiente estado
    always @* begin
        next_state = state;
        case (state)
            S_ROJO: begin
                if (sec_count == 3'd1)          // tras 2 s pasa a verde
                    next_state = S_VERDE;
            end
            S_VERDE: begin
                if (sec_count == 3'd4)          // tras 5 s pasa a amarillo
                    next_state = S_AMARILLO;
            end
            S_AMARILLO: begin
                if (sec_count == 3'd1)          // tras 2 s vuelve a rojo
                    next_state = S_ROJO;
            end
            default: begin
                next_state = S_ROJO;
            end
        endcase
    end

    // Lógica de salidas (Moore)
    always @* begin
        // por defecto todo apagado
        rojo     = 1'b0;
        amarillo = 1'b0;
        verde    = 1'b0;

        case (state)
            S_ROJO: begin
                rojo = 1'b1;
            end
            S_VERDE: begin
                verde = 1'b1;
            end
            S_AMARILLO: begin
                amarillo = 1'b1;
            end
        endcase
    end

endmodule
