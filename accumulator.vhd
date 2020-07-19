-----------------------------------------
--- Universidad Nacional de Asunción ----
-------- Facultad de Ingeniería ---------
--- Carrera de Ingeniería Electrónica ---
---- Cátedra de Sistemas Digitales 2 ----
-----------------------------------------

-- Implementación del Procesador MU0
-- Arquitectura de Manchester University
-- Autor: Abilio Mancuello Petters
-- Fecha: Jul/2020

-- Basado en el texto S. Furber, ARM System-on-Chip Architecture, 2da. Ed. Edinburgo, Addison-Wesley, 2000
-- Inspirado en el diseño de Ben Howes 2011 - https://github.com/benhowes/VHDL-mu0       

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity accumulator is
  port( 
    CLK    : in  std_logic; -- Entrada de reloj
	 RESET  : in  std_logic; -- 
    EN_IN  : in  std_logic; -- Habilitación de entrada al registro
	 EN_OUT : in  std_logic; -- Habilitación de salida del registro
    INPUT  : in  std_logic_vector (15 downto 0);-- entrada del registro
    OUTPUT : out std_logic_vector (15 downto 0); -- Salida del registro
	 N: out std_logic;
	 Z: out std_logic
  );
end accumulator;

architecture behav of accumulator is
	signal v_out : std_logic_vector (15 downto 0) := (others => '0');
begin
	process(EN_IN, CLK, RESET)
	begin
		IF (RESET = '1') then
			v_out <= (others => '0');
		elsif(EN_IN = '1' and rising_edge(CLK)) then
			v_out <= INPUT;
		end if;
	end process;
	OUTPUT <= v_out when EN_OUT = '1' else (others => 'Z');
	N <= v_out(15);
	Z <= '1' when (unsigned(v_out) = 0) else '0';
end behav;