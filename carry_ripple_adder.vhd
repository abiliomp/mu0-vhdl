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

entity carry_ripple_adder is

	generic (
		BITS : integer := 32
	);
	
	port (
		OP1		 : in	 std_logic_vector((BITS - 1) downto 0);
		OP2		 : in	 std_logic_vector((BITS - 1) downto 0);
		CIN		 : in	 std_logic;
		SUM		 : out std_logic_vector((BITS - 1) downto 0);
		COUT		 : out std_logic
	);
	
end carry_ripple_adder;

architecture struct of carry_ripple_adder is

	component full_adder is
		port (
			OP1		 : in	 std_logic;
			OP2		 : in	 std_logic;
			CIN		 : in	 std_logic;
			SUM		 : out std_logic;
			COUT		 : out std_logic
		);
	end component;
	
	signal carries : std_logic_vector((BITS) downto 0);
	
begin

	carries(0) <= cin;
	
	FA: for i in 0 to (BITS - 1) generate
		FAX : full_adder port map (OP1(i), OP2(i), carries(i), SUM(i), carries(i+1));
	end generate FA;
	
	COUT <= carries(BITS);
				 
end struct;