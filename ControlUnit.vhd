LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY CU IS
	PORT(
		OpCode : IN  std_logic_vector(6 DOWNTO 0);
		RegWrite : OUT  std_logic;
		Mode : OUT std_logic_vector(1 downto 0);
		ALUEnable : OUT  std_logic;
		Immediate : OUT std_logic;
		Jump : OUT std_logic;
		IncSP : OUT std_logic;
		DecSP : OUT std_logic;
		PortWrite : OUT std_logic;
		PortRead : OUT std_logic;
		MEMW : OUT std_logic;
		MEMR : OUT std_logic;
		SETC : OUT std_logic;
		CheckC : OUT std_logic;
		CheckN : OUT std_logic;
		CheckZ : OUT std_logic;
		NoCheck : OUT std_logic);
END ENTITY CU;

ARCHITECTURE CUArch OF CU IS
	Signal jmp:std_logic := '0';
	Signal PortEn:std_logic := '0';
	BEGIN
		RegWrite<=OpCode(3);
		Immediate<=OpCode(6);
		Mode(1)<=OpCode(3) AND OpCode(1);
		Mode(0)<=OpCode(2) XOR OpCode(1);
		SETC<=OpCode(2) AND OpCode(1) AND (NOT OpCode(0));
		jmp<=(OpCode(6) OR OpCode(5)) AND OpCode(4);
		Jump<=jmp;
		IncSP<=OpCode(0) when OpCode(6 downto 5)=("01")
		else '0';
		DecSP<= Not OpCode(0) when OpCode(6 downto 5)=("01")
		else '0';
		CheckC<='1' when (jmp AND (OpCode(5) XNOR OpCode(2)))='1' AND OpCode(1 downto 0)=("10")
		else '0';
		CheckZ<='1' when (jmp AND (OpCode(5) XNOR OpCode(2)))='1' AND OpCode(1 downto 0)=("00")
		else '0';
		CheckN<='1' when (jmp AND (OpCode(5) XNOR OpCode(2)))='1' AND OpCode(1 downto 0)=("01")
		else '0';
		NoCheck<='1' when (jmp AND (OpCode(5) XNOR OpCode(2)))='1' AND OpCode(1 downto 0)=("11")
		else '0';
		PortEn<='1' when OpCode(6 downto 4)=("001")
		else '0';
		PortWrite<=OpCode(0) when PortEn='1'
		else '0';
		PortRead<= Not OpCode(0) when PortEn='1'
		else '0';
		MEMW<=OpCode(1) when OpCode(5)='1'
		else '0';
		MEMR<= NOT OpCode(1) when OpCode(5)='1'
		else '0';
		ALUEnable<='1' when OpCode=("0001001") or OpCode=("0001101") or OpCode=("0001011") or OpCode=("1001001")
		else '1' when OpCode=("0001111") or OpCode=("0001000")
		else '1' when OpCode=("1101001") or OpCode=("1100111")
		else '0';
END CUArch;
