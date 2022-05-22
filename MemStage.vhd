LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY MEMWB IS
	PORT(
		clk : IN  std_logic;
		RegWrite : IN  std_logic;
		PortWrite : IN  std_logic;
		PortRead  : IN  std_logic;
		MemRead : IN std_logic;
		MemData : IN std_logic_vector(31 downto 0);
		IncSP  : IN  std_logic;
		DecSP  : IN  std_logic;
		Result  : IN  std_logic_vector(31 downto 0);
		RD : IN std_logic_vector(2 downto 0);
		AddressOut  : OUT  std_logic_vector(19 downto 0);
		RegWritebuf  : OUT std_logic;
		RDbuf  : OUT std_logic_vector(2 downto 0);
		DataOut  : OUT std_logic_vector(31 downto 0));
END ENTITY MEMWB;

ARCHITECTURE MEMWBArch OF MEMWB IS
	signal InPort : unsigned(31 downto 0) := (others=>'0');
	signal OutPort : unsigned(31 downto 0) := (others=>'0');
	signal StackPtr : unsigned(31 downto 0) := (others=>'0');
	BEGIN
		Process(clk)
		Begin
			IF rising_edge(clk) then
				IF MemRead='1' then
				DataOut<=MemData;
				ELSIF PortRead='1' then
				DataOut<=std_logic_vector(InPort);
				ELSE
				DataOut<=Result;
				END IF;
				IF IncSP = '1' then 
				StackPtr<=StackPtr+1;
				ELSIF DecSP='1' then
				StackPtr<=StackPtr-1;
				END IF;
				IF PortWrite='1' then
				OutPort<=unsigned(Result);
				END IF;
				RegWritebuf<=RegWrite;
				RDbuf<=RD;
			END IF;
		END Process;
		AddressOut<=std_logic_vector(StackPtr(19 downto 0)) when (IncSP or DecSP)='1'
		else Result(19 downto 0);
END MEMWBArch;
