-----------------------------------------
--- Universidad Nacional de Asunción ----
-------- Facultad de Ingeniería ---------
--- Carrera de Ingeniería Electrónica ---
---- Cátedra de Sistemas Digitales 2 ----
-----------------------------------------

-- Autor: Abilio Mancuello Petters
-- Fecha: Jul/2020

library IEEE;
use IEEE.std_logic_1164.all;

entity reg is
	generic (
		BITS : integer := 8
	);
	port ( 
		CLK	: in	std_logic;
		EN_IN	: in	std_logic;
		EN_OUT: in	std_logic;
		RESET : in	std_logic;
		INPUT	: in	std_logic_vector ((BITS - 1) downto 0);
		OUTPUT: out	std_logic_vector ((BITS - 1) downto 0)
	);
end reg;

architecture behav of reg is
	signal v_out : std_logic_vector ((BITS - 1) downto 0) := (others => '0');
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
end behav;