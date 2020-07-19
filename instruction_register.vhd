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

entity instruction_register is
  port( 
    CLK    : in  std_logic; -- Entrada de reloj
	 RESET  : in  std_logic; -- Entrada de reloj
    EN_IN  : in  std_logic; -- Habilitación de entrada al registro
    INPUT  : in  std_logic_vector (15 downto 0);-- entrada del registro
    OPCODE : out std_logic_vector (3 downto 0); -- Campo OPCODE del formato de instrucción
	 S 	  : out std_logic_vector (15 downto 0) -- Campo S del formato de instrucción
  );
end instruction_register;

architecture struct of instruction_register is

	signal regout: std_logic_vector (15 downto 0);

	component reg
		generic (
			BITS : integer
		);
		port ( 
			CLK	: in	std_logic;
			EN_IN	: in	std_logic;
			EN_OUT: in	std_logic;
			RESET : in	std_logic;
			INPUT	: in	std_logic_vector ((BITS - 1) downto 0);
			OUTPUT: out	std_logic_vector ((BITS - 1) downto 0)
		);
	end component;
	
begin

	IR_REG : reg
	generic map(
		BITS => 16
	)
	port map(
		CLK    => CLK,
		EN_IN  => EN_IN,
		EN_OUT => '1',
		RESET  => RESET,
		INPUT  => INPUT,
		OUTPUT => regout
	);
	
	OPCODE <= regout(15 downto 12);
	S <= "0000" & regout(11 downto 0);

end struct;