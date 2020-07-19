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

entity computer is
  port (
    CLK : in std_logic;
	 RESET : in std_logic;
    DATA : out std_logic_vector (15 downto 0);
    ADDR : out std_logic_vector (11downto 0);
	 RD: out std_logic;
	 WR: out std_logic
  );
end;
    
architecture struct of computer is
  
	component mu0
		port (
			CLK     : in std_logic;
			RESET   : in std_logic;
			DATA_IN : in std_logic_vector(15 downto 0);
			DATA_OUT: out std_logic_vector(15 downto 0);
			ADDR    : out std_logic_vector(11 downto 0);
			RD 	  : out std_logic;
			WR      : out std_logic
		);
	end component;  
  
	component memory
		port (
			CLK : in std_logic;
			RD  : in std_logic;
			WR  : in std_logic;
			ADDR: in std_logic_vector(11 downto 0);
			DATA_IN : in std_logic_vector(15 downto 0);
			DATA_OUT: out std_logic_vector(15 downto 0)
		);
	end component;
  
  signal srd : std_logic;
  signal swr : std_logic;
  signal saddr : std_logic_vector (11 downto 0);
  signal sdata : std_logic_vector (15 downto 0);
  
  begin
  
  ADDR <= saddr;
  DATA <= sdata;
  RD <= srd;
  WR <= swr;
  
  processor : mu0 port map(
    CLK => CLK,
	 RESET => RESET,
    DATA_OUT => sdata,
    DATA_IN => sdata,
    ADDR => saddr,
    RD => srd,
    WR => swr
  );
  
  mem : memory port map(
    CLK => CLK,
	 RD => srd,
    WR => swr,
    ADDR => saddr,
    DATA_IN => sdata,
    DATA_OUT => sdata
  );
  
end struct;