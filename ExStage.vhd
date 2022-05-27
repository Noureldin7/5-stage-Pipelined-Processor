LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Execute IS
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
			Negative : OUT STD_LOGIC);
	END COMPONENT;
BEGIN
	ex : ALU PORT MAP(Op1, Op2, Mode, ALUEnable, SETC, Resultsig, ALUC, ALUZ, ALUN);
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			RDbuf <= RD;
			RSbuf <= RS;
			RegWritebuf <= RegWrite;
			Immediatebuf <= Immediate;
			IF Checks = ("00") THEN
				Jumpbuf <= Jump AND Zerosig;
				Zerosig <= '0';
				Negativesig <= ALUN;
				Carrysig <= ALUC;
			ELSIF Checks = ("01") THEN
				Jumpbuf <= Jump AND Negativesig;
				Zerosig <= ALUZ;
				Negativesig <= '0';
				Carrysig <= ALUC;
			ELSIF Checks = ("10") THEN
				Jumpbuf <= Jump AND Carrysig;
				Zerosig <= ALUZ;
				Negativesig <= ALUN;
				Carrysig <= '0';
			ELSE
				Jumpbuf <= Jump;
				Zerosig <= ALUZ;
				Negativesig <= ALUN;
				Carrysig <= ALUC;
			END IF;
			IncSPbuf <= IncSP;
			DecSPbuf <= DecSP;
			PortWritebuf <= PortWrite;
			PortReadbuf <= PortRead;
			MEMWbuf <= MemWrite;
			MEMRbuf <= MemRead;
			Checksbuf <= Checks;
			Result <= Resultsig;
			Carry <= Carrysig;
			Zero <= Zerosig;
			Negative <= Negativesig;
		END IF;
	END PROCESS;
END ExArch;