library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
  port (clock : in std_logic;
        reset : in std_logic;

        address  : in  std_logic_vector(7 downto 0);
        write    : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0);

        port_in_00 : in std_logic_vector(7 downto 0);
        port_in_01 : in std_logic_vector(7 downto 0);
        port_in_02 : in std_logic_vector(7 downto 0);
        port_in_03 : in std_logic_vector(7 downto 0);
        port_in_04 : in std_logic_vector(7 downto 0);
        port_in_05 : in std_logic_vector(7 downto 0);
        port_in_06 : in std_logic_vector(7 downto 0);
        port_in_07 : in std_logic_vector(7 downto 0);
        port_in_08 : in std_logic_vector(7 downto 0);
        port_in_09 : in std_logic_vector(7 downto 0);
        port_in_10 : in std_logic_vector(7 downto 0);
        port_in_11 : in std_logic_vector(7 downto 0);
        port_in_12 : in std_logic_vector(7 downto 0);
        port_in_13 : in std_logic_vector(7 downto 0);
        port_in_14 : in std_logic_vector(7 downto 0);
        port_in_15 : in std_logic_vector(7 downto 0);

        port_out_00 : out std_logic_vector(7 downto 0);
        port_out_01 : out std_logic_vector(7 downto 0);
        port_out_02 : out std_logic_vector(7 downto 0);
        port_out_03 : out std_logic_vector(7 downto 0);
        port_out_04 : out std_logic_vector(7 downto 0);
        port_out_05 : out std_logic_vector(7 downto 0);
        port_out_06 : out std_logic_vector(7 downto 0);
        port_out_07 : out std_logic_vector(7 downto 0);
        port_out_08 : out std_logic_vector(7 downto 0);
        port_out_09 : out std_logic_vector(7 downto 0);
        port_out_10 : out std_logic_vector(7 downto 0);
        port_out_11 : out std_logic_vector(7 downto 0);
        port_out_12 : out std_logic_vector(7 downto 0);
        port_out_13 : out std_logic_vector(7 downto 0);
        port_out_14 : out std_logic_vector(7 downto 0);
        port_out_15 : out std_logic_vector(7 downto 0));
end entity;

architecture memory_arch of memory is

  component rom_128x8_sync
    port (clock    : in  std_logic;
          address  : in  std_logic_vector(7 downto 0);
          data_out : out std_logic_vector(7 downto 0));
  end component;

  component rw_96x8_sync
    port (clock    : in  std_logic;
          data_in  : in  std_logic_vector(7 downto 0);
          write    : in  std_logic;
          address  : in  std_logic_vector(4 downto 0);
          data_out : out std_logic_vector(7 downto 0));
  end component;

  signal rom_data_out, rw_data_out : std_logic_vector(7 downto 0);

begin

  ROM : rom_128x8_sync port map (clock, address, rom_data_out);
  RW  : rw_96x8_sync port map (clock, data_in, write, address, rw_data_out);

  MUX : process (address, rom_data_out, rw_data_out,
                 port_in_00, port_in_01, port_in_02, port_in_03,
                 port_in_04, port_in_05, port_in_06, port_in_07,
                 port_in_08, port_in_09, port_in_10, port_in_11,
                 port_in_12, port_in_13, port_in_14, port_in_15)
  begin
    if ((to_integer(unsigned(address)) >= 0)
        and (to_integer(unsigned(address)) <= 127)) then
      data_out <= rom_data_out;
    elsif ((to_integer(unsigned(address)) >= 128)
           and (to_integer(unsigned(address)) <= 223)) then
      data_out <= rw_data_out;
    else
      case (address) is
        when (x"F0") => data_out <= port_in_00;
        when (x"F1") => data_out <= port_in_01;
        when (x"F2") => data_out <= port_in_02;
        when (x"F3") => data_out <= port_in_03;
        when (x"F4") => data_out <= port_in_04;
        when (x"F5") => data_out <= port_in_05;
        when (x"F6") => data_out <= port_in_06;
        when (x"F7") => data_out <= port_in_07;
        when (x"F8") => data_out <= port_in_08;
        when (x"F9") => data_out <= port_in_09;
        when (x"FA") => data_out <= port_in_10;
        when (x"FB") => data_out <= port_in_11;
        when (x"FC") => data_out <= port_in_12;
        when (x"FD") => data_out <= port_in_13;
        when (x"FE") => data_out <= port_in_14;
        when (x"FF") => data_out <= port_in_15;
        when others  => data_out <= x"00";
      end case;
    end if;
  end process;

  POUT0 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_00 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E0" and write = '1') then
        port_out_00 <= data_in;
      end if;
    end if;
  end process;

  POUT1 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_01 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E1" and write = '1') then
        port_out_01 <= data_in;
      end if;
    end if;
  end process;

  POUT2 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_02 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E2" and write = '1') then
        port_out_02 <= data_in;
      end if;
    end if;
  end process;

  POUT3 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_03 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E3" and write = '1') then
        port_out_03 <= data_in;
      end if;
    end if;
  end process;

  POUT4 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_04 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E4" and write = '1') then
        port_out_04 <= data_in;
      end if;
    end if;
  end process;

  POUT5 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_05 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E5" and write = '1') then
        port_out_05 <= data_in;
      end if;
    end if;
  end process;

  POUT6 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_06 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E6" and write = '1') then
        port_out_06 <= data_in;
      end if;
    end if;
  end process;

  POUT7 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_07 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E7" and write = '1') then
        port_out_07 <= data_in;
      end if;
    end if;
  end process;

  POUT8 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_08 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E8" and write = '1') then
        port_out_08 <= data_in;
      end if;
    end if;
  end process;

  POUT9 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_09 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"E9" and write = '1') then
        port_out_09 <= data_in;
      end if;
    end if;
  end process;

  POUT10 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_10 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"EA" and write = '1') then
        port_out_10 <= data_in;
      end if;
    end if;
  end process;

  POUT11 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_11 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"EB" and write = '1') then
        port_out_11 <= data_in;
      end if;
    end if;
  end process;

  POUT12 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_12 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"EC" and write = '1') then
        port_out_12 <= data_in;
      end if;
    end if;
  end process;

  POUT13 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_13 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"ED" and write = '1') then
        port_out_13 <= data_in;
      end if;
    end if;
  end process;

  POUT14 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_14 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"EE" and write = '1') then
        port_out_14 <= data_in;
      end if;
    end if;
  end process;

  POUT15 : process (clock, reset)
  begin
    if (reset = '0') then
      port_out_15 <= x"00";
    elsif (rising_edge(clock)) then
      if (address = x"EF" and write = '1') then
        port_out_15 <= data_in;
      end if;
    end if;
  end process;

end architecture;
