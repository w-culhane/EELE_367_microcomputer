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

  constant LDA_IMM : std_logic_vector(7 downto 0) := x"AA";
  constant LDA_DIR : std_logic_vector(7 downto 0) := x"80";
  constant STA_DIR : std_logic_vector(7 downto 0) := x"96";
  constant ADD_AB  : std_logic_vector(7 downto 0) := x"42";
  constant BRA     : std_logic_vector(7 downto 0) := x"20";
  constant BEQ     : std_logic_vector(7 downto 0) := x"23";

  type state_type is
    (sFETCH_0, sFETCH_1, sFETCH_2,
     sDECODE_3,
     sLDA_IMM_4, sLDA_IMM_5, sLDA_IMM_6,
     sLDA_DIR_4, sLDA_DIR_5, sLDA_DIR_6, sLDA_DIR_7, sLDA_DIR_8,
     sSTA_DIR_4, sSTA_DIR_5, sSTA_DIR_6, sSTA_DIR_7,
     sADD_AB_4,
     sBRA_4, sBRA_5, sBRA_6,
     sBEQ_4, sBEQ_5, sBEQ_6, sBEQ_7);

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
          when LDA_DIR => next_state <= sLDA_DIR_4;
          when STA_DIR => next_state <= sSTA_DIR_4;
          when ADD_AB  => next_state <= sADD_AB_4;
          when BRA     => next_state <= sBRA_4;
          when BEQ =>
            case (CCR_result(2)) is
              when '0'    => next_state <= sBEQ_7;
              when '1'    => next_state <= sBEQ_4;
              when others => next_state <= sBEQ_7;
            end case;
          when others => next_state <= sFETCH_0;
        end case;
      when others => next_state <= sFETCH_0;  -- TODO Remove this
    end case;
  -- TODO Finish instruction implementations
  -- TODO Add more instructions
  end process;

  OUTPUT_LOGIC : process (current_state)
  begin
    case(current_state) is
      when sFETCH_0 =>
        IR_Load  <= '0';
        MAR_Load <= '1';
        PC_Load  <= '0';
        PC_Inc   <= '0';
        A_Load   <= '0';
        B_Load   <= '0';
        ALU_Sel  <= "000";
        CCR_Load <= '0';
        Bus1_Sel <= "00";
        Bus2_Sel <= "01";
        write    <= '0';
      when sFETCH_1 =>
        IR_Load  <= '0';
        MAR_Load <= '0';
        PC_Load  <= '0';
        PC_Inc   <= '1';
        A_Load   <= '0';
        B_Load   <= '0';
        ALU_Sel  <= "000";
        CCR_Load <= '0';
        Bus1_Sel <= "00";
        Bus2_Sel <= "00";
        write    <= '0';
      when others =>                    -- TODO Remove this
        IR_Load  <= '0';
        MAR_Load <= '1';
        PC_Load  <= '0';
        PC_Inc   <= '0';
        A_Load   <= '0';
        B_Load   <= '0';
        ALU_Sel  <= "000";
        CCR_Load <= '0';
        Bus1_Sel <= "00";
        Bus2_Sel <= "01";
        write    <= '0';
    -- TODO
    end case;
  end process;

end architecture;
