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
	Signal Enable:std_logic_vector(7 downto 0);	
	Signal DataOut:OutBus;
	Component Reg is
	Port(
		D: IN std_logic_vector(31 downto 0);
		Clk,Rst,Enable: IN std_logic;
		Q: OUT std_logic_vector(31 downto 0));
	End Component;
	begin
		registers:
		for i in 0 to 7 generate
			Regs:Reg port map(DataIN,Clk,'0',Enable(i),DataOut(i));
	end generate registers;
		Enable<=("00000001") when WAdd=("000") AND RegWrite='1'
		else ("00000010") when WAdd=("001") AND RegWrite='1'
		else ("00000100") when WAdd=("010") AND RegWrite='1'
		else ("00001000") when WAdd=("011") AND RegWrite='1'
		else ("00010000") when WAdd=("100") AND RegWrite='1'
		else ("00100000") when WAdd=("101") AND RegWrite='1'
		else ("01000000") when WAdd=("110") AND RegWrite='1'
		else ("10000000") when WAdd=("111") AND RegWrite='1'
		else ("00000000") when RegWrite='0';
		DataOUT1<=DataOut(to_integer(unsigned(Add1)));
		DataOUT2<=DataOut(to_integer(unsigned(Add2)));
END RegFileArch;
