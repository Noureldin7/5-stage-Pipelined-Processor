LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HDU IS
    PORT (
        r_FD_OpCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0); --values from fetch decode buffer
        r_FD_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_FD_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_FD_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_FD_Imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        r_DE_OpCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0); --values from decode execute buffer
        r_DE_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_DE_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_DE_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_DE_Imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        r_DE_MEMR : IN STD_LOGIC;

        w_FD_OpCode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --values to fetch decode buffer
        w_FD_RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_FD_RT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_FD_RS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_FD_Imm : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        w_DE_OpCode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --values to decode execute buffer and CU
        w_DE_RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_DE_RT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_DE_RS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_DE_Imm : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        Imm_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --forwarded val
        Imm_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --forwarded val

        EN : OUT STD_LOGIC; --PC enable
        Swap_Hazard : OUT STD_LOGIC; --A fucking flag
        Load_Use : OUT STD_LOGIC --Another fucking flag
    );
END ENTITY;

ARCHITECTURE HDU_ARCH OF HDU IS
    SIGNAL Load_Use_Signal : STD_LOGIC;
    SIGNAL Swap_Hazard_Signal : STD_LOGIC;
BEGIN

    Load_Use_Signal <= '1' WHEN r_DE_MEMR = '1' AND (r_DE_RD = r_FD_RS OR r_DE_RD = r_FD_RT) ELSE
        '0';
    Swap_Hazard_Signal <= '1' WHEN r_FD_OpCode = "001100" ELSE
        '0';
    Load_Use <= Load_Use_Signal;
    Swap_Hazard <= Swap_Hazard_Signal;

    PROCESS IS
    BEGIN
        IF (Load_Use_Signal = '1') THEN
            EN <= '0';

            w_DE_OpCode <= (OTHERS => '0');
            w_DE_RD <= (OTHERS => '0');
            w_DE_RT <= (OTHERS => '0');
            w_DE_RS <= (OTHERS => '0');
            w_DE_Imm <= (OTHERS => '0');

            w_FD_OpCode <= r_FD_OpCode;
            w_FD_RD <= r_FD_RD;
            w_FD_RT <= r_FD_RT;
            w_FD_RS <= r_FD_RS;
            w_FD_Imm <= r_FD_Imm;

        ELSIF (Swap_Hazard_Signal = '1') THEN
            EN <= '0';

            w_DE_OpCode <= "101100";
            w_DE_RD <= r_FD_RD;
            w_DE_RT <= (OTHERS => 'X');
            w_DE_RS <= (OTHERS => 'X');
            w_DE_Imm <= Imm_1;

            w_FD_OpCode <= "101100";
            w_FD_RD <= r_FD_RS;
            w_FD_RT <= (OTHERS => 'X');
            w_FD_RS <= (OTHERS => 'X');
            w_FD_Imm <= Imm_2;
        END IF;
    END PROCESS;

END ARCHITECTURE;