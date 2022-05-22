LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.numeric_std.all;

ENTITY Decode IS
	PORT(
		clk : IN std_logic;
		OpCode  : IN std_logic_vector(7 downto 0);
		RT  : IN std_logic_vector(31 downto 0);
		RS  : IN std_logic_vector(31 downto 0);
		Imm  : IN std_logic_vector(15 downto 0);
		Op1 : OUT std_logic_vector(31 downto 0);
		Op2 : OUT std_logic_vector(31 downto 0);
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
		
END ENTITY Decode;

ARCHITECTURE DecodeArch OF Decode IS
Component CU IS
	PORT(
		OpCode : IN  std_logic_vector(7 DOWNTO 0);
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
END Component;
	signal RegWsig:std_logic;
	signal Modesig:std_logic_vector(1 downto 0);
	signal ALUEsig:std_logic;
	signal Immsig:std_logic;
	signal Jmpsig:std_logic;
	signal IncSPsig:std_logic;
	signal DecSPsig:std_logic;
	signal PortWsig:std_logic;
	signal PortRsig:std_logic;
	signal MemWsig:std_logic;
	signal MemRsig:std_logic;
	signal SETCsig:std_logic;
	signal ChkCsig:std_logic;
	signal ChkNsig:std_logic;
	signal ChkZsig:std_logic;
	signal NoChksig:std_logic;
	BEGIN
	ctrl: CU port map(OpCode,RegWsig,Modesig,ALUEsig,Immsig,Jmpsig,IncSPsig,DecSPsig,PortWsig,PortRsig,MemWsig,MemRsig,SETCsig,ChkCsig,ChkNsig,ChkZsig,NoChksig);
		Process(clk)
		Begin
			IF rising_edge(clk) then
				Op1<=RT;
				if (Immsig='1') then
					Op2<=SXT(Imm,32);
				else
					Op2<=RS;
				end if;
				RegWrite<=RegWsig;
				Mode<=Modesig;
				AluEnable<=ALUEsig;
				Immediate<=Immsig;
				Jump<=Jmpsig;
				IncSP<=IncSPsig;
				DecSP<=DecSPsig;
				PortWrite<=PortWsig;
				PortRead<=PortRsig;
				MEMW<=MemWsig;
				MEMR<=MemRsig;
				SETC<=SETCsig;
				CheckC<=ChkCsig;
				CheckN<=ChkNsig;
				CheckZ<=ChkZsig;
				NoCheck<=NoChksig;
			END IF;
		END Process;
END DecodeArch;
