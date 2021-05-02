library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
  port (clock : in std_logic;
        reset : in std_logic;

        IR                : in  std_logic_vector(7 downto 0);
        IR_load, MAR_load : out std_logic;
        PC_load, PC_inc   : out std_logic;
        A_load, B_load    : out std_logic;

        ALU_sel            : out std_logic_vector(2 downto 0);
        CCR_result         : in  std_logic_vector (3 downto 0);
        CCR_load           : out std_logic;
        bus1_sel, bus2_sel : out std_logic_vector(1 downto 0);

        write : out std_logic);
end entity;

architecture control_unit_arch of control_unit is

  -- Loading/storing
  constant LDA_IMM : std_logic_vector(7 downto 0) := x"86";
  constant LDA_DIR : std_logic_vector(7 downto 0) := x"87";
  constant LDB_IMM : std_logic_vector(7 downto 0) := x"88";
  -- constant LDB_DIR : std_logic_vector(7 downto 0) := x"89";
  constant STA_DIR : std_logic_vector(7 downto 0) := x"96";
  -- constant STB_DIR : std_logic_vector(7 downto 0) := x"97";

  -- Data manipulation
  -- constant ADD_AB : std_logic_vector(7 downto 0) := x"42";
  -- constant SUB_AB : std_logic_vector(7 downto 0) := x"43";
  -- constant AND_AB : std_logic_vector(7 downto 0) := x"44";
  -- constant OR_AB  : std_logic_vector(7 downto 0) := x"45";
  -- constant INCA   : std_logic_vector(7 downto 0) := x"46";
  -- constant INCB   : std_logic_vector(7 downto 0) := x"47";
  -- constant DECA   : std_logic_vector(7 downto 0) := x"48";
  -- constant DECB   : std_logic_vector(7 downto 0) := x"49";

  -- Control flow/branching
  constant BRA : std_logic_vector(7 downto 0) := x"20";
  -- constant BMI : std_logic_vector(7 downto 0) := x"21";
  -- constant BPL : std_logic_vector(7 downto 0) := x"22";
  -- constant BEQ : std_logic_vector(7 downto 0) := x"23";
  -- constant BNE : std_logic_vector(7 downto 0) := x"24";
  -- constant BVS : std_logic_vector(7 downto 0) := x"25";
  -- constant BVC : std_logic_vector(7 downto 0) := x"26";
  -- constant BCS : std_logic_vector(7 downto 0) := x"27";
  -- constant BCC : std_logic_vector(7 downto 0) := x"28";

  type state_type is
    (sFETCH_0, sFETCH_1, sFETCH_2,
     sDECODE_3,
     sLDA_IMM_4, sLDA_IMM_5, sLDA_IMM_6,
     sLDB_IMM_4, sLDB_IMM_5, sLDB_IMM_6,
     sLDA_DIR_4, sLDA_DIR_5, sLDA_DIR_6, sLDA_DIR_7, sLDA_DIR_8,
     sSTA_DIR_4, sSTA_DIR_5, sSTA_DIR_6, sSTA_DIR_7,
     sBRA_4, sBRA_5, sBRA_6);
  -- sADD_AB_4,
  -- sBEQ_4, sBEQ_5, sBEQ_6, sBEQ_7);

  signal current_state, next_state : state_type;

