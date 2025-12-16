############################################################
# Reloj principal: 50 MHz
############################################################
create_clock -name clk \
             -period 20.000 \
             [get_ports clk]

############################################################
# Reloj generado internamente: clk2 (≈ 2 Hz)
# Divisor efectivo: 25,000,000
############################################################
create_generated_clock -name clk2 \
    -source [get_ports clk] \
    -divide_by 25000000 \
    [get_registers clk2]

############################################################
# Reset asíncrono activo en bajo
# Se excluye de análisis de temporización
############################################################
set_false_path -from [get_ports nrst]

############################################################
# (Opcional) Excluir caminos entre dominios si Quartus
# no infiere correctamente el generated clock
############################################################
# set_clock_groups -asynchronous \
#     -group [get_clocks clk] \
#     -group [get_clocks clk2]

############################################################
# Salidas LED (sin restricciones externas específicas)
############################################################
# No se aplican set_output_delay
############################################################
