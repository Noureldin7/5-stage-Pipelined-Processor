LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_arith.ALL;
USE IEEE.numeric_std.all;
ENTITY FWDU IS
	PORT(
		SrcAdd1 : IN  std_logic_vector(2 DOWNTO 0);
		SrcAdd2 : IN  std_logic_vector(2 downto 0);
		OrgOp1 : IN  std_logic_vector(31 DOWNTO 0);
		OrgOp2 : IN  std_logic_vector(31 downto 0);
		DstALU : IN std_logic_vector(2 downto 0);
		DstMEM : IN std_logic_vector(2 downto 0);
		RegWALU : IN std_logic;
		RegWMEM : IN std_logic;
		Imm : IN std_logic;
		ALUBuff : IN std_logic_vector(31 downto 0);
		MemBuff : IN std_logic_vector(31 downto 0);
		Op1 : OUT std_logic_vector(31 downto 0);
		Op2 : OUT std_logic_vector(31 downto 0));
END ENTITY FWDU;

ARCHITECTURE FWDUArch OF FWDU IS
	BEGIN
		Op1<=ALUBuff when RegWALU='1'AND DstALU=SrcAdd1
		else MemBuff when RegWMEM='1'AND DstMEM=SrcAdd1
		else OrgOp1;
		Op2<=ALUBuff when RegWALU='1'AND DstALU=SrcAdd2 AND Imm='0'
		else MemBuff when RegWMEM='1'AND DstMEM=SrcAdd2 AND Imm='0'
		else OrgOp2;
END FWDUArch;