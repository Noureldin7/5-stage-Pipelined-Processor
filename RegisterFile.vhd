LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY RegFile IS
	PORT(
		Add1 : IN  std_logic_vector(2 DOWNTO 0);
		Add2 : IN  std_logic_vector(2 DOWNTO 0);
		WAdd : IN  std_logic_vector(2 DOWNTO 0);
		DataIN : IN  std_logic_vector(31 DOWNTO 0);
		RegWrite : IN  std_logic;
		Clk : IN  std_logic;
		DataOUT1 : OUT  std_logic_vector(31 DOWNTO 0);
		DataOUT2 : OUT  std_logic_vector(31 DOWNTO 0));
END ENTITY RegFile;

ARCHITECTURE RegFileArch OF RegFile IS
	Type OutBus is array(0 to 7) of std_logic_vector(31 downto 0);
	Signal Enable:std_logic_vector(7 downto 0) := (others=>'0');	
	Signal DataOut : OutBus := (others=>(others=>'0'));
	Component Reg is
	Port(
		D: IN std_logic_vector(31 downto 0);
		Clk,Rst,Enable: IN std_logic;
		Q: OUT std_logic_vector(31 downto 0));
	End Component;
	begin
		Process(clk)
		Begin
		if rising_edge(clk) then
			if RegWrite='1' then
				DataOut(to_integer(unsigned(WAdd)))<=DataIN;
			END IF;
		END IF;
		END Process;
		DataOUT1<=DataOut(to_integer(unsigned(Add1)));
		DataOUT2<=DataOut(to_integer(unsigned(Add2)));
END RegFileArch;
