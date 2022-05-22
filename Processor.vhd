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
		RD  : OUT std_logic_vector(2 downto 0);
		Op1  : OUT std_logic_vector(31 downto 0);
		Op2  : OUT std_logic_vector(31 downto 0);
		Imm  : OUT std_logic_vector(15 downto 0));
END ENTITY CPU;
ARCHITECTURE CPUArch OF CPU IS
	signal Addresssig : std_logic_vector(19 downto 0);
	signal Inssig : std_logic_vector(31 downto 0);
	signal OpCodesig  : std_logic_vector(7 downto 0);
	signal RDsig  : std_logic_vector(2 downto 0);
	signal RTsig  : std_logic_vector(2 downto 0);
	signal RSsig  : std_logic_vector(2 downto 0);
	signal RTval  : std_logic_vector(31 downto 0);
	signal RSval  : std_logic_vector(31 downto 0);
	signal Immsig  : std_logic_vector(15 downto 0);
	Signal Op1sig : std_logic_vector(31 downto 0);
	Signal Op2sig : std_logic_vector(31 downto 0);
	Signal RegWritesig :  std_logic;
	Signal Modesig : std_logic_vector(1 downto 0);
	Signal ALUEnablesig :  std_logic;
	Signal Immediatesig : std_logic;
	Signal Jumpsig : std_logic;
	Signal IncSPsig : std_logic;
	Signal DecSPsig : std_logic;
	Signal PortWritesig : std_logic;
	Signal PortReadsig : std_logic;
	Signal MEMWsig : std_logic;
	Signal MEMRsig : std_logic;
	Signal SETCsig : std_logic;
	Signal CheckCsig : std_logic;
	Signal CheckNsig : std_logic;
	Signal CheckZsig : std_logic;
	Signal NoChecksig : std_logic;
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
		RD  : OUT std_logic_vector(2 downto 0);
		RT  : OUT std_logic_vector(2 downto 0);
		RS  : OUT std_logic_vector(2 downto 0);
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
	Component Decode IS
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
	END Component;
	Component RegFile IS
	PORT(
		Add1 : IN  std_logic_vector(2 DOWNTO 0);
		Add2 : IN  std_logic_vector(2 DOWNTO 0);
		WAdd : IN  std_logic_vector(2 DOWNTO 0);
		DataIN : IN  std_logic_vector(31 DOWNTO 0);
		RegWrite : IN  std_logic;
		Clk : IN  std_logic;
		DataOUT1 : OUT  std_logic_vector(31 DOWNTO 0);
		DataOUT2 : OUT  std_logic_vector(31 DOWNTO 0));
	END Component;
	BEGIN
	mem: Memory port map(clk,'0',MemRead,Addresssig,(others=>'0'),Inssig);
	fet: Fetch port map(Inssig,Oride,clk,rst,MemRead,sel,Addresssig,Enable,OpCodesig,RD,RTsig,RSsig,Immsig);
	reg: RegFile port map(RTsig,RSsig,(others=>'0'),(others=>'0'),RegWritesig,clk,RTval,RSval);
	dec: Decode port map(clk,OpCodesig,RTval,RSval,Immsig,Op1,Op2,RegWritesig,Modesig,ALUEnablesig,Immediatesig,Jumpsig,IncSPsig,DecSPsig,PortWritesig,PortReadsig,MEMWsig,MEMRsig,SETCsig,CheckCsig,CheckNsig,CheckZsig,NoChecksig);
END CPUArch;
