LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY CPU IS
	PORT(
		clk : IN std_logic;
		sel : IN std_logic;
		Enable : IN std_logic;
		Oride : IN  std_logic_vector(19 DOWNTO 0);
		rst : IN  std_logic;
		Result  : OUT std_logic_vector(31 downto 0);
		Carry  : OUT std_logic;
		Zero  : OUT std_logic;
		Negative  : OUT std_logic);
END ENTITY CPU;
ARCHITECTURE CPUArch OF CPU IS
	signal Addressbuffet : std_logic_vector(19 downto 0) := (others=>'0');
	signal Addressbufmem : std_logic_vector(19 downto 0) := (others=>'0');
	signal Addresssig : std_logic_vector(19 downto 0) := (others=>'0');
	Signal ALUEnablesig :  std_logic := '0';
	Signal CheckCsig : std_logic := '0';
	Signal CheckNsig : std_logic := '0';
	Signal CheckZsig : std_logic := '0';
	Signal CheckCsigEx : std_logic := '0';
	Signal CheckNsigEx : std_logic := '0';
	Signal CheckZsigEx : std_logic := '0';
	Signal DataINbuf : std_logic_vector(31 downto 0) := (others=>'0');
	Signal DecSPsig : std_logic := '0';
	Signal DecSPsigEx : std_logic := '0';
	Signal Immediatesig : std_logic := '0';
	Signal ImmediatesigEx : std_logic := '0';
	signal Immsig  : std_logic_vector(15 downto 0) := (others=>'0');
	signal ImmsigEx  : std_logic_vector(15 downto 0) := (others=>'0');
	Signal IncSPsig : std_logic := '0';
	Signal IncSPsigEx : std_logic := '0';
	Signal Jumpsig : std_logic := '0';
	Signal JumpsigEx : std_logic := '0';
	signal MemDataOut : std_logic_vector(31 downto 0) := (others=>'0');
	Signal MEMRsig : std_logic := '0';
	Signal MEMRsigEx : std_logic := '0';
	Signal MEMWsig : std_logic := '0';
	Signal MEMWsigEx : std_logic := '0';
	Signal Modesig : std_logic_vector(1 downto 0) := (others=>'0');
	Signal NoChecksig : std_logic := '0';
	Signal NoChecksigEx : std_logic := '0';
	signal OpCodesig  : std_logic_vector(6 downto 0) := (others=>'0');
	Signal Op1sig : std_logic_vector(31 downto 0) := (others=>'0');
	Signal Op2sig : std_logic_vector(31 downto 0) := (others=>'0');
	Signal PortReadsig : std_logic := '0';
	Signal PortReadsigEx : std_logic := '0';
	Signal PortWritesig : std_logic := '0';
	Signal PortWritesigEx : std_logic := '0';
	signal RDsig  : std_logic_vector(2 downto 0) := (others=>'0');
	signal RDsigbuf  : std_logic_vector(2 downto 0) := (others=>'0');
	signal RDsigbuf2  : std_logic_vector(2 downto 0) := (others=>'0');
	signal RDsigbufend  : std_logic_vector(2 downto 0) := (others=>'0');
	Signal RegWritesig :  std_logic := '0';
	Signal RegWritesigEx :  std_logic := '0';
	Signal RegWritesigend :  std_logic := '0';
	Signal Resultsig :  std_logic_vector(31 downto 0) := (others=>'0');
	signal RSsig  : std_logic_vector(2 downto 0) := (others=>'0');
	signal RSval  : std_logic_vector(31 downto 0) := (others=>'0');
	signal RSvalbuf  : std_logic_vector(31 downto 0) := (others=>'0');
	signal RSvalbuf2  : std_logic_vector(31 downto 0) := (others=>'0');
	signal RTsig  : std_logic_vector(2 downto 0) := (others=>'0');
	signal RTval  : std_logic_vector(31 downto 0) := (others=>'0');
	Signal SETCsig : std_logic := '0';
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
		OpCode  : OUT std_logic_vector(6 downto 0);
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
		OpCode  : IN std_logic_vector(6 downto 0);
		RD : IN std_logic_vector(2 downto 0);
		RT  : IN std_logic_vector(31 downto 0);
		RS  : IN std_logic_vector(31 downto 0);
		Imm  : IN std_logic_vector(15 downto 0);
		RDbuf : OUT std_logic_vector(2 downto 0);
		RSbuf : OUT std_logic_vector(31 downto 0);
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
	Component Execute IS
	PORT(
		clk : IN std_logic;
		RD : IN std_logic_vector(2 downto 0);
		RS : IN std_logic_vector(31 downto 0);
		Op1 : IN  std_logic_vector(31 DOWNTO 0);
		Op2  : IN  std_logic_vector(31 DOWNTO 0);
		RegWrite : IN  std_logic;
		Mode : IN std_logic_vector(1 downto 0);
		ALUEnable : IN  std_logic;
		Immediate : IN std_logic;
		Jump : IN std_logic;
		IncSP : IN std_logic;
		DecSP : IN std_logic;
		PortWrite : IN std_logic;
		PortRead : IN std_logic;
		MemWrite : IN std_logic;
		MemRead : IN std_logic;
		SETC : IN std_logic;
		CheckC : IN std_logic;
		CheckN : IN std_logic;
		CheckZ : IN std_logic;
		NoCheck : IN std_logic;
		RDbuf : OUT std_logic_vector(2 downto 0);
		RSbuf : OUT std_logic_vector(31 downto 0);
		RegWritebuf : OUT  std_logic;
		Immediatebuf : OUT std_logic;
		Jumpbuf : OUT std_logic;
		IncSPbuf : OUT std_logic;
		DecSPbuf : OUT std_logic;
		PortWritebuf : OUT std_logic;
		PortReadbuf : OUT std_logic;
		MEMWbuf : OUT std_logic;
		MEMRbuf : OUT std_logic;
		CheckCbuf : OUT std_logic;
		CheckNbuf : OUT std_logic;
		CheckZbuf : OUT std_logic;
		NoCheckbuf : OUT std_logic;
		Result : OUT std_logic_vector(31 DOWNTO 0);
		Carry : OUT std_logic;
		Zero : OUT std_logic;
		Negative : OUT std_logic);
	END Component;
	Component MEMWB IS
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
	END Component;
	BEGIN
	Addresssig<=Addressbufmem when (MEMWsigEx or MEMRsigEx)='1'
	else Addressbuffet;
	mem: Memory port map(clk,MEMWsigEx,MEMRsigEx,Addresssig,RSvalbuf2, MemDataOut);
	fet: Fetch port map( MemDataOut,Oride,clk,rst,MEMRsigEx,sel,Addressbuffet,Enable,OpCodesig,RDsig,RTsig,RSsig,Immsig);
	reg: RegFile port map(RTsig,RSsig,RDsigbufend,DataINbuf,RegWritesigend,clk,RTval,RSval);
	dec: Decode port map(clk,OpCodesig,RDsig,RTval,RSval,Immsig,RDsigbuf,RSvalbuf,Op1sig,Op2sig,RegWritesig,Modesig,ALUEnablesig,Immediatesig,Jumpsig,IncSPsig,DecSPsig,PortWritesig,PortReadsig,MEMWsig,MEMRsig,SETCsig,CheckCsig,CheckNsig,CheckZsig,NoChecksig);
	ex: Execute port map(clk,RDsigbuf,RSvalbuf,Op1sig,Op2sig,RegWritesig,Modesig,ALUEnablesig,Immediatesig,Jumpsig,IncSPsig,DecSPsig,PortWritesig,PortReadsig,MEMWsig,MEMRsig,SETCsig,CheckCsig,CheckNsig,CheckZsig,NoChecksig,RDsigbuf2,RSvalbuf2,RegWritesigEx,ImmediatesigEx,JumpsigEx,IncSPsigEx,DecSPsigEx,PortWritesigEx,PortReadsigEx,MEMWsigEx,MEMRsigEx,CheckCsigEx,CheckNsigEx,CheckZsigEx,NoChecksigEx,Resultsig,Carry,Zero,Negative);
	memoryWB: MEMWB port map(clk,RegWritesigEx,PortWritesigEx,PortReadsigEx,MEMRsigEx,MemDataOut,IncSPsigEx,DecSPsigEx,Resultsig,RDsigbuf2,Addressbufmem,RegWritesigend,RDsigbufend,DataINbuf);
END CPUArch;
