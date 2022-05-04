LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_arith.ALL;
USE IEEE.numeric_std.all;
ENTITY FWDU IS
	PORT(
		SrcAdd1 : IN  std_logic_vector(2 DOWNTO 0);
		SrcAdd2 : IN  std_logic_vector(2 downto 0);
		SrcVal1 : IN  std_logic_vector(31 DOWNTO 0);
		SrcVal2 : IN  std_logic_vector(31 downto 0);
		DstALU : IN std_logic_vector(2 downto 0);
		DstMEM : IN std_logic_vector(2 downto 0);
		RegWALU : IN std_logic;
		RegWMEM : IN std_logic;
		Imm : IN std_logic;
		ImmVal : IN std_logic_vector(15 downto 0);
		ALUBuff : IN std_logic_vector(31 downto 0);
		MemBuff : IN std_logic_vector(31 downto 0);
		Op1 : OUT std_logic_vector(31 downto 0);
		Op2 : OUT std_logic_vector(31 downto 0));
END ENTITY FWDU;

ARCHITECTURE FWDUArch OF FWDU IS
	BEGIN
		Op1<=ALUBuff when RegWALU='1'AND DstALU=SrcAdd1
		else MemBuff when RegWMEM='1'AND DstMEM=SrcAdd1
		else SrcVal1;
		Op2<=SXT(ImmVal,32) when Imm='1'
		else ALUBuff when RegWALU='1'AND DstALU=SrcAdd2
		else MemBuff when RegWMEM='1'AND DstMEM=SrcAdd2
		else SrcVal2;
END FWDUArch;