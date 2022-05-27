LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Carry : OUT STD_LOGIC;
		Zero : OUT STD_LOGIC;
		Negative : OUT STD_LOGIC);
END ENTITY CPU;
ARCHITECTURE CPUArch OF CPU IS
	SIGNAL Addressbuffet : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Addressbufmem : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Addresssig : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALUEnablesig : STD_LOGIC := '0';
	SIGNAL Checksig : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ChecksigEx : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DataINbuf : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DecSPsig : STD_LOGIC := '0';
	SIGNAL DecSPsigEx : STD_LOGIC := '0';
	SIGNAL Enable : STD_LOGIC := '1';
	SIGNAL Immediatesig : STD_LOGIC := '0';
	SIGNAL ImmediatesigEx : STD_LOGIC := '0';
	SIGNAL Immsig : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ImmsigEx : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL IncSPsig : STD_LOGIC := '0';
	SIGNAL IncSPsigEx : STD_LOGIC := '0';
	SIGNAL Jumpsig : STD_LOGIC := '0';
	SIGNAL JumpsigEx : STD_LOGIC := '0';
	SIGNAL MemDataOut : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MEMRsig : STD_LOGIC := '0';
	SIGNAL MEMRsigEx : STD_LOGIC := '0';
	SIGNAL MEMWsig : STD_LOGIC := '0';
	SIGNAL MEMWsigEx : STD_LOGIC := '0';
	SIGNAL Modesig : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL OpCodesig : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op1sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op2sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op1sigfwd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op2sigfwd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL PortReadsig : STD_LOGIC := '0';
	SIGNAL PortReadsigEx : STD_LOGIC := '0';
	SIGNAL PortWritesig : STD_LOGIC := '0';
	SIGNAL PortWritesigEx : STD_LOGIC := '0';
	SIGNAL RDsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RDsigbuf : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RDsigbuf2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RDsigbufend : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RegWritesig : STD_LOGIC := '0';
	SIGNAL RegWritesigEx : STD_LOGIC := '0';
	SIGNAL RegWritesigend : STD_LOGIC := '0';
	SIGNAL Resultsig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSsigbuf : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSval : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSvalbuf : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSvalbuf2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RTsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RTsigbuf : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RTval : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL SETCsig : STD_LOGIC := '0';
	COMPONENT Fetch IS
		PORT (
			Ins : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			JumpAddress : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			MemRead : IN STD_LOGIC;
			CheckedJump : IN STD_LOGIC;
			Address : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
			OpCode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			Imm : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	COMPONENT Memory IS
		PORT (
			clk : IN STD_LOGIC;
			MEMW : IN STD_LOGIC;
			MEMR : IN STD_LOGIC;
			address : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
			datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT Decode IS
		PORT (
			clk : IN STD_LOGIC;
			OpCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RTAdd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RSAdd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RS : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			RDbuf : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RSbuf : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RTAddbuf : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RSAddbuf : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			Op1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
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
	END COMPONENT;
	COMPONENT RegFile IS
		PORT (
			Add1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Add2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			WAdd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			DataIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RegWrite : IN STD_LOGIC;
			Clk : IN STD_LOGIC;
			DataOUT1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DataOUT2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT Execute IS
		PORT (
			clk : IN STD_LOGIC;
			RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RS : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RegWrite : IN STD_LOGIC;
			Mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUEnable : IN STD_LOGIC;
			Immediate : IN STD_LOGIC;
			Jump : IN STD_LOGIC;
			IncSP : IN STD_LOGIC;
			DecSP : IN STD_LOGIC;
			PortWrite : IN STD_LOGIC;
			PortRead : IN STD_LOGIC;
			MemWrite : IN STD_LOGIC;
			MemRead : IN STD_LOGIC;
			SETC : IN STD_LOGIC;
			Checks : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			RDbuf : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RSbuf : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RegWritebuf : OUT STD_LOGIC;
			Immediatebuf : OUT STD_LOGIC;
			Jumpbuf : OUT STD_LOGIC;
			IncSPbuf : OUT STD_LOGIC;
			DecSPbuf : OUT STD_LOGIC;
			PortWritebuf : OUT STD_LOGIC;
			PortReadbuf : OUT STD_LOGIC;
			MEMWbuf : OUT STD_LOGIC;
			MEMRbuf : OUT STD_LOGIC;
			Checksbuf : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Carry : OUT STD_LOGIC;
			Zero : OUT STD_LOGIC;
			Negative : OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT MEMWB IS
		PORT (
			clk : IN STD_LOGIC;
			RegWrite : IN STD_LOGIC;
			PortWrite : IN STD_LOGIC;
			PortRead : IN STD_LOGIC;
			MemRead : IN STD_LOGIC;
			MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			IncSP : IN STD_LOGIC;
			DecSP : IN STD_LOGIC;
			Result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			AddressOut : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
			RegWritebuf : OUT STD_LOGIC;
			RDbuf : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT FWDU IS
		PORT (
			SrcAdd1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			SrcAdd2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			OrgOp1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			OrgOp2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DstALU : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			DstMEM : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RegWALU : IN STD_LOGIC;
			RegWMEM : IN STD_LOGIC;
			Imm : IN STD_LOGIC;
			ALUBuff : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			MemBuff : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
BEGIN
	Addresssig <= Addressbufmem WHEN (MEMWsigEx OR MEMRsigEx) = '1'
		ELSE
		Addressbuffet;
	mem : Memory PORT MAP(clk, MEMWsigEx, MEMRsigEx, Addresssig, RSvalbuf2, MemDataOut);
	fet : Fetch PORT MAP(MemDataOut, Resultsig, clk, rst, MEMRsigEx, JumpsigEx, Addressbuffet, OpCodesig, RDsig, RTsig, RSsig, Immsig);
	reg : RegFile PORT MAP(RTsig, RSsig, RDsigbufend, DataINbuf, RegWritesigend, clk, RTval, RSval);
	dec : Decode PORT MAP(clk, OpCodesig, RDsig, RTsig, RSsig, RTval, RSval, Immsig, RDsigbuf, RSvalbuf, RTsigbuf, RSsigbuf, Op1sig, Op2sig, RegWritesig, Modesig, ALUEnablesig, Immediatesig, Jumpsig, IncSPsig, DecSPsig, PortWritesig, PortReadsig, MEMWsig, MEMRsig, SETCsig, Checksig);
	fwd : FWDU PORT MAP(RTsigbuf, RSsigbuf, Op1sig, Op2sig, RDsigbuf2, RDsigbufend, RegWritesigEx, RegWritesigend, Immediatesig, Resultsig, DataINbuf, Op1sigfwd, Op2sigfwd);
	ex : Execute PORT MAP(clk, RDsigbuf, RSvalbuf, Op1sigfwd, Op2sigfwd, RegWritesig, Modesig, ALUEnablesig, Immediatesig, Jumpsig, IncSPsig, DecSPsig, PortWritesig, PortReadsig, MEMWsig, MEMRsig, SETCsig, Checksig, RDsigbuf2, RSvalbuf2, RegWritesigEx, ImmediatesigEx, JumpsigEx, IncSPsigEx, DecSPsigEx, PortWritesigEx, PortReadsigEx, MEMWsigEx, MEMRsigEx, ChecksigEx, Resultsig, Carry, Zero, Negative);
	memoryWB : MEMWB PORT MAP(clk, RegWritesigEx, PortWritesigEx, PortReadsigEx, MEMRsigEx, MemDataOut, IncSPsigEx, DecSPsigEx, Resultsig, RDsigbuf2, Addressbufmem, RegWritesigend, RDsigbufend, DataINbuf);
END CPUArch;