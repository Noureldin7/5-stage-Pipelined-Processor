Library ieee;
use ieee.std_logic_1164.all;
entity Reg IS
Port(d:IN std_logic_vector(31 downto 0);
clk,rst,enable: IN std_logic;
q:OUT std_logic_vector(31 downto 0));
END entity Reg;
Architecture archReg OF Reg IS
BEGIN
Process(clk,rst)
Begin
IF rst='1'then
q<=(others=>'0');
ELSIF rising_edge(clk) and enable='1' then
q<=d;
END IF;
END Process;
END archReg;
