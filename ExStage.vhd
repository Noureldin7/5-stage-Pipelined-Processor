LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Execute IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		intr : IN STD_LOGIC;
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
		Unbuffered_Jump : INOUT STD_LOGIC
	);
END ENTITY Execute;

ARCHITECTURE ExArch OF Execute IS
	SIGNAL Carrysig, Zerosig, Negativesig : STD_LOGIC := '0';
	SIGNAL ALUC, ALUZ, ALUN : STD_LOGIC := '0';
	SIGNAL Resultsig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	COMPONENT ALU IS
		PORT (
			OpA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			OpB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Enable : IN STD_LOGIC;
			SETC : IN STD_LOGIC;
			Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Carry : OUT STD_LOGIC;
			Zero : OUT STD_LOGIC;
			Negative : OUT STD_LOGIC
		);
	END COMPONENT;
BEGIN
	Unbuffered_Result <= Resultsig;
	ex : ALU PORT MAP(Op1, Op2, Mode, ALUEnable, SETC, Resultsig, ALUC, ALUZ, ALUN);
	Zero <= '0' WHEN Checks = ("00")
		ELSE
		ALUZ;
	Negative <= '0' WHEN Checks = ("01")
		ELSE
		ALUN;
	Carry <= '0' WHEN Checks = ("10")
		ELSE
		ALUC;

	ZeroSig <= ALUZ WHEN ALUEnable = '1' ELSE
		'0' WHEN Jumpbuf = '1' AND Checks = ("00");

	Negativesig <= ALUN WHEN AlUEnable = '1' ELSE
		'0' WHEN Jumpbuf = '1' AND Checks = ("01");

	Carrysig <= ALUC WHEN AlUEnable = '1' AND (Mode = "00" OR Mode = "01") ELSE
		'1' WHEN SETC = '1' ELSE
		'0' WHEN Jumpbuf = '1' AND Checks = ("10");

	PROCESS (Jump, Zerosig, IncSP, DecSP, Carrysig, Negativesig, Checks)
BEGIN
		IF Checks = ("00") THEN
			Unbuffered_Jump <= Jump AND Zerosig AND (IncSP NOR DecSP);
		ELSIF Checks = ("01") THEN
			Unbuffered_Jump <= Jump AND Negativesig AND (IncSP NOR DecSP);
		ELSIF Checks = ("10") THEN
			Unbuffered_Jump <= Jump AND Carrysig AND (IncSP NOR DecSP);
		ELSE
			Unbuffered_Jump <= Jump AND (IncSP NOR DecSP);
		END IF;
	END PROCESS;

	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			RDbuf <= (OTHERS => '0');
			RSbuf <= (OTHERS => '0');
			RegWritebuf <= '0';
			Immediatebuf <= '0';
			IncSPbuf <= '0';
			DecSPbuf <= '0';
			PortWritebuf <= '0';
			PortReadbuf <= '0';
			MEMWbuf <= '0';
			MEMRbuf <= '0';
			Jumpbuf <= '0';
			Jump_Original <= '0';
			Checksbuf <= (OTHERS => '0');
			Result <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND intr = '0' THEN
			Jumpbuf <= Unbuffered_Jump;
			Jump_Original <= Jump;
			RDbuf <= RD;
			RSbuf <= RS;
			RegWritebuf <= RegWrite;
			Immediatebuf <= Immediate;
			IncSPbuf <= IncSP;
			DecSPbuf <= DecSP;
			PortWritebuf <= PortWrite;
			PortReadbuf <= PortRead;
			MEMWbuf <= MemWrite;
			MEMRbuf <= MemRead;
			Checksbuf <= Checks;
			Result <= Resultsig;

		END IF;
	END PROCESS;
END ExArch;