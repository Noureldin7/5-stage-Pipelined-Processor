LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS
	PORT(
		clk : IN std_logic;
		MEMW  : IN std_logic;
		MEMR  : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY Memory;

ARCHITECTURE MemoryArch OF Memory IS

	TYPE memory_type IS ARRAY(0 TO 1048575) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL Memory : memory_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF MEMW = '1' THEN
						Memory(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= Memory(to_integer(unsigned(address))) when MEMR='1';
END MemoryArch;
