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
use IEEE.numeric_std.all;

entity alu is
  port (
	 IN_X: in std_logic_vector (15 downto 0); -- Entrada A de la ALU
    IN_Y: in std_logic_vector (15 downto 0); -- Entrada B de la ALU
	 OP  : in std_logic_vector (1 downto 0); -- Entrada de selección de operación ALU
    C_OUT : out std_logic; -- Salida de acarreo de la ALU
	 OUTPUT: out std_logic_vector (15 downto 0) -- Salida de la ALU
  );
end;

architecture struct of alu is
	-- Declaración de señales internas
	signal pr_x: std_logic_vector (15 downto 0);
	signal pr_y: std_logic_vector (15 downto 0);
	signal sx: std_logic;
	signal sy: std_logic;
	signal siy: std_logic;
	signal cin: std_logic;
	-- Declaración de componentes
	component carry_ripple_adder
		generic (
			BITS : integer
		);
		port (
			OP1		 : in	 std_logic_vector((BITS - 1) downto 0);
			OP2		 : in	 std_logic_vector((BITS - 1) downto 0);
			CIN		 : in	 std_logic;
			SUM		 : out std_logic_vector((BITS - 1) downto 0);
			COUT		 : out std_logic
		);
	end component;	
begin
	
	sx  <= OP(1) or OP(0);
	sy  <= not(OP(1));
	siy <= OP(1) and OP(0);
	cin <= OP(1);
	
	pr_x <= IN_X when sx = '1' else (others=>'0');
	
	pr_y <= IN_Y when sy = '1' else 
			not(IN_Y) when siy = '1' else 
			(others=>'0');
	
	ALU_ADD: carry_ripple_adder
	generic map(
		BITS => 16
	)
	port map (
		OP1 => pr_x,
		OP2 => pr_y,
		CIN => cin,
		SUM => OUTPUT,
		COUT => C_OUT
	);
	
end struct;
