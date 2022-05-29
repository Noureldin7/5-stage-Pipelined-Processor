LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CU IS
	PORT (
		OpCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		RegWrite : OUT STD_LOGIC;
		Mode : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALUEnable : OUT STD_LOGIC;
		Immediate : OUT STD_LOGIC;
		Jump : OUT STD_LOGIC;
		IncSP : OUT STD_LOGIC;
		DecSP : OUT STD_LOGIC;
		PortWrite : OUT STD_LOGIC;
		PortRead : OUT STD_LOGIC;
		MEMW : OUT STD_LOGIC;
		MEMR : OUT STD_LOGIC;
		SETC : OUT STD_LOGIC;
		Checks : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END ENTITY CU;

ARCHITECTURE CUArch OF CU IS
	SIGNAL jmp : STD_LOGIC := '0';
	SIGNAL PortEn : STD_LOGIC := '0';
BEGIN
	RegWrite <= OpCode(3);
	Immediate <= OpCode(6);
	Mode(1) <= OpCode(3) AND OpCode(1);
	Mode(0) <= OpCode(2) XOR OpCode(1);
	SETC <= OpCode(2) AND OpCode(1) AND (NOT OpCode(0));
	jmp <= (OpCode(6) OR OpCode(5)) AND OpCode(4);
	Jump <= jmp;
	IncSP <= '1' WHEN OpCode = "0110000"
		ELSE
		OpCode(0) WHEN OpCode(6 DOWNTO 5) = ("01")
		ELSE
		'0';
	DecSP <= NOT OpCode(0) WHEN OpCode(6 DOWNTO 5) = ("01")
		ELSE
		'1' WHEN OpCode = "1100010"
		ELSE
		'0';
	Checks <= OpCode(1 DOWNTO 0) WHEN (jmp AND (OpCode(5) XNOR OpCode(2))) = '1'
		ELSE
		(OTHERS => '1');
	PortEn <= '1' WHEN OpCode(6 DOWNTO 4) = ("001")
		ELSE
		'0';
	PortWrite <= OpCode(0) WHEN PortEn = '1'
		ELSE
		'0';
	PortRead <= NOT OpCode(0) WHEN PortEn = '1'
		ELSE
		'0';
	MEMW <= OpCode(1) WHEN OpCode(5) = '1'
		ELSE
		'0';
	MEMR <= NOT OpCode(1) WHEN OpCode(5) = '1'
		ELSE
		'0';
	ALUEnable <= '1' WHEN OpCode = ("0001001") OR OpCode = ("0001101") OR OpCode = ("0001011") OR OpCode = ("1001001")
		ELSE
		'1' WHEN OpCode = ("0001111") OR OpCode = ("1001000")
		ELSE
		'1' WHEN OpCode = ("1101001") OR OpCode = ("1100111")
		ELSE
		'0';
END CUArch;