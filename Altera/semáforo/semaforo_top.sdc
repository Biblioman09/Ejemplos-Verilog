# semaforo_top.sdc 

# 1) Reloj base de 50 MHz en el pin de entrada
#    Periodo = 20 ns (1 / 50e6)
create_clock -name clk50 -period 20.0 [get_ports {clk_50MHz}]

