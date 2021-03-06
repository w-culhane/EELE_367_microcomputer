library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_path is
  port (clock : in std_logic;
        reset : in std_logic;

        address     : out std_logic_vector(7 downto 0);
        from_memory : in  std_logic_vector(7 downto 0);
        to_memory   : out std_logic_vector(7 downto 0));
end entity;

architecture data_path_arch of data_path is

  signal bus1, bus2         : std_logic_vector(7 downto 0);
  signal bus1_sel, bus2_sel : std_logic_vector(1 downto 0);

  signal IR, MAR, PC, A, B : std_logic_vector(7 downto 0);

  signal IR_load, MAR_load : std_logic;
  signal PC_load, PC_inc   : std_logic;
  signal PC_uns            : unsigned(7 downto 0);
  signal A_load, B_load    : std_logic;
  signal CCR_load          : std_logic;
  signal NZVC, CCR_result  : std_logic_vector(3 downto 0);
  signal ALU_sel           : std_logic_vector(3 downto 0);
  signal ALU_result        : std_logic_vector(7 downto 0);

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
      A <= Bus2;
    end if;
  end process;

  B_REGISTER : process (clock, reset)
  begin
    if (reset = '0') then
      B <= x"00";
    elsif (B_load = '1' and rising_edge(clock)) then
      B <= Bus2;
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

  ALU_PROCESS : process (A, B, ALU_sel)
    variable Sum_uns : unsigned(8 downto 0);
  begin
    -- Addition
    if (ALU_sel = "000") then
      Sum_uns    := unsigned('0' & A) + unsigned('0' & B);
      ALU_result <= std_logic_vector(Sum_uns(7 downto 0));

      -- Negative flag (N)
      NZVC(3) <= Sum_uns(7);

      -- Zero flag (Z)
      if (Sum_uns(7 downto 0) = x"00") then
        NZVC(2) <= '1';
      else
        NZVC(2) <= '0';
      end if;

      -- Overflow flag (V)
      if ((A(7) = '0' and B(7) = '0' and Sum_uns(7) = '1') or
          (A(7) = '1' and B(7) = '1' and Sum_uns(7) = '0')) then
        NZVC(1) <= '1';
      else
        NZVC(1) <= '0';
      end if;

      -- Carry flag (C)
      NZVC(0) <= Sum_uns(8);
    -- TODO Add more ALU functionality
    -- - SUB
    -- - AND
    -- - OR
    -- - INCA/DECA
    -- - INCB/DECB
    end if;
  end process;

end architecture;
