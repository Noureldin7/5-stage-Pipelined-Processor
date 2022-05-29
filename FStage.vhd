LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch IS
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
END ENTITY Fetch;

ARCHITECTURE FetchArch OF Fetch IS
	SIGNAL opsig : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
	SIGNAL rdsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL rtsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL rssig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL immsig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pcsigout : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pcsigin : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL add4sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Enable : STD_LOGIC := '1';
BEGIN
	Enable <= '1' WHEN rst = '1'
		ELSE PC_Enable;
	opsig <= Ins(47 DOWNTO 41);
	rdsig <= Ins(40 DOWNTO 38);
	rtsig <= Ins(37 DOWNTO 35);
	rssig <= Ins(34 DOWNTO 32);
	immsig <= Ins(31 DOWNTO 0);
	add4sig <= STD_LOGIC_VECTOR(unsigned(pcsigout) + 1);
	Address <= (OTHERS => '0') WHEN rst = '1'
		ELSE
		pcsigout(19 DOWNTO 0);
	pcsigin <= JumpAddress WHEN CheckedJump = '1'
		ELSE
		Ins (47 downto 32) & Ins (15 downto 0) WHEN rst = '1' OR intr = '1'
		ELSE
		add4sig;
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) AND intr = '0' THEN
				OpCode <= opsig;
				RD <= rdsig;
				RT <= rtsig;
				RS <= rssig;
				Imm <= immsig;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF falling_edge(clk) THEN
			IF Enable = '1' or CheckedJump = '1' THEN
				pcsigout <= pcsigin;
			END IF;
		END IF;
	END PROCESS;
END FetchArch;