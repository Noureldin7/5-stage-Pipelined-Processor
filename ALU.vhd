LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ALU IS
	PORT(
		OpA : IN  std_logic_vector(31 DOWNTO 0);
		OpB  : IN  std_logic_vector(31 DOWNTO 0);
		Mode  : IN std_logic_vector(1 downto 0);
		Result : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY ALU;

ARCHITECTURE ALUArch OF ALU IS

	BEGIN
		Result<= std_logic_vector(unsigned(OpA)+unsigned(OpB)) when Mode=("00")
		else std_logic_vector(unsigned(OpA)-unsigned(OpB)) when Mode=("01")
		else OpA when Mode=("10")
		else OpB;
END ALUArch;
