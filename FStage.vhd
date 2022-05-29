LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		intr : IN STD_LOGIC;
		Ins : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		JumpAddress : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Mem : IN STD_LOGIC;
		CheckedJump : IN STD_LOGIC;
		Address : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
		OpCode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		RT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		RS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		Imm : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY Fetch;

ARCHITECTURE FetchArch OF Fetch IS
	SIGNAL opsig : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
	SIGNAL rdsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL rtsig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL rssig : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
<<<<<<< HEAD
	SIGNAL rstsig : STD_LOGIC := '0'; --reset signal 
=======
>>>>>>> 1faad9840e6c83a21aea08c609e68e64f5080591
	SIGNAL immsig : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pcsigout : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pcsigin : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL add4sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'); -- Adds 1 to the PC 
	SIGNAL Enable : STD_LOGIC := '1';
BEGIN
	Enable <= '0' WHEN opsig = ("0000001") AND rst = '0'
		ELSE
		'1' WHEN rst = '1';
	opsig <= Ins(31 DOWNTO 25);
	rdsig <= Ins(24 DOWNTO 22);
	rtsig <= Ins(21 DOWNTO 19);
	rssig <= Ins(18 DOWNTO 16);
	immsig <= Ins(15 DOWNTO 0);
	add4sig <= STD_LOGIC_VECTOR(unsigned(pcsigout) + 1);
	Address <= (OTHERS => '0') WHEN rst = '1'
		ELSE
		pcsigout(19 DOWNTO 0);
	pcsigin <= JumpAddress WHEN CheckedJump = '1'
		ELSE
		Ins WHEN rst = '1' OR intr = '1'
		ELSE
		add4sig;
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) AND intr = '0' THEN
			IF Mem = '1' OR rst = '1' THEN
				OpCode <= (OTHERS => '0');
				RD <= (OTHERS => '0');
				RT <= (OTHERS => '0');
				RS <= (OTHERS => '0');
				Imm <= (OTHERS => '0');
			ELSE
				OpCode <= opsig;
				RD <= rdsig;
				RT <= rtsig;
				RS <= rssig;
				Imm <= immsig;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
<<<<<<< HEAD
		IF falling_edge(clk) AND MemRead /= '1' THEN 
=======
		IF falling_edge(clk) AND Mem /= '1' THEN
>>>>>>> 1faad9840e6c83a21aea08c609e68e64f5080591
			IF Enable = '1' THEN
				pcsigout <= pcsigin;
			END IF;
		END IF;
	END PROCESS;
END FetchArch;