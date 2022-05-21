LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY CPU IS
	PORT(
		clk : IN std_logic;
		sel : IN std_logic;
		MemRead : IN std_logic;
		Enable : IN std_logic;
		Oride : IN  std_logic_vector(19 DOWNTO 0);
		rst : IN  std_logic;
		OpCode  : OUT std_logic_vector(7 downto 0);
		RD  : OUT std_logic_vector(3 downto 0);
		RT  : OUT std_logic_vector(3 downto 0);
		RS  : OUT std_logic_vector(3 downto 0);
		Imm  : OUT std_logic_vector(15 downto 0));
END ENTITY CPU;
ARCHITECTURE CPUArch OF CPU IS
	signal Address : std_logic_vector(19 downto 0);
	signal Ins : std_logic_vector(31 downto 0);
	Component Fetch IS
	PORT(
		Ins : IN  std_logic_vector(31 DOWNTO 0);
		Oride : IN  std_logic_vector(19 DOWNTO 0);
		clk  : IN  std_logic;
		rst  : IN  std_logic;
		MemRead  : IN  std_logic;
		sel  : IN  std_logic;
		Add : OUT std_logic_vector(19 downto 0);
		Enable  : IN  std_logic;
		OpCode  : OUT std_logic_vector(7 downto 0);
		RD  : OUT std_logic_vector(3 downto 0);
		RT  : OUT std_logic_vector(3 downto 0);
		RS  : OUT std_logic_vector(3 downto 0);
		Imm  : OUT std_logic_vector(15 downto 0));
	END Component;
	Component Memory IS
	PORT(
		clk : IN std_logic;
		MEMW  : IN std_logic;
		MEMR  : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
	END Component;
	BEGIN
	mem: Memory port map(clk,'0',MemRead,Address,(others=>'0'),Ins);
	fet: Fetch port map(Ins,Oride,clk,rst,MemRead,sel,Address,Enable,OpCode,RD,RT,RS,Imm);
END CPUArch;
