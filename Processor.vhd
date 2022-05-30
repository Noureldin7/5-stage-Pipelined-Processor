LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		intr : IN STD_LOGIC;
		Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
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
	SIGNAL Immsig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ImmsigEx : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL IncSPsig : STD_LOGIC := '0';
	SIGNAL IncSPsigEx : STD_LOGIC := '0';
	SIGNAL Ins : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
	SIGNAL intrsig : STD_LOGIC := '0';
	SIGNAL intrinssig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Jumpsig : STD_LOGIC := '0';
	SIGNAL JumpsigEx : STD_LOGIC := '0';
	SIGNAL MemDataIn : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MemDataOut : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MEMRsig : STD_LOGIC := '0';
	SIGNAL MEMRsigEx : STD_LOGIC := '0';
	SIGNAL Memsig : STD_LOGIC := '0';
	SIGNAL MEMW : STD_LOGIC := '0';
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
	SIGNAL OpCodeD : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL OpCodeE : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL RDsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RDsigbuf : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RDsigbuf2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RDsigbufend : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RegWritesig : STD_LOGIC := '0';
	SIGNAL RegWritesigEx : STD_LOGIC := '0';
	SIGNAL RegWritesigend : STD_LOGIC := '0';
	SIGNAL Resultsig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL rstsig : STD_LOGIC := '0';
	SIGNAL RSsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSsigbuf : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSval : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSvalbuf : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RSvalbuf2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RTsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RTsigbuf : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RTval : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL SETCsig : STD_LOGIC := '0';
	SIGNAL HDU_Ins_Out : STD_LOGIC_VECTOR(47 DOWNTO 0);
	SIGNAL HDU_w_DE_OpCode : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL HDU_w_DE_RD : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL HDU_w_DE_RT : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL HDU_w_DE_RS : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL HDU_w_DE_Imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL HDU_EN : STD_LOGIC;
	SIGNAL HDU_Swap_Hazard : STD_LOGIC;
	SIGNAL HDU_Load_Use : STD_LOGIC;
	SIGNAL HDU_HLT : STD_LOGIC;
	SIGNAL D_IMD : STD_LOGIC;
	SIGNAL ALU_Result : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ex_flush : STD_LOGIC;
	SIGNAL Unbuffered_DataOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Original_Jump_EM : STD_LOGIC;
	SIGNAL RET : STD_LOGIC;
	SIGNAL Fetch_Jump : STD_LOGIC;
	SIGNAL Jump_Address : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Decode_Flush : STD_LOGIC;
	SIGNAL Execute_Flush : STD_LOGIC;
	SIGNAL Unbuffered_Execute_Jump : STD_LOGIC;
	SIGNAL INT : STD_LOGIC;
	SIGNAL IRET : STD_LOGIC;
	SIGNAL FR : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL Zero, Carry, Negative : STD_LOGIC;

	COMPONENT Fetch IS
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			intr : IN STD_LOGIC;
			Ins : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
			JumpAddress : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			PC_Enable : IN STD_LOGIC;
			CheckedJump : IN STD_LOGIC;
			Address : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
			OpCode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			Imm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
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
			rst : IN STD_LOGIC;
			intr : IN STD_LOGIC;
			OpCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RTAdd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RSAdd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RS : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Imm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
			Checks : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			Imm_Flag : OUT STD_LOGIC;
			OpCodeOut : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
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
			rst : IN STD_LOGIC;
			intr : IN STD_LOGIC;
			OpIn : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
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
			FR_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Flag_Override : IN STD_LOGIC;
			Checks : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			RDbuf : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			RSbuf : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RegWritebuf : OUT STD_LOGIC;
			Immediatebuf : OUT STD_LOGIC;
			Jump_Original : OUT STD_LOGIC;
			Jumpbuf : INOUT STD_LOGIC;
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
			Negative : OUT STD_LOGIC;
			Unbuffered_Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Unbuffered_Jump : INOUT STD_LOGIC;
			OpOut : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MEMWB IS
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			intr : IN STD_LOGIC;
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
			DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Unbuffered_DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
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
			MEMR : IN STD_LOGIC;
			ALUBuff : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			MemBuff : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT HDU IS
		PORT (
			PC : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
			r_FD_OpCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0); --values from fetch decode buffer
			r_FD_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			r_FD_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			r_FD_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			r_FD_Imm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	
			r_DE_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --values from decode execute buffer
			r_DE_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			r_DE_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			r_DE_MEMR : IN STD_LOGIC;
			r_DE_IOR : IN STD_LOGIC;
	
			r_EM_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			r_EM_MEMR : IN STD_LOGIC;
			r_EM_MEMW : IN STD_LOGIC;
	
			JMP : IN STD_LOGIC;
			FR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	
			Imm_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --forwarded val
			Imm_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --forwarded val
	
			Ins_In : IN STD_LOGIC_VECTOR(47 DOWNTO 0); -- Ins from mem
			Ins_Out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- Ins to fetch decode buffer
	
			w_DE_OpCode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --values to decode execute buffer and CU
			w_DE_RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			w_DE_RT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			w_DE_RS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			w_DE_Imm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	
			EN : OUT STD_LOGIC; --PC enable
			Swap_Hazard : OUT STD_LOGIC;
			Load_Use : OUT STD_LOGIC;
			HLT : OUT STD_LOGIC
		);
	END COMPONENT;
