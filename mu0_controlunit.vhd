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

entity mu0_controlunit is
	port(
		RESET   : in  std_logic;
		CLK     : in  std_logic;

		RD      : out std_logic;
		WR      : out std_logic;

		ACC_IN : out std_logic;
		ACC_OUT: out std_logic;

		PC_IN : out std_logic;
		PC_OUT: out std_logic;

		IR_IN: out std_logic;

		ASEL: out std_logic;
		YSEL: out std_logic;
		MD_OUT: out std_logic;

		ALU_CTRL: out std_logic_vector (1 downto 0);
		OPCODE: in std_logic_vector (3 downto 0);

		N: in std_logic;
		Z: in std_logic
	);
end;

architecture struct of mu0_controlunit is
	signal next_state : std_logic;
	signal curr_state : std_logic;
	signal ctrl_out : std_logic_vector(12 downto 0);
begin
	
	ctrl_out <= "1110100100010" when curr_state = '0' else
					"0001000011010" when OPCODE = "0000" else
					"0000001001101" when OPCODE = "0001" else
					"0001011011010" when OPCODE = "0010" else
					"0001111011010" when OPCODE = "0011" else
					"0010000000000" when OPCODE = "0100" else
					"00" & not(N) & "0000000000" when OPCODE = "0101" else
					"00" & not(Z) & "0000000000" when OPCODE = "0110" else
					"1000000000000";
					
	next_state <= ctrl_out(12);
	IR_IN <= ctrl_out(11);
	PC_IN <= ctrl_out(10);
	ACC_IN <= ctrl_out(9);
	ALU_CTRL <= ctrl_out(8 downto 7);
	ACC_OUT <= ctrl_out(6);
	PC_OUT <= ctrl_out(5);
	YSEL <= ctrl_out(4);
	ASEL <= ctrl_out(3);
	ASEL <= ctrl_out(3);
	MD_OUT <= ctrl_out(2);
	RD <= ctrl_out(1);
	WR <= ctrl_out(0);
	
	state_trans : process(CLK, RESET) -- Proceso de transición de estado
	begin
		IF (RESET = '1') then
			curr_state <= '0';
		elsif(rising_edge(CLK)) then 
			curr_state <= next_state;
		end if;
	end process;

end architecture;