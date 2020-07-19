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

entity tb_computer is end;

architecture testbench of tb_computer is
  
	component computer
		port (
		 CLK : in std_logic;
		 RESET : in std_logic;
		 DATA : out std_logic_vector (15 downto 0);
		 ADDR : out std_logic_vector (11 downto 0);
		 RD: out std_logic;
		 WR: out std_logic
		 
	  );
	end component;
  
  -- signals
  signal sclk  : std_logic;
  signal sdata : std_logic_vector (15 downto 0);
  signal saddr : std_logic_vector (11 downto 0);
  signal sreset: std_logic;
  signal srd : std_logic;
  signal swr : std_logic;

  begin    
    uut : computer port map(
      CLK => sclk,
		RESET => sreset,
      DATA => sdata,
      ADDR => saddr,
		RD => srd,
		WR => swr
    );
    
    tb_clock : process --clock with 100ns timeperiod
    begin
      wait for 50 ns;
        sclk <= '1';
      wait for 50 ns;
        sclk <= '0';
    end process;
    
    --PROCESS : POWER UP RESET
   p_reset: process
   begin
      sreset <='1';
      wait for 400 ns;
      sreset <='0';
      wait;  --wait forever
   end process;
   
   -- because there is no external memory interface currently, the program has to be hard coded into the primary memory file.
   
 end testbench;