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
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity memory is
  port (
    CLK : in std_logic;
    RD  : in std_logic;
    WR  : in std_logic;
    ADDR: in std_logic_vector(11 downto 0);
    DATA_IN : in std_logic_vector(15 downto 0);
    DATA_OUT: out std_logic_vector(15 downto 0)
  );
end entity memory;

architecture behavioural of memory is

   type ram_type is array (0 to 1048) of std_logic_vector(DATA_IN'range);
   signal ram : ram_type := 
   (
    -- INSTRUCCIONES
    -- Empezar con 0 en ACC, sumar &33, &34 veces y guardar el resultado en 16.
    0 => "0000000000010000", -- LDA 16 -- Cargar el contenido de 16
    1 => "0010000000100001", -- ADD 33 -- sumar el contenido de 33
    2 => "0001000000010000", -- STO 16 -- Guardar el resultado en 16
    3 => "0000000000100010", -- LDA 34 -- Cargar el contenido de 34
    4 => "0011000000100011", -- SUB 35 -- Restar el contenido de 35 (1)
    5 => "0001000000100010", -- STO 34 -- Guardar el nuevo valor de 34 (contador)
    6 => "0110000000000000", -- JNE 0  -- Volver al inicio si es diferente de 0
    7 => "0111000000000000", -- STOP - FIN
    -- DATOS (4 x 8 = 32)
	 16 => x"0000", -- 0
    33 => x"0004", -- 4
    34 => x"0008", -- 8 (contador del bucle)
    35 => x"0001", -- 1 (decrementar el valor)
    others => x"0000"
   );
begin

  datain: process(CLK, ADDR, WR) is
  begin
    if rising_edge(CLK) then
      if (WR = '1') then -- write
        ram(to_integer(unsigned(ADDR))) <= DATA_IN;
      end if;      
    end if;
  end process datain;
  
	dataout: process(CLK, ADDR, DATA_IN, RD, WR) --change the output aysnc
		variable op : std_logic_vector (1 downto 0);
	begin
		op := RD & WR;
		case op is
			when "10" => DATA_OUT <= ram(to_integer(unsigned(ADDR)));
			when others => DATA_OUT <= "ZZZZZZZZZZZZZZZZ";
		end case;
	end process dataout;
  
end architecture behavioural ;
