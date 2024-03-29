LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY HDU IS
    PORT (
        PC : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        r_FD_OpCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0); --values from fetch decode buffer
        r_FD_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_FD_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_FD_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_FD_Imm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        r_DE_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --values from decode execute buffer
        r_DE_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_DE_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_DE_MEMR : IN STD_LOGIC;
        r_DE_IOR : IN STD_LOGIC;

        r_EM_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_EM_MEMR : IN STD_LOGIC;
        r_EM_MEMW : IN STD_LOGIC;

        JMP : IN STD_LOGIC;

        Imm_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --forwarded val
        Imm_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --forwarded val

        Ins_In : IN STD_LOGIC_VECTOR(47 DOWNTO 0); -- Ins from mem
        Ins_Out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- Ins to fetch decode buffer

        w_DE_OpCode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --values to decode execute buffer and CU
        w_DE_RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_DE_RT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_DE_RS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        w_DE_Imm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        EN : OUT STD_LOGIC; --PC enable
        Swap_Hazard : OUT STD_LOGIC;
        Load_Use : OUT STD_LOGIC;
        HLT : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE HDU_ARCH OF HDU IS
    SIGNAL Load_Use_Signal : STD_LOGIC;
    SIGNAL Swap_Hazard_Signal : STD_LOGIC;
    SIGNAL HLT_Signal : STD_LOGIC;
    SIGNAL INT_Signal : STD_LOGIC;
    SIGNAL Call_Signal : STD_LOGIC;
BEGIN

    Load_Use_Signal <= '1' WHEN ((r_DE_MEMR = '1' OR r_DE_IOR = '1') AND (r_DE_RD = r_FD_RS OR r_DE_RD = r_FD_RT)) ELSE
        '0';
    Swap_Hazard_Signal <= '1' WHEN r_FD_OpCode = "0001100" ELSE
        '0';
    HLT_Signal <= '1' WHEN Ins_In(47 DOWNTO 41) = "0000001" ELSE
        '0';
    INT_Signal <= '1' WHEN r_FD_OpCode = "1110001" ELSE
        '0';
    Call_Signal <= '1' WHEN r_FD_OpCode = "1010100" ELSE
        '0';

    Load_Use <= Load_Use_Signal;
    Swap_Hazard <= Swap_Hazard_Signal;
    HLT <= HLT_Signal;

    PROCESS (HLT_Signal, r_EM_MEMR, r_EM_MEMW, r_FD_OpCode, r_FD_RD, r_FD_RT, r_FD_RS, r_FD_Imm, Ins_In, Load_Use_Signal, Swap_Hazard_Signal, Imm_1, Imm_2, r_DE_MEMR, JMP, Call_Signal, PC)
    BEGIN
        IF (JMP = '1') THEN
            EN <= '1';
            Ins_Out <= (OTHERS => '0');
            w_DE_OpCode <= (OTHERS => '0');
            w_DE_RD <= (OTHERS => '0');
            w_DE_RT <= (OTHERS => '0');
            w_DE_RS <= (OTHERS => '0');
            w_DE_Imm <= (OTHERS => '0');
        ELSIF (Call_Signal = '1') THEN
            EN <= '1';
            Ins_Out <= "1010011" &
                "000000000" &
                r_FD_Imm;

            w_DE_OpCode <= "1100010";
            w_DE_RD <= (OTHERS => '0');
            w_DE_RT <= (OTHERS => '0');
            w_DE_RS <= (OTHERS => '0');
            w_DE_Imm <= ("000000000000" & PC) - 1;
        ELSIF (HLT_Signal = '1' OR r_EM_MEMR = '1' OR r_EM_MEMW = '1') THEN
            EN <= '0';
            IF (Load_Use_Signal = '1') THEN
                Ins_Out <= r_FD_OpCode & r_FD_RD & r_FD_RT & r_FD_RS & r_FD_Imm;
                w_DE_OpCode <= (OTHERS => '0');
                w_DE_RD <= (OTHERS => '0');
                w_DE_RT <= (OTHERS => '0');
                w_DE_RS <= (OTHERS => '0');
                w_DE_Imm <= (OTHERS => '0');
            ELSIF (Swap_Hazard_Signal = '1') THEN
                Ins_Out <= "1001100" &
                    r_FD_RS &
                    ("000000") &
                    Imm_1;
                w_DE_OpCode <= "1001100";
                w_DE_RD <= r_FD_RT;
                w_DE_RT <= (OTHERS => '0');
                w_DE_RS <= (OTHERS => '0');
                w_DE_Imm <= Imm_2;
            ELSE
                Ins_Out <= (OTHERS => '0');
                w_DE_OpCode <= r_FD_OpCode;
                w_DE_RD <= r_FD_RD;
                w_DE_RT <= r_FD_RT;
                w_DE_RS <= r_FD_RS;
                w_DE_Imm <= r_FD_Imm;
            END IF;
        ELSIF (Load_Use_Signal = '1') THEN
            EN <= '0';

            Ins_Out <= Ins_In;
            w_DE_OpCode <= (OTHERS => '0');
            w_DE_RD <= (OTHERS => '0');
            w_DE_RT <= (OTHERS => '0');
            w_DE_RS <= (OTHERS => '0');
            w_DE_Imm <= (OTHERS => '0');

        ELSIF (Swap_Hazard_Signal = '1') THEN
            EN <= '0';

            Ins_Out <= "1001100" &
                r_FD_RS &
                ("000000") &
                Imm_1;

            w_DE_OpCode <= "1001100";
            w_DE_RD <= r_FD_RT;
            w_DE_RT <= (OTHERS => '0');
            w_DE_RS <= (OTHERS => '0');
            w_DE_Imm <= Imm_2;

        ELSE
            EN <= '1';

            Ins_Out <= Ins_In;

            w_DE_OpCode <= r_FD_OpCode;
            w_DE_RD <= r_FD_RD;
            w_DE_RT <= r_FD_RT;
            w_DE_RS <= r_FD_RS;
            w_DE_Imm <= r_FD_Imm;

        END IF;

    END PROCESS;

END ARCHITECTURE;