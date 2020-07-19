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

entity full_adder is
	port (
		OP1		 : in	 std_logic;
		OP2		 : in	 std_logic;
		CIN		 : in	 std_logic;
		SUM		 : out std_logic;
		COUT		 : out std_logic
	);
end full_adder;

architecture struct of full_adder is	
begin

	SUM <= OP1 XOR OP2 XOR CIN;

	COUT <= (OP1 AND OP2) OR (CIN AND OP1) OR (CIN AND OP2);
				 
end struct;