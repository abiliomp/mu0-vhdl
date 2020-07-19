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

entity mu0_datapath is
	port (
		RESET   : in  std_logic; -- Reset
		CLK     : in  std_logic; -- Reloj del sistema
		
		-- Interfaz con la Memoria
		DATA_IN : in  std_logic_vector (15 downto 0); -- Entrada de datos
		DATA_OUT: out std_logic_vector (15 downto 0); -- Salida de datos
		ADDR    : out std_logic_vector (11 downto 0); -- Salida de direcciones
		
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
end;

architecture struct of mu0_datapath is
	-- ----------------------------------------------------------------------------
	-- DECLARACIÓN DE COMPONENTES DEL SISTEMA
	component alu is
		port (
			 IN_X: in std_logic_vector (15 downto 0);
			 IN_Y: in std_logic_vector (15 downto 0);
			 OP  : in std_logic_vector (1 downto 0);
			 C_OUT : out std_logic;
			 OUTPUT: out std_logic_vector (15 downto 0)
		);
	end component;
	
	component instruction_register is
		port( 
			CLK    : in  std_logic;
			RESET  : in  std_logic;
			EN_IN  : in  std_logic;
			INPUT  : in  std_logic_vector (15 downto 0);
			OPCODE : out std_logic_vector (3 downto 0);
			S      : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component program_counter is
		port( 
			CLK    : in  std_logic;
			RESET  : in  std_logic;
			EN_IN  : in  std_logic;
			EN_OUT : in  std_logic;
			INPUT  : in  std_logic_vector (15 downto 0);
			OUTPUT : out std_logic_vector (15 downto 0)
		);
	end component;
	
	component accumulator is
		port( 
			CLK    : in  std_logic;
			RESET  : in  std_logic;
			EN_IN  : in  std_logic;
			EN_OUT : in  std_logic;
			INPUT  : in  std_logic_vector (15 downto 0);
			OUTPUT : out std_logic_vector (15 downto 0);
			N: out std_logic;
			Z: out std_logic
		);
	end component;
	
	
	-- ----------------------------------------------------------------------------
   -- DECLARACIÓN DE SEÑALES INTERNAS
	signal alu_output: std_logic_vector (15 downto 0);
	signal ir_output : std_logic_vector (15 downto 0);
	signal alu_y 	  : std_logic_vector (15 downto 0);
	signal d_out 	  : std_logic_vector (15 downto 0);
	SIGNAL alu_c	  : std_logic;
	
begin

	ADDR <= ir_output(11 downto 0) when ASEL = '1' else
			  d_out(11 downto 0);
			  
	alu_y <= DATA_IN when YSEL = '1' else ir_output;
			  
	DATA_OUT <= d_out when MD_OUT = '1' else (others => 'Z');

	ALUC: alu
		port map(
			IN_X => d_out,
			IN_Y => alu_y,
			OP => ALU_CTRL,
			C_OUT => alu_c,
			OUTPUT => alu_output
		);

	IR: instruction_register
		port map( 
			CLK => CLK,
			RESET => RESET,
			EN_IN => IR_IN,
			INPUT => DATA_IN,
			OPCODE => OPCODE,
			S => ir_output
		);
	
	ACC: accumulator
		port map( 
			CLK => CLK,
			RESET => RESET,
			EN_IN => ACC_IN,
			EN_OUT => ACC_OUT,
			INPUT => alu_output,
			OUTPUT => d_out,
			N => N,
			Z => Z
		);
	
	PC: program_counter
		port map( 
			CLK => CLK,
			RESET => RESET,
			EN_IN => PC_IN,
			EN_OUT => PC_OUT,
			INPUT => alu_output,
			OUTPUT => d_out
		);
		



end struct;