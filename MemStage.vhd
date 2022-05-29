LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MEMWB IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		intr : IN STD_LOGIC;
		RegWrite : IN STD_LOGIC;
		PortWrite : IN STD_LOGIC;
		PortRead : IN STD_LOGIC;
		MemRead : IN STD_LOGIC;
		MemData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		IncSP : IN STD_LOGIC;
		DecSP : IN STD_LOGIC;
		Result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		AddressOut : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
		RegWritebuf : OUT STD_LOGIC;
		RDbuf : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY MEMWB;

ARCHITECTURE MEMWBArch OF MEMWB IS
	TYPE Ports IS ARRAY (0 TO 0) OF unsigned(31 DOWNTO 0);
	SIGNAL InPort : Ports := (OTHERS => (OTHERS => '0'));
	SIGNAL OutPort : Ports := (OTHERS => (OTHERS => '0'));
	SIGNAL StackPtr : unsigned(31 DOWNTO 0) := (OTHERS => '1');
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			RegWritebuf <= '0';
			RDbuf <= (OTHERS => '0');
			DataOut <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND intr = '0' THEN
			IF DecSP = '1' THEN
				StackPtr <= StackPtr - 1;
			END IF;
			IF MemRead = '1' THEN
				DataOut <= MemData;
			ELSIF PortRead = '1' THEN
				DataOut <= STD_LOGIC_VECTOR(InPort(0));
			ELSE
				DataOut <= Result;
			END IF;
			RegWritebuf <= RegWrite;
			RDbuf <= RD;
		ELSIF falling_edge(clk) THEN
			IF intr = '1' THEN
				StackPtr <= StackPtr - 1;
			ELSE
				IF IncSP = '1' THEN
					StackPtr <= StackPtr + 1;
				END IF;
				IF PortWrite = '1' THEN
					OutPort(0) <= unsigned(Result);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	AddressOut <= STD_LOGIC_VECTOR(StackPtr(19 DOWNTO 0)) WHEN (IncSP OR intr OR DecSP) = '1'
		ELSE
		Result(19 DOWNTO 0);
END MEMWBArch;