BEGIN
	PROCESS (rst, clk)
	BEGIN
		IF rising_edge(rst) THEN
			rstsig <= '1';
		ELSIF falling_edge(clk) AND rst = '0' THEN
			rstsig <= '0';
		END IF;
	END PROCESS;
	PROCESS (intr, clk)
	BEGIN
		IF rising_edge(intr) THEN
			intrsig <= '1';
		ELSIF falling_edge(clk) AND intr = '0' THEN
			intrsig <= '0';
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			intrinssig <= MemDataOut;
		END IF;
	END PROCESS;
	Addresssig <= Addressbufmem WHEN (MEMW OR MEMRsigEx) = '1'
		ELSE
		(0 => '1', OTHERS => '0') WHEN intr = '1'
		ELSE
		Addressbuffet;
	MemDataIn <= EXT(Addressbuffet, 32) WHEN intr = '1'
		ELSE
		Unbuffered_DataOut WHEN ImmediatesigEx = '1' AND DecSPsigEx = '1'
		ELSE
		RSvalbuf2;

	MEMW <= '1' WHEN intr = '1' AND clk = '1'
		ELSE
		MEMWsigEx;
	Ins <= intrinssig(31 DOWNTO 16) & "0000000000000000" & intrinssig(15 DOWNTO 0) WHEN intr = '1'
		ELSE
		MemDataOut(31 DOWNTO 16) & "0000000000000000" & MemDataOut(15 DOWNTO 0);

	FR <= Zero & Carry & Negative;

	RET <= '1' when OpCodeE = "0110000" else '0';

	IRET <= '1' when OpCodeE = "0110001" else '0';

	INT <= Original_Jump_EM AND MEMRsigEx;

	Fetch_Jump <= RET OR JumpsigEx or IRET;

	Decode_Flush <= rstsig OR RET OR IRET;

	Jump_Address <= Unbuffered_DataOut WHEN RET = '1' or INT = '1' or IRET = '1' ELSE
		Resultsig;

	hdunit : HDU PORT MAP(
		Addressbuffet, OpCodesig, RDsig, RTsig, RSsig, Immsig, RDsigbuf, RTsigbuf, RSsigbuf, MEMRsig, PortReadsig, RDsigbuf2, MEMRsigEx, MEMWsigEx, Unbuffered_Execute_Jump, FR, Op1sigfwd, Op2sigfwd, Ins,
		HDU_Ins_Out, HDU_w_DE_OpCode, HDU_w_DE_RD, HDU_w_DE_RT, HDU_w_DE_RS, HDU_w_DE_Imm, HDU_EN, HDU_Swap_Hazard, HDU_Load_Use, HDU_HLT);

	mem : Memory PORT MAP(clk, MEMW, MEMRsigEx, Addresssig, MemDataIn, MemDataOut);
	fet : Fetch PORT MAP(clk, rstsig, intr, HDU_Ins_Out, Jump_Address, HDU_EN, Fetch_Jump, Addressbuffet, OpCodesig, RDsig, RTsig, RSsig, Immsig);
	reg : RegFile PORT MAP(RTsig, RSsig, RDsigbufend, DataINbuf, RegWritesigend, clk, RTval, RSval);
	dec : Decode PORT MAP(clk, Decode_Flush, intr, HDU_w_DE_OpCode, HDU_w_DE_RD, HDU_w_DE_RT, HDU_w_DE_RS, Op1sigfwd, Op2sigfwd, HDU_w_DE_Imm, RDsigbuf, RSvalbuf, RTsigbuf, RSsigbuf, Op1sig, Op2sig, RegWritesig, Modesig, ALUEnablesig, Immediatesig, Jumpsig, IncSPsig, DecSPsig, PortWritesig, PortReadsig, MEMWsig, MEMRsig, SETCsig, Checksig, D_IMD, OpCodeD);
	fwd : FWDU PORT MAP(RTsig, RSsig, RTval, RSval, RDsigbuf, RDsigbuf2, RegWritesig, RegWritesigEx, MEMRsigEx, ALU_Result, Unbuffered_DataOut, Op1sigfwd, Op2sigfwd);
	ex : Execute PORT MAP(clk, rstsig, intr, OpCodeD, RDsigbuf, RSvalbuf, Op1sig, Op2sig, RegWritesig, Modesig, ALUEnablesig, Immediatesig, Jumpsig, IncSPsig, DecSPsig, PortWritesig, PortReadsig, MEMWsig, MEMRsig, SETCsig, Unbuffered_DataOut(22 downto 20), IRET, Checksig, RDsigbuf2, RSvalbuf2, RegWritesigEx, ImmediatesigEx, Original_Jump_EM, JumpsigEx, IncSPsigEx, DecSPsigEx, PortWritesigEx, PortReadsigEx, MEMWsigEx, MEMRsigEx, ChecksigEx, Resultsig, Carry, Zero, Negative, ALU_Result, Unbuffered_Execute_Jump, OpCodeE);
	memoryWB : MEMWB PORT MAP(clk, rstsig, intr, RegWritesigEx, PortWritesigEx, PortReadsigEx, MEMRsigEx, MemDataOut, IncSPsigEx, DecSPsigEx, Resultsig, RDsigbuf2, Addressbufmem, RegWritesigend, RDsigbufend, DataINbuf, Unbuffered_DataOut);
END CPUArch;