############################################################
# Reloj virtual del sistema (50 MHz)
############################################################
create_clock -name virt_clk -period 20.000

############################################################
# Restricciones de entrada
# Entradas válidas respecto al reloj virtual
############################################################
set_input_delay 0 -clock virt_clk [get_ports {a b}]

############################################################
# Restricciones de salida
# Salida estable respecto al reloj virtual
############################################################
set_output_delay 0 -clock virt_clk [get_ports y]