begin

  STATE_MEMORY : process (clock, reset)
  begin
    if (reset = '0') then
      current_state <= sFETCH_0;
    elsif (rising_edge(clock)) then
      current_state <= next_state;
    end if;
  end process;

  NEXT_STATE_LOGIC : process (current_state, IR, CCR_result)
  begin
    case (current_state) is
      when sFETCH_0 => next_state <= sFETCH_1;
      when sFETCH_1 => next_state <= sFETCH_2;
      when sFETCH_2 => next_state <= sDECODE_3;
      when sDECODE_3 =>
        case (IR) is
          when LDA_IMM => next_state <= sLDA_IMM_4;
          when LDB_IMM => next_state <= sLDB_IMM_4;
          when LDA_DIR => next_state <= sLDA_DIR_4;
          when STA_DIR => next_state <= sSTA_DIR_4;
          when BRA     => next_state <= sBRA_4;
          -- when ADD_AB  => next_state <= sADD_AB_4;
          -- when BEQ =>
          -- case (CCR_result(2)) is
          -- when '0'    => next_state <= sBEQ_7;
          -- when '1'    => next_state <= sBEQ_4;
          -- when others => next_state <= sBEQ_7;
          -- end case;
          when others  => next_state <= sFETCH_0;
        end case;

      -- LDA_IMM
      when sLDA_IMM_4 => next_state <= sLDA_IMM_5;
      when sLDA_IMM_5 => next_state <= sLDA_IMM_6;
      when sLDA_IMM_6 => next_state <= sFETCH_0;

      -- LDB_IMM
      when sLDB_IMM_4 => next_state <= sLDB_IMM_5;
      when sLDB_IMM_5 => next_state <= sLDB_IMM_6;
      when sLDB_IMM_6 => next_state <= sFETCH_0;

      -- LDA_DIR
      when sLDA_DIR_4 => next_state <= sLDA_DIR_5;
      when sLDA_DIR_5 => next_state <= sLDA_DIR_6;
      when sLDA_DIR_6 => next_state <= sLDA_DIR_7;
      when sLDA_DIR_7 => next_state <= sLDA_DIR_8;
      when sLDA_DIR_8 => next_state <= sFETCH_0;

      -- STA_DIR
      when sSTA_DIR_4 => next_state <= sSTA_DIR_5;
      when sSTA_DIR_5 => next_state <= sSTA_DIR_6;
      when sSTA_DIR_6 => next_state <= sSTA_DIR_7;
      when sSTA_DIR_7 => next_state <= sFETCH_0;

      -- BRA
      when sBRA_4 => next_state <= sBRA_5;
      when sBRA_5 => next_state <= sBRA_6;
      when sBRA_6 => next_state <= sFETCH_0;

      when others => next_state <= sFETCH_0;
    end case;
  end process;

  -- bus1_sel values (from DP definition):
  -- 00: PC
  -- 01: A
  -- 10: B

  -- bus2_sel values (from DP definition):
  -- 00: ALU_result
  -- 01: bus1
  -- 10: from_memory

  OUTPUT_LOGIC : process (current_state)
  begin
    case(current_state) is
      -- Generic instruction fetch
      when sFETCH_0 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "01";
        write    <= '0';
      when sFETCH_1 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '1';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
      when sFETCH_2 =>
        IR_load  <= '1';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "10";
        write    <= '0';
      when sDECODE_3 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';

      -- LDA_IMM
      when sLDA_IMM_4 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "01";
        write    <= '0';
      when sLDA_IMM_5 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '1';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
      when sLDA_IMM_6 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '1';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "10";
        write    <= '0';

      -- LDB_IMM
      when sLDB_IMM_4 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "01";
        write    <= '0';
      when sLDB_IMM_5 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '1';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
      when sLDB_IMM_6 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '1';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "10";
        write    <= '0';

      -- LDA_DIR
      when sLDA_DIR_4 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "01";
        write    <= '0';
      when sLDA_DIR_5 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '1';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
      when sLDA_DIR_6 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "10";
        write    <= '0';
      when sLDA_DIR_7 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
      when sLDA_DIR_8 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '1';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "10";
        write    <= '0';

      -- STA_DIR
      when sSTA_DIR_4 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "01";
        write    <= '0';
      when sSTA_DIR_5 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '1';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
      when sSTA_DIR_6 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "10";
        write    <= '0';
      when sSTA_DIR_7 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "01";
        Bus2_sel <= "00";
        write    <= '1';

      -- BRA
      when sBRA_4 =>
        IR_load  <= '0';
        MAR_load <= '1';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "01";
        write    <= '0';
      when sBRA_5 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
      when sBRA_6 =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '1';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "10";
        write    <= '0';

      when others =>
        IR_load  <= '0';
        MAR_load <= '0';
        PC_load  <= '0';
        PC_inc   <= '0';
        A_load   <= '0';
        B_load   <= '0';
        ALU_sel  <= "000";
        CCR_load <= '0';
        Bus1_sel <= "00";
        Bus2_sel <= "00";
        write    <= '0';
    end case;
  end process;

end architecture;
