LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Execute IS
	PORT(
		clk : IN std_logic;
		Op1 : IN  std_logic_vector(31 DOWNTO 0);
		Op2  : IN  std_logic_vector(31 DOWNTO 0);
		RegWrite : IN  std_logic;
		Mode : IN std_logic_vector(1 downto 0);
		ALUEnable : IN  std_logic;
		Immediate : IN std_logic;
		Jump : IN std_logic;
		IncSP : IN std_logic;
		DecSP : IN std_logic;
		PortWrite : IN std_logic;
		PortRead : IN std_logic;
		MemWrite : IN std_logic;
		MemRead : IN std_logic;
		SETC : IN std_logic;
		CheckC : IN std_logic;
		CheckN : IN std_logic;
		CheckZ : IN std_logic;
		NoCheck : IN std_logic;
		RegWritebuf : OUT  std_logic;
		Immediatebuf : OUT std_logic;
		Jumpbuf : OUT std_logic;
		IncSPbuf : OUT std_logic;
		DecSPbuf : OUT std_logic;
		PortWritebuf : OUT std_logic;
		PortReadbuf : OUT std_logic;
		MEMWbuf : OUT std_logic;
		MEMRbuf : OUT std_logic;
		CheckCbuf : OUT std_logic;
		CheckNbuf : OUT std_logic;
		CheckZbuf : OUT std_logic;
		NoCheckbuf : OUT std_logic;
		Result : OUT std_logic_vector(31 DOWNTO 0);
		Carry : OUT std_logic;
		Zero : OUT std_logic;
		Negative : OUT std_logic);
END ENTITY Execute;

ARCHITECTURE ExArch OF Execute IS
	Signal Carrysig,Zerosig,Negativesig:std_logic;
	Signal Resultsig:std_logic_vector(31 downto 0);
	Component ALU IS
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
	END Component;
	BEGIN
	ex: ALU port map(Op1,Op2,Mode,ALUEnable,SETC,Resultsig,Carrysig,Zerosig,Negativesig);
	Process(clk)
		Begin
			IF rising_edge(clk) then
				RegWritebuf<=RegWrite;
				Immediatebuf<=Immediate;
				Jumpbuf<=Jump;
				IncSPbuf<=IncSP;
				DecSPbuf<=DecSP;
				PortWritebuf<=PortWrite;
				PortReadbuf<=PortRead;
				MEMWbuf<=MemWrite;
				MEMRbuf<=MemRead;
				CheckCbuf<=CheckC;
				CheckNbuf<=CheckN ;
				CheckZbuf<=CheckZ ;
				NoCheckbuf<=NoCheck;
				Result<=Resultsig;
				Carry<=Carrysig;
				Zero<=Zerosig;
				Negative<=Negativesig;
			END IF;
	END Process;	
END ExArch;
