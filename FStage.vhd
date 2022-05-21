LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Fetch IS
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
END ENTITY Fetch;

ARCHITECTURE FetchArch OF Fetch IS
	signal opsig : std_logic_vector(7 downto 0);
	signal rdsig : std_logic_vector(2 downto 0);
	signal rtsig : std_logic_vector(2 downto 0);
	signal rssig : std_logic_vector(2 downto 0);
	signal immsig : std_logic_vector(15 downto 0);
	signal pcsigout : std_logic_vector(19 downto 0);
	signal pcsigin : std_logic_vector(19 downto 0);
	signal add4sig : std_logic_vector(19 downto 0);
	BEGIN
	opsig<=Ins(31 downto 24);
	rdsig<=Ins(23 downto 21);
	rtsig<=Ins(20 downto 18);
	rssig<=Ins(17 downto 15);
	immsig<=Ins(15 downto 0);
	add4sig<=std_logic_vector(unsigned(pcsigout)+1);
	Add<=pcsigout;
	pcsigin<=Oride when sel='1'
	else add4sig;
		Process(clk)
		Begin
			IF rising_edge(clk) then
				IF MemRead='1' then
				OpCode<=(others=>'0');
				RD<=(others=>'0');
				RT<=(others=>'0');
				RS<=(others=>'0');
				Imm<=(others=>'0');
				ELSE
				OpCode<=opsig;
				RD<=rdsig;
				RT<=rtsig;
				RS<=rssig;
				Imm<=immsig;
				END IF;
			END IF;
		END Process;
		Process(clk,rst)
		Begin
			IF rst='1' then
				pcsigout<=(others=>'0');
			ELSIF rising_edge(clk) and MemRead='0' and Enable='1' then
				pcsigout<=pcsigin;
			END IF;
		END Process;
END FetchArch;
