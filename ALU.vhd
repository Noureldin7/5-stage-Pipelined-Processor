LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
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
END ENTITY ALU;

ARCHITECTURE ALUArch OF ALU IS
	SIGNAL C, Z, N : STD_LOGIC := '0';
	SIGNAL Temp : unsigned(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
	Temp <= unsigned(OpB) WHEN Enable = '0'
		ELSE
		unsigned(OpA) + unsigned(OpB) WHEN Mode = ("00") AND Enable = '1'
		ELSE
		unsigned(OpA) - unsigned(OpB) WHEN Mode = ("01") AND Enable = '1'
		ELSE
		unsigned(OpA AND OpB) WHEN Mode = ("11") AND Enable = '1'
		ELSE
		unsigned(NOT OpA) WHEN Mode = ("10") AND Enable = '1';
	C <= '1' WHEN (unsigned(OpA) + unsigned(OpB) < unsigned(OpA)) AND Mode = ("00") AND Enable = '1'
		ELSE
		'1' WHEN (unsigned(OpA) > unsigned(OpB)) AND Mode = ("10") AND Enable = '1'
		ELSE
		'1' WHEN SETC = '1'
		ELSE
		C WHEN Mode = ("01") OR Mode = ("11") OR Enable = '0'
		ELSE
		'0';
	N <= STD_LOGIC(Temp(31)) WHEN Enable = '1'
		ELSE
		N;
	Z <= '1' WHEN Temp = 0 AND Enable = '1'
		ELSE
		'0' WHEN Temp > 0 AND Enable = '1'
		ELSE
		Z WHEN Enable = '0';
	Result <= STD_LOGIC_VECTOR(Temp);
	Carry <= C;
	Negative <= N;
	Zero <= Z;
END ALUArch;