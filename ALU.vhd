LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ALU IS
	PORT(
		OpA : IN  std_logic_vector(31 DOWNTO 0);
		OpB  : IN  std_logic_vector(31 DOWNTO 0);
		Mode  : IN std_logic_vector(1 downto 0);
		Enable  : IN  std_logic;
		SETC : IN std_logic;
		Result : OUT std_logic_vector(31 DOWNTO 0);
		Carry : OUT std_logic;
		Zero : OUT std_logic;
		Negative : OUT std_logic);
END ENTITY ALU;

ARCHITECTURE ALUArch OF ALU IS
	Signal C,Z,N:std_logic := '0';
	Signal Temp:unsigned(31 downto 0) := (others=>'0');
	BEGIN
		Temp<=unsigned(OpB) when Enable='0'
		else unsigned(OpA)+unsigned(OpB) when Mode=("00")
		else unsigned(OpA)-unsigned(OpB) when Mode=("01")
		else unsigned(OpA AND OpB) when Mode=("11")
		else unsigned(Not OpA);
		C<='1' when (unsigned(OpA)+unsigned(OpB)<unsigned(OpA)) AND Mode=("00")
		else '1' when (unsigned(OpA)>unsigned(OpB)) AND Mode=("10")
		else '1' when SETC='1'
		else C when Mode=("01") OR Mode=("11") OR Enable='0'
		else '0';
		N<=std_logic(Temp(31)) when Enable='1'
		else N;
		Z<='1' when Temp=0
		else '0' when Temp>0
		else Z when Enable='0';
		Result<=std_logic_vector(Temp);
		Carry<=C;
		Negative<=N;
		Zero<=Z;
END ALUArch;
