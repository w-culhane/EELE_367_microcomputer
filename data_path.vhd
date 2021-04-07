library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_path is
  port (clock : in std_logic;
        reset : in std_logic;

        IR                 : out std_logic_vector(7 downto 0);
        IR_load, MAR_load  : in  std_logic;
        PC_load, PC_inc    : in  std_logic;
        A_load, B_load     : in  std_logic;
        CCR_load           : in  std_logic;
        CCR_result         : out std_logic_vector(3 downto 0);
        bus1_sel, bus2_sel : in  std_logic_vector(1 downto 0);

        address     : out std_logic_vector(7 downto 0);
        from_memory : in  std_logic_vector(7 downto 0);
        to_memory   : out std_logic_vector(7 downto 0));
end entity;

architecture data_path_arch of data_path is

  component ALU
    port (A, B       : in  std_logic_vector(7 downto 0);
          ALU_sel    : in  std_logic_vector(2 downto 0);
          NZVC       : out std_logic_vector(3 downto 0);
          ALU_result : out std_logic_vector(7 downto 0));
  end component;

  signal bus1, bus2 : std_logic_vector(7 downto 0);

  signal MAR, PC, A, B : std_logic_vector(7 downto 0) := x"00";

  signal PC_uns     : unsigned(7 downto 0);
  signal NZVC       : std_logic_vector(3 downto 0);
  signal ALU_sel    : std_logic_vector(2 downto 0);
  signal ALU_result : std_logic_vector(7 downto 0);

begin

  address   <= MAR;
  to_memory <= bus1;
  PC        <= std_logic_vector(PC_uns);

  BUS1_MUX : process (bus1_sel, PC, A, B)
  begin
    case (bus1_sel) is
      when "00"   => bus1 <= PC;
      when "01"   => bus1 <= A;
      when "10"   => bus1 <= B;
      when others => bus1 <= x"00";
    end case;
  end process;

  BUS2_MUX : process (bus2_sel, ALU_result, bus1, from_memory)
  begin
    case (bus2_sel) is
      when "00"   => bus2 <= ALU_result;
      when "01"   => bus2 <= bus1;
      when "10"   => bus2 <= from_memory;
      when others => bus2 <= x"00";
    end case;
  end process;

  INSTRUCTION_REGISTER : process (clock, reset)
  begin
    if (reset = '0') then
      IR <= x"00";
    elsif (IR_load = '1' and rising_edge(clock)) then
      IR <= bus2;
    end if;
  end process;

  MEMORY_ADDRESS_REGISTER : process (clock, reset)
  begin
    if (reset = '0') then
      MAR <= x"00";
    elsif (MAR_load = '1' and rising_edge(clock)) then
      MAR <= bus2;
    end if;
  end process;

  PROGRAM_COUNTER : process (clock, reset)
  begin
    if (reset = '0') then
      PC_uns <= x"00";
    elsif (rising_edge(clock)) then
      if (PC_load = '1') then
        PC_uns <= unsigned(bus2);
      elsif (PC_inc = '1') then
        PC_uns <= PC_uns + 1;
      end if;
    end if;
  end process;

  A_REGISTER : process (clock, reset)
  begin
    if (reset = '0') then
      A <= x"00";
    elsif (A_load = '1' and rising_edge(clock)) then
      A <= bus2;
    end if;
  end process;

  B_REGISTER : process (clock, reset)
  begin
    if (reset = '0') then
      B <= x"00";
    elsif (B_load = '1' and rising_edge(clock)) then
      B <= bus2;
    end if;
  end process;

  CONDITION_CODE_REGISTER : process (clock, reset)
  begin
    if (reset = '0') then
      CCR_result <= x"0";
    elsif (CCR_load = '1' and rising_edge(clock)) then
      CCR_result <= NZVC;
    end if;
  end process;

  ALU_MAIN : ALU port map (A, B, ALU_sel, NZVC, ALU_result);

end architecture;
