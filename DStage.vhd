LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Decode IS
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
		Imm_Flag : OUT STD_LOGIC
		);
		
END ENTITY Decode;

ARCHITECTURE DecodeArch OF Decode IS
	COMPONENT CU IS
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
	END COMPONENT;
	SIGNAL RegWsig : STD_LOGIC := '0';
	SIGNAL Modesig : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALUEsig : STD_LOGIC := '0';
	SIGNAL Immsig : STD_LOGIC := '0';
	SIGNAL Jmpsig : STD_LOGIC := '0';
	SIGNAL IncSPsig : STD_LOGIC := '0';
	SIGNAL DecSPsig : STD_LOGIC := '0';
	SIGNAL PortWsig : STD_LOGIC := '0';
	SIGNAL PortRsig : STD_LOGIC := '0';
	SIGNAL MemWsig : STD_LOGIC := '0';
	SIGNAL MemRsig : STD_LOGIC := '0';
	SIGNAL SETCsig : STD_LOGIC := '0';
	SIGNAL Chksig : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
BEGIN
	ctrl : CU PORT MAP(OpCode, RegWsig, Modesig, ALUEsig, Immsig, Jmpsig, IncSPsig, DecSPsig, PortWsig, PortRsig, MemWsig, MemRsig, SETCsig, Chksig);
	Imm_Flag <= Immsig;
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			RDbuf <= (OTHERS => '0');
			Op1 <= (OTHERS => '0');
			Op2 <= (OTHERS => '0');
			RSbuf <= (OTHERS => '0');
			RTAddbuf <= (OTHERS => '0');
			RSAddbuf <= (OTHERS => '0');
			RegWrite <= '0';
			Mode <= (OTHERS => '0');
			AluEnable <= '0';
			Immediate <= '0';
			Jump <= '0';
			IncSP <= '0';
			DecSP <= '0';
			PortWrite <= '0';
			PortRead <= '0';
			MEMW <= '0';
			MEMR <= '0';
			SETC <= '0';
			Checks <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND intr = '0' THEN
			RDbuf <= RD;
			Op1 <= RT;
			IF (Immsig = '1') THEN
				Op2 <= EXT(Imm, 32);
			ELSE
				Op2 <= RS;
			END IF;
			RSbuf <= RS;
			RTAddbuf <= RTAdd;
			RSAddbuf <= RSAdd;
			RegWrite <= RegWsig;
			Mode <= Modesig;
			AluEnable <= ALUEsig;
			Immediate <= Immsig;
			Jump <= Jmpsig;
			IncSP <= IncSPsig;
			DecSP <= DecSPsig;
			PortWrite <= PortWsig;
			PortRead <= PortRsig;
			MEMW <= MemWsig;
			MEMR <= MemRsig;
			SETC <= SETCsig;
			Checks <= Chksig;
		END IF;
	END PROCESS;
END DecodeArch;