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

library ieee;
use ieee.std_logic_1164.all;

entity mu0 is
  port (
    CLK     : in  std_logic; -- Reloj del sistema
	 RESET   : in  std_logic; -- Reset
    DATA_IN : in  std_logic_vector (15 downto 0); -- Entrada de datos
    DATA_OUT: out std_logic_vector (15 downto 0); -- Salida de datos
    ADDR    : out std_logic_vector (11 downto 0); -- Salida de direcciones
    RD      : out std_logic; -- Lectuta desde la memoria
    WR      : out std_logic --  Escritura a la memoria
  );
end;

architecture struct of mu0 is

	signal sreset, sclk, srd, swr, sacc_in, sacc_out, spc_in, spc_out, sir_in, sasel, sysel, smd_out, sn, sz: std_logic;
	signal salu_ctrl: std_logic_vector (1 downto 0);
	signal sopcode: std_logic_vector (3 downto 0);

	component mu0_controlunit is
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
	end component;

	component mu0_datapath is
		port (
			RESET   : in  std_logic;
			CLK     : in  std_logic;
			
			DATA_IN : in  std_logic_vector (15 downto 0);
			DATA_OUT: out std_logic_vector (15 downto 0);
			ADDR    : out std_logic_vector (11 downto 0);

			ACC_IN : in std_logic;
			ACC_OUT: in std_logic;

			PC_IN : in std_logic;
			PC_OUT: in std_logic;

			IR_IN: in std_logic;

			ASEL: in std_logic;
			YSEL: in std_logic;
			MD_OUT: in std_logic;

			ALU_CTRL: in std_logic_vector (1 downto 0);
			OPCODE: out std_logic_vector (3 downto 0);

			N: out std_logic;
			Z: out std_logic
		);
	end component;
	
begin
	
	sclk <= CLK;
	sreset <= RESET;
	RD <= srd;
	WR <= swr;
	
	CU: mu0_controlunit 
		port map(
			RESET => sreset,
			CLK => sclk,
			RD => srd,
			WR => swr,
			ACC_IN => sacc_in,
			ACC_OUT => sacc_out,
			PC_IN => spc_in,
			PC_OUT => spc_out,
			IR_IN => sir_in,
			ASEL => sasel,
			YSEL => sysel,
			MD_OUT => smd_out,
			ALU_CTRL => salu_ctrl,
			OPCODE => sopcode,
			N => sn,
			Z => sz
		);
	
	DP: mu0_datapath
		port map(
			RESET => sreset,
			CLK => sclk,
			DATA_IN => DATA_IN,
			DATA_OUT => DATA_OUT,
			ADDR => ADDR,			
			ACC_IN => sacc_in,
			ACC_OUT => sacc_out,
			PC_IN => spc_in,
			PC_OUT => spc_out,
			IR_IN => sir_in,
			ASEL => sasel,
			YSEL => sysel,
			MD_OUT => smd_out,
			ALU_CTRL => salu_ctrl,
			OPCODE => sopcode,
			N => sn,
			Z => sz
		);

end struct;
